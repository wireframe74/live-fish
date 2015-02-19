<%@page import="co.simplypos.model.website.page.PageModel " %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
PageModel pageModel = null;
try {
	pageModel = userSession.getWebController().getCurrentPageController().getPageModel();				
	if (userSession == null) {
		out.write("Session has expired, refresh the page.");
	} else {
		if (pageModel.getValidationMessage() != null) {
		%>
			<ul class="validation labelpairleft" >
                            <li class="validationicon"><img src="<%=website.getImagePath("icon_error.gif")%>" alt="" /></li>		 
                             <li class="validationtext"><%=pageModel.getValidationMessage()%></li>
			</ul>

		<%
		}
	}
} catch (Exception ee1) { 
	website.writeToLog("Failed to get validation message. Reason: "+ee1.getMessage()); 
} 	
%>
