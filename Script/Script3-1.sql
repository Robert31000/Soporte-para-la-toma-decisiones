use master;
GO

IF EXISTS(SELECT * FROM master.sys.databases 
          WHERE name='soporte')
BEGIN
    Drop database soporte;
END
GO

Create Database soporte;
GO

use soporte;
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Customer]') AND type in (N'U'))
BEGIN
	CREATE TABLE Customer (
		CustomerID INT PRIMARY KEY,
		DateOfBirth DATE NOT NULL,
		Name VARCHAR(100) NOT NULL
	);
END;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FrequentFlyerCard]') AND type in (N'U'))
BEGIN
	CREATE TABLE FrequentFlyerCard (
		FFC_Number INT PRIMARY KEY,
		Miles INT NOT NULL,
		Meal_Code VARCHAR(10) NOT NULL,
		CustomerID INT,
		FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
	);
END;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Country]') AND type in (N'U'))
BEGIN
	CREATE TABLE Country (
		CountryID INT PRIMARY KEY  ,
		Name VARCHAR(100) NOT NULL
	);
END;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[City]') AND type in (N'U'))
BEGIN
	CREATE TABLE City (
		CityID INT PRIMARY KEY  ,
		Name VARCHAR(100) NOT NULL,
		CountryID INT,
		FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
	);
END;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Airport]') AND type in (N'U'))
BEGIN
	CREATE TABLE Airport (
		AirportID INT PRIMARY KEY  ,
		Name VARCHAR(100) NOT NULL,
		CityID INT,
		FOREIGN KEY (CityID) REFERENCES City(CityID)
	);
END;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PlaneModel]') AND type in (N'U'))
BEGIN
	CREATE TABLE PlaneModel (
		PlaneModelID INT PRIMARY KEY  ,
		Description VARCHAR(100) NOT NULL,
		Graphic VARBINARY(MAX) 
	);
END;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Airplane]') AND type in (N'U'))
BEGIN
	CREATE TABLE Airplane (
		AirplaneID INT PRIMARY KEY  ,
		RegistrationNumber VARCHAR(50) NOT NULL,
		BeginOfOperation DATE NOT NULL,
		Status VARCHAR(50),
		PlaneModelID INT,
		FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID)
	);
END;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[category_pasaje]') AND type in (N'U'))
BEGIN
    CREATE TABLE category_pasaje(
        id INT PRIMARY KEY,
        nombre VARCHAR(60) NOT NULL
    );
END;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Ticket]') AND type in (N'U'))
BEGIN
	CREATE TABLE Ticket (
		TicketID INT PRIMARY KEY  ,
		TicketingCode VARCHAR(50) NOT NULL,
		CustomerID INT,
		id_category_pasaje INT,
		FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
		FOREIGN KEY (id_category_pasaje) REFERENCES category_pasaje(id)
	);
END;


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FlightNumber]') AND type in (N'U'))
BEGIN
	CREATE TABLE FlightNumber (
		FlightNumberID INT PRIMARY KEY  ,
		DepartureTime DATETIME NOT NULL,
		Description VARCHAR(50),
		Type VARCHAR(50) NOT NULL,
		Airline VARCHAR(50) NOT NULL,
		StartAirportID INT NOT NULL,
		GoalAirportID INT NOT NULL,
		PlaneModelID INT NOT NULL,
		FOREIGN KEY (StartAirportID) REFERENCES Airport(AirportID),
		FOREIGN KEY (GoalAirportID) REFERENCES Airport(AirportID),
		FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID)
	);
END;


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Flight]') AND type in (N'U'))
BEGIN
	CREATE TABLE Flight (
		FlightID INT PRIMARY KEY  ,
		BoardingTime DATETIME NOT NULL,
		FlightDate DATE NOT NULL,
		Gate VARCHAR(50) NOT NULL,
		CheckInCounter VARCHAR(50) NOT NULL,
		FlightNumberID INT NOT NULL,
		FOREIGN KEY (FlightNumberID) REFERENCES FlightNumber(FlightNumberID)
	);
END;



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Seat]') AND type in (N'U'))
BEGIN
	CREATE TABLE Seat (
		SeatID INT PRIMARY KEY  ,
		Size VARCHAR(50) NOT NULL,
		Number INT NOT NULL,
		Location VARCHAR(50) NOT NULL,
		PlaneModelID INT NOT NULL,
		FOREIGN KEY (PlaneModelID) REFERENCES PlaneModel(PlaneModelID)
	);
