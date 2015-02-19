$(document).ready(function(){
	
	//variables
	var $irMenu = $(".topNav");
	
	var irMenuFade = parseInt($irMenu.attr("data-fade"));
	if( irMenuFade == null ){
		irMenuFade = 0;
	}
	
	var irMenuHeight = parseInt($irMenu.attr("data-height"));
	if( irMenuHeight == null ){
		irMenuHeight = 12;
	}
	
	var irMenuImg = parseInt($irMenu.attr("data-img"));
	if( irMenuImg == null ){
		irMenuImg = 0;
	}
	
	var irMenuImgBg = $irMenu.attr("data-imgBg");
	if( irMenuImgBg == null ){
		irMenuImgBg = "#fff";
	}
	
	
	
	
	//Columns
	$("li ul",$irMenu).each(function(){
		
		var $irMenuUl = $(this);
		
		if( $irMenuUl.children("li").size() > irMenuHeight ){
			
			var irMenuCol = 0;
			$irMenuUl.append("<div class='irMenuCol"+irMenuCol+" irMenuCol'></div>");
			
			
			
			//Just lvl1s
			if( $irMenuUl.children(".irMenuLvl2").size() <= 0 ){
				var i = 0;
				$irMenuUl.children("li").each(function(){
					var $irMenuLi = $(this);
					$irMenuUl.children(".irMenuCol"+irMenuCol).append( $irMenuLi );
					i++;
					if( i >= irMenuHeight ){
						irMenuCol++;
						if( $irMenuUl.children(".irMenuCol"+irMenuCol).size() < 1 ){
							$irMenuUl.append("<div class='irMenuCol"+irMenuCol+" irMenuCol'></div>");
						}
						i = 0;
					}
				});
				$irMenuUl.addClass("irMenuStyle2");
			} else {
			
			
			
				//Calculate groups
				var i = 0;
				var counter = -1;
				var counterArray = [];
				$irMenuUl.children("li").each(function(){
					var $irMenuLi = $(this);
					if( $irMenuLi.hasClass("irMenuLvl1") ){
						if( counter != -1 ){
							counterArray[i] = counter;
							i++;
						}
						counter = 0;
					} else {
						counter++;
					}
				});
				counterArray[i] = counter;
			
				//Mixed 1s + 2s
				i=0;
				var ia = -1;
				var $irMenuLiLast;
				var lastTop = false;
				$irMenuUl.children("li").each(function(){
					var $irMenuLi = $(this);
					if( $irMenuLi.hasClass("irMenuLvl1") ){
						ia++;
						$irMenuLiLast = $(this);
						if( i == 0 ){
							lastTop = true;
						} else {
							lastTop = false;
						}
					}
					var useLast = false;
					if( $irMenuLi.hasClass("irMenuLvl1") && i + (counterArray[ia] + 1) > irMenuHeight && counterArray[ia] + 1 <= irMenuHeight ){
						i = 1000;
					}
					if($irMenuLi.hasClass("irMenuLvl1") && i+1 >= irMenuHeight && counterArray[ia] > 0){
						i = 1000;
						lastTop = true;
					}
					
					if( i >= irMenuHeight ){
						irMenuCol++;
						if( $irMenuUl.children(".irMenuCol"+irMenuCol).size() < 1 ){
							$irMenuUl.append("<div class='irMenuCol"+irMenuCol+" irMenuCol'></div>");
						}
						i = 0;
						var topSpace = false;
						if( !$irMenuLi.hasClass("irMenuLvl1") && !lastTop ){
							
							useLast = true;
							lastTop = true;
							
						}
						if( !$irMenuLi.hasClass("irMenuLvl1") && !useLast ){
							topSpace = true;
							lastTop = true;
						}
					}
					if(useLast){
						$irMenuUl.children(".irMenuCol"+irMenuCol).append( $irMenuLiLast.clone().children("a").append(" (Cont.)").parent() );
						i++;
					}
					else if(topSpace){
						$irMenuUl.children(".irMenuCol"+irMenuCol).append( "<li><a class='irMenuSpacing'>&nbsp;</a></li>" );
						i++;
					}
					$irMenuUl.children(".irMenuCol"+irMenuCol).append( $irMenuLi );
					i++;
				});
				$irMenuUl.addClass("irMenuStyle3");
			
			
			}
			
		} else {
			//No Columns
			$irMenuUl.addClass("irMenuStyle1");
		}
		
		
		
	
	
	
		
		//Images
		if( irMenuImg > 0 ){
			$("li",$irMenuUl).each(function(){
				var $irMenuLi = $(this);
				var irMenuLiImg = $irMenuLi.attr("data-img");
				var irMenuLiImgSize = $irMenuLi.attr("data-imgSize");
				var irMenuLiLvl = parseInt($irMenuLi.attr("class").replace("irMenuLvl",""));
				if( irMenuImg >= irMenuLiLvl ){
					$irMenuLi.children("a").append("<div class='irMenuImg' style='background:url("+irMenuLiImg+") center center no-repeat "+irMenuImgBg+";width:"+irMenuLiImgSize+"px;height:"+irMenuLiImgSize+"px;' ></div>");
					$irMenuLi.addClass("irMenuImg");
				}
			});
		}
		
		
		
		
		
		
		//Menu Positioning
		var irMenuWidth = $irMenu.width() + parseInt($irMenu.css("paddingLeft")) + parseInt($irMenu.css("paddingRight")) + parseInt($irMenu.css("border-left-width")) + parseInt($irMenu.css("border-right-width"));
		var irMenuUlWidth = $irMenuUl.width() + parseInt($irMenuUl.css("paddingLeft")) + parseInt($irMenuUl.css("paddingRight")) + parseInt($irMenuUl.css("border-left-width")) + parseInt($irMenuUl.css("border-right-width"));
		var irMenuUlLeft = $irMenuUl.parent().offset().left - $irMenu.offset().left;
		if( irMenuWidth < irMenuUlWidth ){
			var irLeft =  (0 - irMenuUlLeft) - (( irMenuUlWidth - irMenuWidth ) / 2 );
			$irMenuUl.css({"left":irLeft});
		}
		else if( irMenuUlWidth + irMenuUlLeft > irMenuWidth ){
			var irLeft = (0 - irMenuUlLeft) + (irMenuWidth - irMenuUlWidth);
			$irMenuUl.css({"left":irLeft});
		}
		
		
		
		
		
	});
	
	
	
	
	
	
	
	
	
	
	//Hover Trigger
	$(".topNav > li > *").hover(function(){
		$(this).addClass("hov");
		irMenuHover($(this),irMenuFade);
	},function(){
		$(this).removeClass("hov");
		irMenuHover($(this),irMenuFade);
	});
	
	
	
	
	
});



//Show/Hide Menu
function irMenuHover($hover, irMenuFade){
	var $hoverUl = $hover.parent().children("ul");
	if( $hover.parent().children(".hov").size() > 0 ){
		$hover.parent().addClass("irMenuOpen");
		$hoverUl.stop().fadeTo(irMenuFade/4, 1);
		$hoverUl.css({"display":"block"});
	} else {
		$hover.parent().removeClass("irMenuOpen");
		$hoverUl.stop().fadeTo(irMenuFade, 0, "linear", function(){$hoverUl.css({"display":"none"})} );
	}
}
