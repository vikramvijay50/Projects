<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Login Check</title>
	</head>
	<body>
		<% 
			try {
				String username = request.getParameter("username");
				session.setAttribute("username", username);
				String password = request.getParameter("password");
		
				//Get the database connection
				ApplicationDB database = new ApplicationDB();	
				Connection connection = database.getConnection();		
				
				//Create a SQL statement
				PreparedStatement checkUsername = connection.prepareStatement("SELECT c.custUsername FROM customer c WHERE c.custUsername=?");
				checkUsername.setString(1, username);
				
				//Run the query against the database.
				ResultSet resultUsername = checkUsername.executeQuery();
				boolean customerExists = resultUsername.next();
	
				PreparedStatement checkEmployee = connection.prepareStatement("SELECT r.cUsername FROM customer_rep r WHERE r.cUsername=?");
				checkEmployee.setString(1, username);
				
				ResultSet resultEmployee = checkEmployee.executeQuery();
				boolean custRepExists = resultEmployee.next();
				
				PreparedStatement checkAdmin = connection.prepareStatement("SELECT a.aUsername FROM administrator a WHERE a.aUsername=?");
				checkAdmin.setString(1, username);
				
				ResultSet resultAdmin = checkAdmin.executeQuery();
				boolean adminExists = resultAdmin.next();
				
				if (!customerExists && !custRepExists && !adminExists) {
					session.setAttribute("error", "Invalid username. Try again.");
					response.sendRedirect("index.jsp");
				} else if(customerExists){		
					//Password Check
					PreparedStatement checkPassword = connection.prepareStatement("SELECT * FROM customer c WHERE c.custUsername=? AND c.custPassword=?");
					
					checkPassword.setString(1, username);
					checkPassword.setString(2, password);
	
					ResultSet resultPassword = checkPassword.executeQuery();

					if (!resultPassword.next()) {
						session.setAttribute("error", "Wrong password. Try again.");
						response.sendRedirect("index.jsp");
					} else {
						//session.setAttribute("username", resultPassword.getString("username"));
						response.sendRedirect("customer.jsp");	
					}
				} else if(custRepExists){
					PreparedStatement checkEmployeePass = connection.prepareStatement("SELECT * FROM customer_rep r WHERE r.cUsername=? AND r.cPassword=?");
					
					checkEmployeePass.setString(1, username);
					checkEmployeePass.setString(2, password);
	
					ResultSet resultEmployeePass = checkEmployeePass.executeQuery();
					
					
					if (!resultEmployeePass.next()) {
						session.setAttribute("error", "Wrong password. Try again.");
						response.sendRedirect("index.jsp");
					} else{
						//session.setAttribute("username", resultEmployeePass.getString("username"));
						
						response.sendRedirect("customerRep.jsp");
					}
				} else if(adminExists){
					PreparedStatement checkAdminPass = connection.prepareStatement("SELECT * FROM administrator a WHERE a.aUsername=? AND a.aPassword=?");
					
					checkAdminPass.setString(1, username);
					checkAdminPass.setString(2, password);
	
					ResultSet resultAdminPass = checkAdmin.executeQuery();
					if (!resultAdminPass.next()) {
						session.setAttribute("error", "Wrong password. Try again.");
						response.sendRedirect("index.jsp");
					} else{
						//session.setAttribute("username", resultAdminPass.getString("username"));
						
						response.sendRedirect("admin.jsp");
					}
				}
				
				//close the connection.
				database.closeConnection(connection);
			} catch (Exception e) {
				out.print(e);
			}
		%>
	</body>
</html>