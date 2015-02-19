<!-- start of components/giftList.jsp -->
<%@page import="java.sql.Connection"%>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%@page import="co.simplypos.persistence.ListClassHdr" %>
<%@page import="co.simplypos.persistence.ListClassClsfn" %>
<%@page import="co.simplypos.persistence.ListClass"%>
<%@page import="java.util.Vector" %>
<%@page import="java.util.Hashtable" %>
<%
	
	String listName;
	String listCode;
	String giftListId;
	String message;
	Connection conn = null;
	Vector listHdrs = null;
	StringBuilder where = new StringBuilder();
	where.append("where ").append(ListClassHdr.OBJECT_ID).append(" = ").append(userSession.getLoggedInCustomerId());
    where.append(" and ").append(ListClassHdr.LIST_CLASS_TYPE_DOMAIN_ID).append(" = ").append(ListClassClsfn.LIST_TYPE_GIFT_LIST_DOMAIN_ID);
    where.append(" and ").append(ListClassHdr.LIST_CLASS_CLSFN_DOMAIN_ID).append(" = ").append(ListClassClsfn.LIST_CLSFN_ARTICLE_DOMAIN_ID);
    where.append(" and ").append(ListClassHdr.LIST_CLASS_SUB_CLSFN_DOMAIN_ID).append(" = ").append(ListClassClsfn.LIST_CLSFN_CUSTOMER_DOMAIN_ID);
    where.append(" and ").append(ListClassHdr.LIST_CLASS_HDR_STATUS_DOM_ID).append(" = ").append(ListClassHdr.LIST_STATUS_ACTIVE_DOMAIN_ID);
    try {
    	conn = website.getConnection();
    	 listHdrs = website.getPersistenceManager().getListHdrClass().getRows(conn, where.toString());
    } catch (Exception e) {
        website.writeToLog(e);
    } finally {
        if (conn != null) {
            website.releaseConnection(conn);
        }
    }
	
	listName = (String) request.getAttribute("listname");
	if (listName == null) {
	    listName = "";
	}
	
	listCode = (String) request.getAttribute("listcode");
	if (listCode == null) {
		listCode = "";
	}
    String prefix = "C" + userSession.getLoggedInCustomerId() + "_";
    if (listCode.indexOf(prefix) >-1 )  {
        listCode = listCode.substring(prefix.length());
    }
	
	giftListId = (String) request.getAttribute("giftListId");
	if (giftListId == null) {
	    giftListId = "";
	}
	
	message = (String) request.getAttribute("message");
	if (message == null) {
	    message = "";
	}

