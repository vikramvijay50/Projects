<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Reservations By Transit Line</title>
	</head>
	<body>


		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();

			String flight = request.getParameter("rfNum");
			
			
			String sql = "SELECT DISTINCT r.FtkNum, r.Username " +
						 "FROM flight_ticket r " +
						 "WHERE r.FlightNum=" + "'" + flight + "'";
			
			
			if(flight.isEmpty()){
				%>Please enter the name of the Station.<%
			}
			else{
					out.println("Reservations for Flight #"+flight+":");
					ResultSet rs = stmt.executeQuery(sql);
					while(rs.next()){
						String reservation = rs.getString("FtkNum");
						String user = rs.getString("Username");

						%><br><%
						out.println("Reservation Number: " + reservation);
						%><br><%
						out.println("Customer: " + user);
						%><br><%
				
					}
			}			
			
			db.closeConnection(con);
			
			
		} catch (Exception e) {
			out.print(e);
		}%>
		
		<br>
		<form method="get" action="admin.jsp">
            <input type="submit" value="Return to Admin Tools">
        </form>
				
	</body>
</html>