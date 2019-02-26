(function(){
	var BODY = $(document.body);
	var DOC = $(document);
	$.extend($.fn , {
		getWindow: function(){
			return new WindowPlugin(this);
		},


	})

	$.extend($,{
		showToast: function(msg,delay,callback){
			showmsg(msg,delay,callback);
		},
		showloading: function(msg,delay,callback){
			return showloading(msg,delay,callback);
		}
	})

	function showmsg(msg,delay,callback){
		showmsgExt({
			msg: msg,
			delay: delay || 1000,
			icon: 'none'
		})
	}

	function showloading(msg,delay,callback){
		return new showmsgExt({
			msg: msg,
			delay: delay ||0,
			icon: 'loading'
		})
	}


	/**交互提示框，注意，每一时刻只能显示一种，如果同时出现两种，则第一种会隐藏，如loading中需要显示showToast
	* 则loading自动隐藏
	*/
	function showmsgExt(options){
	var opts = $.extend({
		msg: '',//显示的内容
		delay: 0,//消失时间，默认不消失
		icon: 'none',//图标，支持 succ loading warming
	},options)
	var instance = $.MsgInstance;
	if(instance){ //当已经有显示框了，先把它隐藏了，在构造新的
		instance.hide();
	}
	/*var mark = $("<div>").addClass("show-msg-mark");
	mark.appendTo("BODY");*/
	var modal = $("<div/>").addClass("show-msg-modal");
	modal.appendTo(BODY);
	var dialog = $("<div/>").addClass("show-msg-dialog");
	dialog.addClass("modal-dialog-show").appendTo(BODY);
	var content = $("<div/>").html(opts.msg);
	content.appendTo(dialog);
	if('none' != opts.icon){
		var width = DOC.width() * 0.3; //窗口的30% 最大200px
		width = width > 200 ? 200 : width
		var height = width;
		dialog.css({
			width: width,
			height:height
		})
		adjustCenter(dialog,width,height);
		var icon = $("<div/>").addClass("show-msg-loading-icon").appendTo(dialog);
		if(opts.icon == 'loading'){
			var iconHeight = height *0.7;
			icon.css({height: iconHeight});
			var itemHeight = iconHeight * 0.13;
			for(let i=0;i<12;i++){
				var delay = i*(1/12)-1; //因为动画的执行时间是1s，所以第一个应该在-1秒的时候就执行，不然的话会等待一秒后才执行
				icon.append($("<div/>").addClass("loading-item").css({
					'animation-delay':+delay+'s',
					'-webkit-animation-delay':+delay+'s', /* Safari 和 Chrome */
					'transform': 'rotate('+ i * 30 + 'deg) translate(0, -142%)',
					'-webkit-transform': 'rotate(' + i * 30 + 'deg) translate(0, -142%)',
					"height":itemHeight,
					"top": (itemHeight*4)+"px",
				}));
			}
			var contentPosi = (height - iconHeight ) / 2;
			content.css({
				bottom: contentPosi+"px"
			}).addClass("content-text-icon")
		}
	}else{
		//loading情况
		content.addClass("content-text")
		dialog.css({
			width:"normal",
			height:"normal"
		})
		dialog.css({
			"max-width": "80%"
		})
		adjustCenter(dialog);
	}
	
	var delay = opts.delay;
	if(delay > 0){
		setTimeout(function(){
			hide();
		},delay)
	}
	var callbacks = options.callbacks ||{};

	/**添加action（如hide）动作的回调 */
	this.addCallback = function(action,fn){
		callbacks[action] = fn;
	}

	function hide(callback){
		if(!dialog)
			return;
		dialog.removeClass("modal-dialog-show");
		dialog.addClass("modal-dialog-hide");
		setTimeout(function(){
			dialog && dialog.hide();
			modal && modal.hide();
			destory();
			$.MsgInstance = null;//消除实例
			typeof callback=== "function" && callback();
			typeof callbacks["hide"] === "function" && callbacks["hide"]();
		},200)
	}

	function show(callback){
		dialog.addClass("modal-dialog-show")
		modal.show();
		dialog.show();
		typeof callback === "function" && callback();
		typeof callbacks["show"] === "function" && callbacks["show"]();
	}

	function destory(){
		dialog.remove();
		modal.remove();
		content.remove();
		dialog = null;
		modal = null;
		content = null;
		$.MsgInstance = null;
		typeof callbacks["destory"] === "function" && callbacks["destory"]();
	}


	this.getModal = function(){
		return modal;
	}

	this.show = function(callback){
		show(callback);
	}

	this.hide = function(callback){
		hide(callback);
	}
	this.destory = function(){
		destory();
	}
	//$.MsgType = opts.icon == 'none' ? 'loading' : opts.icon;
	$.MsgInstance = this; //保存一下实例，当下一个实例进来时，判断当前是否已经存在实例，存在则先销毁
}

/**
 *
 * 将绝对定位元素ele设置为中间显示
 *
 */
 function adjustCenter(ele,width,height){
 	var elem = $(ele);
 	width = width || elem.width();
 	height = height || elem.height();
 	var docWidth = $(document).width();
 	var docHeight = $(document).height();
 	var left =(docWidth - width)/2;
 	var top = (docHeight - height)/2;
 	elem.css({
 		left: left,
 		top: top
 	})
 }

/**
 * 弹窗
 * 
 * @param ele 弹出个内容元素
 */
 function WindowPlugin(ele) {
 	var content = $(ele);
 	var win = $(window);
 	var plugin = this;
 	var mask = $("<div/>").addClass("window-plugin-background").appendTo(BODY);
 	var dialog = $("<div/>").addClass("window-plugin-dialog").appendTo(BODY);
 	var closer = $("<span/>").addClass("window-plugin-closer").appendTo(dialog).attr("title", "关闭");
 	content.appendTo(dialog);
	var clickbackhide = false; //点击背景关闭 默认不关闭
	var callbackafterclose; //关闭后回调
	this.setCallbackafterclose = function (callbackafterclose) {
		this.callbackafterclose = callbackafterclose;
	}
	this.clickbackhide = function() {
		clickbackhide = true;
		if(clickbackhide) {
			mask.bind("click" , function() {
				mask.attr("title" , "关闭");
				plugin.hide();
			});
		}
	}
	this.show = function() {
		mask.show();
		dialog.show();
		mask.removeClass("modal-background-hide");
		dialog.removeClass("modal-dialog-hide");
		mask.addClass("modal-background-show");
		dialog.addClass("modal-dialog-show");	
		center();
	}
	this.hide = function(callback) {
		mask.removeClass("modal-background-show");
		dialog.removeClass("modal-dialog-show");
		mask.addClass("modal-background-hide");
		dialog.addClass("modal-dialog-hide");
		setTimeout(function() {
			hideWindow(callback);
		} , 500)
	}
	this.setCloser = function(bool) { //显示||隐藏X关闭图标
		var b = typeof bool ==='boolean' ? bool :  true;
		if(b) {
			closer.show();
		}else {
			closer.hide();
		}
	}
	this.center = function(){
		center();
	}
	
	if(clickbackhide) {
		mask.bind("click" , function() {
			mask.attr("title" , "关闭");
			plugin.hide();
		});
	}
	
	function hideWindow(callback) {
		mask.hide();
		dialog.hide();
		if(typeof callback ==='function') {
			callback();
		}
		 //关闭后回调，用于不直接在外部调用hide(callback)函数关闭窗体时的回调（如点击背景modal关闭 ， 点击右上角X关闭）
		 if(callbackafterclose){
		 	if(typeof callbackafterclose ==='function'){
		 		callbackafterclose();
		 	}
		 }
		}
		closer.bind("click" , function() {
			plugin.hide();
		})
	function center(){ //使居中
		var height = DOC.height();
		var width = DOC.width();
		var dialogHeight = dialog.height();
		var dialogWidth = dialog.width();
		console.log(height+"  "+width);
		console.log(dialogHeight+"  "+dialogWidth);
		var top , left;
		if(dialogHeight > height){
			top = 0;
		}else{
			top = (height - dialogHeight) / 2;
		}
		if(dialogWidth > width){
			left = 0;
		}else{
			left = (width - dialogWidth) / 2;
		}

		dialog.css({
			top: top+"px",
			left: left+"px"
		})
	}
	win.bind("resize" , function() {
		if(dialog.is(":visible")) {
			center();
			mask.css({
				height: win.height(),
				width: win.width()
			})
		}
	});
}
})()
