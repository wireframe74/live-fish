<%@ page import = "com.pintexx.components.web.pinEdit.*" %>

<%

  pinEdit pe = new pinEdit("editor","../../../editor");
  pe.setPositionWidth("100%");
  pe.setPositionHeight("100%");
  pe.setMenu(false);
  pe.setUserMode(pinEdit.PE_USERMODE_HTML);
  pe.setCallBackOnInit("onEditorLoaded");
  pe.setToolbarXMLPath(application.getRealPath("") + "\\editor\\config\\xml-toolbar\\toolbar-hf.xml");

  // determine license key
  // application
  String pinEditLicenseKey = (String) application.getAttribute("PINEDITLICENSEKEY");
  if(pinEditLicenseKey != null) {
    pe.setLicenseKey(pinEditLicenseKey);
  } else {
    // session
    pinEditLicenseKey = (String) session.getAttribute("PINEDITLICENSEKEY");
    if(pinEditLicenseKey != null)
      pe.setLicenseKey(pinEditLicenseKey);
  }

%>

<head>
<script>
function onEditorLoaded(objEditor)
{
  parent.onEditorLoaded(objEditor);
}
</script>
</head>
<body style="margin:0;overflow:hidden">

<%= pe.create() %>

</body>