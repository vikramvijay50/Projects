<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Revenue by Customer</title>
	</head>
	<body>


		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();

			String flight = request.getParameter("rFlight");
			
			
			String sql = "SELECT r.price, r.Ftknum " +
					 "FROM flight_ticket r " +
					 "WHERE r.FlightNum =" + "'" + flight + "'";
			
			
			if(flight.isEmpty()){
				%>Please enter the Flight Number.<%
			}
			else{
					out.println("Revenue for Flight #"+flight+":");
					%><br><%
					double total = 0;
					ResultSet rs = stmt.executeQuery(sql);
					while(rs.next()){
						String resNum = rs.getString("Ftknum");
						String fare = rs.getString("price");	
						%><br><%
						out.println("Reservation Number: " + resNum);
						%><br><%
						out.println("Price: $" + fare);
						%><br><%
						total += Double.parseDouble(fare);
					}
					
					%><br><%
					out.println("Total: $" + total);
					%><br><%
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