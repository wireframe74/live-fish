var captcha = 0;
function validateContact(){
	
	var name = $("#fullName").val();
	var email = $("#email").val();
	var question = $("#question").val();
	var val1 = parseInt($("#contactval1").val());
	var val2 = parseInt($("#contactval2").val());
	var rel = parseInt($("#contactrel").val());
	
	var at = email.indexOf("@");
	var dot = email.lastIndexOf(".");
	
	var error = "";
	
	if( name = "" || !name ){
		error += "Please enter your name<br/>";
		$("#fullName").addClass("error");
	}
	
	if( email = "" || !email ){
		error += "Please enter your email address<br/>";
		$("#email").addClass("error");
	}
	else if( at < 1 || dot < at+2 || dot+2 >= email.length ){
		error += "Your email address appears to be invalid<br/>";
		$("#email").addClass("error");
	}
	
	if( question = "" || !question ){
		error += "Please enter a qusetion<br/>";
		$("#question").addClass("error");
	}
	
	if( val1 + val2 != rel ){
		error += "Sorry, you appear to be a Bot<br/>";
	}
	
	if( error != "" ){
		$(".contactMessage").html(error);
		$(".contactMessage").addClass("error");
		return false;
	} else {
		return true;
	}
	
}
$(".contactFormInput").on("input",function(){
	$(this).removeClass("error");
});