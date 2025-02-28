<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Website Maintenance</title>

    <%@ Import Namespace="IBM.Data.DB2.iseries" %>
    <%@ Import Namespace="System.Data" %>
    <%@ Import Namespace="System.Web.Mail" %>

    <script runat="Server">

        Public strFleet As String
        Public strYear As String
        Public strVin As String
        Public strRepNumber As String
        Public strbranch As String

        Sub Page_Load()

            If Session("SLSREPBIO_USER") Is Nothing Or Session("SLSREPBIO_BRANCH") Is Nothing Then
                Response.Redirect("SlsMaintLogin.aspx")
            End If

            strRepNumber = Request.QueryString("slsrepno")
            txtRepID.Text = strRepNumber

            strbranch = Session("SLSREPBIO_BRANCH")
            lblBranch.Text = strbranch

            If Not IsPostBack Then
                LoadLanguages()
                LoadRep()
            End If

        End Sub

        Sub LoadRep()
            Dim inspeccon As New iDB2Connection
            Dim cmdSelect As iDB2Command
            Dim dtrSelect As iDB2DataReader

            inspeccon = New iDB2Connection(ConfigurationManager.AppSettings("ConnString"))
            inspeccon.Open()


            cmdSelect = New iDB2Command("Select * from SLSREPBIO where SLSREPNO = ? ", inspeccon)
            cmdSelect.Parameters.Add("@slsrepno", txtRepID.Text)

            dtrSelect = cmdSelect.ExecuteReader()

            While dtrSelect.Read()
                txtRepID.Text = dtrSelect("SLSREPNO")
                lblBranch.Text = dtrSelect("SLSBRANCH").trim()
                lblBranchText.Text = dtrSelect("SLSREPBR").trim()
                txtFirstName.Text = dtrSelect("SLSFNAME").trim()
                txtLastName.Text = dtrSelect("SLSLNAME").trim()
                txtEmail.Text = dtrSelect("SLSEMAIL").trim()
                txtPhone.Text = dtrSelect("SLSPHONE").trim()
                txtRepBio.Text = dtrSelect("SLSBIO").trim()
                DropLang1.SelectedValue = dtrSelect("SLSLANG1").trim()
                DropLang2.SelectedValue = dtrSelect("SLSLANG2").trim()
                DropLang3.SelectedValue = dtrSelect("SLSLANG3").trim()
                DropLang4.SelectedValue = dtrSelect("SLSLANG4").trim()
                DropLang5.SelectedValue = dtrSelect("SLSLANG5").trim()
                DropLang6.SelectedValue = dtrSelect("SLSLANG6").trim()
                DropLang7.SelectedValue = dtrSelect("SLSLANG7").trim()
                DropLang8.SelectedValue = dtrSelect("SLSLANG8").trim()

            End While

            inspeccon.Close()

        End Sub

        Sub Update_Click(s As Object, e As EventArgs)
            'txtPhone 
            txtPhone.Text = Trim(txtPhone.Text)
            If Trim(txtPhone.Text) <> "" Then
                If IsNumeric(txtPhone.Text) = False Or Len(txtPhone.Text) <> 10 Then
                    lblrequest.Text = "Invalid Phone Number. Please enter 10 digits phone number."
                    lblrequest.Focus()
                    Exit Sub
                End If
            End If

            Dim con As New iDB2Connection
            Dim cmdUpdate As iDB2Command
            Dim strSQL As String

            con.ConnectionString = ConfigurationManager.AppSettings("ConnString")
            con.Open()

            strSQL = "Update SLSREPBIO set " +
             "SLSREPBR=?,SLSBRANCH=?,SLSFNAME=?,SLSLNAME=?,SLSEMAIL=?,SLSPHONE=?,SLSBIO=?,SLSLANG1=?,SLSLANG2=?,SLSLANG3=?,SLSLANG4=?,SLSLANG5=?,SLSLANG6=?,SLSLANG7=?,SLSLANG8=? where SLSREPNO= ?"

            cmdUpdate = New iDB2Command(strSQL, con)

            'Need to replace some special characters at the fields. Such as ‘a’, it’s, “A”, – to -, "" etc. Chr(39) is ', Chr(34) is ". 
            '.Replace("'", Chr(39)).Replace("’", Chr(39)).Replace("‘", Chr(39)).Replace(Chr(147), Chr(34)).Replace(Chr(148), Chr(34))
            Dim strRepBio As String = Trim(txtRepBio.Text).Replace("'", Chr(39)).Replace("’", Chr(39)).Replace("‘", Chr(39)).Replace(Chr(147), Chr(34)).Replace(Chr(148), Chr(34)).Replace("–", "-")

            cmdUpdate.Parameters.Add("@SLSREPBR", lblBranchText.Text)
            cmdUpdate.Parameters.Add("@SLSBRANCH", lblBranch.Text.Trim())
            cmdUpdate.Parameters.Add("@SLSFNAME", txtFirstName.Text.ToUpper().Trim())
            cmdUpdate.Parameters.Add("@SLSLNAME", txtLastName.Text.ToUpper().Trim())
            cmdUpdate.Parameters.Add("@SLSEMAIL", txtEmail.Text.ToUpper().Trim())
            cmdUpdate.Parameters.Add("@SLSPHONE", Trim(txtPhone.Text))
            cmdUpdate.Parameters.Add("@SLSBIO", strRepBio)
            cmdUpdate.Parameters.Add("@SLSLANG1", DropLang1.SelectedItem.Text.Trim())
            cmdUpdate.Parameters.Add("@SLSLANG2", DropLang2.SelectedItem.Text.Trim())
            cmdUpdate.Parameters.Add("@SLSLANG3", DropLang3.SelectedItem.Text.Trim())
            cmdUpdate.Parameters.Add("@SLSLANG4", DropLang4.SelectedItem.Text.Trim())
            cmdUpdate.Parameters.Add("@SLSLANG5", DropLang5.SelectedItem.Text.Trim())
            cmdUpdate.Parameters.Add("@SLSLANG6", DropLang6.SelectedItem.Text.Trim())
            cmdUpdate.Parameters.Add("@SLSLANG7", DropLang7.SelectedItem.Text.Trim())
            cmdUpdate.Parameters.Add("@SLSLANG8", DropLang8.SelectedItem.Text.Trim())
            cmdUpdate.Parameters.Add("@SLSREPNO", txtRepID.Text)

            cmdUpdate.ExecuteNonQuery()

            con.Close()

            lblrequest.Text = "STAFF INFO HAS BEEN UPDATED!"
            lblrequest.Visible = True

        End Sub

        Sub Return_Click(s As Object, e As EventArgs)
            Response.Redirect("ViewSalesReps.aspx")
        End Sub

        '* New function to load languages to all the drop down
        Sub LoadLanguages()
            Dim i As Integer
            Dim sCtl As Object

            For i = 1 To 8
                sCtl = GetControl(i)
                sCtl.Items.Add("    ")
                sCtl.Items.Add("ARABIC")
                sCtl.Items.Add("BOSNIAN")
                sCtl.Items.Add("BULGARIAN")
                sCtl.Items.Add("CHINESE")
                sCtl.Items.Add("CROATIAN")
                sCtl.Items.Add("CZECH")
                sCtl.Items.Add("DARI")
                sCtl.Items.Add("DUTCH")
                sCtl.Items.Add("FARSI")
                sCtl.Items.Add("FRENCH")
                sCtl.Items.Add("GERMAN")
                sCtl.Items.Add("GREEK")
                sCtl.Items.Add("HEBREW")
                sCtl.Items.Add("HINDI")
                sCtl.Items.Add("ITALIAN")
                sCtl.Items.Add("JAPANESE")
                sCtl.Items.Add("MACEDONIAN")
                sCtl.Items.Add("NIGERIA")
                sCtl.Items.Add("POLISH")
                sCtl.Items.Add("PORTUGUESE")
                sCtl.Items.Add("PUNJABI")
                sCtl.Items.Add("RUSSIAN")
                sCtl.Items.Add("SERBIAN")
                sCtl.Items.Add("SLOVAK")
                sCtl.Items.Add("SOMALI")
                sCtl.Items.Add("SPANISH")
                sCtl.Items.Add("SWAHILI")
                sCtl.Items.Add("TAMIL")
                sCtl.Items.Add("TURKISH")
                sCtl.Items.Add("UKRAINE")
                sCtl.Items.Add("URDU")
                sCtl.Items.Add("VIETNAM")
            Next
        End Sub

        'Get the rioght control
        Function GetControl(ByVal sIndex As Integer) As Object
            'On Error Resume Next		
            Select Case sIndex
                Case 1 : Return DropLang1
                Case 2 : Return DropLang2
                Case 3 : Return DropLang3
                Case 4 : Return DropLang4
                Case 5 : Return DropLang5
                Case 6 : Return DropLang6
                Case 7 : Return DropLang7
                Case 8 : Return DropLang8
            End Select
        End Function

        Sub Home_Click(s As Object, e As EventArgs)
            Response.Redirect("SalesRepMenu.aspx")
        End Sub

    </script>

    <style type="text/css">
        body {
            margin-left: 0px;
            margin-top: 0px;
            margin-right: 0px;
            margin-bottom: 0px;
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

        .auto-style1 {
            width: 119px;
        }

        .auto-style2 {
            width: 108px;
        }

        .auto-style3 {
            width: 267px;
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

                <p align="center"><strong>UPDATE STAFF </strong></p>

                <form runat="Server">
                    <table width="820" border="0" bordercolor="#E7DFE7">
                        <tr>
                            <td colspan="2" align="center">
                                <asp:Label
                                    ID="lblrequest"
                                    Visible="false"
                                    ForeColor="#FF0000"
                                    Text="STAFF HAS BEEN UPDATED."
                                    runat="Server" /></td>
                        </tr>
                        <tr>
                            <td width="129">Emp ID:</td>
                            <td width="681">
                                <asp:label ID="txtRepID" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td width="129">Branch:</td>
                            <td>
                                <asp:label ID="lblBranchText" runat="server" />
                                <asp:Label ID="lblBranch" runat="server" Visible="false" /></td>
                        </tr>
                        <tr>
                            <td width="129">First Name:</td>
                            <td>
                                <asp:TextBox
                                    ID="txtFirstName"
                                    Columns="35"
                                    runat="server" MaxLength="25" />
                                <asp:RequiredFieldValidator
                                    ControlToValidate="txtFirstName"
                                    Text="Required!" ForeColor="Red"
                                    Display="Dynamic"
                                    runat="Server" /></td>
                        </tr>
                        <tr>
                            <td width="129">Last Name:</td>
                            <td>
                                <asp:TextBox
                                    ID="txtLastName"
                                    Columns="35"
                                    runat="server" MaxLength="25" />
                                <asp:RequiredFieldValidator
                                    ControlToValidate="txtLastName"
                                    Text="Required!" ForeColor="Red"
                                    Display="Dynamic"
                                    runat="Server" /></td>
                        </tr>
                        <tr>
                            <td width="129">Email:</td>
                            <td>
                                <asp:TextBox
                                    ID="txtEmail"
                                    Columns="35"
                                    runat="server" MaxLength="40" />
                                <asp:RequiredFieldValidator
                                    ControlToValidate="txtEmail"
                                    Text="Required!" ForeColor="Red"
                                    Display="Dynamic"
                                    runat="Server" />
                            </td>
                        </tr>
                        <tr>
                            <td valign="top">Phone:</td>
                            <td valign="top">
                                <asp:TextBox
                                    ID="txtPhone"
                                    Columns="35"
                                    runat="Server" MaxLength="10" />
                                &nbsp;(10 digits. E.g. 8166274900)</td>
                        </tr>
                        <tr>
                            <td valign="top">Rep Bio:</td>
                            <td valign="top">
                                <asp:TextBox
                                    ID="txtRepBio"
                                    MaxLength="800"
                                    Columns="75"
                                    runat="server" Wrap="true" TextMode="MultiLine" Rows="8" /></td>
                        </tr>
                    </table>
                    <table width="789" border="0" bordercolor="#E7DFE7">
                        <tr>
                            <td width="131"></td>
                            <td class="auto-style2">
                                <asp:Label
                                    ID="lbl4l"
                                    ForeColor="#000000"
                                    Text="Language 1:"
                                    runat="Server" /></td>
                            <td class="auto-style3">
                                <asp:DropDownList
                                    ID="DropLang1"
                                    Columns="10"
                                    runat="server" /></td>
                            <td class="auto-style1">
                                <asp:Label
                                    ID="lbl8l"
                                    Text="Language 5:"
                                    runat="Server" /></td>
                            <td width="282">
                                <asp:DropDownList
                                    ID="DropLang5"
                                    Columns="10"
                                    runat="server" /></td>
                        </tr>
                        <tr>
                            <td width="131"></td>
                            <td class="auto-style2">
                                <asp:Label
                                    ID="lbl5l"
                                    Text="Language 2:"
                                    runat="Server" /></td>
                            <td class="auto-style3">
                                <asp:DropDownList
                                    ID="DropLang2"
                                    Columns="10"
                                    runat="server" /></td>
                            <td class="auto-style1">
                                <asp:Label
                                    ID="lbl9l"
                                    Text="Language 6:"
                                    runat="Server" /></td>
                            <td width="282">
                                <asp:DropDownList
                                    ID="DropLang6"
                                    Columns="10"
                                    runat="server" /></td>
                        </tr>
                        <tr>
                            <td width="131"></td>
                            <td class="auto-style2">
                                <asp:Label
                                    ID="lbl6l"
                                    Text="Language 3:"
                                    runat="Server" /></td>
                            <td class="auto-style3">
                                <asp:DropDownList
                                    ID="DropLang3"
                                    Columns="10"
                                    runat="server" /></td>
                            <td class="auto-style1">
                                <asp:Label
                                    ID="lbl10l"
                                    Text="Language 7:"
                                    runat="Server" /></td>
                            <td width="282">
                                <asp:DropDownList
                                    ID="DropLang7"
                                    Columns="10"
                                    runat="server" /></td>
                        </tr>
                        <tr>
                            <td width="131"></td>
                            <td class="auto-style2">
                                <asp:Label
                                    ID="lbl7l"
                                    Text="Language 4:"
                                    runat="Server" /></td>
                            <td class="auto-style3">
                                <asp:DropDownList
                                    ID="DropLang4"
                                    Columns="10"
                                    runat="server" /></td>
                            <td class="auto-style1">
                                <asp:Label
                                    ID="lbl11l"
                                    Text="Language 8:"
                                    runat="Server" /></td>
                            <td width="282">
                                <asp:DropDownList
                                    ID="DropLang8"
                                    Columns="10"
                                    runat="server" /></td>
                        </tr>
                        <tr>
                            <td width="131"></td>
                            <td class="auto-style2"></td>
                            <td class="auto-style3"></td>
                            <td class="auto-style1"></td>
                        </tr>
                    </table>
                    <table width="789" border="0" bgcolor="#FFFFFF">

                        <tr>
                            <td colspan="5" align="center">
                                <asp:Button
                                    Text="  Update Staff  "
                                    OnClick="Update_Click"
                                    runat="Server" /></td>
                        </tr>
                        <tr>
                            <td>&nbsp;</td>
                        </tr>
                        <tr>
                            <td colspan="5" align="center">
                                <asp:LinkButton
                                    Text="  Return to Search  "
                                    OnClick="Return_Click"
                                    runat="Server" />
                                &nbsp; &nbsp; &nbsp;
            <asp:LinkButton
                Text="Return to Menu"
                OnClick="Home_Click"
                runat="Server" />
                            </td>
                        </tr>
                    </table>
                </form>

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
