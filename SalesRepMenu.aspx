<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Website Maintenance</title>

    <%@ Import Namespace="IBM.Data.DB2.iseries" %>
    <%@ Import Namespace="System.Data" %>

    <script runat="Server">
        Public strbranch As String

        Sub Page_Load()

            If Session("SLSREPBIO_USER") Is Nothing Or Session("SLSREPBIO_USRBRANCH") Is Nothing Then
                Response.Redirect("SlsMaintLogin.aspx")
            End If

            If Not IsPostBack Then
                loadBranch()

                Dim allowedJobTitle() As String = {"MGR", "ADMIN", "FIMGR/ADMIN", "ASTMGR"}
                If allowedJobTitle.Contains(Session("SLSREPBIO_USRJOBTL")) Then
                    DropBranch.SelectedValue = Session("SLSREPBIO_BRANCH")
                    Session("SLSREPBIO_BRANCHTEXT") = DropBranch.SelectedItem.Text
                    DropBranch.Enabled = False
                ElseIf Session("SLSREPBIO_USRJOBTL") = "IT" Then
                    DropBranch.SelectedValue = Session("SLSREPBIO_BRANCH")
                    Session("SLSREPBIO_BRANCHTEXT") = DropBranch.SelectedItem.Text
                    DropBranch.Enabled = True
                Else
                    Response.Redirect("SlsMaintLogin.aspx")
                End If

                lblUsername.Text = Session("SLSREPBIO_USRNAME")
            End If

        End Sub

        Sub AddRep(s As Object, e As EventArgs)
            Response.Redirect("AddSlsBio.aspx")
        End Sub
        Sub UpdateRep(s As Object, e As EventArgs)
            Response.Redirect("ViewSalesReps.aspx")
        End Sub
        Sub UpdatePhoto(s As Object, e As EventArgs)
            Response.Redirect("UploadPhoto.aspx")
        End Sub
        Sub ViewAllRep(s As Object, e As EventArgs)
            Response.Redirect("ViewAllReps.aspx")
        End Sub

        Sub btnLogoff_click(s As Object, e As EventArgs)
            Response.Redirect("SlsMaintLogin.aspx")
        End Sub

        Sub DropBranch_Changed(s As Object, e As EventArgs)
            Session("SLSREPBIO_BRANCH") = DropBranch.SelectedValue
            Session("SLSREPBIO_BRANCHTEXT") = DropBranch.SelectedItem.Text
        End Sub


        Sub loadBranch()
            Dim con As New iDB2Connection
            con.ConnectionString = ConfigurationManager.AppSettings("ConnString")
            con.Open()

            Dim sql = "Select b.* from BRANCH b Join BRANCH800 b8 on b.BRNBRNID = b8.BRANCH Where b8.ACTIVE = 'Y' Order By BRNBRNID  "
            Dim cmd = New iDB2Command(sql, con)
            Dim dbReader = cmd.ExecuteReader()

            While dbReader.Read()
                DropBranch.Items.Add(New ListItem(dbReader("BRNNAME").Trim(), dbReader("BRNBRNID").Trim()))
            End While

            dbReader.Close()
            con.Close()
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
    </style>
</head>

<body>
    <table width="800" border="0" align="center">
        <tr>
            <td valign="top">
                <table width="799" border="0">
                    <tr>
                        <td align="left" width="30%">
                            <img src="Images/arrowlogoweb.GIF" alt="Arrow Truck Sales ">
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
                        <table width="799" height="50" border="0" style="margin-bottom: 20px;">
                            <tr>
                                <td align="center">
                                    <h2>Branch Bio System </h2>
                                </td>
                            </tr>
                            <tr>
                                <td align="center">Hello, 
                                    <asp:Label ID="lblUsername" runat="Server" Style="margin-right: 20px; font-size: small" />
                                    <asp:Button ID="btnLogoff" runat="Server" Text="Log off" OnClick="btnLogoff_click" />
                                </td>
                            </tr>

                            <tr>
                                <td align="center" style="line-height: 30px; font-size: medium; padding-top: 10px;">
                                    <span style="margin-right: 20px;"><b>Branch</b></span>
                                    <asp:DropDownList ID="DropBranch" runat="server" OnSelectedIndexChanged="DropBranch_Changed" AutoPostBack="true" Style="width: 200px;" />
                                </td>
                            </tr>
                            <tr>
                                <td align="center">
                                    <br>
                                    <span style="font-size: 12px; color: #06C;">Note: please add the staffs of your branch to this system and keep it current.
                                        <br>
                                        The staffs listed here will be shown out at the branch location page.</span><br>
                                    <br>
                                    <asp:Button
                                        Text="Add Staff" Width="200"
                                        OnClick="AddRep"
                                        runat="server" />
                                    <br>
                                    <br>
                                    <asp:Button
                                        Text="View/Update Staffs" Width="200"
                                        OnClick="UpdateRep"
                                        runat="server" />
                                    <br>
                                    <br>
                                    <asp:Button
                                        Text="Upload Photo" Width="200"
                                        OnClick="UpdatePhoto"
                                        runat="server" />
                                    <br>
                                    <br>
                                    <asp:Button
                                        Text="View All Branch Staffs" Width="200"
                                        OnClick="ViewAllRep"
                                        runat="server" />
                                    <br>
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
