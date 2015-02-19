<%@page import="co.simplypos.model.website.ArticleDetail" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="co.simplypos.model.website.page.model.StockDetailPageModel " %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="co.simplypos.interconnect.HTMLHelper" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.io.File" %>
<%@page import="java.util.ArrayList" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%

try {
	StockDetailPageModel pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
	StockDetailPageView pageView = (StockDetailPageView) userSession.getWebController().getCurrentPageController().getPageView();

	String optionLevelKey = request.getParameter("optlevkey");
	String optionsListLev5 = "";

	if (optionLevelKey != null) {
		ArrayList al = pageModel.getLeafOptionList().get(optionLevelKey);
		if (al != null) {
			for (int i=0;i<al.size();i++) {
				optionsListLev5 += al.get(i);
				optionsListLev5 += "</option> \n"; 
     				
			}
		}
	}
	String optionList = "<select class=\"inputitem\" name=\"id\" onChange=\"qtyform.updbasket.value=0;qtyform.submit();\">";
	optionList += "<option selected>"+request.getParameter("emptytxt")+"</option>";
	optionList += optionsListLev5;
	optionList += "</select>";
	System.out.println(optionList);
	
 %>
	<script>document.forms['qtyform'].elements['id'].selectedIndex = 0;</script>
	<%=optionList%>		
 <%
	
} catch (Exception ee1) { 
	out.write(""+ee1.getMessage());
	website.writeToLog("stockdetailoptionlist.jsp failed: "+ee1.getMessage()); 
} 	
%>
