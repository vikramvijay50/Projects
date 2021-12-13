<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Change Flights</title>
	</head>
	<body>
		
		<p1>Add a Flight:</p1>
		<br>
		<form method="get" action="addFlight.jsp">
			<table>
					<tr>    
						<td>Flight Number:</td><td><input type="text" name="flightNum"></td>
					</tr>
					<tr>    
						<td>Departure Airport:</td><td><input type="text" name="depAirport"></td>
					</tr>
					<tr>    
						<td>Destination Airport:</td><td><input type="text" name="destAirport"></td>
					</tr>
					<tr>    
						<td>Departure Time:</td><td><input type="text" name="depTime"></td>
					</tr>
					<tr>    
						<td>Arrival Time:</td><td><input type="text" name="arrivalTime"></td>
					</tr>
					<tr>    
						<td>Flight Duration:</td><td><input type="text" name="duration"></td>
					</tr>
					<tr>    
						<td>Price:</td><td><input type="text" name="price"></td>
					</tr>
					<tr>    
						<td>Number of Stops:</td><td><input type="text" name="stops"></td>
					</tr>
					<tr>    
						<td>Airline:</td><td><input type="text" name="airline"></td>
					</tr>
					<tr>    
						<td>Domestic or International:</td><td><input type="text" name="type"></td>
					</tr>
					<tr>    
						<td>Number of Seats:</td><td><input type="text" name="numSeats"></td>
					</tr>
			</table>
            <input type="submit" value="Add Flight">
        </form>
        <br>
        
        <br>
        <p1>Edit a Flight:</p1>
		<br>
		<form method="get" action="editFlight.jsp">
			<table>
					<tr>    
						<td>Flight Number:</td><td><input type="text" name="flightNum"></td>
					</tr>
			</table>
            <input type="submit" value="Edit Flight">
        </form>
        <br>
        
        <br>
        <p1>Delete a Flight:</p1>
		<br>
		<form method="get" action="deleteFlight.jsp">
			<table>
					<tr>    
						<td>Flight Number:</td><td><input type="text" name="flightNum"></td>
					</tr>
			</table>
            <input type="submit" value="Delete Flight">
        </form>
        <br>
        <br>
		<form method="get" action="customerRep.jsp">
            <input type="submit" value="Go Back">
        </form>
		
	</body>
</html>