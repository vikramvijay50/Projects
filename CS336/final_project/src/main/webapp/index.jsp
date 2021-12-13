<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*" %>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Login Page</title>
	</head>
	<body>
		<%
			if (session.getAttribute("error")!=null) {
				out.println(session.getAttribute("error"));
				session.setAttribute("error", null);
			}
		%>
		<h2>Welcome to the Online Flight Booking System!</h2>
		<h4>Login here:</h4>							  
		<form method="post" action="loginCheck.jsp">
			<table>
				<tr>    
					<td>Username:</td><td><input type="text" name="username"></td>
				</tr>
				<tr>
					<td>Password:</td><td><input type="password" name="password"></td>
				</tr>
			</table>
			<input type="submit" value="Login">
		</form>	
		<h4>Are you a customer who doesn't have an account? Create one here:</h4>
		<form method="get" action="create.jsp">
			<input type="submit" value="Create">
		</form>
	</body>
</html>