<%
String thispgname = ""+request.getAttribute("origPageName");
if (thispgname != null) {
	int idxpgnamedot = thispgname.indexOf(".");
	if (idxpgnamedot > -1) thispgname = thispgname.substring(0,idxpgnamedot);
}
if (userSession.isHomePage()) thispgname = "homepage";
if (thispgname == null || thispgname.equals("null")) thispgname = "unclassifiedpage";

%>
<div id="<%=thispgname%>" class="<%=userSession.getCurrentTemplatePage()%>"> 
<% try  {
if (templatePage.equalsIgnoreCase("register")) {
%>
	<%@include file="register.html"%>
<%
} else if (templatePage.equalsIgnoreCase("myaccount")) {
%>
	<jsp:include page="template/components/myaccount.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("welcome")) {
%>
	<jsp:include page="template/components/welcome.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("templateOrders")) {
%>
	<jsp:include page="template/components/templateOrders.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("viewList")) {
%>
	<jsp:include page="template/components/viewList.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("delivery")) {
%>
	<%@include file="delivery.html"%>
<%
} else if (templatePage.equalsIgnoreCase("basket")) {
%>
	<jsp:include page="template/components/shoppingbasket_mobile.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("confirm")) {
%>
	<jsp:include page="template/components/confirm.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("detail")) {
%>
	<%@include file="stockdetail_mobile.jsp"%>
<%
} else if (templatePage.equalsIgnoreCase("host")) {
%>
	<%@include file="host.html"%>
<%
} else if (templatePage.equalsIgnoreCase("stocklisting")) {
%>
	<%@include file="stocklisting_mobile.jsp"%>
<%
} else if (templatePage.equalsIgnoreCase("stocklistingnew")) {
%>
	<div id="ajaxFrameCentreComponent">
		<jsp:include page="template/components/stocklistingnew.jsp">
			<jsp:param name="paramPid" value="<%=paramPid%>" />
		</jsp:include>
	</div>
<%
} else if (templatePage.equalsIgnoreCase("changeaddr")) {
%>
	<jsp:include page="template/components/changeaddr.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("siteindex")) {
%>
	<%@include file="siteindex.html"%>
<%
} else if (templatePage.equalsIgnoreCase("tracking")) {
%>
	<jsp:include page="template/components/tracking.jsp"/>
<%
} else if (templatePage.equalsIgnoreCase("pay")) {
%>
	<jsp:include page="template/components/pay.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("quickpay")) {
%>
	<jsp:include page="template/components/quickpay.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("custauth")) {
%>
	<%@include file="custauth.html"%>
<%
} else if (templatePage.equalsIgnoreCase("changepwd")) {
%>
	<%@include file="changepwd.html"%>
<%
} else if (templatePage.equalsIgnoreCase("metaKeyAdmin")) {
%>
	<jsp:include page="template/components/metaKeyAdmin.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("giftlist")) {
%>
	<jsp:include page="template/components/giftList.jsp" />

<%
} else if (templatePage.equalsIgnoreCase("flightdeck")) {
%>
	<jsp:include page="template/components/flightdeck.jsp" />
<%
} else if (templatePage.equalsIgnoreCase("logout")) {
	//userSession.logout();
	userSession.clearSessionInfo();
	request.getSession().removeAttribute("userSession");
	UserSession newSession = new UserSession();
	newSession.initialise(website, request);
	request.getSession().setAttribute("userSession", newSession);
	
%>
	<%@include file="../../logout.html"%>
<%
} else if (templatePage.equalsIgnoreCase("STATICPAGE")) {
	String staticpageurl = request.getRequestURI().substring(0,request.getRequestURI().lastIndexOf("/"));
%>
		<jsp:include page='<%="/"+staticpageurl.substring(staticpageurl.lastIndexOf("/")+1)+".jsp"%>' />    

<% } %>


<%
} catch (Exception e32e9393) {
	website.writeToLog("componentcontroller exception: "+e32e9393.getMessage());
	website.writeToLog(e32e9393);
}
%>
</div> 