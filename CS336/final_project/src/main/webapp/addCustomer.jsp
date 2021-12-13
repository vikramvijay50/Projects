<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.text.*,java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Add New Customer</title>
	</head>
	<body>	
	<%
	try{
		String custUser = request.getParameter("addCustomerUsername");
		String custPass = request.getParameter("addCustomerPass");
		
		if(custUser == "" || custPass == ""){
			out.println("Please enter values for all the necessary fields.");
		} else{
			ApplicationDB database = new ApplicationDB();	
			Connection connection = database.getConnection();
			
			PreparedStatement addAircraft = connection.prepareStatement("INSERT INTO customer VALUES (?,?)");
			addAircraft.setString(1, custUser);
			addAircraft.setString(2, custPass);
			addAircraft.executeUpdate();
			
			%><h4>New Customer Details:</h4><%
			out.println("Username: " + custUser);
			%><br><%
			out.println("Password: " + custPass);
			database.closeConnection(connection);	
		}
	} catch (Exception e) {
		out.print(e);
	}
	%>
	
	<br><br>
		<form method="get" action="admin.jsp">
            <input type="submit" value="Go Back">
        </form>
</body>
</html>