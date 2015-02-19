<%@ page import = "com.pintexx.components.web.pinEdit.*" %>

<%

    pinEdit pe = new pinEdit("","");

    // determine spell license key
    // application
    String pinEditSpellLicenseKey = (String) application.getAttribute("PINEDITSPELLLICENSEKEY");
    if(pinEditSpellLicenseKey != null) {
      pe.setSpellLicenseKey(pinEditSpellLicenseKey);
    } else {
      // session
      pinEditSpellLicenseKey = (String) session.getAttribute("PINEDITSPELLLICENSEKEY");
      if(pinEditSpellLicenseKey != null)
        pe.setSpellLicenseKey(pinEditSpellLicenseKey);
    }
    
    //---------------------------------------------------------------------
    // SET KEY DIRECTLY
    //---------------------------------------------------------------------
    //pe.setSpellLicenseKey("");
    
    out.write(pe.createStartup());

%>

