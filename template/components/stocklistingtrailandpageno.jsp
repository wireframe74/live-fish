<%@page import="co.simplypos.model.website.ArticleDetail" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="co.simplypos.model.website.page.model.StockDetailPageModel " %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>
<%@page import="co.simplypos.model.website.HTMLComponents2" %>
<%@page import="co.simplypos.model.utils.helpers.HTMLHelper" %>
<%@page import="co.simplypos.model.website.UserSession" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.io.File" %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean><%
try {
        String pageNoString = request.getParameter("pageNo");
        String numPagesString = request.getParameter("numPages");
        String navLocationString = request.getParameter("navLoc");
        String hideExtranav = request.getParameter("hideExtra");
        String params = request.getParameter("params");
        String queryString = request.getParameter("queryString");
        if (queryString == null) queryString = "";
        queryString = HTMLHelper.getQueryString(website, queryString, new String[]{"layout","pg","cName"});

        String trailHTML = userSession.getStoreHTMLTrailForCategoryPage();

        int pageNo = 1;
        int numPages = 1;
        int hideExtra = 0;
        if (pageNoString != null && !pageNoString.equals("")) {
                try {
                        pageNo = Integer.parseInt(pageNoString);
                } catch (NumberFormatException nfe) {
                        pageNo = 1;
                }
        }
        if (numPagesString != null && !numPagesString.equals("")) {
                try {
                        numPages = Integer.parseInt(numPagesString);
                } catch (NumberFormatException nfe) {
                        numPages = 1;
                }
        }
        if (hideExtranav  != null && !hideExtranav.equals("")) {
                try {
                        hideExtra = Integer.parseInt(hideExtranav);
                } catch (NumberFormatException nfe) {
                        hideExtra = 1;
                }
        }


        if (userSession == null) {
                out.write("Session has expired, refresh the page.");
        } else {
                if (request.getQueryString() != null) {
                        int sortOrder = userSession.getCurrentSortOrder();

                        if (request.getParameter("price1") != null && request.getParameter("price2") != null) {
                                double price1 = 0;
                                double price2 = 0;
                                try {
                                        price1 = Double.parseDouble(request.getParameter("price1"));
                                } catch (NumberFormatException nfe) {
                                        price1 = 0;
                                }
                                try {
                                        price2 = Double.parseDouble(request.getParameter("price2"));
                                } catch (NumberFormatException nfe) {
                                        nfe.printStackTrace();
                                        price2 = 0;
                                }
                                if (price1 > 0 || price2 > 0) sortOrder = UserSession.SORT_ORDER_ARTICLE_PRICE_ASC;
                        }

        %>


                <div class="page<%=navLocationString%>nav">
                        <ul class="crumb blocklist">
                                        <%=trailHTML%>
                        </ul>
                        <% if (!website.getuseSelectablePageNumbers()) { %>
                        <ul class="navPage blocklistright">
                                <%if (pageNo < numPages) { %>
                                        <li class="buttonnextpage">
                                                <a href="?<%=params%>&amp;pg=<%=(pageNo+1)%>"><%=website.getText("listingnextpage","Next Page")%></a>
                                        </li>
                                <% } %>
                                <% if (pageNo > 1) { %>
                                        <li class="buttonprevpage">
                                                <a href="?<%=params%>&amp;pg=<%=(pageNo-1)%>"> <%=website.getText("listingprevpage","Previous Page")%> </a>  <% //nm1 %>
                                        </li>
                                <% } %>

                        </ul>
                        <% } %>
                </div>
                <%if (hideExtra != 1) {%>
                        <div class="page<%=navLocationString%>navextra">
                                <% if (userSession.getArticleDetail().isLastPopulateHadArticles()) { %>
                                        <div class="stocklistingSortOptions">
                                                <form name="listSortForm" action="?<%=params%>" method="post">
                                                        <span class="sortByLabel"><%=website.getText("listingsortordertext","Sort results by")%></span>
                                                        <select class="sortSearch" name="listsort" id="listsort" onchange="submit()">
                                                                <option value="<%=UserSession.SORT_ORDER_MOST_POPULAR%>" <%=(sortOrder==UserSession.SORT_ORDER_MOST_POPULAR?"selected=\"selected\"":"")%>>Most Popular</option>
                                                                <option value="<%=UserSession.SORT_ORDER_ARTICLE_SHORT_DESCRIPTION%>" <%=(sortOrder==UserSession.SORT_ORDER_ARTICLE_SHORT_DESCRIPTION?"selected=\"selected\"":"")%>>Name</option>
                                                                <option value="<%=UserSession.SORT_ORDER_ARTICLE_PRICE_ASC%>" <%=(sortOrder==UserSession.SORT_ORDER_ARTICLE_PRICE_ASC?"selected=\"selected\"":"")%>>Price: low to high</option>
                                                                <option value="<%=UserSession.SORT_ORDER_ARTICLE_PRICE_DESC%>" <%=(sortOrder==UserSession.SORT_ORDER_ARTICLE_PRICE_DESC?"selected=\"selected\"":"")%>>Price: high to low</option>
                                                        </select>
                                                </form>
                                        </div>
                                <% } %>
                                <% if (!website.getuseSelectablePageNumbers()) { %>
                                <div class="stocklistingmodeandpagenumber">
                                        <a href="?layout=<%=UserSession.INDEX_LAYOUT_MODE_LIST%>&amp;<%=queryString%>">        <% //nm1 %>
                                                <%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_LIST?"<b>List</b>":"List")%>
                                        </a>
                                        |
                                        <a href="?layout=<%=UserSession.INDEX_LAYOUT_MODE_THUMBNAILS%>&amp;<%=queryString%>">  <% //nm1 %>
                                                <%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_THUMBNAILS?"<b>Thumb</b>":"Thumb")%>
                                        </a>
                                        |
                                        <%="Page "+pageNo+" of "+numPages%>
                                </div>
                                <% } else {%>
                                        <%if (numPages < 1) { %>
                                                <div class="stocklistingmodeandpagenumber">
                                                <a href="?layout=<%=UserSession.INDEX_LAYOUT_MODE_LIST%>&amp;<%=queryString%>">        <% //nm1 %>
                                                <%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_LIST?"<b>List</b>":"List")%>
                                                </a>
                                                |
                                                <a href="?layout=<%=UserSession.INDEX_LAYOUT_MODE_THUMBNAILS%>&amp;<%=queryString%>">  <% //nm1 %>
                                        <%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_THUMBNAILS?"<b>Thumb</b>":"Thumb")%>
                                </a>
                        </div>
                        <% } else { %>
                        <div class="stocklistingmodeandpagenumber">
                                <a href="?layout=<%=UserSession.INDEX_LAYOUT_MODE_LIST%>&amp;pg=1<%=("".equals(queryString)?"":"&"+queryString)%>">        <% //nm1 %>
                                        <%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_LIST?"<b>List</b>":"List")%>
                                </a>
                                |
                                <a href="?layout=<%=UserSession.INDEX_LAYOUT_MODE_THUMBNAILS%>&amp;pg=1<%=("".equals(queryString)?"":"&"+queryString)%>">  <% //nm1 %>
                                        <%=(userSession.getIndexLayoutMode()==UserSession.INDEX_LAYOUT_MODE_THUMBNAILS?"<b>Thumb</b>":"Thumb")%>
                                </a>
                        </div>
                <%}if (numPages > 1) {%>
                        <div id="pagenumber">
                                <%int numOfPagesDisplay =5;%>

                                <%String listingclass ="pageNum";%>
                                <%if( pageNo > 1 ){%><a href="?<%=params%>&amp;pg=<%=(pageNo-1)%>" id="previouspagebutton"> &lt; previous </a><% }%>
                                <%if(numPages > numOfPagesDisplay){%>
                                        <%if(pageNo ==1){listingclass ="pageNumActive";}%>
                                        <a href="?<%=params%>&amp;pg=1" class="<%=listingclass%>">1</a>
                                        <%int startPage=pageNo - (numOfPagesDisplay/2);%>
                                        <%if (startPage <= 1) {startPage=2;}%>
                                        <%int endPage = startPage + numOfPagesDisplay-1; %>
                                        <%if (endPage >= numPages){endPage = (numPages -1);startPage = (endPage - numOfPagesDisplay+1);}%>
                                        <%if (startPage <= 1) {startPage=2;}%>
                                        <%if (startPage >= 3){ %> .. <%}%>
                                        <%for(int i=startPage;i<=endPage;i++){%>
                                                <%listingclass ="pageNum";%>
                                                <%if(pageNo == i){ listingclass ="pageNumActive";}%>
                                                <a href="?<%=params%>&amp;pg=<%=i%>" class="<%=listingclass%>"> <%=i%></a>
                                        <%}%>
                                        <%if (endPage <= numPages -2){ %> .. <%}%>
                                        <%listingclass ="pageNum";%>
                                        <%if(pageNo ==numPages){listingclass ="pageNumActive";}%>
                                        <a href="?<%=params%>&amp;pg=<%=numPages%>" class="<%=listingclass%>"> <%=numPages%></a>
                                <%}else {%>
                                        <%for(int i=1;i<=numPages;i++){%>
                                                <%listingclass ="pageNum";%>
                                                <%if(pageNo == i){ listingclass ="pageNumActive";}%>
                                                <a href="?<%=params%>&amp;pg=<%=i%>" class="<%=listingclass%>"> <%=i%></a>
                                        <%}%>
                                <%}%>
                                <%if(pageNo < numPages){%><a href="?<%=params%>&amp;pg=<%=(pageNo+1)%>" id="nextpagebutton"> next &gt; </a><% }%>
                        </div>


                <%}%>

                                <% } %>
                        </div>
                <% } %>
<% } %>

<%
        }
} catch (Exception ee1) {
        website.writeToLog("Failed to get trail and page no for stocklistingtrailandpageno.jsp. Reason: "+ee1.getMessage());
}
%>

