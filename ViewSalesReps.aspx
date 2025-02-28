<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <title>Website Maintenance</title>

    <%@ Import Namespace="IBM.Data.DB2.iseries" %>
    <%@ Import Namespace="System.Data" %>
    <%@ Import Namespace="System.Web.Mail" %>

    <script runat="Server">
        Public strSortField As String

        Sub Page_Load()

            lblBranch.Text = Session("SLSREPBIO_BRANCH")
            strSortField = Session("sortField")

            If Not IsPostBack Then
                Session("sortField") = "SLSREPNO"
                strSortField = Session("sortField")
                GetReps()
            End If

        End Sub

        Sub GetReps()

            Dim con = New iDB2Connection(ConfigurationManager.AppSettings("ConnString"))
            con.Open()

            Dim strSql = "Select * from SLSREPBIO where  SLSBRANCH Like ('%" & lblBranch.Text & "%')" + "  Order by " + strSortField
            Dim dataSelect = New iDB2DataAdapter(strSql, con)

            Dim dstSelect = New DataSet
            dataSelect.Fill(dstSelect)

            dgrdsalesrep.DataSource = dstSelect
            dgrdsalesrep.DataBind()

            con.Close()

        End Sub

        Sub dgrdsalesrep_PageIndexChanged(s As Object, e As DataGridPageChangedEventArgs)
            dgrdsalesrep.CurrentPageIndex = e.NewPageIndex
            GetReps()
        End Sub

        Sub dgrdsalesrep_SortCommand(s As Object, e As DataGridSortCommandEventArgs)
            Session("sortField") = e.SortExpression
            strSortField = Session("sortField")
            GetReps()
        End Sub

        Sub dgrdsalesrep_ItemDataBound(s As Object, e As DataGridItemEventArgs)
            If e.Item.ItemType = ListItemType.Item Then
                e.Item.Cells(6).Attributes.Add("onclick", "return confirm('Are you sure you want to delete?');")
            End If
        End Sub


        Sub dgrdsalesrep_ItemCommand(s As Object, e As DataGridCommandEventArgs)

            If e.CommandName = "Delete" Then
                Dim deletecon As New iDB2Connection
                Dim cmdDelete As iDB2Command
                Dim strDelete As String

                'deletecon.ConnectionString = ConfigurationManager.AppSettings("ConnString")
                'deletecon.Open()

                'Dim itemCell As TableCell = e.Item.Cells(0)
                'Dim item As String = itemCell.Text
                'strSls = item


                'strDelete = "Delete from SLSREPBIO Where SLSREPNO=? and SLSBRANCH = '" & strbranch & "' "

                'cmdDelete = New iDB2Command(strDelete, deletecon)
                'cmdDelete.Parameters.Add("@SLSREPNO", CInt(strSls))

                'cmdDelete.ExecuteNonQuery()
                'deletecon.Close()

                ''Redirect back to menu
                'Response.Redirect("SalesRepMenu.aspx?branch=" + strbranch)
            End If
        End Sub

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

                <p align="center"><strong>BRANCH STAFFS LIST</strong></p>
                <div>
                    <center>
                        <form runat="Server">
                            <asp:DataGrid
                                ID="dgrdsalesrep"
                                AllowSorting="True"
                                OnSortCommand="dgrdsalesrep_SortCommand"
                                OnItemCommand="dgrdsalesrep_ItemCommand"
                                OnItemDataBound="dgrdsalesrep_ItemDataBound"
                                AllowPaging="true"
                                PagerStyle-Position="Bottom"
                                PagerStyle-Mode="NumericPages"
                                PagerStyle-BackColor="#CCCCCC"
                                PagerStyle-HorizontalAlign="Center"
                                Font-Size="10pt"
                                AutoGenerateColumns="False"
                                CellPadding="2"
                                PageSize="20"
                                OnPageIndexChanged="dgrdsalesrep_PageIndexChanged"
                                AlternatingItemStyle-BackColor="#CCCCCC"
                                runat="Server">

                                <HeaderStyle BackColor="#CCCCCC" HorizontalAlign="Center" Font-Bold="True"></HeaderStyle>
                                <Columns>

                                    <asp:HyperLinkColumn
                                        DataNavigateUrlField="slsrepno"
                                        HeaderText="Emp #"
                                        DataNavigateUrlFormatString="UpdateSlsRep.aspx?slsrepno={0}"
                                        DataTextField="SLSREPNO" />
                                    <asp:BoundColumn
                                        HeaderText="Branch"
                                        DataField="SLSBRANCH"
                                        SortExpression="slsbranch" />
                                    <asp:BoundColumn
                                        HeaderText="First Name"
                                        DataField="SLSFNAME"
                                        SortExpression="slsfname" />
                                    <asp:BoundColumn
                                        HeaderText="Last Name"
                                        DataField="SLSLNAME"
                                        SortExpression="slslname" />
                                    <asp:BoundColumn
                                        HeaderText="E-Mail"
                                        DataField="SLSEMAIL"
                                        SortExpression="SLSEMAIL" />
                                    <asp:BoundColumn
                                        HeaderText="Phone"
                                        DataField="SLSPHONE"
                                        SortExpression="SLSPHONE" />
                                    <asp:ButtonColumn
                                        HeaderText="Action"
                                        CommandName="Delete"
                                        Text="DELETE!" />
                                </Columns>

                            </asp:DataGrid>
                            <table width="825" border="0" bordercolor="#FFFFFF" bgcolor="#FFFFFF" height="50">
                                <tr style="line-height: 30px">
                                    <td colspan="3" align="center" bgcolor="#FFFFFF">
                                        <asp:Button
                                            Text="Return to Menu"
                                            OnClick="Home_Click"
                                            runat="Server" /></td>
                                </tr>
                            </table>
                            <asp:Label ID="lblBranch" runat="Server" Visible="false" />
                        </form>
                    </center>
                </div>

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
