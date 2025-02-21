<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html><!-- InstanceBegin template="../Templates/main.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!-- InstanceBeginEditable name="doctitle" -->
<title>AddSalesRep</title>
<!- ******************************************************************* ->
<!- * File: AddSlsBio.aspx                                            * ->
<!- *                                                                 * ->
<!- * Purpose: Add new STAFF                                      * ->
<!- *                                                                 * ->
<!- * Written by: Clifton Davis 12.19.2005                            * ->
<!- *                                                                 * ->
<!- ******************************************************************* -> 

<%@ Import NameSpace="IBM.Data.DB2.iseries" %>
<%@ Import NameSpace="System.Data" %>
<%@ Import NameSpace="System.Web.Mail" %>
<!- ******************************************************************* ->
<!- *                      Define Script                              * ->
<!- ******************************************************************* -> 
<Script Runat="Server">
    Public strBrAbv As String = ""
    Public strbranch As String = ""

    Sub Page_Load()
        'Get branch
        strbranch = UCase(Request.QueryString("branch"))
        lblBranch.Text = strbranch

        If Not IsPostBack Then
            LoadBranches()
            LoadLanguages()
            'Set branch selection
            If strbranch <> "" Then
                'lblBranch.Text =  DropBranch.SelectedItem.Text.trim()
                'dropBranch.Items.FindByValue(strbranch).Selected = True		'Have problem with this.
                'DropBranch.SelectedItem.Text = strbranch
                DropBranch.SelectedValue = strbranch        'Note: Can't use SelectedItem.Value, need to use SelectedValue!!
            End If

            'Link back to menu
            lbMenu.NavigateUrl = "SalesRepMenu.aspx?branch=" + lblBranch.Text
        End If

    End Sub

    Sub LoadBranches()
        Dim con As New iDB2Connection
        Dim dtrBranch As iDB2DataReader
        Dim dadBranch As iDB2DataAdapter
        Dim dstBranch As DataSet

        con = New iDB2Connection(ConfigurationSettings.AppSettings("ConnString"))
        con.Open()

        dstBranch = New DataSet

        dadBranch = New iDB2DataAdapter("Select BRNBRNID, BRNNAME from AIS2000D.BRANCH Order by BRNBRNID", con)

        dadBranch.Fill(dstBranch)
        dropBranch.DataSource = dstBranch

        'dropBranch.DataTextField="BRNBRNID"
        'dropBranch.DataValueField="BRNNAME" 
        dropBranch.DataTextField = "BRNNAME"
        dropBranch.DataValueField = "BRNBRNID"
        dropBranch.DataBind()

        con.Close()
    End Sub

    Sub Add_Click(s As Object, e As EventArgs)
        'Emp ID should be numbers.
        txtRepID.Text = Trim(txtRepID.Text)
        If IsNumeric(txtRepID.Text) = False Then
            lblrequest.Text = "Invalid Emp ID. Numbers only."
            txtRepID.Focus()
            Exit Sub
        End If

        'txtPhone 
        txtPhone.Text = Trim(txtPhone.Text)
        If Trim(txtPhone.Text) <> "" Then
            If IsNumeric(txtPhone.Text) = False Or Len(txtPhone.Text) <> 10 Then
                lblrequest.Text = "Invalid Phone Number. Please enter 10 digits phone number."
                txtPhone.Focus()
                Exit Sub
            End If
        End If

        'Add data to database
        InsertData()

    End Sub

    Sub Return_Click(s As Object, e As EventArgs)
        'Request.QueryString( "branch" ) = lblBranch.Text 

        Session("branch") = lblBranch.Text
        If lblBranch.Text = "IM" Then
            Response.Redirect("../IMMaint/SalesRepMenu2.aspx?branch=" + lblBranch.Text)
        Else
            Response.Redirect("SlsRepBio/SalesRepMenu.aspx?branch=" + lblBranch.Text)
        End If
    End Sub

    'Sub Language_Click( s As Object, e As EventArgs ) 
    '    Response.Redirect( "Languages.aspx?slsno=" + txtRepID.Text + "&fname=" + txtFirstName.Text.ToUpper().trim() + "&lname=" + txtLastName.Text.ToUpper().trim() + "&branch=" + DropBranch.SelectedItem.Value.trim())
    'End Sub

    Sub InsertData()
        Dim con As New iDB2Connection
        Dim cmdInsert As iDB2Command
        Dim strInsert As String
        Dim dtrAccount As iDB2DataReader

        lblBranch.Text = DropBranch.SelectedValue

        con.ConnectionString = ConfigurationSettings.AppSettings("ConnString")
        con.Open()

        strInsert = "Insert into AIS2000D.SLSREPBIO (" + _
      "SLSREPNO,SLSREPBR,SLSBRANCH,SLSFNAME,SLSLNAME,SLSEMAIL,SLSPHONE,SLSBIO,SLSLANG1,SLSLANG2,SLSLANG3,SLSLANG4,SLSLANG5,SLSLANG6,SLSLANG7,SLSLANG8)" + _
       " values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"

        ''Escape single quotes and special characters in SQL query
        'txtRepBio.Text = Trim(txtRepBio.Text).Replace("’", "'")
        'txtRepBio.Text = txtRepBio.Text.Replace("‘", "'")
        ''txtRepBio.Text = txtRepBio.Text.Replace("'", "''")

        'Need to replace some special characters at the fields. Such as &#8216;a&#8217;, it&#8217;s, &#8220;A&#8221;, &#8211; to -, "" etc. Chr(39) is ', Chr(34) is ". 
        '.Replace("'", Chr(39)).Replace("&#8217;", Chr(39)).Replace("&#8216;", Chr(39)).Replace(Chr(147), Chr(34)).Replace(Chr(148), Chr(34))
        Dim strRepBio As String = Trim(txtRepBio.Text).Replace("'", Chr(39)).Replace("&#8217;", Chr(39)).Replace("&#8216;", Chr(39)).Replace(Chr(147), Chr(34)).Replace(Chr(148), Chr(34)).Replace("&#8211;", "-")

        cmdInsert = New iDB2Command(strInsert, con)
        cmdInsert.Parameters.Add("@SLSREPNO", txtRepID.Text.Trim())
        cmdInsert.Parameters.Add("@SLSREPBR", DropBranch.SelectedItem.Text.trim())
        cmdInsert.Parameters.Add("@SLSBRANCH", lblBranch.Text)
        cmdInsert.Parameters.Add("@SLSFNAME", txtFirstName.Text.ToUpper().trim())
        cmdInsert.Parameters.Add("@SLSLNAME", txtLastName.Text.ToUpper().trim())
        cmdInsert.Parameters.Add("@SLSEMAIL", txtEmail.Text.ToUpper().trim())
        cmdInsert.Parameters.Add("@SLSPHONE", Trim(txtPhone.Text))
        cmdInsert.Parameters.Add("@SLSBIO", strRepBio)
        cmdInsert.Parameters.Add("@SLSLANG1", DropLang1.SelectedItem.Text)
        cmdInsert.Parameters.Add("@SLSLANG2", DropLang2.SelectedItem.Text)
        cmdInsert.Parameters.Add("@SLSLANG3", DropLang3.SelectedItem.Text)
        cmdInsert.Parameters.Add("@SLSLANG4", DropLang4.SelectedItem.Text)
        cmdInsert.Parameters.Add("@SLSLANG5", DropLang5.SelectedItem.Text)
        cmdInsert.Parameters.Add("@SLSLANG6", DropLang6.SelectedItem.Text)
        cmdInsert.Parameters.Add("@SLSLANG7", DropLang7.SelectedItem.Text)
        cmdInsert.Parameters.Add("@SLSLANG8", DropLang8.SelectedItem.Text)

        cmdInsert.ExecuteNonQuery()
        con.Close()

        lblrequest.Text = "STAFF HAS BEEN ADDED!"

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
        Response.Redirect("SalesRepMenu.aspx?branch=" + lblBranch.Text)
    End Sub

