<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width , initial-scale=1">
<title>博客详情</title>
<link href="${ pageContext.request.contextPath }/css/common.css" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/common/common.css" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/blog/css/blog.css" rel="stylesheet" type="text/css">

<style type="text/css">
</style>
</head>
<body>
	<div class="main">
		<nav class="min-width-client-header">
			<button id="slideOutTag" class="tag-btn">
				<span class="bar-icon"></span>
				<span class="bar-icon"></span>
				<span class="bar-icon"></span>
			</button>
		</nav>
		<%-- <jsp:include page="/nav.jsp"></jsp:include> --%>
		<div id="iContainner" class="container fl-rl-a">
				<div id="iTags" class="left-tag">
		        	<div class="list-group">
				       	<a class="active">标签分类</a>
						<a>java(15)</a>
						<a >c(11)</a>
						<a >c++(4)</a>
						<a>php(3)</a>
						<a>ubuntu(21)</a>
						<a>linux(1)</a>
						<a>pyhont(2)</a>
						<a>tomcat(1)</a>
						<a>other(4)</a>
						<a>更多标签</a>
		    		</div>
				</div>
				<div class="center-main" id="iBlogs">
					<section class="title"></section>
					<section class="user-list">
						<span></span>
						<span></span>
						<span></span>
					</section>
					<section class="content">
					</section>
				</div>
				<div class="right-info">
					<span class="hits">关注公众号，获取最新动态</span>
					<div class="wxgz-qrcode">
						<img alt="找不到图片" src="../images/my_wxgz_qrcode.jpg">
					</div>
				</div>
			</div>
	</div>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/common/mommon.js"></script>
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