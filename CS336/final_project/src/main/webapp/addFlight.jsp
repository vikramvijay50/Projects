<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.text.*,java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Add Flight</title>
	</head>
	<body>	
	<%
	try{
		int fNum = Integer.parseInt(request.getParameter("flightNum").toString());
		String depAirport = request.getParameter("depAirport");
		String destAirport = request.getParameter("destAirport");
		String depTime = request.getParameter("depTime");
		String arrivalTime = request.getParameter("arrivalTime");
		int duration = Integer.parseInt(request.getParameter("duration").toString());
		String price = request.getParameter("price");
		int stops = Integer.parseInt(request.getParameter("stops").toString());
		String airline = request.getParameter("airline");
		String type = request.getParameter("type");
		int numSeats = Integer.parseInt(request.getParameter("numSeats").toString());
		
		ApplicationDB database = new ApplicationDB();	
		Connection connection = database.getConnection();
		
		PreparedStatement addFlight = connection.prepareStatement("INSERT INTO flight VALUES (?,?,?,?,?,?,?,?,?,?,?,?)");
		addFlight.setInt(1, fNum);
		addFlight.setString(5, depAirport);
		addFlight.setString(4, destAirport);
		addFlight.setString(3, depTime);
		addFlight.setString(2, arrivalTime);
		addFlight.setInt(6, duration);
		addFlight.setString(7, price);
		addFlight.setInt(8, stops);
		addFlight.setString(9, airline);
		if(type.equals("Domestic") || type.equals("domestic")){
			addFlight.setBoolean(10, true);
			addFlight.setBoolean(11, false);
		} else{
			addFlight.setBoolean(10, false);
			addFlight.setBoolean(11, true);
		}
		addFlight.setInt(12, numSeats);
		addFlight.executeUpdate();
			
		%><h4>New Flight Details:</h4><%
		out.println("Flight Number: " + fNum);
		%><br><%
		out.println("Departure Airport: " + depAirport);
		%><br><%
		out.println("Destination Airport: " + destAirport);
		%><br><%
		out.println("Departure Time: " + depTime);
		%><br><%
		out.println("Arrival Time: " + arrivalTime);
		%><br><%
		out.println("Flight Duration: " + duration);
		%><br><%
		out.println("Price: " + price);
		%><br><%
		out.println("Number of Stops: " + stops);
		%><br><%
		out.println("Airline: " + airline);
		%><br><%
		out.println("Domestic or International: " + type);
		%><br><%
		out.println("Number of Seats: " + numSeats);
		
		database.closeConnection(connection);	

	} catch (Exception e) {
		out.print(e);
	}
	%>
	
	<br><br>
		<form method="get" action="changeFlight.jsp">
            <input type="submit" value="Go Back">
        </form>
</body>
</html>