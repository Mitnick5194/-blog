(function(){
	// 模板
	String.prototype.temp = function(obj) {
		return this.replace(/\[\w+\]?/g, function(match) {
			var ret = obj[match.replace(/\[|\]/g, "")];
			return (ret + "") == "undefined" ? "" : ret;
		})
	}
	var tempstr = $("#iBlogTemp").html();
	var cacheTags = null;
	loadblogs();
	function loadblogs(){
		var loading = $.showloading("加载中")
		$.ajax({
			type: 'post',
			data:{},
			url: 'loadblogs.do',
			success: function(data){
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
			fail: function(e){
				$.showToast(e)
			},
			complete: function(){
				
			}
			
		})
	}
	
	function loadtags(){
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
					for(let i=0;i<tags.length;i++){
						var tag = tags[i];
						sb.push("<div>"+tag.name+"（"+tag.blogCount+"）</div>");
						if(i == 9){
							//显示10个
							sb.push("<div class='moreTags'>更多标签</div>");
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
				
			}
			
		})
	}
	
	$("#iBlogs").on("click" , "section" , function(e){
		e.stopPropagation(); //禁止冒泡
		var id = $(this).attr("data-id");
		location.href = "blog.do?id="+id;
		//window.open("blog.do?id="+id);
	})
	
	$("#iListTags").on("click","div",function(e){
		e.stopPropagation(); //禁止冒泡
		var _this = $(this);
		if(_this.hasClass("moreTags")){
			window.open("moretags.do");
		}
	})
	
	var tags = $("#iTags");
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