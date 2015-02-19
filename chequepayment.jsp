<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />

				<% try {

                                String textEmailBody = website.getWebsiteName()+"\n\r"+userSession.getLoggedInCustomerName()+"\n\r\n\rThank you for your order.\n\r\n\rThis is to confirm that you have opted to pay by cheque.\n\r"+website.getWebSiteURL();
                                String htmlEmailBody = "<br>"+userSession.getLoggedInCustomerName()+"<br><br>Thank you for your order.<br><br>This is to confirm that you have opted to pay by cheque.<br><br><a href='"+website.getWebSiteURL()+"'>"+website.getWebsiteName()+"</a>";
                                website.sendEmail(userSession.getLoggedInCustomerEmailAddress(), website.getWebsiteName(), textEmailBody, htmlEmailBody);
                            } catch (Exception eas1) {
	                            %>
       	                     <script type="text/javascript">
       	                     	<!--
								alert ("Failed to send an email informing the merchant you wish to pay by cheque. Please contact the merchant yourself to inform them you are paying by cheque.");
								//-->
              	              </script>
                     	       <%
                            }%>

<jsp:include page='chequepayment.html' />
