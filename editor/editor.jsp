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
<body bgcolor="#F9F2DE">
<%
	String websitePath = application.getRealPath("/");
	String path1 = websitePath.substring(0, websitePath.length()-1);
	if (path1 != null && path1.indexOf("localhost") == -1) {
		try  {
			path1 = co.simplypos.model.utils.helpers.StringHelper.replace(path1.substring(path1.lastIndexOf("/")),"ROOT", "");
		} catch (Exception ee1) {
			out.write("Exception: "+ee1.getMessage());
		}
	}
	if (path1 != null && !path1.endsWith("/")) path1 += '/';
%>
<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
<td width="29%" style="font-family: Tahoma; font-size: 18px; font-weight: normal; color:gray; ">
Website Content Editor<BR>
<span style="font-family: Tahoma; font-size: 11px; font-weight: normal; color:gray;">Click on the file you wish to edit:</span>
</td><td width="28%" align="center" style="font-family: Tahoma; font-size: 11px; font-weight: bold; color:darkred; ">

</td>
<td >
<img src="<%=path1%>editor/irlogo.gif" align="right">
</td></tr>
</table>
<HR color="#EDDFBF"  >
<BR>
<% 
if (request.getParameter("go") != null && new File(request.getSession().getServletContext().getRealPath("/")+"editor/key/").exists() && new File(request.getSession().getServletContext().getRealPath("/")+"editor/key/"+request.getParameter("go")+".key").exists()) { 
%>

<table border="1" cellspacing="0" cellpadding="0" borderwidth="1" bordercolor="#EDDFBF" bgcolor="#FFFFFF" align="center"><tr><td>
<table cellspacing="10" cellpadding="2" align="center" border="0">
<tr>
<td bgcolor="#F9F2DE" ></td>
<td style="font-family: Tahoma; font-size: 18px; font-weight: normal; color:gray;">Website Files</td>
<td bgcolor="#F9F2DE" ></td>
<td style="font-family: Tahoma; font-size: 18px; font-weight: normal; color:gray;">Personal Files</td>
<td></td>

</div>
</tr>
<tr>

<td bgcolor="#F9F2DE" ><img src="/images/spacer.gif" width="20" height="1"></td>
<td><img src="/images/spacer.gif" width="300" height="1"></td>
<td bgcolor="#F9F2DE"><img src="/images/spacer.gif" width="20" height="1"></td>
<td><img src="/images/spacer.gif" width="300" height="1"></td>
<td><img src="/images/spacer.gif" width="20" height="1"></td>



</tr>
<tr><td bgcolor="#F9F2DE" ></td><td>
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
			%>
				<a href="<%="edit.jsp?filename="+childFileName+"&"+extraParams%>"><%=childFileName%></a><BR>
			<%
			
	       }
	%>
	</span>
<td bgcolor="#F9F2DE"></td></td><td>
	<span style="font-family: Tahoma; font-size: 12px; font-weight: normal; color:orange;">
	<%
	
		root = request.getSession().getServletContext().getRealPath("/personal/File/");
		rootFile = new File(root);
		if (rootFile.exists()) {
			fileList = new ArrayList();
			for (int i=0; i<rootFile.listFiles().length; i++) {
				File childFile = rootFile.listFiles()[i];
				if (childFile.getName().endsWith(".html")) fileList.add(childFile.getName());
			}
			Collections.sort(fileList);
			for (int i=0;i<fileList.size();i++) {
	       	       String childFileName = ""+fileList.get(i);
				%>
					<a href="<%="edit.jsp?filename=/personal/File/"+childFileName+"&"+extraParams%>"><%=childFileName%></a><BR>
				<%			
	       	}
		}
	%>
	</span>
<td></td></td></tr></table>
</td></tr></table>

<%
} else {
%>
    Access not allowed
<%
} %>		
	</body>
</html>