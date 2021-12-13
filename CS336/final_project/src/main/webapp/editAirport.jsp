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

	<h2>Edit Aircraft <% out.println(request.getParameter("aircraftNum"));%></h2>	

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	

			//Create a SQL statement
			PreparedStatement getTicket = con.prepareStatement("SELECT * FROM airports WHERE airportName=?");
			getTicket.setString(1, request.getParameter("airportNum"));
			ResultSet result = getTicket.executeQuery();
			
			if(!result.next()){
				response.sendRedirect("changeAirport.jsp");
			} else{
				request.setAttribute("airportNum", result.getString("airportName"));
				request.setAttribute("aircrafts", result.getString("aircrafts"));
			}
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
	

	<form method="get" action="editAirportMake.jsp">
			<table>
					<tr>    
						<td>Aircraft Number:</td><td><input type="text" name="changeName" value=<%=request.getParameter("airportNum")%>></td>
					</tr>
					<tr>    
						<td>Total Seats:</td><td><input type="text" name="changeAircrafts" value=<%=request.getAttribute("aircrafts")%>></td>
					</tr>
			</table>
            <input type="submit" value="Edit Reservation">
        </form>
        
        <form method="get" action="changeAirport.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>