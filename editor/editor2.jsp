<%@ taglib uri="http://fckeditor.net/tags-fckeditor" prefix="FCK" %>
<%@ page language="java" import="java.io.*,java.util.*,co.simplypos.model.utils.helpers.FileHelper"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>Website Content Editor</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="robots" content="noindex, nofollow">
		<link href="/template/style.css" rel="stylesheet" type="text/css" />
	</head>


<body>

	<img src="../template/images/meta_logo.gif" style="position:relative; left:0px; top:1px; float:left;" />
	<div class="pagetitle" align="left" style="float:left; margin-left:40px;">
	</div>

<br/>

	<div class="checkoutcontainer" align="left">
	<div class="pagetitle" align="left">
		<img src="../template/images/meta_editor.png" alt="" style="position:relative; left:3px; top:5px;"  />
		<span style="font-size: 14px;">Edit a File</span>
	</div>

<br/>


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

			if (sb == null || sb.indexOf("<%") > -1) { 
		    		/* This page contains active content and therefore cannot be edited. Press Back on the browser to return to the editor menu. */
			} else {
				%>
				<a href="<%="index_tg.jsp?PageUrl=/"+childFileName+"&"+extraParams%>" target="_blank"><%=childFileName%></a><BR>
				<%
			}	
	       }
	%>
	</span>
	</body>
</html>