<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%@page import="co.simplypos.persistence.Customer" %>
<div id="accountbuttons">
	<ul>
		<li id="myaccountbutton" class="accountbutton">
			<a href="myaccount.jsp?pg=1">
				<%=website.getText("myaccountaccountdetails","My Account Details")%>
			</a>
		</li>
		</li>	
		<li id="mydeliveryaddress" class="accountbutton">
			<a href="myaccount.jsp?pg=2">
					<%=website.getText("myaccountdeliveryAddresses","My Delivery Addresses")%>	
			</a>
		</li>
	<% if (website.isShowGiftLists()) { %>
		<li id="mygiftlist" class="accountbutton">
			<a href="<%=website.getGiftListPageURL()%>?oemail=<%=userSession.getLoggedInCustomerEmailAddress()%>&oid=<%=userSession.getLoggedInCustomerId()%>">
				<%=website.getText("myaccountgiftlists","My Gift Lists")%>	
			</a>
		</li>
	<% } %>
	<% if (website.isShowPersonalShopper() && userSession.getCustomerTypeDomainId() == Customer.CUSTOMER_TYPE_COMMERCIAL /* 6/12/2009 NRM - only allow consultancy customers to get the the shopping lists */) { %>	
		<li id="myshoppinglist" class="accountbutton">
			<a href="<%=website.getPersonalShopperPageURL()%>">
				<%=website.getText("myaccountshoppinglist","My Personal Shopping Lists")%>	
			</a>
		</li>
	<% } %>
		<li id="mypurchases" class="accountbutton">
			<a href="myaccount.jsp?pg=3">
				<%=website.getText("myaccountmypurchases","My Purchases")%>	
			</a>
		</li>
		<li id="myaccountshop" class="accountbutton">
			<a href="index.jsp">
				<%=website.getText("myaccountshop","Shop!")%>
			</a>
		</li>
		<li id="myaccountlogout" class="accountbutton">
			<a href="myaccount.jsp?action=logout">
				<%=website.getText("myaccountlogout","logout")%>
			</a>
		</li>
	</ul>
</div>