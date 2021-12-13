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
<h2>Create a Customer Account</h2>
<h4>Enter the account information here:</h4>
<form name = "userForm" action="usernamePasswordCheck.jsp">
  <label for="username">Username:</label>
  <input type="text" id="username" name="username"><br><br>
  <label for="pass">Password:</label>
  <input type="text" id="pass" name="pass"><br><br>
  <label for="conf">Confirm Password:</label>
  <input type="text" id="conf" name="conf"><br><br>
  <input type="submit" value="Create">
</form>

<br>

<form method="get" action="index.jsp">
            <input type="submit" value="Return to Main Page">
        </form>

</body>
</html>
