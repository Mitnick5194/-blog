package com.ajie.blog.blog;


/**
 * blog保存实时性不严格的字段保存到redis
 *
 * @author niezhenjie
 *
 */
public class RedisBlogVo {
	private int id;
	/** 评论数 */
	private int commentnum;
	/** 点赞数 */
	private int praisenum;
	/** 收藏数 */
	private int collectnum;
	/** 阅读数 */
	private int readnum;

	public int getCommentnum() {
		return commentnum;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getId() {
		return id;
	}

	public void setCommentnum(int commentnum) {
		this.commentnum = commentnum;
	}

	public int getPraisenum() {
		return praisenum;
	}

	public void setPraisenum(int praisenum) {
		this.praisenum = praisenum;
	}

	public int getCollectnum() {
		return collectnum;
	}

	public void setCollectnum(int collectnum) {
		this.collectnum = collectnum;
	}

	public int getReadnum() {
		return readnum;
	}

	public void setReadnum(int readnum) {
		this.readnum = readnum;
	}

}
