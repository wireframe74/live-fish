$(document).ready(function(){
	$("#headerbasket").load('basketarea.jsp',"");
});

function viewBasket(){
	
	$(".basketNoFlip").fadeOut(300);
	$(".basketFlipper").addClass("open");
	
	
	setTimeout( function(){
	
		$(".basketFlipper").animate({ "height":$(".basketFlip").height()+20 }, 100 );
		
		setTimeout(function(){
			$(".basketFlip").fadeIn(300);
		},300);
		
	}, 300);
	
}

function hideBasket(){

	$(".basketFlip").fadeOut(300);
	
	setTimeout( function(){
	
		$(".basketFlipper").animate({ "height":"50px" }, 100 );
		
		setTimeout( function(){
			$(".basketFlipper").removeClass("open");
			$(".basketNoFlip").fadeIn(300);
		}, 300);
		
	}, 300);

}