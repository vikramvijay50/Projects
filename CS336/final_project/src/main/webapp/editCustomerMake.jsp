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

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			String newUser = request.getParameter("changeCustUser");
			String newPass = request.getParameter("changeCustPass");

			PreparedStatement editCustomer = con.prepareStatement("UPDATE customer SET custUsername=?, custPassword=? WHERE custUsername=?");
			editCustomer.setString(1, newUser);
			editCustomer.setString(2, newPass);
			editCustomer.setString(3, newUser);
			editCustomer.executeUpdate();
			
			%><h4>Customer Details:</h4><%
			out.println("Customer New Username: " + newUser);
			%><br><%
			out.println("Customer New Password: " + newPass);
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
        
        <form method="get" action="admin.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>