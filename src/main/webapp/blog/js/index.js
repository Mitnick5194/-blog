(function(){
	// 模板
	String.prototype.temp = function(obj) {
		return this.replace(/\[\w+\]?/g, function(match) {
			var ret = obj[match.replace(/\[|\]/g, "")];
			return (ret + "") == "undefined" ? "" : ret;
		})
	}
	var tempstr = $("#iBlogTemp").html();
	loadblogs();
	function loadblogs(){
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
				console.log(data);
			},
			fail: function(e){
				console.log(e);
			},
			complete: function(){
				
			}
			
		})
	}
	
	$("#iBlogs").on("click" , ".blogTitle" , function(){
		var id = $(this).attr("data-id");
		location.href = "blog.do?id="+id;
	})
	
	
	
})()