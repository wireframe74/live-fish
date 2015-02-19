$(document).ready(function(){
	$("#headerbasket").load('basketarea.jsp',"");
});

function toggleMiniBasket(){

	var $mbh = $(".miniBasketHold");
	var $mb = $mbh.children(".miniBasket");
	
	
	if( $mbh.hasClass("open") ){
		
		$mbh.removeClass("open");
		$mb.animate({"height":"0"}, 400);
		
		
	} else {
		
		$mbh.addClass("open");
		$mb.height("auto");
		var mbHeight = $mb.height();
		$mb.height(0);
		$mb.animate({"height": mbHeight },400);
		
	}
	
	if( $("#basketName").attr("data-html") != null && $("#basketName").attr("data-html") != "" ){
		var basketName = $("#basketName").html();
		$("#basketName").html( $("#basketName").attr("data-html") );
		$("#basketName").attr("data-html",basketName);
	}
	
}