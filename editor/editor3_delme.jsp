<!-- start of components/metaKeyAdmin.html -->
<%@ taglib uri="http://fckeditor.net/tags-fckeditor" prefix="FCK" %>
<%@ page language="java" import="java.io.*,java.util.*,co.simplypos.model.utils.helpers.FileHelper"%>

<link rel="stylesheet" href="../template/framework.css" type="text/css" />
<link rel="stylesheet" href="../template/style.css" type="text/css" />

<body bgcolor="#ffffff" text="#000000" marginwidth="0" marginheight="0" topmargin="0" bottommargin="0" leftmargin="0" rightmargin="0">      
<style  TYPE="text/css"><!-- 
body {
	font-family: Verdana, Arial, "MS Sans Serif", sans-serif;
	color: #000000;
	margin-top: 4px;
	background:#FFFFFF;
}
li { list-style-type:none; }
--></style> 

	<img src="../template/images/meta_logo.gif" style="position:relative; left:0px; top:1px; float:left;" />

	<div class="pagetitle" align="left" style="float:left; margin-left:40px;">
	</div>

<span style="font-size: 14px; margin-right:18px; float:right;"><a href="#"><img src="../template/images/meta_help.png" border="0" style="position:relative; left:0px; top:5px;" /><u>HELP! Click here to show instructions</u></a></span>

<br/>
<br/>
<br/>
<br/>

	<div class="tabs" align="left" style="border-bottom: 2px solid #333333">
		<a href="../metakeyAdmin.jsp"><img src="../template/images/meta_tab_off.gif" alt="" style="position:relative; left:3px; top:5px;"  /></a>
		<a href="../editor/editor3.jsp"><img src="../template/images/editor_tab_on.gif" alt="" style="position:relative; left:3px; top:5px;"  /></a>
	</div>

<div class="checkoutcontainer" align="left">
	<div class="pagetitle" align="left">
		<img src="../template/images/meta_editor.png" alt="" style="position:relative; left:3px; top:5px;"  />
		<span style="font-size: 14px;">Select a page to Edit</span>
	</div>

<br/>

<table style="margin-top:0px; margin-left:50px;margin-bottom:15px;">
		<thead>
			<tr>
				<td class="smallertext" width="5%"><u>File Name</u></td>
			</tr>
		</thead>

		<tbody>
			<tr>
			<td>
			<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:blue;">
			<%
	
			String root = request.getSession().getServletContext().getRealPath("/");
			String extraParams = "go="+request.getParameter("go");
			File rootFile = new File(root);
			ArrayList fileList = new ArrayList();
			for (int i=0; i<rootFile.listFiles().length; i++) {
				File childFile = rootFile.listFiles()[i];
				if (childFile.getName().endsWith(".html")) fileList.add(childFile.getName());
				}
				Collections.sort(fileList);	
				for (int i=0;i<fileList.size();i++) {
	       	       String childFileName = ""+fileList.get(i);

					String sb = FileHelper.readFileToString(new File(root, childFileName));

					%>
					<a href="<%="../editor_new.jsp?PageUrl=/"+childFileName%>" target="_blank"><%=childFileName%></a><BR>
					<%
					
	      		 }
			%>
			</span>
			</td>
			</tr>
		</tbody>




</div>





</body></html>
<!-- end of components/metaKeyAdmin.html -->