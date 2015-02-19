function basketBarCreate(per){
	if( per < 100 ){
		$('.freedeliveryprogressbar').css({"overflow":"hidden"});
		$('.freedeliveryprogressbar').addClass('barBord');
		$('#basketprogressbar').css({"width":per+"%", "height":"100%"});
		$('#basketprogressbar').addClass('barGrad');
	}
}