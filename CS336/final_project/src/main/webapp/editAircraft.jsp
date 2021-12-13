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

	<h2>Edit Aircraft <% out.println(request.getParameter("aircraftNum"));%></h2>	

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	

			//Create a SQL statement
			PreparedStatement getTicket = con.prepareStatement("SELECT * FROM aircrafts WHERE aircraftName=?");
			getTicket.setString(1, request.getParameter("aircraftNum"));
			ResultSet result = getTicket.executeQuery();
			
			if(!result.next()){
				response.sendRedirect("changeAircraft.jsp");
			} else{
				request.setAttribute("aircraftNum", result.getString("aircraftName"));
				request.setAttribute("aircraftSeats", result.getString("total_seats"));
				request.setAttribute("aircraftDays", result.getString("daysOperated"));
			}
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
	

	<form method="get" action="editAircraftMake.jsp">
			<table>
					<tr>    
						<td>Aircraft Number:</td><td><input type="text" name="changeNum" value=<%=request.getParameter("aircraftNum")%>></td>
					</tr>
					<tr>    
						<td>Total Seats:</td><td><input type="text" name="changeSeats" value=<%=request.getAttribute("aircraftSeats")%>></td>
					</tr>
					<tr>    
						<td>Days Operated:</td><td><input type="text" name="changeDays" value=<%=request.getAttribute("aircraftDays")%>></td>
					</tr>

			</table>
            <input type="submit" value="Edit Reservation">
        </form>
        
        <form method="get" action="changeAircraft.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>