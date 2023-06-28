-- CS4400: Introduction to Database Systems: Wednesday, March 8, 2023
-- Flight Management Course Project Mechanics (v1.0) STARTING SHELL
-- Views, Functions & Stored Procedures

/* This is a standard preamble for most of our scripts.  The intent is to establish
a consistent environment for the database behavior. */
set global transaction isolation level serializable;
set global SQL_MODE = 'ANSI,TRADITIONAL';
set names utf8mb4;
set SQL_SAFE_UPDATES = 0;
set @thisDatabase = 'flight_management';

use flight_management;
-- -----------------------------------------------------------------------------
-- stored procedures and views
-- -----------------------------------------------------------------------------
/* Standard Procedure: If one or more of the necessary conditions for a procedure to
be executed is false, then simply have the procedure halt execution without changing
the database state. Do NOT display any error messages, etc. */

-- [1] add_airplane()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airplane.  A new airplane must be sponsored
by an existing airline, and must have a unique tail number for that airline.
username.  An airplane must also have a non-zero seat capacity and speed. An airplane
might also have other factors depending on it's type, like skids or some number
of engines.  Finally, an airplane must have a database-wide unique location if
it will be used to carry passengers. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airplane;
delimiter //
create procedure add_airplane (in ip_airlineID varchar(50), in ip_tail_num varchar(50),
	in ip_seat_capacity integer, in ip_speed integer, in ip_locationID varchar(50),
    in ip_plane_type varchar(100), in ip_skids boolean, in ip_propellers integer,
    in ip_jet_engines integer)
sp_main: begin   
    # An airplane must have a non-zero and non-negative seat capacity and speed.
    if ip_speed <= 0 or ip_seat_capacity <= 0 then leave sp_main; end if;
    
    # A jet must have non-zero and non-negative jet engines
    if ip_plane_type like 'jet' and ip_jet_engines <= 0 then leave sp_main; end if;
    
    # A propeller plane must have non-zero and non-negative prop engines
    if ip_plane_type like 'prop' and ip_propellers <= 0 then leave sp_main; end if;
    
    # A plane must have non-negative skids
    if ip_skids < 0 then leave sp_main; end if;
    
    # If passing all cases, insert values
    insert into airplane values (ip_airlineID, ip_tail_num, ip_seat_capacity, ip_speed, ip_locationID, ip_plane_type, ip_skids, ip_propellers, ip_jet_engines);
end //
delimiter ;

-- [2] add_airport()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new airport.  A new airport must have a unique
identifier along with a database-wide unique location if it will be used to support
airplane takeoffs and landings.  An airport may have a longer, more descriptive
name.  An airport must also have a city and state designation. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_airport;
delimiter //
create procedure add_airport (in ip_airportID char(3), in ip_airport_name varchar(200),
    in ip_city varchar(100), in ip_state char(2), in ip_locationID varchar(50))
sp_main: begin    
    # Insert values
    insert into airport values (ip_airportID, ip_airport_name, ip_city, ip_state, ip_locationID);
end //
delimiter ;

-- [3] add_person()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new person.  A new person must reference a unique
identifier along with a database-wide unique location used to determine where the
person is currently located: either at an airport, or on an airplane, at any given
time.  A person may have a first and last name as well.

Also, a person can hold a pilot role, a passenger role, or both roles.  As a pilot,
a person must have a tax identifier to receive pay, and an experience level.  Also,
a pilot might be assigned to a specific airplane as part of the flight crew.  As a
passenger, a person will have some amount of frequent flyer miles. */
-- -----------------------------------------------------------------------------
drop procedure if exists add_person;
delimiter //
create procedure add_person (in ip_personID varchar(50), in ip_first_name varchar(100),
    in ip_last_name varchar(100), in ip_locationID varchar(50), in ip_taxID varchar(50),
    in ip_experience integer, in ip_flying_airline varchar(50), in ip_flying_tail varchar(50),
    in ip_miles integer)
sp_main: begin    
    # Checking for non-negative pilot experience and non-negative passenger miles constraints
	if (ip_experience is not null and ip_experience < 0) or (ip_miles is not null and ip_miles < 0) then leave sp_main; end if;
    
    # Inserting into person
    insert into person values (ip_personID, ip_first_name, ip_last_name, ip_locationID);
    
    # Inserting into pilot
    if ip_experience is not null and ip_taxID is not null then insert into pilot values (ip_personID, ip_taxID, ip_experience, ip_flying_airline, ip_flying_tail); end if;
    
    # Inserting into passenger
    if ip_miles is not null and ip_miles >= 0 then insert into passenger values (ip_personID, ip_miles); end if;
end //
delimiter ;

-- [4] grant_pilot_license()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new pilot license.  The license must reference
a valid pilot, and must be a new/unique type of license for that pilot. */
-- -----------------------------------------------------------------------------
drop procedure if exists grant_pilot_license;
delimiter //
create procedure grant_pilot_license (in ip_personID varchar(50), in ip_license varchar(100))
sp_main: begin
    # The inserted license must be a new/unique type of license for that pilot
    if ip_license in (select license from pilot_licenses where personID = ip_personID) then leave sp_main; end if;
	
	# Inserting into pilot_licenses
	insert into pilot_licenses values (ip_personID, ip_license);
