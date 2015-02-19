<%@ page language="java" import="java.io.*,java.util.*,co.simplypos.model.utils.helpers.FileHelper,co.simplypos.model.website.utils.FtpUpload"%>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%
if (!userSession.isLoggedIn() && (request.getParameter("go") == null || !request.getParameter("go").equals("g1ftware"))) {
	String forwardPage = "../myaccount.jsp";
	try {
		//Thread.sleep(2000);
		response.sendRedirect(forwardPage); 
	} catch (Exception e102) {
		out.write("<script type='text/javascript'>document.location.href='"+forwardPage+"';</script>"); 
	}
}
%>
<html>
<head>
<link rel="stylesheet" href="../template/framework.css" type="text/css" />
<% if (userSession.isUsingIE()) { %><link rel="stylesheet" href="../template/framework_ie.css" type="text/css" /><% } %>
<link rel="stylesheet" href="../template/style.css" type="text/css" />
<%if (userSession.isUsingIE()) { %><link rel="stylesheet" href="../template/style_ie.css" type="text/css" /><% } %>
</head>
<body>
<div id="adminstoredineditor">
<%@include file="../template/components/adminheader.jsp"%>
<div id="admineditor">
<%
String message = null;
try { 
	if (request.getParameter("clearcompilecache.x") != null) {
		if (website.getWebSiteCacheFolder() != null && website.getWebSiteCacheFolder().indexOf("_logs/") > -1) {
			website.writeToLog("deleting: "+new File(website.getWebSiteCacheFolder()).getAbsolutePath());
			boolean del = FileHelper.deleteDir(new File(website.getWebSiteCacheFolder()));
			if (del) { 
				message = "Compile cache successfully cleared";
			} else {
				message = "Compile cache delete failed";
			}
		} else {
			message = "Cannot find compile cache location";
		}
	} else if (request.getParameter("reloadwebsite.x") != null) {
		message = "";
		if (website.getWebSiteCacheFolder() != null && website.getWebSiteCacheFolder().indexOf("_logs/") > -1) {
			website.writeToLog("deleting: "+new File(website.getWebSiteCacheFolder()).getAbsolutePath());
			boolean del = FileHelper.deleteDir(new File(website.getWebSiteCacheFolder()));
			if (del) { 
				message = "Compile cache successfully cleared. ";
			} else {
				message = "Compile cache delete failed. ";
			}
		} else {
			message = "Cannot find compile cache location. ";
		}
		
			
		co.simplypos.model.utils.Pair pair = co.simplypos.model.website.utils.FtpUpload.getHostNameAndAppFolder(website.getWebSiteURL());
		if (pair != null) {
			co.simplypos.model.website.WebSite.writeToPublicLog(request.getRequestURL().toString()+" manual tomcat restart and logs cleared at "+new File(website.getWebSiteCacheFolder()).getAbsolutePath());
			FtpUpload.reloadTomcatApp((String)pair.get(0), (String)pair.get(1), FtpUpload.TOMCAT_AUTH1, FtpUpload.TOMCAT_AUTH2); 
			String forwardPage = "websiterelaoaded.html";
			try {
		      		response.sendRedirect(forwardPage); 
			} catch (Exception e102) {
				out.write("<script type='text/javascript'>document.location.href='"+forwardPage+"';</script>"); 
			}	
			return;
		}
	}
} catch (Exception ee) {
	website.writeToLog(ee);
	message = "Exception: "+ee.getMessage();
}
if (request.getParameter("showhelp") != null) {
%>
		<div id="instructions" class="checkoutcontainer" align="left">
			<div class="pagetitle" align="left">
				<img src="../template/images/meta_help.png" alt="" style="position:relative; left:3px; top:5px;" />
				<span style="font-size: 14px;">How To Use This Page...</span>
			</div>
			<div style="color:#666666;font-size: 11px;margin-left:50px;">
				<i>
				<p>Use this page to edit html static content within your website. Simply <b>click on the page</b> you wish to edit. </p>
				<p>If you are editing a style sheet, a text editor page will open. From this page you can directly edit and save the stylesheet content.</p>
				<p>If you are editing any other pages, then click the file name to use the graphical editor which will allow you to make neccessary changes, upload further files and images and save the contents. For further detailed documentation relating to this editing software <a href="http://www.pintexx.com/pinedit/doc/pinEdit_UserHelp.pdf" target="_blank1"><u>click here</u></a>.  To edit the source code directly click on the source code link that is next to the file you wish to edit.</p>
				</i>
				<p><br /></p>
			</div>
		</div>
<%
}
 if (message != null) { %>
	<div class="checkoutcontainer" align="left">
		<div class="pagetitle" align="left">
			<span style="font-size: 14px;"><%=message%></span>
		</div>
	<br/>
<% } %>


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
						<i>Activity relating to the self-editing of your website is outside of the scope of the standard Intelligent Retail helpdesk support service. If you are unsure about any change you are planning to make, it is recommended that the Intelligent Retail website design team are commissioned to do the change for you. To request a quotation for commissioned design changes to your website, please send details of the request to <a href="mailto:creativedesign@intelligentretail.co.uk">creativedesign@intelligentretail.co.uk</a></i>
					</span>
				</td>
			</tr>
		</tbody>
	</table>

	<div class="checkoutcontainer" align="left">
		<div class="pagetitle" align="left">
			<img src="../template/images/meta_editor.png" alt="" style="position:relative; left:3px; top:5px;"  />
			<span style="font-size: 14px;">Select a page to edit:</span>
		</div>
	<br/>

	
	<table style="margin-top:0px; margin-left:50px;margin-bottom:15px;">
		<thead>
			<tr>
				<td class="smallertext" width="100"><u>Style Sheets</u></td> 
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>
					<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:blue;">
						<a href="../template/components/editcss.jsp" target="_blank">style.css</a>
					</span>
				</td>
				<td>
					<i>(main customisable style sheet for all browsers)</i>
				</td>
			</tr>
			<tr>
				<td>
					<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:blue;">
						<a href="../template/components/editcss.jsp?type=ie" target="_blank">style_ie.css</a>
					</span>
				</td>
				<td>
					<i>(optional style sheet dedicated to IE only!)</i>
				</td>
			</tr>
		</tbody>
	</table>
	<table style="margin-top:0px; margin-left:50px;margin-bottom:15px;">
		<thead>
			<tr>
				<td class="smallertext" width="100"><u>Meta Files</u></td> 
			</tr>
		</thead>
		<tbody>
			<tr>
				<td>
					<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:blue;">
						<a href="../template/components/editcss.jsp?type=metahdr" target="_blank">metaheader.html</a>
					</span>
				</td>
				<td>
					<i>(add meta header entries by adding to this file)</i>
				</td>
			</tr>
		</tbody>
	</table>

	<table style="margin-top:0px; margin-left:50px;margin-bottom:15px;">
		<thead>
			<tr>
				<td class="smallertext" width="5%"><u>Files In Use</u></td>
				<td class="smallertext" width="5%"><u>Edit Source Code</u></td>
			</tr>
		</thead>
		<tbody>
			<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:blue;">
			<%

			boolean colouron = true;
			String root = request.getSession().getServletContext().getRealPath("/");
			String extraParams = "go="+request.getParameter("go");
			File rootFile = new File(root);
			ArrayList fileList = new ArrayList();
			for (int i=0; i<rootFile.listFiles().length; i++) {
				
				File childFile = rootFile.listFiles()[i];
                           try {
				if (childFile.getName().endsWith(".html") && !FileHelper.isPageBlank(childFile)) fileList.add(childFile.getName());
				} catch (Exception e) {
					//out.write("<br />Failed: "+childFile.getName()+" with: "+e.getMessage());
					fileList.add(childFile.getName());
				}
				}
				Collections.sort(fileList);	
				for (int i=0;i<fileList.size();i++) {
					colouron = !colouron;
	       	       	String childFileName = ""+fileList.get(i);

					//String sb = FileHelper.readFileToString(new File(root, childFileName));

					%>
					<tr class="<%=(colouron?"editorcolourrow":"editornoncolouredrow")%>"><td><a href="<%="editPage.jsp?PageUrl="+website.getBaseURL(request)+"/"+childFileName%>" target="_blank"><%=childFileName%></a></td><td>    <a href="<%="../template/components/edithtml.jsp?file="+childFileName.substring(childFileName.lastIndexOf("/")+1,childFileName.lastIndexOf("."))%>" target="_blank">-source code-</a><BR>
					</td></tr> 
					<%
					
	      		 }
			%>
			</span>

                </tbody>
        </table>

        <table style="margin-top:0px; margin-left:50px;margin-bottom:15px;">
                <thead>
                        <tr>
 				<td class="smallertext" width="5%"><u>Files Currently Empty</u></td>
                            <td class="smallertext" width="5%"><u>Edit Source Code</u></td>
			  </tr>
                </thead>
                <tbody>
			<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:blue;">
			<%
			colouron = true;
			fileList = new ArrayList();
			for (int i=0; i<rootFile.listFiles().length; i++) {
				File childFile = rootFile.listFiles()[i];
                           try {
				if (childFile.getName().endsWith(".html") && FileHelper.isPageBlank(childFile)) fileList.add(childFile.getName());
				} catch (Exception e) {
					//out.write("<br />Failed: "+childFile.getName()+" with: "+e.getMessage());
				}
				}
				Collections.sort(fileList);	
				for (int i=0;i<fileList.size();i++) {
	       	       String childFileName = ""+fileList.get(i);
					colouron = !colouron;
					//String sb = FileHelper.readFileToString(new File(root, childFileName));

					%>
					<tr class="<%=(colouron?"editorcolourrow":"editornoncolouredrow")%>">
					<td valign="top">
					<a href="<%="editPage.jsp?PageUrl="+website.getBaseURL(request)+"/"+childFileName%>" target="_blank"><%=childFileName%></a><BR>
					</td>
					<td>
					<a href="<%="../template/components/edithtml.jsp?file="+childFileName.substring(childFileName.lastIndexOf("/")+1,childFileName.lastIndexOf("."))%>" target="_blank">-source code-</a><BR>
					</td>
					</tr>
					<%
					
	      		 }
			%>
			</span>


		</tbody>
	</table>
	<br /><br /><p>
	<div class="pagetitle" align="left">
		<span style="font-size: 14px;">Reloading Your Website (Clearing the Website Cache)</span><br />
	</div>
	<span style="font-size: 11px;">
	<p><b>WARNING!</b> Please read this fully before pressing the Reload Website button. <br /></p>
	<p>This button allows you to refresh the content on your website in order to make any page changes visible. Production websites typically utilise caching techniques to improve website performance. A side-effect of website caching is that changes you make may not be immediately viewable, instead the cached version showing.</p>
	<p>Reloading your website will clear the cache by <b>stopping then restarting your website</b>. If you choose this option then <strong>always check the site is running afterwards</strong> and notify the support team if this is not the case. Though this is unlikely, when changing content and reloading your website there is always an element of risk. Please make all of your changes then use this button as a final step to minimise its usage, as restarting will interrupt the smooth running of your website.</span><br /></p>
	<div id="adminreloadwebsite"><div id="adminreloadwebsiteinner">	
		<form action="?" method="post">
	 		<input type="image" alt="Reload Website"  name="reloadwebsite" value="" src="../template/images/reload_website.gif" />
		</form>	
		<br /><br />
	</div>
	</div>
	</div>
</div>
</div>
</div>
</div>
</div>
</body></html>