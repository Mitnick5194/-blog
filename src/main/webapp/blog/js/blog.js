(function(){
	var main = $("#iBlogs");
	// 模板
	String.prototype.temp = function(obj) {
		return this.replace(/\[\w+\]?/g, function(match) {
			var ret = obj[match.replace(/\[|\]/g, "")];
			return (ret + "") == "undefined" ? "" : ret;
		})
	}
	$(document).ready(function(){
		$.toggleDarkMode($.isDarkMode());
	})
	var dayIcon = {
			url:'http://www.ajie18.top/images/day3.jpg',
			text: "日间模式",
			css: {},
			callback:function(panel) {
				$.toggleDarkMode(false);
				//toggleDarkMode(false);
				panel.setIcon(darkIcon , 3);
				panel.hidePanel();
			}
		}
	var darkIcon = {
			url:'http://www.ajie18.top/images/dark.jpg',
			text: "夜间模式",
			css: {},
			callback:function(panel) {
				$.toggleDarkMode(true);
				//toggleDarkMode(true);
				panel.setIcon(dayIcon , 3);
				panel.hidePanel();
			}
		}
	var icon = $.isDarkMode() ? dayIcon  : darkIcon;
	//悬浮菜单
	var icons = [{
		url:'http://www.ajie18.top/images/fresh.jpg',
		text: "刷新",
		css: {},
		callback:function() {
			var panel = arguments[0];
			location.reload();
		}
	},{
		url:'http://www.ajie18.top/images/gotoTop.jpg',
		text: "顶部",
		css: {},
		callback:function(panel) {
			$('html,body').animate({scrollTop:0},'fast');
		}
	},{
		url:'http://www.ajie18.top/images/logging.jpg',
		text: "日志",
		css: {},
		callback:function() {
			 pageLog();
		}
	},icon
	,{
		url:'http://www.ajie18.top/images/manager.jpg',
		text: "后台",
		css: {},
		callback:function(panel){
			location.href = "manager.do";
		}
	},{
		url:'http://www.ajie18.top/images/wxapp.jpg',
		text: "小程序",
		css: {},
		callback:function(panel){
			var host = "http://"+location.host +"/blog/"+serverId+"/images/";
			var url = host+"my_wxapp_code_shuiyin.jpg";
			//全屏查看图片
			wx.previewImage({
				current: url, // 当前显示图片的http链接
				urls: [url] // 需要预览的图片http链接列表
			});
		}
	},]
	var options = {
		tapHide: true,
		icons: icons
	}
	$.createSuspendBtn(options);
	getblogbyid(id,function(data){
		main.find(".title").html(data.title);
		var userList = "<span>"+data.createDate+" | </span><span class='user' data-id="+data.userId+">"+data.user+" | </span><span>阅读数 "+data.readNum+"</span>";
		main.find(".user-list").html(userList);
		var tagsBlock = main.find(".tags");
		var tagsstr = data.labels;
		if(tagsstr &&tagsstr.length){
			var tags = tagsstr.split(",");
			var sb = [];
			sb.push("<span>标签：</span>")
			for(let i=0;i<tags.length;i++){
				sb.push("<span>"+tags[i]+"</span>")
			}
			tagsBlock.html(sb.join(""));
		}
		
		main.find(".content").html(data.content)
	});
	function getblogbyid(id,callback){
		var loading = $.showloading("加载中")
		$.ajax({
			type: 'post',
			data: {
				id: id,
			},
			url: 'getblogbyid.do',
			success: function(data){
				if(data.code == 200){
					typeof callback === 'function' && callback(data.data);
					loadcomments(handleComment);
				}else{
					$.showToast(data.msg)
				}
			},
			fail: function(e){
				$.showToast(e)
			},
			complete: function(){
				loading.hide();
			}
		})
	}
	
	function loadcomments(callback){
		$.ajax({
			type: 'post',
			data: {
				blogId: id,
			},
			url: 'getcommentsbyblog.do',
			success: function(data){
				if(data.code == 200){
					typeof callback === 'function' && callback(data.data);
				}else{
					$.showToast(data.msg);
				}
			},
			fail: function(e){
				$.showToast(e);
			},
			complete: function(){
				//更新一下时间
				if(!endTime){
					endTime = new Date().getTime();
				}
			}
		})
	}
	
	function handleComment(data){
		if(!data || !data.length){
			return;
		}
		var tempstr = $("#iCommentTemp").html();
		var sb = [];
		for(let i=0;i<data.length;i++){
			var d = data[i];
			d["order"] = (i+1); //加入层数
			sb.push(tempstr.temp(d));
		}
		$("#iComments").html(sb.join(""));
	}
	
	$("#iSubmit").on("click", function(){
		comment()
	})
	
	function comment(callback){
		if(!checkComment()){
			return;
		}
		var content = $("#iComment").val();
		var loading = $.showloading("正在发布");
		$.ajax({
			type: 'post',
			data: {
				blogId: id,
				content: content
			},
			url: 'createcomment.do',
			success: function(data){
				if(data.code == 200){
					$.showToast("发布成功",1500,function(){
						$("#iComment").val("");//清空
						loadcomments(handleComment);
					})
				}else{
					$.showToast(data.msg);
				}
			},
			fail: function(e){
				$.showToast(e);
			},
			complete: function(){
			}
		})
	}
	
	function checkComment(){
		//检查是否登录
		var userId = $("#iUser").val();
		var conent = $("#iComment").val();
		if(!userId){
			loginFrame.show();
			return false;
		}
		if(!conent){
			$.showToast("内容为空");
			return false;
		}
		return true;
	}
	
	var host = "http://"+location.host +"/blog/"+serverId+"/images/";
	var url1 = host +"my_wxgz_qrcode.jpg";
	var url2 = host+"my_wxapp_code.jpg";
	var urls = [url1,url2];
	var imgs = [];
	$(".viewImg").on("click",function(){
		var idx = Number.parseInt($(this).attr("data-idx"));
		var current = urls[idx-1];
		//全屏查看图片
		wx.previewImage({
			current: current, // 当前显示图片的http链接
			urls: urls // 需要预览的图片http链接列表
		});
	})
	
	//登录
	$("#iLoginBtn").on("click",function(){
		var url = "dologin.do";
		var _this  = $(this);
		var parent = _this.parent();
		var name = $.trim(parent.find("input[name=key]").val());
		var password = $.trim(parent.find("input[name=password]").val());
		if(!name){
			$.showToast("用户名不能为空")
			return;
		}
		if(!password){
			$.showToast("密码不能为空");
			return;
		}
		var loading = $.showloading("正在登录");
		
		var host = location.host;
		var url;
		if(host.indexOf("localhost") > -1 ||host.indexOf("127.0") > -1 || host.indexOf("10.8") > -1){
			url = "http://localhost:8081/sso/dologin.do";
		}else if(serverId == 'xff'){
			url = "http://www.ajie18.top/ajie/sso/dologin.do";
		}
		else{
			url = "http://www.ajie18.top/sso/dologin.do";
		}
		$.ajax({
		    url: url,
		    dataType: 'JSONP',
		    jsonpCallback: 'callback',//success后会进入这个函数，如果不声明，也不会报错，直接在success里处理也行
		    type: 'GET',
		    data:{
		    	key:name,
		    	password: password
		    },
		    success: function (data) {
		    	if(data.code != 200){
		    		$.showToast(data.msg);
		    		return;
		    	}
		    	$.showToast("登录成功",function(){
		    		//清空内容
		    		$("#iLoginForm").find("input").val("");
		    		loginFrame.hide();
		    		changeHeader(data.data);
		    	})
		    }
		});
	})
	
	/**改变头部，显示用户登录*/
	function changeHeader(data){
		$("#iUser").val(data.id);
		var header = $("#iUserHeader");
		header.find(".login-btn").addClass("hidden");
		var user = header.find(".user-info");
		user.removeClass("hidden");
		user.attr("data-id",data.id).attr("src",data.header);
		
	}
	
	$(".user").on("click",function(e){
		e = e || window.event;
		e.stopPropagation(); //禁止冒泡
		var _this = $(this);
		gotoUserPage(_this);
	})
	
	function gotoUserPage(ele){
		var _this = $(ele);
		var type = _this.attr("data-type")
		var host = location.host+"/";
		var url = "";
		if(host.indexOf("localhost") > -1 ||host.indexOf("127.0") > -1 || host.indexOf("10.8") > -1){
			url = 'http://localhost:8081/sso/';
		}else if(serverId == 'xff'){
			url = "http://"+host+"ajie/sso/";
		}else{
			url = "http://"+host+"/sso/";
		}
		if("login" == type){
			url += "login.do?ref="+location.href;
		}else if("userinfo" == type){
			url += "userinfo?id="+_this.attr("data-id");
			url += "?id="+_this.attr("data-id");
		}
		
		location.href = url;
	}
	
	

})()