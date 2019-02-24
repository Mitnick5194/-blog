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
				console.log(e);
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
							sb.push("<div id='iMoreTags'>更多标签</div>");
							break;
						}
					}
					$("#iTags").find(".list-group").html(sb.join(""));
					cacheTags = tags;
				}
			},
			fail: function(e){
				console.log(e);
			},
			complete: function(){
				
			}
			
		})
	}
	
	$("#iBlogs").on("click" , ".title" , function(){
		var id = $(this).attr("data-id");
		window.open("blog.do?id="+id);
	})
	
	$("#iMoreTags").on("click",function(){
		window.open("moretags.do");
	})
	
})()