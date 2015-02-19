$(window).bind("load", function() { 
	
	var footerHeight = 0,
		footer = $("#footer");
	
	
	posFoot();
	
	
	function posFoot(){
		
		if( footer.css("position") != "static" ){
			footerHeight = footer.height() + parseInt(footer.css("paddingTop")) + parseInt(footer.css("paddingBottom")) + parseInt(footer.css("borderTopWidth")) + parseInt(footer.css("borderBottomWidth")) + parseInt(footer.css("marginTop")) + parseInt(footer.css("marginBottom"));
		} else {
			footerHeight = 0;
		}
		
		if( ($(document.body).height()+footerHeight) < $(window).height() ){
			
			footer.css({ "bottom":"0px", "position":"absolute" });
			
		} else {
			
			footer.css({ "position":"static" });
			
		}
		
	}
	
	$(window).resize(posFoot);
	
});