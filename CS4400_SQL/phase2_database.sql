-- CS4400: Introduction to Database Systems: Monday, January 30, 2023
-- Flight Management Course Project Database TEMPLATE (v1.0)

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'flight_management';

drop database if exists flight_management;
create database if not exists flight_management;
use flight_management;

-- Define the database structures and enter the denormalized data

DROP TABLE IF EXISTS airline;
CREATE TABLE airline (
  airlineID char(50) NOT NULL,
  revenue int,
  PRIMARY KEY (airlineID)
) ENGINE=InnoDB;

-- Dumping data for table airline

INSERT INTO airline  VALUES
('Air_france', 25),
('American', 45),
('Delta', 46),
('Jetblue', 8),
('Lufthansa', 31),
('Southwest', 22),
('Spirit', 4),
('United', 40);

DROP TABLE IF EXISTS location;
CREATE TABLE location (
	locID char(15) NOT NULL,
	PRIMARY KEY (locID)
) ENGINE=InnoDB;

-- Inserting data into location table
INSERT INTO location VALUES
('plane_1'),
('plane_11'),
('plane_15'),
('plane_2'),
('plane_4'),
('plane_7'),
('plane_8'),
('plane_9'),
('port_1'),
('port_10'),
('port_11'),
('port_13'),
('port_14'),
('port_15'),
('port_17'),
('port_18'),
('port_2'),
('port_3'),
('port_4'),
('port_5'),
('port_7'),
('port_9');

DROP TABLE IF EXISTS airplane;
CREATE TABLE airplane (
  tail_num char(10) NOT NULL,
  airlineID char(50) NOT NULL,
  seat_cap int NOT NULL,
  speed int NOT NULL,
  plane_type char(10),
  props_or_jets int,
  skids int,
  locID char(10),
  PRIMARY KEY (tail_num, airlineID),
  CONSTRAINT fk1 FOREIGN KEY(airlineID) REFERENCES airline (airlineID)
) ENGINE=InnoDB;

-- Inserting data into table airplane

INSERT INTO airplane VALUES
	('n330ss', 'American', '4', '200', 'jet', '2', NULL, 'plane_4'),
	('n380sd', 'American', '5', '400', 'jet', '2', NULL, NULL),
	('n106js', 'Delta', '4', '200', 'jet', '2', NULL, 'plane_1'),
	('n110jn', 'Delta', '5', '600', 'jet', '4', NULL, 'plane_2'),
	('n127js', 'Delta', '4', '800', NULL, NULL, NULL, NULL),
	('n156sq', 'Delta', '8', '100', NULL, NULL, NULL, NULL),
	('n161fk', 'JetBlue', '4', '200', 'jet', '2', NULL, NULL),
	('n337as', 'JetBlue', '5', '400', 'jet', '2', NULL, NULL),
	('n118fm', 'Southwest', '4', '100', 'prop', '1', '1', 'plane_11'),
	('n401fj', 'Southwest', '4', '200', 'jet', '2', NULL, 'plane_9'),
	('n653fk', 'Southwest', '6', '400', 'jet', '2', NULL, NULL),
	('n815pw', 'Southwest', '3', '200', 'prop', '2', '0', NULL),
	('n256ap', 'Spirit', '4', '400', 'jet', '2', NULL, 'plane_15'),
	('n451fi', 'United', '5', '400', 'jet', '4', NULL, NULL),
	('n517ly', 'United', '4', '400', 'jet', '2', NULL, 'plane_7'),
	('n616lt', 'United', '7', '400', 'jet', '4', NULL, NULL),
	('n620la', 'United', '4', '200', 'prop', '2', '0', 'plane_8');

DROP TABLE IF EXISTS person;
CREATE TABLE person (
  personID char(50) NOT NULL,
  fname char(50) NOT NULL,
  lname char(50),
  experience int,
  miles int,
  locID char(15),
  taxID char(20) UNIQUE,
  pilot_airline char(10),
  pilot_tail char(10),
  pilot_flag boolean NOT NULL,
  passenger_flag boolean NOT NULL,
  PRIMARY KEY (personID),
  CONSTRAINT fk11 FOREIGN KEY (pilot_airline, pilot_tail) REFERENCES airplane (airlineID, tail_num),
  CONSTRAINT fk16 FOREIGN KEY (locID) REFERENCES location (locID)
) ENGINE=InnoDB;