end //
delimiter ;

-- [5] offer_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new flight.  The flight can be defined before
an airplane has been assigned for support, but it must have a valid route.  Once
an airplane has been assigned, we must also track where the airplane is along
the route, whether it is in flight or on the ground, and when the next action -
takeoff or landing - will occur. */
-- -----------------------------------------------------------------------------
drop procedure if exists offer_flight;
delimiter //
create procedure offer_flight (in ip_flightID varchar(50), in ip_routeID varchar(50),
    in ip_support_airline varchar(50), in ip_support_tail varchar(50), in ip_progress integer,
    in ip_airplane_status varchar(100), in ip_next_time time)
sp_main: begin
    # Needs to have both airline and tail number or neither
    if (ip_support_airline is null and ip_support_tail is not null) or (ip_support_airline is not null and ip_support_tail is null) then leave sp_main; end if;
    
    # Needs to have progress, status, and time if the airplane is assigned
    if (ip_support_airline is not null and ip_support_tail is not null) and (ip_progress is null or ip_airplane_status is null or ip_next_time is null) then leave sp_main; end if;
    
    # Insert into flight
    insert into flight values (ip_flightID, ip_routeID, ip_support_airline, ip_support_tail, ip_progress, ip_airplane_status, ip_next_time);
end //
delimiter ;

-- [6] purchase_ticket_and_seat()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new ticket.  The cost of the flight is optional
since it might have been a gift, purchased with frequent flyer miles, etc.  Each
flight must be tied to a valid person for a valid flight.  Also, we will make the
(hopefully simplifying) assumption that the departure airport for the ticket will
be the airport at which the traveler is currently located.  The ticket must also
explicitly list the destination airport, which can be an airport before the final
airport on the route.  Finally, the seat must be unoccupied. */
-- -----------------------------------------------------------------------------
drop procedure if exists purchase_ticket_and_seat;
delimiter //
create procedure purchase_ticket_and_seat (in ip_ticketID varchar(50), in ip_cost integer,
	in ip_carrier varchar(50), in ip_customer varchar(50), in ip_deplane_at char(3),
    in ip_seat_number varchar(50))
sp_main: begin
    # Finally, the seat must be unoccupied
    if ip_seat_number in (select seat_number from ticket_seats) then leave sp_main; end if;
    
    # Insert into ticket
    insert into ticket values (ip_ticketID, ip_cost, ip_carrier, ip_customer, ip_deplane_at);
    
    # Insert into ticket_seats
    insert into ticket_seats values (ip_ticketID, ip_seat_number);
end //
delimiter ;

-- [7] add_update_leg()
-- -----------------------------------------------------------------------------
/* This stored procedure creates a new leg as specified.  However, if a leg from
the departure airport to the arrival airport already exists, then don't create a
new leg - instead, update the existence of the current leg while keeping the existing
identifier.  Also, all legs must be symmetric.  If a leg in the opposite direction
exists, then update the distance to ensure that it is equivalent.   */
-- -----------------------------------------------------------------------------
drop procedure if exists add_update_leg;
delimiter //
create procedure add_update_leg (in ip_legID varchar(50), in ip_distance integer,
    in ip_departure char(3), in ip_arrival char(3))
sp_main: begin
    # Check for non-zero and non-negative distance
    if ip_distance <= 0 then leave sp_main; end if;
    
    # If a leg from the departure airport to the arrival airport already exists,
    # then update the existence of the current leg while keeping the existing identifier
    # If a leg in the opposite direction exists, then update the distance to ensure that it is equivalent
    if (ip_departure, ip_arrival) in (select departure, arrival from leg) then
    update leg set distance = ip_distance where (departure, arrival) = (ip_departure, ip_arrival);
    update leg set distance = ip_distance where (departure, arrival) = (ip_arrival, ip_departure);
    leave sp_main;
    end if;
    
    # Insert into leg otherwise
    insert into leg values (ip_legID, ip_distance, ip_departure, ip_arrival);
end //
delimiter ;

-- [8] start_route()
-- -----------------------------------------------------------------------------
/* This stored procedure creates the first leg of a new route.  Routes in our
system must be created in the sequential order of the legs.  The first leg of
the route can be any valid leg. */
-- -----------------------------------------------------------------------------
drop procedure if exists start_route;
delimiter //
create procedure start_route (in ip_routeID varchar(50), in ip_legID varchar(50))
sp_main: begin
    # Insert into route
    insert into route values (ip_routeID);
    
    # Insert into route path
    insert into route_path values (ip_routeID, ip_legID, 1);
end //
delimiter ;

