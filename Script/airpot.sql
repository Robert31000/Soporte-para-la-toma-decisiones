if db_id('airport1') is null
begin
	create database airport1;
end
go

use airport1;
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Customer','U') is null
begin
	create table Customer(
	id int identity(1,1) primary key,
	Date_of_Birth date not null,
	Name varchar(30) not null,
	);
end
go

if not exists (select 1 from Customer)
begin
	declare @length tinyint=20;
	declare @counter tinyint=0;
	declare @minDate date='1960-01-01';
	declare @maxDate date='2014-12-31';

	while @counter <= @length
	begin

		declare @random date;
		set @random=dateadd(day,floor(rand()*datediff(day,@minDate,@maxDate)+1),@minDate);

		insert into Customer(Name,Date_of_Birth)
		values('Customer '+cast(@counter as varchar(10)),@random);

		set @counter=@counter+1;
	end
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Country','U') is null
begin
	create table Country(
	id int identity(1,1) primary key,
	Name varchar(30) not null,
	);
end
go

if not exists(select 1 from Country)
begin
	declare @length int=9;
	declare @counter int=0;

	while @counter<= @length 
	begin
	insert into Country(Name)
	values('country '+ cast(@counter as varchar(10)));

	set @counter=@counter+1;
	end
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Passport', 'U') is null
begin
	create table Passport(
	id int identity(1,1) primary key,
	Date_of_Issue date not null,
	Valid_Date date not null,
	Customer_id int not null,
	Country_id int not null,
	foreign key (Customer_id) references Customer(id),
	foreign key (Country_id) references Country(id),
	);
end 
go

if not exists(select 1 from Passport)
begin
	declare @length tinyint=30;
	declare @minIssueDate date='2010-01-01';
	declare @maxIssueDate date='2023-12-31';
	declare @counter tinyint=0;
	declare @issueDate date;
	declare @validDate date;
	declare @customerId tinyint;
	declare @countryId tinyint;

	while @counter<@length
	begin

	set @issueDate=dateadd(day,floor(rand()*datediff(day,@minIssueDate,@maxIssueDate)+1),@minIssueDate);
	set @validDate=dateadd(year,1+floor(rand()*9),@issueDate);

	select @customerId=id from Customer order by newid() offset @counter % (
		select count(*) from Customer
	) rows fetch next 1 rows only;

	select @countryId=id from Country order by newid() offset @counter % (
		select count(*) from Country
	) rows fetch next 1 rows only;


	insert into Passport(Date_of_Issue,Valid_Date,Customer_id,Country_id) 
	values(@issueDate, @validDate, @customerId, @countryId);

	set @counter=@counter+1;
	end

end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('City','U') is null
begin
	create table City(
	id int identity(1,1) primary key,
	Country_id int not null,
	Name varchar(30) not null,
	foreign key (Country_id) references Country(id)
	);
end
go

if not exists(select 1 from City)
begin
	declare @length int=14;
	declare @counter int=0;

	while @counter<=@length
	begin
	insert into City(Name,Country_id)
	values('city '+cast(@counter as varchar(10)),
	(select top 1 id from Country order by newid()));

	set @counter=@counter+1;
	end
end 
go

--------------------------------------------------------------------------------------------------------------------------


if object_id('Airport', 'U') is null
begin
	create table Airport(
	id int identity(1,1) primary key,
	Name varchar(30) not null,
	City_id int not null,
	foreign key (City_id) references City(id)
	);
end 
go

if not exists(select 1 from Airport)
begin
	declare @length int=40;
	declare @counter int=0;

	while @counter<=@length
	begin
	insert into Airport(Name,City_id)
	values('airport '+cast(@counter as varchar(10)),
	(select top 1 id from City order by newid()));

	set @counter=@counter+1;
	end
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Plane_Model', 'U') is null
begin
	create table Plane_Model(
	id int identity(1,1) primary key,
	Description varchar(60) not null,
	Graphic varchar(50) not null,
	);
end 
go

