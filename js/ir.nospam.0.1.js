$(document).ready(function(){
	$('.irEmail').each(function(){
		var address = $(this).html();
		address = address.replace("+at+","@");
		address = "<a href='mailto:"+address+"'>"+address+"</a>";
		$(this).after(address);
		$(this).remove();
	});
});