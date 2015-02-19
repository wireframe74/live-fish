<%@ Page Language="VB" %>

<script runat="server" >
Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

  Dim pu As Pintexx.Components.Web.pinUpload.pinUpload = New Pintexx.Components.Web.pinUpload.pinUpload
  Dim sAction As String = Request.Item("action")
  Dim sXML = "<?xml version=""1.0""?>"

  ' List DIR
  if sAction = "parsedir" then
    Dim sDir as string = request.item("dir")
    If check(sDir) Then
      Dim sDisplayFiles as string = request.item("displayfiles")
      sXML = sXML + pu.CreateFileList(sDir, IIf(sDisplayFiles = "1", True, False))
      Response.ContentType = "text/xml"
    end if
    response.write(sXml)
  end if

  If sAction = "newfolder" Then
    Dim sPath As String = Request.Item("path")
    If check(sPath) Then
      If pu.createFolder(sPath) Then
        Response.Write("&error=0")
      Else
        Response.Write("&error=1")
      End If
    end if
  End If

  If sAction = "rename" Then
    Dim sOldPath As String = Request.Item("oldpath")
    Dim sNewPath As String = Request.Item("newpath")

    If check(sNewPath) Then
      If pu.Rename(sOldPath, sNewPath) Then
        Response.Write("&error=0")
      Else
        Response.Write("&error=1")
      End If
    end if
  End If

  If sAction = "remove" Then
    Dim sPath As String = Request.Item("path")
    If check(sPath) Then
      If pu.Remove(spath) Then
        Response.Write("&error=0")
      Else
        Response.Write("&error=1")
      End If
    end if
  End If

  If sAction = "upload" Then
    Dim sPath as string = Request.Item("dir")
    Dim sImageSize as string = Request.Item("imagesize")
    If check(sPath) Then
      Try
        pu.Upload(sPath,sImageSize,Request)
      Catch ex1 As Exception
      End Try
    end if
  End If

  If sAction = "imagesize" Then
    Dim sPath as string = Request.Item("path")
    Try
      Response.write(pu.getImageSize(sPath))
    Catch ex1 As Exception
    End Try
  End If
  
  response.end
  
End sub

Function readLimitPath(ByVal path As String) As String()
  
  Dim config As New System.Xml.XmlDocument
  config.Load(path)
  Dim list As System.Xml.XmlNodeList = config.GetElementsByTagName("limitpath")
  Dim allPaths(list.Count - 1) As String
  Dim i As Integer
  For i = 0 To list.Count - 1
    Dim node As System.Xml.XmlNode = list.Item(i)
    allPaths(i) = node.Attributes.GetNamedItem("value").Value.ToLower
    allPaths(i) = allPaths(i).Replace("/", "\")
  Next
  
  Return allPaths
End Function

  Function check(ByVal sPath As String) As Boolean

    Dim isAllowed As Boolean = False
    Dim file As New System.IO.FileInfo(Request.PhysicalPath)
    Dim i As Integer
    Dim checkPath As New System.IO.FileInfo(sPath)
    Dim curPath As String = checkPath.FullName
    curPath = sPath.Replace("/", "\")
    curPath = curPath.ToLower

    Try
      Dim allPaths As String() = readLimitPath(file.DirectoryName + "\..\..\..\config\security.xml")
      For i = 0 To allPaths.Length - 1
        If curPath.StartsWith(allPaths(i)) Then
          isAllowed = True
          Exit For
        End If
      Next
    Catch ex As Exception
    End Try
    Return isAllowed

  End Function


</script>

