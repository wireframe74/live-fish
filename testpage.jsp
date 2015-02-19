<!-- start of imageBrowser.jsp -->
<%@page import="co.simplypos.model.utils.helpers.HTMLHelper" %>
<%@page import="co.simplypos.model.website.RenderImageServlet" %>
<%@page import="co.simplypos.persistence.VendorArticle" %>
<%@page import="co.simplypos.persistence.BlobStorage" %>
<%@page import="java.io.File" %>
<%@page import="java.sql.Connection" %>
<%@page import="java.util.Hashtable" %>
<%@page import="java.util.Vector" %>
<%@page import="java.nio.charset.Charset" %>

<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />


 <%=Charset.defaultCharset()%>

