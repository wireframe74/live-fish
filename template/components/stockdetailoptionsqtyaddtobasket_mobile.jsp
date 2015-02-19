<%@page import="co.simplypos.model.website.ArticleDetail" %>
<%@page import="co.simplypos.model.website.ArticleDetailImage" %>
<%@page import="co.simplypos.model.website.UserSession" %>
<%@page import="co.simplypos.model.website.page.model.StockDetailPageModel " %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>
<%@page import="co.simplypos.persistence.Article" %>
<%@page import="co.simplypos.persistence.VendorArticle" %>
<%@page import="co.simplypos.persistence.TransactionLine" %>
<%@page import="co.simplypos.interconnect.HTMLHelper" %>
<%@page import="java.util.Iterator" %>
<%@page import="java.io.File" %>
<jsp:useBean id="website" scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean>
<%
StockDetailPageModel pageModel = null;
try {
        pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
        StockDetailPageView pageView = (StockDetailPageView) userSession.getWebController().getCurrentPageController().getPageView();

        if (userSession == null) {
                out.write("Session has expired, refresh the page.");
        } else {
                int type = StockDetailPageView.ARTICLE_LIST_TYPE_MAIN_PRODUCT_PAGE;
                int seq = StockDetailPageView.ARTICLE_LIST_SEQ_MAIN_PRODUCT_PAGE;
%>
                        <form name="qtyform" method="post" action="detail.jsp?rpid=<%=pageModel.getRecParentVendorArticleId()%>&amp;rid=<%=pageModel.getRecVendorArticleId()%>">   <% //nm1 %>
                                <input type="hidden" name="action" value="" />

                                        <% if (!pageModel.isHasOptions() && pageModel.getOptionSetId() == 0) { %>
                                                <input type="hidden" name="id" value="<%=pageModel.getVendorArticleId()%>" />
                                                <input type="hidden" name="pid" value="<%=pageModel.getParentVendorArticleId()%>" />
                                        <% } else if (pageModel.isHasOptions()) { %>
                                                <input type="hidden" name="pid" value="<%=pageModel.getParamPid()%>" />
                                                <div id="productoptionselection">
                                                        <%=pageModel.getOptionList()%>
                                                </div>
                                        <% } %>

                                <% if (pageModel.isHasOptions() || pageModel.getOrderType() == VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY) { %>
                                        <input type="hidden" name="updbasket" value="<%=website.getAddToBasketText()%>" class="button_basket button" />
                                <% } %>
                                <% if (!pageModel.isHasOptions() || pageModel.isOption()) { %>
                                        <% if (pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY && pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY_HIDE_PRICE) { %>
                                                <% if (pageModel.getUnitPrice() > 0) { %>


                                                                <% if (userSession.hasActiveGiftList() && userSession.isGiftListOwner()) { %>
                                                                        <% if (userSession.getGiftListArticles() != null && userSession.getGiftListArticles().contains(new Integer(pageModel.getVendorArticleId()))) {
                                                                                if (false) { %>

                                                                                                <a href="javascript: document.qtyform.action.value='glRemove';document.qtyform.submit();"><img src="<%=website.getImagePath("remove-from-giftlist.gif")%>" alt="Remove from gift list" class="noBorder" /></a>

                                                                                <% } %>
                                                                        <% } else {     %>


                                                                                                <span class="detailquantitytext"><%=website.getText("detailquantity","Quantity")%></span>
                                                                                                <a class="detailquantityminus" href="javascript:qty_minus('qtyPlusMinus<%=seq%>', 1)"><%=website.getText("detailquantityminus","-")%> </a>
                                                                                                <input type="text" class="inputitem_productqty" id="qtyPlusMinus<%=seq%>" name="qty" value="1" size="1" />
                                                                                                <a class="detailquantityplus" href="javascript:qty_plus('qtyPlusMinus<%=seq%>', 99)"><%=website.getText("detailquantityplus","+")%> </a>



                                                                                        <a href="javascript: document.qtyform.action.value='glAdd';document.qtyform.submit();"><img src="<%=website.getImagePath("add-to-giftlist.gif")%>" alt="Add to gift list" class="noBorder" /></a>

                                                                        <% } %>
                                                                <% } else { %>
                                                                                <div class="addtobasketqty">
                                                                                <span class="detailquantitytext"> <%=website.getText("detailquantity","Quantity")%> </span>

                                                                                                <a class="detailquantityminus" href="javascript:qty_minus('qtyPlusMinus<%=seq%>', 1)"><%=website.getText("detailquantityminus","-")%> </a>
                                                                                        <input type="text" class="inputitem_productqty" id="qtyPlusMinus<%=seq%>" name="qty" value="1" size="1" />
                                                                                        <a class="detailquantityplus" href="javascript:qty_plus('qtyPlusMinus<%=seq%>', 99)"><%=website.getText("detailquantityplus","+")%> </a>
                                                                                </div>
                                                                        <input type="hidden" name="price" value="<%=pageModel.getUnitPrice()%>" />

                                                                                <a  name="<%=website.getAddToBasketText()%>" class="buttonaddtobasket" href="javascript: addToBasket(<%=type%>,<%=seq%>,<%=pageModel.getVendorArticleId()%>)"
 >
                                                                                        <%=website.getText("detailAddtobasket","<span>Add to basket</span>")%>
                                                                                </a>

                                                                <% } %>

                                                <% } %>
                                        <% } %>


                                                <ul class="detailextras">
                                                        <% if (website.isOfferGiftWrappingService()) { %>
                                                                <li>
                                                                   <a id="extrasgiftwrap" class="extras" href="#giftwrapoptions" onclick='javascript:document.getElementById("div_giftwrapoptions").style.display="";' >
                                                                        <span class="extrastext"> <%=website.getText("handwritecard","Giftwrapping")%> </span>
                                                                   </a>
                                                                </li>
                                                        <% } %>
                                                        <% if (website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() != null) { %>
                                                                <li>
                                                                   <a class="extras" id="extraspersonalisation" href="#personalisationoptions" >
                                                                        <span class="extrastext"> <%=website.getText("personalisationOptions","Personalisation")%> </span>
                                                                   </a>
                                                                </li>
                                                        <% }else { %>
                                                                <% if (website.isOfferWritingService()) { %>
                                                                        <li>
                                                                         <a class="extras" id="extrahandwritecard" href="#giftwrapoptions" onclick='javascript: document.getElementById("div_giftwrapoptions").style.display = "";'>
                                                                                <span class="extrastext"> <%=website.getText("handwritecard","Handwrite Card")%> </span>
                                                                         </a>
                                                                        </li>

    <% } %>
                                                        <% } %>


                                                <% if (website.isShowTellAFriend()) { %>
                                                        <li>
                                                        <a href="#tellafriend" class="extras" id="extrastellafriend" onclick='javascript: document.getElementById("div_tellafriend").style.display = "";document.tellafriendform.tellyourname.focus();'>
                                                                <span class="extrastext"> <%=website.getText("tellafriend","Tell a friend")%> </span>
                                                        </a>
                                                        </li>
                                                <% } %>
                                                </ul>



                                <% } else { %>
                                        <% if (website.isShowTellAFriend()) { %>

                                                        <a href="#tellafriend" onclick='javascript: document.getElementById("div_tellafriend").style.display = "";document.tellafriendform.tellyourname.focus();'>
                                                                <%=website.getText("tellafriend","Tell a friend")%>
                                                        </a>

                                        <% } %>
                                <% } %>
                                <% if (pageModel.getMessageTypeDomainId() == TransactionLine.MESSAGE_TYPE_LINE_NOTE) {
                                        String personalShoppingMessage = pageModel.getGiftwrapOrCardWrittenMessage();
                                        if (!(""+personalShoppingMessage).startsWith("FORM PERSONALISATION:")) {
                                %>

                                                        <img align="left" src="<%=website.getImagePath("psshopper.png")%>" alt="Personal Shopping Note" />
                                                        <%=HTMLHelper.applyHTML(personalShoppingMessage)%>

                                <%      }
                                  } %>
                                <input type="hidden" name='vacid' value='<%=pageModel.getVendorArticleClsfnId()%>' />
                                <input type="hidden" name='tlid' value='<%=pageModel.getParamTransLineId()%>' />
                                <input type="hidden" name='sqty' value='<%=pageModel.isArticleSet()?pageModel.getQuantity():userSession.getArticleDetail().getQuantity(pageModel.getParentVendorArticleId(), pageModel.getVendorArticleId())%>' />
                                <input type="hidden" name='aibqty' value='<%=userSession.getShoppingBasket().getQuantityInBasket(pageModel.getParentVendorArticleId(), pageModel.getVendorArticleId())%>' />
                                <input type="hidden" name=<%="'"+UserSession.URL_PARAM_NO_TRAIL_PHRASE+"'"%> value='1' />
                                <input type="hidden" name='set' value='<%=pageModel.isArticleSet()?1:0%>' />
                                <input type="hidden" name='unlimstock' value='<%=pageModel.isAllowOutOfStockOrdering()?1:0%>' />
                        </form>
<%
        }
} catch (Exception ee1) {
        website.writeToLog("Failed to render stockdetailoptionsqtyaddtobasket fragment for: "+(pageModel!=null?pageModel.getVendorArticleId():"[unknown]")+". Reason: "+ee1.getMessage());
}
%>


