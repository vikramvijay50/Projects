<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Change Aircrafts</title>
	</head>
	<body>
		
		<p1>Add an Aircraft:</p1>
		<br>
		<form method="get" action="addAircraft.jsp">
			<table>
					<tr>    
						<td>Aircraft Number:</td><td><input type="text" name="aircraftNum"></td>
					</tr>
					<tr>    
						<td>Number of Seats:</td><td><input type="text" name="aircraftSeats"></td>
					</tr>
					<tr>    
						<td>Days Operated:</td><td><input type="text" name="aircraftDays"></td>
					</tr>
			</table>
            <input type="submit" value="Add Aircraft">
        </form>
        <br>
        
        <br>
        <p1>Edit an Aircraft:</p1>
		<br>
		<form method="get" action="editAircraft.jsp">
			<table>
					<tr>    
						<td>Aircraft Number:</td><td><input type="text" name="aircraftNum"></td>
					</tr>
			</table>
            <input type="submit" value="Edit Aircraft">
        </form>
        <br>
        
        <br>
        <p1>Delete an Aircraft:</p1>
		<br>
		<form method="get" action="deleteAircraft.jsp">
			<table>
					<tr>    
						<td>Aircraft Number:</td><td><input type="text" name="aircraftNum"></td>
					</tr>
			</table>
            <input type="submit" value="Delete Aircraft">
        </form>
        <br>
        <br>
		<form method="get" action="customerRep.jsp">
            <input type="submit" value="Go Back">
        </form>
		
	</body>
</html>