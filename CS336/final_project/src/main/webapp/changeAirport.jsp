<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Change Airports</title>
	</head>
	<body>
		
		<p1>Add an Airport:</p1>
		<br>
		<form method="get" action="addAirport.jsp">
			<table>
					<tr>    
						<td>Airport Name:</td><td><input type="text" name="airportName"></td>
					</tr>
					<tr>    
						<td>Aircrafts:</td><td><input type="text" name="airportAircrafts"></td>
					</tr>
			</table>
            <input type="submit" value="Add Airport">
        </form>
        <br>
        
        <br>
        <p1>Edit an Airport:</p1>
		<br>
		<form method="get" action="editAirport.jsp">
			<table>
					<tr>    
						<td>Airport Name:</td><td><input type="text" name="airportNum"></td>
					</tr>
			</table>
            <input type="submit" value="Edit Airport">
        </form>
        <br>
        
        <br>
        <p1>Delete an Airport:</p1>
		<br>
		<form method="get" action="deleteAirport.jsp">
			<table>
					<tr>    
						<td>Airport Name:</td><td><input type="text" name="airportNum"></td>
					</tr>
			</table>
            <input type="submit" value="Delete Airport">
        </form>
        <br>
        <br>
		<form method="get" action="customerRep.jsp">
            <input type="submit" value="Go Back">
        </form>
		
	</body>
</html>