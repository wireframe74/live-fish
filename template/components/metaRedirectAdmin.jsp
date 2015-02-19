<%@include file="header.html"%><body><%@include file="adminheader.jsp"%><div id="adminredirect"><%
	Vector metaRedirects;
	String metaRedirectId;
	String oldURL;
	String newURI;

	metaRedirects =  (Vector) request.getAttribute("metaRedirects");
	metaRedirectId = (String) request.getAttribute("metaRedirectId");
	if (metaRedirectId == null) {
	    metaRedirectId = "";
	}
	oldURL = (String) request.getAttribute("oldURL");
	newURI = (String) request.getAttribute("newURI");
	if (oldURL == null) {
	    oldURL = "";
	}
	if (newURI == null) {
	    newURI = "";
	}
	if (request.getParameter("clearmetacache.x") != null) {
		website.clearMetaCache();
		out.write("<p><center><strong>Meta cache cleared!<strong></center></p>");
	}
	if (request.getParameter("showhelp") != null) {
%>
		<div id="instructions" class="checkoutcontainer" align="left">
			<div class="pagetitle" align="left">
				<img src="template/images/meta_help.png" alt="" style="position:relative; left:3px; top:5px;" />
				<span style="font-size: 14px;">How To Use This Page...</span>
			</div>
			<div style="color:#666666;font-size: 11px;margin-left:50px;">
				<i>
				<p>Use this page to redirect from one page to another. You can redirect from different domains or across the same domain.</p>
				<ul><li>Examples:</li>
				<li><br />
					to redirect from pages that no longer exist that were on the same domain, follow the example:<br />
					<ul><li>oldURL: http://www.mydomain.co.uk/Items/gg-30734-02</li>
					<li>newURI: index.jsp?layout=1&limit=10&searchStr=Pink Stripey Fabric Cupcake Pin Cushion: GG 30734-02</li></ul>

				</li>
				<li><br />
					to redirect from an different domain, first forward that domain to your website domain and follow the example:
					<ul><li>oldURL: http://www.mydomain.co.uk/default.aspx?size=junior&rnd=ce97d78a-11cd-4f4f-ada7-c170d63e0d76</li>
					<li>newURI: index.jsp?layout=1&limit=10&searchStr=cricket equipment, cricket bats</li></ul>

				</li>
				</ul>
				<p><b>Note:</b> to edit an entry, click on the page name in the list to modify it.</p>
				</i>
			</div>
		</div>
<%
	}
%>
<table style="margin-top:10px; margin-left:3px;margin-bottom:15px;" width="100%">
		<thead>
			<tr>
				<td class="smallertext" width="300"><u>Before You Begin - Important Information</u></td><td></td> 
			</tr>
		</thead>
		<tbody>
			<tr>
				<td colspan="2">
					<span style="color:#666;">
						<i>This page is intended for third-party search engine optimisation companies and SEO professionals. Changing settings in this area without fully understanding the purpose could negatively affect your website search engine listings or worst case, cause unexpected downtime for your website. Actions performed within this page fall outside the scope of standard Intelligent Retail helpdesk support service. Any remedial work will therefore incur an hourly charge. If you would like information regarding Intelligent Retail's Search Engine Optimisation service, then please send details of the enquiry to <a href="mailto:expertseo@intelligentretail.co.uk">expertseo@intelligentretail.co.uk</a></i>
					</span>
				</td>
			</tr>
		</tbody>
</table>
<div class="checkoutcontainer" align="left">
	<div class="pagetitle" align="left">
		<img src="template/images/meta_editor.png" alt="" style="position:relative; left:3px; top:5px;"  />
		<span style="font-size: 14px;">Add/Edit a Page Redirect</span>
	</div>
	<form  name="metaRedirectAdmin" method="post" action="metaRedirectAdmin.jsp">
		<input type="hidden" name="action" value="save" />
		<input type="hidden" name="metaRedirectId" value="<%=metaRedirectId%>" />
		<table>
			<tr valign="top">
				<td>&nbsp;</td>
				<td>&nbsp;</td>	
			</tr>
			
			<tr valign="top">
				<td align="right">Old URL:</td>
				<td><textarea cols="100" rows="3" name="oldURL"><%=(oldURL!=null?oldURL:"")%></textarea></td>
			</tr>

			<tr valign="top">
				<td align="right">New URI:</td>
				<td><textarea cols="100" rows="3" name="newURI"><%=(newURI!=null?newURI:"")%></textarea></td>
			</tr>

			<tr>
				<td align="right">&nbsp;</td>
				<td align="right">
			 		<input type="image" alt="Save Meta" value="" src="template/images/meta_save.gif" />					
				</td>
			</tr>
		</table>
	</form>
</div>
<div style="position:relative; top:-15px;">
<%
if (metaRedirects != null && metaRedirects.size() > 0) { %>
   	<div class="checkoutcontainer" align="left">
		<div class="pagetitle" align="left">
			<img src="template/images/meta_tag.png" alt=""  style="position:relative; left:3px; top:5px;" />
			<span style="font-size: 14px;">Page Redirect</span>
		</div>
   		
		<table style="margin-top:0px; margin-left:50px;margin-bottom:15px;">
		<thead>
			<tr>
				<td class="smallertext" width="5%"><u>Delete</u></td>
				<td class="smallertext"><u>Old URL</u></td>
				<td class="smallertext"><u>New URI</u></td>
			</tr>
		</thead>
		<tbody>
<%
		for (int i=0;i<metaRedirects.size();i++) {
			Hashtable data = (Hashtable) metaRedirects.get(i);
			String currId;
			String currOldURL;
			String currNewURI;
			
			currId = (String) data.get("meta_redirect_id");
			currOldURL = (String) data.get("oldURL");
			currNewURI = (String) data.get("newURI");
		
			if (currOldURL == null) {
				currOldURL = "";
			}
			if (currNewURI == null) {
				currNewURI = "";
			}
%>
			<tr>
				<td align="center"><a href="?action=delete&metaRedirectId=<%=currId%>"><img src="<%=website.getImagePath("delete.gif")%>" alt="delete" class="noBorder" /></a></td>
				<td><a href="?action=edit&metaRedirectId=<%=currId%>"><%=currOldURL%></a></td><td><%=currNewURI%></td>
			</tr>			
<%		}
%>
		</tbody>
		</table>
	</div>
<% 
}
%>
</div>
</div>
</div>
</div>
</body></html>
