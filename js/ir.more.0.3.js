var twoHeight = [];
var openText = [];
var closeText = [];
var i = 0;

$(document).ready(function(){
	$('.irMore').each(function(){
		twoHeight[i] = $('.irMoreTwo',this).height();
		openText[i] = $(this).attr("data-open");
		closeText[i] = $(this).attr("data-close");
		$(this).append('<button class="irMoreLink">'+openText[i]+'</button>');
		$(".irMoreTwo",this).css({"overflow":"hidden"});
		$(".irMoreTwo",this).height(0);
		$(this).attr("id","irMore"+i);
		i = i+1;
	});
});

$('.irMore').on("click",".irMoreLink",function(){
	var x = parseInt( $(this).parent().attr("id").replace("irMore","") );
	if( !$(this).hasClass("irOpen") ){
		$(this).html(closeText[x]);
		$(this).addClass("irOpen");
		if( $(this).parent().hasClass("bounce") ){
			$(this).siblings(".irMoreTwo").animate({"height":twoHeight[x]+5},200);
			$(this).siblings(".irMoreTwo").animate({"height":twoHeight[x]-5},90);
			$(this).siblings(".irMoreTwo").animate({"height":twoHeight[x]},60);
		}
		else{
			$(this).siblings(".irMoreTwo").animate({"height":twoHeight[x]},400);
		}
	}
	else{
		$(this).html(openText[x]);
		$(this).removeClass("irOpen");
		if( $(this).parent().hasClass("bounce") ){
			$(this).siblings(".irMoreTwo").animate({"height":"0px"},200);
			$(this).siblings(".irMoreTwo").animate({"height":"5px"},90);
			$(this).siblings(".irMoreTwo").animate({"height":"0px"},60);
		}
		else{
			$(this).siblings(".irMoreTwo").animate({"height":"0px"},400);
		}
	}
});