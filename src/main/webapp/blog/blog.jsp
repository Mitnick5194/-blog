<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width ,initial-scale=1,maximum-scale=1.0, user-scalable=0">
<title>详情</title>
<link href="${ pageContext.request.contextPath }/${serverId }/css/global.css" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/${serverId }/common/common.css" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/${serverId }/blog/css/blog.css" rel="stylesheet" type="text/css">

<style type="text/css">
</style>
</head>
<body>
	<div class="main">
		<div class="header-navi">
			<div onclick="javascript:location.href='addblog.do'" class="addblog">写博客</div>
				<div class="user-header" id="iUserHeader">
					<img class="${empty userid ? 'hidden':'' } user-info" onclick="navigatorTo(this)" data-id="${userid }" data-type="userinfo" data-uri="sso/userinfo.do" src="${userheader }" />
					<div  class="${empty userid ? '':'hidden' } login-btn"  onclick="navigatorTo(this)" data-type="login" data-uri="sso/login.do">登录/注册</div>
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
						<section class="tags">
							<!-- <span>标签：</span>
							<span>linux</span>
							<span>linux</span>
							<span>linux</span> -->
						</section>
						<section class="content"></section>
					</div>
					<div class="right-info">
						<span class="hits">关注公众号和小程序，获取最新动态</span>
						<div class="wxgz-qrcode">
							<img alt="找不到图片" src="${ pageContext.request.contextPath }/${serverId }/images/my_wxgz_qrcode.jpg">
						</div>
						<div class="wxgz-qrcode">
							<img alt="找不到图片" src="${ pageContext.request.contextPath }/${serverId }/images/my_wxapp_code.jpg">
						</div>
					</div>
				</div>
				<div class="comment">
					<input type="hidden" id="iUser" value="${userid }" />
					<c:choose>
						<c:when test="${not empty userheader }">
							<img alt="" src="${userheader }" id="iUserHeader">
						</c:when>
						<c:otherwise>
							<img alt="" src="${ pageContext.request.contextPath }/${serverId }/images/user_header_not_login.png" id="iUserHeader">
						</c:otherwise>
					</c:choose>
					
					<div class="text-dv"> 
						<textarea id="iComment" class="comment-text" placeholder="想对作者说点什么"></textarea>
					</div>
					<div class="submit-btn" id="iSubmit">发表</div>
				</div>
				<div class="comment-list" id="iComments">
				</div>
				<div class="footer-code">
						<span class="hits">关注公众号和小程序，获取最新动态</span>
						<div class="footer-qr-code">
							<div class="wxgz-qrcode">
								<img alt="找不到图片" data-idx="1" class="viewImg" src="${ pageContext.request.contextPath }/${serverId }/images/my_wxgz_qrcode.jpg">
							</div>
							<div class="wxgz-qrcode">
								<img alt="找不到图片"  data-idx="2" class="viewImg"  src="${ pageContext.request.contextPath }/${serverId }/images/my_wxapp_code.jpg">
							</div>
						</div>
						
						
					</div>
			</div>
	</div>
	
	<!-- 登录弹窗 -->
	<div class="login-frame" id="iLoginFrame">
		<div class="login-dv">
			<div  class="mobile-login-dv">
				<div class="navBar">
					<div>登录</div>
				</div>
				<div id="iForms" class="form-group ">
					<div class="login-form" id="iLoginForm">
						<div class="key-dv"><input type="text" name="key" placeholder="用户名/手机号/邮箱"/></div>
						<div class="passwd-dv"><input type="password" name="password" placeholder="密码"/></div>
						<div id="iLoginBtn" class="login-btn submitBtn">登录</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	<jsp:include page="/footer.jsp"></jsp:include>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId }/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId }/common/common.js"></script>
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script>
	<script>
		var serverId = '${serverId}';
		var loginFrame = $("#iLoginFrame").getWindow();
		loginFrame.setCloser(false);
		loginFrame.clickbackhide();
		var tagBtn = $("#slideOutTag");
		var containner = $("#iContainner");
		tagBtn.on("click" , function(){
			containner.toggleClass("active");
		})
		var id = '${id}';
		function navigatorTo(ele){
			var _this = $(ele);
			var type = _this.attr("data-type")
			var uri = _this.attr("data-uri");
			var host = location.host+"/";
			var url = "";
			if(host.indexOf("localhost") > -1 ||host.indexOf("127.0") > -1 || host.indexOf("10.8") > -1){
				url = 'http://localhost:8081/'+uri;
			}else{
				url = "http://"+host+uri;
			}
			if("login" == type){
				url += "?ref="+location.href
			}else if("userinfo" == type){
				url += "?id="+_this.attr("data-id");
			}
			
			location.href = url;
		}
		
		var config = {};
		var configstr = '${config}';
		if(configstr && configstr.length){
			config = JSON.parse(configstr);
		}
		wx.config(config);
		
	</script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId }/blog/js/blog.js"></script>
	<script type="text/temp" id="iCommentTemp">
		<section class="comment-item">
			<div data-id='[userId]' class="left-user-info">
				<img src="[userHeader]">
			</div>
			<div class="right-comment-info">
				<span class="commenter">[userName]：</span>
				<span>[content]</span>
				<span class="create-date">（[createDate]	#[order]楼）</span>
			</div>
		</section>
	</script>
	
</body>
</html>