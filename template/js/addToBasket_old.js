$(document).bind('reveal.facebox', function() {document.getElementById('facebox').style.display="none"; $("#facebox").toggle( "bounce",{times:3, distance:10} ,30); })

var url_addProductToBasket = 'template/components/stocklistingaddtobasket.jsp';

var url_tabController = 'template/components/stockdetailtabarea.jsp';

var url_stockdetailvalidation = 'template/components/stockdetailvalidation.jsp';

var url_stocklistingquantityarea ='template/components/stocklistingquantityarea.jsp';
var url_stockdetailprimaryimage = 'template/components/stockdetailprimaryimage.jsp';
var url_stockdetailstockindicator = 'template/components/stockdetailstockindicator.jsp';
var url_stockdetailoptionlist = 'template/components/stockdetailoptionlist.jsp';
var url_basketarea = 'basketarea.jsp';

function addToBasket(type,seq,vaId)
{
 qty = document.getElementById('qtyPlusMinus'+seq).value

 $.ajax({
  url: url_addProductToBasket,
  context: document.body,
  data: "seq="+ seq +"&qty="+ qty +"&vaId="+ vaId +"&type=" + type,
  dataType: "text",
  success: function(data){updateBasketAdd(type, seq, qty, vaId, data)}
 });
}

function updateBasketAdd(type, seq, qty, vaId, data1)
{
 $("#pagevalidation_ajax").load(url_stockdetailvalidation, "")
 if (type == 3) {
	$("#stockindicatorAjax").load(url_stockdetailstockindicator , "")
 } else{
	$("#ajaxStockListingQuantityArea"+seq).load(url_stocklistingquantityarea + '?seq=' + seq + '&type=' + type, "")
 }
	updateMiniBasket();
 return false;
}

function updateMiniBasket(){
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

$("#tabsholder").load(url_tabController + '?tab='+tab + " #tabsholder>*", "");
 return false;
}

function updatePrimaryImage(imageid) {
$("#ajax_image_wrap").load(url_stockdetailprimaryimage + '?imageId='+ imageid + " #ajax_image_wrap>*", "");
}

function imageZoom(largeImageName) {
	$.facebox({ajax:"zoomwrapper.jsp" + "?imagename=" +largeImageName});
}

function generateBasketProgressBar(percentage) {
	$( "#basketprogressbar" ).progressbar({value: percentage});
} 