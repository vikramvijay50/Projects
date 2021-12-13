<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="com.cs336.pkg.*"%>
<%@ page import="java.text.*,java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
		<title>Make Reservations</title>
	</head>
	<body>	
		<% 
			try {
				String userUsername = request.getParameter("userusername");
				String firstName = request.getParameter("firstName");
				String lastName = request.getParameter("lastName");
				String airlineName = request.getParameter("airlineName");
				String originAirport = request.getParameter("originAirport");
				String destinationAirport = request.getParameter("destinationAirport");
				String departureDate = request.getParameter("departureDate");
				String arrivalDate = request.getParameter("arrivalDate");
				String seatNum = request.getParameter("seatNum");
				String seatClass = request.getParameter("seatClass");
				
				if (firstName == "" || lastName == "" || originAirport == "" || destinationAirport == "" || departureDate == "" || seatNum == "") {
					out.println("Please enter values for all the necessary fields.");
				} else {
					//Get the database connection
					ApplicationDB database = new ApplicationDB();	
					Connection connection = database.getConnection();
					
					String template = "SELECT * FROM flight WHERE flight.depart_airport=? AND flight.dest_airport=? AND flight.depart_time=? AND airline=?";
						PreparedStatement list;
						list = connection.prepareStatement(template);
						
						list.setString(1, originAirport);
						list.setString(2, destinationAirport);
						list.setString(3, departureDate);
						list.setString(4, airlineName);
						
						ResultSet result = list.executeQuery();
					if (!result.next()) {
						out.println("A flight could not be found. Please try again.");
					} else {
						int numSeats = result.getInt("numSeats");
						if(numSeats <= 0){
							PreparedStatement updateWaiting = connection.prepareStatement("INSERT INTO waiting_list VALUES (?,?)");
							updateWaiting.setInt(1, result.getInt("Fnum"));
							updateWaiting.setString(2, session.getAttribute("username").toString());
							updateWaiting.executeUpdate();
							out.println("The flight found was full!");
							%><br><%
							out.println("You have been put on the waiting list for flight " + result.getInt("Fnum"));
						} else{
						
						int randomInt = (int)(Math.random() * (90000) + 10000);
						PreparedStatement random = connection.prepareStatement("SELECT * FROM flight_ticket WHERE Ftknum=?");
						random.setInt(1, randomInt);
						ResultSet resultRandom = random.executeQuery();
						while (resultRandom.next()) {
							resultRandom.close();
							randomInt = (int)(Math.random() * (90000) + 10000);
							random = connection.prepareStatement("SELECT * FROM flight_ticket WHERE Ftknum=?");
							random.setInt(1, randomInt);
							resultRandom = random.executeQuery();
						}

						java.sql.Date purchaseDate = new java.sql.Date(System.currentTimeMillis());
						int flightNum = result.getInt("Fnum");
						java.sql.Date departureTime = result.getDate("depart_time");
						
						int totalPrice;
						if(seatClass.equals("Economy")){
							totalPrice = Integer.parseInt(result.getString("price"));
							PreparedStatement insertReservation = connection.prepareStatement("INSERT INTO flight_ticket (Ftknum, username, firstName, lastName, flight_sequence, price, from_airport, to_airport, seatNum, FlightNum, purchaseDate, departure, isFirstClass, isBusiClass, isEconClass) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
							insertReservation.setInt(1, randomInt);
							insertReservation.setString(2, userUsername);
							insertReservation.setString(3, firstName);
							insertReservation.setString(4, lastName);
							insertReservation.setString(5, null);
							insertReservation.setInt(6, totalPrice);
							insertReservation.setString(7, originAirport);
							insertReservation.setString(8, destinationAirport);
							insertReservation.setString(9, seatNum);
							insertReservation.setInt(10, flightNum);
							insertReservation.setDate(11, purchaseDate);
							insertReservation.setDate(12, departureTime);
							insertReservation.setBoolean(13, false);
							insertReservation.setBoolean(14, false);
							insertReservation.setBoolean(15, true);
							insertReservation.executeUpdate();
						} else if(seatClass.equals("Business")){
							totalPrice = Integer.parseInt(result.getString("price")) + 100;
							PreparedStatement insertReservation = connection.prepareStatement("INSERT INTO flight_ticket (Ftknum, username, firstName, lastName, flight_sequence, price, from_airport, to_airport, seatNum, FlightNum, purchaseDate, departure, isFirstClass, isBusiClass, isEconClass) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
							insertReservation.setInt(1, randomInt);
							insertReservation.setString(2, userUsername);
							insertReservation.setString(3, firstName);
							insertReservation.setString(4, lastName);
							insertReservation.setString(5, null);
							insertReservation.setInt(6, totalPrice);
							insertReservation.setString(7, originAirport);
							insertReservation.setString(8, destinationAirport);
							insertReservation.setString(9, seatNum);
							insertReservation.setInt(10, flightNum);
							insertReservation.setDate(11, purchaseDate);
							insertReservation.setDate(12, departureTime);
							insertReservation.setBoolean(13, false);
							insertReservation.setBoolean(14, true);
							insertReservation.setBoolean(15, false);
							insertReservation.executeUpdate();
						} else{
							totalPrice = Integer.parseInt(result.getString("price")) + 250;
							PreparedStatement insertReservation = connection.prepareStatement("INSERT INTO flight_ticket (Ftknum, username, firstName, lastName, flight_sequence, price, from_airport, to_airport, seatNum, FlightNum, purchaseDate, departure, isFirstClass, isBusiClass, isEconClass) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
							insertReservation.setInt(1, randomInt);
							insertReservation.setString(2, userUsername);
							insertReservation.setString(3, firstName);
							insertReservation.setString(4, lastName);
							insertReservation.setString(5, null);
							insertReservation.setInt(6, totalPrice);
							insertReservation.setString(7, originAirport);
							insertReservation.setString(8, destinationAirport);
							insertReservation.setString(9, seatNum);
							insertReservation.setInt(10, flightNum);
							insertReservation.setDate(11, purchaseDate);
							insertReservation.setDate(12, departureTime);
							insertReservation.setBoolean(13, true);
							insertReservation.setBoolean(14, false);
							insertReservation.setBoolean(15, false);
							insertReservation.executeUpdate();
						}
						
						PreparedStatement updateSeats = connection.prepareStatement("UPDATE flight SET numSeats=? WHERE Fnum=?");
						updateSeats.setInt(1, numSeats-1);
						updateSeats.setInt(2, flightNum);
						updateSeats.executeUpdate();
							
							%><h4>Success! Reservation Details:</h4><%
							out.println("Reservation Number: " + randomInt);
							%><br><%
							out.println("Username: " + userUsername);
							%><br><%
							out.println("First Name: " + firstName);
							%><br><%
							out.println("Last Name: " + lastName);
							%><br><%
							out.println("Class: " + seatClass);
							%><br><%
							out.println("Seat Number: " + seatNum);
							%><br><%
							out.println("Fight Number: " + flightNum);
							%><br><%
							out.println("Origin Airport: " + originAirport);
							%><br><%
							out.println("Destination Airport: " + destinationAirport);
							%><br><%
							out.println("Total Price: $" + totalPrice);
							%><br><%
							out.println("Date Made: " + purchaseDate);
						}
							if(!arrivalDate.equals("")){
								String template2 = "SELECT * FROM flight WHERE flight.depart_airport=? AND flight.dest_airport=? AND flight.depart_time=? AND airline=?";
								PreparedStatement list2;
								list2 = connection.prepareStatement(template2);
								
								list2.setString(1, destinationAirport);
								list2.setString(2, originAirport);
								list2.setString(3, arrivalDate);
								list2.setString(4, airlineName);
								
								ResultSet result2 = list2.executeQuery();
							if (!result2.next()) {
								out.println("A return flight could not be found.");
							} else {
								int numSeats2 = result2.getInt("numSeats");
								if(numSeats <= 0){
									PreparedStatement updateWaiting = connection.prepareStatement("INSERT INTO waiting_list VALUES (?,?)");
									updateWaiting.setInt(1, result2.getInt("Fnum"));
									updateWaiting.setString(2, session.getAttribute("username").toString());
									updateWaiting.executeUpdate();
									out.println("The return flight found was full!");
									%><br><%
									out.println("You have been put on the waiting list for flight " + result.getInt("Fnum"));
								} else{
								
								int randomInt2 = (int)(Math.random() * (90000) + 10000);
								PreparedStatement random2 = connection.prepareStatement("SELECT * FROM flight_ticket WHERE Ftknum=?");
								random2.setInt(1, randomInt2);
								ResultSet resultRandom2 = random2.executeQuery();
								while (resultRandom2.next()) {
									resultRandom2.close();
									randomInt2 = (int)(Math.random() * (90000) + 10000);
									random2 = connection.prepareStatement("SELECT * FROM flight_ticket WHERE Ftknum=?");
									random2.setInt(1, randomInt2);
									resultRandom2 = random2.executeQuery();
								}
								
								int flightNum2 = result2.getInt("Fnum");
								java.sql.Date departureTime2 = result2.getDate("depart_time");
								java.sql.Date purchaseDate = new java.sql.Date(System.currentTimeMillis());
								
								int totalPrice2;
								if(seatClass.equals("Economy")){
									totalPrice2 = Integer.parseInt(result.getString("price"));
									PreparedStatement insertReservation = connection.prepareStatement("INSERT INTO flight_ticket (Ftknum, username, firstName, lastName, flight_sequence, price, from_airport, to_airport, seatNum, FlightNum, purchaseDate, departure, isFirstClass, isBusiClass, isEconClass) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
									insertReservation.setInt(1, randomInt2);
									insertReservation.setString(2, userUsername);
									insertReservation.setString(3, firstName);
									insertReservation.setString(4, lastName);
									insertReservation.setString(5, null);
									insertReservation.setInt(6, totalPrice2);
									insertReservation.setString(7, destinationAirport);
									insertReservation.setString(8, originAirport);
									insertReservation.setString(9, seatNum);
									insertReservation.setInt(10, flightNum2);
									insertReservation.setDate(11, purchaseDate);
									insertReservation.setDate(12, departureTime2);
									insertReservation.setBoolean(13, false);
									insertReservation.setBoolean(14, false);
									insertReservation.setBoolean(15, true);
									insertReservation.executeUpdate();
								} else if(seatClass.equals("Business")){
									totalPrice2 = Integer.parseInt(result.getString("price")) + 100;
									PreparedStatement insertReservation = connection.prepareStatement("INSERT INTO flight_ticket (Ftknum, username, firstName, lastName, flight_sequence, price, from_airport, to_airport, seatNum, FlightNum, purchaseDate, departure, isFirstClass, isBusiClass, isEconClass) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
									insertReservation.setInt(1, randomInt2);
									insertReservation.setString(2, userUsername);
									insertReservation.setString(3, firstName);
									insertReservation.setString(4, lastName);
									insertReservation.setString(5, null);
									insertReservation.setInt(6, totalPrice2);
									insertReservation.setString(7, destinationAirport);
									insertReservation.setString(8, originAirport);
									insertReservation.setString(9, seatNum);
									insertReservation.setInt(10, flightNum2);
									insertReservation.setDate(11, purchaseDate);
									insertReservation.setDate(12, departureTime2);
									insertReservation.setBoolean(13, false);
									insertReservation.setBoolean(14, true);
									insertReservation.setBoolean(15, false);
									insertReservation.executeUpdate();
								} else{
									totalPrice2 = Integer.parseInt(result.getString("price")) + 250;
									PreparedStatement insertReservation = connection.prepareStatement("INSERT INTO flight_ticket (Ftknum, username, firstName, lastName, flight_sequence, price, from_airport, to_airport, seatNum, FlightNum, purchaseDate, departure, isFirstClass, isBusiClass, isEconClass) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)");
									insertReservation.setInt(1, randomInt2);
									insertReservation.setString(2, userUsername);
									insertReservation.setString(3, firstName);
									insertReservation.setString(4, lastName);
									insertReservation.setString(5, null);
									insertReservation.setInt(6, totalPrice2);
									insertReservation.setString(7, destinationAirport);
									insertReservation.setString(8, originAirport);
									insertReservation.setString(9, seatNum);
									insertReservation.setInt(10, flightNum2);
									insertReservation.setDate(11, purchaseDate);
									insertReservation.setDate(12, departureTime2);
									insertReservation.setBoolean(13, true);
									insertReservation.setBoolean(14, false);
									insertReservation.setBoolean(15, false);
									insertReservation.executeUpdate();
								}
								PreparedStatement updateSeats2 = connection.prepareStatement("UPDATE flight SET numSeats=? WHERE Fnum=?");
								updateSeats2.setInt(1, numSeats2-1);
								updateSeats2.setInt(2, flightNum2);
								updateSeats2.executeUpdate();
									
									%><h4>Return Reservation Details:</h4><%
									out.println("Reservation Number: " + randomInt2);
									%><br><%
									out.println("Username: " + userUsername);
									%><br><%
									out.println("First Name: " + firstName);
									%><br><%
									out.println("Last Name: " + lastName);
									%><br><%
									out.println("Class: " + seatClass);
									%><br><%
									out.println("Seat Number: " + seatNum);
									%><br><%
									out.println("Fight Number: " + flightNum2);
									%><br><%
									out.println("Origin Airport: " + destinationAirport);
									%><br><%
									out.println("Destination Airport: " + originAirport);
									%><br><%
									out.println("Total Price: $" + totalPrice2);
									%><br><%
									out.println("Date Made: " + purchaseDate);
							}
						}
					}
				}
					
					//close the connection.
					database.closeConnection(connection);
				}
			} catch (Exception e) {
				out.print(e);
			}
		%>
		<br><br>
		<form method="get" action="customerRep.jsp">
            <input type="submit" value="Go Back">
        </form>
	</body>
</html>