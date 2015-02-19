<%@ taglib uri="http://www.opensymphony.com/oscache" prefix="cache" %>
<%
try {

StockListingPageModel pageModel = null;
StockListingPageView pageView = null;
StockListingPageController pageController = null;

try {
	pageModel = (StockListingPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
} catch (Exception asdkkio22) { website.writeToLog("Page: "+request.getRequestURI()+"   params: "+request.getQueryString()); website.writeToLog(asdkkio22); }
try{
	pageView = (StockListingPageView) userSession.getWebController().getCurrentPageController().getPageView();
} catch (Exception asdkkio22) { website.writeToLog("Page: "+request.getRequestURI()+"   params: "+request.getQueryString()); website.writeToLog(asdkkio22); }
try{
	pageController = (StockListingPageController) userSession.getWebController().getCurrentPageController();
	pageController.populatePageModel(request, userSession.getWebController().getParamPid());
} catch (Exception asdkkio22) { website.writeToLog("Page: "+request.getRequestURI()+"   params: "+request.getQueryString()); website.writeToLog(asdkkio22); }

boolean showHome = false;
boolean bContinue = true; 

String searchString = pageModel.getSearchString();
float price1 = pageModel.getPrice1();
float price2 = pageModel.getPrice2();
String priceDesc = pageModel.getPriceDesc();
int pageNo = pageModel.getPageNo();
int paramParentVendorArticleId = pageModel.getParamParentVendorArticleId();
Vector resultSet = pageModel.getResultSet();
int paramNumInSet = pageModel.getParamNumInSet();
String params = pageModel.getParams();
int numPages = pageModel.getNumPages();

String queryString = StringHelper.replace(request.getQueryString(),"&","&amp;");
queryString = StringHelper.replace(queryString, "layout=0&amp;", "");
queryString = StringHelper.replace(queryString, "layout=1&amp;", "");
%>
	<div class="pagebanner">
<%if (pageModel.isHomePage()) { %>
	<%showHome = true;  // if its not all products (no categories) then set showHome %>
	<%@include file='../../bannerhome_mobile.html' %>
<% } else {
		String bannercName = request.getParameter("cName");
		String bannerNameJsp = "banner"+bannercName+"_mobile.jsp";   
		String bannerNameHtml = "banner"+bannercName+"_mobile.html"; 
		String bannerWrapperName = "wrapperbanner_mobile.jsp";
		File bannertemp = new File(website.getWebSitePath()+bannerNameJsp);
		boolean bannerTestJsp = bannertemp.exists();
		bannertemp = new File(website.getWebSitePath()+bannerNameHtml);
		boolean bannerTestHtml = bannertemp.exists();
		bannertemp = new File(website.getWebSitePath()+bannerWrapperName);
		boolean bannerTestWrap = bannertemp.exists();
		if (bannerTestWrap || bannerTestHtml || bannerTestJsp ){
 		%>
			<% if (bannerTestJsp) { %>
				<jsp:include page="<%=bannerNameJsp%>"/>
			<%} else { %>
				<%if (bannerTestWrap) {%>
							<%if (bannerTestHtml) { %>
								<jsp:include page="<%=bannerWrapperName%>">
									<jsp:param name="pageNo" value="<%=pageNo%>" />
									<jsp:param name="bannercName" value="<%=bannercName%>" />	
									<jsp:param name="bannerName" value="<%=bannerNameHtml%>" />
								</jsp:include>
							<% } else { %>
						<jsp:include page="<%=bannerWrapperName%>">
							<jsp:param name="pageNo" value="<%=pageNo%>" />
							<jsp:param name="bannercName" value="<%=bannercName%>" />	
						</jsp:include>
							<% } %>
				<%} else {%>
					<%if (bannerTestHtml) { %>
						<jsp:include page="<%=bannerNameHtml%>"/>
					<% } %>
				<% } %> 
			<% } %>	
			
		<% } %>
<% } %>
</div>


<% if (website.getDefaultWebsiteAccessDomainId() == Customer.WEB_ACCESS_TYPE_NONE) {
	if (!userSession.isLoggedIn() || userSession.getWebsiteAccessDomainId() == Customer.WEB_ACCESS_TYPE_NONE) {
		bContinue = false;
		if (userSession.isLoggedIn()) {
			userSession.refreshCurrentLogin(); // try a refresh
			if (userSession.getWebsiteAccessDomainId() == Customer.WEB_ACCESS_TYPE_NONE) {
			%>   
				<center>Registration pending, please try again later.</center> 
			<%} else {
				bContinue = true;
			}
		} else { %>
			<center><%=website.getStockListingLoginMsg()%></center> 

		<%}
	}
} %>
<div id="pagevalidationmessageajax"> 
		<jsp:include page="/template/components/stockdetailvalidation.jsp" /> 		
</div>

<%
if (bContinue) {
	String pageClassName = userSession.getPageName();
	if (userSession.isHomePage()) {
		pageClassName = "home";
	}
	String trailHTML = userSession.getTrailHTML(request, searchString, price2, priceDesc, pageNo, paramParentVendorArticleId, true);
	userSession.setStoreHTMLTrailForCategoryPage(trailHTML);

	if (!showHome) { %>
			<jsp:include page="/template/components/stocklistingtrailandpageno.jsp"> 
				<jsp:param name="pageNo" value="<%=pageNo%>" />
				<jsp:param name="numPages" value="<%=numPages%>" />
				<jsp:param name="navLoc" value="top" />
				<jsp:param name="params" value="<%=params%>" />
				<jsp:param name="queryString" value="<%=queryString%>" />
				<jsp:param name="trailHTML" value="<%=trailHTML%>" />
			</jsp:include>			
	<% }
	int qtyToShow = 4; // dunno if needed
	if (pageView != null) { %>
		<div id="stocklising">
			<% website.writeToLog("Result Set: "+resultSet.toString());%>
			<% if (pageModel.isHomePage()) { %>
				<%=pageView.getMobileMenu(userSession)%>
			<% } %>
			<%=pageView.getArticleListHTML(request, resultSet, qtyToShow, searchString, price2, categoryTitleText, website.getFeaturedItemsText(), paramNumInSet, showHome, website.isShowCategoriesOnHomepage(), website.isShowFeaturedItemsOnHomepage(), website.isEnableGroupImagePadding(), true)%>
		</div>
	<% }
	
	if (!showHome) { 
		if (!website.isShowFooterTrail()) trailHTML = ""; 
		%>
		<jsp:include page="/template/components/stocklistingtrailandpageno.jsp"> 
			<jsp:param name="pageNo" value="<%=pageNo%>" />
			<jsp:param name="navLoc" value="bottom" />
			<jsp:param name="numPages" value="<%=numPages%>" />
			<jsp:param name="params" value="<%=params%>" />
			<jsp:param name="hideExtra" value="1" />
			<jsp:param name="queryString" value="<%=queryString%>" />
			<jsp:param name="trailHTML" value="<%=trailHTML%>" />
		</jsp:include>	
		<%	
		String footercName = request.getParameter("cName");

		String footerNameJsp = "footer"+footercName+"_mobile.jsp";   
		String footerNameHtml = "footer"+footercName+"_mobile.html"; 
		String footerWrapperName = "wrapperfooter_mobile.jsp";
		File footertemp = new File(website.getWebSitePath()+footerNameJsp);
		boolean footerTestJsp = footertemp.exists();
		footertemp = new File(website.getWebSitePath()+footerNameHtml);
		boolean footerTestHtml = footertemp.exists();
		footertemp = new File(website.getWebSitePath()+footerWrapperName);
		boolean footerTestWrap = footertemp.exists(); %>

<%
		if ((footerTestWrap || footerTestHtml || footerTestJsp) && !(footerNameHtml == "footer.html") ){
 		%>

			<div class="pagefooter">
			<% if (footerTestJsp) { %>
				<jsp:include page="<%=footerNameJsp%>"/>
			<%} else { %>
				<%if (footerTestWrap) {%>
					<%if (footerTestHtml) { %>
						<jsp:include page="<%=footerWrapperName%>">
							<jsp:param name="pageNo" value="<%=pageNo%>" />
							<jsp:param name="footercName" value="<%=footercName%>" />	
							<jsp:param name="footerName" value="<%=footerNameHtml%>" />
						</jsp:include>
					<% } else { %>
						<jsp:include page="<%=footerWrapperName%>">
							<jsp:param name="pageNo" value="<%=pageNo%>" />
							<jsp:param name="footercName" value="<%=footercName%>" />	
						</jsp:include>
					<% } %>
				<%} else {%>
					<%if (footerTestHtml) { %>
						<jsp:include page="<%=footerNameHtml%>"/>
					<% } %>
				<% } %> 
			<% } %>	
			</div>	
		<% } %>
	<% } %>

<%}
if (request.getParameterMap().size() == 0 || (request.getParameterMap().size() == 2 && request.getParameter("btn") != null && request.getParameter("nls") != null)) {
%>
<div id="pagefooterhome">

				<% 
				String footerHomeName = "footerhome_mobile.html";
				File footerHome = new File(website.getWebSitePath()+footerHomeName);
				if (footerHome.exists()) { %>
					<jsp:include page="<%=footerHomeName%>"/>
				<% } %>

</div>
<%
}
} catch (Exception ee) {
	out.write(ee.getMessage());
	website.writeToLog(ee);
}
//out.write("</cache:cache>");
%>