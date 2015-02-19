<%@ Page Language="VB" %>

<script runat="server" >
Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

  Dim licenseKey as String = ""

  '-------------------------------------------------------------------------
  ' Enter license key here
  '-------------------------------------------------------------------------
  licenseKey = "<-- key -->"

  if request.item("action") = "licensepu" then
    response.write("&error=0&key=" + licenseKey)
  end if
  response.end

End sub

</script>

