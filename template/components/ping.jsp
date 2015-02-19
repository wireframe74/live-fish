<%@page import="java.sql.Connection" %><%@page import="java.sql.Statement" %><%@page import="java.sql.ResultSet" %><jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" /><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" /><%
Connection conn = null;
try {
	out.write("STATUS:");
	conn = website.getConnection();
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery("select domain_id from domain_data where domain_id = 1");
	if (rs.next()) {
		if (rs.getInt(1) == 1) {
			out.write("OK");
		}
	}
	String servertag = null;
	try {
		servertag = new String(co.simplypos.model.utils.helpers.FileHelper.readSmallFile(new java.io.File("/home/public/server_name.txt"))); 
	} catch (Exception e34hg3) { 
		servertag="[]";
	}
	out.write(servertag);
} catch (Exception e) {
	website.writeToLog(e);
} finally {
	try {
		website.releaseConnection(conn); 
	} catch (Exception e111) {}
}
%>
<!-- end of ping.jsp -->