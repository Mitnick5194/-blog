package com.ajie.blog.controller;

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.converter.json.MappingJacksonValue;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import com.ajie.blog.blog.BlogService;
import com.ajie.blog.blog.RedisBlog;
import com.ajie.blog.blog.exception.BlogException;
import com.ajie.blog.comment.CommentService;
import com.ajie.blog.controller.vo.BlogVo;
import com.ajie.blog.label.LabelService;
import com.ajie.blog.label.vo.LabelVo;
import com.ajie.chilli.cache.redis.RedisClient;
import com.ajie.chilli.collection.utils.TransList;
import com.ajie.chilli.common.ResponseResult;
import com.ajie.chilli.picture.Picture;
import com.ajie.chilli.picture.PictureException;
import com.ajie.chilli.picture.PictureService;
import com.ajie.chilli.utils.TimeUtil;
import com.ajie.chilli.utils.Toolkits;
import com.ajie.dao.mapper.TbBlogMapper;
import com.ajie.dao.pojo.TbBlog;
import com.ajie.dao.pojo.TbUser;
import com.ajie.sso.user.UserService;

/**
 * 博客控制器
 *
 * @author niezhenjie
 *
 */
@Controller
public class BlogController {
	public Logger logger = LoggerFactory.getLogger(BlogController.class);
	private static String prefix = "blog/";
	@Resource
	private BlogService blogService;
	@Resource
	private CommentService commentService;
	@Resource
	private LabelService labelService;
	@Resource
	private UserService userService;
	@Resource
	private PictureService pictureService;
	@Resource
	private RedisClient redisClient;

	@Resource
	private TbBlogMapper mapper;

	/**
	 * 首页路径
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/index.do")
	public String index(HttpServletRequest request, HttpServletResponse response) {
		TbUser user = userService.getUser(request);
		if (null != user) {
			request.setAttribute("username", user.getName());
			request.setAttribute("userheader", user.getHeader());
			request.setAttribute("userid", user.getId());
		}
		return prefix + "index";
	}

	/**
	 * 博客详情
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/blog.do")
	public String blog(HttpServletRequest request, HttpServletResponse response) {
		int id = Toolkits.toInt(request.getParameter("id"), 0);
		// 更新博客的浏览数
		RedisBlog vo = new RedisBlog(redisClient, id);
		vo.updateReadNum(1);
		request.setAttribute("id", id);
		return prefix + "blog";
	}

	/**
	 * 添加或编辑博客页面
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@RequestMapping("/addblog.do")
	public String addblog(HttpServletRequest request, HttpServletResponse response) {
		String id = request.getParameter("id");
		request.setAttribute("id", id);
		return prefix + "addblog";
	}

	@RequestMapping("/moretags.do")
	public String moretags(HttpServletRequest request, HttpServletResponse response) {
		logger.info(1 / 0 + "");
		return prefix + "moretags";
	}

	/**
	 * 加载首页数据
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/loadblogs")
	public ResponseResult loadblogs(HttpServletRequest request, HttpServletResponse response) {
		List<TbBlog> blogs = blogService.getBlogs(null, 0, null);
		List<BlogVo> trans = new TransList<BlogVo, TbBlog>(blogs) {
			@Override
			public BlogVo trans(TbBlog v) {
				return new BlogVo(v);
			}
		};
		return ResponseResult.newResult(ResponseResult.CODE_SUC, trans);
	}

	/**
	 * 加载所有标签
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/loadtags")
	public ResponseResult loadtags(HttpServletRequest request, HttpServletResponse response) {
		List<LabelVo> labels = labelService.getLabels();
		return ResponseResult.newResult(ResponseResult.CODE_SUC, labels);
	}

	/**
	 * 通过id拿到博客
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@ResponseBody
	@RequestMapping("/getblogbyid")
	public ResponseResult getblogbyid(HttpServletRequest request, HttpServletResponse response) {
		int id = Toolkits.toInt(request.getParameter("id"), 0);
		TbUser operator = userService.getUser(request);
		try {
			TbBlog blog = blogService.getBlogById(id, operator);
			if (null == blog) {
				return ResponseResult.newResult(ResponseResult.CODE_ERR, "文章不存在");
			}
			BlogVo vo = new BlogVo(blog);
			return ResponseResult.newResult(ResponseResult.CODE_SUC, vo);
		} catch (BlogException e) {
			return ResponseResult.newResult(ResponseResult.CODE_ERR, e.getMessage());
		}
	}

	/**
	 * 添加一条博客
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	@ResponseBody
	@RequestMapping("/createblog")
	public ResponseResult createblog(HttpServletRequest request, HttpServletResponse response)
			throws UnsupportedEncodingException {
		request.setCharacterEncoding("utf-8");
		setAjaxContentType(response);
		TbUser operator = userService.getUser(request);
		if (null == operator) {
			return ResponseResult.newResult(ResponseResult.CODE_SESSION_INVALID, "会话过期，请重新登录");
		}
		String title = request.getParameter("title");
		String content = request.getParameter("content");
		String labelstrs = request.getParameter("labels");
		TbBlog blog = new TbBlog(title, content);
		blog.setLabelstrs(labelstrs);
		blog.setUserid(operator.getId());
		blog.setUserheader(operator.getHeader());
		blog.setUsername(operator.getName());
		blog.setUsernickname(operator.getNickname());
		try {
			blogService.createBlog(blog);
		} catch (BlogException e) {
			logger.warn("", e);
			return ResponseResult.newResult(ResponseResult.CODE_SUC, "无法添加博客");
		}
		List<String> list = Arrays.asList(labelstrs.split(LabelService.BLOG_IDS_SEPARATOR));
		try {
			labelService.openLabels(blog, list);
		} catch (BlogException e) {
			logger.warn("", e);
			return ResponseResult.newResult(ResponseResult.CODE_ERR, "微博发布成功，标签添加失败");
		}
		return ResponseResult.newResult(ResponseResult.CODE_SUC, "发布成功");
	}

	/**
	 * 获取用户的博客
	 * 
	 * @param request
	 * @param response
	 * @return
	 */
	@SuppressWarnings("deprecation")
	@ResponseBody
	@RequestMapping("/getblogbyuser")
	public Object getblogbyuser(HttpServletRequest request, HttpServletResponse response) {
		int userId = Toolkits.toInt(request.getParameter("userId"), 0);
		String callback = request.getParameter("callback");
		TbUser user = new TbUser();
		user.setId(userId);
		List<TbBlog> blogs = blogService.getMyBlogs(user);
		ResponseResult result = ResponseResult.newResult(ResponseResult.CODE_SUC, blogs);
		if (null == callback) {
			return result;
		}
		MappingJacksonValue jsonp = new MappingJacksonValue(result);
		jsonp.setJsonpFunction(callback);
		return jsonp;
	}

