<%@page import="co.simplypos.model.website.HTMLComponents" %>
<%@page import="co.simplypos.model.website.UserSession" %>
<%@page import="co.simplypos.model.website.WebSite" %>
<%@page import="co.simplypos.model.website.page.controller.StockListingPageController" %>
<%@page import="co.simplypos.model.website.page.PageController" %>
<%@page import="java.io.File" %>
<%@page import="java.util.*" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%
String templatePage = userSession.getCurrentTemplatePage();
if (!WebSite.isThisPageInList(request, "detail") || (templatePage.equalsIgnoreCase("stocklisting") || templatePage.equalsIgnoreCase("stocklistingnew"))) {
	userSession.setLastIndexPageKey("sn_"+userSession.getUniquePageStringKey(request, false));
}
String lastIndexPageKey = userSession.getLastIndexPageKey();

ArrayList currentDescsUsed = new ArrayList(); 
String currRefineHtml = co.simplypos.model.website.HTMLComponents.getCurrentRefinementSelection(request, userSession, "topTagRefine", "Refine by ", currentDescsUsed);	
%>

<% 
try { 
PageController pageController = userSession.getWebController().getCurrentPageController(); 
if (pageController instanceof StockListingPageController) {
	((StockListingPageController)pageController).populatePageModel(request, userSession.getWebController().getParamPid());
}
if (!website.isUsingRefinementSearch()) website.setUsingRefinementSearch(true);

if (!WebSite.isThisPageInList(request, "register,delivery,confirm")) { 
   String currencySymbol = userSession.getCurrencySymbol(); 
   boolean useTopImage = false;
   if (new File(website.getWebSitePath()+"images/lm-top.gif").exists()) useTopImage = true;
   boolean useFootImage = false;
   if (new File(website.getWebSitePath()+"images/lm-bottom.gif").exists()) useFootImage = true;

   if (!WebSite.isThisPageInList(request, "detail") && (!WebSite.isThisPageInList(request, "index") || (userSession.getWebController().getId() == 0 && request.getParameter("tag") == null) && (request.getParameter("price1") == null || request.getParameter("price1").trim().equals("")) && (request.getParameter("searchStr") == null || request.getParameter("searchStr").trim().equals("")) && (request.getParameter("brand") == null || request.getParameter("brand").trim().equals("0") || request.getParameter("brand").trim().equals("")))) { 
%>	
	<div id="quickshop" class="refineblock">
		<%=(useTopImage?"<div><img src=\"images/lm-top.gif\" /></div>":"")%>
		<h2>Quick Shop</h2>
		<form name="quickShopForm" action="index.jsp" method="get">
			<%=co.simplypos.model.website.HTMLComponents.getTagFilterOptions(request, userSession, "topTagSelect", true /*whether to submit on change*/, false)%>
		</form>	
		<div class="refinehead">Search our site</div>
		<div style="padding-left:11px;">
			<form name="searchform" action="index.jsp">
				<input name="searchStr" type="text" id="search" onfocus="this.value=(this.value=='search item or keyword')? '' : this.value ;" value="search item or keyword" size="17" />
				<input type="submit" value="Go" alt="Go" />
			</form>
		</div>
		<div id="rs_currprice" class="refineblock">	
			<div class="refinehead">Shop by price</div>	
			<ul class="refineitems">
				<%String tagParamsPrice = "";%>
				<%@include file='../../pricesearch.html' %>
			</ul>
		</div>	
	</div>
	<%=(useFootImage?"<img src=\"images/lm-bottom.gif\" />":"")%>
  <% } else { 
	String furtherRefineHtml = "";

	String tagParamsPrice = userSession.getNavigationRefinementSettings().getRefinementAsQueryString(true,true,false,true,true,true,true,true,true);
	String tagParamsSearchStr = userSession.getNavigationRefinementSettings().getRefinementAsQueryString(true,true,true,true,false,true,true,true,false);

	String catHtml = co.simplypos.model.website.HTMLComponents.getRefineCategoriesHTML(userSession);
	if (catHtml != null) furtherRefineHtml += "<div id=\"refinceCategories\"><div class=\"refinehead\">Refine by category</div><div class=\"refineitems\">"+catHtml+"</div></div>";
	String brandHtml = co.simplypos.model.website.HTMLComponents.getRefineBrandsHTML(request, userSession);
	if (brandHtml != null) furtherRefineHtml += "<div id=\"refinceBrands\"><div class=\"refinehead\">Refine by brand</div><div class=\"refineitems\">"+brandHtml+"</div></div>";
	furtherRefineHtml += co.simplypos.model.website.HTMLComponents.getTagFilterOptionsAsLinks(request, userSession, "topTagRefine", true, "Refine by ");
	if (website.getNavigationRefinementOptionsTitles() != null && website.getNavigationRefinementOptionsTitles().get(0) != null) {
		String optionLev1Html = co.simplypos.model.website.HTMLComponents.getRefineOptionsHTML(request, userSession, 1, true);
		if (optionLev1Html != null) furtherRefineHtml += optionLev1Html;
		String optionLev2Html = co.simplypos.model.website.HTMLComponents.getRefineOptionsHTML(request, userSession, 2, true);
		if (optionLev2Html != null) furtherRefineHtml += optionLev2Html;
		String optionLev3Html = co.simplypos.model.website.HTMLComponents.getRefineOptionsHTML(request, userSession, 3, true);
		if (optionLev3Html != null) furtherRefineHtml += optionLev3Html;
	}
	boolean isPriceSearch = (request.getParameter("price1") != null && request.getParameter("price2") != null && !request.getParameter("price1").trim().equals("") && !request.getParameter("price2").trim().equals("") && !request.getParameter("priceDesc").trim().equals("show"));
	boolean isTextStrSearch = (request.getParameter("searchStr") != null && !request.getParameter("searchStr").trim().equals(""));

	if (currRefineHtml != null && !currRefineHtml.equals("")) { %>		
		<div id="refinecurrent" class="refineblock">	
		<%=(useTopImage?"<div><img src=\"images/lm-top.gif\" /></div>":"")%>
		<div class="refinetitle">Current selection</div>
		<div class="refinehead">(click any item to remove)</div>
		<%=currRefineHtml%>
		</div>
		<%=(useFootImage?"<img src=\"images/lm-bottom.gif\" />":"")%>
		<div id="refinespacer"></div>
	<% } %>
	<% if ((furtherRefineHtml != null && !furtherRefineHtml.equals("")) || !isPriceSearch || !isTextStrSearch ) { %>
		<div id="refinefurther" class="refineblock">
		<%=(useTopImage?"<div><img src=\"images/lm-top.gif\" /></div>":"")%>
		<h2>Refine your search</h2>
		<%=furtherRefineHtml %>
		<% if (!isPriceSearch) { %>
		  <div id="taghdrsearch" class="refineblock">	
			<div class="refinehead">Refine by price</div>
			<ul class="refineitems">				
				<%@include file='../../pricesearch.html' %>
			</ul> 
		  </div>
		<% } %>		
	 	 <div id="taghdrsearchstr" class="refineblock">	
		 <div class="refinehead">Refine by keyword search</div>
		 <div style="padding-left:15px;">
			<form name="searchform" action="<%=HTMLComponents.getCategoryRefinementPageName(request,"search")%>?<%=tagParamsSearchStr%>" method="post">
				<input name="searchStr" type="text" id="search" onfocus="this.value=(this.value=='search item or keyword')? '' : this.value ;" value="search item or keyword" size="17" />
				<input type="submit" value="Go" alt="Go" />
			</form>
		 </div>
		 </div>		
		</div>
		<%=(useFootImage?"<img src=\"images/lm-bottom.gif\" />":"")%>
	<% } %>

  <% } %>
<% }
} catch (Exception ee) { 
	website.writeToLog(ee.getMessage());
} 
%>

<%
try {
  if (!userSession.getNavigationRefinementSettings().isHasRefinementNavigation()) {
	userSession.getNavigationRefinementSettings().clearCurrentRefinementPageNameCache();
  } else {	
	Hashtable<String,String> ht = new Hashtable<String,String>();
	Iterator<String> currCacheIter = userSession.getNavigationRefinementSettings().getCurrentRefinementPageNameCache().keySet().iterator();
	while (currCacheIter.hasNext()) {
		String cacheKey = currCacheIter.next();
		if (currentDescsUsed.contains(cacheKey)) {
	        	ht.put(cacheKey, userSession.getNavigationRefinementSettings().getCurrentRefinementPageNameCache().get(cacheKey));
        	}
	}
	userSession.getNavigationRefinementSettings().setCurrentRefinementPageNameCache(ht);
  }
        
} catch (Exception ee) { 
	website.writeToLog(ee);
} 
%>