-- [9] extend_route()
-- -----------------------------------------------------------------------------
/* This stored procedure adds another leg to the end of an existing route.  Routes
in our system must be created in the sequential order of the legs, and the route
must be contiguous: the departure airport of this leg must be the same as the
arrival airport of the previous leg. */
-- -----------------------------------------------------------------------------
drop procedure if exists extend_route;
delimiter //
create procedure extend_route (in ip_routeID varchar(50), in ip_legID varchar(50))
sp_main: begin
	# Declare local variables to be used later
    declare departure char(3);
    declare previous_arrival char(3);
    declare previous_sequence int;

    # Find the departure airport
    set departure = (select departure from leg where legID = ip_legID);
    
    # Find the previous sequence number
    set previous_sequence = (select max(sequence) from route_path where routeID = ip_routeID group by routeID);
    
    # Find the arrival airport of the last leg of a route path
    set previous_arrival = (select arrival from leg where legID = 
								(select legID from (select * from route_path where routeID = ip_routeID) as leg where sequence = previous_sequence)
							);
    
    # Check for sequential order
    if departure not like previous_arrival then leave sp_main; end if;
    
    # Insert into route_path if passes the case above
    insert into route_path values (ip_routeID, ip_legID, previous_sequence + 1);
end //
delimiter ;

-- [10] flight_landing()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight landing at the next airport
along it's route.  The time for the flight should be moved one hour into the future
to allow for the flight to be checked, refueled, restocked, etc. for the next leg
of travel.  Also, the pilots of the flight should receive increased experience, and
the passengers should have their frequent flyer miles updated. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_landing;
delimiter //
create procedure flight_landing (in ip_flightID varchar(50))
sp_main: begin
	# Declare variables
    declare ip_legID varchar(50);
    declare ip_distance int;
    declare ip_airline varchar(50);
    declare ip_tail_num varchar(50);
    declare ip_locationID varchar(50);
    
    # Change state of flight to on_ground and set the time for the flight one hour into the future
    update flight set airplane_status = 'on_ground', next_time = addtime(next_time, '01:00:00') where flightID = ip_flightID;
    
    # Find the leg that was just traversed
    set ip_legID = (select legID from route_path where (routeID, sequence) = (select routeID, progress from flight where flightID = ip_flightID));
    
    # Find the distance traveled on the leg
    set ip_distance = (select distance from leg where legID = ip_legID);
    
    # Find the airline and tail number to find the plane
    set ip_airline = (select support_airline from flight where flightID = ip_flightID);
    set ip_tail_num = (select support_tail from flight where flightID = ip_flightID);
    
    # Find the location so you can identify passengers
    set ip_locationID = (select locationID from airplane where airlineID = ip_airline and tail_num = ip_tail_num);
    
    # The pilots of the flight should receive increased experience
	update pilot set experience = experience + 1 where flying_airline = ip_airline and flying_tail = ip_tail_num;
    
    # The passengers should have their frequent flyer miles updated using this leg
    update passenger set miles = miles + ip_distance where personID in (select personID from person where locationID = ip_locationID);
end //
delimiter ;

-- [11] flight_takeoff()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for a flight taking off from its current
airport towards the next airport along it's route.  The time for the next leg of
the flight must be calculated based on the distance and the speed of the airplane.
And we must also ensure that propeller driven planes have at least one pilot
assigned, while jets must have a minimum of two pilots. If the flight cannot take
off because of a pilot shortage, then the flight must be delayed for 30 minutes. */
-- -----------------------------------------------------------------------------
drop procedure if exists flight_takeoff;
delimiter //
create procedure flight_takeoff (in ip_flightID varchar(50))
sp_main: begin
	# Declare variables
    declare ip_airline varchar(50);
    declare ip_tail_num varchar(50);
    declare num_pilots int;
    declare ip_routeID varchar(50);
    declare ip_progress int;
    declare next_leg varchar(50);
    declare travel_time decimal;
    
    # Find the airline and tail number to find the plane
    set ip_airline = (select support_airline from flight where flightID = ip_flightID);
    set ip_tail_num = (select support_tail from flight where flightID = ip_flightID);
    
    # Find number of pilots
    set num_pilots = (select count(*) from pilot where flying_airline = ip_airline and flying_tail = ip_tail_num group by flying_airline, flying_tail);
    
    # Propeller plane check pilot shortage
    if (select plane_type from airplane where airlineID = ip_airline and tail_num = ip_tail_num) like 'prop' and num_pilots < 1 then
    update flight set next_time = addtime(next_time, '00:30:00') where flightID = ip_flightID;
    leave sp_main;
    end if;
    
    # Jet plane check pilot shortage
    if (select plane_type from airplane where airlineID = ip_airline and tail_num = ip_tail_num) like 'jet' and num_pilots < 2 then
    update flight set next_time = addtime(next_time, '00:30:00') where flightID = ip_flightID;
    leave sp_main;
    end if;
    
    # Find the route and the current progress
    set ip_routeID = (select routeID from flight where flightID = ip_flightID);
    set ip_progress = (select progress from flight where flightID = ip_flightID);
    
    # If the next leg doesn't exist, leave
    if ip_progress + 1 > (select max(sequence) from route_path where routeID = ip_routeID) then leave sp_main; end if;
    
    # Otherwise find the next leg
    set next_leg = (select legID from route_path where routeID = ip_routeID and sequence = ip_progress + 1);
    
    # Calculate time (in seconds) needed for next leg
    set travel_time = (select distance from leg where legID = next_leg) / (select speed from airplane where airlineID = ip_airline and tail_num = ip_tail_num) * 3600;
    
    # Add time and change flight status
    update flight set progress = progress + 1, airplane_status = 'in_flight', next_time = addtime(next_time, sec_to_time(travel_time)) where flightID = ip_flightID;
