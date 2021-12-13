<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Ask Question</title>
	</head>
	<body>
		<% 
			try {
				String question = request.getParameter("question");
		
				//Get the database connection
				ApplicationDB database = new ApplicationDB();	
				Connection connection = database.getConnection();
				
				int randomInt = (int)(Math.random() * (90000) + 10000);
				PreparedStatement random = connection.prepareStatement("SELECT * FROM questions WHERE qID=?");
				random.setInt(1, randomInt);
				ResultSet resultRandom = random.executeQuery();
				while (resultRandom.next()) {
					resultRandom.close();
					randomInt = (int)(Math.random() * (90000) + 10000);
					random = connection.prepareStatement("SELECT * FROM questions WHERE qID=?");
					random.setInt(1, randomInt);
					resultRandom = random.executeQuery();
				}
				
				PreparedStatement insertQuestion = connection.prepareStatement("INSERT INTO questions VALUES " +
					"(?,NOW(),?,NULL)");
				insertQuestion.setInt(1, randomInt);
				insertQuestion.setString(2, question);
				insertQuestion.executeUpdate();
				
				response.sendRedirect("customerQuestions.jsp");
				
				//close the connection.
				database.closeConnection(connection);
				
			} catch (Exception e) {
				out.print(e);
			}
		%>
	</body>
</html>