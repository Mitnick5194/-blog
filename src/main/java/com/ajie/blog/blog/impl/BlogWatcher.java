package com.ajie.blog.blog.impl;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ajie.blog.blog.BlogListener;
import com.ajie.blog.blog.BlogListeners;
import com.ajie.blog.blog.BlogService;
import com.ajie.dao.pojo.TbBlog;

/**
 * 博客监听器
 * 
 * @author ajie
 *
 */
public class BlogWatcher implements BlogListener {

	private static final Logger logger = LoggerFactory
			.getLogger(BlogWatcher.class);

	private BlogService blogService;

	public void setBlogService(BlogService service) {
		blogService = service;
		if (null == blogService) {
			return;
		}
		((BlogListeners) blogService).register(this);
	}

	@Override
	public void onCreate(TbBlog blog) {
		logger.info("监听到新增博客");
	}

	@Override
	public void onDelete(TbBlog blog) {
		logger.info("监听到删除博客");
	}

	@Override
	public void onUpdate(TbBlog blog) {
		logger.info("监听到更新博客");
	}

}