end //
delimiter ;

-- [12] passengers_board()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting on a flight at
its current airport.  The passengers must be at the airport and hold a valid ticket
for the flight. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_board;
delimiter //
create procedure passengers_board (in ip_flightID varchar(50))
sp_main: begin
	# Declare variables
    declare ip_airline varchar(50);
    declare ip_tail_num varchar(50);
    declare ip_airplane_locationID varchar(50);
    declare ip_routeID varchar(50);
    declare ip_progress int;
    declare ip_legID varchar(50);
    declare ip_airportID varchar(3);
    declare ip_airport_locationID varchar(50);
    
    # Check if the plane is on the ground, leave if not
    if (select airplane_status from flight where flightID = ip_flightID) not like 'on_ground' then leave sp_main; end if;
    
    # Find the route and the current progress
    set ip_routeID = (select routeID from flight where flightID = ip_flightID);
    set ip_progress = (select progress from flight where flightID = ip_flightID);
    
    # Edge case of progress = 0, find leg traversed and current airport
    if ip_progress = 0
		then
        set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = 1);
		set ip_airportID = (select departure from leg where legID = ip_legID);
        end if;
	
    # Finding leg traversed and current airport otherwise
	if ip_progress > 0
		then
		set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = ip_progress);
		set ip_airportID = (select arrival from leg where legID = ip_legID);
        end if;
	
    # Find the current airport locationID using the leg that was found
    set ip_airport_locationID = (select locationID from airport where airportID = ip_airportID);
    
    # Find the airline and tail number
    set ip_airline = (select support_airline from flight where flightID = ip_flightID);
    set ip_tail_num = (select support_tail from flight where flightID = ip_flightID);
    
    # Find the airplane location ID
    set ip_airplane_locationID = (select locationID from airplane where airlineID = ip_airline and tail_num = ip_tail_num);
    
    # Update person location if they are at the airport and they are holding a valid ticket
    # Also check if the ticket's deplaning airport is within the airports along the rest of the route
    update person set locationID = ip_airplane_locationID
    where
    locationID = ip_airport_locationID
    and
    personID in (select customer from ticket
		where
			carrier = ip_flightID
			and
			deplane_at in (select arrival from route_path as r join leg as l on r.legID = l.legID where routeID = ip_routeID and sequence >= ip_progress + 1)
        );
end //
delimiter ;

-- [13] passengers_disembark()
-- -----------------------------------------------------------------------------
/* This stored procedure updates the state for passengers getting off of a flight
at its current airport.  The passengers must be on that flight, and the flight must
be located at the destination airport as referenced by the ticket. */
-- -----------------------------------------------------------------------------
drop procedure if exists passengers_disembark;
delimiter //
create procedure passengers_disembark (in ip_flightID varchar(50))
sp_main: begin
	# Declare variables
    declare ip_airline varchar(50);
    declare ip_tail_num varchar(50);
    declare ip_airplane_locationID varchar(50);
    declare ip_routeID varchar(50);
    declare ip_progress int;
    declare ip_legID varchar(50);
    declare ip_airportID varchar(3);
    declare ip_airport_locationID varchar(50);
    
    # Check if the plane is on the ground, leave if not
    if (select airplane_status from flight where flightID = ip_flightID) not like 'on_ground' then leave sp_main; end if;
    
    # Find the route and the current progress, then use those to find the leg that was just traversed
    set ip_routeID = (select routeID from flight where flightID = ip_flightID);
    set ip_progress = (select progress from flight where flightID = ip_flightID);
    
    # Edge case of progress = 0, find leg traversed and current airport
    if ip_progress = 0
		then
        set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = 1);
		set ip_airportID = (select departure from leg where legID = ip_legID);
        end if;
	
    # Finding leg traversed and current airport otherwise
	if ip_progress > 0
		then
		set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = ip_progress);
		set ip_airportID = (select arrival from leg where legID = ip_legID);
        end if;
    
	# Find the current airport locationID using the leg that was found
    set ip_airport_locationID = (select locationID from airport where airportID = ip_airportID);
    
    # Find the airline and tail number
    set ip_airline = (select support_airline from flight where flightID = ip_flightID);
    set ip_tail_num = (select support_tail from flight where flightID = ip_flightID);
    
    # Find the airplane location ID
    set ip_airplane_locationID = (select locationID from airplane where airlineID = ip_airline and tail_num = ip_tail_num);
    
    # Update person location if they are on the plane and they deplane at the current airport
    update person set locationID = ip_airport_locationID
    where
    locationID = ip_airplane_locationID
    and
    personID in (select customer from ticket where carrier = ip_flightID and deplane_at = ip_airportID);
end //
delimiter ;

