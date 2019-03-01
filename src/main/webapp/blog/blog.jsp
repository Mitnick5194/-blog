<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width , initial-scale=1">
<title>博客详情</title>
<link href="${ pageContext.request.contextPath }/${serviceId }/css/common.css" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/${serviceId }/common/common.css" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/${serviceId }/blog/css/blog.css" rel="stylesheet" type="text/css">

<style type="text/css">
</style>
</head>
<body>
	<div class="main">
		<div class="header-navi">
			<div onclick="javascript:location.href='addblog.do'" class="addblog">写博客</div>
				<div class="user-header">
					<c:choose>
						<c:when test="${not empty userid }">
							<img onclick="navigatorTo(this)" data-id="${userid }" data-type="userinfo" data-uri="sso/userinfo.do" src="${userheader }" />
						</c:when>
						<c:otherwise>
							<div class="login-btn" onclick="navigatorTo(this)" data-type="login" data-uri="sso/login.do">登录/注册</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
			<div class="container">
				<div class="container-content">
					<div class="center-main" id="iBlogs">
						<section class="title"></section>
						<section class="user-list">
							<span></span>
							<span></span>
							<span></span>
						</section>
						<section class="content"></section>
					</div>
					<div class="right-info">
						<span class="hits">关注公众号和小程序，获取最新动态</span>
						<div class="wxgz-qrcode">
							<img alt="找不到图片" src="/blog/images/my_wxgz_qrcode.jpg">
						</div>
						<div class="wxgz-qrcode">
							<img alt="找不到图片" src="/blog/images/my_wxapp_code.jpg">
						</div>
					</div>
				</div>
				<div class="commen">
					这是评论
				</div>
			</div>
	</div>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/common/common.js"></script>
	<script type="text/temp" id="iBlogTemp">
	</script>
	<script>
		var tagBtn = $("#slideOutTag");
		var containner = $("#iContainner");
		tagBtn.on("click" , function(){
			containner.toggleClass("active");
		})
		var id = '${id}';
		
	</script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/blog/js/blog.js"></script>
	
	
</body>
</html>