DROP DATABASE IF EXISTS HOTEL;
CREATE DATABASE HOTEL;
USE HOTEL;

DROP TABLE IF EXISTS User;
DROP TABLE IF EXISTS RoomType;
DROP TABLE IF EXISTS Room;
DROP TABLE IF EXISTS Booking;
DROP TABLE IF EXISTS BookingRecord;


CREATE TABLE User
(
    uID INT AUTO_INCREMENT,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    phone VARCHAR(15),
    age INT,
    PRIMARY KEY (uID)
);


CREATE TABLE RoomType (
    typeName VARCHAR(45),
    price INT,
    bedSize VARCHAR(15),
    numBeds INT,
    max_occupants INT,
    PRIMARY KEY(typeName)
);


CREATE TABLE Room
(
    rID INT,
    floorNumber INT,
    typeName VARCHAR(45),
    reserved BOOLEAN DEFAULT FALSE,
    smokeFree BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (rID),
    FOREIGN KEY (typeName) REFERENCES RoomType(typeName)
);


CREATE TABLE Booking
(
    uID INT,
    rID INT,
    startDate DATE,
    endDate DATE,
    deposit BOOLEAN,
    PRIMARY KEY (uID, rID, startDate),
    FOREIGN KEY (rID) REFERENCES Room (rID),
    FOREIGN KEY (uID) REFERENCES User (uID)
);


CREATE TABLE BookingRecord
(
    uID INT,
    rID INT,
    startDate DATE,
    endDate DATE,
    PRIMARY KEY(uID, rID, startDate),
    FOREIGN KEY(uID) REFERENCES user(uID),
    FOREIGN KEY(rID) REFERENCES room(rID)
);


DROP TRIGGER IF EXISTS CheckIn;
DELIMITER //
CREATE TRIGGER CheckIn
BEFORE INSERT ON Booking
FOR EACH ROW
BEGIN
	UPDATE Room
	SET reserved = true
	WHERE Room.rID = new.rID
	AND new.startDate <= CURDATE()
	AND new.endDate > CURDATE();
END //
DELIMITER ;


DROP TRIGGER IF EXISTS CheckOut;
DELIMITER //
CREATE TRIGGER CheckOut
BEFORE DELETE ON Booking
FOR EACH ROW
BEGIN
UPDATE room
set room.reserved = False
WHERE old.rID = room.rID;
END //
DELIMITER ;

DROP PROCEDURE IF EXISTS countAvailableRoomsMax;
DELIMITER //
CREATE PROCEDURE countAvailableRoomsMax(IN maxPrice INT, OUT count INT)
BEGIN
	SELECT COUNT(*)
	FROM Room
	WHERE reserved = false and Room.typeName IN (
SELECT typeName FROM RoomType 
WHERE price <= maxPrice);
END //
DELIMITER ;


DROP PROCEDURE IF EXISTS recordBooking;
DELIMITER //
CREATE PROCEDURE recordBooking (IN cutOffDate DATE)
BEGIN
	INSERT INTO BookingRecord (uID, rID, startDate, endDate)
		SELECT uID, rID, startDate, endDate
		FROM Booking
		WHERE Booking.endDate <= cutOffDate ;
	DELETE FROM Booking WHERE Booking.endDate <= cutOffDate ;
END // 
DELIMITER ;