-- [14] assign_pilot()
-- -----------------------------------------------------------------------------
/* This stored procedure assigns a pilot as part of the flight crew for a given
airplane.  The pilot being assigned must have a license for that type of airplane,
and must be at the same location as the flight.  Also, a pilot can only support
one flight (i.e. one airplane) at a time.  The pilot must be assigned to the flight
and have their location updated for the appropriate airplane. */
-- -----------------------------------------------------------------------------
drop procedure if exists assign_pilot;
delimiter //
create procedure assign_pilot (in ip_flightID varchar(50), ip_personID varchar(50))
sp_main: begin
	# Declare variables
    declare pilot_location varchar(50);
    declare airport_location varchar(50);
    declare plane_location varchar(50);
    declare ip_airline varchar(50);
    declare ip_tail_num varchar(50);
    declare ip_plane_type varchar(100);
    declare ip_routeID varchar(50);
    declare ip_progress int;
    declare ip_legID varchar(50);
    declare ip_airportID varchar(3);
    
    # Check if the pilot is already assigned or not, leave if so
    if (select flying_airline from pilot where personID = ip_personID) is not null or (select flying_tail from pilot where personID = ip_personID) is not null
    then leave sp_main; end if;
    
    # Find the airline and tail number, and then find the type of airplane
    set ip_airline = (select support_airline from flight where flightID = ip_flightID);
    set ip_tail_num = (select support_tail from flight where flightID = ip_flightID);
    set ip_plane_type = (select plane_type from airplane where airlineID = ip_airline and tail_num = ip_tail_num);
    
    # Check if the pilot has the correct license, leave if not
    if ip_plane_type not in (select license from pilot_licenses where personID = ip_personID)
    then leave sp_main; end if;
    
    # Find the route and the current progress, then use those to find the leg that was just traversed
    set ip_routeID = (select routeID from flight where flightID = ip_flightID);
    set ip_progress = (select progress from flight where flightID = ip_flightID);
    
    # Edge case of progress = 0, find leg traversed and current airport
    if ip_progress = 0
		then
        set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = 1);
		set ip_airportID = (select departure from leg where legID = ip_legID);
        end if;
	
    # Finding leg traversed and current airport otherwise
	if ip_progress > 0
		then
		set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = ip_progress);
		set ip_airportID = (select arrival from leg where legID = ip_legID);
        end if;
    
	# Find the current airport and airport locationID using the leg that was found
    set airport_location = (select locationID from airport where airportID = ip_airportID);
    
    # Find pilot location and compare with airport location to see if it matches and is valid, leave if not
    set pilot_location = (select locationID from person where personID = ip_personID);
    if airport_location not like pilot_location then leave sp_main; end if;
    
	# Find the airplane location ID
    set plane_location = (select locationID from airplane where airlineID = ip_airline and tail_num = ip_tail_num);
    
    # If passing all the tests, update person table location and pilot table plane assignment
	update person set locationID = plane_location where personID = ip_personID;
    update pilot set flying_airline = ip_airline, flying_tail = ip_tail_num where personID = ip_personID;
end //
delimiter ;

-- [15] recycle_crew()
-- -----------------------------------------------------------------------------
/* This stored procedure releases the assignments for a given flight crew.  The
flight must have ended, and all passengers must have disembarked. */
-- -----------------------------------------------------------------------------
drop procedure if exists recycle_crew;
delimiter //
create procedure recycle_crew (in ip_flightID varchar(50))
sp_main: begin
	# Declare variables
	declare ip_airline varchar(50);
    declare ip_tail_num varchar(50);
    declare ip_plane_locationID varchar(50);
    declare ip_routeID varchar(50);
    declare ip_progress int;
    declare ip_legID varchar(50);
    declare ip_airportID varchar(3);
    declare ip_airport_locationID varchar(50);
    
    # Check if the flight is landed
    if (select airplane_status from flight where flightID = ip_flightID) not like 'on_ground' then leave sp_main; end if;
    
    # Check if the passengers are all disembarked
		# Find the airline and tail number, and then find the airplane location ID
		set ip_airline = (select support_airline from flight where flightID = ip_flightID);
		set ip_tail_num = (select support_tail from flight where flightID = ip_flightID);
        # Find the airplane location ID
		set ip_plane_locationID = (select locationID from airplane where airlineID = ip_airline and tail_num = ip_tail_num);
	if exists
		(select personID from person
        where
			locationID = ip_plane_locationID
            and
			personID not in (select personID from pilot where flying_airline = ip_airline and flying_tail = ip_tail_num))
        then leave sp_main; end if;

	# If passing all tests, update person table location to the airport and null the pilot table plane assignment
		# Find the route and the current progress, then use those to find the leg that was just traversed
		set ip_routeID = (select routeID from flight where flightID = ip_flightID);
		set ip_progress = (select progress from flight where flightID = ip_flightID);
        
        # Edge case of progress = 0, find leg traversed and current airport
		if ip_progress = 0
			then
			set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = 1);
			set ip_airportID = (select departure from leg where legID = ip_legID);
			end if;
	
		# Finding leg traversed and current airport otherwise
		if ip_progress > 0
			then
			set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = ip_progress);
			set ip_airportID = (select arrival from leg where legID = ip_legID);
			end if;

		# Find the current airport locationID using the leg that was found
		set ip_airport_locationID = (select locationID from airport where airportID = ip_airportID);
        
    update person set locationID = ip_airport_locationID
		where personID in (select personID from pilot where flying_airline = @ip_airline and flying_tail = @ip_tail_num);
    update pilot set flying_airline = null, flying_tail = null
		where flying_airline = @ip_airline and flying_tail = @ip_tail_num;
