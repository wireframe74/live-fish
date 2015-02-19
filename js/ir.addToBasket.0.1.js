$(document).bind('reveal.facebox', function() {document.getElementById('facebox').style.display="none"; $("#facebox").toggle( "bounce",{times:3, distance:10} ,30); })

var url_addProductToBasket = 'template/components/stocklistingaddtobasket.jsp';

var url_tabController = 'template/components/stockdetailtabarea.jsp';

var url_stockdetailvalidation = 'template/components/stockdetailvalidation.jsp';

var url_stocklistingquantityarea ='template/components/stocklistingquantityarea.jsp';
var url_stockdetailprimaryimage = 'template/components/stockdetailprimaryimage.jsp';
var url_stockdetailstockindicator = 'template/components/stockdetailstockindicator.jsp';
var url_stockdetailoptionlist = 'template/components/stockdetailoptionlist.jsp';
var url_basketarea = 'basketarea.jsp';

function addToBasket(type,seq,vaId){
	
	if(type==0){
		btnOrigHtml = $('#addbutton_'+type+'_'+seq).html();
		$('#addbutton_'+type+'_'+seq).html("adding...");
		$('#addbutton_'+type+'_'+seq).attr("disabled","disabled");
		$('#addbutton_'+type+'_'+seq).css({"backgroundColor":"#999"});
	}
	else if(type==3){
		btnOrigHtml = $('.buttonaddtobasket').html();
		$('.buttonaddtobasket').html("adding...");
		$('.buttonaddtobasket').attr("disabled","disabled");
		$('.buttonaddtobasket').css({"backgroundColor":"#999"});
	}

	qty = document.getElementById('qtyPlusMinus'+seq).value

	$.ajax({
		url: url_addProductToBasket,
		context: document.body,
		data: "seq="+ seq +"&qty="+ qty +"&vaId="+ vaId +"&type=" + type,
		dataType: "text",
		success: function(data){updateBasketAdd(type, seq, qty, vaId, data)}
	});
}

function updateBasketAdd(type, seq, qty, vaId, data1){
	$("#pagevalidation_ajax").load(url_stockdetailvalidation, "")
	
	if (type == 3) {
		$("#stockindicatorAjax").load(url_stockdetailstockindicator , "")
	} else{
		$("#ajaxStockListingQuantityArea"+seq).load(url_stocklistingquantityarea + '?seq=' + seq + '&type=' + type, "")
	}
	
	updateMiniBasket(type, seq);
	return false;
}

function updateMiniBasket(type, seq){
		
	if(type==0){
		$('#addbutton_'+type+'_'+seq).html(btnOrigHtml);
		$('#addbutton_'+type+'_'+seq).removeAttr("disabled");
		$('#addbutton_'+type+'_'+seq).removeAttr("style");
	}
	else if(type==3){
		$('.buttonaddtobasket').html(btnOrigHtml);
		$('.buttonaddtobasket').removeAttr("disabled");
		$('.buttonaddtobasket').removeAttr("style");
	}
	$("#headerbasket").load(url_basketarea,"");
	
}

function calcupdateOptions(optlevkey, emptytxt){

	$.ajax({
		url: url_stockdetailoptionlist,
		context: document.body,
		data: "emptytxt="+ emptytxt + "&optlevkey=" + optlevkey,
		dataType: "text",
		success: function(data){updateOptions(data);}
	});

}

function updateOptions(data) {
	$('#optionListAjax').html(data);
}

function updateTabs(tab){
	$("#tabsholder").load(url_tabController + '?tab='+tab + " #tabsholder>*", "", function(){$(".tab_container").wrap("<div class='tabBorder'></div>")});
	return false;
}

function updatePrimaryImage(imageid) {
	$("#ajax_image_wrap").load(url_stockdetailprimaryimage + '?imageId='+ imageid + " #ajax_image_wrap>*", "");
}

function imageZoom(largeImageName) {
	$.facebox({ajax:"zoomwrapper.jsp" + "?imagename=" +largeImageName});
}


/* basket and product detail quantity changer */
function qty_plus(whichLayer, max) {
	var qty = document.getElementById(whichLayer);
	
	if (!max) {
		max = 99;
	}
	
	if (qty.value < max) {
		qty.value = parseInt(qty.value) + 1;
	}
}

function qty_minus(whichLayer, min) {
	var qty = document.getElementById(whichLayer);
	
	if (!min) {
		min = 0;
	}
	
	if (qty.value > min) {
		qty.value = parseInt(qty.value) - 1;
	}
}