END; 


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AvailableSeat]') AND type in (N'U'))
BEGIN
	CREATE TABLE AvailableSeat (
		AvailableSeatID INT PRIMARY KEY  ,
		FlightID INT NOT NULL,
		SeatID INT NOT NULL,
		FOREIGN KEY (FlightID) REFERENCES Flight(FlightID),
		FOREIGN KEY (SeatID) REFERENCES Seat(SeatID)
	);
END;



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Coupon]') AND type in (N'U'))
BEGIN
	CREATE TABLE Coupon (
		CouponID INT PRIMARY KEY  ,
		DateOfRedemption DATE NOT NULL,
		Class VARCHAR(50) NOT NULL,
		Standby VARCHAR(50) NOT NULL,
		MealCode VARCHAR(50) NOT NULL,
		TicketID INT NOT NULL,
		FlightID INT NOT NULL,
		FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
		FOREIGN KEY (FlightID) REFERENCES Flight(FlightID)
	);
END;



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PiecesOfLuggage]') AND type in (N'U'))
BEGIN
	CREATE TABLE PiecesOfLuggage (
		LuggageID INT PRIMARY KEY  ,
		Number INT NOT NULL,
		Weight DECIMAL(5, 2) NOT NULL,
		CouponID INT NOT NULL,
		FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID)
	);
END;



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[AvailableCoupon]') AND type in (N'U'))
BEGIN
	CREATE TABLE AvailableCoupon (
		CouponID INT UNIQUE,
		AvailableSeatID INT UNIQUE,
		FOREIGN KEY (CouponID) REFERENCES Coupon(CouponID),
		FOREIGN KEY (AvailableSeatID) REFERENCES AvailableSeat(AvailableSeatID)
	);
END;


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Document]') AND type in (N'U'))
BEGIN
	CREATE TABLE Document (
		DocumentID INT PRIMARY KEY  ,
		DocumentType VARCHAR(50) NOT NULL,
		DocumentNumber VARCHAR(50) NOT NULL
	);
END;


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[DocumentCustomer]') AND type in (N'U'))
BEGIN
	CREATE TABLE DocumentCustomer(
		DocumentID INT UNIQUE,
		CustomerID INT UNIQUE,
		FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
		FOREIGN KEY (DocumentID) REFERENCES Document(DocumentID)
	);
END;

GO

CREATE INDEX IDX_Ticket_CustomerID
ON Ticket (CustomerID);
GO

CREATE INDEX IDX_Airplane_PlaneModelID
ON Airplane (PlaneModelID);
GO

CREATE INDEX IDX_FlightNumber_StartAirportID
ON FlightNumber (StartAirportID);
GO

CREATE INDEX IDX_FlightNumber_GoalAirportID
ON FlightNumber (GoalAirportID);
GO

INSERT INTO Customer (CustomerID, DateOfBirth, Name) VALUES
(1, '1985-02-15', 'John Doe'),
(2, '1990-07-21', 'Jane Smith'),
(3, '1978-11-30', 'Robert Brown'),
(4, '1982-05-12', 'Emily Johnson'),
(5, '1995-01-19', 'Michael Davis'),
(6, '1989-03-03', 'Sarah Wilson'),
(7, '1980-08-09', 'William Taylor'),
(8, '1992-12-25', 'Linda White'),
(9, '1987-06-17', 'James Harris'),
(10, '1994-09-22', 'Jessica Martin');
GO

INSERT INTO FrequentFlyerCard (FFC_Number, Miles, Meal_Code, CustomerID) VALUES
(1001, 5000, 'A', 1),
(1002, 7500, 'B', 2),
(1003, 6000, 'C', 3),
(1004, 8000, 'D', 4),
(1005, 9000, 'E', 5),
(1006, 10000, 'F', 6),
(1007, 5500, 'G', 7),
(1008, 6500, 'H', 8),
(1009, 7000, 'I', 9),
(1010, 8500, 'J', 10);
GO


INSERT INTO Country (CountryID, Name) VALUES
(1, 'United States'),
(2, 'Canada'),
(3, 'United Kingdom'),
(4, 'Germany'),
(5, 'France'),
(6, 'Italy'),
(7, 'Spain'),
(8, 'Australia'),
(9, 'Japan'),
(10, 'China');
GO

INSERT INTO City (CityID, Name, CountryID) VALUES
(1, 'New York', 1),
(2, 'Toronto', 2),
(3, 'London', 3),
(4, 'Berlin', 4),
(5, 'Paris', 5),
(6, 'Rome', 6),
(7, 'Madrid', 7),
(8, 'Sydney', 8),
(9, 'Tokyo', 9),
(10, 'Beijing', 10);
GO

