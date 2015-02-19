if($(".irBanHold").length){
	if( $('.irBanHold').attr("data-width") ){
		var banWidth = $('.irBanHold').attr("data-width");
	}
	else{
		var banWidth = 960;
	}
	if( $('.irBanHold').attr("data-height") ){
		var banHeight = $('.irBanHold').attr("data-height");
	}
	else{
		var banHeight = 400;
	}
	if( $('.irBanHold').attr("data-delay") ){
		var banDelay = $('.irBanHold').attr("data-delay");
	}
	else{
		var banDelay = 5000;
	}
	if( $('.irBanHold').attr("data-scroll") ){
		if( $('.irBanHold').attr("data-scroll") == "false" ){
			var banScroll = false;
		}
		else{
			var banScroll = true;
		}
	}
	else{
		var banScroll = false;
	}
	if( $('.irBanHold').attr("data-arrow") ){
		if( $('.irBanHold').attr("data-arrow") == "false" ){
			var banArrow = false;
		}
		else{
			var banArrow = true;
		}
	}
	else{
		var banArrow = false;
	}
	if( $('.irBanHold').attr("data-fullwidth") ){
		if( $('.irBanHold').attr("data-fullwidth") == "false" ){
			var banFullWidth = false;
		}
		else{
			var banFullWidth = true;
		}
	}
	else{
		var banFullWidth = false;
	}
}
else{
	var banWidth = 960;
	var banHeight = 400;
	var banDelay = 5000;
	var banScroll = false;
	var banArrrow = false;
	var banFullWidth = false;
}

var banImgNum;
var banPause = false;

$(document).ready(function(){

	$('.irBanHold').css({"width":banWidth,"height":banHeight});
	
	banImgNum = $('.irBanHold').children('.irBan').length;
	
	if( banArrow ){
		$('.irBanHold').append("<div class='irBanPrev'></div><div class='irBanNext'></div>");
		var arrowOffset = (banHeight/2)-50;
		$('.irBanPrev').css({"top":arrowOffset+"px"});
		$('.irBanNext').css({"top":arrowOffset+"px"});
	}
	
	$('.irBanHold').append('<div class="irBanDots"></div>');
	for( i=1 ; i <= banImgNum ; i++ ){
		if( i == 1 ){
			var active = " active";
		}
		else{
			var active = "";
		}
		$('.irBanDots').append('<div class="dot'+i+active+' irBanDot"></div>');
	}
	
	$('.irBanDots').stop().fadeTo(0,0.2);
	$('.irBanPrev').stop().fadeTo(0,0.2);
	$('.irBanNext').stop().fadeTo(0,0.2);
	
	
	
	$('.irBanDot').hover(function(){
		if( !$(this).hasClass('active') ){
			$(this).stop().fadeTo(100,0.7);
		}
	},function(){
		if( !$(this).hasClass('active') ){
			$(this).stop().fadeTo(500,0.4);
		}
	});
	
	$('.irBanNext').hover(function(){
		$(this).stop().fadeTo(100,1);
	},function(){
		$(this).stop().fadeTo(500,0.5);
	});
	
	$('.irBanPrev').hover(function(){
		$(this).stop().fadeTo(100,1);
	},function(){
		$(this).stop().fadeTo(500,0.5);
	});
	
	
	$('.irBanHold').hover(function(){
		$('.irBanDots',this).stop().fadeTo(500,1);
		$('.irBanPrev',this).stop().fadeTo(500,0.5);
		$('.irBanNext',this).stop().fadeTo(500,0.5);
		banPause = true;
	},function(){
		$('.irBanDots',this).stop().fadeTo(500,0.2);
		$('.irBanPrev',this).stop().fadeTo(500,0.2);
		$('.irBanNext',this).stop().fadeTo(500,0.2);
		banPause = false;
	});
	
	
	$('.irBanDot').click(function(){
		var dotNum = parseInt($(this).attr("class").replace("dot",""));
		
		if(!$(this).hasClass('active')){
		
			if( !banScroll ){
				banImgFade(dotNum);
			}
			else{
				banImgScroll(dotNum);
			}
			
		}
		
	});
	
	
	$('.irBanNext').click(function(){
		if( banImgNum > 1 ){
			var curImg = parseInt($('.irBanDots .active').attr('class').replace("dot",""));
			if( curImg == banImgNum ){
				curImg = 1;
			}
			else{
				curImg = curImg+1;
			}
			if( banScroll ){
				banImgScroll(curImg);
			}
			else{
				banImgFade(curImg);
			}
		}
	});
	$('.irBanPrev').click(function(){
		if( banImgNum > 1 ){
			var curImg = parseInt($('.irBanDots .active').attr('class').replace("dot",""));
			if( curImg == 1 ){
				curImg = banImgNum;
			}
			else{
				curImg = curImg-1;
			}
			if( banScroll ){
				banImgScrollPrev(curImg);
			}
			else{
				banImgFade(curImg);
			}
		}
	});
	
	if( banImgNum > 1 ){
		setTimeout(function(){
			banLoop();
		},banDelay);
	}
	
	if( banFullWidth ){
		
		$("body").css({"overflowX":"hidden"});
		
		var banSideSize = (3000 - banWidth) / 2;
		
		$(".irBanHold").css({"width":"3000px", "position":"relative", "left":-banSideSize, "textAlign":"center"});
		
		$(".irBanHold").addClass("banFull");
		
	}
});



