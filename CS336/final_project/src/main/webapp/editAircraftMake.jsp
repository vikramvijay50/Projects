<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Aircraft</title>
</head>
<body>

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();
			
			String aircraftName = request.getParameter("changeNum");
			String numSeats = request.getParameter("changeSeats");
			String days = request.getParameter("changeDays");

			PreparedStatement editAircraft = con.prepareStatement("UPDATE aircrafts SET aircraftName=?, total_seats=?, daysOperated=? WHERE aircraftName=?");
			editAircraft.setString(1, aircraftName);
			editAircraft.setString(2, numSeats);
			editAircraft.setString(3, days);
			editAircraft.setString(4, aircraftName);
			editAircraft.executeUpdate();
			
			%><h4>New Aircraft Details:</h4><%
			out.println("Aircraft Number: " + aircraftName);
			%><br><%
			out.println("Number of Seats: " + numSeats);
			%><br><%
			out.println("Days Operated: " + days);
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
        
        <form method="get" action="changeAircraft.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>