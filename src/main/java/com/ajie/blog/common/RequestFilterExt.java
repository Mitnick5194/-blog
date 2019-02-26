package com.ajie.blog.common;

import java.io.File;
import java.io.IOException;
import java.io.RandomAccessFile;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ajie.chilli.remote.RemoteCmd;
import com.ajie.chilli.remote.exception.RemoteException;
import com.ajie.chilli.support.TimingTask;
import com.ajie.chilli.support.Worker;
import com.ajie.chilli.utils.TimeUtil;
import com.ajie.web.RequestFilter;

/**
 * 对拦截器进行扩展，记录访问者并定时保存
 *
 * @author niezhenjie
 *
 */
public class RequestFilterExt extends RequestFilter implements Worker {
	private static final Logger logger = LoggerFactory.getLogger(RequestFilterExt.class);
	/** 命令类型--执行备份 */
	private static final int TYPE_BACKUP = 1;
	/** 命令类型 -- 执行回滚 */
	private static final int TYPE_ROLLBACK = 2;
	public static final String[] TABLE_HEADER = { "key\t", "count\t", "ip\t", "date\t", "address\n" };
	/** 访问记录 key是ip去除. */
	private Map<String, Access> accessRecord;
	/** 制表符ASCII码 \t */
	public static final byte HT = 9;
	/** 换行符ASCII码 \n */
	public static final byte LR = 10;
	/** 归位符ASCII码 \r */
	public static final byte CR = 13;

	/** 远程命令服务 */
	private RemoteCmd cmd;
	/** 访问记录的文件路径 */
	private String path;

	public RequestFilterExt() {
		accessRecord = new HashMap<String, Access>();
		String ymd = TimeUtil.formatYMD(new Date());
		TimingTask.createTimingTask("access-info-save", this, TimeUtil.parse(ymd + " 00:10"),
				2 * 60 * 1000);// 每小时
	}

	public void setRemoteCmd(RemoteCmd cmd) {
		this.cmd = cmd;
	}

	public RemoteCmd getRemoteCmd() {
		return cmd;
	}

	public void setPath(String path) {
		this.path = path;
	}

	public String getPath() {
		return path;
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		HttpServletRequest req = (HttpServletRequest) request;
		enterRecord(req);
		super.doFilter(request, response, chain);
	};

	/**
	 * 定时对内存中的访问值写入文件中，写入完成需要将内存置空，每次写入时，要吧内存的记录load进来，然后作对比，如果已经存在记录，
	 * 则值要更新内存中的值的访问量，然后将这条记录写入内存
	 */
	@Override
	public void work() throws RemoteException {
		if (accessRecord.isEmpty())
			return;
		String path = this.path;
		if (null == path) {
			// 如果没有，则在classpath中找，但是这样很危险，每次部署都会被覆盖
			URL url = Thread.currentThread().getContextClassLoader()
					.getResource("access-record.txt");
			path = url.getPath();
		}

		// 备份
		backup(path, TYPE_BACKUP);
		FileChannel channel = null;
		RandomAccessFile raf = null;
		try {
			File file = new File(path);
			raf = new RandomAccessFile(file, "rw");
			Map<String, Access> map = loadFile(raf);
			raf.seek(0);
			merge(map);
			// 将合并的记录写入文件
			channel = raf.getChannel();
			ByteBuffer buffer = ByteBuffer.allocate(512);
			writeHeader(channel, buffer);
			Iterator<Entry<String, Access>> it = map.entrySet().iterator();
			while (it.hasNext()) {
				buffer.clear();
				Entry<String, Access> next = it.next();
				Access access = next.getValue();
				buffer.put(access.getKey().getBytes());
				buffer.put(HT);
				buffer.put(String.valueOf(access.getCount()).getBytes());
				buffer.put(HT);
				buffer.put(access.getIp().getBytes());
				buffer.put(HT);
				Date date = access.getDate();
				if (null == date) {
					date = new Date();
				}
				buffer.put(TimeUtil.formatDate(date).getBytes());
				buffer.put(HT);
				String address = access.getAddress();
				if (null == address) {
					address = "";
				}
				buffer.put(address.getBytes());
				buffer.put(CR);
				buffer.put(LR);
				buffer.flip();
				channel.write(buffer);
			}
			clearRecord();
			logger.info("访问记录已同步至文件，时间：" + new Date());
		} catch (Exception e) {
			logger.error("访问记录写入文件失败", e);
			logger.info("正在执行回滚操作");
			backup(path, TYPE_ROLLBACK);// 回滚
		} finally {
			try {
				channel.close();
				raf.close();
			} catch (IOException e) {
			}

		}

	}

