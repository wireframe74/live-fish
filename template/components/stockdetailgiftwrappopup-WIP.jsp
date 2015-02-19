<!-- start of components/stockdetailgiftwrappopup.jsp -->
<%@page import="co.simplypos.model.website.page.model.StockDetailPageModel" %>
<%@page import="co.simplypos.model.website.page.view.StockDetailPageView" %>
<%@page import="co.simplypos.model.website.page.controller.StockDetailPageController" %>
<%@page import="co.simplypos.model.website.HTMLComponents" %>
<%@page import="co.simplypos.persistence.TransactionLine" %>
<%@page import="co.simplypos.persistence.VendorArticle" %>
<%@page import="co.simplypos.persistence.Article" %>
<%@page import="java.util.Vector" %>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<link rel="stylesheet" href="../style.css" type="text/css" />
<% 
StockDetailPageModel pageModel = null;
StockDetailPageView pageView = null;
try { 
	pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
	pageView = (StockDetailPageView) userSession.getWebController().getCurrentPageController().getPageView();
} catch (Exception ee) {
	website.writeToLog(ee);
	out.write("Could not load page: "+ee.getMessage());
}
%>
<div id='stockdetailgiftwrapoptions' class="stockcontainer">

  <form name="extrasform" method="post" action="<%=request.getParameter("actionURL")%>?rpid=<%=pageModel.getRecParentVendorArticleId()%>&rid=<%=pageModel.getRecVendorArticleId()%>" >


	<table width="99%" cellspacing="0" cellpadding="2" border="0">
		<tr>
			<td>
			<table width="100%" cellspacing="0" cellpadding="0">
				<%
         		if (pageModel.getArticleSubType() == Article.ARTICLE_SUB_TYPE_STANDARD_GIFT) {
				%>
				<tr>
					<td>
						<table width=100% cellspacing=0 cellpadding=0>
							<tr>
								<td></td>
								<td>
									<table width=100% border=0 cellspacing=0 cellpadding=0>
										<tr>
											<td class="smalltext" align="right">Would you like us to wrap this gift?&nbsp;&nbsp;</td>
											<td><select name="wrapgift">
												<%=pageModel.getWrappingOptionsList()%>
											</select></td>
										</tr>
										<% if (!website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() == null) { %>
										   <tr>
											<td class="smalltext" align="right">Would you like a gift tag on this gift?&nbsp;&nbsp;</td>
											<td><input type="radio" name="gifttag"
												value="<%=TransactionLine.MESSAGE_TYPE_NO_MESSAGE%>"
												<%=pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE||pageModel.getMessageTypeDomainId()==0?"checked":""%>
												onclick='javascript: document.getElementById("div_message").style.display = "none";'>No</input>
											<input type="radio" name="gifttag"
												value="<%=TransactionLine.MESSAGE_TYPE_GIFT_TAG%>"
												<%=pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE||pageModel.getMessageTypeDomainId()==0?"":"checked"%>
												onclick='javascript: document.getElementById("div_tempfield").style.display = "";document.getElementById("div_message").style.display = "";document.extrasform.tempfield.focus();document.getElementById("div_tempfield").style.display = "none";document.qtyform.gifttagmessage.focus();'><%=pageModel.getGiftwrapOrCardYesTagText()%></input>
											</td>
										   </tr>
										<% } %>
									</table>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<% if (!website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() == null) { %>
				   <tr>
					<td>
	
					<table width=100% align=right valign=top border=0>
						<tr>
							<td width=100% align=right valign=top>
								<div id='div_message' style='display:"<%=pageModel.getMessageTypeDomainId()==0||pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE?"none":""%>";'>
									<table width=100% border=0>
										<tr>
											<td valign=top align=right>
											<div class="smalltext">Gift tag message:</div>
											<div class="tinytext"><br>
											<br>
											We reserve the right to exclude any part of the message that is
											deemed to be offensive</div>
											</td>
											<td align=right width=1><textarea name="gifttagmessage"
												rows="5" cols="37"><%=pageModel.getGiftwrapOrCardWrittenMessage()%></textarea>
											</td>
										</tr>
									</table>
								</div>
		
								<script type='text/javascript'>
		            				document.getElementById("div_message").style.display="<%=pageModel.getMessageTypeDomainId()==0||pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE?"none":""%>";
		        				</script>
		        			</td>
						</tr>
					</table>
					</td>
				</tr>
				
				<%
				}
	        	} else if (pageModel.getArticleSubType() == Article.ARTICLE_SUB_TYPE_STANDARD_CARD && !website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() == null) { %>

				<tr>
					<td>
					<table width=100% cellspacing=0 cellpadding=0>
						<tr>
							<td></td>
							<td>
								<table class="smallertext" width=100% border=0 cellspacing=0 cellpadding=0>
									<tr>
										<td width=65%><%=website.getText("giftwrapandhandwritecardquestion","Would you like one of our staff to handwrite a message inside this card?")%>
										</td>
										<td><input type="radio" name="gifttag"
											value="<%=TransactionLine.MESSAGE_TYPE_NO_MESSAGE%>"
											<%=pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE||pageModel.getMessageTypeDomainId()==0?"checked":""%>
											onclick='javascript: document.getElementById("div_message").style.display = "none";'>No	thanks</td>
									</tr>
									<tr>
										<td></td>
										<td><input type="radio" name="gifttag"
											value="<%=TransactionLine.MESSAGE_TYPE_INSIDE_CARD%>"
											<%=pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE||pageModel.getMessageTypeDomainId()==0?"":"checked"%>
											onclick='javascript: document.getElementById("div_tempfield").style.display = "";document.getElementById("div_message").style.display = "";document.extrasform.tempfield.focus();document.getElementById("div_tempfield").style.display = "none";document.qtyform.gifttagmessage.focus();'><%=pageModel.getGiftwrapOrCardYesTagText()%></input>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
					</td>
				</tr>
				<tr>
					<td>
					<table width=100% align=right valign=top border=0>
						<tr>
							<td width=100% align=right valign=top>
							<div id="div_message" style="display:<%=pageModel.getMessageTypeDomainId()==0||pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE?"none":""%>;">
								<table width=100% border=0>
									<tr>
										<td align=right valign=top><FONT class=mediumtext
											color=green size=2> Message: </FONT> <FONT
											style="font.size:10px" color=black> <br>
										<br>
										<%=website.getText("giftwrapandhandwritecardexcludetextwarning","We reserve the right to exclude any part of the message that is deemed to be offensive")%>
										</FONT></td>
										<td align=right width=1><textarea name="gifttagmessage"
											rows="15" cols="37"><%=pageModel.getGiftwrapOrCardWrittenMessage()%></textarea>
										</td>
									</tr>
								</table>
							</div>
							<script type='text/javascript'>
		            			document.getElementById("div_message").style.display="<%=pageModel.getMessageTypeDomainId()==0||pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE?"none":""%>";
       				  		</script></td>
						</tr>
					</table>
					</td>
				</tr>
				<%
       			}
				%>
				<tr>
					<td align=right>
					<table border=0 cellpadding=2 cellspacing=0>
						<tr>
							<td>
								<%
                         				if (pageModel.getParamTransLineId() > 0) {
                     					%>
									<table width="250" align=right cellspacing=0 cellpadding=0
										bottommargin=0 topmargin=0>
										<tr>
											<td width="100%" valign="middle" align="right">
												<% if (1==0) { %>
													<a href='javascript: document.qtyform.updbasket.value=2; document.qtyform.submit();' class="button">&nbsp;&nbsp;&nbsp;&nbsp;Update <%=(pageModel.getQtyInBasket()==1?"":""+pageModel.getQtyInBasket())+" item"+(pageModel.getQtyInBasket()==1?"":"s")%>&nbsp;&nbsp;&nbsp;&nbsp;</a><br>
												<% } %>
												<INPUT type="submit" name="updbasket" value="<%=website.getUpdateBasketText()+(pageModel.getQtyInBasket()==1?"":(" ("+pageModel.getQtyInBasket()+" item"+(pageModel.getQtyInBasket()==1?"":"s")+")"))%>" class="button_basket button"> 																		

											</td>
										</tr>
									</table>	
								<%
                         				}
                     					%>
							</td>
							<td>
								<%
                         				if (pageModel.getParamTransLineId() == 0) {
                     					%>
								<table align=left cellspacing=0 cellpadding=0 bottommargin=0 topmargin=0>
									<tr>
										<% 											  
									  	if (pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY && pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY_HIDE_PRICE) {

									  		if (1==0 && !pageModel.isAllowOutOfStockOrdering()) { %>
												<td valign="middle">
													<a
													href='javascript: if (ValidateQty()) { document.qtyform.updbasket.value=1; document.qtyform.submit(); }'
													class="button">&nbsp;&nbsp;&nbsp;Add to Basket&nbsp;&nbsp;&nbsp;&nbsp;</a>
												</td>
												<td width="2"></td>
												<td valign="middle"><img
													src="<%=website.getImagePath("btnright.gif")%>" alt=""
													class="btnLeft" />
												</td>
											<% } else if (1==0) { %>
												<td valign="middle">
													<a href='javascript: document.qtyform.updbasket.value=1; document.qtyform.submit(); '
													class="button">&nbsp;&nbsp;&nbsp;Add to	Basket&nbsp;&nbsp;&nbsp;&nbsp;</a>
												</td>
												<td width="2">
												</td>
												<td valign="middle"><img src="<%=website.getImagePath("btnright.gif")%>" alt="" class="btnLeft" />
												</td>
											<% } %>

											<input type="submit" name="updbasket" value="<%=website.getAddToBasketText()%>" class="buttonaddtobasket"> 																		

									  	<% } %>
						
										

									</tr>
								</table>
								<%
                         				}
                     					%>
							</td>
						</tr>
					</table>
					</td>
				</tr>							
			</table>
			</td>
		</tr>
		<tr>
			<td>
			<div id="div_tempfield" style="display:none;"><input type=text border=0 name='tempfield'></div>
			<script type='text/javascript'>
		    		document.getElementById("div_tempfield").style.display = "none";
		      </script></td>
		</tr>
	</table>
   </form>
</div>
<script type='text/javascript'>
	document.getElementById("div_giftwrapoptions").style.display="<%=pageModel.isHideServices()?"none":""%>";
</script>
<!-- end of components/stockdetailgiftwrappopup.jsp -->