-- Inserting data for table person
-- MISSING PILOT_TAIL, PILOT_AIRLINE, PILOT_FLAG, PASSENGER_FLAG

INSERT INTO person VALUES
	('p1', 'Jeanne', 'Nelson', 31, NULL , 'plane_1', '330-12-6907', 'Delta', 'n106js', TRUE, FALSE),
    ('p10', 'Lawrence', 'Morgan', 15, NULL, 'plane_9', '769-60-1266', 'Southwest', 'n401fj', TRUE, FALSE),
	('p11', 'Sandra', 'Cruz', 22, NULL, 'plane_9', '369-22-9505', 'Southwest', 'n401fj', TRUE, FALSE),
	('p12', 'Dan', 'Ball', 24, NULL, 'plane_11', '680-92-5329', 'Southwest', 'n118fm', TRUE, FALSE),
	('p13', 'Bryant', 'Figueroa', 24, NULL, 'plane_2', '513-40-4168', 'Delta', 'n110jn', TRUE, FALSE),
	('p14', 'Dana', 'Perry', 13, NULL, 'plane_2', '454-71-7847', 'Delta', 'n110jn', TRUE, FALSE),
	('p15', 'Matt', 'Hunt', 30, NULL, 'plane_2', '153-47-8101', 'Delta', 'n110jn', TRUE, FALSE),
	('p16', 'Edna', 'Brown', 28, NULL, 'plane_15', '598-47-5172', 'Spirit', 'n256ap', TRUE, FALSE),
	('p17', 'Ruby', 'Burgess', 36, NULL, 'plane_15', '865-71-6800', 'Spirit', 'n256ap', TRUE, FALSE),
	('p18', 'Esther', 'Pittman', 23, NULL, 'port_2', '250-86-2784', NULL, NULL, TRUE, FALSE),
	('p19', 'Doug', 'Fowler', 2, NULL, 'port_4', '386-39-7881', NULL, NULL, TRUE, FALSE),
	('p2', 'Roxanne', 'Byrd', 9, NULL, 'plane_1', '842-88-1257', 'Delta', 'n106js', TRUE, FALSE),
	('p20', 'Thomas', 'Olson', 28, NULL, 'port_3', '522-44-3098', NULL, NULL, TRUE, FALSE),
	('p21', 'Mona', 'Harrison', 2, 771, 'port_4', '621-34-5755', NULL, NULL, TRUE, TRUE),
	('p22', 'Arlene', 'Massey', 3, 374, 'port_2', '177-47-9877', NULL, NULL, TRUE, TRUE),
	('p23', 'Judith', 'Patrick', 12, 414, 'port_3', '528-64-7912', NULL, NULL, TRUE, TRUE),
	('p24', 'Reginald', 'Rhodes', 34, 292, 'plane_1', '803-30-1789', NULL, NULL, TRUE, TRUE),
	('p25', 'Vincent', 'Garcia', 13, 390, 'plane_1', '986-76-1587', NULL, NULL, TRUE, TRUE),
	('p26', 'Cheryl', 'Moore', 20, 302, 'plane_4', '584-77-5105', NULL, NULL, TRUE, TRUE),
	('p27', 'Michael', 'Rivera', NULL, 470, 'plane_7', NULL, NULL, NULL, FALSE, TRUE),
	('p28', 'Luther', 'Matthews', NULL, 208, 'plane_8', NULL, NULL, NULL, FALSE, TRUE),
	('p29', 'Moses', 'Parks', NULL, 292, 'plane_8', NULL, NULL, NULL, FALSE, TRUE),
	('p3', 'Tanya', 'Nguyen', 11, NULL, 'plane_4', '750-24-7616', 'American', 'n330ss', TRUE, FALSE),
	('p30', 'Ora', 'Steele', NULL, 686, 'plane_9', NULL, NULL, NULL, FALSE, TRUE),
	('p31', 'Antonio', 'Flores', NULL, 547, 'plane_9', NULL, NULL, NULL, FALSE, TRUE),
	('p32', 'Glenn', 'Ross', NULL, 257, 'plane_11', NULL, NULL, NULL, FALSE, TRUE),
	('p33', 'Irma', 'Thomas', NULL, 564, 'plane_11', NULL, NULL, NULL, FALSE, TRUE),
	('p34', 'Ann', 'Maldonado', NULL, 211, 'plane_2', NULL, NULL, NULL, FALSE, TRUE),
	('p35', 'Jeffrey', 'Cruz', NULL, 233, 'plane_2', NULL, NULL, NULL, FALSE, TRUE),
	('p36', 'Sonya', 'Price', NULL, 293, 'plane_15', NULL, NULL, NULL, FALSE, TRUE),
	('p37', 'Tracy', 'Hale', NULL, 552, 'plane_15', NULL, NULL, NULL, FALSE, TRUE),
	('p38', 'Albert', 'Simmons', NULL, 812, 'port_1', NULL, NULL, NULL, FALSE, TRUE),
	('p39', 'Karen', 'Terry', NULL, 541, 'port_9', NULL, NULL, NULL, FALSE, TRUE),
	('p4', 'Kendra', 'Jacobs', 24, NULL, 'plane_4', '776-21-8098', 'American', 'n330ss', TRUE, FALSE),
	('p40', 'Glen', 'Kelley', NULL, 441, 'plane_4', NULL, NULL, NULL, FALSE, TRUE),
	('p41', 'Brooke', 'Little', NULL, 875, 'port_4', NULL, NULL, NULL, FALSE, TRUE),
	('p42', 'Daryl', 'Nguyen', NULL, 691, 'port_3', NULL, NULL, NULL, FALSE, TRUE),
	('p43', 'Judy', 'Willis', NULL, 572, 'port_1', NULL, NULL, NULL, FALSE, TRUE),
	('p44', 'Marco', 'Klein', NULL, 572, 'port_2', NULL, NULL, NULL, FALSE, TRUE),
	('p45', 'Angelica', 'Hampton', NULL, 663, 'port_5', NULL, NULL, NULL, FALSE, TRUE),
	('p5', 'Jeff', 'Burton', 27, NULL, 'plane_4', '933-93-2165', 'American', 'n330ss', TRUE, FALSE),
	('p6', 'Randal', 'Parks', 38, NULL, 'plane_7', '707-84-4555', 'United', 'n517ly', TRUE, FALSE),
	('p7', 'Sonya', 'Owens', 13, NULL, 'plane_7', '450-25-5617', 'United', 'n517ly', TRUE, FALSE),
	('p8', 'Bennie', 'Palmer', 12, NULL, 'plane_8', '701-38-2179', 'United', 'n620la', TRUE, FALSE),
	('p9', 'Marlene', 'Warner', 13, NULL, 'plane_8', '936-44-6941', 'United', 'n620la', TRUE, FALSE);


