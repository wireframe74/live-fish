<!-- start of components/tracking.jsp -->
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%@page import="java.text.SimpleDateFormat" %>
<%@page import="java.util.Vector" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.sql.Connection" %>
<%@page import="co.simplypos.persistence.Address" %>
<%@page import="co.simplypos.persistence.AddressClsfn" %>
<%@page import="co.simplypos.persistence.Transaction" %>
<%@page import="co.simplypos.persistence.OrderTracking" %>
<%@page import="co.simplypos.model.utils.helpers.StringHelper" %>
<%@page import="co.simplypos.model.website.UserSession" %>
<%@page import="co.simplypos.model.website.WebSite" %>
<%@page import="co.simplypos.model.website.ShoppingBasket" %>

<% 
try {
    if (website == null || website.getArticleMenu() == null || userSession == null || userSession.getArticleDetail() == null) {
	    return;
	}
	int paramOrderRef = 0;
	int paramTransId = 0;
	float paramOrderAmount = 0;
	String paramSource = "";

	if (request.getParameter("oid") != null) {
		paramOrderRef = Integer.parseInt(request.getParameter("oid"));
	}
	if (request.getParameter("oamnt") != null) {
		paramOrderAmount = Float.parseFloat(request.getParameter("oamnt"));
	}
	if (request.getParameter("id") != null) {
		paramTransId = Integer.parseInt(request.getParameter("id"));
	}
	if (request.getParameter("src") != null) {
		paramSource = request.getParameter("src");
	}

	String href = "";
	if (paramSource.equals("myacc")) {
	    href = "myaccount.jsp?pg=3";
	} else if (paramSource.equals("template")) {
	    href = "templateOrders.jsp";
	} else {
	 	href = userSession.getLastIndexURL();
	}

	String trailHTML = "";
	String shortDesc = "Track Order";
	userSession.resetTrail();

	boolean accepted = userSession.addTrail(shortDesc, UserSession.getFullURL(request));
	if (!accepted) {
		trailHTML = "[page has expired please close your brower, re-open and start again]";
	} else {
		for (int i=0;i<userSession.getTrailList().size();i++) {
			if (!trailHTML.equals("")) {
				trailHTML += "";
			}
			String trailItem = (String)userSession.getTrailList().get(i);
			String trailItemURL = userSession.getTrailPageURL(trailItem);
			trailHTML += "<a href='"+trailItemURL+"' class='trail'>"+trailItem+"</a>";
		}
	}
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");
	int transId = 0;
	Vector transList = null;
	Connection conn = website.getConnection();
	try {
		if (paramOrderRef > 0) {
			transList = website.getPersistenceManager().getTransaction().getRows(conn, " where "+Transaction.WORLDPAY_TRANS_ID +" = "+paramOrderRef+" and "+Transaction.TRANSACTION_ID+" = "+paramTransId);
		} else {
			transList = website.getPersistenceManager().getTransaction().getRows(conn, " where "+Transaction.TOTAL +" >= "+(paramOrderAmount-0.01)+" and "+Transaction.TOTAL +" <= "+(paramOrderAmount+0.01)+" and "+Transaction.TRANSACTION_ID+" = "+paramTransId);
		}
%>
<div class="pagetopnav">
	<ul class="crumb blocklist">
		<li><%=trailHTML%></li>
	</ul>
	<ul class="navPage blocklistright">
		<li class="buttonbacktoshop">
			<a href="<%=href%>"> <%=website.getText("trackingbacktoshopbutton","Back to shop")%> </a>
		</li>
	</ul>
</div>
<%
		if (transList.size() >= 1) {
			Object transIdObj = ((Hashtable)transList.get(0)).get(website.getPersistenceManager().getTransaction().getAlias()+"."+Transaction.TRANSACTION_ID);
			if (transIdObj != null) transId = Integer.parseInt(""+transIdObj);
			if (paramOrderRef == 0) {
				Object orderRef = ((Hashtable)transList.get(0)).get(website.getPersistenceManager().getTransaction().getAlias()+"."+Transaction.WORLDPAY_TRANS_ID);		 	   
				if (orderRef != null) paramOrderRef = Integer.parseInt(""+orderRef);
			}
			String orderRef = "P"+paramOrderRef;
			UserSession tempSession = new UserSession();
			tempSession.initialise(website);
			ShoppingBasket tempBasket = new ShoppingBasket(tempSession);    
			tempBasket.openTransaction(conn, transId);
			String HTMLReceipt = tempBasket.buildHTMLReceipt(conn, transId, "smallertext", "formheader", true, true);
			if (userSession.getCurrencyId() != 1) HTMLReceipt = StringHelper.replace(HTMLReceipt,'?',userSession.getCurrencySymbol());
			Vector trackingRows = website.getPersistenceManager().getOrderTracking().getRows(conn, " where "+OrderTracking.TRANSACTION_ID + "=" + transId+" order by "+OrderTracking.ORDER_TRACKING_TYPE_DOMAIN_ID+" asc");
			int subType = tempBasket.getTransactionSubType();

			
%>
<%if (subType == Transaction.SUB_TYPE_TRANSACTION_PERSONAL_SHOPPING_TEMPLATE || subType == Transaction.SUB_TYPE_TRANSACTION_PERSONAL_SHOPPING) {%>
<div class="pagetitle"><h1><%=website.getText("trackingheaderonepsl","Personal Shopping List Details")%></h1></div>
<%}else{%>
<div class="pagetitle"><h1><%=website.getText("trackingheaderone","Order Tracking")%></h1></div>
<%}%>
<div class="trackingordersummary">
	<div class="pagesubtitle"><h2><%=website.getText("trackingheadertwo","Order Summary")%></h2></div>
	<ul id="trackingordersummarylist">
		<li class="trackingordersummaryref"><%=website.getText("trackingsummaryorderreflabel","Order Reference:")%><%=orderRef%></li>
	</ul>
	<div id="ordersummarytable" class="listtable">
		<%=HTMLReceipt%>
	</div>
</div>
<%
			if (website.getWebsiteMode() == WebSite.MODE_TRADE) {
%>

							All prices are exclusive of VAT.
<%
			}

			String billingAddressString = "";
			String deliveryAddressString = "";                    
			try {
				String aliasPrefix1 = website.getPersistenceManager().getAddress().getAlias() + ".";
                    		Vector addresses = website.getPersistenceManager().getAddress().getAddresses(transId, AddressClsfn.ADDRESS_TYPE_BILLING, AddressClsfn.ADDRESS_CLSFN_TRANSACTION_ADDRESS);
                    		if (addresses.size() >= 1) {
                        		Hashtable address = (Hashtable) addresses.get(0);
                        		billingAddressString = Address.multiLineAddress((String) address.get(aliasPrefix1 + Address.CONTACT), (String) address.get(aliasPrefix1 + Address.ADDRESS_LINE1), (String) address.get(aliasPrefix1 + Address.ADDRESS_LINE2), (String) address.get(aliasPrefix1 + Address.ADDRESS_LINE3), (String) address.get(aliasPrefix1 + Address.COUNTY), (String) address.get(aliasPrefix1 + Address.COUNTRY), (String) address.get(aliasPrefix1 + Address.POST_CODE), (String) address.get(aliasPrefix1 + Address.TELEPHONE), (String) address.get(aliasPrefix1 + Address.EMAIL_ADDRESS), "" + address.get(aliasPrefix1 + Address.SPECIAL_INSTRUCTIONS));
                    		}
			} catch (Exception e238) {
				website.writeToLog(e238.getMessage());
			}
			try {
				String aliasPrefix1 = website.getPersistenceManager().getAddress().getAlias() + ".";                    
				Vector addresses = website.getPersistenceManager().getAddress().getAddresses(transId, AddressClsfn.ADDRESS_TYPE_DELIVERY, AddressClsfn.ADDRESS_CLSFN_TRANSACTION_ADDRESS);
                    		if (addresses.size() >= 1) {
                        		Hashtable address = (Hashtable) addresses.get(0);
                        		deliveryAddressString = Address.multiLineAddress((String) address.get(aliasPrefix1 + Address.CONTACT), (String) address.get(aliasPrefix1 + Address.ADDRESS_LINE1), (String) address.get(aliasPrefix1 + Address.ADDRESS_LINE2), (String) address.get(aliasPrefix1 + Address.ADDRESS_LINE3), (String) address.get(aliasPrefix1 + Address.COUNTY), (String) address.get(aliasPrefix1 + Address.COUNTRY), (String) address.get(aliasPrefix1 + Address.POST_CODE), (String) address.get(aliasPrefix1 + Address.TELEPHONE), (String) address.get(aliasPrefix1 + Address.EMAIL_ADDRESS), "" + address.get(aliasPrefix1 + Address.SPECIAL_INSTRUCTIONS));
                    		}
			} catch (Exception e238) {
				website.writeToLog(e238.getMessage());
			}

			int orderTrackingTypeId = 0;
			if (subType != Transaction.SUB_TYPE_TRANSACTION_PERSONAL_SHOPPING && subType != Transaction.SUB_TYPE_TRANSACTION_PERSONAL_SHOPPING_TEMPLATE) {
%>
<div id="trackingbillingaddress" class="trackingaddress">
	<div class="pagesubtitle"><h2><%=website.getText("trackingheaderthree","Billing Address")%></h2></div>
	<ul>
		<li><%=billingAddressString%></li>
	</ul>
</div>
<div id="trackingdeliveryaddress" class="trackingaddress">
	<div class="pagesubtitle"><h2><%=website.getText("trackingheaderfour","Delivery Address")%></h2></div>
	<ul>
		<li><%=deliveryAddressString%></li>
	</ul>
</div>
<div id="trackingordertracking">
	<div class="pagesubtitle"><h2><%=website.getText("trackingheaderfive","Status Tracking")%></h2></div>
	
	<div id="orderstatus" class="listtable">
		<ul class="listtableheader">
			<li class="orderstatusdate"> <%=website.getText("trackingorderstatusheaderdate","Date/Time")%></li>
			<li class="orderstatusstatus"><%=website.getText("trackingorderstatusheaderstatus","Order Status")%></li>
		</ul>
													


<%		int lastTrackingId = 0;
		for (int i=0;i<trackingRows.size();i++) {
			Hashtable trackingRow = (Hashtable)trackingRows.get(i);
			String aliasPrefix = website.getPersistenceManager().getOrderTracking().getAlias()+".";	
			java.sql.Timestamp updateOn = (java.sql.Timestamp)trackingRow.get(aliasPrefix+OrderTracking.UPDATED_ON);
			orderTrackingTypeId = ((Integer)trackingRow.get(aliasPrefix+OrderTracking.ORDER_TRACKING_TYPE_DOMAIN_ID)).intValue();
			String orderStatus = website.getPersistenceManager().getDomain().getDescription(orderTrackingTypeId);
			if (orderTrackingTypeId != lastTrackingId) {
			%>
				<ul class="listtableline">
					<li class="orderstatusdate"> <%=sdf.format(updateOn)%></li>
					<li class="orderstatusstatus"> <%=orderStatus%> </li>
				</ul>
			<% } %>
		<% lastTrackingId = orderTrackingTypeId; %>
		<% } %>
	</div>
</div>
						
					
<% } %>
<%} else { %>
<div class="pagetitle"><h1><%=website.getText("trackingheaderone","Order Tracking")%></h1></div>
<div id="trackingnoorder"> <%=website.getText("trackingordernotfound","Order Not Found")%> </div>
<%
		}
	} finally {
		website.releaseConnection(conn); 
	}
%>
<div id="pagebottomnav">
	<ul class="crumb blocklist">
		<li><%=trailHTML%></li>
	</ul>
	<ul class="navPage blocklistright">
		<li class="buttonbacktoshop">
			<a href="<%=href%>"> <%=website.getText("trackingbacktoshopbutton","Back to shop")%> </a>
		</li>
	</ul>
</div>

<% } catch (Exception e) { website.writeToLog(e);}%>