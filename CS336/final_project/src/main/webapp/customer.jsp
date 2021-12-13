<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Customer Page</title>
	</head>
	<body>
		<h2>Welcome Customer <%out.println(session.getAttribute("username"));%>!</h2>
		<h4>Search for Train Schedules:</h4>	
		<form method="post" action="browseFlightSched.jsp">
			<table>
				<tr>
					<td>Origin Airport:</td><td><input type="text" name="originInput"></td>
				</tr>
				<tr>
					<td>Destination Airport:</td><td><input type="text" name="destInput"></td>
				</tr>
				<tr>
					<td>Departure Date:</td><td><input type="text" name="departureInput"></td>
				</tr>
				<tr>
					<td>Return Date:</td><td><input type="text" name="arrivalInput"></td>
				</tr>
			</table>
			<select name="isFlexible">
				<option>Specific Date</option>
				<option>Flexible Date</option>
			</select>
			<br>
			<input type="submit" value="Search">
		</form>							 
		<br>*For One way trips please leave the Arrival Date blank.<br>
		*For date of travel, please enter a date in the format: YYYY-MM-DD.<br>
		
		<%
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			PreparedStatement alerts = con.prepareStatement("SELECT * from waiting_list WHERE alert=true");
			ResultSet result = alerts.executeQuery();
			
			while(result.next()){
				%><br><%
				out.println("There is now an Empty Seat on Flight: #" + result.getInt("Fnum"));
				%><br><%
			}
		%>
		
		<h4>Purchase a Ticket Here:</h4>	
		<form method="post" action="makeReservation.jsp">
			<table>
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
			<br><br>
			<input type="submit" value="Make Reservation">
		</form>
		<br>*For One way trips please leave the Arrival Date blank.<br>
		*For date of travel, please enter a date in the format: YYYY-MM-DD.<br>
		
		<h4>Current Reservations:</h4>
		<form method="get" action="currentReservations.jsp">
			<input type="submit" value="View or Cancel">
		</form>
		
		<h4>Past Reservations:</h4>
		<form method="get" action="pastReservations.jsp">
			<input type="submit" value="View">
		</form>
		
		<h4>Ask Questions or View Questions and Answers:</h4>
		<form method="get" action="customerQuestions.jsp">
			<input type="submit" value="Ask or View">
		</form>
		
		<br>
		<form method="get" action="index.jsp">
			<input type="submit" value="Logout">
		</form>
	</body>
</html>