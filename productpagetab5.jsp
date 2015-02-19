<%@ page language="java" contentType="text/html" %>
<%@ page pageEncoding="UTF-8"%>
<%@ page import="javax.xml.transform.*"%>
<%@ page import="javax.xml.transform.stream.*"%>
<%@ page import="co.simplypos.model.website.tracking.Feefo"%>
<%@ page import="co.simplypos.model.website.page.model.StockDetailPageModel"%>
<%@ page import="co.simplypos.model.utils.helpers.HTMLHelper"%>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" /><jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%! String FS = System.getProperty("file.separator");%><%
try {
	StockDetailPageModel pageModel = (StockDetailPageModel) userSession.getWebController().getCurrentPageController().getPageModel();
	Feefo feefo = (Feefo)userSession.getTrackingController().feefo;

	String feefoLogin = feefo.feefoLogin;
	String vendorArticleCode = feefo.getBestProductCode(pageModel.getVendorArticleId());

	String xmlFile = "http://www.feefo.com/feefo/xmlfeed.jsp?logon="+feefoLogin+"&vendorref="+vendorArticleCode+"&limit=100&mode=product";
	String xslFile = "feefofeedback.xsl"; //request.getParameter("XSL");

      String ctx = getServletContext().getRealPath("") + FS + "xslt" + FS;
      xslFile = ctx + xslFile;
      xmlFile = xmlFile;

	//out.write("<p>xslFile1: "+xslFile+"   <p>xmlFile1: "+xmlFile); 

	TransformerFactory tFactory = TransformerFactory.newInstance();
	Transformer transformer = tFactory.newTransformer(new StreamSource(xslFile));
	transformer.transform(new StreamSource(xmlFile), new StreamResult(out));
	
} catch (Exception ee) {
	website.writeToLog(ee);
}
%>