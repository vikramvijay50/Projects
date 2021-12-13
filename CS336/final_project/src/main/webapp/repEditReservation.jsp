<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Edit Reservation</title>
</head>
<body>

	<h2>Edit Reservation for Ticket <% out.println(request.getParameter("changeticketNum"));%></h2>	

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	

			//Create a SQL statement
			PreparedStatement getTicket = con.prepareStatement("SELECT * FROM flight_ticket WHERE Ftknum=?");
			getTicket.setInt(1, Integer.parseInt(request.getParameter("changeticketNum").toString()));
			ResultSet result = getTicket.executeQuery();
			
			if(!result.next()){
				response.sendRedirect("customerRep.jsp");
			} else{
				request.setAttribute("firstname", result.getString("firstName"));
				request.setAttribute("lastname", result.getString("lastName"));
				request.setAttribute("from", result.getString("from_airport"));
				request.setAttribute("to", result.getString("to_airport"));
				request.setAttribute("departure", result.getString("departure"));
				request.setAttribute("seatNum", result.getString("seatNum"));
				if(result.getBoolean("isFirstClass")){
					request.setAttribute("seatClass", "First Class");
				} else if(result.getBoolean("isBusiClass")){
					request.setAttribute("seatClass", "Business");
				} else{
					request.setAttribute("seatClass", "Economy");
				}
			}
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
	

	<form method="get" action="repMakeEdit.jsp">
			<table>
					<tr>    
					<td>Ticket Number:</td><td><input type="text" name="changeticketNum" value=<%=request.getParameter("changeticketNum")%> readonly="readonly"></td>
					</tr>
					<tr>    
					<td>First Name:</td><td><input type="text" name="changefirstName" value=<%=request.getAttribute("firstname")%>></td>
					</tr>
					<tr>    
						<td>Last Name:</td><td><input type="text" name="changelastName" value=<%=request.getAttribute("lastname")%>></td>
					</tr>
					<tr>    
						<td>Origin Airport Name:</td><td><input type="text" name="changeoriginAirport" value=<%=request.getAttribute("from")%>></td>
					</tr>
					<tr>
						<td>Destination Airport Name:</td><td><input type="text" name="changedestinationAirport" value=<%=request.getAttribute("to")%>></td>
					</tr>
					<tr>
						<td>Departure Date:</td><td><input type="text" name="changedepartureDate" value=<%=request.getAttribute("departure")%>></td>
					</tr>
					<tr>
						<td>Seat Number:</td><td><input type="text" name="changeseatNum" value=<%=request.getAttribute("seatNum")%>></td>
					</tr>
					<tr>
						<td>Seat Class:</td><td><input type="text" name="changeseatClass" value=<%=request.getAttribute("seatClass")%>></td>
					</tr>
			</table>
            <input type="submit" value="Edit Reservation">
        </form>
        
        <form method="get" action="customerRep.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>