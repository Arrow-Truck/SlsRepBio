<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Website Maintenance</title>

    <%@ Import Namespace="IBM.Data.DB2.iseries" %>
    <%@ Import Namespace="System.Data" %>
    <%@ Import Namespace="System.Web.Mail" %>

    <script runat="Server">
        Public strid As String
        Public strbranch As String
        Public strpw As String
        Dim validUser As Boolean

        Sub Page_Load()
            Session.Clear()
        End Sub

        Sub Button_Click(s As Object, e As EventArgs)

            Dim con As New iDB2Connection

            validUser = False

            con.ConnectionString = ConfigurationManager.AppSettings("ConnString")
            con.Open()

            Dim sql = "Select * from SYSUSER WHERE usrtdate = 0 AND USRUSER = ? and USRPASWD = ? "

            Dim cmdSelect = New iDB2Command(sql, con)
            cmdSelect.Parameters.Add("@usruser", txtUser.Text.ToUpper().Trim())
            cmdSelect.Parameters.Add("@usrpaswd", txtPswd.Text.ToUpper().Trim())

            Dim dtrAccount = cmdSelect.ExecuteReader()


            If dtrAccount.Read() Then
                Session("SLSREPBIO_USER") = dtrAccount("USRUSER").Trim()
                Session("SLSREPBIO_USRNAME") = dtrAccount("USRNAME").Trim()
                Session("SLSREPBIO_USREMAIL") = dtrAccount("USREMAIL").Trim()
                Session("SLSREPBIO_USRBRANCH") = dtrAccount("USRBRNCH").Trim()
                Session("SLSREPBIO_BRANCH") = dtrAccount("USRBRNCH").Trim()
                Session("SLSREPBIO_USRJOBTL") = dtrAccount("USRJOBTL").Trim()
                validUser = True
            Else
                lblerror.Text = "Invalid UserId or Password."
                lblerror.Visible = True
            End If

            con.Close()

            If validUser Then
                Dim allowedJobTitle() As String = {"MGR", "ADMIN", "FIMGR/ADMIN", "ASTMGR", "IT"}
                If allowedJobTitle.Contains(Session("SLSREPBIO_USRJOBTL")) Then
                    Response.Redirect("SalesRepMenu.aspx")
                Else
                    lblerror.Text = "You are not allowed to access."
                    lblerror.Visible = "true"
                End If
            End If

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

        #tblLogin {
            padding-top:20px;
            padding-bottom:20px;
        }
        #tblLogin tr{
            line-height:30px;
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
                        <table width="800" border="0">
                            <tr>
                                <td align="center">
                                    <asp:Label
                                        ID="lblerror"
                                        Visible="false"
                                        ForeColor="#FF0000"
                                        Text="INVALID USERID OR PASSWORD."
                                        runat="Server" /></td>
                            </tr>
                        </table>
                        <table width="800" border="0">
                            <tr>
                                <td valign="top" bordercolor="#000000">
                                    <table width="200" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#000000">
                                        <tr>
                                            <td>
                                                <table width="400" border="0" align="center" bgcolor="#CCCCCC" id="tblLogin">
                                                    <tr>
                                                        <td height="50" colspan="2" valign="middle">
                                                            <div align="center" style="font-size: 20px;"><b>Branch Bio System Login </b></div>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="106" align="right">User ID:
                                                        </td>
                                                        <td align="left">
                                                            <asp:TextBox
                                                                ID="txtUser"
                                                                runat="server" Width="180px" 
                                                                placeholder="AS400 Username"/>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtUser"
                                                                Text="Required!"
                                                                Display="Dynamic"
                                                                runat="Server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td width="106" align="right">Password:</td>
                                                        <td align="left">
                                                            <asp:TextBox
                                                                ID="txtPswd"
                                                                TextMode="password"
                                                                runat="server" Width="180px" 
                                                                placeholder="SFA Password"/>
                                                            <asp:RequiredFieldValidator
                                                                ControlToValidate="txtPswd"
                                                                Text="Required!"
                                                                Display="Dynamic"
                                                                runat="Server" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="40" colspan="2" valign="middle">
                                                            <div align="center">
                                                                <asp:Button
                                                                    Text="Click Here to Login!"
                                                                    OnClick="Button_Click"
                                                                    runat="Server" />
                                                            </div>
                                                        </td>
                                                    </tr>
                                                </table>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
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
