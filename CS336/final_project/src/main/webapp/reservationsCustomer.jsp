<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Reservations by Customer</title>
	</head>
	<body>


		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();

			String customer = request.getParameter("rCustomer");
			
			
			String sql = "SELECT DISTINCT * " +
					 "FROM flight_ticket r " +
					 "WHERE r.Username=" + "'" + customer + "'";
			
			
			if(customer.isEmpty()){
				%>Please enter the name of the Customer.<%
			}
			else{
					out.println("Reservations for "+customer+":");
					%><br><%

					ResultSet rs = stmt.executeQuery(sql);
					while(rs.next()){
						String resNum = rs.getString("Ftknum");
						String date = rs.getString("purchaseDate");	
						%><br><%
						out.println("Reservation Number: " + resNum);
						%><br><%
						out.println("Date Made: " + date);
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