DROP TABLE IF EXISTS airport;
CREATE TABLE airport (
  airportID char(5) NOT NULL,
  airport_name char(100) NOT NULL, 
  city char(100) NOT NULL, 
  state char(5) NOT NULL, 
  locID char(15),
  PRIMARY KEY (airportID),
  CONSTRAINT fk15 FOREIGN KEY(locID) REFERENCES location (locID)
) ENGINE=InnoDB;

-- Inserting data for table airport
INSERT INTO airport VALUES
('ABQ', 'Albuquerque International Sunport', 'Albuquerque', 'NM', NULL),
('ANC', 'Ted Stevens Anchorage International Airport', 'Anchorage', 'AK', NULL),
('ATL', 'Hartsfield-Jackson Atlanta International Airport', 'Atlanta', 'GA', 'port_1'),
('BDL', 'Bradley International Airport', 'Hartford', 'CT', NULL),
('BFI', 'King County International Airport', 'Seattle', 'WA', 'port_10'),
('BHM', 'Birmingham‚ÄìShuttlesworth International Airport', 'Birmingham', 'AL', NULL),
('BNA', 'Nashville International Airport', 'Nashville', 'TN', NULL),
('BOI', 'Boise Airport', 'Boise', 'ID', NULL),
('BOS', 'General Edward Lawrence Logan International Airport', 'Boston', 'MA', NULL),
('BTV', 'Burlington International Airport', 'Burlington', 'VT', NULL),
('BWI', 'Baltimore_Washington International Airport', 'Baltimore', 'MD', NULL),
('BZN', 'Bozeman Yellowstone International Airport', 'Bozeman', 'MT', NULL),
('CHS', 'Charleston International Airport', 'Charleston', 'SC', NULL),
('CLE', 'Cleveland Hopkins International Airport', 'Cleveland', 'OH', NULL),
('CLT', 'Charlotte Douglas International Airport', 'Charlotte', 'NC', NULL),
('CRW', 'Yeager Airport', 'Charleston', 'WV', NULL),
('DAL', 'Dallas Love Field', 'Dallas', 'TX', 'port_7'),
('DCA', 'Ronald Reagan Washington National Airport', 'Washington', 'DC', 'port_9'),
('DEN', 'Denver International Airport', 'Denver', 'CO', 'port_3'),
('DFW', 'Dallas-Fort Worth International Airport', 'Dallas', 'TX', 'port_2'),
('DSM', 'Des Moines International Airport', 'Des Moines', 'IA', NULL),
('DTW', 'Detroit Metro Wayne County Airport', 'Detroit', 'MI', NULL),
('EWR', 'Newark Liberty International Airport', 'Newark', 'NJ', NULL),
('FAR', 'Hector International Airport', 'Fargo', 'ND', NULL),
('FSD', 'Joe Foss Field', 'Sioux Falls', 'SD', NULL),
('GSN', 'Saipan International Airport', 'Obyan Saipan Island', 'MP', NULL),
('GUM', 'Antonio B_Won Pat International Airport', 'Agana Tamuning', 'GU', NULL),
('HNL', 'Daniel K. Inouye International Airport', 'Honolulu Oahu', 'HI', NULL),
('HOU', 'William P_Hobby Airport', 'Houston', 'TX', 'port_18'),
('IAD', 'Washington Dulles International Airport', 'Washington', 'DC', 'port_11'),
('IAH', 'George Bush Intercontinental Houston Airport', 'Houston', 'TX', 'port_13'),
('ICT', 'Wichita Dwight D_Eisenhower National Airport ', 'Wichita', 'KS', NULL),
('ILG', 'Wilmington Airport', 'Wilmington', 'DE', NULL),
('IND', 'Indianapolis International Airport', 'Indianapolis', 'IN', NULL),
('ISP', 'Long Island MacArthur Airport', 'New York Islip', 'NY', 'port_14'),
('JAC', 'Jackson Hole Airport', 'Jackson', 'WY', NULL),
('JAN', 'Jackson_Medgar Wiley Evers International Airport', 'Jackson', 'MS', NULL),
('JFK', 'John F_Kennedy International Airport', 'New York', 'NY', 'port_15'),
('LAS', 'Harry Reid International Airport', 'Las Vegas', 'NV', NULL),
('LAX', 'Los Angeles International Airport', 'Los Angeles', 'CA', 'port_5'),
('LGA', 'LaGuardia Airport', 'New York', 'NY', NULL),
('LIT', 'Bill and Hillary Clinton National Airport', 'Little Rock', 'AR', NULL),
('MCO', 'Orlando International Airport', 'Orlando', 'FL', NULL),
('MDW', 'Chicago Midway International Airport', 'Chicago', 'IL', NULL),
('MHT', 'Manchester_Boston Regional Airport', 'Manchester', 'NH', NULL),
('MKE', 'Milwaukee Mitchell International Airport', 'Milwaukee', 'WI', NULL),
('MRI', 'Merrill Field', 'Anchorage', 'AK', NULL),
('MSP', 'Minneapolis_St_Paul International Wold_Chamberlain Airport', 'Minneapolis Saint Paul', 'MN', NULL),
('MSY', 'Louis Armstrong New Orleans International Airport', 'New Orleans', 'LA', NULL),
('OKC', 'Will Rogers World Airport', 'Oklahoma City', 'OK', NULL),
('OMA', 'Eppley Airfield', 'Omaha', 'NE', NULL),
('ORD', 'O_Hare International Airport', 'Chicago', 'IL', 'port_4'),
('PDX', 'Portland International Airport', 'Portland', 'OR', NULL),
('PHL', 'Philadelphia International Airport', 'Philadelphia', 'PA', NULL),
('PHX', 'Phoenix Sky Harbor International Airport', 'Phoenix', 'AZ', NULL),
('PVD', 'Rhode Island T_F_Green International Airport', 'Providence', 'RI', NULL),
('PWM', 'Portland International Jetport', 'Portland', 'ME', NULL),
('SDF', 'Louisville International Airport', 'Louisville', 'KY', NULL),
('SEA', 'Seattle‚ÄìTacoma International Airport', 'Seattle Tacoma', 'WA', 'port_17'),
('SJU', 'Luis Munoz Marin International Airport', 'San Juan Carolina', 'PR', NULL),
('SLC', 'Salt Lake City International Airport', 'Salt Lake City', 'UT', NULL),
('STL', 'St_Louis Lambert International Airport', 'Saint Louis', 'MO', NULL),
('STT', 'Cyril E_King Airport', 'Charlotte Amalie Saint Thomas', 'VI', NULL);


