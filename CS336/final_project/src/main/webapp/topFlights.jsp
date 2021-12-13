<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Best Customer</title>
	</head>
	<body>
	<h1> Top 5 Active Flights </h1>

		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
		

			//Create a SQL statement
			Statement stmt = con.createStatement();		
			
			String sql = "SELECT COUNT(rf.Ftknum), rf.FlightNum FROM flight_ticket rf GROUP BY rf.FlightNum ORDER BY COUNT(*) DESC LIMIT 5";
			

					ResultSet rs = stmt.executeQuery(sql);
					while(rs.next()){
						String counts = rs.getString("COUNT(rf.Ftknum)");
						String transit = rs.getString("FlightNum");
						%><br><%
						out.println("Flight Number: #" + transit);
						%><br><%
						out.println("Reservation Count: " + counts);
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