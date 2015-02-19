<img src="images/payment-methods.png" class="pull-left payment-methods" /><% if (co.simplypos.model.website.tracking.Feefo.isFeefoEnabled(userSession)) { 
String pfxProtocol = (request.getRequestURL().toString().startsWith("https")?"https":"http");
%>
<div id="feefofooterlogo">

<a href="<%=pfxProtocol%>://www.feefo.com/feefo/viewvendor.jsp?logon=<%=((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).feefoLogin%>" onclick="window.open(this.href,'Feefo','width=800,height=600,scrollbars,resizable');
return false;"><img src="<%=pfxProtocol%>://www.feefo.com/feefo/feefologo.jsp?logon=<%=((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).feefoLogin%>&template=N178x60W.gif" border="0" alt="Feefo logo"
title="See what our customers say about us"></a>
</div>
<% } %>
<div id="pagetimestamp"><%=website.getWebsiteName()+" - "+new java.util.Date()%>&nbsp;<% String servertag=null;try {servertag=new String(co.simplypos.model.utils.helpers.FileHelper.readSmallFile(new java.io.File("/home/public/server_name.txt"))); } catch (Exception e34hg3) { servertag="[]";}%><%=servertag%></div><%
out.write(userSession.getTrackingController().getScript(request, userSession.getWebController().isThankYouPage()));
%><%@include file="/analytics.html"%></body>
<% if (request.getRequestURI().indexOf("quickpay.jsp") > -1 && ((QuickPayPageModel)userSession.getWebController().getCurrentPageController().getPageModel()).isAddressLookupFailed()) { 
	((QuickPayPageModel)userSession.getWebController().getCurrentPageController().getPageModel()).setAddressLookupFailed(false); %>
	<script>GB_showCenter('Review Address Details','../../../components/changeaddrpopup.jsp?addressid=<%=userSession.getDeliveryAddressId()%>&addresstype=<%=request.getParameter("addresstype")%>&failedlookup=1&failedreason=<%=((QuickPayPageModel)userSession.getWebController().getCurrentPageController().getPageModel()).getAddressLookupFailedMessage()%>', 580, 660, 0);</script>
<% } %>
<script type="text/javascript">
if (top.location != self.location) {
	top.location = self.location.href
}
</script>
</html>