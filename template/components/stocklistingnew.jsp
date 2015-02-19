<%@page import="co.simplypos.model.website.*, co.simplypos.model.utils.*, co.simplypos.model.utils.helpers.*, co.simplypos.persistence.Address,
	co.simplypos.persistence.*, co.simplypos.model.*, co.simplypos.model.website.utils.Logger, co.simplypos.persistence.Currency,
	java.text.*, javax.mail.*, java.io.*, java.awt.*, java.util.*, java.sql.*, java.net.*, java.util.Date,
    javax.imageio.ImageWriter, com.sun.imageio.plugins.jpeg.JPEGImageWriter, java.math.BigDecimal,
    javax.net.ssl.HttpsURLConnection, javax.swing.table.DefaultTableModel, co.simplypos.model.website.page.view.*, co.simplypos.model.website.page.controller.*,
co.simplypos.model.website.page.model.*, javax.swing.text.html.HTML, com.clearcommerce.CpiTools.security.HashGenerator"%>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<!-- start of components/stocklisting.html -->
<%
try {

StockListingPageModel pageModel = null;
StockListingPageView pageView = null;
StockListingPageController pageController = null;

try {
	pageModel = (StockListingPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
} catch (Exception asdkkio22) { website.writeToLog(asdkkio22); }
try{
	pageView = (StockListingPageView) userSession.getWebController().getCurrentPageController().getPageView();
} catch (Exception asdkkio22) { website.writeToLog(asdkkio22); }
try{
	pageController = (StockListingPageController) userSession.getWebController().getCurrentPageController();
} catch (Exception asdkkio22) { website.writeToLog(asdkkio22); }

boolean showHome = false;
boolean bContinue = true; 
int paramParentVendorArticleId = 0; //paramPid
int pageNo = 1;
int paramNumInSet = 0;
     
float price1 = 0;
float price2 = 0;

String searchString = "";
String priceDesc = "";
String tagAction = "";

ArticleDetail articleDetail = userSession.getArticleDetail();

boolean showFeaturedItemsOnHomePage = website.isShowFeaturedItemsOnHomepage();

String categoryTitleText = website.getCategoryTitleText(); 
boolean showCategoriesOnHomePage = website.isShowCategoriesOnHomePage();
boolean enableGroupImagePadding = website.isEnableGroupImagePadding();


if (request.getParameter("paramPid") != null) { 
    paramParentVendorArticleId = Integer.parseInt(request.getParameter("paramPid"));
}

if (request.getParameter("id") != null) { 
    paramParentVendorArticleId = Integer.parseInt(request.getParameter("id"));
}

if (paramParentVendorArticleId==0) {
    paramParentVendorArticleId = website.getRootId();
}

if (request.getParameter("pg") != null) {
    pageNo = Integer.parseInt(request.getParameter("pg"));
}

if (request.getParameter("searchStr") != null) {
    searchString = request.getParameter("searchStr");
}
if (request.getParameter("priceDesc") != null) {
    priceDesc = request.getParameter("priceDesc");
}

if (request.getParameter("set") != null) {
    paramNumInSet = Integer.parseInt(request.getParameter("set"));
}
if (request.getParameter("price1") != null) {
    price1 = Float.parseFloat(request.getParameter("price1"));
}
if (request.getParameter("price2") != null) {
    price2 = Float.parseFloat(request.getParameter("price2"));
}

if (request.getParameter("mnu") != null) {
    userSession.resetTrail();
}

if (request.getParameter("tag") != null) {
    tagAction = request.getParameter("tag");
}

String params="";
if (!searchString.equals("")) {
    params = "searchStr="+searchString+"";
} else if (price2 > 0) {
    params = "price1="+price1+"&price2="+price2+"&priceDesc="+priceDesc;
} else {
    if (paramParentVendorArticleId > 0) {
        params = "id="+paramParentVendorArticleId;
    }
}
if (tagAction.equals("qs")) {
    if (!"".equals(params)) params += "&tag=qs&";
    params += HTMLComponents.getTagParams(request);
}

Vector resultSet = null;
Vector resultSet1 = null;

resultSet1 = articleDetail.getHTMLArticleList(paramParentVendorArticleId, pageNo, searchString, null, false, price1, price2);

ArrayList includeSetInList = null;
boolean forceArticleSetsFirst = false;
Vector resultSetAdditional = null;
if (paramNumInSet > 0) {
    includeSetInList = new ArrayList();
    includeSetInList.add(new Integer(paramParentVendorArticleId));
    forceArticleSetsFirst = true;
    resultSetAdditional = articleDetail.getHTMLArticleList(paramParentVendorArticleId, pageNo, searchString, includeSetInList, forceArticleSetsFirst);
    if (resultSetAdditional != null) {
        resultSet = resultSetAdditional;
    }
}

if (resultSet == null) {
    resultSet = resultSet1;
} else {
    resultSet.addAll(resultSet1);
}
if (request.getParameterMap().size() == 0 || (request.getParameterMap().size() == 2 && request.getParameter("btn") != null && request.getParameter("nls") != null)) {
    if (website.getArticleMenu().getSiteIndexIds().size() > 1) {
        showHome = true;  // if its not all products (no categories) then set showHome
    }

%>
<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td>
			<center>
				<%@include file='../../bannerhome.html' %>
			</center>
		</td>
	</tr>
</table>
<%
}

%>
<%-- Main containing table --%>
<table width="100%" cellspacing="0" cellpadding="0" border="0">
	<tr> <%-- start of first row of main containing table --%>
		<td>
<%

	String bannerName = "banner"+request.getParameter("cName")+".html"; 
	File banner = new File(website.getWebSitePath()+bannerName);
	if (banner.exists()) {
	%>
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td>
				<center>
					<jsp:include page="<%=bannerName%>"/>
				</center>
			</td>
		</tr>
	</table> 
	</td></tr><tr><td> 
	<%
}

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

	
<%
if (bContinue) {
	if (!showHome) {
%>
	<tr> <%-- start of second row of main containing table --%>
		<td>
			<table border="0" width="100%" align="center" cellspacing="0" cellpadding="0">
				<tr>
					<td align="left" valign="top">&nbsp;
<%
    
		String trailHTML = userSession.getTrailHTML(request, searchString, price2, priceDesc, pageNo, paramParentVendorArticleId);
		if (request.getQueryString() != null) { 
			out.write(""+trailHTML);
		} 
%>
					</td>
<%
		if (articleDetail.getNumPages() < 1) {
%>
				<td align="right">
    					<table border="0" cellspacing="0" cellpadding="0">
    						<tr>
   	        					<td align="right" <%=(pageNo < articleDetail.getNumPages()) ? "colspan=\"2\"" : "" %> class="pagenumber">

								<div >
									<a href="index.jsp?layout=<%=UserSession.INDEX_LAYOUT_MODE_LIST%>&<%=request.getQueryString()%>">
										<%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_LIST?"<b>List</b>":"List")%>
									</a>
									&nbsp;|&nbsp;
									<a href="index.jsp?layout=<%=UserSession.INDEX_LAYOUT_MODE_THUMBNAILS%>&<%=request.getQueryString()%>">
										<%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_THUMBNAILS?"<b>Thumb</b>":"Thumb")%>
									</a>									      															
								</div>   
   	        					</td>
   						</tr>
					</table>
				</td>
<%
		} else {
%>	        
					<td align="right">
    					<table border="0" cellspacing="0" cellpadding="0">
    						<tr>
   	        					<td align="right" <%=(pageNo < articleDetail.getNumPages()) ? "colspan=\"2\"" : "" %> class="pagenumber">
								<div >
									<a href="index.jsp?layout=<%=UserSession.INDEX_LAYOUT_MODE_LIST%>&<%=request.getQueryString()%>">
										<%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_LIST?"<b>List</b>":"List")%>
									</a>
									&nbsp;|&nbsp;
									<a href="index.jsp?layout=<%=UserSession.INDEX_LAYOUT_MODE_THUMBNAILS%>&<%=request.getQueryString()%>">
										<%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_THUMBNAILS?"<b>Thumb</b>":"Thumb")%>
									</a>
									&nbsp;|&nbsp;
	        							<%="Page "+pageNo+" of "+articleDetail.getNumPages()%>&nbsp;
								</div>   
   	        					</td>
   							</tr>
   							<tr height="20">
<%
			if (pageNo > 1) {
%>
								<td width="<%=(pageNo > 1 && pageNo < articleDetail.getNumPages())?"50%":"100%"%>" >
   									<a href="?<%=params%>&amp;pg=<%=(pageNo-1)%>" class="button" style="float:right;">
   										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Prev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   									</a>
   								</td>
<%
   			}
   			if (pageNo < articleDetail.getNumPages()) {
%>							
   								<td width="<%=(pageNo > 1 && pageNo < articleDetail.getNumPages())?"50%":"100%"%>" >
   									<a href="?<%=params%>&pg=<%=(pageNo+1)%>" class="button" style="float:right;">
   										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Next&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
   									</a>
   								</td>
<%
   			}
%>
   							</tr>	        
   	        					        			
   						</table>
   					</td>	        
<%	        
   	    }
