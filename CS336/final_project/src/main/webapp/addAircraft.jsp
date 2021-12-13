<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.text.*,java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Add Aircraft</title>
	</head>
	<body>	
	<%
	try{
		String aircraftName = request.getParameter("aircraftNum");
		String numSeats = request.getParameter("aircraftSeats");
		String days = request.getParameter("aircraftDays");
		
		if(aircraftName == "" || numSeats == "" || days == ""){
			out.println("Please enter values for all the necessary fields.");
		} else{
			ApplicationDB database = new ApplicationDB();	
			Connection connection = database.getConnection();
			
			PreparedStatement addAircraft = connection.prepareStatement("INSERT INTO aircrafts VALUES (?,?,?)");
			addAircraft.setString(1, aircraftName);
			addAircraft.setString(2, numSeats);
			addAircraft.setString(3, days);
			addAircraft.executeUpdate();
			
			%><h4>Aircraft Details:</h4><%
			out.println("Aircraft Number: " + aircraftName);
			%><br><%
			out.println("Number of Seats: " + numSeats);
			%><br><%
			out.println("Days Operated: " + days);	
			database.closeConnection(connection);	
		}
	} catch (Exception e) {
		out.print(e);
	}
	%>
	
	<br><br>
		<form method="get" action="changeAircraft.jsp">
            <input type="submit" value="Go Back">
        </form>
</body>
</html>