insert into user values(1,'Nabeel', 'Chen', '408-200-2090',30);
insert into user values(2,'Cherry', 'Blair', '408-207-3555',25);
insert into user values(3,'Matas', 'Grimes', '305-258-9383',48);
insert into user values(4,'Bob', 'Weeks', '408-224-6469',43);
insert into user values(5,'Asiyah', 'Salt', '408-210-5628',33);
insert into user values(6,'Courtney', 'Stafford', '831-844-3181',22);
insert into user values(7,'Jasmin', 'Quinn', '408-213-3853',33);
insert into user values(8,'Bentley', 'Perkins', '614-799-6254',65);
insert into user values(9,'Alivia', 'Pineda', '408-216-8042',38);
insert into user values(10,'Tj', 'Blundell', '408-217-0286',28);
insert into user values(11,'Gregory', 'Velazquez', '408-218-7135',25);
insert into user values(12,'Matas', 'Woods', '646-998-1245',65);
insert into user values(13,'Bob', 'Weeks', '408-219-2364',45);
insert into user values(14,'Florrie', 'Porter', '218-781-9042',21);
insert into user values(15,'Domas', 'Adam', '408-221-4657',25);
insert into user values(16,'Beverly', 'Walls', '408-223-2028',38);
insert into user values(17,'Bob', 'Weeks', '428-124-3449',36);
insert into user values(18,'Jasmin', 'Blundell', '408-225-3232',46);
insert into user values(19,'Simon', 'Enriquez', '408-226-2742',46);
insert into user values(20,'Tj', 'Chen', '408-227-0398',53);
insert into user values(21,'Leo', 'Britt', '979-532-7183',74);
insert into user values(22,'Mindy', 'Weeks', '608-515-2749',22);
insert into user values(23,'Harri', 'Olson', '856-756-7309',29);
insert into user values(24,'Ferne ', 'West', '559-446-6155',23);
insert into user values(25,'Shelbie ', 'Buck', '469-337-3581',55);
insert into user values(26,'Abi', 'Park', '408-229-5237',39);
insert into user values(27,'Celeste', 'Horner', '398-207-6211',42);
insert into user values(28,'Brody', 'Rogers', '478-210-3721',58);
insert into user values(29,'Josh', 'OReilly', '406-485-9984',62);
insert into user values(30,'Alessia', 'Keller', '406-741-2284',31);
insert into user values(31,'Colby', 'Chaney', '406-850-8802',31);
insert into user values(32,'Hallie', 'Rowley', '406-822-5775',58);
insert into user values(33,'Brody', 'Rogers', '406-451-2719',58);
insert into user values(34,'Addison', 'Clemons', '406-975-8747',58);
insert into user values(35,'Alexia', 'Welsh', '406-980-3657',58);
insert into user values(36,'Velma', 'Luna', '406-410-0623',58);
insert into user values(37,'Landon', 'Neville', '406-265-5102',58);
insert into user values(38,'Jolie', 'Dillon', '317-856-4147',58);
insert into user values(39,'Abi', 'Parks', '317-809-4726',58);
insert into user values(40,'Scarlette', 'Logan', '317-968-0908',58);
insert into user values(41,'Kyra', 'Deleon', '541-919-2625',58);
insert into user values(42,'Erin', 'Jeffery', '217-268-5274',58);
insert into user values(43,'Andy', 'Mcdougall', '830-358-7905',58);
insert into user values(44,'Devin', 'Firth', '505-946-6433',58);
insert into user values(45,'Carlos', 'Mccaffrey', '857-237-2185',58);
insert into user values(46,'Fiza', 'Bird', '702-621-3336',58);
insert into user values(47,'Laibah', 'Dawe', '907-770-9267',58);
insert into user values(48,'Riley', 'Halliday', '503-902-8437',58);
insert into user values(49,'Jude', 'OConnor', '213-966-8041',58);
insert into user values(50,'Brody', 'Rogers', '681-753-2066',58);

insert into roomtype values('CLASSIC', 79,'Queen', 1,2);
insert into roomtype values('VALUE', 99,'King', 1, 4);
insert into roomtype values('PREMIUM', 119,'Queen', 2,4);
insert into roomtype values('PREMIUM KING', 139,'King', 2,4);
insert into roomtype values('DELUXE', 159,'King', 1,2);
insert into roomtype values('DELUXE KING', 189,'King', 2,6);
insert into roomtype values('DELUXE PREMIUM', 259,'King', 2,8);



insert into room values(201, 2, 'CLASSIC',True,True);
insert into room values(202, 2, 'CLASSIC',True,True);
insert into room values(203, 2, 'CLASSIC',True,True);
insert into room values(204, 2, 'CLASSIC',false,True);
insert into room values(205, 2, 'CLASSIC',True,false);
insert into room values(206, 2, 'CLASSIC',TRUE,false);
insert into room values(301, 3, 'VALUE',True,True);
insert into room values(302, 3, 'VALUE',True,True);
insert into room values(303, 3, 'VALUE',True,True);
insert into room values(304, 3, 'VALUE',True,True);
insert into room values(305, 3, 'PREMIUM',True,True);
insert into room values(306, 3, 'PREMIUM',TRUE,false);
insert into room values(401, 4, 'PREMIUM KING',True,True);
insert into room values(402, 4, 'PREMIUM KING',True,True);
insert into room values(403, 4, 'DELUXE',TRUE,True);
insert into room values(404, 4, 'DELUXE',false,True);
insert into room values(405, 4, 'DELUXE',True,False);
insert into room values(406, 4, 'DELUXE KING',false,false);
insert into room values(501, 5, 'DELUXE KING',True,True);
insert into room values(502, 5, 'DELUXE PREMIUM',false,false);
insert into room values(503, 5, 'DELUXE PREMIUM',false,True);

