<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Flight</title>
</head>
<body>

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			int fNum = Integer.parseInt(request.getParameter("changeflightNum").toString());
			String depAirport = request.getParameter("changedepAirport");
			String destAirport = request.getParameter("changedestAirport");
			String depTime = request.getParameter("changedepTime");
			String arrivalTime = request.getParameter("changearrivalTime");
			int duration = Integer.parseInt(request.getParameter("changeduration").toString());
			String price = request.getParameter("changeprice");
			int stops = Integer.parseInt(request.getParameter("changestops").toString());
			String airline = request.getParameter("changeairline");
			String type = request.getParameter("changetype");
			int numSeats = Integer.parseInt(request.getParameter("changenumSeats").toString());

			PreparedStatement editFlight = con.prepareStatement("UPDATE flight SET Fnum=?, arrival_time=?, depart_time=?, dest_airport=?, depart_airport=?, duration=?, price=?, numStops=?, airline=?, isDomestic=?, isInternational=?, numSeats=? WHERE Fnum=?");
			editFlight.setInt(1, fNum);
			editFlight.setString(5, depAirport);
			editFlight.setString(4, destAirport);
			editFlight.setString(3, depTime);
			editFlight.setString(2, arrivalTime);
			editFlight.setInt(6, duration);
			editFlight.setString(7, price);
			editFlight.setInt(8, stops);
			editFlight.setString(9, airline);
			if(type.equals("Domestic") || type.equals("domestic")){
				editFlight.setBoolean(10, true);
				editFlight.setBoolean(11, false);
			} else{
				editFlight.setBoolean(10, false);
				editFlight.setBoolean(11, true);
			}
			editFlight.setInt(12, numSeats);
			editFlight.setInt(13, fNum);
			editFlight.executeUpdate();
			
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
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
        
        <form method="get" action="changeFlight.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>