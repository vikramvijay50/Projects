<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.text.*,java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Add New Customer Rep</title>
	</head>
	<body>	
	<%
	try{
		String repUser = request.getParameter("addRepUsername");
		String repPass = request.getParameter("addRepPass");
		
		if(repUser == "" || repPass == ""){
			out.println("Please enter values for all the necessary fields.");
		} else{
			ApplicationDB database = new ApplicationDB();	
			Connection connection = database.getConnection();
			
			PreparedStatement addAircraft = connection.prepareStatement("INSERT INTO customer_rep VALUES (?,?)");
			addAircraft.setString(1, repUser);
			addAircraft.setString(2, repPass);
			addAircraft.executeUpdate();
			
			%><h4>New Customer Rep Details:</h4><%
			out.println("Username: " + repUser);
			%><br><%
			out.println("Password: " + repPass);
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