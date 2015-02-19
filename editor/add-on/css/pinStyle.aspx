<%@ Page Language="VB" validateRequest="false" %>

<script runat="server" >
Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

    Dim ps As New Pintexx.Components.Web.pinStyle

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

    ' create
    ps.create(Response)
End sub
</script>

