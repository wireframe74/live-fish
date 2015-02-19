<%@include file="header.html"%><body><%@include file="adminheader.jsp"%><%
	Vector metaTags;
	String metaTagId;
	String pageURL;
	String title;
	String titleStatus;
	String key;
	String keyStatus;
	String desc;
	String descStatus;
	String breadcrumb;

	metaTags =  (Vector) request.getAttribute("metaTags");
	metaTagId = (String) request.getAttribute("metaTagId");
	if (metaTagId == null) {
	    metaTagId = "";
	}
	
	pageURL = (String) request.getAttribute("pageURL");

	title = (String) request.getAttribute("title");
	titleStatus = (String) request.getAttribute("titleStatus");
	
	key = (String) request.getAttribute("key");	
	keyStatus = (String) request.getAttribute("keyStatus");
	
	desc = (String) request.getAttribute("desc");
	descStatus = (String) request.getAttribute("descStatus");
	
	breadcrumb = (String)request.getAttribute("breadcrumb");

	if (pageURL == null) {
	    pageURL = "";
	}

	if (title == null) {
	    title = "";
	}
	
	if (titleStatus == null) {
	    titleStatus = "1";
	}
	
	if (key == null) {
	    key = "";
	}
	
	if (keyStatus == null) {
	    keyStatus = "1";
	}
	
	if (desc == null) {
	    desc = "";
	}
	
	if (descStatus == null) {
	    descStatus = "1";
	}

	if (breadcrumb == null) {
	    breadcrumb = "";
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
				<p>Use this page to define Meta Title, Key and Description values for each page within this website.</p>
				<p><b>To specify which pages to set the meta policy for</b>, simply enter the relative URL of the page you wish to modify into the 'Page' field. Alternatively, common phrases have been setup for convenience, for example the home page can be specified using the phrase <b>[home]</b> as the page name.
				The domain name should not be entered for example enter 'index.jsp' not 'http://www.mydomain.com/index.jsp'. 
				Additional parameters can be entered if needed, for example 'detail.jsp?parameter=value'. 
				</p>
				<p><b>To setup a Global Meta Policy,</b> page filters can be specified as the page name, for example: <b>[pine] [chair] [.ir] -[.irc]</b> would include pages with the word "pine" and "chair" and extension ".ir" though exclude pages with the extension ".irc". Global policy filters are matched to the page name using a scoring system similar to a google search. This means a global policy can be defined for the entire website by using the phrase <b>[]</b>. This will match all pages though with a weak scoring. This can then be overridden for specific campaign pages using more closely matching phrases. 
				</p>
				<p><b>When specifying meta information</b> tokens can be used, which will be replaced with page data when the page is loaded. For example, a pattern for a product page could be presented as <ul><li>'Visit <b>{!WN}</b> for great prices on <b>{!PB}</b> - <b>{!PN}</b> with free giftwrapping on all orders over &pound;20.</li></ul>
				<ul><li>Valid tokens are:</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!WN}</b> = Website Name</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!PN}</b> = Page Name</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!AN}</b> = Article Name</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!AB}</b> = Article Brand</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!AD}</b> = Article Full Description</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!AP}</b> = Article Price</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!CN}</b> = Category Name</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!PC}</b> = Parent Category</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!GC}</b> = Grand Parent Category</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!CS}</b> = Category Structure</li>
					<li><b>&nbsp;&nbsp;&nbsp;{!AC}</b> = All Categories (Category Structure and Sub Categories)</li>
					<li></li>
					<li><b>Delimiters</b> = Using {!AB - }{!AN} would show "Disney - Mickey Mouse". The "-" within the "{!AB}" token means if no AB data is present then the delimiter will not be included showing only "Mickey Mouse".</li>
					</ul>
				</p>
				<!--
				<p><b>Prefix</b> will insert the text entered before the system generated meta key/description
				<br /><b>Suffix</b> will append the text entered onto the end of the system generated meta key/description
				<br /><b>Override</b> will override the system generated meta key/description with the text entered
				<br /><b>Disable</b> will disable the modification so only the system generated value is used
				-->
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
						<i>This page is intended for third-party search engine optimisation companies and SEO professionals. Changing settings in this area without fully understanding the purpose could negatively affect your website search engine listings or worst case, cause unexpected downtime for your website. Actions performed within this page fall outside the scope of standard Intelligent Retail support service. Any remedial work will therefore incur an hourly charge. If you would like information regarding Intelligent Retail's Search Engine Optimisation service, then please send details of the enquiry to <a href="mailto:expertseo@intelligentretail.co.uk">expertseo@intelligentretail.co.uk</a></i>
					</span>
				</td>
			</tr>
		</tbody>
