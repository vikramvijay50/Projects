<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.text.*,java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Add Airport</title>
	</head>
	<body>	
	<%
	try{
		String airportName = request.getParameter("airportName");
		String airportAircrafts = request.getParameter("airportAircrafts");
		
		if(airportName == "" || airportAircrafts == ""){
			out.println("Please enter values for all the necessary fields.");
		} else{
			ApplicationDB database = new ApplicationDB();	
			Connection connection = database.getConnection();
			
			PreparedStatement addAirport = connection.prepareStatement("INSERT INTO airports VALUES (?,?)");
			addAirport.setString(1, airportName);
			addAirport.setString(2, airportAircrafts);
			addAirport.executeUpdate();
			
			%><h4>Aircraft Details:</h4><%
			out.println("Aircraft Number: " + airportName);
			%><br><%
			out.println("Number of Seats: " + airportAircrafts);
			database.closeConnection(connection);	
		}
	} catch (Exception e) {
		out.print(e);
	}
	%>
	
	<br><br>
		<form method="get" action="changeAirport.jsp">
            <input type="submit" value="Go Back">
        </form>
</body>
</html>