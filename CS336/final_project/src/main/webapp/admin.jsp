<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Admin Tools</title>
	</head>
	<body>
		<h2>Welcome Admin!</h2>								  
		
		<p1>Add Customer Rep</p1>
		<form method="get" action="addCustomerRep.jsp">
			<table>
					<tr>    
						<td>New Customer Rep Username:</td><td><input type="text" name="addRepUsername"></td>
					</tr>
					<tr>    
						<td>New Customer Rep Password:</td><td><input type="text" name="addRepPass"></td>
					</tr>
			</table>
            <input type="submit" value="Add">
        </form>
        <br>
        <p1>Edit Customer Rep</p1>
        <br>
		<form method="get" action="editCustomerRep.jsp">
			<table>
					<tr>    
						<td>Customer Rep Username:</td><td><input type="text" name="editRepUsername"></td>
					</tr>
			</table>
            <input type="submit" value="Edit">
        </form>
        <br>
        <p1>Delete Customer Rep</p1>
        <br>
        <form method="get" action="deleteCustomerRep.jsp">
        	<table>
					<tr>    
						<td>Customer Rep Username:</td><td><input type="text" name="deleteRepUsername"></td>
					</tr>
			</table>
            <input type="submit" value="Delete">
        </form>
		<br>
		
		<p1>Add Customer</p1>
		<form method="get" action="addCustomer.jsp">
			<table>
					<tr>    
						<td>New Customer Username:</td><td><input type="text" name="addCustomerUsername"></td>
					</tr>
					<tr>    
						<td>New Customer Password:</td><td><input type="text" name="addCustomerPass"></td>
					</tr>
			</table>
            <input type="submit" value="Add">
        </form>
        <br>
        <p1>Edit Customer</p1>
        <br>
		<form method="get" action="editCustomer.jsp">
			<table>
					<tr>    
						<td>Customer Username:</td><td><input type="text" name="editCustomerUsername"></td>
					</tr>
			</table>
            <input type="submit" value="Edit">
        </form>
        <br>
        <p1>Delete Customer</p1>
        <br>
        <form method="get" action="deleteCustomer.jsp">
        	<table>
					<tr>    
						<td>Customer Username:</td><td><input type="text" name="deleteCustomerUsername"></td>
					</tr>
			</table>
            <input type="submit" value="Delete">
        </form>
		<br>
		
		<p2>Sales Report by Month</p2>
		<form method="get" action="monthlySales.jsp">
            <input type="submit" value="View">
        </form>
		<br>
		
		<p3>Reservations List</p3>
		<form method="get" action="reservationsFlight.jsp">
            <table>
					<tr>    
						<td>Flight Number: </td><td><input type="text" name="rfNum"></td>
					</tr>
			</table>
			<input type="submit" value="View">
        </form>
        <form method="get" action="reservationsCustomer.jsp">
            <table>
					<tr>    
						<td>Customer (Username): </td><td><input type="text" name="rCustomer"></td>
					</tr>
			</table>
			<input type="submit" value="View">
        </form>
		<br>
		
		<p4>Revenue Listing</p4>
		<form method="get" action="revenueFlight.jsp">
            <table>
					<tr>    
						<td>Flight Number: </td><td><input type="text" name="rFlight"></td>
					</tr>
			</table>
			<input type="submit" value="View">
        </form>
        <form method="get" action="revenueAirline.jsp">
            <table>
					<tr>    
						<td>Airline: </td><td><input type="text" name="rAirline"></td>
					</tr>
			</table>
			<input type="submit" value="View">
        </form>
        <form method="get" action="revenueCustomer.jsp">
            <table>
					<tr>    
						<td>Customer (Username): </td><td><input type="text" name="rCustomer"></td>
					</tr>
			</table>
			<input type="submit" value="View">
        </form>
		<br>
		
		<p5>Highest Revenue Customer</p5>
		<form method="get" action="bestCustomer.jsp">
            <input type="submit" value="View">
        </form>
		<br>
		
		<p6>Top 5 Active Flights</p6>
		<form method="get" action="topFlights.jsp">
            <input type="submit" value="View">
        </form>
		<br>
		<form method="get" action="index.jsp">
			<input type="submit" value="Log Out">
		</form>
		
	</body>
</html>