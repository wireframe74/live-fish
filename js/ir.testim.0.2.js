$(document).ready(function(){
	if( $('.ir-testim').length ){
	
		var irQuote1 = "";
		var irQuote2 = "";
		if( $('.ir-testim').attr('ir-quote') != "false" ){
			irQuote1 = "<strong>&ldquo;</strong>";
			irQuote2 = "<strong>&rdquo;</strong>";
		}
		
		if( $('.ir-testim').attr('ir-fade')=="false" ){
		
			for( x=1 ; x <= $('.ir-testim').attr('ir-amount') ; x++ ){
				var countTst = $('.ir-testim div').length;			
				var displayTst = Math.floor((Math.random()*countTst)+1);
				
				var i = 1;
				$('.ir-testim div').each(function(){
					$(this).attr('id','testim'+i);
					i=i+1;
				});
				
				var tstTxt = $('.ir-testim #testim'+displayTst).html();
				var tstBy = $('.ir-testim #testim'+displayTst).attr('testim-by');
				$('.ir-testim #testim'+displayTst).remove();
				
				$('.ir-testim').append('<p>'+irQuote1+tstTxt+irQuote2+'</p><span>- '+tstBy+'</span>');
			}
			
			$('.ir-testim div').remove();
			
		}
		
		
		if( $('.ir-testim').attr('ir-fade')=="true" ){
		
			var i = 1;
			$('.ir-testim div').each(function(){
				var tstTxt = $(this).html();
				var tstBy = $(this).attr('testim-by');
				$(this).remove();
				
				$('.ir-testim').append('<div id="testim'+i+'"><p>'+irQuote1+tstTxt+irQuote2+'</p><span>- '+tstBy+'</span></div>');
				i=i+1;
			});
			
			$('.ir-testim div').wrapAll('<div class="testimHold"></div>');
			
			var tstMaxHeight = 0;
			$('.testimHold div').each(function(){
				var tstHeight = $(this).height();
				if( tstHeight >= tstMaxHeight ){ tstMaxHeight=tstHeight; }
			});
			
			$('.testimHold').height(tstMaxHeight);
			
			$('.testimHold div').fadeTo(0,0);
			$('.testimHold div').hide();
			$('.testimHold #testim1').show(0);
			$('.testimHold #testim1').fadeTo(0,1);
			
			var countTst = $('.testimHold div').length;
			setTimeout(function(){ loopTestim(1,countTst); },10000);
			
		}
		
		
	}
});

function loopTestim(x,l){
		
	$('.testimHold #testim'+x).fadeTo(500,0);
	
	setTimeout(function(){
		$('.testimHold #testim'+x).hide(0);
		if(x!=l){ x=x+1; }else{x=1;}
		$('.testimHold #testim'+x).show(0);
		$('.testimHold #testim'+x).fadeTo(500,1);
	}, 500);
	
	setTimeout(function(){ loopTestim(x,l); },10000);
	
}