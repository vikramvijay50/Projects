<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Customer Rep Tools</title>
	</head>
	<body>
		<h2>Welcome Customer Rep!</h2>								  
		
		<p1>Make a reservation for a User</p1>
		
		<br>
		<br>
		<form method="get" action="repMakeReservation.jsp">
			<table>
					<tr>    
						<td>User Username:</td><td><input type="text" name="userusername"></td>
					</tr>
					<tr>    
					<td>First Name:</td><td><input type="text" name="firstName"></td>
					</tr>
					<tr>    
						<td>Last Name:</td><td><input type="text" name="lastName"></td>
					</tr>
					<tr>    
						<td>Airline Name:</td><td><input type="text" name="airlineName"></td>
					</tr>
					<tr>    
						<td>Origin Airport Name:</td><td><input type="text" name="originAirport"></td>
					</tr>
					<tr>
						<td>Destination Airport Name:</td><td><input type="text" name="destinationAirport"></td>
					</tr>
					<tr>
						<td>Departure Date:</td><td><input type="text" name="departureDate"></td>
					</tr>
					<tr>
						<td>Return Date:</td><td><input type="text" name="arrivalDate"></td>
					</tr>
					<tr>
						<td>Seat Number:</td><td><input type="text" name="seatNum"></td>
					</tr>
			</table>
			<select name="seatClass">
				<option>Economy</option>
				<option>Business</option>
				<option>First Class</option>
			</select>
            <input type="submit" value="Make Reservation">
        </form>
        <br>
        <p1>Add, Edit, Delete Information for Aircrafts</p1>
        <br>
        <form method="get" action="changeAircraft.jsp">
			<input type="submit" value="Go to Page">
		</form>
        
		<br>
		<p1>Add, Edit, Delete Information for Airports</p1>
        <br>
        <form method="get" action="changeAirport.jsp">
			<input type="submit" value="Go to Page">
		</form>
        
		<br>
		<p1>Add, Edit, Delete Information for Flights</p1>
        <br>
        <form method="get" action="changeFlight.jsp">
			<input type="submit" value="Go to Page">
		</form>
        
		<br>
		
        <p1>Edit a reservation for a User</p1>
        
        <br>
        <form method="get" action="repEditReservation.jsp">
        	<table>
					<tr>    
						<td>Ticket Number:</td><td><input type="text" name="changeticketNum"></td>
					</tr>
			</table>
            <input type="submit" value="Find Ticket">
        </form>
		<br>
		
		<p4>List Passengers on the Waiting List for a Particular Flight</p4>
		<br>
        <form method="get" action="passengerWaitingList.jsp">
			<table>
					<tr>    
						<td>Flight Number: </td><td><input type="text" name="waitingFlightNum"></td>
					</tr>
			</table>
            <input type="submit" value="View">
        </form>
        
        <br>
        
        <p4>List all Flights for an Airport</p4>
        <br>
         <form method="get" action="airportFlights.jsp">
			<table>
					<tr>    
						<td>Airport: </td><td><input type="text" name="flightsAirport"></td>
					</tr>
			</table>
            <input type="submit" value="View">
        </form>
       
       <br>
       
       <% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();
			
			String sql = "SELECT COUNT(q.question) FROM questions q WHERE q.response IS NULL";
					
					out.println("Current Customer Questions: ");

					ResultSet rs = stmt.executeQuery(sql);
					while(rs.next()){
						String count = rs.getString("COUNT(q.question)");
						%><br><%
						out.println(count);
		
					}
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
		}%>
       
       <br>
       
       <form method="get" action="customerRepQuestions.jsp">
			<input type="submit" value="View Questions">
		</form>
		
		<br>
       
		<form method="get" action="index.jsp">
			<input type="submit" value="Log Out">
		</form>
		<br>
		
	</body>
</html>