	/**
	 * 表头
	 * 
	 * @param channel
	 * @param buffer
	 */
	private void writeHeader(FileChannel channel, ByteBuffer buffer) {
		if (null == channel || null == buffer)
			return;
		for (int i = 0; i < TABLE_HEADER.length; i++) {
			buffer.clear();
			String item = TABLE_HEADER[i];
			buffer.put(item.getBytes());
			if (i == TABLE_HEADER.length - 1) {
				buffer.put(CR);
				buffer.put(LR);
			} else {
				buffer.put(HT);
			}
			buffer.flip();
			try {
				channel.write(buffer);
			} catch (IOException e) {
				logger.error("", e);
			}

		}
	}

	/**
	 * 使用远程命令对访问记录文件进行备份，如果异常，使用备份文件回滚
	 * 
	 * @param url
	 * @throws RemoteException
	 */
	private void backup(String path, int type) throws RemoteException {
		path = "/var/www/temp/access-record.txt";
		if (null == cmd) {
			return;
		}
		if (type == TYPE_BACKUP) {
			String comand = "mv " + path + " " + path + ".bak";
			cmd.cmd(comand);
		} else if (type == TYPE_ROLLBACK) {
			String comand = "rm " + path + ".bak";
			cmd.cmd(comand);
		} else {
			throw new RemoteException("不支持的操做类型,path:" + path + " type" + type);
		}
	}

	/**
	 * 将内存的访问记录清除
	 */
	private void clearRecord() {
		if (accessRecord.isEmpty())
			return;
		accessRecord.clear();
	}

	/**
	 * 将内存中的值合并到map，如果map已经存在该值，则更新状态，如果没有，则添加
	 * 
	 * @param map
	 */
	private void merge(Map<String, Access> map) {
		if (null == map) {
			map = new HashMap<String, Access>();
		}
		Iterator<Entry<String, Access>> iterator = accessRecord.entrySet().iterator();
		while (iterator.hasNext()) {
			Entry<String, Access> next = iterator.next();
			String key = next.getKey();
			Access access = map.get(key);
			if (null == access) {
				// 没有，添加
				map.put(key, accessRecord.get(key));
			} else {
				// 已经存在了，将内存中的记录的访问值加上文件中的访问值
				access.setCount(access.getCount() + map.get(key).getCount());
				map.put(access.getKey(), access); // 修改完记录后覆盖掉记录里的值
			}
		}
	}

	private void enterRecord(HttpServletRequest request) {
		String uri = request.getRequestURI();
		// 只记录访问首页
		if (uri.indexOf("/blog/index.do") == -1) {
			return;
		}
		String ip = request.getHeader("X-Real-IP");
		if (null == ip)
			return;
		String key = ip.replaceAll("\\.", "");// 去除“.”
		Access access = accessRecord.get(key);
		if (null == access) {
			Access acc = new Access(key, 1, ip);
			accessRecord.put(key, acc);
			acc.setDate(new Date());
			acc.setAddress("");
			return;
		}
		access.setCount(access.getCount() + 1);
	}

	/**
	 * 将内存中的数据读入
	 * 
	 * @param file
	 * @return
	 */
	private Map<String, Access> loadFile(RandomAccessFile file) {
		if (null == file)
			return null;
		Map<String, Access> map = new HashMap<String, Access>();
		try {
			String line = file.readLine();// 先把第一行表头读掉
			// 分析每一行
			while (null != (line = file.readLine())) {
				if ("".equals(line))
					continue;
				byte[] bytes = line.getBytes();
				int cursor = 0;
				int preIdx = 0;
				String[] split = new String[5];
				for (int i = 0; i < bytes.length; i++) {
					if (bytes[i] == HT) {
						String str = new String(
								new String(bytes, preIdx, i - preIdx, "ISO-8859-1").getBytes(),
								"utf-8");
						split[cursor++] = str.trim();
						preIdx = i;
					}

				}
				Access access = new Access(split[0], Integer.valueOf(split[1]), split[2]);
				String dstr = split[3];
				try {
					access.setDate(TimeUtil.parse(dstr));
				} catch (Exception e) {// 这里不需要太严谨
					access.setDate(new Date());
				}
				map.put(access.getKey(), access);
			}
		} catch (Exception e) {
			logger.error("无法将访问记录文件读入", e);
			return null;
		}
		return map;
	}

	static class Access {
		// Map保存到key，ip去除.
		private String key;
		private String ip;
		private int count;
		private Date date;
		private String address;

		public Access(String key, int count, String ip) {
			this.key = key;
			this.ip = ip;
			this.count = count;
		}

		public String getKey() {
			return key;
		}

		public void setKey(String key) {
			this.key = key;
		}

		public String getIp() {
			return ip;
		}

		public void setIp(String ip) {
			this.ip = ip;
		}

		public int getCount() {
			return count;
		}

		public void setCount(int count) {
			this.count = count;
		}

		public Date getDate() {
			return date;
		}

		public void setDate(Date date) {
			this.date = date;
		}

		public String getAddress() {
			return address;
		}

		public void setAddress(String address) {
			this.address = address;
		}

	}
}
