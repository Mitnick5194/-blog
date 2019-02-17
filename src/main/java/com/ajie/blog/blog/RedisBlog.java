package com.ajie.blog.blog;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.ajie.chilli.cache.redis.RedisClient;
import com.ajie.chilli.cache.redis.RedisException;
import com.ajie.dao.pojo.TbBlog;

/**
 * blog实时性不严格的字段保存到redis
 *
 * @author niezhenjie
 *
 */
public class RedisBlog {

	public Logger logger = LoggerFactory.getLogger(RedisBlogVo.class);
	private RedisBlogVo vo;
	/** redis客户端 */
	private RedisClient redisClient;

	public RedisBlog(RedisClient redisClient, int blogId) {
		this.redisClient = redisClient;
		vo = new RedisBlogVo();
		vo.setId(blogId);
		load();
	}

	private void load() {
		try {
			RedisBlogVo blogVo = redisClient.hgetAsBean(BlogService.REDIS_PREFIX, vo.getId() + "",
					RedisBlogVo.class);
			if (null == blogVo)
				blogVo = new RedisBlogVo();
			vo.setCollectnum(blogVo.getCollectnum());
			vo.setReadnum(blogVo.getReadnum());
			vo.setPraisenum(blogVo.getPraisenum());
			vo.setCommentnum(vo.getCommentnum());
		} catch (RedisException e) {
			logger.warn("从redis缓存中获取RedisBlogVo失败", e);
		}
	}

	/**
	 * 增加step个评论数
	 * 
	 * @param redisClient
	 * @param step
	 *            负数则为减少
	 */
	public void updateCommentNum(int step) {
		vo.setCommentnum(vo.getCommentnum() + step);
		save();
	}

	/**
	 * 增加step个点赞数
	 * 
	 * @param redisClient
	 * @param step
	 *            负数则为减少
	 */
	public void updatePraiseNum(int step) {
		vo.setPraisenum(vo.getPraisenum() + step);
		save();
	}

	/**
	 * 增加step个收藏数
	 * 
	 * @param redisClient
	 * @param step
	 *            负数则为减少
	 */
	public void updateCollectNum(int step) {
		vo.setCollectnum(vo.getCollectnum() + step);
		save();
	}

	/**
	 * 增加step个阅读数
	 * 
	 * @param redisClient
	 * @param step
	 *            负数则为减少
	 */
	public void updateReadNum(int step) {
		vo.setReadnum(vo.getReadnum() + step);
		save();
	}

	private void save() {
		try {
			redisClient.hset(BlogService.REDIS_PREFIX, vo.getId() + "", vo);
		} catch (RedisException e) {
			try {
				// 重试
				redisClient.hset(BlogService.REDIS_PREFIX, vo.getId() + "", vo);
			} catch (RedisException e1) {
				logger.warn("RedisBlogVo保存缓存失败", e1);
			}
		}
	}

	/**
	 * 赋值
	 * 
	 * @param blog
	 * @return
	 */
	public TbBlog assign(TbBlog blog) {
		blog.setCollectnum(vo.getCollectnum());
		blog.setPraisenum(vo.getPraisenum());
		blog.setReadnum(vo.getReadnum());
		blog.setCommentnum(vo.getCommentnum());
		return blog;
	}

}