INSERT INTO Airport (AirportID, Name, CityID) VALUES
(1, 'John F. Kennedy International Airport', 1),
(2, 'Toronto Pearson International Airport', 2),
(3, 'Heathrow Airport', 3),
(4, 'Berlin Brandenburg Airport', 4),
(5, 'Charles de Gaulle Airport', 5),
(6, 'Leonardo da Vinci International Airport', 6),
(7, 'Adolfo Suárez Madrid-Barajas Airport', 7),
(8, 'Sydney Kingsford Smith Airport', 8),
(9, 'Narita International Airport', 9),
(10, 'Beijing Capital International Airport', 10);
GO

INSERT INTO PlaneModel (PlaneModelID, Description, Graphic) VALUES
(1, 'Boeing 737', NULL),
(2, 'Airbus A320', NULL),
(3, 'Boeing 777', NULL),
(4, 'Airbus A330', NULL),
(5, 'Boeing 787', NULL),
(6, 'Airbus A350', NULL),
(7, 'Boeing 747', NULL),
(8, 'Airbus A380', NULL),
(9, 'Embraer E190', NULL),
(10, 'Bombardier CRJ900', NULL);
GO

INSERT INTO category_pasaje (id, nombre) VALUES
(1, 'Economy Class'),
(2, 'Business Class'),
(3, 'First Class'),
(4, 'Premium Economy'),
(5, 'Standard Class'),
(6, 'Comfort Class'),
(7, 'Luxury Class'),
(8, 'Discount Class'),
(9, 'Executive Class'),
(10, 'Basic Class');
GO

INSERT INTO Airplane (AirplaneID, RegistrationNumber, BeginOfOperation, Status, PlaneModelID) VALUES
(1, 'N12345', '2015-06-01', 'Active', 1),
(2, 'C12345', '2017-09-15', 'Active', 2),
(3, 'N67890', '2014-03-25', 'Maintenance', 3),
(4, 'C67890', '2018-01-10', 'Active', 4),
(5, 'N24680', '2019-07-22', 'Active', 5),
(6, 'C24680', '2020-02-12', 'Active', 6),
(7, 'N13579', '2016-08-19', 'Inactive', 7),
(8, 'C13579', '2015-11-03', 'Active', 8),
(9, 'N86420', '2021-05-30', 'Active', 9),
(10, 'C86420', '2019-12-15', 'Maintenance', 10);
GO

INSERT INTO Ticket (TicketID, TicketingCode, CustomerID, id_category_pasaje) VALUES
(1001, 'TICKET001', 1, 1),
(1002, 'TICKET002', 2, 2),
(1003, 'TICKET003', 3, 3),
(1004, 'TICKET004', 4, 4),
(1005, 'TICKET005', 5, 1),
(1006, 'TICKET006', 6, 2),
(1007, 'TICKET007', 7, 3),
(1008, 'TICKET008', 8, 5),
(1009, 'TICKET009', 9, 6),
(1010, 'TICKET010', 10, 7);
GO


INSERT INTO FlightNumber (FlightNumberID, DepartureTime, Description, Type, Airline, StartAirportID, GoalAirportID, PlaneModelID) VALUES
(1, '2024-08-30 07:00:00', 'Morning Flight to London', 'International', 'Airways A', 1, 3, 1),
(2, '2024-08-30 10:00:00', 'Midday Flight to Berlin', 'International', 'Airways B', 1, 4, 2),
(3, '2024-08-30 13:00:00', 'Afternoon Flight to Paris', 'International', 'Airways C', 1, 5, 3),
(4, '2024-08-30 16:00:00', 'Evening Flight to Rome', 'International', 'Airways D', 1, 6, 4),
(5, '2024-08-30 19:00:00', 'Night Flight to Sydney', 'International', 'Airways E', 1, 8, 5),
(6, '2024-08-31 08:00:00', 'Morning Flight to Tokyo', 'International', 'Airways F', 1, 9, 6),
(7, '2024-08-31 11:00:00', 'Midday Flight to Beijing', 'International', 'Airways G', 1, 10, 7),
(8, '2024-08-31 14:00:00', 'Afternoon Flight to Toronto', 'International', 'Airways H', 1, 2, 8),
(9, '2024-08-31 17:00:00', 'Evening Flight to Madrid', 'International', 'Airways I', 1, 7, 9),
(10, '2024-08-31 20:00:00', 'Night Flight to New York', 'International', 'Airways J', 1, 1, 10);
GO

