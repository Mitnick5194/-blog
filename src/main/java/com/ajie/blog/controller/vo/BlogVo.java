package com.ajie.blog.controller.vo;

import com.ajie.blog.controller.utils.BlogUtil;
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
		this.title = blog.getTitle();
		this.createDate = BlogUtil.handleDate(blog.getCreatetime());
		this.readNum = blog.getReadnum();
		this.commentNum = 0;
		this.userId = blog.getUserid();
		this.labels = blog.getLabelstrs();
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

}