DROP TABLE IF EXISTS leg;
CREATE TABLE leg (
  legID char(10) NOT NULL, 
  distance int NOT NULL,
  depart_airportID char(5) NOT NULL,
  arrive_airportID char(5) NOT NULL,
  PRIMARY KEY (legID),   
  CONSTRAINT fk9 FOREIGN KEY(depart_airportID) REFERENCES airport (airportID),
  CONSTRAINT fk10 FOREIGN KEY(arrive_airportID) REFERENCES airport (airportID)
) ENGINE=InnoDB;

-- Inserting values into table leg

INSERT INTO leg VALUES
	('leg_4', 600, 'ATL', 'ORD'),
	('leg_18', 1200, 'LAX', 'DFW'),
	('leg_24', 1800, 'SEA', 'ORD'),
	('leg_23', 2400, 'SEA', 'JFK'),
	('leg_25', 600, 'ORD', 'ATL'),
	('leg_22', 800, 'ORD', 'LAX'),
	('leg_12', 200, 'IAH', 'DAL'),
	('leg_3', 800, 'ATL', 'JFK'),
	('leg_19', 1000, 'LAX', 'SEA'),
	('leg_21', 800, 'ORD', 'DFW'),
	('leg_16', 800, 'JFK', 'ORD'),
	('leg_17', 2400, 'JFK', 'SEA'),
	('leg_27', 1600, 'ATL', 'LAX'),
	('leg_10', 800, 'DFW', 'ORD'),
	('leg_20', 600, 'ORD', 'DCA'),
	('leg_9', 800, 'DFW', 'ATL'),
	('leg_26', 800, 'LAX', 'ORD'),
	('leg_6', 200, 'DAL', 'HOU'),
	('leg_7', 600, 'DCA', 'ATL'),
	('leg_8', 200, 'DCA', 'JFK'),
	('leg_1', 600, 'ATL', 'IAD'),
	('leg_11', 600, 'IAD', 'ORD'),
	('leg_13', 1400, 'IAH', 'LAX'),
	('leg_14', 2400, 'ISP', 'BFI'),
	('leg_15', 800, 'JFK', 'ATL'),
	('leg_2', 600, 'ATL', 'IAH'),
	('leg_5', 1000, 'BFI', 'LAX');

