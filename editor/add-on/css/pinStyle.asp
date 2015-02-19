<%
	  set ps = Server.CreateObject("pinStyleASP.pinStyle")

    ps.Language = Request.QueryString("language")
    ps.Design = Request.QueryString("design")
    If Request.QueryString("url") <> "" Then
      ps.Url = Request.QueryString("url")
    End If
    If Request.QueryString("path") <> "" Then
      ps.Path = Request.QueryString("path")
    End If
    If Request.QueryString("file") <> "" Then
      ps.FileName = Request.QueryString("file")
    End If

    '-----------------------------------------------
    ' LICENSEKEY
    '-----------------------------------------------
    ps.LicenseKey = "<-- here -->"

    ' create
    ps.create1(response)
%>