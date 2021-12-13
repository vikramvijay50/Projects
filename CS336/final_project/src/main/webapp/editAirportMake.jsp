<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Airport</title>
</head>
<body>

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			String airportName = request.getParameter("changeName");
			String aircrafts = request.getParameter("changeAircrafts");

			PreparedStatement editAircraft = con.prepareStatement("UPDATE airports SET airportName=?, aircrafts=? WHERE airportName=?");
			editAircraft.setString(1, airportName);
			editAircraft.setString(2, aircrafts);
			editAircraft.setString(3, airportName);
			editAircraft.executeUpdate();
			
			%><h4>New Aircraft Details:</h4><%
			out.println("Aircraft Number: " + airportName);
			%><br><%
			out.println("Number of Seats: " + aircrafts);
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
        
        <form method="get" action="changeAirport.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>