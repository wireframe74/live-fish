<!-- start of contactus.html -->
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<div class="stockcontainer">    

	<h1>Contact us</h1>
		
	<div id="contactForm">
			
		<%
		String fullName;
		String question;
		String email;
		String messagefalse;
		
		String message = "";
		boolean submitting = true;
		
		fullName = request.getParameter("fullName");
		if (fullName == null) {
			fullName = "";
		}
		
		question = request.getParameter("question");
		if (question == null) {
			question = "";   
		}
		
		email = request.getParameter("email");
		if (email == null) {
			email = "";
			submitting = false;
		}
		
		messagefalse = request.getParameter("message");
		if ( messagefalse != "" && messagefalse != null ) {
			messagefalse = "Sorry, you appear to be a Bot";
			submitting = false;
		}else{
			messagefalse="";
		}
		
		
		if (submitting) {
			String subject = "Website Communication";
			StringBuilder textEmailBody = new StringBuilder();
			StringBuilder htmlEmailBody = new StringBuilder();
			
			textEmailBody.append("The following person has asked a question or sent a comment \n");
			textEmailBody.append("Name: ").append(fullName).append("\n");
			textEmailBody.append("Email: ").append(email).append("\n");
			textEmailBody.append("Question: ").append(question).append("\n");
		
			htmlEmailBody.append("<div>");
			
			htmlEmailBody.append("The following person has asked a question or sent a comment<br /><br />");
			htmlEmailBody.append("Name: ").append(fullName).append("<br />");
			htmlEmailBody.append("Email: ").append(email).append("<br />");
			htmlEmailBody.append("Question: ").append(question).append("<br />");
			
			htmlEmailBody.append("</div>");
			try {
				
				if (email.equals("")) {
					throw new Exception();
				}
				
				website.sendEmail(null, subject, textEmailBody.toString(), htmlEmailBody.toString());
				
				message = "Your question was submitted successfully someone will be in touch with you shortly";
				fullName = "";
				email = "";
				question = "";
		
			
			} catch (Exception e) {
					
					message = "The question could not be submitted, please check your details and try again.";
			}
		}%>
		
		<form class="contact" name="questionForm" method="post" onSubmit="return validateContact()">
			
			<div>
				<label for="fullName">Name </label>
				<input class="contactFormInput" type="text" name="fullName" id="fullName" value="<%=fullName %>" />
			</div>
			<div>
				<label for="email">E-mail</label>
				<input class="contactFormInput" type="text" name="email" id="email" value="<%=email%>" />
			</div>
			<div>
				<label for="question">Question or comment</label>
				<textarea class="contactFormInput" name="question" id="question"><%=question%></textarea>
			</div>
			<div class="captcha">
				<input type="text" name="message" value="" />
				<input type="text" name="val1" id="contactval1" />
				<input type="text" name="val2" id="contactval2" />
				<input type="text" name="rel" id="contactrel" />
				<script>$(document).ready(function(){var contactVal1=Math.floor((Math.random()*100)+1),contactVal2=Math.floor((Math.random()*100)+1);$("#contactval1").val(contactVal1);$("#contactval2").val(contactVal2);$("#contactrel").val(contactVal1+contactVal2);});</script>
			</div>
			
			<%if (!submitting) {%>
				<div class="contactBtnHold">
					<button class="send" type="submit" >Send</button>
				</div>
			<%}%>
			
			<div class="contactMessage <%if (!submitting) {%>error<%}%>"><%=message%> <%=messagefalse%></div>
			
		</form>
	
	</div>

	<jsp:include page="contactus.html" />
	
	<jsp:include page="contactusmap.html" />
	
</div>

<!-- end of contactus.html -->