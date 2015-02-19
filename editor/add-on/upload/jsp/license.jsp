<%

  String licenseKey = "";

  //-------------------------------------------------------------------------
  // Enter license key here
  //-------------------------------------------------------------------------
  licenseKey = "<-- key -->";

  if(request.getParameter("action").equals("licensepu")) {
    out.print("&error=0&key=" + licenseKey);
  }

%>