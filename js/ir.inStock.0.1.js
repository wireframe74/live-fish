$(document).ready(function(){
	
	if( $('.component_stockdetail').length && !$(".stockStatus i").length ){
		
		var stockHtml = $('.stockStatus').html();
		var stockQty = parseInt($('form[name="qtyform"] input[name="sqty"]').val());
		
		if( stockQty > 0 ){
		
			$('.stockStatus').html(stockQty+" "+stockHtml);
		
		}
		
	}
	
});