DROP TABLE IF EXISTS route;
CREATE TABLE route (
  routeID char(30) NOT NULL,
  PRIMARY KEY (routeID)
) ENGINE=InnoDB;

-- Inserting data for table route
INSERT INTO route VALUES
('circle_east_coast'),
('circle_west_coast'),
('eastbound_north_milk_run'),
('eastbound_north_nonstop'),
('eastbound_south_milk_run'),
('hub_xchg_southeast'),
('hub_xchg_southwest'),
('local_texas'),
('northbound_east_coast'),
('northbound_west_coast'),
('southbound_midwest'),
('westbound_north_milk_run'),
('westbound_north_nonstop'),
('westbound_south_nonstop');
  
DROP TABLE IF EXISTS flight;
CREATE TABLE flight (
  flightID char(10) NOT NULL,
  support_tail char(10),
  support_airline char(10),
  progress int,
  airplane_status char(15),
  next_time char(15),
  routeID char(30) NOT NULL,
  PRIMARY KEY (flightID),
  CONSTRAINT fk4 FOREIGN KEY(support_tail, support_airline) REFERENCES airplane (tail_num, airlineID),
  CONSTRAINT fk8 FOREIGN KEY(routeID) REFERENCES route (routeID)
) ENGINE=InnoDB;
  
