<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Flights from Airport</title>
	</head>
	<body>
		<h2>Flights from Airport <%out.println(request.getParameter("flightsAirport"));%>:</h2>	
		<% 
			try {
				
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
				
				String airport = request.getParameter("flightsAirport");
				
				String template = "SELECT * FROM flight WHERE flight.depart_airport=? OR flight.dest_airport=?";
				PreparedStatement list;
				list = connection.prepareStatement(template);			
				
				list.setString(1, airport);
				list.setString(2, airport);
				
				
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
				
				out.print("</table>");
				
				//close the connection.
				database.closeConnection(connection);
			} catch (Exception e) {
				out.print(e);
			}
		%>

		<br><br>
		<form method="get" action="customerRep.jsp">
            <input type="submit" value="Return to Customer Rep Tools">
        </form>
	</body>
</html>