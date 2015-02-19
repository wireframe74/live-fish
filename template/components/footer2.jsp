<% if (co.simplypos.model.website.tracking.Feefo.isFeefoEnabled(userSession)) { 
	String pfxProtocol = (request.getRequestURL().toString().startsWith("https")?"https":"http");%>
	<div id="feefofooterlogo">
		<a href="<%=pfxProtocol%>://www.feefo.com/feefo/viewvendor.jsp?logon=<%=((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).feefoLogin%>" onclick="window.open(this.href,'Feefo','width=800,height=600,scrollbars,resizable');return false;">
			<img src="<%=pfxProtocol%>://www.feefo.com/feefo/feefologo.jsp?logon=<%=((co.simplypos.model.website.tracking.Feefo)userSession.getTrackingController().feefo).feefoLogin%>&template=N178x60W.gif" border="0" alt="Feefo logo"title="See what our customers say about us">
		</a>
	</div>
<% } %>

<div id="pagetimestamp">
	<%=website.getWebsiteName()+" - "+new java.util.Date()%>&nbsp;<%
	String servertag=null;
	try {
		servertag=new String(co.simplypos.model.utils.helpers.FileHelper.readSmallFile(new java.io.File("/home/public/server_name.txt"))); 
	} catch (Exception e34hg3) {
		servertag="[]";
	}%>
	<%=servertag%>
</div>