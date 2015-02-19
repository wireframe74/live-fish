<%@ page language="java" import="java.io.*,java.util.*,co.simplypos.model.utils.helpers.FileHelper,co.simplypos.model.website.utils.FtpUpload"%>
<jsp:useBean id="website"  scope="application" class="co.simplypos.model.website.WebSite" />
<jsp:useBean id="userSession" scope="session" class="co.simplypos.model.website.UserSession" />
<%if (!userSession.isLoggedIn() && (request.getParameter("go") == null || !request.getParameter("go").equals("g1ftware"))) {
        String forwardPage = "../myaccount.jsp";
        try {
                //Thread.sleep(2000);
                response.sendRedirect(forwardPage);
        } catch (Exception e102) {
                out.write("<script type='text/javascript'>document.location.href='"+forwardPage+"';</script>");
        }
}%>
<html>
<head>
<link rel="stylesheet" href="../template/framework.css" type="text/css" />
<%if (userSession.isUsingIE()) { %><link rel="stylesheet" href="../template/framework_ie.css" type="text/css" /><% } %>
<link rel="stylesheet" href="../template/style.css" type="text/css" />
<%if (userSession.isUsingIE()) { %><link rel="stylesheet" href="../template/style_ie.css" type="text/css" /><% } %>
</head>
<body>
<div id="adminstoredineditor">
<%@include file="../template/components/adminheader.jsp"%>
<div id="adminupload">
<%
if (request.getParameter("showhelp") != null) {
%>
                <div id="instructions" class="checkoutcontainer" align="left">
                        <div class="pagetitle" align="left">
                                <img src="../template/images/meta_help.png" alt="" style="position:relative; left:3px; top:5px;" />
                                <span style="font-size: 14px;">How To Use This Page...</span> 
                        </div>
                        <div style="color:#666666;font-size: 11px;margin-left:50px;">
                                <i>
                                <p>Use this page to upload additional files, click the correct button depending on what type of file you are uploading. </p>
                                </i>
                                <p><br /></p>
                        </div>
                </div>
<%
}
%>
</br>
Upload a html file - click below - (*.html only)
</br>
<applet name="jumpLoaderApplet"
                code="jmaster.jumploader.app.JumpLoaderApplet.class"
                archive="jumploader_z.jar"
                width="140"
                height="44"
                mayscript>
       <param name="uc_uploadUrl" value="/editor/uploadHandler_html.jsp?dir_name=<%=website.getWebSitePath()%>"/>
	<param name='uc_fileNamePattern' value='^.+\.((html))$'/>
	<param name='uc_maxFileLength' value='2097152'/>
       <param name="ac_mode" value="framed"/>
	<param name="gc_loggingLevel" value="INFO"/>
</applet>
</br>
</br>
Upload an image file - click below - (*.jpg *.jpeg *.gif *.png only)
</br>
<applet name="jumpLoaderApplet"
                code="jmaster.jumploader.app.JumpLoaderApplet.class"
                archive="jumploader_z.jar"
                width="140"
                height="44"
                mayscript>
       <param name="uc_uploadUrl" value="/editor/uploadHandler_img.jsp?dir_name=<%=website.getWebSitePath()+"images"%>"/>
	<param name='uc_fileNamePattern' value='^.+\.((gif)|(jpeg)|(jpg)|(png)|(GIF)|(JPEG)|(JPG)|(PNG))$'/>
	<param name='uc_addImagesOnly' value='true'/> 
	<param name='uc_maxFileLength' value='2097152'/>
       <param name="ac_mode" value="framed"/>
</applet>
</br>
</br>
Upload other files - click below - (*.txt *.pdf *.js only saved to /cust folder)
</br>
<applet name="jumpLoaderApplet"
                code="jmaster.jumploader.app.JumpLoaderApplet.class"
                archive="jumploader_z.jar"
                width="140"
                height="44"
                mayscript>
       <param name="uc_uploadUrl" value="/editor/uploadHandler_other.jsp?dir_name=<%=website.getWebSitePath()+"cust"%>"/>
	<param name='uc_fileNamePattern' value='^.+\.((txt)|(pdf)|(js))$'/>
       <param name='uc_maxFileLength' value='2097152'/>
       <param name="ac_mode" value="framed"/>
</applet>
<div id="adminuploadspacer"></div>
</div>
</div>
</div>
</div>
</div>
</body></html>