	@ResponseBody
	@RequestMapping("deleteblog")
	public ResponseResult deleteblog(HttpServletRequest request, HttpServletResponse response) {
		TbUser operator = userService.getUser(request);
		int id = Toolkits.toInt(request.getParameter("id"), 0);
		TbBlog blog = new TbBlog();
		blog.setId(id);
		try {
			blogService.deleteBlog(blog, operator);
			return ResponseResult.newResult(ResponseResult.CODE_SUC, "删除成功");
		} catch (BlogException e) {
			logger.warn("删除博文失败", e);
			return ResponseResult.newResult(ResponseResult.CODE_ERR, e.getMessage());
		}
	}

	/**
	 * 富文本的图片上传
	 * 
	 * @param request
	 * @param response
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/imgupload.do")
	public void imgupload(@RequestParam("upload") CommonsMultipartFile file,
			HttpServletRequest request, HttpServletResponse response) throws IOException {
		// 如果设置了头是json响应 则返回的结果的标签会被转义，坑爹啊，调了我这么久
		// setAjaxContentType(response);
		PrintWriter out = response.getWriter();
		String cKEditorFuncNum = request.getParameter("CKEditorFuncNum");
		InputStream stream = file.getInputStream();
		// 文件夹，按日期创建
		String folder = TimeUtil.compactYMD(new Date());
		try {
			Picture p = pictureService.create(folder, stream);
			out.println(editorcallback(cKEditorFuncNum, p.getAddress()));
			out.flush();
		} catch (PictureException e) {
			logger.error("图片上传失败", e);
			out.println(editorcallback(cKEditorFuncNum, e.getMessage()));
			out.flush();
		}
		/*out.println("<script type='text/javascript'>");
		out.println("window.parent.CKEDITOR.tools.callFunction(" + CKEditorFuncNum
				+ ",'http://www.ajie18.top/images/view.jpg','')");
		out.println("</script>");*/
		out.close();
	}

	/**
	 * 富文本编辑器 回调
	 * 
	 * @param msg
	 * @return
	 */
	private String editorcallback(String cKEditorFuncNum, String msg) {
		StringBuilder sb = new StringBuilder();
		sb.append("<script type='text/javascript'>");
		sb.append("window.parent.CKEDITOR.tools.callFunction(");
		sb.append(cKEditorFuncNum);
		sb.append(",");
		sb.append("'");
		sb.append(msg);
		sb.append("'");
		sb.append(",'')");
		sb.append("</script>");
		return sb.toString();
	}

	private void setAjaxContentType(HttpServletResponse response) {
		response.setContentType("application/json;charset=UTF-8");
		response.setCharacterEncoding("utf-8");
	}

}
