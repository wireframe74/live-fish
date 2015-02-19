	<div id="adminbody">
	<div id="admincontainer">
	<img src="<%=website.getWebSiteBaseURL()%>/template/images/meta_logo.gif" style="position:relative; left:0px; top:1px; float:left;" />
	<div class="pagetitle" align="left" style="float:left; margin-left:40px;">
	</div>
	<div id="admintitle">
		<span>Website Management Area</span><br />
		<div id="adminhelp">
<%
		if (request.getParameter("showhelp") != null) { %>
			<span style="font-size: 14px; float:right;"><a href="?"><img src="<%=website.getWebSiteBaseURL()%>/template/images/meta_help.png" border="0" style="position:relative; left:0px; top:5px;" /><u>HELP! Click here to hide instructions</u></a></span>
		<% } else {%>
			<span style="font-size: 14px; float:right;"><a href="?showhelp=1"><img src="<%=website.getWebSiteBaseURL()%>/template/images/meta_help.png" border="0" style="position:relative; left:0px; top:5px;"><u>HELP! Click here to show instructions</u></a></span>
		<% } 
%>
		</div>
	</div>
	<div id="admintabheader" class="tabheader">
				<ul>
					<li><div id="<%=request.getRequestURI().indexOf("editorAdmin.jsp")>-1?"tabcurrent":""%>" class="tab"><a href="<%=website.getWebSiteBaseURL()%>/editor/editorAdmin.jsp"><span>Page Editing</span></a></div></li>
					<li><div id="<%=request.getRequestURI().indexOf("uploadAdmin.jsp")>-1?"tabcurrent":""%>" class="tab"><a href="<%=website.getWebSiteBaseURL()%>/editor/uploadAdmin.jsp"><span>File Uploading</span></a></div></li>
					<li><div id="<%=request.getRequestURI().indexOf("metakeyAdmin.jsp")>-1?"tabcurrent":""%>" class="tab"><a href="<%=website.getWebSiteBaseURL()%>/metakeyAdmin.jsp"><span>Page Meta Policies</span></a></div></li>
					<li><div id="<%=request.getRequestURI().indexOf("metaRedirectAdmin.jsp")>-1?"tabcurrent":""%>" class="tab"><a href="<%=website.getWebSiteBaseURL()%>/metaRedirectAdmin.jsp"><span>Page Redirects</span></a></div></li>
				</ul>
	</div>
	<div id="admintabbody" class="tabbody">