end //
delimiter ;

-- [16] retire_flight()
-- -----------------------------------------------------------------------------
/* This stored procedure removes a flight that has ended from the system.  The
flight must be on the ground, and either be at the start its route, or at the
end of its route.  */
-- -----------------------------------------------------------------------------
drop procedure if exists retire_flight;
delimiter //
create procedure retire_flight (in ip_flightID varchar(50))
sp_main: begin
	# Declare variables
    declare ip_routeID varchar(50);
    
    # Check if the flight is on the ground
    if (select airplane_status from flight where flightID = ip_flightID) not like 'on_ground' then leave sp_main; end if;
    
    # Find routeID of the flight
    set ip_routeID = (select routeID from flight where flightID = ip_flightID);
    
    # If flight is on progress of 0 or of the max sequence, then retire the flight 
    if
		(select progress from flight where flightID = ip_flightID) = 0
        or 
		(select progress from flight where flightID = ip_flightID) = (select max(sequence) from route_path group by routeID having routeID = ip_routeID)
	then
		delete from flight where flightID = ip_flightID;
	end if;
end //
delimiter ;

-- [17] remove_passenger_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes the passenger role from person.  The passenger
must be on the ground at the time; and, if they are on a flight, then they must
disembark the flight at the current airport.  If the person had both a pilot role
and a passenger role, then the person and pilot role data should not be affected.
If the person only had a passenger role, then all associated person data must be
removed as well. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_passenger_role;
delimiter //
create procedure remove_passenger_role (in ip_personID varchar(50))
sp_main: begin
	# Declare variables
	declare ip_passenger_locationID varchar(50);
	declare ip_airport_locationID varchar(50);
    declare ip_airlineID varchar(50);
    declare ip_tail_num varchar(50);
    declare ip_flightID varchar(50);
    declare ip_routeID varchar(50);
    declare ip_progress int;
    declare ip_legID varchar(50);
    declare ip_airportID char(3);
    
    # Check if the person is a passenger at all
    if ip_personID not in (select personID from passenger) then leave sp_main; end if;
    
    # Find passenger location
    set ip_passenger_locationID = (select locationID from person where personID = ip_personID);
    
    # If passenger is on a flight, the plane must be on the ground and they must disembark at the current airport
    if ip_passenger_locationID in (select locationID from airplane)
    then
		# Find the current airport
			# Find the airplane, and use it to find the current flight
            set ip_airlineID = (select airlineID from airplane where locationID = ip_passenger_locationID);
			set ip_tail_num = (select tail_num from airplane where locationID = ip_passenger_locationID);
            set ip_flightID = (select flightID from flight where support_airline = ip_airlineID and support_tail = ip_tail_num);
            
            # If plane is in the air, leave the procedure
            if (select airplane_status from flight where support_airline = ip_airlineID and support_tail = ip_tail_num) like 'in_flight' then leave sp_main; end if;
        
			# Find the the route and the current progress, then use those to find the leg that was just traversed
			set ip_routeID = (select routeID from flight where flightID = ip_flightID);
			set ip_progress = (select progress from flight where flightID = ip_flightID);
            
				# Edge case of progress = 0, find leg traversed and current airport
				if ip_progress = 0
					then
					set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = 1);
					set ip_airportID = (select departure from leg where legID = ip_legID);
					end if;
	
				# Finding leg traversed and current airport otherwise
				if ip_progress > 0
					then
					set ip_legID = (select legID from route_path where routeID = ip_routeID and sequence = ip_progress);
					set ip_airportID = (select arrival from leg where legID = ip_legID);
					end if;
    
			# Find the current airport and airport locationID using the leg that was found
			set ip_airport_locationID = (select locationID from airport where airportID = ip_airportID);
            
            # Change person location to airport locationID
            update person set locationID = ip_airport_locationID where personID = ip_personID;
	end if;

	# If person is a pilot, remove passenger role and leave
    if ip_personID in (select personID from pilot) then
		delete from passenger where personID = ip_personID;
        leave sp_main;
	end if;
    
    # If person is not a pilot, remove everything
    delete from passenger where personID = ip_personID;
    delete from person where personID = ip_personID;
end //
delimiter ;

