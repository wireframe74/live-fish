<%@page import="co.simplypos.model.website.HTMLComponents" %>
<%@page import="co.simplypos.model.website.UserSession" %>
<%@page import="co.simplypos.model.website.WebSite" %>
<%@page import="co.simplypos.model.website.page.controller.StockListingPageController" %>
<%@page import="co.simplypos.model.website.page.PageController" %>
<%@page import="java.io.File" %>
<%@ taglib uri="http://www.opensymphony.com/oscache" prefix="cache" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<cache:cache key='<%="topnavmenu_"+userSession.getCurrentDepartmentId()%>' time="-1" scope="application">
<%@include file="topnav.html"%>
</cache:cache> 