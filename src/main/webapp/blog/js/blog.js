(function(){
	var main = $("#iBlogs");
	getblogbyid(id,function(data){
		console.log(data)
		main.find(".title").html(data.title);
		var userList = "<span>"+data.createDate+" | </span><span class='user' data-id="+data.userId+">"+data.user+" | </span><span>阅读数 "+data.readNum+"</span>";
		main.find(".user-list").html(userList);
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
					loading.hide();
				}
			},
			fail: function(e){
				console.log(e);
			},
			complete: function(){
				
			}
		})
	}
	
	
})()