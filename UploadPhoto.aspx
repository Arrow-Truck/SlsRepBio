<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">

<!- ******************************************************************* ->
<!- * File: UploadPhoto.aspx                                          * ->
<!- *                                                                 * ->
<!- * Purpose: Upload STAFF photo                                 * ->
<!- *                                                                 * ->
<!- *                                                                 * ->
<!- * Written by: Clifton Davis 12.27.2005                            * ->
<!- *                                                                 * ->
<!- ******************************************************************* -> 
<%@ page language="vb" debug="true" %>
<%@ Import NameSpace="IBM.Data.DB2.iseries" %>
<%@ Import NameSpace="System.Data" %> 
<%@ Import NameSpace="System.Drawing.Printing" %>
<%@ Import NameSpace="System.IO" %>
<%@ Import NameSpace="system.drawing" %> 
<%@ Import NameSpace="system.drawing.image" %> 
<%@ Import NameSpace="system.drawing.drawing2d" %>
<%@ Import NameSpace="System.drawing.Graphics" %>   
<%@ Import NameSpace="System.drawing.Rectangle" %>   
<!- ******************************************************************* ->
<!- *                      Define Script                              * ->
<!- ******************************************************************* -> 
<Script Runat="Server">
Public strbranch As String

Sub Page_Load
 strbranch = Request.QueryString( "branch" )
 
 txtRepNo.focus()
End Sub
 
Sub Button_Click( s As Object, e As EventArgs )

	if trim(txtRepNo.text) = "" then
		lbluploaded.text = "Note: please enter Employee Number!"
		exit sub
	end if

	Dim strRepno As String = txtRepNo.text.trim()
	Dim strSlsImageFolder as String = "E:\Sites\arrowtruck_com\images\SlsPhotos\"
	Dim strUploadFile as String = strSlsImageFolder + strRepno + "\" + strRepno + "image1.jpg"

	lbluploaded.text = ""

	'Check if there is valid selected file
	If inpFileUp1.PostedFile.ContentLength() <> 0 Then
		lbluploaded.text = ""
		'Determine type and filename of uploaded image
		'Dim UploadedImageType As String = inpFileUp1.PostedFile.ContentType.ToString().ToLower()	'image/jpeg
		Dim UploadedImageFileName As String = inpFileUp1.PostedFile.FileName	'Chrysanthemum.jpg
		Dim sExt as String = System.IO.Path.GetExtension(UploadedImageFileName)	'.jpg

	    'Check the image file type: .JPG, .GIF
	    If instr(".JPG, .GIF", ucase(sExt)) = 0 then
			lbluploaded.text = "Error: You can only uplad an JPG/GIF file!"
			exit sub
		end if
			
		'Create an image object from the uploaded file
		Dim UploadedImage As System.Drawing.Image = System.Drawing.Image.FromStream(inpFileUp1.PostedFile.InputStream)
		'Dim UploadedImage As System.Drawing.Image = System.Drawing.Image.FromFile(UploadedImageFileName)
		
		'Determine width and height of uploaded image
		Dim UploadedImageWidth As single = UploadedImage.PhysicalDimension.Width
		Dim UploadedImageHeight As single = UploadedImage.PhysicalDimension.Height

	    'Check if the image with equal image height
		If UploadedImageWidth <> UploadedImageHeight Then
			lbluploaded.text = "Error: The dimension of this image is " & UploadedImageWidth & "x" & UploadedImageHeight & " px. The image width should be same as image height!"
			exit sub
		End If

		'*************************************************************************************** 
		'Create a subdirectory for each image grouping
		'Dim di As New DirectoryInfo("D:\Sites\arrowsite\images\SlsPhotos\")
		Dim di As New DirectoryInfo(strSlsImageFolder)
		Dim disub As DirectoryInfo
		disub = di.CreateSubdirectory(strRepno)
		'Delete existing folder 
		If disub.Exists = True Then
			disub.Delete(True)
			disub = di.CreateSubdirectory(strRepno)
		End If	
		
		'upload the file
		inpFileUp1.PostedFile.SaveAs(strUploadFile)

		'For resize, save to a temp file.
		dim strTempFile as string = strUploadFile.Replace(".jpg", "_temp.jpg")
		'Resize to 640
		createThumb(strUploadFile, strTempFile, 640)
		
		'Rename the file back to original name.
		File.Delete(strUploadFile)
		File.Move(strTempFile, strUploadFile)		
			
		' now create thumb with size of 210
		createThumb(strUploadFile, strUploadFile.Replace(".jpg", ".tb.jpg"), 210)
		
		' now create second thumb of 123
		createThumb(strUploadFile, strUploadFile.Replace(".jpg", ".tb2.jpg"), 123)
			
		lbluploaded.text = "Success: Staff Photo (" & strRepno & ") has been uploaded!"

'		'Redirect to next page
'		If strbranch = "IM" Then
'			Response.Redirect( "../IMMaint/SalesRepMenu2.aspx?branch=" + strbranch )
'		Else 
'			Response.Redirect( "SalesRepMenu.aspx?branch=" + strbranch )
'		End If
		'*************************************************************************************** 
		
	Else
		lbluploaded.text = "Error: Please select image file to upload!"
	End If
	
End Sub
Sub CancelUpload( s As Object, e As EventArgs )

	If strbranch = "IM" Then
	 	Response.Redirect( "../IMMaint/SalesRepMenu2.aspx?branch=" + strbranch )
	Else 
	 	Response.Redirect( "SalesRepMenu.aspx?branch=" + strbranch )
	End If 
