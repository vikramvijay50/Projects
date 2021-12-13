<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Flight</title>
</head>
<body>

	<h2>Edit Flight</h2>	

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	

			//Create a SQL statement
			PreparedStatement getTicket = con.prepareStatement("SELECT * FROM flight WHERE Fnum=?");
			getTicket.setInt(1, Integer.parseInt(request.getParameter("flightNum").toString()));
			ResultSet result = getTicket.executeQuery();
			
			if(!result.next()){
				response.sendRedirect("changeFlight.jsp");
			} else{
				request.setAttribute("Fnum", result.getInt("Fnum"));
				request.setAttribute("arrival_time", result.getString("arrival_time"));
				request.setAttribute("depart_time", result.getString("depart_time"));
				request.setAttribute("dest_airport", result.getString("dest_airport"));
				request.setAttribute("depart_airport", result.getString("depart_airport"));
				request.setAttribute("duration", result.getInt("duration"));
				request.setAttribute("price", result.getString("price"));
				request.setAttribute("numStops", result.getInt("numStops"));
				request.setAttribute("airline", result.getString("airline"));
				if(result.getBoolean("isDomestic")){
					request.setAttribute("type", "Domestic");
				} else{
					request.setAttribute("type", "International");
				}
				request.setAttribute("numSeats", result.getInt("numStops"));
			}
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
	

	<form method="get" action="editFlightMake.jsp">
			<table>
					<tr>    
						<td>Flight Number:</td><td><input type="text" name="changeflightNum" value=<%=request.getAttribute("Fnum")%>></td>
					</tr>
					<tr>    
						<td>Departure Airport:</td><td><input type="text" name="changedepAirport" value=<%=request.getAttribute("depart_airport")%>></td>
					</tr>
					<tr>    
						<td>Destination Airport:</td><td><input type="text" name="changedestAirport" value=<%=request.getAttribute("dest_airport")%>></td>
					</tr>
					<tr>    
						<td>Departure Time:</td><td><input type="text" name="changedepTime" value=<%=request.getAttribute("depart_time")%>></td>
					</tr>
					<tr>    
						<td>Arrival Time:</td><td><input type="text" name="changearrivalTime" value=<%=request.getAttribute("arrival_time")%>></td>
					</tr>
					<tr>    
						<td>Flight Duration:</td><td><input type="text" name="changeduration" value=<%=request.getAttribute("duration")%>></td>
					</tr>
					<tr>    
						<td>Price:</td><td><input type="text" name="changeprice" value=<%=request.getAttribute("price")%>></td>
					</tr>
					<tr>    
						<td>Number of Stops:</td><td><input type="text" name="changestops" value=<%=request.getAttribute("numStops")%>></td>
					</tr>
					<tr>    
						<td>Airline:</td><td><input type="text" name="changeairline" value=<%=request.getAttribute("airline")%>></td>
					</tr>
					<tr>    
						<td>Domestic or International:</td><td><input type="text" name="changetype" value=<%=request.getAttribute("type")%>></td>
					</tr>
					<tr>    
						<td>Number of Seats:</td><td><input type="text" name="changenumSeats" value=<%=request.getAttribute("numSeats")%>></td>
					</tr>
			</table>
            <input type="submit" value="Edit Reservation">
        </form>
        
        <form method="get" action="changeFlight.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>