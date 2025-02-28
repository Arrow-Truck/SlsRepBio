<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<%@ Page Language="vb" Debug="true" %>

<%@ Import Namespace="IBM.Data.DB2.iseries" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Drawing.Printing" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="system.drawing" %>
<%@ Import Namespace="system.drawing.image" %>
<%@ Import Namespace="system.drawing.drawing2d" %>
<%@ Import Namespace="System.drawing.Graphics" %>
<%@ Import Namespace="System.drawing.Rectangle" %>

<script runat="Server">
    Public strbranch As String

    Sub Page_Load()

        If Session("SLSREPBIO_USER") Is Nothing Or Session("SLSREPBIO_BRANCH") Is Nothing Then
            Response.Redirect("SlsMaintLogin.aspx")
        End If

        lblBranchText.Text = Session("SLSREPBIO_BRANCHTEXT")
        lblBranch.Text = Session("SLSREPBIO_BRANCH")
        If Not IsPostBack Then
            GetReps()
        End If

    End Sub

    Sub Upload_Click(s As Object, e As EventArgs)

        If dropRep.SelectedValue Is Nothing Then
            lbluploaded.Text = "Note: please enter Employee Number!"
            Exit Sub
        End If

        Dim strRepno As String = dropRep.SelectedValue
        Dim strSlsImageFolder As String = ConfigurationManager.AppSettings("PathSLSPhotos")
        Dim strUploadFile As String = strSlsImageFolder + strRepno + "\" + strRepno + "image1.jpg"

        lbluploaded.Text = ""

        'Check if there is valid selected file
        If inpFileUp1.PostedFile.ContentLength() <> 0 Then
            lbluploaded.Text = ""
            'Determine type and filename of uploaded image
            'Dim UploadedImageType As String = inpFileUp1.PostedFile.ContentType.ToString().ToLower()	'image/jpeg
            Dim UploadedImageFileName As String = inpFileUp1.PostedFile.FileName    'Chrysanthemum.jpg
            Dim sExt As String = System.IO.Path.GetExtension(UploadedImageFileName) '.jpg

            'Check the image file type: .JPG, .GIF
            If InStr(".JPG, .GIF", UCase(sExt)) = 0 Then
                lbluploaded.Text = "Error: You can only uplad an JPG/GIF file!"
                Exit Sub
            End If

            'Create an image object from the uploaded file
            Dim UploadedImage As System.Drawing.Image = System.Drawing.Image.FromStream(inpFileUp1.PostedFile.InputStream)
            'Dim UploadedImage As System.Drawing.Image = System.Drawing.Image.FromFile(UploadedImageFileName)

            'Determine width and height of uploaded image
            Dim UploadedImageWidth As Single = UploadedImage.PhysicalDimension.Width
            Dim UploadedImageHeight As Single = UploadedImage.PhysicalDimension.Height

            'Check if the image with equal image height
            If UploadedImageWidth <> UploadedImageHeight Then
                lbluploaded.Text = "Error: The dimension of this image is " & UploadedImageWidth & "x" & UploadedImageHeight & " px. The image width should be same as image height!"
                Exit Sub
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
            Dim strTempFile As String = strUploadFile.Replace(".jpg", "_temp.jpg")
            'Resize to 640
            createThumb(strUploadFile, strTempFile, 640)

            'Rename the file back to original name.
            File.Delete(strUploadFile)
            File.Move(strTempFile, strUploadFile)

            ' now create thumb with size of 210
            createThumb(strUploadFile, strUploadFile.Replace(".jpg", ".tb.jpg"), 210)

            ' now create second thumb of 123
            createThumb(strUploadFile, strUploadFile.Replace(".jpg", ".tb2.jpg"), 123)

            lbluploaded.Text = "Success: Staff Photo (" & strRepno & ") has been uploaded!"


        Else
            lbluploaded.Text = "Error: Please select image file to upload!"
        End If

    End Sub

    Sub createThumb(ByVal strSrc As String, strDest As String, thumbWidth As Integer)

        Dim srcWidth As Integer
        Dim srcHeight As Integer
        Dim sizeRatio As Decimal
        Dim thumbHeight As Integer
        Dim bmp As Bitmap
        Dim image As System.Drawing.Image
        Dim gr As System.Drawing.Graphics
        Dim rectDestination As System.Drawing.Rectangle

        image = System.Drawing.Image.FromFile(strSrc)

        srcWidth = image.Width
        srcHeight = image.Height

        sizeRatio = CDec(srcHeight / srcWidth)
        thumbHeight = Decimal.ToInt32(sizeRatio * thumbWidth)
        bmp = New Bitmap(thumbWidth, thumbHeight)

        gr = System.Drawing.Graphics.FromImage(bmp)
        gr.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.HighQuality
        gr.CompositingQuality = System.Drawing.Drawing2D.CompositingQuality.HighQuality
        gr.InterpolationMode = System.Drawing.Drawing2D.InterpolationMode.High

        rectDestination = New System.Drawing.Rectangle(0, 0, thumbWidth, thumbHeight)
        gr.DrawImage(image, rectDestination, 0, 0, srcWidth, srcHeight, GraphicsUnit.Pixel)

        bmp.Save(strDest)
        bmp.Dispose()
        image.Dispose()

    End Sub

    Sub GetReps()
        Dim con = New iDB2Connection(ConfigurationManager.AppSettings("ConnString"))
        con.Open()

        Dim strSql = "Select * from SLSREPBIO where  SLSBRANCH Like ('%" & lblBranch.Text & "%')" + "  Order by SLSREPNO"
        Dim cmd = New iDB2Command(strSql, con)

        Dim dbReader = cmd.ExecuteReader()

        While dbReader.Read()
            Dim repName = dbReader("SLSFNAME").Trim() + " " + dbReader("SLSLNAME").Trim()
            Dim repNo = dbReader("SLSREPNO").ToString()
            dropRep.Items.Add(New ListItem(repNo + ": " + repName, repNo))
        End While

        dbReader.Close()
        con.Close()
    End Sub

    Sub CancelUpload(s As Object, e As EventArgs)
        Response.Redirect("SalesRepMenu.aspx")
    End Sub

    Sub Home_Click(s As Object, e As EventArgs)
        Response.Redirect("SalesRepMenu.aspx")
    End Sub

