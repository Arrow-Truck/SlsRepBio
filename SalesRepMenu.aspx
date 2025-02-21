<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
"http://www.w3.org/TR/html4/loose.dtd">
<html><!-- InstanceBegin template="../Templates/main.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
    <!-- InstanceBeginEditable name="doctitle" -->
<title>SalesRepMenu</title>
<!- ******************************************************************* ->
<!- * File: SalesRepMenu.aspx                                         * ->
<!- *                                                                 * ->
<!- * Purpose: System Menu                                         * ->
<!- *                                                                 * ->
<!- * Written by: Clifton Davis 12.23.2005                            * ->
<!- *                                                                 * ->
<!- ******************************************************************* -> 

<%@ Import NameSpace="IBM.Data.DB2.iseries" %>
<%@ Import NameSpace="System.Data" %>
<%@ Import NameSpace="System.Web.Mail" %>
<!- ******************************************************************* ->
<!- *                      Define Script                              * ->
<!- ******************************************************************* -> 
<Script Runat="Server">
Public strbranch As String

    Sub Page_Load()
	    'Get the branch ID.
        strbranch = Request.QueryString("branch")
        lblBranch.Text = strbranch
        txtRepID.Text = Request.QueryString("branch")
	
        If Not IsPostBack Then
            Session("branch") = strbranch
        End If
	
    End Sub

    Sub AddRep(s As Object, e As EventArgs)
        Response.Redirect("AddSlsBio.aspx?branch=" + lblBranch.Text)
    End Sub
    Sub UpdateRep(s As Object, e As EventArgs)
        Response.Redirect("ViewSalesReps.aspx?branch=" + lblBranch.Text)
    End Sub
    Sub ViewAllReps(s As Object, e As EventArgs)
        ' Response.Redirect( "ViewAllReps.aspx" )
    End Sub
    Sub ViewEmail(s As Object, e As EventArgs)
        Response.Redirect("ViewRepEmailAddrBR.aspx?branch=" + lblBranch.Text)
    End Sub
    Sub UpdatePhoto(s As Object, e As EventArgs)
        Response.Redirect("UploadPhoto.aspx?branch=" + lblBranch.Text)
    End Sub
    Sub DeleteRep(s As Object, e As EventArgs)
        Response.Redirect("DeleteReps.aspx?branch=" + lblBranch.Text)
    End Sub
    Sub PhotoUpload(s As Object, e As EventArgs)
        Response.Redirect("TruckImageUpload.aspx?branch=" + lblBranch.Text)
    End Sub
    
</script>
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
    <center><form runat="Server">
   <table width="799" height="50" border="0">
       <tr>
           <td align="center"><h2>
               <asp:Label
              ID="lblBranch"
			  Text=""
			  runat="server" /> Branch Bio System </h2>
           </td>
  	   </tr>
            <tr>
              <td align="center">
              <br>
                <span style="font-size:12px; color:#06C;">Note: please add the staffs of your branch to this system and keep it current. <br>
                The staffs listed here will be shown out at the branch location page.</span><br>
                <br>
                <asp:Button
                   Text="Add Staff" Width="200" 
                   OnClick="AddRep"
                   runat="server"/>
                <br>
                <br>
                <asp:Button
                   Text="Update Staffs" Width="200" 
                   OnClick="UpdateRep"
                   runat="server"/>                              
                <br>
                <br>
				<asp:Button
                   Text="Branch Email List" Width="200" 
                   OnClick="ViewEmail"
                   runat="server"/>                              
                <br>
                <br>
				<asp:Button
                   Text="Upload Photo" Width="200" 
                   OnClick="UpdatePhoto"
                   runat="server"/>                              
              	<br>
              	<br>
			  	<asp:Button
                   Text="Delete Staff" Width="200" 
                   OnClick="DeleteRep"
                   runat="server"/>
                   
              </td>
            </tr>
            
            <tr>
              <td align="center">&nbsp;</td>
            </tr>
            
            <tr>
              <td align="center"><asp:Label
                      ID="lblupload"
					  Visible="false"
					  Font-Name="Helvetica"
					  ForeColor="#FF0000"
					  Text="UPLOAD TRUCK PHOTOS."
                      runat="Server" /></td>
            </tr>
            <tr>
              <td align="center"><asp:Button
                   Text="Upload Truck Photos" Width="200" 
                   OnClick="PhotoUpload"
				   Visible="false"
                   runat="server"/> 
              <asp:TextBox
                       ID="txtRepID"
					   Visible="false"
                       Columns="5"
                        runat="Server" /></td>
            </tr>
	</table>		
   
		
	</form></center>		
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
