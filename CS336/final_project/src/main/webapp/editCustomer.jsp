<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Customer</title>
</head>
<body>

	<h2>Edit Customer</h2>	

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	

			//Create a SQL statement
			PreparedStatement getCust = con.prepareStatement("SELECT * FROM customer WHERE custUsername=?");
			getCust.setString(1, request.getParameter("editCustomerUsername"));
			ResultSet result = getCust.executeQuery();
			
			if(!result.next()){
				response.sendRedirect("admin.jsp");
			} else{
				request.setAttribute("custUser", result.getString("custUsername"));
				request.setAttribute("custPass", result.getString("custPassword"));
			}
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
	

	<form method="get" action="editCustomerMake.jsp">
			<table>
					<tr>    
						<td>New  Username:</td><td><input type="text" name="changeCustUser" value=<%=request.getAttribute("custUser")%>></td>
					</tr>
					<tr>    
						<td>New Password:</td><td><input type="text" name="changeCustPass" value=<%=request.getAttribute("custPass")%>></td>
					</tr>
			</table>
            <input type="submit" value="Edit Customer Info">
        </form>
        
        <form method="get" action="admin.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>