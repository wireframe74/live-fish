<!-- start of components/templateOrders.jsp -->
<%@page import="java.util.Vector"%>
<%@page import="java.util.Hashtable"%>
<%@page import="co.simplypos.persistence.Transaction"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.math.BigDecimal"%>
<%@page import="co.simplypos.model.utils.Pair"%>
<%@page import="co.simplypos.persistence.OrderTracking"%>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />

<jsp:include page="accountButtons.jsp" />

<%
Vector templateList = null;
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
try {
	templateList = userSession.getPersonalShopperTemplate(userSession.getLoggedInCustomerId());
} catch (Exception e) {
	website.writeToLog(e);
}
%>

<div class="checkoutcontainer">
	<table width="100%">
		<tr>
			<td class="pagetitle">
				<img src="<%=website.getImagePath("containerheader.gif")%>" alt="" />
				My Personal Shopping Lists
			</td>
			<td><img src="<%=website.getImagePath("psshopper.png") %>" alt="" align="right" /></td>
		</tr>
	</table>
<% 
if (templateList != null && templateList.size() > 0)  { 
%>	
	<div class="templateList">
<%
	String aliasPrefix = userSession.getWebSite().getPersistenceManager().getTransaction().getAlias() + ".";	    
	for (int i = 0; i < templateList.size(); i++) {
	    Hashtable templateRow = (Hashtable) templateList.get(i);
	    int transactionId =  Integer.parseInt("" + templateRow.get(aliasPrefix + Transaction.TRANSACTION_ID));
	    String transactionDate = sdf.format(templateRow.get(aliasPrefix + Transaction.TRANSACTION_DATE));
        int numItems = Integer.parseInt("" + templateRow.get(aliasPrefix + Transaction.NUM_ITEMS));
        BigDecimal total = new BigDecimal(((Number) templateRow.get(aliasPrefix + Transaction.TOTAL)).doubleValue()).setScale(2, BigDecimal.ROUND_HALF_EVEN);
        String description = "Personal Shopping List with " + numItems + " item" + (numItems == 1 ? "" : "s") + " created for you on " + transactionDate;
        int statusId = 0;
        Pair pair = userSession.getHighestType(transactionId);
        if (pair != null) {
            statusId = ((Integer) pair.get(0)).intValue();
        }
        if (statusId != OrderTracking.TYPE_CANCELLED) {
%>            
			<div class="orderTemplateItem">
            	<img src="<%=website.getImagePath("psshopper.png")%>" alt="" class="height15" align="left" />
            	&nbsp;<a href="viewList.jsp?id=<%=transactionId %>"><%=description %></a>
            </div>
<%            
        }
	}
%>
	</div>
<%} else { %>
		<div class="templateList">No Lists Found</div>
<% } %>
</div>
<!-- end of components/templateOrders.jsp -->