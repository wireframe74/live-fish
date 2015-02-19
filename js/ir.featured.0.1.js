$(document).ready(function(){
	if( $(".index .productsLayoutModeThumb .stockThumb").size() < 1 || $(".index #stocklisting .noarticles").size() >= 1 ){
		$(".index #stocklisting .noarticles").hide();
		$(".index .productsLayoutModeThumb").hide();
		$(".index .irFeatHide").hide();
	}
});
