package com.ajie.blog.controller.vo;

import com.ajie.blog.controller.utils.BlogUtil;
import com.ajie.chilli.utils.common.StringUtils;
import com.ajie.dao.pojo.TbBlog;

/**
 * 博文vo
 *
 * @author niezhenjie
 *
 */
public class BlogVo {

	private int id;
	private String content;
	/** 首页摘要*/
	private String abstractContent;
	private String title;
	private String userName;
	private int userId;
	private String userHeader;
	private String createDate;
	private int readNum;
	private int commentNum;
	private String labels;

	public BlogVo() {

	}

	public BlogVo(TbBlog blog) {
		this.id = blog.getId();
		this.content = blog.getContent();
		handleAbstractContent(this.content);
		this.title = blog.getTitle();
		this.createDate = BlogUtil.handleDate(blog.getCreatetime());
		this.readNum = blog.getReadnum();
		this.commentNum = blog.getCommentnum();
		this.userId = blog.getUserid();
		this.userHeader = blog.getUserheader();
		if(StringUtils.isEmpty(blog.getUsernickname())){
			this.userName = blog.getUsername();
		}else{
			this.userName = blog.getUsernickname();
		}
		this.labels = blog.getLabelstrs();
	}

	/**
	 * 摘要部分去除图片的显示
	 * 
	 * @param content
	 */
	private void handleAbstractContent(String content) {
		if (content.length() > 150) {
			// 摘要最多显示150个字
			content = content.substring(0, 149);
		}
		StringBuilder sb = new StringBuilder();
		if (content.indexOf("<img") > -1 && content.indexOf("/>") > -1) {
			char[] chars = content.toCharArray();
			boolean append = true;
			for (int i = 0; i < chars.length; i++) {
				// (i + 5) < chars.length是因为防止最后一个是<img/
				if (chars[i] == '<' && (i + 5) < chars.length && chars[i + 1] == 'i'
						&& chars[i + 2] == 'm' && chars[i + 3] == 'g') {
					append = false;
				}
				if (!append) {
					if (chars[i] == '>' && chars[i - 1] == '/') {
						append = true;
						continue;
					}
				}
				if (append) {
					sb.append(chars[i]);
				}
			}
		} else {
			sb.append(content);
		}
		abstractContent = sb.toString();
	}

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getUserId() {
		return userId;
	}

	public void setUserId(int userId) {
		this.userId = userId;
	}

	public String getUserHeader() {
		return userHeader;
	}

	public void setUserHeader(String header) {
		this.userHeader = header;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getAbstractContent() {
		return abstractContent;
	}

	public void setAbstractContent(String abstractContent) {
		this.abstractContent = abstractContent;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getUser() {
		return userName;
	}

	public void setUser(String user) {
		this.userName = user;
	}

	public String getCreateDate() {
		return createDate;
	}

	public void setCreateDate(String createDate) {
		this.createDate = createDate;
	}

	public int getReadNum() {
		return readNum;
	}

	public void setReadNum(int readNum) {
		this.readNum = readNum;
	}

	public int getCommentNum() {
		return commentNum;
	}

	public void setCommentNum(int commentNum) {
		this.commentNum = commentNum;
	}

	public String getLabels() {
		return labels;
	}

	public void setLabels(String labels) {
		this.labels = labels;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}
}
