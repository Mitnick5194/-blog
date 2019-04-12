(function(){
	//夜间模式cookid key
	var NIGHT_COOKIE_KEY = "night-mode";
	var NIGHT_COOKIE_VAL = "night";
	// 模板
	String.prototype.temp = function(obj) {
		return this.replace(/\[\w+\]?/g, function(match) {
			var ret = obj[match.replace(/\[|\]/g, "")];
			return (ret + "") == "undefined" ? "" : ret;
		})
	};
	
	$(document).ready(function(){
		$.toggleDarkMode($.isDarkMode());
	});
	var tempstr = $("#iBlogTemp").html();
	var cacheTags = null;
	loadblogs();
	function loadblogs(tag) {
		var loading = $.showloading("加载中")
		$.ajax({
			type: 'post',
			data:{
				tag: tag
			},
			url: 'loadblogs.do',
			success: function(data) {
				console.log(data);
				if(data.code == 200){
					var blogs = data.data ||[];
					var sb = [];
					for(let i=0;i<blogs.length;i++){
						var blog = blogs[i];
						var labelsStr = blog.labels;
						if(labelsStr){
							var labels = labelsStr.split(",");
							//标签处理一下
							var lab = [];
							for(let i=0;i<labels.length;i++){
								lab.push("<span class='label'>"+labels[i]+"</span>");
							}
							blog["labels"] = lab.join("");
						}
						sb.push(tempstr.temp(blog));
						
					}
					$("#iBlogs").html(sb.join(""));
				}
				loading.hide();
				loadtags();
			},
			fail: function(e) {
				$.showToast(e)
			},
			complete: function(){
				//在文档加载时已经判断了是不是夜间模式，但是异步加载的节点比较慢，所以需要手动再判断一下是不是夜间
				if($.isDarkMode()){
					$.toggleDarkMode($.isDarkMode())
				}
			}
			
		})
	}
	
	function loadtags() {
		if(cacheTags){
			return;
		}
		$.ajax({
			type: 'post',
			data:{},
			url: 'loadtags.do',
			success: function(data){
				if(data.code == 200){
					var tags = data.data ||[];
					var sb = [];
					sb.push("<div class='title'>标签分类</div>")
					sb.push("<div class='tag'>全部</div>")
					for(let i=0;i<tags.length;i++){
						var tag = tags[i];
						sb.push("<div class='tag' data-name="+tag.name+">"+tag.name+"（"+tag.blogCount+"）</div>");
						if(i == 6){
							//显示7个
							sb.push("<div class='tag moreTags'>更多标签</div>");
							break;
						}
					}
					$("#iTags").find(".list-group").html(sb.join(""));
					cacheTags = tags;
				}
			},
			fail: function(e){
				$.showToast(e)
			},
			complete: function(){
				//更新一下时间
				if(!endTime){
					endTime = new Date().getTime();
				}
				//$("#iLogFrame").find(".interval").html((endTime-startTime)/1000);
			}
			
		})
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
			url = "http://"+host+"sso/";
		}
		if("login" == type){
			url += "login.do?ref="+location.href;
		}else if("userinfo" == type){
			url += "userinfo.do?id="+_this.attr("data-id");
		}
		
		location.href = url;
	}
	
	$("#iBlogs").on("click" , "section" , function(e){
		e.stopPropagation(); //禁止冒泡
		var id = $(this).attr("data-id");
		location.href = "blog.do?id="+id;
	})
	
	$("#iBlogs").on("click" , ".user" , function(e){
		e.stopPropagation(); //禁止冒泡
		gotoUserPage($(this));
	})
	
	var tags = $("#iTags");
	$("#iListTags").on("click",".tag",function(e){
		e.stopPropagation(); //禁止冒泡
		var _this = $(this);
		tags.removeClass("active");
		if(_this.hasClass("moreTags")){
			window.open("moretags.do");
			return ;
		}
		var tag = _this.attr("data-name");
		_this.siblings(".active").removeClass("active");
		_this.addClass("active");
		loadblogs(tag);
	})
	
	//点击标签 只有移动设备才有标签按钮，所以可以直接监听touchstart,方便做收起操作
	$("#iSlider").on("touchstart",function(e){
			var e = e || window.event;
			e.stopPropagation(); //禁止冒泡
			var classes = iTags.classList;
			if(tags.hasClass("active")){
				tags.removeClass("active");
			}else{
				tags.addClass("active");
			}
		});
	//移动端移动收起标签
	$(document).on("touchstart",function(e){
		if (!tags.hasClass("active")) {
			return;
		}
		if (tags[0] != e.target && tags.has(e.target).length == 0) {
			tags.removeClass("active");
		}
	})
	
})()