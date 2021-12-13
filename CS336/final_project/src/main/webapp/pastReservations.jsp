<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.text.*,java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Past Reservations</title>
	</head>
	<body>	
		<h2>Past Reservations:</h2>
		<% 
			try {			
				out.print("<table border=\"1 px solid black\">");
				out.print("<tr>");
				
				out.print("<td>");
				out.print("Reservation Number");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Date Made");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Class");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Total Price");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Flight Number");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Origin Airport");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Destination Airport");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Departure Time");
				out.print("</td>");
				
				out.print("</tr>");
				
				//Get the database connection
				ApplicationDB database = new ApplicationDB();	
				Connection connection = database.getConnection();
				
				//Create a SQL statement
				PreparedStatement getPast = connection.prepareStatement("SELECT * FROM flight_ticket WHERE username=? AND departure < NOW()");
				getPast.setString(1, session.getAttribute("username").toString());
				
				//Run the query against the database.
				ResultSet result = getPast.executeQuery();
				while (result.next()) {
					out.print("<tr>");
					
					out.print("<td>");
					out.print(result.getString("Ftknum"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("purchaseDate"));
					out.print("</td>");
					
					if(result.getBoolean("isFirstClass")){
						out.print("<td>");
						out.print("First Class");
						out.print("</td>");
					} else if(result.getBoolean("isBusiClass")){
						out.print("<td>");
						out.print("Business");
						out.print("</td>");
					} else{
						out.print("<td>");
						out.print("Economy");
						out.print("</td>");
					}
					
					out.print("<td>");
					out.print(result.getString("price"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("FlightNum"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("from_airport"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("to_airport"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("departure"));
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
		<br>
		<form method="get" action="customer.jsp">
            <input type="submit" value="Go Back">
        </form>
	</body>
</html>