if not exists(select 1 from Plane_Model)
begin
    insert into Plane_Model (Description, Graphic) values
    ('Boeing 737', 'boeing737.png'),
    ('Airbus A320', 'airbusA320.png'),
    ('Boeing 777', 'boeing777.png'),
    ('Airbus A380', 'airbusA380.png'),
    ('Embraer E190', 'embraerE190.png');
end
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Frequent_Flyer_Card', 'U') is null
begin
	create table Frequent_Flyer_Card(
	FFC_Number int identity(1,1) primary key,
	Miles int not null,
	Meal_Code int not null,
	Customer_id int not null,
	foreign key (Customer_id) references Customer(id)
	);
end 
go

if not exists(select 1 from Frequent_Flyer_Card)
begin
	declare @length tinyint=(select count(*) from Customer);
	declare @counter int=1;
	declare @maxMiles int=100000;
	declare @minMiles int=1000;
	declare @maxMealCode tinyint=10;
	declare @minMealCode tinyint=1;

	while @counter <= @length
	begin
		insert into Frequent_Flyer_Card (Miles, Meal_Code,Customer_id) values(
		(floor(rand()*(@maxMiles- @minMiles+1)+@minMiles)),
		(floor(rand()*(@maxMealCode-@minMealCode+1)+@minMealCode)),
		@counter
		);

		set @counter=@counter+1;
	end
end
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Airplane', 'U') is null
begin
	create table Airplane(
	Registration_Number int identity(1,1) primary key,
	Begin_of_Operation date not null,
	Status varchar(30) not null,
	Plane_Model_id int not null,
	foreign key (Plane_Model_id) references Plane_Model(id),
	);
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Flight_Number', 'U') is null
begin
	create table Flight_Number(
	id int identity(1,1) primary key,
	Departure_Time time not null,
	Description varchar(50) not null,
	Type bit not null,
	Airline varchar(20) not null,
	Airport_Start int not null,
	Airport_Goal int not null,
	foreign key (Airport_Start) references Airport(id),
	foreign key (Airport_Goal) references Airport(id),
	);
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Ticket', 'U') is null
begin
	create table Ticket(
	Ticketing_Code int identity(1,1) primary key,
	Number int not null,
	Customer_id int not null,
	foreign key (Customer_id) references Customer(id)
	);
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Flight', 'U') is null
begin
	create table Flight(
	id int identity(1,1) primary key,
	Boarding_Time time not null,
	Flight_Date date not null,
	Gate tinyint not null,
	Check_In_Counter bit not null,
	Flight_Number_id int not null,
	foreign key (Flight_Number_id) references Flight_Number(id),
	);
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Seat', 'U') is null
begin
	create table Seat(
	id int identity(1,1) primary key,
	Size int not null,
	Number int not null,
	Location varchar(30) not null,
	Plane_Model_id int not null,
	foreign key (Plane_Model_id) references Plane_Model(id),
	);
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Available_Seat', 'U') is null
begin
	create table Available_Seat(
	id int identity(1,1) primary key,
	Flight_id int not null,
	Seat_id int not null,
	foreign key (Flight_id) references Flight(id),
	foreign key (Seat_id) references Seat(id),
	);
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Coupon', 'U') is null
begin
	create table Coupon(
	id int identity(1,1) primary key,
	Date_of_Redemption date not null,
	Class varchar(20) not null,
	Standby varchar(20) not null,
	Meal_Code int not null,
	Ticketing_Code int not null,
	Flight_id int not null,
	foreign key (Ticketing_Code) references Ticket(Ticketing_Code),
	foreign key (Flight_id) references Flight(id),
	);
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Available_Seat_Coupon', 'U') is null
begin
	create table Available_Seat_Coupon(
	Coupon_id int not null,
	Available_Seat_id int not null,
	foreign key (Available_Seat_id) references Available_Seat(id),
	foreign key (Coupon_id) references Coupon(id),
	);
end 
go

--------------------------------------------------------------------------------------------------------------------------

if object_id('Pieces_of_Luggage', 'U') is null
begin
	create table Pieces_of_Luggage(
	id int identity(1,1) primary key,
	Number int not null,
	Weight int not null,
	Coupon_id int not null,
	foreign key (Coupon_id) references Coupon(id),
	);
end 
go