insert into booking values(15,202,'2020-10-20','2020-10-24',TRUE);
insert into booking values(26,205,'2020-10-20','2020-10-24',TRUE);
insert into booking values(26,206,'2020-10-20','2020-10-24',TRUE);
insert into booking values(17,304,'2020-10-22','2020-10-24',FALSE);
insert into booking values(30,203,'2020-10-22','2020-10-25',TRUE);
insert into booking values(31,302,'2020-10-23','2020-10-25',TRUE);
insert into booking values(20,403,'2020-10-23','2020-10-31',FALSE);
insert into booking values(45,501,'2020-10-24','2020-10-30',TRUE);
insert into booking values(22,305,'2020-10-24','2020-10-25',FALSE);
insert into booking values(13,201,'2020-10-24','2020-10-26',TRUE);
insert into booking values(24,404,'2020-10-25','2020-10-31',TRUE);
insert into booking values(30,502,'2020-10-25','2020-10-31',TRUE);
insert into booking values(32,303,'2020-10-25','2020-10-29',TRUE);
insert into booking values(36,403,'2020-10-25','2020-10-31',TRUE);
insert into booking values(24,401,'2020-10-26','2020-10-30',FALSE);
insert into booking values(41,306,'2020-10-27','2020-10-30',TRUE);




insert into bookingrecord values(1,202,'2020-06-23','2020-06-24');
insert into bookingrecord values(2,205,'2020-06-28','2020-06-30');
insert into bookingrecord values(3,201,'2020-07-13','2020-07-16');
insert into bookingrecord values(4,302,'2020-07-15','2020-07-24');
insert into bookingrecord values(25,402,'2020-07-15','2020-07-24');
insert into bookingrecord values(3,304,'2020-07-17','2020-07-20');
insert into bookingrecord values(5,305,'2020-07-19','2020-07-26');
insert into bookingrecord values(6,405,'2020-07-23','2020-07-24');
insert into bookingrecord values(7,501,'2020-07-23','2020-07-28');
insert into bookingrecord values(10,405,'2020-07-25','2020-07-30');
insert into bookingrecord values(11,302,'2020-07-26','2020-07-29');
insert into bookingrecord values(12,202,'2020-07-27','2020-07-31');
insert into bookingrecord values(13,204,'2020-08-10','2020-08-13');
insert into bookingrecord values(14,401,'2020-08-13','2020-08-15');
insert into bookingrecord values(15,301,'2020-08-13','2020-08-19');
insert into bookingrecord values(5,303,'2020-08-13','2020-08-19');
insert into bookingrecord values(22,202,'2020-08-15','2020-08-19');
insert into bookingrecord values(33,203,'2020-08-17','2020-08-19');
insert into bookingrecord values(25,304,'2020-08-23','2020-08-25');
insert into bookingrecord values(27,401,'2020-08-25','2020-08-27');
insert into bookingrecord values(35,402,'2020-08-27','2020-08-29');
insert into bookingrecord values(36,203,'2020-08-27','2020-08-29');
insert into bookingrecord values(37,204,'2020-08-29','2020-08-31');
insert into bookingrecord values(11,205,'2020-09-01','2020-09-05');
insert into bookingrecord values(5,301,'2020-09-03','2020-09-07');
insert into bookingrecord values(7,402,'2020-09-05','2020-09-07');
insert into bookingrecord values(8,301,'2020-09-05','2020-09-06');
insert into bookingrecord values(16,201,'2020-09-05','2020-09-09');
insert into bookingrecord values(17,205,'2020-09-06','2020-09-10');
insert into bookingrecord values(29,401,'2020-09-07','2020-09-10');




