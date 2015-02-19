<!-- start of components/quickpaypostcodelookup.jsp -->
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" /><%
String html = "";
if (userSession.getShoppingBasket().getOrderTotalIncVAT() > 0 || co.simplypos.model.website.ShoppingBasket.isFullyPaidByVoucher(userSession, request)) { 
	String baseURL = userSession.getWebSite().getWebSiteURL();
	baseURL = baseURL.substring(4, baseURL.lastIndexOf("/") + 1);
	String actionURL = "https"+baseURL+"quickpay.jsp";
%>
	<div id="pcl_quickcheckout" class="quickcheckout">
		<form id="quickpayform" name="quickpay" action="<%=actionURL%>" method="post" >
			<input type="hidden" name="action" value="quickpaypcl" />
			<input type="hidden" name="src" value="" />
			<input type="hidden" name="addresstype" value="<%=request.getParameter("addresstype")%>" />
			<div>
				<span class="pcl_postcode_label">Post Code/Zip:</span>
				<input class="pcl_postcode" name="qc-postcode" type="text" size="8"  value="" onfocus="this.value='';" />
				<span class="pcl_houseno_label">House Name/No:</span>
				<input class="pcl_houseno"  name="qc-house"    type="text" size="10" value="" onfocus="this.value='';" />
			</div>
			<div id="quickpaylookupline2">
				<span class="pcl_name_label">Full Name:</span>
				<input class="pcl_name"     name="qc-name"     type="text" size="12" value="" onfocus="this.value='';" />
				<input type="submit" id="quickpaygetaddress" class="buttonbig" name="submit1" align="right" value="<%=website.getText("quickpayGetAddress","Get Address")%>">
			</div>
		</form>
	</div>
<% } %><!-- end of components/quickpaypostcodelookup.jsp -->