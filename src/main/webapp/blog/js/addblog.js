(function(){
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
    	 labelInputGruop.append(input);
     })
     
     labelInputGruop.on("click" , ".delLabelBtn" , function(){
    	 $(this).parent("section").remove();
     })
     
     function submit(){
    	 var title = form.find("input[name=title]").val();
    	 var content = CKEDITOR.instances.editor.getData();
    	 var labels = getLabels();
    	 if(!submitVertify(title , content , labels)){
    		 return false;
    	 }
    	 $.ajax({
    		 type: 'post',
    		 url: 'createblog.do',
    		 data:{
    			 title: title,
    			 content: content,
    			 labels: labels
    		 },
    		 success: function(data){
    			 console.log(data);
    		 },
    		 fail: function(){
    			 
    		 },
    		 complete:function(){
    			 
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
    		 alert("标题不能为空")
    		 return false;
    	 }
    	 if(!content || !content.length){
    		 alert("内容不能为空");
    		 return false;
    	 }
    	 if(!labels || !labels.length){
    		 alert("标签不能为空");
    		 return false;
    	 }
    	 return true;
     }
     
})()