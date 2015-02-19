<%@page isErrorPage="true" %><%@page import="java.sql.Connection,java.sql.ResultSet,java.sql.SQLException,java.sql.Statement"%><jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" /><%
	String newURI = null;
	String newURL = null;
	Connection internetConn = null;
	Statement stmt = null;
	ResultSet rs = null;
	String sql = "";
	String notFoundPageName = "";
	try {
		internetConn = website.getConnection();
		stmt = internetConn.createStatement();    		
    		if(pageContext != null) {    
    			ErrorData ed = null;
        		try {
            			ed = pageContext.getErrorData();
        		} catch(NullPointerException ne) {
        			// Catch and ignore it... it effectively means we can't use the ErrorData
        		}
		       if(ed != null) {
		    		notFoundPageName = website.getBaseURL(request)+ed.getRequestURI()+(request.getQueryString()==null?"":"?"+request.getQueryString());
				notFoundPageName = co.simplypos.model.utils.helpers.StringHelper.replace(notFoundPageName,".cg1",".cgi");
				notFoundPageName = co.simplypos.model.utils.helpers.StringHelper.replace(notFoundPageName,"%20","-");
				notFoundPageName = co.simplypos.model.utils.helpers.StringHelper.replace(notFoundPageName," ","-");
				notFoundPageName = co.simplypos.model.utils.helpers.StringHelper.replace(notFoundPageName,"'","");
				sql = "select newURI from meta_redirect where oldURL = '"+notFoundPageName+"'";
				//website.writeToLog("Meta Redirect sql: "+notFoundPageName);

				rs = stmt.executeQuery(sql);	
				if (rs.next()) {
					newURI = rs.getString(1);
					newURL = website.getBaseURL(request)+"/"+newURI;
				}
				internetConn.commit();	
        		}
    		}
	} catch (Exception ee1) {
		if (internetConn != null) {
			try {
	      			internetConn.rollback();
	     		} catch (SQLException ee2) {}
		}
		website.writeToLog("Could not read table meta_redirect. Reason: "+ee1.getMessage()+"    sql: "+sql);
	} finally {
		if (rs != null) {
			rs.close();
		}
		if (stmt != null) {
			stmt.close();
		}
		if (internetConn != null) {
			website.releaseConnection(internetConn);
		}
	}
	if (newURL != null) {		
		website.writeToLog("Meta Redirect1 forwarding from: "+notFoundPageName+" to: "+newURL);
		try {
//			response.setStatus(301);
//			response.sendRedirect(newURL); 

			response.setStatus(301);
			response.setHeader("Location", newURL);
			response.setHeader("Connection", "close");

		} catch (Exception e102) {
			out.write("<script type='text/javascript'>document.location.href='"+newURL+"';</script>"); 
		}		
	      	return;
	}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title><%=website.getWebsiteName()%></title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="keywords" content="" />
<meta name="description" content="" />
<meta HTTP-EQUIV="REFRESH" content="1; url=/index.jsp">
</head>
<body>
<p><br />Page not found, redirecting...
</body>
</html>