%>					
				</tr>
			</table>
		</td>
	</tr> <%-- end of second row of main containing table --%>
<%
	}
	
%>
	
	<tr> <%-- start of fourth row of main containing table --%>
		<td>
			<img src="<%=website.getImagePath("spacer.gif")%>" alt="" class="height6 width1" />
		</td>
	</tr><%-- end of fourth row of main containing table --%>
	

<%
int qtyToShow = 4; // dunno if needed

if (pageView != null) {
%>

      <%=pageView.getArticleListHTML(request, resultSet, qtyToShow, searchString, price2, categoryTitleText, website.getFeaturedItemsText(), paramNumInSet, showHome, showCategoriesOnHomePage, showFeaturedItemsOnHomePage, enableGroupImagePadding)%>

	<tr><td><img src="<%=website.getImagePath("spacer.gif")%>" height="40" width="1"></td></tr>
<%
}

	if (!showHome) {
%>
	<tr> <%-- start of eigth row of main containing table --%>
		<td align="right">
<% 
	 	if (articleDetail.getNumPages() < 1) {

	 	} else {
%>
			<table border="0" cellspacing="0" cellpadding="0">
				<tr height="20">
<%
			if (pageNo > 1) {
%>
					<td width="<%=(pageNo > 1 && pageNo < articleDetail.getNumPages())?"50%":"100%"%>" >
						<a href="?<%=params%>&amp;pg=<%=(pageNo-1)%>" class="button" style="float:right;">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Prev&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</a>
					</td>
<%
			}
			if (pageNo < articleDetail.getNumPages()) {
%>
					<td width="<%=(pageNo > 1 && pageNo < articleDetail.getNumPages())?"50%":"100%"%>" >
						<a href="?<%=params%>&pg=<%=(pageNo+1)%>" class="button" style="float:right;">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Next&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						</a>
					</td>
<%
			}
%>
				</tr>	        
				<tr>
					<td align="right" <%=(pageNo < articleDetail.getNumPages()) ? "colspan=\"2\"" : "" %> class="pagenumber">
								<div >
									<a href="index.jsp?layout=<%=UserSession.INDEX_LAYOUT_MODE_LIST%>&<%=request.getQueryString()%>">
										<%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_LIST?"<b>List</b>":"List")%>
									</a>
									&nbsp;|&nbsp;
									<a href="index.jsp?layout=<%=UserSession.INDEX_LAYOUT_MODE_THUMBNAILS%>&<%=request.getQueryString()%>">
										<%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_THUMBNAILS?"<b>Thumb</b>":"Thumb")%>
									</a>
									&nbsp;|&nbsp;
	        							<%="Page "+pageNo+" of "+articleDetail.getNumPages()%>&nbsp;
								</div> 
					</td>
				</tr>	        			
			</table>
<%	        
	    }
%>
		</td>
	</tr><%-- end of eigth row of main containing table --%>
<%
	}
}
%>
</table>
<%
if (request.getParameterMap().size() == 0 || (request.getParameterMap().size() == 2 && request.getParameter("btn") != null && request.getParameter("nls") != null)) {
%>
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
<%
}
} catch (Exception ee) {
	out.write(ee.getMessage());
	website.writeToLog(ee);
}
%>
<!-- end of components/stocklisting.html -->