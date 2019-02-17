<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width , initial-scale=1">
<title>博客专栏</title>
<link href="../css/common.css" rel="stylesheet" type="text/css">
<link href="/blog/css/index.css" rel="stylesheet" type="text/css">

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
					
				</div>
				<div class="right-info">
					<div class="login-part">
						<div class="user-info">
							<h2>账号登录</h2>
							<input type="text" name="username" id="iUserName" placeholder="请输入用户名/邮箱/手机号" />
							<input type="password" name="password" id="iPassowrd" placeholder="请输入密码" />
							<div class="forget-password">
								<span>
									<input type="checkbox" id="iRememberMe"/>
									<label class="rememberMe-label" for="iRememberMe">下次自动登录</label>
								</span>
								<span class="forget-password-sp"><a href="#">忘记密码</a></span>
							</div>
							<div class="loginBtn">登录</div>
							<div class="register-dv">还没有账号？ <a class="register" href="#">立刻注册</a></div>
						</div>
					</div>
				</div>
			</div>
	</div>
	<script type="text/javascript" src="/js/jquery-1.9.1.js"></script>
	<script type="text/temp" id="iBlogTemp">
		<section class="content-dv item">
	            <h2  data-id="[id]"  class="content-dv-title blogTitle" title="">
	            <span>[title]</span>
	            </h2>
	            <div class="summary">[content]</div>
		  <div class="list-user-bar">
		  	<section class="sec-left sec">
		  		<div ><img class="user-header" src="[userHeader]" /></div>
		  		<div class="inteval">[user]</div>
		  		<div  class="inteval">[createDate]</div>
		  		<div  class="color-gre labels">
		  			[labels]
		  		</div>
		  	</section>
		  	<section class="sec-right sec">
		  		<div  class="inteval"><span class="color-gre">[readNum] </span>阅读</div>
		  		<div><span class="color-gre">[commentNum] </span>评价</div>
		  	</section>
		  </div>
		</section>
	</script>
	<script>
		var tagBtn = $("#slideOutTag");
		var containner = $("#iContainner");
		tagBtn.on("click" , function(){
			containner.toggleClass("active");
		})
		
	</script>
	<script type="text/javascript" src="/blog/js/index.js"></script>
	
	
</body>
</html>