-- Inserting data into table flight

INSERT INTO flight VALUES
('AM_1523', 'n330ss', 'American', 2, 'on_ground', '14:30:00', 'circle_west_coast'),
('DL_1174', 'n106js', 'Delta', 0, 'on_ground', '08:00:00', 'northbound_east_coast'),
('DL_1243', 'n110jn', 'Delta', 0, 'on_ground', '09:30:00', 'westbound_north_nonstop'),
('DL_3410', NULL, NULL, NULL, NULL, NULL, 'circle_east_coast'),
('SP_1880', 'n256ap', 'Spirit', 2, 'in_flight', '15:00:00', 'circle_east_coast'),
('SW_1776', 'n401fj', 'Southwest', 2, 'in_flight', '14:00:00', 'hub_xchg_southwest'),
('SW_610', 'n118fm', 'Southwest', 2, 'in_flight', '11:30:00', 'local_texas'),
('UN_1899', 'n517ly', 'United', 0, 'on_ground', '09:30:00', 'eastbound_north_milk_run'),
('UN_523', 'n620la', 'United', 1, 'in_flight', '11:00:00', 'hub_xchg_southeast'),
('UN_717', NULL, NULL, NULL, NULL, NULL, 'circle_west_coast');

DROP TABLE IF EXISTS ticket;
CREATE TABLE ticket (
  ticketID char(15) NOT NULL, 
  cost int, 
  deplane_airport char(5) NOT NULL,
  flightID char(10) NOT NULL,
  personID char(50) NOT NULL,
  PRIMARY KEY (ticketID),   
  CONSTRAINT fk5 FOREIGN KEY(deplane_airport) REFERENCES airport (airportID),
  CONSTRAINT fk6 FOREIGN KEY(flightID) REFERENCES flight (flightID),
  CONSTRAINT fk7 FOREIGN KEY(personID) REFERENCES person (personID)
) ENGINE=InnoDB;

-- INSERTING DATA INTO TABLE ticket
-- fix data

INSERT INTO ticket VALUES
	('tkt_dl_1', 450, 'JFK', 'DL_1174', 'p24'),
	('tkt_dl_2', 225, 'JFK', 'DL_1174', 'p25'),
	('tkt_am_3', 250, 'LAX', 'AM_1523', 'p26'),
	('tkt_un_4', 175, 'DCA', 'UN_1899', 'p27'),
	('tkt_un_5', 225, 'ATL', 'UN_523', 'p28'),
	('tkt_un_6', 100, 'ORD', 'UN_523', 'p29'),
	('tkt_sw_7', 400, 'ORD', 'SW_1776', 'p30'),
	('tkt_sw_8', 175, 'ORD', 'SW_1776', 'p31'),
	('tkt_sw_9', 125, 'HOU', 'SW_610', 'p32'),
	('tkt_sw_10', 425, 'HOU', 'SW_610', 'p33'),
	('tkt_dl_11', 500, 'LAX', 'DL_1243', 'p34'),
	('tkt_dl_12', 250, 'LAX', 'DL_1243', 'p35'),
	('tkt_sp_13', 225, 'ATL', 'SP_1880', 'p36'),
	('tkt_sp_14', 150, 'DCA', 'SP_1880', 'p37'),
	('tkt_un_15', 150, 'ORD', 'UN_523', 'p38'),
	('tkt_sp_16', 475, 'ATL', 'SP_1880', 'p39'),
	('tkt_am_17', 375, 'ORD', 'AM_1523', 'p40'),
	('tkt_am_18', 275, 'LAX', 'AM_1523', 'p41');
                       
# Multivalued Attributes
DROP TABLE IF EXISTS license;
CREATE TABLE license (
  personID char(50) NOT NULL,
  license char(15) NOT NULL,
  PRIMARY KEY (personID, license),
  CONSTRAINT fk2 FOREIGN KEY(personID) REFERENCES person (personID)
) ENGINE=InnoDB;