-- [18] remove_pilot_role()
-- -----------------------------------------------------------------------------
/* This stored procedure removes the pilot role from person.  The pilot must not
be assigned to a flight; or, if they are assigned to a flight, then that flight
must either be at the start or end of its route.  If the person had both a pilot
role and a passenger role, then the person and passenger role data should not be
affected.  If the person only had a pilot role, then all associated person data
must be removed as well. */
-- -----------------------------------------------------------------------------
drop procedure if exists remove_pilot_role;
delimiter //
create procedure remove_pilot_role (in ip_personID varchar(50))
sp_main: begin
	# Declare variables
	declare ip_pilot_locationID varchar(50);
    declare ip_airlineID varchar(50);
    declare ip_tail_num varchar(50);
    declare ip_flightID varchar(50);
    declare ip_routeID varchar(50);
    declare ip_progress int;

	# Check if the person is a pilot in the first place
    if ip_personID not in (select personID from pilot) then leave sp_main; end if;
    
    # Find pilot location
    set ip_pilot_locationID = (select locationID from person where personID = ip_personID);
    
    # Check if pilot is assigned to flight
    if exists (select flying_airline, flying_tail from pilot where personID = ip_personID) then
		# Find the airplane, and use it to find the current flight
		set ip_airlineID = (select airlineID from airplane where locationID = ip_pilot_locationID);
		set ip_tail_num = (select tail_num from airplane where locationID = ip_pilot_locationID);
		set ip_flightID = (select flightID from flight where support_airline = ip_airlineID and support_tail = ip_tail_num);
        
        # Check if flight is on the ground, leave if it isn't
        if (select airplane_status from flight where support_airline = ip_airlineID and support_tail = ip_tail_num) not like 'on_ground' then leave sp_main; end if;
        
        # Find the route and progress of the flight
        set ip_routeID = (select routeID from flight where flightID = ip_flightID);
		set ip_progress = (select progress from flight where flightID = ip_flightID);
        
        # Check if flight is at start or at end, leave if not
        if ip_progress != 0 and ip_progress != (select max(sequence) from route_path group by routeID having routeID = ip_routeID)
			then leave sp_main; end if;
	end if;
        
    # If person is a passenger, remove pilot and licenses and leave
    if ip_personID in (select personID from passenger) then
		delete from pilot_licenses where personID = ip_personID;
        delete from pilot where personID = ip_personID;
        leave sp_main;
        end if;
    
    # If person is not a passenger, remove everything
	delete from pilot_licenses where personID = ip_personID;
	delete from pilot where personID = ip_personID;
    delete from person where personID = ip_personID;

end //
delimiter ;

-- [19] flights_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently airborne are located. */
-- -----------------------------------------------------------------------------
create or replace view flights_in_the_air as
with flight_counts as (
  select departure, arrival, count(*) as num_flights
  from leg
  group by departure, arrival
)
select l.departure, l.arrival, fc.num_flights, f.flightID, min(f.next_time), max(f.next_time), a.locationID
from airplane a
join flight f on a.tail_num = f.support_tail
join route_path rp on f.routeID = rp.routeID and f.progress = rp.sequence and f.progress > 0
join leg l on rp.legID = l.legID
join flight_counts fc on l.departure = fc.departure and l.arrival = fc.arrival
where f.airplane_status = 'in_flight'
group by l.departure, l.arrival, f.flightID, a.locationID;
end //
delimiter ;

-- [20] flights_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where flights that are currently on the ground are located. */
-- -----------------------------------------------------------------------------
create or replace view flights_on_the_ground as 
with flight_counts as (
  select l.departure, count(*) as num_flights
  from airplane a
  join flight f on a.tail_num = f.support_tail
  join route_path rp on f.routeID = rp.routeID and rp.sequence = f.progress + 1
  join leg l on rp.legID = l.legID
  where f.airplane_status = 'on_ground'
  group by l.departure
)
select l.departure, fc.num_flights, f.flightID, min(f.next_time), max(f.next_time), a.locationID
from airplane a
join flight f on a.tail_num = f.support_tail
join route_path rp on f.routeID = rp.routeID and rp.sequence = f.progress + 1
join leg l on rp.legID = l.legID
join flight_counts fc on l.departure = fc.departure
where f.airplane_status = 'on_ground'
group by l.departure, f.flightID, a.locationID;
end //
delimiter ;

-- [21] people_in_the_air()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently airborne are located. */
-- -----------------------------------------------------------------------------
create or replace view people_in_the_air (departing_from, arriving_at, num_airplanes,
	airplane_list, flight_list, earliest_arrival, latest_arrival, num_pilots,
	num_passengers, joint_pilots_passengers, person_list) as
select
	l.departure as departing_from,
    l.arrival as arrive_at,
    count(distinct a.locationID) as num_airplanes,
    a.locationID as airplane_list,
    f.flightID as flight_list,
    min(f.next_time) as earliest_arrival,
    max(f.next_time) as latest_arrival,
    count(distinct p.personID) as num_pilots,
    count(distinct pa.personID) as num_passengers,
    count(distinct p.personID) + count(distinct pa.personID) as joint_pilots_passengers,
    group_concat(distinct pe.personID) as person_list
from airplane a
	left outer join flight f on a.tail_num = f.support_tail
	left outer join route_path rp on f.routeID = rp.routeID and f.progress = rp.sequence
	left outer join leg l on rp.legID = l.legID
	left outer join pilot_licenses pl on pl.license = a.plane_type
	left outer join pilot p on p.personID = pl.personID and p.flying_tail = a.tail_num
	left outer join person pe on pe.locationID = a.locationID
	left outer join passenger pa on pa.personID = pe.personID
	left outer join ticket t on t.customer = pa.personID
	left outer join ticket_seats ts on ts.ticketID = t.ticketID 
where f.airplane_status = 'in_flight'
group by l.departure, l.arrival, f.flightID, a.locationID;
end //
delimiter ;

