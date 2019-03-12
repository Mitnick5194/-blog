<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport" content="width=device-width , initial-scale=1,maximum-scale=1.0, user-scalable=0">
<title>${empty id ? '发布博客': '编辑博客' }</title>
<link href="${ pageContext.request.contextPath }/${serverId}/css/global.css" rel="stylesheet" type="text/css">
<style type="text/css">
.container{margin-bottom: 50px;}
.nav{width: 90%; margin: 0 auto; height: 40px;background: #eee;}
.main{width: 90%;margin: 0 auto;margin-top: 20px;margin-top: 55px;}
.main>.left{width: 260px;display: none}
/* 导航 */
.header-navi{z-index: 1000; position: fixed;top:0;left:0;width: 100%;height: 45px;line-height: 45px;background: #fff;text-align: right;border-bottom: 1px solid #eee;}
.header-navi>div{display: inline-block;}
.header-navi>.user-header{display: inline-flex;align-items: center;height: 100%;margin-right: 15px;cursor: pointer;}
.header-navi>.user-header div:nth-child(2){margin-left: 10px;color: #337ab7}
.header-navi>.user-header>img{width: 25px; height: 25px;border-radius: 50%;}
.login-btn{color: blue}.main>.editor-area{width: 100%;}
.form>input[name=title]{width: 98%;height: 40px;line-height: 40px;background: #eee;margin-bottom: 5px;padding: 0 10px;border: none;font-size: 16px;}
.labels{height: 30px;line-height: 30px;align-items: center;padding:10px 0;}
.add-label{position: relative;color: #349EDF;cursor: pointer;}
/* .add-label:before{content:'';position: absolute;width: 20px;height: 20px;border-radius: 3px;background:#349EDF;color:#fff;left: -25px;top: 5px;} */
.add-label>div{display: inline-block;}
.add-label-btn{position: absolute;left: 0;width: 20px;height: 20px;background:#349EDF;border-radius: 3px;top: 5px; }
.add-label-btn>span:nth-child(1){position: absolute;top:9px;height: 2px;background: #fff;width:16px;left: 2px;}
.add-label-btn>span:nth-child(2){position: absolute;width: 2px;background: #fff;left:9px;top: 2px;height:16px;}
.add-label-hits{margin-left: 25px;}
.input-group{display: flex;}
.input-group input{background: #eee;border: none;width: 80px;border-radius: 3px;padding: 5px; }
.delLabelBtn{display: inline-block;width: 20px;height: 100%;color: #888;font-size: 22px;margin-right: 3px;text-align: center;cursor: pointer;}
.submit-btn{cursor:pointer; display: inline-block;width: 120px;padding: 8px 0;text-align: center;background:#349EDF;border-radius: 5px; color:#fff;}
.hits-frame{width: 80%;}
.hits-frame>div{padding:10px;}
.hits-frame>.hits-title{background:#349EDF;text-align: center;color: #fff; }
.hits-frame>.hits-content{padding: 25px 10px; }
/* 平板 */
@media screen and (min-width: 768px){
	.header-navi>.user-header{margin-right: 70px;}
	.main>.left{display: block}
}
</style>
<link href="${ pageContext.request.contextPath }/${serverId }/css/global.css" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/${serverId }/common/common.css" rel="stylesheet" type="text/css">
<link href="${ pageContext.request.contextPath }/${serverId}/css/dark-mode-support.css" rel="stylesheet" type="text/css">
</head>
<body>
	
	<div class="container">
		<div class="header-navi darkMode">
			<div class="user-header">
				<img  class="user" data-id="${userid }" data-type="userinfo"  src="${userheader }" />
			</div>
		</div>
		<div class="flex main">
			<div class="left">
				<span class="hits">关注公众号和小程序，获取最新动态</span>
				<div class="wxgz-qrcode">
					<img alt="找不到图片" src="${ pageContext.request.contextPath }/${serverId }/images/my_wxgz_qrcode.jpg">
				</div>
				<div class="wxgz-qrcode">
					<img alt="找不到图片" src="${ pageContext.request.contextPath }/${serverId }/images/my_wxapp_code.jpg">
				</div>
			</div>
			<div class="editor-area">
				<form class="form" id="iForm">
					<input placeholder="文章标题" type="text" name="title"/>
			    	<textarea  name="editor" id="editor"></textarea>
			    	<div class="labels flex">
			    		<div>文章标签：</div>
			    		<div class="input-group" id="iInputGruop">
			    			<!-- <input type="text" /><span class="del-label-btn">x</span>
			    			<input type="text" />
			    			<input type="text" /> -->
			    		</div>
			    		<div class="add-label" id="iAddLabelBtn">
			    			<div class="add-label-btn"><span></span><span></span></div>
			    			<div class="add-label-hits">添加标签</div>
			    		</div>
			    	</div>
			     </form> 
			     <div class="submit-btn" id="iBtn">发布</div>
			</div>
		</div>
	</div>
	
	<div class="hits-frame darkMode" id="iHitsFrame">
		<div class="hits-title">温馨提示</div>
		<div class="hits-content">
			富文本编辑器尚未兼容手机宽度，可前往PC端获得更好体验！
		</div>
		<div>
			<div>不再提醒</div>
			<div>我知道了</div>	
		</div>
	</div>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId }/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId }/common/common.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/js/dark-mode-support.js"></script>
	 <script src="${ pageContext.request.contextPath }/${serverId }/ckeditor/ckeditor.js"></script>
     <script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId }/blog/js/addblog.js?d=2019"></script>
      <script>
          
	   </script>
</body>
</html>