INSERT INTO Flight (FlightID, BoardingTime, FlightDate, Gate, CheckInCounter, FlightNumberID) VALUES
(1, '2024-08-30 06:30:00', '2024-08-30', 'A1', '1', 1),
(2, '2024-08-30 09:30:00', '2024-08-30', 'B2', '2', 2),
(3, '2024-08-30 12:30:00', '2024-08-30', 'C3', '3', 3),
(4, '2024-08-30 15:30:00', '2024-08-30', 'D4', '4', 4),
(5, '2024-08-30 18:30:00', '2024-08-30', 'E5', '5', 5),
(6, '2024-08-31 07:30:00', '2024-08-31', 'F6', '6', 6),
(7, '2024-08-31 10:30:00', '2024-08-31', 'G7', '7', 7),
(8, '2024-08-31 13:30:00', '2024-08-31', 'H8', '8', 8),
(9, '2024-08-31 16:30:00', '2024-08-31', 'I9', '9', 9),
(10, '2024-08-31 19:30:00', '2024-08-31', 'J10', '10', 10);
GO

INSERT INTO Seat (SeatID, Size, Number, Location, PlaneModelID) VALUES
(1, 'Economy', 1, 'A1', 1),
(2, 'Economy', 2, 'A2', 1),
(3, 'Business', 3, 'B1', 2),
(4, 'Business', 4, 'B2', 2),
(5, 'First', 5, 'C1', 3),
(6, 'First', 6, 'C2', 3),
(7, 'Economy', 7, 'D1', 4),
(8, 'Economy', 8, 'D2', 4),
(9, 'Business', 9, 'E1', 5),
(10, 'Business', 10, 'E2', 5);
GO

INSERT INTO AvailableSeat (AvailableSeatID, FlightID, SeatID) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 3),
(4, 2, 4),
(5, 3, 5),
(6, 3, 6),
(7, 4, 7),
(8, 4, 8),
(9, 5, 9),
(10, 5, 10);
GO

INSERT INTO Coupon (CouponID, DateOfRedemption, Class, Standby, MealCode, TicketID, FlightID) VALUES
(1, '2024-08-29', 'Economy', 'No', 'A', 1001, 1),
(2, '2024-08-29', 'Business', 'Yes', 'B', 1002, 2),
(3, '2024-08-29', 'First', 'No', 'C', 1003, 3),
(4, '2024-08-29', 'Economy', 'Yes', 'D', 1004, 4),
(5, '2024-08-29', 'Business', 'No', 'E', 1005, 5),
(6, '2024-08-29', 'Economy', 'Yes', 'F', 1006, 6),
(7, '2024-08-29', 'First', 'No', 'G', 1007, 7),
(8, '2024-08-29', 'Economy', 'Yes', 'H', 1008, 8),
(9, '2024-08-29', 'Business', 'No', 'I', 1009, 9),
(10, '2024-08-29', 'Economy', 'Yes', 'J', 1010, 10);
GO

INSERT INTO PiecesOfLuggage (LuggageID, Number, Weight, CouponID) VALUES
(1, 1, 15.00, 1),
(2, 2, 20.50, 2),
(3, 3, 10.00, 3),
(4, 4, 22.00, 4),
(5, 5, 18.50, 5),
(6, 6, 12.75, 6),
(7, 7, 25.00, 7),
(8, 8, 17.00, 8),
(9, 9, 19.25, 9),
(10, 10, 21.00, 10);
GO

INSERT INTO AvailableCoupon (CouponID, AvailableSeatID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);
GO

INSERT INTO Document (DocumentID, DocumentType, DocumentNumber) VALUES
(1, 'Passport', 'P123456789'),
(2, 'Identity Card', 'ID987654321'),
(3, 'Visa', 'V123456789'),
(4, 'Driver License', 'DL123456789'),
(5, 'Social Security Card', 'SS123456789'),
(6, 'Health Insurance Card', 'HI123456789'),
(7, 'Birth Certificate', 'BC123456789'),
(8, 'Residence Permit', 'RP123456789'),
(9, 'Student ID', 'SI123456789'),
(10, 'Work Permit', 'WP123456789');
GO


INSERT INTO DocumentCustomer (DocumentID, CustomerID) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5),
(6, 6),
(7, 7),
(8, 8),
(9, 9),
(10, 10);
GO

