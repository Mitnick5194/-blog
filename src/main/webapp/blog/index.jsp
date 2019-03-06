<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html class="darkMode">
<head >
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width , initial-scale=1,maximum-scale=1.0, user-scalable=0">
<title>首页</title>
 <link href="${ pageContext.request.contextPath }/${serverId}/common/common.css" rel="stylesheet" type="text/css">
 <link href="${ pageContext.request.contextPath }/${serverId}/css/global.css" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/${serverId}/blog/css/index.css?d=20190306" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/${serverId}/plugin/suspend-btn.css" rel="stylesheet" type="text/css">

<style type="text/css">
</style>

<script type="text/javascript">
var errMsg , errCount = 0;
window.addEventListener("error" , function(e){
	/* console.log("监听到错误");
	console.log(e);
	alert(e.error +" \r\n  "+e.error.stack); */
	errMsg = e.error+"<br>"+e.error.stack;
	++errCount;
	pageLog();
})

</script>
</head>
<body class="darkMode ">
	<div class="main ">
		<div id="iSlider" class="tag-btn darkMode">
			<span class="bar-icon"></span>
			<span class="bar-icon"></span>
			<span class="bar-icon"></span>
			<span class="bar-icon"></span>
		</div>
		<div class="header-navi darkMode">
			<div onclick="javascript:location.href='addblog.do'" class="addblog">写博客</div>
			<div class="user-header">
				<c:choose>
					<c:when test="${not empty userid }">
						<img  class="user" data-id="${userid }" data-type="userinfo" data-uri="sso/userinfo.do" src="${userheader }" />
					</c:when>
					<c:otherwise>
						<div class="login-btn user" data-type="login" data-uri="sso/login.do">登录/注册</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<div class="container">
			<form id="iForm" class="hidden" method="post" action="blog.do">
				<input name="id" type="hidden" >
			</form>
			<div id="iTags" class="tags-block darkMode">
				<div class="list-group " id="iListTags">
		    	</div>
			</div>
			<div class="blogs" id="iBlogs">
			</div>
			<div class="qr-code">
				<div>关注公众号和小程序，获取获取最新状态</div>
				<div>
					<img src="${ pageContext.request.contextPath }/${serverId}/images/my_wxgz_qrcode.jpg" />
				</div>
				<div>
					<img src="${ pageContext.request.contextPath }/${serverId}/images/my_wxapp_code.jpg" />
				</div>
			</div>
		</div>
	</div>
	
	<div class="log-frame" id="iLogFrame">
		<div class="log-nav"><div>页面日志</div><div>info：0 warn：0 <span class="logErr error-font">error: 0</span></div></div>
		<div class="system-info">系统：</div>
		<div class="page-log">页面错误日志</div>
	</div>
	
<!-- 	<div class="operating">
		<div class="operating-more">更多</div>
	</div>
	
	<div class="operating-mask">
		<div class="operating-menu">
		
		</div>
	</div> -->
	
	<jsp:include page="/footer.jsp"></jsp:include>
	<script type="text/temp"  id="iBlogTemp">
		<section class='darkMode'  data-id='[id]' >
			<div class="title">[title]</div>
			<div class="abstract-content">[abstractContent]</div>
			<div class="extract-list">
				<div class="list-left flex">
					<img src="[userHeader]">
					<div>[user]</div>
					<div>[createDate]</div>
				</div>
				<div class="list-right flex">
					<div>阅读 [readNum]</div>
					<div>评论 [commentNum]</div>
				</div>
			</div>
		</section>
	</script>
	<script type="text/javascript">
		var serverId = '${serverId}';
	</script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/plugin/suspend-btn.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/common/common.js?d=2019"></script>
	<script type="text/javascript">
		//日志弹窗
		var  logFrame = $("#iLogFrame").getWindow();
		logFrame.setCloser(false);
		logFrame.clickbackhide();
		//页面错误日志
		function pageLog(){
			var userAgent = navigator.userAgent;
			var frame =  $("#iLogFrame")
			var supportCss3 = $.supportcss3;
			if(supportCss3){
				frame.find(".system-info").html("系统："+userAgent+" <span style='color: green'>正常</span>");
			}else{
				frame.find(".system-info").html("系统："+userAgent+" <span style='color: red'>异常</span>");
			}
			
			var pageLog ="页面信息：";
			if(!errMsg){
				pageLog += "<span style='color: green'>正常</span>"
			}else{
				frame.find(".logErr").html("error："+errCount);
				pageLog += "<span style='color:red'>"+errMsg+"</span>"
			}
			frame.find(".page-log").html(pageLog);
			logFrame.show();
		}
	</script>
	<script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/blog/js/index.js?d=2042"></script>
	<script type="text/javascript">
	/*var config = {};
	var configstr = '${config}';
	if(configstr && configstr.length){
		config = JSON.parse(configstr);
	}
	wx.config(config);*/
	 /*   wx.config({
	    debug: false, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
	    appId: 'wx207d32dbbf52e1c1', // 必填，公众号的唯一标识
	    timestamp: 1551875120, // 必填，生成签名的时间戳
	    nonceStr: 'b1fcb8e9-6045-4b4e-bfaa-ad2cc1acef09', // 必填，生成签名的随机串
	    signature: '830c2c68feea84893701992dba2aa8379d3f2b2e',// 必填，签名
	    jsApiList: ["getNetworkType"] // 必填，需要使用的JS接口列表
	})  */
	
	//var config = ${config};
	/* config.debug = true;
	wx.config(config); */
	
	
	
</script>
	
</body>
</html>