-- [22] people_on_the_ground()
-- -----------------------------------------------------------------------------
/* This view describes where people who are currently on the ground are located. */
-- -----------------------------------------------------------------------------
create or replace view people_on_the_ground (departing_from, airport, airport_name,
	city, state, num_pilots, num_passengers, joint_pilots_passengers, person_list) as
select
	airport.airportID as departing_from,
    airport.locationID as airport,
    airport.airport_name,
    airport.city,
    airport.state,
    count(pilot.personID),
    count(passenger.personID),
    count(person.personID),
    group_concat(person.personID)
from airport
	left outer join person on airport.locationID = person.locationID
    left outer join pilot on person.personID = pilot.personID
    left outer join passenger on person.personID = passenger.personID
group by airport.airportID, airport.locationID, airport_name, airport.city, airport.state
having count(person.personID) > 0;
end //
delimiter ;

-- [23] route_summary()
-- -----------------------------------------------------------------------------
/* This view describes how the routes are being utilized by different flights. */
-- -----------------------------------------------------------------------------
create or replace view route_summary (route, num_legs, leg_sequence, route_length,
	num_flights, flight_list, airport_sequence) as
SELECT 
    rp.routeID,
    COUNT(DISTINCT rp.legID) AS num_legs,
    GROUP_CONCAT(DISTINCT rp.legID ORDER BY rp.sequence ASC) AS leg_sequence,
    (SELECT SUM(l.distance) 
     FROM leg l 
     WHERE l.legID IN (SELECT rrp.legID FROM route_path rrp WHERE rrp.routeID = rp.routeID)
    ) AS total_distance,
    COUNT(DISTINCT f.flightID) AS num_flights,
    GROUP_CONCAT(DISTINCT f.flightID) AS flightIDs,
    GROUP_CONCAT(DISTINCT CONCAT_WS(' -> ', dep.airportID, arr.airportID) ORDER BY rp.sequence ASC) AS airport_sequence
FROM 
    route_path rp
    INNER JOIN leg l ON rp.legID = l.legID
    left outer join flight f ON rp.routeID = f.routeID
    INNER JOIN airport a ON l.departure = a.airportID OR l.arrival = a.airportID
    INNER JOIN airport dep ON l.departure = dep.airportID
    INNER JOIN airport arr ON l.arrival = arr.airportID
GROUP BY 
    rp.routeID;
end //
delimiter ;

-- [24] alternative_airports()
-- -----------------------------------------------------------------------------
/* This view displays airports that share the same city and state. */
-- -----------------------------------------------------------------------------
create or replace view alternative_airports (city, state, num_airports,
	airport_code_list, airport_name_list) as
SELECT city, state, COUNT(*) AS num_airports, GROUP_CONCAT(airportID ORDER BY airportID ASC) AS airport_code_list,
	GROUP_CONCAT(airport_name ORDER BY airportID ASC) AS airport_name_list
FROM airport as a
GROUP BY city, state
HAVING COUNT(*) > 1;
end //
delimiter ;

-- [25] simulation_cycle()
-- -----------------------------------------------------------------------------
/* This stored procedure executes the next step in the simulation cycle.  The flight
with the smallest next time in chronological order must be identified and selected.
If multiple flights have the same time, then flights that are landing should be
preferred over flights that are taking off.  Similarly, flights with the lowest
identifier in alphabetical order should also be preferred.

If an airplane is in flight and waiting to land, then the flight should be allowed
to land, passengers allowed to disembark, and the time advanced by one hour until
the next takeoff to allow for preparations.

If an airplane is on the ground and waiting to takeoff, then the passengers should
be allowed to board, and the time should be advanced to represent when the airplane
will land at its next location based on the leg distance and airplane speed.

If an airplane is on the ground and has reached the end of its route, then the
flight crew should be recycled to allow rest, and the flight itself should be
retired from the system. */
-- -----------------------------------------------------------------------------
drop procedure if exists simulation_cycle;
delimiter //
create procedure simulation_cycle ()
sp_main: begin
	# Declare variables
    declare priority_flightID varchar(50);
    declare ip_routeID varchar(50);
    declare ip_progress int;
    
    # Find the flight that should be dealt with first with regards to sort by minimum time, sort first by in_flight, then sort by alphabet
    set priority_flightID =
		(select flightID from flight
		where airplane_status is not null
		order by next_time, airplane_status, flightID
		limit 1);
            
	# If landing, use flight_landing()
    if (select airplane_status from flight where flightID = priority_flightID) like 'in_flight'
    then call flight_landing(priority_flightID);
    end if;
    
    # If taking off, use flight_takeoff()
    if (select airplane_status from flight where flightID = priority_flightID) like 'on_ground'
    then call flight_takeoff(priority_flightID);
    end if;
    
	# Find the route and progress of the flight
	set ip_routeID = (select routeID from flight where flightID = priority_flightID);
	set ip_progress = (select progress from flight where flightID = priority_flightID);
        
	# Check if flight is at end of route, use recycle_crew() and retire_flight() if so
	if
		ip_progress = (select max(sequence) from route_path group by routeID having routeID = ip_routeID)
		and
		(select airplane_status from flight where flightID = priority_flightID) like 'on_ground'
	then
		call recycle_crew(priority_flightID);
        call retire_flight(priority_flightID);
    end if;
end //
delimiter ;
