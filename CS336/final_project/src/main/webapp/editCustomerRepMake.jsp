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

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			String newUser = request.getParameter("changeUser");
			String newPass = request.getParameter("changePass");

			PreparedStatement editRep = con.prepareStatement("UPDATE customer_rep SET cUsername=?, cPassword=? WHERE cUsername=?");
			editRep.setString(1, newUser);
			editRep.setString(2, newPass);
			editRep.setString(3, newUser);
			editRep.executeUpdate();
			
			%><h4>Customer Rep Details:</h4><%
			out.println("Rep New Username: " + newUser);
			%><br><%
			out.println("Rep New Password: " + newPass);
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
        
        <form method="get" action="admin.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>