<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.text.*,java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Customer Questions</title>
	</head>
	<body>	
		<h2>Questions and Answers:</h2>
		<% 
			try {			
				//Get the database connection
				ApplicationDB database = new ApplicationDB();	
				Connection connection = database.getConnection();
				
				//Create a SQL statement
				PreparedStatement getQuestions = connection.prepareStatement("SELECT * FROM questions ORDER BY dateAsked DESC");
				
				//Run the query against the database.
				ResultSet result = getQuestions.executeQuery();
				while (result.next()) {
					out.println("Date Asked: " + result.getString("dateAsked"));
					%><br><%
					out.println("Question: " + result.getString("question"));
					%><br><%
					if (result.getString("response") == null) {
						out.println("Response: NO RESPONSE YET.");
					} else {
						out.println("Response: " + result.getString("response"));
					}
					%><br><%%><br><%
				}
					
				//close the connection.
				database.closeConnection(connection);
				
			} catch (Exception e) {
				out.print(e);
			}
		%>
		
		<h4>Ask Questions Here:</h4>
		<form method="post" action="askQuestion.jsp">
			<textarea name="question" rows="4" cols="50">Write question here. Max 200 characters.</textarea>
			<br>
            <input type="submit" value="Ask">
		</form>
		
		<h4>Search for Questions By Keyword:</h4>
		<form method="post" action="searchQuestion.jsp">
			<table>
				<tr>    
					<td>Keyword:</td><td><input type="text" name="keyword"></td>
				</tr>
			</table>
            <input type="submit" value="Search">
		</form>
		
		<br>
		<form method="get" action="customer.jsp">
            <input type="submit" value="Go Back">
        </form>
	</body>
</html>