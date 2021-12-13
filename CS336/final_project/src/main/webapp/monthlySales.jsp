<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Monthly Sales</title>
	</head>
	<body>
	<h1> Revenue by Month </h1>
 	<p1> Note: Any months not listed had a revenue of 0.00 </p1>
 	<br>
		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		
		

			//Create a SQL statement
			Statement stmt = con.createStatement();		
			
			String sql = "SELECT SUM(r.price), MONTHNAME(r.purchaseDate) FROM flight_ticket r " +
					"GROUP BY MONTH(r.purchaseDate) "+
					"ORDER BY MONTH(r.purchaseDate)";
			

					ResultSet rs = stmt.executeQuery(sql);
					while(rs.next()){
						String sum = rs.getString("SUM(r.price)");
						String date = rs.getString("MONTHNAME(r.purchaseDate)");
						%><br><%
						out.println(date);
						%><br><%
						out.println("Revenue: $" + sum);
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