</script>

<!-- InstanceEndEditable -->
<!-- InstanceBeginEditable name="head" --><!-- InstanceEndEditable -->
<style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
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
    .auto-style1 {
        width: 125px;
    }
    .auto-style2 {
        width: 113px;
    }
    .auto-style3 {
        width: 233px;
    }
-->
</style></head>

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
<p align="center"><strong> ADD NEW STAFF </strong></p>

	 <form runat="Server">
	  <table width="789" border="0" bordercolor="#E7DFE7">
        <tr>
          <td colspan="2" align="center"><asp:Label
              ID="lblrequest"
			  ForeColor="Red"
              runat="Server" />
            </td>
          </tr>
        <tr>
          <td width="129">Emp ID:</td>
          <td width="642"><asp:TextBox
                       ID="txtRepID"
                       Columns="15"
                        runat="server" MaxLength="7" Rows="2" />
          <asp:RequiredFieldValidator
                        ControlToValidate="txtRepID"
                        Text="Required!" ForeColor="Red" 
                        Display="Dynamic"
                        runat="Server" />
          <SPAN id="lbl92"> (Numbers Only. Example: 1234)</SPAN></td>
        </tr>
        <tr>
          <td width="129">Branch:</td>
          <td><asp:DropDownList
                 ID="DropBranch"
                 runat="server" />&nbsp;<asp:Label
              ID="lblBranch"
			  Visible="False"
			  Text=""
			  runat="server" /></td>
        </tr>
        <tr>
          <td width="129">First Name:</td>
          <td><asp:TextBox
                       ID="txtFirstName"
                       Columns="35"
                        runat="server" />    
						<asp:RequiredFieldValidator
                        ControlToValidate="txtFirstName"
                        Text="Required!" ForeColor="Red" 
                        Display="Dynamic"
                        runat="Server" /></td>
        </tr>
        <tr>
          <td width="129">Last Name:</td>
          <td><asp:TextBox
                       ID="txtLastName"
                       Columns="35"
                        runat="server" />
						<asp:RequiredFieldValidator
                        ControlToValidate="txtLastName"
                        Text="Required!" ForeColor="Red" 
                        Display="Dynamic"
                        runat="Server" /></td>
        </tr>
        <tr>
          <td width="129">Email:</td>
          <td><asp:TextBox
                       ID="txtEmail"
                       Columns="35"
                        runat="Server" />
						<asp:RequiredFieldValidator
                        ControlToValidate="txtEmail"
                        Text="Required!" ForeColor="Red" 
                        Display="Dynamic"
                        runat="Server" />						</td>
        </tr>
          <tr>
          <td valign="top">Phone:</td>
          <td valign="top"><asp:TextBox
                       ID="txtPhone"
                       Columns="35"
                        runat="Server" MaxLength="10" />
						&nbsp;(10 digits. E.g. 8166274900)</td>
          </tr>
        <tr>
          <td valign="top">Rep Bio:</td>
          <td valign="top"><asp:TextBox
                       ID="txtRepBio"
					   MaxLength="800"
                       Columns="75"
                       runat="server" Wrap="true" TextMode="MultiLine" Rows="8"/></td>
        </tr>
      </table>
	  <table width="789" border="0" bordercolor="#E7DFE7">
	  <tr>
	  <td width="131"></td>
	  <td class="auto-style2"><asp:Label
              ID="lbl4l"
			  ForeColor="#000000"
              Text="Language 1:"
              runat="Server" /></td>
	  <td class="auto-style3"><asp:DropDownList
                 ID="DropLang1"
                  Columns="10"
                 runat="server" /></td>
	  <td class="auto-style1"><asp:Label
              ID="lbl8l"
              Text="Language 5:"
              runat="Server" /></td>
	  <td width="247"><asp:DropDownList
                 ID="DropLang5"
                  Columns="10" 
				  runat="server"/></td>
		</tr>
	  <tr>
	  <td width="131"></td>
	  <td class="auto-style2"><asp:Label
              ID="lbl5l"
              Text="Language 2:"
              runat="Server" /></td>
	  <td class="auto-style3"><asp:DropDownList
                 ID="DropLang2"
                  Columns="10"
				  runat="server" /></td>
	  <td class="auto-style1"><asp:Label
              ID="lbl9l"
              Text="Language 6:"
              runat="Server" /></td>
	  <td width="247"><asp:DropDownList
                 ID="DropLang6"
                  Columns="10" 
				  runat="server"/></td>
		</tr>
	  <tr>
	  <td width="131"></td>
	  <td class="auto-style2"><asp:Label
              ID="lbl6l"
              Text="Language 3:"
              runat="Server" /></td>
	  <td class="auto-style3"><asp:DropDownList
                 ID="DropLang3"
                  Columns="10" 
				  runat="server"/></td>
	  <td class="auto-style1"><asp:Label
              ID="lbl10l"
              Text="Language 7:"
              runat="Server" /></td>
	  <td width="247"><asp:DropDownList
                 ID="DropLang7"
                  Columns="10" 
				  runat="server"/></td>
		</tr>
	  <tr>
	  <td width="131"></td>
	  <td class="auto-style2"><asp:Label
              ID="lbl7l"
              Text="Language 4:"
              runat="Server" /></td>
	  <td class="auto-style3"><asp:DropDownList
                 ID="DropLang4"
                  Columns="10" 
				  runat="server"/></td>
	  <td class="auto-style1"><asp:Label
              ID="lbl11l"
              Text="Language 8:"
              runat="Server" /></td>
	  <td width="247"><asp:DropDownList
                 ID="DropLang8"
                  Columns="10" 
				  runat="server"/></td>
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
	  <td width="195"></td>
	  </tr>
        <tr>
          <td align="center"><asp:Button
                   Text="  Add Staff  "
                   OnClick="Add_Click"
                   runat="Server" />
          </td>
        </tr>
        <tr>
          <td align="center"> &nbsp;</td>
          </tr>
        <tr>
          <td align="center"> <asp:HyperLink ID="lbMenu" Text="Return to Menu" runat="server" /> <asp:Button ID="Button1"
                   Text="Return to Menu" Visible="false" 
                   OnClick="Home_Click"
                   runat="Server" />
          </td>
          </tr>
      </table>
	</form> 
	
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
