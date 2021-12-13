<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Current Customer Questions</title>
	</head>
	<body>


		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();		
		
			String ans = request.getParameter("answer");
			String id = (String) session.getAttribute("qID");
			

			PreparedStatement changePass = con.prepareStatement("UPDATE questions SET response="+"'"+ans+"'" + "WHERE qID="+id);
			changePass.executeUpdate();
			
			out.println("Answer Submitted!");

			
			db.closeConnection(con);
			
			
		} catch (Exception e) {
			out.print(e);
		}%>
		
		<br>
		<form method="get" action="customerRep.jsp">
            <input type="submit" value="Return to Customer Rep Tools">
        </form>
				
	</body>
</html>