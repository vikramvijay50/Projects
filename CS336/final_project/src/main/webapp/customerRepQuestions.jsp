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
	<h1> Current Questions </h1>

		<% try {
			//Get the database connection
			ApplicationDB db = new ApplicationDB();	
			Connection con = db.getConnection();		

			//Create a SQL statement
			Statement stmt = con.createStatement();		
		
			
			String sql = "SELECT q.question, q.qID FROM questions q WHERE q.response IS NULL";

					ResultSet rs = stmt.executeQuery(sql);
					while(rs.next()){
						
						String question = rs.getString("question");
						String qID = rs.getString("qID");
						session.setAttribute("qID", qID);
						
						out.println("Q: " + question);
						
						%> 
						<form method="get" action="answerCustomerQuestion.jsp">
							<table>
									<tr>    
										<td>A: </td><td><input type="text" name="answer"></td>
									</tr>
							</table>
				            <input type="submit" value="Answer">
				        </form>
				        <br>
						<%
						
						
						
						%> <br> <%

					}		
			
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