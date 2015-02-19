<!-- start of components/stockdetailgiftwrap.jsp -->
<div id='div_giftwrapoptions' style='display:"<%=pageModel.isHideServices()&&request.getParameter("gwon")==null?"none":""%>";' class="stockcontainer componentBorder">
	<a name="giftwrapoptions"></a> 
	<%
		String pageTitleGiftwrap = "";
            if (pageModel.getArticleSubType() == Article.ARTICLE_SUB_TYPE_STANDARD_GIFT) {
			pageTitleGiftwrap = website.getText("giftwrapping",website.getGiftwrapText());
            } else {
			pageTitleGiftwrap = website.getText("handwritecard",website.getHandwriteText());
            }
	%>

	<h3><%=pageTitleGiftwrap%></h3>
	
				
					<% if (pageModel.getArticleSubType() == Article.ARTICLE_SUB_TYPE_STANDARD_GIFT) { %>
					<p>	Would you like us to wrap this gift?
												
													<select name="wrapgift">
														<%=pageModel.getWrappingOptionsList()%>
												    	</select>
					</p>							
											
												<% if (!website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() == null) { %>
					<p>						   	
												Would you like a gift tag on this gift?

			<input type="radio" name="gifttag" value="<%=TransactionLine.MESSAGE_TYPE_NO_MESSAGE%>" onclick="javascript:document.getElementById('div_message').style.display='none';" <%=pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE||pageModel.getMessageTypeDomainId()==0?"checked=\"checked\"":""%> />
				No
			<input type="radio" name="gifttag" value="<%=TransactionLine.MESSAGE_TYPE_GIFT_TAG%>" onclick="javascript:document.getElementById('div_message').style.display='';document.qtyform.gifttagmessage.focus();" <%=pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE||pageModel.getMessageTypeDomainId()==0?"":"checked=\"checked\""%> /> 
				<%=pageModel.getGiftwrapOrCardYesTagText()%>
					</p>	
												<% } %>
										
					<% if (!website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() == null) { %>
				   						<div id="div_message" style="display:'<%=pageModel.getMessageTypeDomainId()==0||pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE?"none":""%>';">
											<p>
													Gift tag message:
														
														We reserve the right to exclude any part of the message that is
														deemed to be offensive
											</p>		
												<textarea name="gifttagmessage" rows="5" cols="10"><%=pageModel.getGiftwrapOrCardWrittenMessage()%></textarea>												
										</div>
		
										<script type='text/javascript'>
		            							document.getElementById("div_message").style.display="<%=pageModel.getMessageTypeDomainId()==0||pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE?"none":""%>";
		        							</script>
		        			
					<%
					}
	        			} else if (pageModel.getArticleSubType() == Article.ARTICLE_SUB_TYPE_STANDARD_CARD && !website.isShowPersonalisationForms() && pageModel.getPersonalisationFormName() == null) { %>

						<%=website.getText("giftwrapandhandwritecardquestion","Would you like one of our staff to handwrite a message inside this card?")%>
												<input type="radio" name="gifttag" value="<%=TransactionLine.MESSAGE_TYPE_NO_MESSAGE%>"
													<%=pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE||pageModel.getMessageTypeDomainId()==0?"checked":""%>
													onclick='javascript: document.getElementById("div_message").style.display = "none";'/>No	thanks
												
												<input type="radio" name="gifttag"
													value="<%=TransactionLine.MESSAGE_TYPE_INSIDE_CARD%>"
													<%=pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE||pageModel.getMessageTypeDomainId()==0?"":"checked"%>
													onclick='javascript: document.getElementById("div_tempfield").style.display = "";document.getElementById("div_message").style.display = "";document.extrasform.tempfield.focus();document.getElementById("div_tempfield").style.display = "none";document.qtyform.gifttagmessage.focus();' />
													<%=pageModel.getGiftwrapOrCardYesTagText()%>
												
										<div id="div_message" style="display:<%=pageModel.getMessageTypeDomainId()==0||pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE?"none":""%>;">
												 Message:  
															<%=website.getText("giftwrapandhandwritecardexcludetextwarning","We reserve the right to exclude any part of the message that is deemed to be offensive")%>
														<textarea name="gifttagmessage" rows="15" cols="37"><%=pageModel.getGiftwrapOrCardWrittenMessage()%></textarea>
										</div>
										<script type='text/javascript'>
		            							document.getElementById("div_message").style.display="<%=pageModel.getMessageTypeDomainId()==0||pageModel.getMessageTypeDomainId()==TransactionLine.MESSAGE_TYPE_NO_MESSAGE?"none":""%>";
       				  					</script>
									
					<% } %>
										<% if (pageModel.getParamTransLineId() > 0) { %>
									
													<input type="hidden"  name="<%=website.getUpdateBasketText()+(pageModel.getQtyInBasket()==1?"":(" ("+pageModel.getQtyInBasket()+" item"+(pageModel.getQtyInBasket()==1?"":"s")+")"))%>" />
													<a  name="<%=website.getAddToBasketText()%>" class="buttonaddtobasket" href="javascript: document.extrasform.submit()" >
                                                                                                                <%=website.getText("detailUpdatebasket","<span>Update basket</span>")%>
                                                                                                        </a>

											
										<% } %>
									
										<% if (pageModel.getParamTransLineId() == 0) { %>
										
												<% if (pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY && pageModel.getOrderType() != VendorArticle.ORDER_TYPE_ENQUIRIES_ONLY_HIDE_PRICE) { %>												
													<input type="hidden" name="<%=website.getAddToBasketText()%>"  />
													<a  name="<%=website.getAddToBasketText()%>" class="buttonaddtobasket" href="javascript: document.extrasform.submit()" >
                                                                                        			<%=website.getText("detailAddtobasket","<span>Add to basket</span>")%>
                                                                                			</a>

									  			<% } %>
											
										<% } %> 
			
				
					<input type="text" name="tempfield" id="tempfield" style="dispaly:none"/>
				
					<script type='text/javascript'>
		    			document.getElementById("tempfield").style.display = "none";
		    			</script>
			
</div>
<script type='text/javascript'>
	document.getElementById("div_giftwrapoptions").style.display="<%=pageModel.isHideServices()?"none":""%>";
</script>
<!-- end of components/stockdetailgiftwrap.jsp -->
