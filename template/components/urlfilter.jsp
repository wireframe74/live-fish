<%@page import="java.io.File,java.io.Serializable, java.util.Enumeration, javax.servlet.http.HttpServlet, javax.servlet.http.HttpServletRequest, javax.servlet.http.HttpServletResponse, co.simplypos.model.utils.ExceptionManager, co.simplypos.model.utils.helpers.StringHelper, co.simplypos.model.website.ItemDescriptionServlet"%><jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
String baseURL = "";
String logFile = "";
try{
	String resultsPage = "";
	String cName;
	String realPath = request.getSession().getServletContext().getRealPath("/");
	logFile = realPath +"urlfilter.log";
	baseURL = request.getRequestURL().substring(0,request.getRequestURL().length()-request.getRequestURI().length())+request.getContextPath();
	String requestedURL = request.getRequestURL().toString();
	String requestedPage = request.getRequestURI();
	requestedPage = requestedPage.substring(requestedPage.lastIndexOf("/")+1);

	int irIdx = requestedPage.indexOf((".ir"));
	int irgIdx = requestedPage.indexOf((".irc"));
	if (irgIdx == -1) irgIdx = requestedPage.indexOf((".htm"));
	int irsIdx = requestedPage.indexOf((".irs"));
	if (irsIdx == -1) irsIdx = requestedPage.indexOf((".cgi"));

	if (irsIdx > -1) {
		requestedPage = requestedPage.substring(0, irsIdx);

		String title = StringHelper.replace(StringHelper.replace(requestedPage, "-", " "),"_"," ");
		title = ItemDescriptionServlet.getPropper(title);

		if (new File(realPath,requestedPage+".jsp").exists()) {
			resultsPage = "/host.jsp?pg="+requestedPage+".jsp&desc="+title;	 //nm1
		} else {
			resultsPage = "/host.jsp?pg="+requestedPage+".html&desc="+title;  //nm1
		}
	} else if (irgIdx > -1) {
		String requestedCategory = requestedPage.substring(0, irIdx);

		Enumeration<String> enum1 = request.getParameterNames();
		String paramList = "";
		while (enum1.hasMoreElements()) {
		String parameter = enum1.nextElement();
		if (!paramList.equals("")) paramList += "&";  //nm1
			paramList += parameter+"="+request.getParameter(parameter);
		}
		String paramCategory = "cName="+requestedCategory;
		if (!paramList.equals("")) paramCategory += "&"; //nm1
		paramList = paramCategory + paramList;

		resultsPage = "/index.jsp?" + paramList;

	} else if (irIdx > -1) {
		requestedPage = requestedPage.substring(0, irIdx);
		cName = request.getParameter("cName");
		resultsPage = "/detail.jsp?pName=" + requestedPage;
		if (cName != null) resultsPage += "&cName=" + cName;  //nm1
	} else {
		resultsPage = requestedPage;
	}    
	try {
		request.setAttribute("origPageName",requestedPage);
		if (resultsPage != null && resultsPage.length() > 1) request.setAttribute("newPageName",resultsPage.substring(1));
		co.simplypos.model.website.utils.Logger.writeToInfoLog(logFile, new java.lang.StringBuffer("urlfilter.jsp dispatching from: "+requestedPage+" to: "+resultsPage));
		response.setStatus(HttpServletResponse.SC_OK);
		getServletContext().getRequestDispatcher(resultsPage).forward(request, response);
	} catch (Exception e) {
		co.simplypos.model.website.utils.Logger.writeToLog(logFile,e);
	}
} catch (Exception e) {
	co.simplypos.model.website.utils.Logger.writeToLog(logFile,e);
}%>