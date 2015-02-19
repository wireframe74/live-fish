for(var ie=-1,b=document.createElement("b");b.innerHTML="<!--[if gt IE "+ ++ie+"]>1<![endif]-->",+b.innerHTML;);
var browser = $.browser;
if(ie<=7 && ie>1){
	var badBrowser = "Microsoft Internet Explorer "+ie;
}
else if( $(".no-boxsizing").size() > 0 ){
	var badBrowser = browser;
}
if( badBrowser ){
	if( $(".index").size() > 0 ){
		//alert("It appears that you are currently using "+badBrowser+".\n\n We regret that our site is unstable/unreliable in this browser due to its age or lack of features.\n\n We would highly recommend updating to a newer version of your browser or to another browser such as 'Mozilla Firefox' or 'Google Chrome' so that you can view our site at its full potential.");
	}
	$("head").append("<link rel='stylesheet' type='text/css' href='template/ie7.css'>");
}