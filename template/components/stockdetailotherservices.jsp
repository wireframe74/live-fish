
			<%@include file="stockdetailtellafriend.jsp"%>

		<form name="extrasform" method="post" action="<%=request.getRequestURL().toString()%>?rpid=<%=pageModel.getRecParentVendorArticleId()%>&amp;rid=<%=pageModel.getRecVendorArticleId()%>" >   <% //nm1 %>

				<%@include file="stockdetailgiftwrap.jsp"%>

			<% if (website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() != null) { %>

					<a name="personalisationoptions">

							<%=website.getText("personalisationoptions","Personalisation Options")%>

					</a>

					<% 
						String personalisationPageName = "forms/"+pageModel.getPersonalisationFormName();
						if (new File(website.getWebSitePath(),personalisationPageName+".html").exists()) {
							try {
								out.write(pageView.readPersonalisationFormAndApplyDefaultValues(new File(website.getWebSitePath(),personalisationPageName+".html")).toString());
							} catch (Exception ee) {
								website.writeToLog(ee);
								out.write("There is a problem with personalisation form for this product called "+personalisationPageName+".html"+". Reason: "+ee.getMessage());
							}
						}  
					%>

						<% if (pageModel.getParamTransLineId() > 0) { %>
							<input type="image" src="<%=website.getImagePath("update-basket-personalisation.gif")%>" name="<%=website.getUpdateBasketText()+" with Personalisation"+(pageModel.getQtyInBasket()==1?"":(" ("+pageModel.getQtyInBasket()+" item"+(pageModel.getQtyInBasket()==1?"":"s")+")"))%>" class="buttonupdatebasketpersonalisation" />
						<% }

                         		if (pageModel.getParamTransLineId() == 0) {
						  	if (pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY && pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY_HIDE_PRICE && pageModel.getUnitPrice() > 0) { %>
								<input type="image" src="<%=website.getImagePath("add-to-basket-personalisation.gif")%>" name="<%=website.getAddToBasketText()+" with Personalisation"%>" class="buttonaddtobasketpersonalisation" />
						  	<% } 
                         		}
                     			%>

			<% } %>
			<input type="hidden" name="id" value="<%=pageModel.getVendorArticleId()%>" /> 
			<input type="hidden" name="pid" value="<%=pageModel.getParentVendorArticleId()%>" /> 
			<input type="hidden" name="vacid" value="<%=pageModel.getVendorArticleClsfnId()%>" /> 
			<input type="hidden" name="qty" value="1" /> 
			<input type="hidden" name="price" value="<%=pageModel.getUnitPrice()%>" />
			<input type="hidden" name="tlid" value="<%=pageModel.getParamTransLineId()%>" /> 
			<input type="hidden" name="sqty" value="<%=pageModel.isArticleSet()?pageModel.getQuantity():userSession.getArticleDetail().getQuantity(pageModel.getParentVendorArticleId(), pageModel.getVendorArticleId())%>" />
			<input type="hidden" name="aibqty" value="<%=userSession.getShoppingBasket().getQuantityInBasket(pageModel.getParentVendorArticleId(), pageModel.getVendorArticleId())%>" />
			<input type="hidden" name=<%="\""+UserSession.URL_PARAM_NO_TRAIL_PHRASE+"\""%> value="1" /> 
			<input type="hidden" name="set" value="<%=pageModel.isArticleSet()?1:0%>" /> 
			<input type="hidden" name="unlimstock" value="<%=pageModel.isAllowOutOfStockOrdering()?1:0%>" />

		</form>
