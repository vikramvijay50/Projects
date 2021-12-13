<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Delete Airport</title>
</head>
<body>

	<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();	

			//Create a SQL statement
			PreparedStatement delete = con.prepareStatement("DELETE FROM airports WHERE airportName=?");
			delete.setString(1, request.getParameter("airportNum"));
			delete.executeUpdate();
			
			out.println("Airport Deleted!");
								
			db.closeConnection(con);		
			
		} catch (Exception e) {
			out.print(e);
	}%>
        
        <form method="get" action="changeAirport.jsp">
            <input type="submit" value="Go Back">
        </form>

</body>
</html>