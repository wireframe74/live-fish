//Create Form
$(document).ready(function(){
	$('.irFlags').after("<form name='flagsForm' method='post'><input type='hidden' value='0' name='currid'></input></form>");
});

//Light Active Flag
$(document).ready(function(){
	var current = ".flag" + $('input[name=flagCur]').val();
	$(current).fadeTo(0,1);
	$(current).addClass("active");
});

//OnClick
$('.irFlags li').click(function(){
	var val = parseInt($(this).attr("class").replace("flag",""));
	$('form[name=flagsForm] input[name=currid]').val(val);
	$('form[name=flagsForm]').submit();
	$(this).addClass("active");
	$('.irFlags li').fadeTo(0,0.6);
	$(this).fadeTo(0,1);
});

//Hover
$('.irFlags li').hover(
	function(){
		if( !$(this).hasClass("active") ){
			$(this).stop().fadeTo(200,0.8);
		}
	},function(){
		if( !$(this).hasClass("active") ){
			$(this).stop().fadeTo(100,0.6);
		}
	}
);