<%@ page import="
	java.io.File,
	java.io.FileWriter,
	java.io.IOException,
	java.net.URLEncoder,
	java.text.SimpleDateFormat,
	java.util.StringTokenizer,
	javax.swing.UIManager,
	co.simplypos.model.website.ArticleMenu,
	co.simplypos.model.website.WebSite,
       co.simplypos.model.utils.helpers.StringHelper,
	co.simplypos.persistence.PersistenceManager
"%> 
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite"><%website.initialise(request.getRequestURL().toString(), application.getRealPath("/"), 170);%></jsp:useBean>
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession"><%userSession.initialise(website, request);%></jsp:useBean>
<%
if (website == null) {
%>
	<p><br />Website not initialised yet, awaiting first visitor to visit the website.
<%
} else {
	if (request.getParameter("launch") == null) {
%>
		<p><br />Please note that visiting this page is no longer required as sitemap files are now automatically generated nightly for convenience.

<%
	} else {

		response.setContentType("text/html");

		String fullHTMLIndex = website.getArticleMenu().getFullSiteIndexHTML();
    		
    		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    		StringBuffer output = new StringBuffer("<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n");
    		//output.append("<urlset xmlns=\"http://www.google.com/schemas/sitemap/0.84\">\n");
    		output.append("<urlset xmlns=\"http://www.google.com/schemas/sitemap/0.84\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xsi:schemaLocation=\"http://www.google.com/schemas/sitemap/0.84 http://www.google.com/schemas/sitemap/0.84/sitemap.xsd\">\n");
    		
		String fullHTMLIndex1 = null;
		try {
			fullHTMLIndex1 = co.simplypos.model.utils.helpers.FileHelper.readFileToString(new File(website.getWebSitePath(),"sitemap_static.html")); 
		} catch(Exception ee) {}

		fullHTMLIndex1 = StringHelper.replace(fullHTMLIndex1 ,"\"", "'");
		//out.write(""+fullHTMLIndex1);
		
		if (fullHTMLIndex1 != null) {
			StringTokenizer st = new StringTokenizer(fullHTMLIndex1,"<");
	
			int loopCheck = 99999;
			int loop = 0;
    			while (st.hasMoreTokens()) {
				if (loop++ > loopCheck) break;

				try {
	    				String s1 = ""+st.nextToken("<");
					//out.write("<br />"+s1);
					if (s1.startsWith("a href='")) {
						s1 = s1.substring(8);
						s1 = s1.substring(0,s1.indexOf('\''));
						output.append("   <url>\n");
						output.append("      <loc>"+s1+"</loc>\n");
						output.append("      <lastmod>"+sdf.format(new java.util.Date())+"</lastmod>\n");
						output.append("      <changefreq>weekly</changefreq>\n");
						output.append("   </url>\n");
					}
				} catch (Exception eeeeffe) {}
	    		}
		
		}
		StringTokenizer st = new StringTokenizer(fullHTMLIndex,"<");

		int loopCheck = 99999;
		int loop = 0;
    		while (st.hasMoreTokens()) {
			if (loop++ > loopCheck) break;

    			String s1 = ""+st.nextToken("<");
				if (s1.startsWith("a href='")) {
					s1 = s1.substring(8);
					s1 = s1.substring(0,s1.indexOf('\''));

					String params = s1.substring(s1.indexOf("?"));
					//if (!params.equals("")) params += "&";
					//params += "src=gsitemaps";
					String fileName = s1.substring(0,s1.indexOf("?"));
					File f = new File(website.getWebSitePath(), fileName);
					//if (f.exists()) {	 
						//out.print(StringHelper.replace(website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1)+f.getName()+params, '&', "&amp;"));							
						output.append("   <url>\n");
						output.append("      <loc>"+StringHelper.replace(website.getWebSiteURL().substring(0,website.getWebSiteURL().lastIndexOf("/")+1)+f.getName()+params, '&', "&amp;")+"</loc>\n");
						//output.append("      <lastmod>"+sdf.format(new java.util.Date(f.lastModified()))+"</lastmod>\n");
						output.append("      <lastmod>"+sdf.format(new java.util.Date())+"</lastmod>\n");
						output.append("      <changefreq>weekly</changefreq>\n");
						output.append("   </url>\n");
					//}					
				}
    		}








    		output.append("</urlset>\n");  
    		
		java.io.InputStream in = null;
    		FileWriter fw = null;
   		try {
			File file = new File(website.getWebSitePath(), "sitemap.xml");
			website.writeToLog("created file " + website.getWebSitePath() + "sitemap.xml");
    		fw = new FileWriter(file);
    		fw.write(output.toString());
		       
			//in = new java.io.BufferedInputStream(new java.io.FileInputStream(file) );
			//int ch;
		       //while ((ch = in.read()) !=-1) {
		       //	out.print((char)ch);
			//}
			out.print("Sitemap built");
    		} finally {
    		    if (fw != null) {
    				fw.close();
    		    }
			if (in != null) in.close();
    		}
	}
}
%>