<%@ taglib uri="http://www.opensymphony.com/oscache" prefix="cache" %>
<%
//String cacheKey="sl_"+userSession.getUniquePageStringKey(request);
//out.write("<cache:cache key='"+cacheKey+"' time=\"-1\" scope=\"application\">"+new java.util.Date());
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

if (pageModel.isHomePage()) {	
//if (request.getParameterMap().size() == 0 || (request.getParameterMap().size() == 2 && request.getParameter("btn") != null && request.getParameter("nls") != null)) {
//    if (website.getArticleMenu().getSiteIndexIds().size() > 1) {
//       showHome = true;  // if its not all products (no categories) then set showHome
//    }

%>
<div id="pagebanner">
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<center>
				<%@include file='../../bannerhome.html' %>
			</center>
		</td>
	</tr>
	</table>
</div>
<%
}

%>
<div id="pagelisting">
<table width="100%" cellspacing="0" cellpadding="0" border="0">
	<tr> <%-- start of first row of main containing table --%>
		<td>
<%
  // 18/05/2011 GF: Banner code added
		String bannercName = request.getParameter("cName");
		String bannerNameJsp = "banner"+bannercName+".jsp";   
		String bannerNameHtml = "banner"+bannercName+".html"; 
		String bannerWrapperName = "wrapperbanner.jsp";
		File bannertemp = new File(website.getWebSitePath()+bannerNameJsp);
		boolean bannerTestJsp = bannertemp.exists();
		bannertemp = new File(website.getWebSitePath()+bannerNameHtml);
		boolean bannerTestHtml = bannertemp.exists();
		bannertemp = new File(website.getWebSitePath()+bannerWrapperName);
		boolean bannerTestWrap = bannertemp.exists();
		if (bannerTestWrap || bannerTestHtml || bannerTestJsp ){
	%>
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<center>
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
				</center>
			</td>
		</tr>
	</table> 
	</td></tr><tr><td> 
		<%}

if (website.getDefaultWebsiteAccessDomainId() == Customer.WEB_ACCESS_TYPE_NONE) {
	if (!userSession.isLoggedIn() || userSession.getWebsiteAccessDomainId() == Customer.WEB_ACCESS_TYPE_NONE) {
		bContinue = false;
		if (userSession.isLoggedIn()) {
			userSession.refreshCurrentLogin(); // try a refresh
			if (userSession.getWebsiteAccessDomainId() == Customer.WEB_ACCESS_TYPE_NONE) {
%>   
			<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0">
				<tr height="100%" >
					<td width="100%" >
						<br /><br /><br /><br /><br /><br />
						<center>Registration pending, please try again later.</center> 
						<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
					</td>
				</tr>
			</table>
    
<%
			} else {
				bContinue = true;
			}
		} else {
%>
			<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0">
				<tr height="100%" >
					<td width="100%" >
						<br /><br /><br /><br /><br /><br />
						<center><%=website.getStockListingLoginMsg()%></center> 
						<br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br /><br />
					</td>
				</tr>
			</table>
<%
		}
	}
}
%>
		</td>
	</tr> <%-- end of first row of main containing table --%>
	<tr>
		<td>
			<div id="pagevalidationmessageajax"> 
				<jsp:include page="/template/components/stockdetailvalidation.jsp" /> 		
			</div>
		</td>
	</tr>
<%
if (bContinue) {
	String pageClassName = userSession.getPageName();
	if (userSession.isHomePage()) {
		pageClassName = "home";
	}
	String trailHTML = userSession.getTrailHTML(request, searchString, price2, priceDesc, pageNo, paramParentVendorArticleId);
	userSession.setStoreHTMLTrailForCategoryPage(trailHTML);

	if (!showHome) {
%>
	<tr> 
		<td>
			
			<div id="pagenavtop<%=pageClassName%>" class="pagenavtop" flush="true" >
				<div id="pagenavtop">
					<jsp:include page="/template/components/stocklistingtrailandpageno.jsp"> 
						<jsp:param name="pageNo" value="<%=pageNo%>" />
						<jsp:param name="numPages" value="<%=numPages%>" />
						<jsp:param name="params" value="<%=params%>" />
						<jsp:param name="queryString" value="<%=queryString%>" />
						<jsp:param name="trailHTML" value="<%=trailHTML%>" />
					</jsp:include>			
				</div>
			</div>
		</td>
	</tr> 
<%
	}

	int qtyToShow = 4; // dunno if needed

	userSession.setShowOutOfStockItems(false);

	if (pageView != null) {
%>
	      <%=pageView.getArticleListHTML(request, resultSet, qtyToShow, searchString, price2, categoryTitleText, website.getFeaturedItemsText(), paramNumInSet, showHome, website.isShowCategoriesOnHomepage(), website.isShowFeaturedItemsOnHomepage(), website.isEnableGroupImagePadding())%>
<%
	}

	//userSession.setShowOutOfStockItems(null);

	if (!showHome) { 
		if (!website.isShowFooterTrail()) trailHTML = "";
	%>
	
	<tr> 
		<td>		
			<div id="pagenavbottom<%=pageClassName%>" class="pagenavbottom">
				<div id="pagenavbottom">
					<jsp:include page="/template/components/stocklistingtrailandpageno.jsp"> 
						<jsp:param name="pageNo" value="<%=pageNo%>" />
						<jsp:param name="numPages" value="<%=numPages%>" />
						<jsp:param name="params" value="<%=params%>" />
						<jsp:param name="queryString" value="<%=queryString%>" />
						<jsp:param name="trailHTML" value="<%=trailHTML%>" />
					</jsp:include>	
				</div>		
			</div>
		</td>
	</tr> 
<%
	}
  // 18/05/2011 GF: Footer code added
		String footercName = request.getParameter("cName");
		String footerNameJsp = "footer"+footercName+".jsp";   
		String footerNameHtml = "footer"+footercName+".html"; 
		String footerWrapperName = "wrapperfooter.jsp";
		File footertemp = new File(website.getWebSitePath()+footerNameJsp);
		boolean footerTestJsp = footertemp.exists();
		footertemp = new File(website.getWebSitePath()+footerNameHtml);
		boolean footerTestHtml = footertemp.exists();
		footertemp = new File(website.getWebSitePath()+footerWrapperName);
		boolean footerTestWrap = footertemp.exists();
		if (footerTestWrap || footerTestHtml || footerTestJsp ){
 		%>
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<center>

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
			</center>
				</td>
			</tr>
		</table> 
	</td></tr><tr><td>			
		
		<%
		}

}
%>
</table>
</div>
<%
if (request.getParameterMap().size() == 0 || (request.getParameterMap().size() == 2 && request.getParameter("btn") != null && request.getParameter("nls") != null)) {
%>
<div id="pagefooterhome">
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<center>
				<% 
				String footerHomeName = "footerhome.html";
				File footerHome = new File(website.getWebSitePath()+footerHomeName);
				if (footerHome.exists()) { %>
					<jsp:include page="<%=footerHomeName%>"/>
				<% } %>
			</center>
		</td>
	</tr>
	</table>
</div>
<%
}
} catch (Exception ee) {
	out.write(ee.getMessage());
	website.writeToLog(ee);
}
//out.write("</cache:cache>");
%>