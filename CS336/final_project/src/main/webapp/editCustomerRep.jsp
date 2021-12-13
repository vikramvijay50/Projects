<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Customer Rep</title>
</head>
<body>

	<h2>Edit Customer Rep</h2>	

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	

			//Create a SQL statement
			PreparedStatement getRep = con.prepareStatement("SELECT * FROM customer_rep WHERE cUsername=?");
			getRep.setString(1, request.getParameter("editRepUsername"));
			ResultSet result = getRep.executeQuery();
			
			if(!result.next()){
				response.sendRedirect("admin.jsp");
			} else{
				request.setAttribute("repUser", result.getString("cUsername"));
				request.setAttribute("repPass", result.getString("cPassword"));
			}
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
	

	<form method="get" action="editCustomerRepMake.jsp">
			<table>
					<tr>    
						<td>New Username:</td><td><input type="text" name="changeUser" value=<%=request.getAttribute("repUser")%>></td>
					</tr>
					<tr>    
						<td>New Password:</td><td><input type="text" name="changePass" value=<%=request.getAttribute("repPass")%>></td>
					</tr>
			</table>
            <input type="submit" value="Edit Rep Info">
        </form>
        
        <form method="get" action="admin.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>