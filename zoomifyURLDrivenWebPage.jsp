<HTML>
	<HEAD>
		<TITLE>Zoomify Flash Dynamic Display</TITLE>
	</HEAD>
	<BODY BGCOLOR='#ffffff'>
		<DIV ALIGN='center'>
			<SCRIPT language="javascript">
				var urlString = document.location.href;
				var paramIndex = urlString.indexOf("?")+1;
				var paramString = urlString.substring(paramIndex,urlString.length);
				document.write("	<OBJECT CLASSID='clsid:D27CDB6E-AE6D-11cf-96B8-444553540000'");
				document.write("           CODEBASE='http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=6,0,40,0'");
				document.write("           WIDTH='660'");
				document.write("           HEIGHT='460'");
				document.write("           ID='theMovie'>");
				document.write("			<PARAM NAME='FlashVars' VALUE='" + paramString + "'>");
				document.write("    		<PARAM NAME='src' VALUE='ZoomifyDynamicViewer.swf'>");
				document.write("		<EMBED SRC='ZoomifyDynamicViewer.swf'");
				document.write("		   FlashVars='" + paramString + "'");
				document.write("           PLUGINSPAGE='http://www.macromedia.com/shockwave/download/index.cgi?P1_Prod_Version=ShockwaveFlash'");
				document.write("           WIDTH='660'");
				document.write("           HEIGHT='460'");
				document.write("           NAME='theMovie'>");
				document.write("    	</EMBED>");
				document.write("   </OBJECT>");
			</SCRIPT>
 		</DIV>
	</BODY>
</HTML>
