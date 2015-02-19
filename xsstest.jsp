<!-- start of thankyou.jsp --> 
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<html>
<head>
</head>
<body>
<b>Cross Site Scripting Test</b>
<br /><br />
example: mytest.jsp?cName=carseat-accessories%22%3E%3Cscript%25curl-L
<br /><br />
<%="request.getQueryString() seen as: "+request.getQueryString()%>
<br/>
<%="cName parameter seen as: "+request.getParameter("cName")%> 
<br/><br />
<%="Is Cross Site Scripting Present: "+(request.getAttribute("XSSDetect")!=null)%> 
<br/>
<%="Is website redirect in place: "+co.simplypos.model.website.controller.WebController.isCrossSiteScriptingPresent(request,website)%>
</body>
</html>

