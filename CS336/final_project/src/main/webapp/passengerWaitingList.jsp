<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Passenger Waiting List</title>
	</head>
	<body>
		<h2>Passenger on Waiting List for Flight #<%out.println(request.getParameter("waitingFlightNum"));%>:</h2>	
		<% 
			try {
				
				//Get the database connection
				ApplicationDB database = new ApplicationDB();	
				Connection connection = database.getConnection();		
	
				out.print("<table border=\"1 px solid black\">");
				out.print("<tr>");
				
				out.print("<td>");
				out.print("Username");
				out.print("</td>");
				
				out.print("<td>");
				out.print("First Name");
				out.print("</td>");
				
				out.print("<td>");
				out.print("Last Name");
				out.print("</td>");
				
				out.print("</tr>");
				
				int flightNum = Integer.parseInt(request.getParameter("waitingFlightNum").toString());
				
				String template = "SELECT * FROM waiting_list WHERE waiting_list.Fnum=?";
				PreparedStatement list;
				list = connection.prepareStatement(template);			
				
				list.setInt(1, flightNum);
				
				//Run the query against the database.
				ResultSet result = list.executeQuery();
				while (result.next()) {
					out.print("<tr>");
					
					out.print("<td>");
					out.print(result.getString("Fnum"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("firstName"));
					out.print("</td>");
					
					out.print("<td>");
					out.print(result.getString("lastName"));
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