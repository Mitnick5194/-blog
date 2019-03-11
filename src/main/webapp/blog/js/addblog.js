(function(){
	var hits = $("#iHitsFrame").getWindow();
	hits.setCloser(false);
	hits.clickbackhide();
	$(document).ready(function(){
		var winwid = $(window).width();
		if(winwid < 768){
			hits.show();
		}
	})
	var labelTemp = "<section><input type='text' /><span class='delLabelBtn'>x</span></section>";
	var labelInputGruop = $("#iInputGruop");
	var form = $("#iForm");
	  CKEDITOR.replace( 'editor' , {
     	 filebrowserImageUploadUrl: "imgupload.do",
     	 language : 'zh-cn',
     	 height: 600
     } );
     
     $("#iBtn").on("click",function(){
    	 submit();
     })
     
     $("#iAddLabelBtn").on("click",function(){
    	 var input = $(labelTemp);
    	 labelInputGruop.append(input).find("input").attr("focus",false);
    	 //需要append到页面之后再聚焦，否则无效
    	 input.find("input").focus();
     })
     
     labelInputGruop.on("click" , ".delLabelBtn" , function(){
    	 $(this).parent("section").remove();
     })
     
     var canClick = true;
     function submit(){
    	 if(!canClick) {
    		 return false;
    	 }
    	 canClick = false;//防止多次点击，提交多次
    	 var title = form.find("input[name=title]").val();
    	 var content = CKEDITOR.instances.editor.getData();
    	 var labels = getLabels();
    	 if(!submitVertify(title , content , labels)){
    		 canClick = true;
    		 return false;
    	 }
    	 var loading = $.showloading("正在发布")
    	 $.ajax({
    		 type: 'post',
    		 url: 'createblog.do',
    		 data:{
    			 title: title,
    			 content: content,
    			 labels: labels
    		 },
    		 success: function(data){
    			 if(data == 200){
    				 $.showToast("发布成功",function(){
        				 location.href = "index.do";
        			 }) 
    			 }else{
    				 $.showToast(data.msg);
    			 }
    		 },
    		 fail: function(e){
    			 $.showToast(e);
    		 },
    		 complete:function(){
    			 canClick = true;
    		 }
    	 })
     }
     
     function getLabels(){
    	 var inputs = $("#iInputGruop").find("input");
    	 if(!inputs.length){
    		 return null;
    	 }
    	 var sb = [];
    	 for(let i=0;i<inputs.length;i++){
    		 var  input = inputs.eq(i);
    		 if(!input.val()){
    			 continue;
    		 }
    		 sb.push(input.val());
    	 }
    	 if(!sb.length){
    		 return null;
    	 }
    	 return sb.join(",");
     }
     
     function submitVertify(title , content , labels){
    	 if(!title || !title.length){
    		 $.showToast("标题不能为空")
    		 return false;
    	 }
    	 if(!content || !content.length){
    		 $.showToast("内容不能为空");
    		 return false;
    	 }
    	 if(!labels || !labels.length){
    		 $.showToast("标签不能为空");
    		 return false;
    	 }
    	 return true;
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