</script>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>UploadPhoto</title>
    <style type="text/css">
        body {
            margin-left: 0px;
            margin-top: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
            font-size: 13px;
            font-family: Arial, Helvetica, sans-serif;
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

        .style4 {
            font-weight: bold;
            font-size: 18px;
            margin-top: 8px;
        }
    </style>
</head>

<body>
    <table width="800" border="0" align="center">
        <tr>
            <td valign="top">
                <table width="799" border="0">
                    <tr>
                        <td align="left" width="30%">
                            <img src="Images/arrowlogoweb.GIF" alt="Arrow Truck Sales">
                        </td>
                        <td align="right" width="70%" valign="right"><span class="style2">WEBSITE MAINTENANCE</span>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>

        <tr>
            <td height="3" bgcolor="#CC3333"></td>
        </tr>

        <tr>
            <td height="281">

                <center>
                    <form runat="Server">

                        <center spry:hover="style4" class="style4">
                            UPLOAD PROFILE PHOTO
                        </center>

                        <table cellpadding="3" cellspacing="3" style="width: 100%; border: 0; font-size: small; line-height:30px;">

                            <tr>
                                <td align="center" style="color: blue">Note: you can only upload an JPG/GIF photo with square shape.</td>
                            </tr>
                            <tr>
                                <td align="center" style="font-weight: 600; padding-top: 20px; font-size:medium">Branch: 
                                    <asp:Label ID="lblBranch" runat="Server" Visible="false" />
                                    <asp:Label ID="lblBranchText" runat="Server" Style="margin-left: 10px;" />
                                </td>
                            </tr>

                            <tr>
                                <td align="center" style="font-size:medium; padding-bottom:20px">Select Employee: 
                                    <asp:DropDownList ID="dropRep" Width="300px" runat="server" Wrap="false" Height="25px" />
                                </td>
                            </tr>
                            <tr>
                                <td align="center" valign="middle" style="padding:10px 0 10px 0">
                                    <input id="inpFileUp1" type="file" size="60" runat="Server" style="font-size: 18px"></td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <asp:Label ID="lbluploaded" ForeColor="#FF0000" runat="Server" />
                                </td>
                            </tr>
                            <tr>
                                <td align="center" style="padding:10px 0 10px 0">
                                    <asp:Button
                                        Text="Upload Photo" Width="400px" Font-Size="18px"
                                        OnClick="Upload_Click"
                                        runat="Server" />
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <asp:LinkButton
                                        Text="Cancel Upload" Width="200px" Font-Size="18px"
                                        OnClick="CancelUpload"
                                        runat="Server" />
                                    <asp:LinkButton
                                        Text="Return to Menu" Width="200px" Font-Size="18px"
                                        OnClick="Home_Click"
                                        runat="Server" /></td>
                            </tr>
                        </table>
                    </form>
                </center>

            </td>
        </tr>

        <tr>
            <td valign="top">
                <table width="799" border="0">
                    <tr>
                        <td height="12" bgcolor="#cc3333"></td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>

</html>