End Sub
' ***************************************** ->
' * Create Thumb Nails                    * ->
' ***************************************** ->
Sub createThumb( ByVal strSrc As String, strDest As String, thumbWidth As Integer)

	Dim srcWidth As Integer
	Dim srcHeight As Integer
	Dim sizeRatio As Decimal
	Dim thumbHeight As Integer
	Dim bmp As BitMap
	Dim image As System.drawing.image
	Dim gr As System.drawing.graphics
	Dim rectDestination As System.Drawing.Rectangle	
	
	image = System.Drawing.Image.FromFile(strSrc)
	  
	srcWidth=image.Width
	srcHeight=image.Height 
	
	sizeRatio = cdec(srcHeight/srcWidth) 
	thumbHeight=Decimal.ToInt32(sizeRatio*thumbWidth)
	bmp = new Bitmap(thumbWidth, thumbHeight) 
	
	gr = System.Drawing.Graphics.FromImage(bmp) 
	gr.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality
	gr.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
	gr.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High
	
	rectDestination = new System.Drawing.Rectangle(0, 0, thumbWidth,thumbHeight)
	gr.DrawImage(image, rectDestination, 0, 0, srcWidth, srcHeight, GraphicsUnit.Pixel)
	
	bmp.Save(strDest)
	bmp.Dispose()
	image.Dispose()   

End Sub

Sub Home_Click( s As Object, e As EventArgs )
	Response.Redirect("SalesRepMenu.aspx?branch=" + strBranch)
End Sub

</script>
<!-- *********************************************************************** -->
<!-- * End of Script                                                       * -->
<!-- *********************************************************************** -->


<html><!-- InstanceBegin template="../Templates/main.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <!--
      <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
      <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
      <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    -->

    <!-- InstanceBeginEditable name="doctitle" -->
    <title>UploadPhoto</title>
    <!-- InstanceEndEditable -->
    <!-- InstanceBeginEditable name="head" -->
    <!-- InstanceEndEditable -->
    
	<style type="text/css">
    <!--
    body {
        margin-left: 0px;
        margin-top: 0px;
        margin-right: 0px;
        margin-bottom: 0px;
        font-size: 13px;
        font-family:Arial, Helvetica, sans-serif;
    }
    .style1 {
        font-weight: bold;
        font-style: italic;
        color: #FFFFFF;
    }
    .style2 {
        color: #000000;
        font-weight: bold;
        font-size: 25px;
    }

    .style4 {font-weight: bold; font-size: 18px; margin-top:8px; }

    -->
    </style>
</head>

<body>
<table width="800" border="0" align="center">
  <tr>
    <td valign="top">
      <table width="799" border="0">
        <tr>	
          <td align="left" width="30%" ><img src="../Images/arrowlogoweb.GIF" >
          </td>
          <td align="right" width="70%" valign="right" ><span class="style2">WEBSITE MAINTENANCE</span>
          </td>
        </tr>
      </table>
    </td>
   </tr>
   
   <tr>
      <td height="3" bgcolor="#CC3333"> </td>
   </tr>
       
  <tr>
    <td height="281"><!-- InstanceBeginEditable name="EditRegion3" -->

 <CENTER><form runat="Server">
 
  <center spry:hover="style4" class="style4">
    UPLOAD PROFILE PHOTO
  </center>
      
<table width="100%" border="0" cellpadding="3" cellspacing="3" >

<tr>
  <td align="center" style="color:blue">Note: you can only upload an JPG/GIF photo with square shape.</td>
</tr>
<tr><td>&nbsp;</td>	
</tr>

<tr>
  <td align="center"><asp:Label
              ID="lbluploaded"
			  ForeColor="#FF0000"
              runat="Server" /></td>
</tr>
<tr>
  <td align="center" >Enter Employee Number: &nbsp
    <asp:TextBox ID="txtRepNo" Width="200px" Font-Size="18px" runat="server" Wrap="false" Height="25px" />    
    </td>
</tr>
<tr>
  <td align="center">
      &nbsp;</td>
</tr>
<tr>
  <td align="center" valign="middle" ><input id="inpFileUp1" type="file" size="60" runat="Server" style="font-size:18px" ></td>
</tr>
<tr>
  <td>&nbsp;</td>
</tr>
<tr>
  <td align="center"><asp:Button
                   Text="Upload Photo" Width="400px" Font-Size="18px" 
                   OnClick="Button_Click"
                   runat="Server" /></td>
</tr>
<tr>
  <td align="center">&nbsp;</td>
</tr>
<tr>
  <td align="center"><asp:linkButton
                   Text="Cancel Upload"  Width="200px" Font-Size="18px" 
                   OnClick="CancelUpload"
                   runat="Server" /> &nbsp; &nbsp; &nbsp; 
    <asp:linkButton
                   Text="Return to Menu"  Width="200px" Font-Size="18px" 
                   OnClick="Home_Click"
                   runat="Server" /></td>
</tr>
<tr>
  <td align="center">&nbsp;</td>
</tr>
</table>
 </form></CENTER>	  
	
	<!-- InstanceEndEditable --></td>
  </tr>
  
  <tr>
    <td valign="top">
         <table width="799" border="0">
              <tr>
                <td height="12" bgcolor="#cc3333"> </td>
              </tr>
         </table>
    </td>
  </tr>
</table>
</body>
<!-- InstanceEnd --></html>
