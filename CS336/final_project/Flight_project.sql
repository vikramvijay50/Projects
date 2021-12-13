CREATE DATABASE  IF NOT EXISTS `Flight_booking`;
USE `Flight_booking`;

create table users(
	username varchar(50),
    password varchar(50),
    primary key (username, password));
    
insert into users values
('lmp313', 'abcd1234'),
('dpb123', 'abcd2468');

create table administrator(
    aUsername varchar(50),
    aPassword varchar(50),
    primary key (aUsername));

create table customer_rep(
    cUsername varchar(50),
    cPassword varchar(50),
    primary key (cUsername));

drop table if exists customer;
create table customer(
    custUsername varchar(50),
    custPassword varchar(50),
    primary key (custUsername));
    
insert into administrator values
('lmp313', 'abcd1234');

insert into customer_rep values
('dpb123', 'abcd2468');

create table flight_ticket(
	Ftknum int,
    from_airport varchar(3),
    to_airport varchar(3),
    seatNum varchar(4),
    flight_sequence varchar(50),
    FlightNum int,
    departure datetime,
    isFirstClass boolean,
    isBusiClass boolean,
    isEconClass boolean,
	firstName varchar(30),
    lastName varchar(30),
    price int,
    purchaseDate datetime,
    username varchar(50),
    primary key (Ftknum));

create table airline_co(
	arplname varchar(50),
    num_of_airports int,
    primary key (arplname));

drop table if exists flight;
create table flight(
	Fnum int,
    arrival_time datetime,
    depart_time datetime,
    dest_airport varchar(10),
    depart_airport varchar(10),
    duration int,
    price varchar(10),
    numStops int,
    airline varchar(20),
    numSeats int,
    isDomestic boolean,
    isInternational boolean,
    primary key (Fnum));
    
create table questions(
	qID int,
	dateAsked datetime,
    question varchar(200),
    response varchar(200),
    primary key (qID));

create table aircrafts(
	aircraftName varchar(50),
    total_seats varchar(10),
    daysOperated varchar(50),
    primary key (aircraftName));
    
create table airports(
	airportName varchar(50),
    aircrafts varchar(50),
    primary key (airportName));

create table waiting_list(
	Fnum int,
    username varchar(50),
    firstName varchar(30),
    lastName varchar(30),
    alert boolean,
    foreign key (Fnum) references flight(Fnum));