function banImgFade(img){
	
	$('.irBanHold .ban'+img).css({"zIndex":"4"});
	$('.irBanHold .ban'+img).show();
	$('.irBanHold .irBan.active').fadeOut(500);
	$('.irBanDots .dot'+img).fadeTo(500,1);
	$('.irBanDots .active').fadeTo(500,0.4);
	$('.irBanDots .active').removeClass('active');
	$('.irBanDots .dot'+img).addClass('active');
	
	setTimeout(function(){
		$('.irBanHold .irBan.active').css({"zIndex":"1"});
		$('.irBanHold .irBan.active').hide();
		$('.irBanHold .irBan.active').fadeIn(0);
		$('.irBanHold .ban'+img).css({"zIndex":"5"});
		$('.irBanHold .irBan.active').removeClass('active');
		$('.irBanHold .ban'+img).addClass('active');
	},500);
}

function banImgScroll(img){

	if( banFullWidth ){
		banImgFade(img);
	}
	else{
	
		$('.irBanHold .ban'+img).css({"zIndex":"4","marginLeft":banWidth+"px"});
		$('.irBanHold .ban'+img).show();
		$('.irBanHold .irBan.active').animate({"marginLeft":"-"+banWidth+"px"},500);
		$('.irBanHold .ban'+img).animate({"marginLeft":"0px"},500);
		$('.irBanDots .dot'+img).fadeTo(500,1);
		$('.irBanDots .active').fadeTo(500,0.4);
		$('.irBanDots .active').removeClass('active');
		$('.irBanDots .dot'+img).addClass('active');
		
		setTimeout(function(){
			$('.irBanHold .irBan.active').css({"zIndex":"1","marginLeft":"0px"});
			$('.irBanHold .irBan.active').hide();
			$('.irBanHold .ban'+img).css({"zIndex":"5"});
			$('.irBanHold .irBan.active').removeClass('active');
			$('.irBanHold .ban'+img).addClass('active');
		},500);
	
	}
}

function banImgScrollPrev(img){

	if( banFullWidth ){
		banImgFade(img);
	}
	else{
	
		$('.irBanHold .ban'+img).css({"zIndex":"4","marginLeft":"-"+banWidth+"px"});
		$('.irBanHold .ban'+img).show();
		$('.irBanHold .irBan.active').animate({"marginLeft":banWidth+"px"},500);
		$('.irBanHold .ban'+img).animate({"marginLeft":"0px"},500);
		$('.irBanDots .dot'+img).fadeTo(500,1);
		$('.irBanDots .active').fadeTo(500,0.4);
		$('.irBanDots .active').removeClass('active');
		$('.irBanDots .dot'+img).addClass('active');
		
		setTimeout(function(){
			$('.irBanHold .irBan.active').css({"zIndex":"1","marginLeft":"0px"});
			$('.irBanHold .irBan.active').hide();
			$('.irBanHold .ban'+img).css({"zIndex":"5"});
			$('.irBanHold .irBan.active').removeClass('active');
			$('.irBanHold .ban'+img).addClass('active');
		},500);
	
	}
	
}


function banLoop(){
	
	if( !banPause ){
		var curImg = parseInt($('.irBanDots .active').attr('class').replace("dot",""));
		if( curImg == banImgNum ){
			curImg = 1;
		}
		else{
			curImg = curImg+1;
		}
		
		if( !banScroll ){
			banImgFade(curImg);
		}
		else{
			banImgScroll(curImg);
		}
	}
	
	setTimeout(function(){
		banLoop();
	},banDelay)
}