package com.ajie.blog.blog;

import com.ajie.dao.pojo.TbBlog;

/**
 * 博客监听者
 * 
 * @author niezhenjie
 *
 */
public interface BlogListener {

	/**
	 * 创建博客
	 * 
	 * @param blog
	 */
	void onCreate(TbBlog blog);

	/**
	 * 删除博客
	 * 
	 * @param blog
	 */
	void onDelete(TbBlog blog);

	/**
	 * 更新博客
	 * 
	 * @param blog
	 */
	void onUpdate(TbBlog blog);
}
