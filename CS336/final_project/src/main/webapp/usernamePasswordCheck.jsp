<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<!--Import some libraries that have classes that we need -->
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Customer Account Creation</title>
</head>
<body>


<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();

			String user = request.getParameter("username");
			String pass = request.getParameter("pass");
			String confirm = request.getParameter("conf");
			
			if(user.isEmpty() || pass.isEmpty() || confirm.isEmpty()){
						%>
						<h4>Empty value found. Please try again.</h4>
						<form method="get" action="create.jsp">
	            		<input type="submit" value="Click to Try Again">
		        		</form>
		        		<%
			}
			else{
				PreparedStatement checkUsername = con.prepareStatement("SELECT c.custUsername FROM customer c WHERE c.custUsername=?");
				checkUsername.setString(1, user);
				
				ResultSet rs = checkUsername.executeQuery();
				boolean userExists = rs.next();
				if(!userExists && pass.equals(confirm)){
					
					String insert = "INSERT INTO Flight_booking.customer" + " VALUES " + "('" + user + "','" + pass + "')";
					stmt.executeUpdate(insert);
					
					%>
					<h4>Account created!</h4>
					<form method="get" action="index.jsp">
	            		<input type="submit" value="Return to Main Page">
	        		</form>
	        		<%
				}
				else if(userExists){
					%>
					<h4>Username already exists. Please try with a different one.</h4>
					<form method="get" action="create.jsp">
	            		<input type="submit" value="Click to Try Again">
	        		</form>
	        		<%
				}
				else if(!(pass.equals(confirm))){
					%>
					<h4>Passwords did not match. Please try again.</h4>
					<form method="get" action="create.jsp">
	            		<input type="submit" value="Click to Try Again">
	        		</form>
	        	<%
				}	
				db.closeConnection(con);
			
			}%>
		<%} catch (Exception e) {
			out.print(e);
		}%>
<br>



</body>
</html>