</table>
<div class="checkoutcontainer" align="left">
	<div class="pagetitle" align="left">
		<img src="template/images/meta_editor.png" alt="" style="position:relative; left:3px; top:5px;"  />
		<span style="font-size: 14px;">Add/Edit Meta Policy</span>
	</div>
	<form  name="metaTagAdmin" method="post" action="metakeyAdmin.jsp">
		<input type="hidden" name="action" value="save" />
		<input type="hidden" name="metaTagId" value="<%=metaTagId %>" />
		<table style="margin-left:20px;">
			<tr valign="top">
				<td>&nbsp;</td>
				<td>&nbsp;</td>	
<!--	
				<td><u>Prefix</u></td>
				<td><u>Suffix</u></td>
				<td><u>Override</u></td>
				<td><u>Disable</u></td>
				<td>&nbsp;</td>
-->
			</tr>
			
			<tr valign="top">
				<td align="right">Page:</td>
				<td><input type="text" name="pageURL" size="100" maxlength="500" value="<%=pageURL %>" /></td>
<!--				<td colspan="5">&nbsp;</td> -->
			</tr>

			<tr valign="top">
				<td align="right">Meta Title:</td>
				<td><textarea cols="100" rows="3" name="title"><%=(title!=null?title:"")%></textarea></td>
<!--				<td align="center" valign="top"><br /><input type="radio" name="titleStatus" value="3" <% if ("3".equals(titleStatus))  { %> checked="checked" <% } %>/></td>
				<td align="center" valign="top"><br /><input type="radio" name="titleStatus" value="1" <% if ("1".equals(titleStatus))  { %> checked="checked" <% } %>/></td>
				<td align="center" valign="top"><br /><input type="radio" name="titleStatus" value="2" <% if ("2".equals(titleStatus))  { %> checked="checked" <% } %>/></td>
				<td align="center" valign="top"><br /><input type="radio" name="titleStatus" value="0" <% if ("0".equals(titleStatus))  { %> checked="checked" <% } %>/></td>
				<td>&nbsp;</td>   -->
			</tr>

			<tr valign="top">
				<td align="right">Meta Key:</td>
				<td><textarea cols="100" rows="3" name="key"><%=key %></textarea></td>
<!--				<td align="center" valign="top"><br /><input type="radio" name="keyStatus" value="3" <% if ("3".equals(keyStatus))  { %> checked="checked" <% } %>/></td>
				<td align="center" valign="top"><br /><input type="radio" name="keyStatus" value="1" <% if ("1".equals(keyStatus))  { %> checked="checked" <% } %>/></td>
				<td align="center" valign="top"><br /><input type="radio" name="keyStatus" value="2" <% if ("2".equals(keyStatus))  { %> checked="checked" <% } %>/></td>
				<td align="center" valign="top"><br /><input type="radio" name="keyStatus" value="0" <% if ("0".equals(keyStatus))  { %> checked="checked" <% } %>/></td>
				<td>&nbsp;</td>   -->
			</tr>
			
			<tr valign="top">
				<td align="right">Meta Description:</td>
				<td><textarea cols="100" rows="4" name="desc"><%=desc %></textarea></td>
<!--				<td align="center" valign="top"><br /><input type="radio" name="descStatus" value="3" <% if ("3".equals(descStatus))  { %> checked="checked" <% } %>/></td>
				<td align="center" valign="top"><br /><input type="radio" name="descStatus" value="1" <% if ("1".equals(descStatus))  { %> checked="checked" <% } %>/></td>
				<td align="center" valign="top"><br /><input type="radio" name="descStatus" value="2" <% if ("2".equals(descStatus))  { %> checked="checked" <% } %>/></td>
				<td align="center" valign="top"><br /><input type="radio" name="descStatus" value="0" <% if ("0".equals(descStatus))  { %> checked="checked" <% } %>/></td>
				<td>&nbsp;</td>   -->
			</tr>
			<input type="hidden" name="titleStatus" value="2"/>
			<input type="hidden" name="keyStatus" value="2"/>
			<input type="hidden" name="descStatus" value="2"/>
			<tr>
				<td align="right">&nbsp;</td>
				<td></td>
				<td></td>
			</tr>

			<tr valign="top">
				<td align="right">Breadcrumb:</td>
				<td><textarea cols="100" rows="2" name="breadcrumb"><%=breadcrumb %></textarea></td>
				<td align="right" valign="bottom" colspan="5"><img src="images/spacer.gif" width="40"/></td>
			</tr>

			<tr>
				<td align="right">&nbsp;</td>
				<td align="right">
			 			    <input type="image" alt="Save Meta" value="" src="template/images/meta_save.gif" />
							<input type="image" alt="Clear Meta Cache" name="clearmetacache" value="1" src="template/images/meta_clear.gif" /></td>

			</tr>
		</table>
	</form>