%>
<div id="giftlist">
<jsp:include page="accountButtons.jsp" />
<br />
<div class="checkoutcontainer" align="left">
<h1 id="mainTitle" class="pagetitle left">&nbsp;<img src="<%=website.getImagePath("containerheader.gif") %>" alt="" class="containerHeader" />My Gift Lists<img src="<%=website.getImagePath("giftlist.png") %>" alt="Gift Lists" align="right" id="mainImg" /></h1>
<% 
	if (!message.equals("")) { %>	
	<div class="discount left">&nbsp;<img src="<%=website.getImagePath("icon_error.gif") %>" alt="Warning" /> <%=message %> </div>
<% 
	}

	if (listHdrs != null && listHdrs.size() > 0) {
%>

	
	<br />
	
	<table width="100%">
		<thead>
			<tr>
				<td>&nbsp;</td>
				<td class="smallertext" align="center">&nbsp;</td>
				<td class="smallertext">List Name</td>
				<td class="smallertext">List Code</td>
				<td class="smallertext">Desired</td>
				<td class="smallertext">Received</td>
				<td class="smallertext">&nbsp;</td>
								
			</tr>
		</thead>
		
		<tbody>
<% 
	try {
		conn = website.getConnection();
		for (int i = 0; i < listHdrs.size(); i++) {
			Hashtable list = (Hashtable) listHdrs.get(i);
			ListClassClsfn listClassClsfn = website.getPersistenceManager().getListClassClsfn();
			String listHdrAlias = website.getPersistenceManager().getListHdrClass().getAlias() + ".";
			String currListName = "";
			String currListCode = "";
			int numInList = 0;
			int remaining = 0;
			int currId = 0;
			int currListId = 0;
			Vector listClassRow = null;
			
			currListCode = (String) list.get(listHdrAlias + ListClassHdr.DESCRIPTION);
			currId = ((Integer) list.get(listHdrAlias + ListClassHdr.LIST_CLASS_HDR_ID)).intValue();
			where.setLength(0);
			where.append("where ").append(ListClass.LIST_CLASS_HDR_ID).append(" = ").append(currId);
			
			try {
				listClassRow = website.getPersistenceManager().getListClass().getRows(conn, where.toString());
			} catch (Exception e) {
			    website.writeToLog(e);
			}
			if (listClassRow != null && listClassRow.size() > 0) {
			    String listClassAlias = website.getPersistenceManager().getListClass().getAlias() + ".";
			    Hashtable listClass = (Hashtable) listClassRow.get(0);
			    currListName = (String) listClass.get(listClassAlias + ListClass.DESCRIPTION);
			    currListId = ((Integer) listClass.get(listClassAlias + ListClass.LIST_CLASS_ID)).intValue();
			    
			}
			
			if (currListId > 0) {
			    try {
					conn = website.getConnection();
					numInList = listClassClsfn.getNumItemsInList(conn, currListId);
					remaining = listClassClsfn.getNumRemaining(conn, currListId);
			    } catch (Exception e) {
			        website.writeToLog(e);
			    }
			}
%>
			<tr>
				<td><img src="<%=website.getImagePath("giftlist.png") %>" class="height25" alt="Gift List" /></td>
				<td align="center"><!-- 4/5/2010 NRM: remove delete option: <a href="giftList.jsp?action=delete&giftListId=<=currId>"><img src="<=website.getImagePath("delete.gif")>" alt="Remove" class="noBorder" /></a> --> </td>
				<td>
					<a href="giftList.jsp?action=edit&giftListId=<%=currId %>" title="Edit"><%=currListName%></a>
				</td>
				<td><a href="giftList.jsp?action=activate&giftListId=<%=currId %>" title="Activate"><%=currListCode%></a></td>
				<td>
					<%=numInList%>
				</td>
				<td><%=numInList-remaining %></td>
				<td><a href="viewList.jsp?listcode=<%=currListCode %>" class="glButton">View List&nbsp;<img src="<%=website.getImagePath("btnright.gif") %>" class="noBorder" /></a></td>
				
				
			</tr>
<%
		}
	} catch (Exception e232a) {
	    website.writeToLog(e232a);
	} finally {
	    if (conn != null) {
	        website.releaseConnection(conn);
	    }
	}
%>	
		</tbody>		
	</table>


<%

	}

%>

<br />

	<div class="pagetitle" align="left">
		&nbsp;<img src="<%=website.getImagePath("containerheader.gif")%>" alt="" class="containerHeader" />
		<span style="font-size: 14px;">Add/Rename Gift List</span>
	</div>
	<form name="addGiftList" action="giftList.jsp" method="post">
		<input type="hidden" name="action" value="save" />
		<input type="hidden" name="giftListId" value="<%=giftListId %>" />  
		<table>
			<tr>
				<td><label for="listname">List Name:</label>
				</td>
				<td>&nbsp;</td>
				<td>
					<input name="listname" type="text" value="<%=listName %>" />
				</td>
				<td>Enter a name for the list
				</td>
			</tr>
			<tr>
				<td><label for="listcode">List Code:</label>
				</td>
				<td>
					<%=prefix %>
				</td>
				<td><input name="listcode" type="text" value="<%=listCode %>" />
				</td>
				<td>Enter a code for the list to give to your friends
				</td>
			</tr>
			<tr>
				<td colspan="3" align="right">
					<input type="submit" value="Save List" />
				</td>
			</tr>
		</table>
	</form>


<% if ((!"".equals(userSession.getGiftListCode())) && userSession.getGiftListOwner() == userSession.getLoggedInCustomerId()) { %>
	<br />
	<div class="pagetitle" align="left">
		&nbsp;<img src="<%=website.getImagePath("containerheader.gif")%>" alt="" class="containerHeader" />
		<span style="font-size: 14px;">Active Gift List</span>
	</div>
	<div><%=userSession.getGiftListName() %></div>

<% } %>
</div>
</div>
<!-- end of components/giftList.jsp -->