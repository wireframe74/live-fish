<%@ page import = "com.pintexx.components.flash.*" %>

<%
  // create new instance
  pinUpload pu = new pinUpload();

  String edurl = request.getParameter("edurl");
  String path = request.getParameter("path");
  String url = request.getParameter("url");
  String lng = request.getParameter("lng");
  String imgfilter = request.getParameter("imgfilter");
  String docfilter = request.getParameter("docfilter");
  
  // set base url for pinupload folder
  pu.setBaseUrl(edurl + "add-on/upload/");
  // set upload folder
  pu.setUploadPath(path);
  // set upload url (required for image preview)
  pu.setUploadUrl(url);
  
  // set language
  pu.setLanguage(lng);

  // set image filter
  pu.setImageFilter(imgfilter);

  // set doc filter
  pu.setDocFilter(docfilter);

  // disable new button
  //pu.setEnableNew(false);

  // disable rename button
  //pu.setEnableRename(false);

  // disable delete button
  //pu.setEnableDelete(false);

  // display only folders
  //pu.setDisplayFiles(false);

  // set max file size per file
  //pu.setMaxFileSize(1000000);

  // set maximum of total files
  //pu.setTotalFileSize(3000000);

  // disable image resizing
  //pu.setEnableImageResize(false);
  
  // set image options for resizing
  // width 200 or 400; height is calculated
  //pu.setImageSize("200:-,400:-");
  
  // set background color
  //pu.setBackgroundColor("#ff0000");

  // set display style
  //pu.setDisplayStyle(2);
%>

<body style="margin:0px">
<%= pu.create() %>
</body>