</div>
<div style="position:relative; top:-15px;">
<%
if (metaTags != null && metaTags.size() > 0) { 
    String alias = website.getPersistenceManager().getMetaTag().getAlias();

    boolean showAll = false;
    for (int type=0;type<=1;type++) { %>

	<div class="checkoutcontainer" align="left">
		<div class="pagetitle" align="left">
			<img src="template/images/<%=(type==0?"meta_global.png":"meta_tag.png")%>" alt=""  style="position:relative; left:3px; top:5px;" />
			<span style="font-size: 14px;"><%=(type==0?"Global Meta Policy":"Page Meta Policy (Overrides the Global Meta Policy)")%></span>
		</div>
   		
		<table style="margin-top:0px; margin-left:50px;margin-bottom:15px;">
		<thead>
			<tr>
				<td class="smallertext" width="5%"><u>Delete</u></td>
				<td class="smallertext" width="7%"><u>Action</u></td>
				<td class="smallertext"><u>Page</u></td>
				<% if (showAll) { %>
					<td class="smallertext"><u>Meta Title</u></td>
					<td class="smallertext" width="7%"><u>Action</u></td>
					<td class="smallertext"><u>Meta Key</u></td>
					<td class="smallertext" width="7%"><u>Action</u></td>
					<td class="smallertext"><u>Meta Description</u></td>
				<% } %>
			</tr>
		</thead>
		<tbody>
<%
		for (int i=0;i<metaTags.size();i++) {
			Hashtable data = (Hashtable) metaTags.get(i);
			Integer currId;
			String currPage;
			String currTitle;
			Integer currTitleStatus;
			String currTitleStatusString;
			String currKey;
			Integer currKeyStatus;
			String currKeyStatusString;
			String currDesc;
			Integer currDescStatus;
			String currDescStatusString;
			
			currId = (Integer) data.get(alias + "." + MetaTag.META_TAG_ID);
			currPage = (String) data.get(alias + "." + MetaTag.PAGE);
			currTitle = (String) data.get(alias + "." + MetaTag.TITLE);
			currTitleStatus = (Integer) data.get(alias + "." + MetaTag.TITLE_STATUS);
			currKey = (String) data.get(alias + "." + MetaTag.KEY);
			currKeyStatus = (Integer) data.get(alias + "." + MetaTag.KEY_STATUS);
			currDesc = (String) data.get(alias + "." + MetaTag.DESCRIPTION);
			currDescStatus = (Integer) data.get(alias + "." + MetaTag.DESC_STATUS);
			
			boolean include = false;
			if (type == 0 && currPage != null && currPage.trim().startsWith("[")) {
				include = true;
			}
			if (type == 1 && (currPage == null || !currPage.trim().startsWith("["))) {
				include = true;
			}
			if (include) {
				switch (currTitleStatus.intValue()) {
					case MetaTag.STATUS_DISABLED:
						currTitleStatusString = "Disabled";
						break;
					case MetaTag.STATUS_OVERRIDE:
						currTitleStatusString = "Override";
						break;
					case MetaTag.STATUS_APPEND:
						currTitleStatusString = "Append";
						break;
					default:
						currTitleStatusString = "Unknown";
				}
		
				switch (currKeyStatus.intValue()) {
					case MetaTag.STATUS_DISABLED:
						currKeyStatusString = "Disabled";
						break;
					case MetaTag.STATUS_OVERRIDE:
						currKeyStatusString = "Override";
						break;
					case MetaTag.STATUS_APPEND:
						currKeyStatusString = "Append";
						break;
					default:
						currKeyStatusString = "Unknown";
				}
				
				switch (currDescStatus.intValue()) {
					case MetaTag.STATUS_DISABLED:
						currDescStatusString = "Disabled";
						break;
					case MetaTag.STATUS_OVERRIDE:
						currDescStatusString = "Override";
						break;
					case MetaTag.STATUS_APPEND:
						currDescStatusString = "Append";
						break;
					default:
						currDescStatusString = "Unknown";
				}
				if (currTitle == null) {
					currTitle = "";
					currTitleStatusString = "";
				}
				if (currKey == null) {
					currKey = "";
					currKeyStatusString = "";
				}
				if (currDesc == null) {
					currDesc = "";
					currDescStatusString = "";
				}

%>
				<tr>
					<td align="center"><a href="metakeyAdmin.jsp?action=delete&metaTagId=<%=currId%>"><img src="<%=website.getImagePath("delete.gif")%>" alt="delete" class="noBorder" /></a></td>
					<td><%=currDescStatusString%></td>
					<td><a href="metakeyAdmin.jsp?action=edit&metaTagId=<%=currId%>"><%=currPage %></a></td>
					<% if (showAll) { %>
						<td><%=currTitle %></td>
						<td><%=currTitleStatusString %></td>
						<td><%=currKey %></td>
						<td><%=currKeyStatusString %></td>
						<td><%=currDesc%></td>
					<% } %>
				</tr>			
<%			}
		}
%>
		</tbody>
		</table>
	</div>
<% 
   }
}
%>
</div>
</div>
</div>
</body></html>