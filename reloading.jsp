<!-- start of reloading.html -->
<html>
<head>
<meta HTTP-EQUIV="REFRESH" content="5; url=<%=request.getParameter("pg")%><%=(request.getParameter("params")!=null?"?"+request.getParameter("params"):"")%>">
</head>							
<body>
<b>Reloading page, please wait...</b>
<br />
<br />
<i>(if the page does not reload automatically within 5 seconds please <a href="<%=request.getParameter("pg")%><%=(request.getParameter("params")!=null?"?"+request.getParameter("params"):"")%>">click here</a>)</i>
</body>
</html>
<!-- end of reloading.html -->