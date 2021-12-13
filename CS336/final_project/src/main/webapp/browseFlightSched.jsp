<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Browse Flight Schedules</title>
	</head>
	<body>
		<h2>Resulting Schedules:</h2>	
		<% 
			try {
				String isFlexible;
				if (request.getParameter("isFlexible") != null) {
					isFlexible = request.getParameter("isFlexible");
					session.setAttribute("isFlexible", isFlexible);
				} else {
					isFlexible = session.getAttribute("isFlexible").toString();
				}
			
				String originInput;
				if (request.getParameter("originInput") != null) {
					originInput = request.getParameter("originInput");
					session.setAttribute("originInput", originInput);
				} else {
					originInput = session.getAttribute("originInput").toString();
				}
				
				String destInput;
				if (request.getParameter("destInput") != null) {
					destInput = request.getParameter("destInput");
					session.setAttribute("destInput", destInput);
				} else {
					destInput = session.getAttribute("destInput").toString();
				}
				
				String departureInput;
				if (request.getParameter("departureInput") != null) {
					departureInput = request.getParameter("departureInput");
					session.setAttribute("departureInput", departureInput);
				} else {
					departureInput = session.getAttribute("departureInput").toString();
				}
				
				String arrivalInput;
				if (request.getParameter("arrivalInput") != null) {
					arrivalInput = request.getParameter("arrivalInput");
					session.setAttribute("arrivalInput", arrivalInput);
					if(request.getParameter("arrivalInput").equals("")){
						arrivalInput = "1753-01-01";
					}
				} else {
					arrivalInput = session.getAttribute("arrivalInput").toString();
				}
				
				String interval = "";
				if (isFlexible.equals("Specific Date")) {
					interval = "";
				} else if (isFlexible.equals("Flexible Date")) {
					interval = "AND flight.depart_time < DATE(flight.depart_time + INTERVAL 3 DAY) AND flight.depart_time > DATE(flight.depart_time - INTERVAL 3 DAY)";
				}
		
				String sort = "";
				if (request.getParameter("sortBy") != null) {
					if (request.getParameter("sortBy").equals("Price")) {
						sort = "ORDER BY flight.price ASC";
					} else if (request.getParameter("sortBy").equals("Departure Time")) {
						sort = "ORDER BY flight.depart_time ASC";
					} else if (request.getParameter("sortBy").equals("Arrival Time")) {
						sort = "ORDER BY flight.arrival_time ASC";
					} else if (request.getParameter("sortBy").equals("Duration")) {
						sort = "ORDER BY flight.duration ASC";
					}
				}
				
				String filter = "";
				boolean isFiltered = false;
				if (request.getParameter("filterBy") != null) {
					if (request.getParameter("filterBy").equals("Price")) {
						filter = "AND flight.price=?";
						isFiltered = true;
					} else if (request.getParameter("filterBy").equals("Number of Stops")) {
						filter = "AND flight.numStops=?";
						isFiltered = true;
					} else if (request.getParameter("filterBy").equals("Airline")) {
						filter = "AND flight.airline=?";
						isFiltered = true;
					} else if (request.getParameter("filterBy").equals("Departure Time")) {
						filter = "AND flight.depart_time=?";
						isFiltered = true;
					} else if (request.getParameter("filterBy").equals("Arrival Time")) {
						filter = "AND flight.arrival_time=?";
						isFiltered = true;
					} else if (request.getParameter("filterBy").equals("No filter")) {
						isFiltered = false;
					}
				}
				
				//Get the database connection
				ApplicationDB database = new ApplicationDB();	
				Connection connection = database.getConnection();		
	
				out.print("<table border=\"1 px solid black\">");
				out.print("<tr>");
				
				out.print("<td>");
				out.print("Airline Name");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Origin Airport");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Destination Airport");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Price");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Duration");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Number of Stops");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Departure Time");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Arrival Time");
				out.print("</td>");
				
				out.print("</tr>");
				
				String template = "SELECT * FROM flight WHERE flight.depart_airport=? AND flight.dest_airport=? AND flight.depart_time=?";
				PreparedStatement list;
				list = connection.prepareStatement(template + interval + filter + sort);
				
				PreparedStatement list2;
				String template2 = "SELECT * FROM flight WHERE flight.depart_airport=? AND flight.dest_airport=? AND flight.depart_time=?";
				list2 = connection.prepareStatement(template2 + interval + filter + sort);				
				
				list.setString(1, originInput);
				list.setString(2, destInput);
				list.setString(3, departureInput);
				if(isFiltered){
					list.setString(4, request.getParameter("filterInput"));
				}
				
				list2.setString(1, destInput);
				list2.setString(2, originInput);
				list2.setString(3, arrivalInput);
				if(isFiltered){
					list2.setString(4, request.getParameter("filterInput"));
				}
				
				//Run the query against the database.
				ResultSet result = list.executeQuery();
				while (result.next()) {
					out.print("<tr>");
					
					out.print("<td>");
					out.print(result.getString("airline"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("depart_airport"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("dest_airport"));
					out.print("</td>");
					
					out.print("<td>");
					out.print("$" + result.getString("price"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("duration"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("numStops"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("depart_time"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("arrival_time"));
					out.print("</td>");
					
					out.print("</tr>");
				}
				ResultSet result2 = list2.executeQuery();
				while (result2.next()) {
					out.print("<tr>");
					
					out.print("<td>");
					out.print(result2.getString("airline"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result2.getString("depart_airport"));
					out.print("</td>");
						
					out.print("<td>");
					out.print(result2.getString("dest_airport"));
					out.print("</td>");
						
					out.print("<td>");
					out.print("$" + result2.getString("price"));
					out.print("</td>");
						
					out.print("<td>");
					out.print(result2.getString("duration"));
					out.print("</td>");
						
					out.print("<td>");
					out.print(result2.getString("numStops"));
					out.print("</td>");
						
					out.print("<td>");
					out.print(result2.getString("depart_time"));
					out.print("</td>");
						
					out.print("<td>");
					out.print(result2.getString("arrival_time"));
					out.print("</td>");
						
					out.print("</tr>");
				}
				
				out.print("</table>");
				
				//close the connection.
				database.closeConnection(connection);
			} catch (Exception e) {
				out.print(e);
			}
		%>
		<h4>Sort by a different criteria:</h4>
		<form method="post" action="browseFlightSched.jsp">
			<select name="sortBy">
				<option>Price</option>
				<option>Departure Time</option>
				<option>Arrival Time</option>
				<option>Duration</option>
			</select>
			<input type="submit" value="Sort">
		</form>
		<h4>Filter by a different criteria:</h4>
		<form method="post" action="browseFlightSched.jsp">
			<select name="filterBy">
				<option>No Filter</option>
				<option>Price</option>
				<option>Number of Stops</option>
				<option>Airline</option>
				<option>Departure Time</option>
				<option>Arrival Time</option>
			</select>
			<input type="text" name="filterInput">
			<input type="submit" value="Filter">
		</form>	
		<br><br>
		<form method="get" action="customer.jsp">
            <input type="submit" value="Return to Customer Page">
        </form>
	</body>
</html>