INSERT INTO license VALUES
('p1',	'jet'),
('p10',	'jet'),
('p11',	'jet'),
('p11',	'prop'),
('p12',	'prop'),
('p13',	'jet'),
('p14',	'jet'),
('p15',	'jet'),
('p15',	'prop'),
('p15',	'testing'),
('p16',	'jet'),
('p17',	'jet'),
('p17',	'prop'),
('p18',	'jet'),
('p19',	'jet'),
('p2', 'jet'),
('p2', 'prop'),
('p20',	'jet'),
('p21',	'jet'),
('p21',	'prop'),
('p22',	'jet'),
('p23',	'jet'),
('p24',	'jet'),
('p24',	'prop'),
('p24', 'testing'),
('p25', 'jet'),
('p26', 'jet'),
('p3', 'jet'),
('p4', 'jet'),
('p4', 'prop'),
('p5', 'jet'),
('p6', 'jet'),
('p6', 'prop'),
('p7', 'jet'),
('p8', 'prop'),
('p9', 'jet'),
('p9', 'prop'),
('p9', 'testing');


DROP TABLE IF EXISTS seat;
CREATE TABLE seat (
  ticketID char(15) NOT NULL,
  seat char(15) NOT NULL,
  PRIMARY KEY (ticketID, seat),
  CONSTRAINT fk3 FOREIGN KEY(ticketID) REFERENCES ticket (ticketID)
) ENGINE=InnoDB;

INSERT INTO seat VALUES
('tkt_dl_1', '1C'),
('tkt_dl_1', '2F'),
('tkt_dl_2', '2D'),
('tkt_am_3', '3B'),
('tkt_un_4', '2B'),
('tkt_un_5', '1A'),
('tkt_un_6', '3B'),
('tkt_sw_7', '3C'),
('tkt_sw_8', '3E'),
('tkt_sw_9', '1C'),
('tkt_sw_10', '1D'),
('tkt_dl_11', '1E'),
('tkt_dl_11', '1B'),
('tkt_dl_11', '2F'),
('tkt_dl_12', '2A'),
('tkt_sp_13', '1A'),
('tkt_sp_14', '2B'),
('tkt_un_15', '1B'),
('tkt_sp_16', '2C'),
('tkt_sp_16', '2E'),
('tkt_am_17', '2B'),
('tkt_am_18', '2A');

# M-N Relationships
DROP TABLE IF EXISTS route_contains;
CREATE TABLE route_contains (
  sequence int,
  legID char(10) NOT NULL,
  routeID char(30),
  PRIMARY KEY (sequence, legID, routeID),
  CONSTRAINT fk12 FOREIGN KEY(legID) REFERENCES leg (legID),
  CONSTRAINT fk13 FOREIGN KEY(routeID) REFERENCES route (routeID)
) ENGINE=InnoDB;

INSERT INTO route_contains VALUES
(1, 'leg_4', 'circle_east_coast'),
(2, 'leg_20', 'circle_east_coast'),
(3, 'leg_7', 'circle_east_coast'),
(1, 'leg_18', 'circle_west_coast'),
(2, 'leg_10', 'circle_west_coast'),
(3, 'leg_22', 'circle_west_coast'),
(1, 'leg_24', 'eastbound_north_milk_run'),
(2, 'leg_20', 'eastbound_north_milk_run'),
(3, 'leg_8', 'eastbound_north_milk_run'),
(1, 'leg_23', 'eastbound_north_nonstop'),
(1, 'leg_18', 'eastbound_south_milk_run'),
(2, 'leg_9', 'eastbound_south_milk_run'),
(3, 'leg_1', 'eastbound_south_milk_run'),
(1, 'leg_25', 'hub_xchg_southeast'),
(2, 'leg_4', 'hub_xchg_southeast'),
(1, 'leg_22', 'hub_xchg_southwest'),
(2, 'leg_26', 'hub_xchg_southwest'),
(1, 'leg_12', 'local_texas'),
(2, 'leg_6', 'local_texas'),
(1, 'leg_3', 'northbound_east_coast'),
(1, 'leg_19', 'northbound_west_coast'),
(1, 'leg_21', 'southbound_midwest'),
(1, 'leg_16', 'westbound_north_milk_run'),
(2, 'leg_22', 'westbound_north_milk_run'),
(3, 'leg_19', 'westbound_north_milk_run'),
(1, 'leg_17', 'westbound_north_nonstop'),
(1, 'leg_27', 'westbound_south_nonstop');
