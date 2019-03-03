package com.ajie.blog.comment.impl;

import java.util.Collections;
import java.util.List;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import com.ajie.blog.blog.BlogService;
import com.ajie.blog.blog.RedisBlog;
import com.ajie.blog.blog.exception.BlogException;
import com.ajie.blog.comment.CommentException;
import com.ajie.blog.comment.CommentService;
import com.ajie.chilli.cache.redis.RedisClient;
import com.ajie.dao.mapper.TbCommentMapper;
import com.ajie.dao.pojo.TbBlog;
import com.ajie.dao.pojo.TbComment;
import com.ajie.dao.pojo.TbCommentExample;
import com.ajie.dao.pojo.TbCommentExample.Criteria;
import com.ajie.dao.pojo.TbUser;
import com.ajie.sso.role.RoleUtils;

/**
 * 评论服务接口实现
 *
 * @author niezhenjie
 *
 */
@Service
public class CommentServiceImpl implements CommentService {

	@Resource
	private TbCommentMapper mapper;
	@Resource
	private BlogService blogService;
	@Resource
	private RedisClient redisClient;

	@Override
	public TbComment createComment(String content, int blogId, int userId) throws CommentException {
		if (null == content || blogId == 0 || userId == 0)
			throw new CommentException("评论失败，参数异常");
		TbComment comment = new TbComment(content, blogId, userId);
		int ret = mapper.insert(comment);
		if (ret != 1)
			throw new CommentException("评论失败");
		// 更新评论数
		RedisBlog redisBlog = new RedisBlog(redisClient, blogId);
		redisBlog.updateCommentNum(1);
		return comment;
	}

	@Override
	public void deleteComment(TbComment comment, TbUser operator) throws CommentException {
		if (null == comment || comment.getId() == 0)
			throw new CommentException("删除失败，评论不存在");
		if (null == operator || operator.getId() == 0)
			throw new CommentException("删除失败，不能删除非自己的评论");
		// 防止评论id被篡改但用户id没有改，而出现删除别的评论的情况
		comment = mapper.selectByPrimaryKey(comment.getId());
		if (comment.getUserid() != operator.getId() && !RoleUtils.isAdmin(operator))
			throw new CommentException("删除失败，不能删除非自己的评论");
		comment.setMark(MARK_STATE_DELETE);
		mapper.updateByPrimaryKey(comment);
	}

	@Override
	public void deleteAllComment(TbBlog blog, TbUser operator) throws CommentException {
		if (null == blog || blog.getId() == 0)
			throw new CommentException("删除失败，博客不存在");
		if (null == operator || operator.getId() == 0)
			throw new CommentException("删除失败，不能删除非自己的评论");
		try {
			blog = blogService.getBlogById(blog.getId(), operator);
		} catch (BlogException e) {
			throw new CommentException("删除失败，博客不存在");
		}
		if (null == blog)
			throw new CommentException("删除失败，博客不存在");
		TbCommentExample ex = new TbCommentExample();
		Criteria criteria = ex.createCriteria();
		criteria.andBlogidEqualTo(blog.getId());
		List<TbComment> comments = mapper.selectByExample(ex);
		if (null == comments || comments.isEmpty())
			return;
		for (TbComment comment : comments) {
			comment.setMark(MARK_STATE_DELETE);
			mapper.updateByPrimaryKey(comment);
		}

	}

	@Override
	public List<TbComment> getComments(TbBlog blog) {
		if (null == blog || blog.getId() == 0)
			return Collections.emptyList();
		TbCommentExample ex = new TbCommentExample();
		Criteria criteria = ex.createCriteria();
		criteria.andBlogidEqualTo(blog.getId());
		List<TbComment> comments = mapper.selectByExample(ex);
		if (null == comments)
			return Collections.emptyList();
		Collections.sort(comments,CREATE_DATE);
		return comments;
	}

	@Override
	public List<TbComment> getComments(int blogId) {
		TbCommentExample ex = new TbCommentExample();
		Criteria criteria = ex.createCriteria();
		criteria.andBlogidEqualTo(blogId);
		List<TbComment> comments = mapper.selectByExample(ex);
		if (null == comments)
			return Collections.emptyList();
		Collections.sort(comments,CREATE_DATE);
		return comments;
	}

	@Override
	public int getBlogCommentCount(int blogId) {
		int commentCount = mapper.getBlogCommentCount(blogId);
		return commentCount;
	}
}
