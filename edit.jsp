<%@ taglib uri="http://fckeditor.net/tags-fckeditor" prefix="FCK" %>
<%@ page language="java" import="java.io.*,java.util.*,co.simplypos.model.utils.helpers.FileHelper"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<html>
	<head>
		<title>Website Content Editor</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<meta name="robots" content="noindex, nofollow">
		<link href="/template/style.css" rel="stylesheet" type="text/css" />
		<script type="text/javascript">

function FCKeditor_OnComplete( editorInstance )
{
	window.status = editorInstance.Description ;
}

		</script>
	</head>
<body bgcolor="#F9F2DE">

<%

//if (request.getParameter("go") != null && new File(request.getSession().getServletContext().getRealPath("/")+"editor/key/"+request.getParameter("go")+".key").exists()) {  
if (request.getParameter("go") != null && new File(request.getSession().getServletContext().getRealPath("/")+"editor/key/").exists() && new File(request.getSession().getServletContext().getRealPath("/")+"editor/key/"+request.getParameter("go")+".key").exists()) { 

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

	int rev = 0;
	String root = request.getSession().getServletContext().getRealPath("/");
	if (request.getParameter("rev") != null) {
		rev = Integer.parseInt(request.getParameter("rev"));
		rev++;
	}
	
	String extraText = "";
	boolean extraIcon = false;
	if (request.getParameter("save") != null && request.getParameter("save").equals("yes")) {
		FileWriter fileout = new FileWriter(new File(root, request.getParameter("filename")));
		fileout.write(request.getParameter("EditorDefault"));
		fileout.close();
		extraIcon = true;
		extraText = "Revision "+rev+" saved successfully";

	} 

	String sb = FileHelper.readFileToString(new File(root, request.getParameter("filename")));


%>

<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tr valign="top">

<td width="1%" >
<form action="editor.jsp" method="post">
	<input type="submit" value="Back to Index">
<%
Enumeration params1 = request.getParameterNames();
while (params1.hasMoreElements()) {
	String parameter = (String) params1.nextElement() ;	
	if (parameter.equalsIgnoreCase("go")) {
%>
		<input type=hidden name="<%=parameter%>" value="<%=request.getParameter(parameter)%>">
<%
	}
}
%>
  
</form>
</td><td width="1%" >
<form action="edit.jsp" method="post">  
	<input type="submit" value="   Save   ">
</td>



<td width="100%" rowspan="2" align="center">
<table width="80%" border="1" align="center" cellspacing="0" cellpadding="0" borderwidth="1" bordercolor="#EDDFBF" bgcolor="#FFFFFF" >
<tr><td><table cellspacing="6" cellpadding="2"><tr><td width="1%" bgcolor="#F9F2DE"><img src="/images/spacer.gif" width="20" height="1" /></td>
<td style="font-family: Tahoma; font-size: 18px; font-weight: normal; color:#B1985D;"><%=request.getParameter("filename")%>
</td></tr></table>
</td></tr></table>
</td>
<td rowspan="2">
<img src="<%=path1%>editor/irlogo.gif" align="right" />
</td>
</tr>
<tr>


<td width="1%" colspan="2" style="font-family: Tahoma; font-size: 11px; font-weight: bold; color:darkred; ">
<% if (extraIcon) {%> <img src="<%=path1%>editor/thumbs_up.gif" />  <% } %>
<%=extraText%>
</td>

<td>

</td>
<td >
</td></tr>
</table>
<HR color="#EDDFBF"  >

<%
Enumeration params = request.getParameterNames();
while (params.hasMoreElements()) {
	String parameter = (String) params.nextElement() ;	
	if (!parameter.equalsIgnoreCase("EditorDefault") && !parameter.equalsIgnoreCase("save") && !parameter.equalsIgnoreCase("rev")) {
%>
		<input type=hidden name="<%=parameter%>" value="<%=request.getParameter(parameter)%>">
<%
	}
}
		

		String[] tokens = new String[]{".jpg",".gif"};
		String test = sb;
		StringBuffer newString = new StringBuffer(test);
		String last4 = "";
		int tokensFound = 0;
		for (int i=0;i<test.length();i++) {
			
			if (i>4) last4 = test.substring(i-3, i+1);
			//System.out.println(""+last4);
			String fileName = "";
			
			boolean found = false;
			for (int t=0;t<tokens.length;t++) {
				if (last4.equalsIgnoreCase(tokens[t])) {
					fileName = tokens[t];
					found = true;
				}
			}
			if (found) {
				int idx = i-3;
				char c;
				
				while (idx > 0) {
					idx--;
					//System.out.println("idx: "+idx);
					c = test.charAt(idx);
					if ("abcdefghijklmnopqrstuvwxyz1234567890-_./".toLowerCase().contains((""+c).toLowerCase())) {
						fileName = c+fileName;
					} else {
						if (newString.charAt(idx+1+tokensFound) != '/') {
							newString.insert(idx+1+tokensFound,"/");
							tokensFound++;
						}
						break;
					}
				}
				
				//System.out.println("     "+fileName);	
				
			}
			
		}
%>
 	<input type=hidden name="save" value="yes">
	<input type=hidden name="rev" value="<%=rev%>">


			<FCK:editor id="EditorDefault" basePath="<%=path1%>" height="90%"  
				imageBrowserURL="/editor/filemanager/browser/default/browser.html?Type=Image&Connector=connectors/jsp/connector"
				linkBrowserURL="/editor/filemanager/browser/default/browser.html?Connector=connectors/jsp/connector&ServerPath=/ROOT/"
				flashBrowserURL="/editor/filemanager/browser/default/browser.html?Type=Flash&Connector=connectors/jsp/connector"
				imageUploadURL="/editor/filemanager/upload/simpleuploader?Type=Image"
				linkUploadURL="/editor/filemanager/upload/simpleuploader?Type=File"
				flashUploadURL="/editor/filemanager/upload/simpleuploader?Type=Flash">
				
				
				<%=newString.toString()%>

			</FCK:editor>
</form>			
<% 
} else {
%>
    Access not allowed
<%
} %>		
	</body>
</html>