$(document).ready(function(){
	
	var minHide = "6";
	if( $("irRefine").length > 0 && parseInt($("irRefine").attr("minHide"))	>= 0 ){
		minHide = parseInt($("irRefine").attr("minHide"));
	}
	$("irRefine").remove();
	
	if( $("#refinefurther").length > 0 ){
	
		var refineHtml = $("#refinefurther").html().replace(/\[/g,"(").replace(/\]/g,")");
		$("#refinefurther").html(refineHtml);
		
		$("#refinefurther > div").each(function(){
			if( $(this).attr("id") != null && $(this).attr("id").indexOf("taghdrsearch") < 0 && $(this).attr("id") != "refinetitle" ){ //Loop Menus
				
				var hasSelected = false;
				var items = 0;
				
				if( $(this).attr("id") == "refinceCategories" ){
					
					hasSelected = "true";
					
				}
				
				$(".refineitems ul li", this).each(function(){ //Loop Tags
					
					if( $(this).hasClass("selected") ){
						hasSelected = true;
					}
					items += 1;
					
				});
				
				$(this).addClass("irRefHidden");
				$(".refinehead", this).addClass("irRefClick");
				$(".refineitems", this).height( parseInt( $(".refineitems ul", this).height() ) );
				$(".refineitems", this).css({"overflow":"hidden","transition":"ease-in-out 400ms"});
				
				if( items >= minHide && !hasSelected ){
					$(".refinehead", this).addClass("irRefClose");
					$(".refineitems", this).height("0px");
				}
				
			}
		});
		
	}
	
	$(".irRefHidden .refinehead").click(function(){
		
		if( $(this).hasClass("irRefClose") ){
		
			$(this).next(".refineitems").height( parseInt($(this).next(".refineitems").children("ul").height()) );
			
			$(this).removeClass("irRefClose");
			
		}else{
		
			$(this).next(".refineitems").height("0px");
			
			$(this).addClass("irRefClose");
			
		}
	
	});
	
});