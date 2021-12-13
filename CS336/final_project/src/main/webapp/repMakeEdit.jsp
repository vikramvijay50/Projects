<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Reservation</title>
</head>
<body>

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			int ticketNum = Integer.parseInt(request.getParameter("changeticketNum").toString());
			String firstName = request.getParameter("changefirstName");
			String lastName = request.getParameter("changelastName");
			String originAirport = request.getParameter("changeoriginAirport");
			String destinationAirport = request.getParameter("changedestinationAirport");
			java.sql.Date departureDate = java.sql.Date.valueOf(request.getParameter("changedepartureDate"));
			String seatNum = request.getParameter("changeseatNum");
			String seatClass = request.getParameter("changeseatClass");

			if(seatClass.equals("First Class")){
				PreparedStatement setTicket = con.prepareStatement("UPDATE flight_ticket SET firstName=?, lastName=?, from_airport=?, to_airport=?, departure=?, seatNum=?, isFirstClass=true, isBusiClass=false, isEconClass=false WHERE Ftknum=?");
				setTicket.setString(1, firstName);
				setTicket.setString(2, lastName);
				setTicket.setString(3, originAirport);
				setTicket.setString(4, destinationAirport);
				setTicket.setDate(5, departureDate);
				setTicket.setString(6, seatNum);
				setTicket.setInt(7, ticketNum);
				setTicket.executeUpdate();
			} else if(seatClass.equals("Business")){
				PreparedStatement setTicket = con.prepareStatement("UPDATE flight_ticket SET firstName=?, lastName=?, from_airport=?, to_airport=?, departure=?, seatNum=?, isFirstClass=false, isBusiClass=true, isEconClass=false WHERE Ftknum=?");
				setTicket.setString(1, firstName);
				setTicket.setString(2, lastName);
				setTicket.setString(3, originAirport);
				setTicket.setString(4, destinationAirport);
				setTicket.setDate(5, departureDate);
				setTicket.setString(6, seatNum);
				setTicket.setInt(7, ticketNum);
				setTicket.executeUpdate();
			} else{
				PreparedStatement setTicket = con.prepareStatement("UPDATE flight_ticket SET firstName=?, lastName=?, from_airport=?, to_airport=?, departure=?, seatNum=?, isFirstClass=false, isBusiClass=false, isEconClass=true WHERE Ftknum=?");
				setTicket.setString(1, firstName);
				setTicket.setString(2, lastName);
				setTicket.setString(3, originAirport);
				setTicket.setString(4, destinationAirport);
				setTicket.setDate(5, departureDate);
				setTicket.setString(6, seatNum);
				setTicket.setInt(7, ticketNum);
				setTicket.executeUpdate();
			}
			
			%><h4>Success! Reservation Details:</h4><%
			out.println("Reservation Number: " + ticketNum);
			%><br><%
			out.println("First Name: " + firstName);
			%><br><%
			out.println("Last Name: " + lastName);
			%><br><%
			out.println("Class: " + seatClass);
			%><br><%
			out.println("Seat Number: " + seatNum);
			%><br><%
			out.println("Origin Airport: " + originAirport);
			%><br><%
			out.println("Destination Airport: " + destinationAirport);
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
        
        <form method="get" action="customerRep.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>