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
<link href="${ pageContext.request.contextPath }/${serverId}/blog/css/index.css" rel="stylesheet" type="text/css">

<style type="text/css">
</style>
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
						<img onclick="navigatorTo(this)" data-id="${userid }" data-type="userinfo" data-uri="sso/userinfo.do" src="${userheader }" />
					</c:when>
					<c:otherwise>
						<div class="login-btn" onclick="navigatorTo(this)" data-type="login" data-uri="sso/login.do">登录/注册</div>
					</c:otherwise>
				</c:choose>
			</div>
		</div>

		<div class="container">
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
	<!-- <script type="text/javascript" src="http://res.wx.qq.com/open/js/jweixin-1.4.0.js"></script> -->
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/js/jquery-1.9.1.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/common/common.js"></script>
	<script type="text/javascript" src="${ pageContext.request.contextPath }/${serverId}/blog/js/index.js"></script>
	<script type="text/javascript">
	/*  wx.config({
	    debug: true, // 开启调试模式,调用的所有api的返回值会在客户端alert出来，若要查看传入的参数，可以在pc端打开，参数信息会通过log打出，仅在pc端时才会打印。
	    appId: 'wx207d32dbbf52e1c1', // 必填，公众号的唯一标识
	    timestamp: 1551168970069, // 必填，生成签名的时间戳
	    nonceStr: 'fad3e0e9-40a1-4116-aa87-40e5adf521bd', // 必填，生成签名的随机串
	    signature: '433bc34eed5863ce379ac6673c75c9583696c5a6',// 必填，签名
	    jsApiList: ["updateTimelineShareData","updateAppMessageShareData"] // 必填，需要使用的JS接口列表
	});
	wx.error(function(res){
		console.log(res);
		alert(res)
	});
	wx.ready(function () {      //需在用户可能点击分享按钮前就先调用
	    wx.updateTimelineShareData({ 
	        title: '博客234234', // 分享标题
	        link: 'http://www.ajie18.top/ajie/index.do', // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
	        imgUrl: 'http://www.ajie18.top/images/view.jpg', // 分享图标
	        success: function () {
	          alert("分享成功");
	        }
	    });
	
	    wx.updateAppMessageShareData({
	    	title: 'haha', // 分享标题
	    	desc: 'zheshihaha', // 分享描述
	    	link: 'http://www.ajie18.top/ajie/index.do', // 分享链接，该链接域名或路径必须与当前页面对应的公众号JS安全域名一致
	    	imgUrl: 'http://www.ajie18.top/images/view.jpg', // 分享图标
	    	type: 'link', // 分享类型,music、video或link，不填默认为link
	    	success: function (res) {
	    		alert(res)
	    	}
	    	});
	});  */
	
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
	
	//true切换夜间，false切换白天
	function toggleDarkMode(bool){
		var toggle = typeof bool === 'boolean' ? bool : false;
		//随便找一个节点看看是不是夜间模式
		var isDark = $("#iSlider").hasClass("darkModeActive");
		if(isDark == toggle){
			return;
		}
		toggle ? $(".darkMode").addClass("darkModeActive") :$(".darkMode").removeClass("darkModeActive");
		
	}
	
	
	/* 
	
	<div class="operating">
		<div class="operating-more">更多</div>
	</div>
	
	<div class="operating-mask">
		<div class="operating-menu">
		
		</div>
	</div>
	*/
	
	
	(function(){
		var BODY = $(document.body);
		var DOC = $(document);
		var WIN = $(window);
		var WINWIDTH = WIN.width();
		var WINHEIGHT = WIN.height();
		//菜单相对于面板的方向 -- 左
		var DIRECT_LEFT = 1;
		//菜单相对于面板的方向 -- 右
		var DIRECT_RIGHT = 1<<1;
		//菜单相对于面板的方向 -- 上
		var DIRECT_TOP = 1<<2;
		//菜单相对于面板的方向 -- 下
		var DIRECT_BOTTOM = 1<<3;
		//菜单相对于面板的方向 -- 中
		var DIRECT_BOTTOM = 1<<4;
		//菜单相对于面板的方向 -- 右上
		/* var DIRECT_RIGHT_TOP = 1<<4;
		//菜单相对于面板的方向 -- 右下
		var DIRECT_RIGHT_BOTTOM = 1<<5; */
		var panelWidth = WINWIDTH * 0.8;//宽度为屏幕的80%
		if(panelWidth > 380) {
			panelWidth = 380;//最大380px;
		}
		var menu = $("<div>").addClass("operating").appendTo(BODY);
		$("<div>").addClass("operating-more").html("更多").appendTo(menu);
		var mask = $("<div>").addClass("operating-mask").addClass("hidden").appendTo(BODY)
		var panel = $("<div>").addClass("operating-panel").appendTo(mask);
		panel.css({
			width: panelWidth,
			height: panelWidth
		})
		adjustPanelPosi();
		function getPanelWidth(){
			return panelWidth;
		}
		
		function getWinWidth(){
			return WIN.width();
		}
		
		//面板根据菜单位置寻找位置
		function adjustPanelPosi(){
			var menupos = getMenuPosi();
			var width = getPanelWidth();
			var x = (getWinWidth() - width) / 2;
			//var y = menupos.top - (width / 2) + (menu.height()/2) ;
			//y也居中
			var y = (WINHEIGHT - width) / 2;
			panel.css({
				left: x,
				top: y
			})
		}
		
		function getMenuPosi(){
			var offset = menu.position();
			var menuWidth = menu.width();
			var left = offset.left;
			var top = offset.top
			//相对于面板的方向
			var direction = 0;
			if((WIN.width()-menuWidth) / 2 > left) {
				direction |= DIRECT_LEFT ;
			}else{
				direction |= DIRECT_RIGHT;
			}
			var panelPosi = getPanelPosi();
			if(panelPosi.top >= (top + menuWidth)){
				direction |= DIRECT_TOP;
			}else if(panelPosi.top + panel.height() < top){
				direction |= DIRECT_BOTTOM;
			}
			return {
				left: left,
				top: top,
				direction: direction
			}
		}
		
		function getPanelPosi(){
			var width = getPanelWidth();
			var top = (WINHEIGHT - width) / 2;
			var left = (WINWIDTH - width) / 2;
			return {
				left: left,
				top: top,
			}
		}
		
		function showPanel(){
			adjustPanelPosi();
			var menuPosi = getMenuPosi();
			panel.removeClass("transform-origin-left").removeClass("transform-origin-right");
			panel.removeClass("transform-origin-left-top").removeClass("transform-origin-left-bottom");
			panel.removeClass("transform-origin-right-top").removeClass("transform-origin-right-bottom")
			if((menuPosi.direction & DIRECT_LEFT) == DIRECT_LEFT) {
				//在左边
				if((menuPosi.direction & DIRECT_TOP) == DIRECT_TOP){
					panel.addClass("transform-origin-left-top");
				}else if((menuPosi.direction & DIRECT_BOTTOM) == DIRECT_BOTTOM){
					panel.addClass("transform-origin-left-bottom");
				}else{
					panel.addClass("transform-origin-left");
				}
			}else if((menuPosi.direction & DIRECT_RIGHT) == DIRECT_RIGHT){
				//在右边
				if((menuPosi.direction & DIRECT_TOP) == DIRECT_TOP){
					panel.addClass("transform-origin-right-top");
				}else if((menuPosi.direction & DIRECT_BOTTOM) == DIRECT_BOTTOM){
					panel.addClass("transform-origin-right-bottom");
				}else{
					panel.addClass("transform-origin-right");
				}
			}
			panel.addClass("menu_dialog_show");
			mask.removeClass("hidden");
			menu.addClass("hidden");
		}
		
		function hidePanel(){
			panel.removeClass("menu_dialog_show");
			panel.addClass("menu_dialog_hide");
			menu.removeClass("hidden");
			var timing;
			timing = setTimeout(function(){
				mask.addClass("hidden");
				panel.removeClass("menu_dialog_hide");
				clearTimeout(timing);
			},200)
		}
		
		var startTime,endTime,startX,startY,endX,endY,curentX,curentY,startMenuX,startMenuY,menuWidth;
		menu.get(0).addEventListener("touchstart",function(event){
			var event = event || window.event;
			event.preventDefault();//禁止页面顺着滚动
			startTime = event.timeStamp;
			startX = event.changedTouches[0].clientX;
			startY = event.changedTouches[0].clientY;
			var menuPosi = getMenuPosi();
			startMenuX = menuPosi.left;
			startMenuY = menuPosi.top;
			menuWidth = menu.width();
		},false)
		menu.get(0).addEventListener("touchmove",function(event){
			var event = event || window.event;
			event.preventDefault();//禁止页面顺着滚动
			currentX = event.changedTouches[0].clientX;
			currentY = event.changedTouches[0].clientY;
			var moveX = currentX - startX;
			var moveY = currentY - startY;
			var x = startMenuX + moveX;
			var y = startMenuY + moveY;
			if(x <= 0){
				x = 0;
			}
			if(x+menuWidth >= WINWIDTH){
				x = WINWIDTH - menuWidth;
			}
			/* if(x <= 0 || (x+menuWidth) >= WINWIDTH){
				return;
			} */
			if(y <= 0){
				y = 0;
			}
			if(y+menuWidth >= WINHEIGHT){
				y = WINHEIGHT - menuWidth
			}
			/* if(y <= 0 || (y+menuWidth) >= WINHEIGHT){
				return;
			} */
			menu.css({
				top: y+"px",
				left: x+"px"
			})
		},false)
		menu.get(0).addEventListener("touchend",function(event){
			var event = event || window.event;
			event.preventDefault();//禁止页面顺着滚动
			endTime = event.timeStamp;
			var interval = endTime - startTime;
			endX = event.changedTouches[0].clientX;
			endY = event.changedTouches[0].clientY;
			var moveX = endX - startX;
			var moveY = endY - startY;
			if(interval < 200 && moveX < 5 && moveY < 5){
				click();
				return;
			}
			var menuPosi = getMenuPosi();
			var x = 10;
			if((menuPosi.direction & DIRECT_RIGHT) == DIRECT_RIGHT){
				menu.css({
					left: "unset",
					right: "10px"
				})
			}else{
				menu.css({
					right: "unset",
					left: "10px"
				})
			}
		},false)
		
		function click(){
			showPanel()
		}
		/* menu.on("click",function(e){
			var e = e || window.event;
			e.stopPropagation(); //禁止冒泡
			showPanel()
		}) */
		mask.on("touchstart",function(e){
			e.stopPropagation(); //禁止冒泡
			hidePanel();
		})
		
		panel.on("click",function(e){
			var e = e || window.event;
			e.stopPropagation(); //禁止冒泡
		})
	})()
	
	</script>
	
</body>
</html>