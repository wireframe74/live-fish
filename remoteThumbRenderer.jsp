<%@page contentType="image/jpeg" %><%
try {
	byte[] b = co.simplypos.model.utils.helpers.ImageHelper.remoteRenderer(request, true);
	if (b != null && !response.isCommitted()) {
		int len = b.length;
		response.setContentLength(len);
		response.getOutputStream().write(b);
		response.getOutputStream().flush();
		response.getOutputStream().close();
	}
} catch (Exception ee142) {
	co.simplypos.model.website.utils.Logger.writeToLog(getServletContext().getRealPath(co.simplypos.model.website.utils.Logger.LOG_FILENAME), ee142);			
}
%>