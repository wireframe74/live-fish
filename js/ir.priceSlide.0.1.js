var psMaxPrice = 150;
var psPrice1 = 0;
var psPrice2 = 0;
var psBarPx = 0;

$(document).ready(function(){
	
	if( $(".psHold") ){
		
		var psRMaxPrice = parseInt($(".psHold").attr("ir-max-price"));
		
		if( psRMaxPrice > 0 ){
			psMaxPrice = psRMaxPrice;
		}
		
		psPrice1 = $("#psPrice1").val();
		psPrice2 = $("#psPrice2").val();
		
		psBarPx = $(".psBar").width();
		
		if( psPrice2 == 0 ){
			$("#psPrice2").val(psMaxPrice);
		}
		
	}
	
	var psMark1 = false;
	var psMark2 = false;

    $(".psSlider").mousemove(function(e) {
		
		var offsetLeft = e.pageX - $(this).position().left;
	
		if( psMark1 ){
		
			if( offsetLeft <= 0 ){
				offsetLeft = 0;
			}
			if( offsetLeft >= parseInt($(".psMark2").css("left")) - ($(".psMark2").width()+2) ){
				offsetLeft = parseInt($(".psMark2").css("left")) - ($(".psMark2").width()+2);
			}
			
			$(".psMark1").css({"left":offsetLeft+"px"});
			$(".psBarFill").css({"left":offsetLeft+"px"});
		
			psBarDrag( parseInt($(".psMark1").css("left")), parseInt($(".psMark2").css("left")) );
		}
	
		if( psMark2 ){
		
			if( offsetLeft >= psBarPx){
				offsetLeft = psBarPx;
			}
			if( offsetLeft <= parseInt($(".psMark1").css("left")) + ($(".psMark1").width()+2) ){
				offsetLeft = parseInt($(".psMark1").css("left")) + ($(".psMark1").width()+2);
			}
			
			var offsetRight = psBarPx - offsetLeft;
			
			$(".psMark2").css({"left":offsetLeft+"px"});
			$(".psBarFill").css({"right":offsetRight+"px"});
		
			psBarDrag( parseInt($(".psMark1").css("left")), parseInt($(".psMark2").css("left")) );
		}
		
    });

    $(".psMark1").mousedown(function(e) {
		e.preventDefault();
        psMark1 = true;
    });
	$(".psMark2").mousedown(function(e) {
		e.preventDefault();
        psMark2 = true;
    });
    $(document).mouseup(function(){
        psMark1 = false;
        psMark2 = false;
    });
	
	$(".priceInput").on('input', function() {
		psBarInput();
	});
	
	psBarInput();
});

function psBarDrag(px1, px2){
	
	var psBarPx = $(".psBar").width();
	var psBarPxPer1 = psBarPx / 100;
	var psBarPricePer1 = psMaxPrice / 100;
	
	var px1Per = px1 / psBarPxPer1;
	var psP1 = psBarPricePer1 * px1Per;
	
	$("#psPrice1").val(parseInt(psP1))
	
	var px2Per = px2 / psBarPxPer1;
	var psP2 = psBarPricePer1 * px2Per;
	
	$("#psPrice2").val(parseInt(psP2));

}

function psBarInput(){
	
	psPrice1 = $("#psPrice1").val();
	psPrice2 = $("#psPrice2").val();
	
	var psBarPricePer1 = psMaxPrice / 100;
	
	var p1Per = psPrice1 / psBarPricePer1;
	var p2Per = psPrice2 / psBarPricePer1;
	
	var psBarPx = $(".psBar").width();
	var psBarPxPer1 = psBarPx / 100;
	
	var p1px = psBarPxPer1 * p1Per;
	var p2px = psBarPxPer1 * p2Per;
	
	if( p1px <= 0 ){
		p1px = 0;
	}
	
	if( p2px >= psBarPx ){
		p2px = psBarPx;
	}
	
	if( p1px >= p2px - ($(".psMark2").width()+2) ){
		p1px = 0;
	}
	
	if( p2px <= p1px + ($(".psMark1").width()+2) ){
		p2px = psBarPx;
	}
	
	$(".psMark1").css({"left":p1px+"px"});
	$(".psBarFill").css({"left":p1px+"px"});
	
	var psRightPx = psBarPx - p2px;
	
	$(".psMark2").css({"left":p2px+"px"});
	$(".psBarFill").css({"right":psRightPx+"px"});
}



function psSubmit(){
	
	psPrice1 = $("#psPrice1").val();
	psPrice2 = $("#psPrice2").val();
	psPriceDesc = $("#psPriceDesc").val();
	psPriceExtras = $("#psPriceExtras").val();
	
	var psLinkString = "?price1=" + psPrice1 + "&price2=" + psPrice2 + "&priceDesc=" + psPriceDesc + psPriceExtras;
	
	window.location = psLinkString;
	
	return false;
	
}