-- Airplanes (1)
DECLARE @airplaneCount INT = 1;
WHILE @airplaneCount <= 1
BEGIN
    EXEC AddRandomAirplane;
    SET @airplaneCount = @airplaneCount + 1;
END;

-- Flights (30)
DECLARE @flightCount INT = 1;
WHILE @flightCount <= 30
BEGIN
    EXEC AddRandomFlight;
    SET @flightCount = @flightCount + 1;
END;

-- Passengers (1000)
DECLARE @passengerCount INT = 1;
WHILE @passengerCount <= 1000
BEGIN
    EXEC AddRandomPassenger;
    SET @passengerCount = @passengerCount + 1;
END;

-- Tickets (3000)
DECLARE @ticketCount INT = 1;
WHILE @ticketCount <= 3000
BEGIN
    EXEC AddRandomTicket;
    SET @ticketCount = @ticketCount + 1;
END;

-- Employees (100)
DECLARE @employeeCount INT = 1;
WHILE @employeeCount <= 100
BEGIN
    EXEC AddRandomEmployee;
    SET @employeeCount = @employeeCount + 1;
END;

-- Crews (7)
DECLARE @crewCount INT = 1;
WHILE @crewCount <= 7
BEGIN
    DECLARE @randomFlightID INT;
    SELECT TOP 1 @randomFlightID = FlightID FROM Flights ORDER BY NEWID();
    EXEC AddRandomCrew @FlightID = @randomFlightID;
    SET @crewCount = @crewCount + 1;
END;



exec GetAllAirplanes
exec GetAllCrew @FlightID = 1;
exec GetAllEmployees
exec GetAllFlights
exec GetAllPassengers
exec GetAllTickets
exec GetAllCartData



CREATE DATABASE aviasales;
-- �������� ������� "��������"
CREATE TABLE Airplanes (
    AirplaneID INT PRIMARY KEY IDENTITY,
    Model NVARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    ProductionYear DATE NOT NULL
);

-- �������� ������� "�����"
CREATE TABLE Flights (
    FlightID INT PRIMARY KEY IDENTITY,
    DepartureAirport NVARCHAR(3) NOT NULL,
    ArrivalAirport NVARCHAR(3) NOT NULL,
    DepartureTime DATETIME NOT NULL,
    ArrivalTime DATETIME NOT NULL,
    AirplaneID INT REFERENCES Airplanes(AirplaneID)
);

-- �������� ������� "���������"
CREATE TABLE Passengers (
    PassengerID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    PassportNumber NVARCHAR(20) NOT NULL UNIQUE,
    BirthDate DATE NOT NULL
);

-- �������� ������� "������"
CREATE TABLE Tickets (
    TicketID INT PRIMARY KEY IDENTITY,
    FlightID INT REFERENCES Flights(FlightID),
    PassengerID INT REFERENCES Passengers(PassengerID),
    SeatNumber NVARCHAR(4) NOT NULL,
    TicketClass NVARCHAR(20) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

-- �������� ������� "����������"
CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY IDENTITY,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Position NVARCHAR(50) NOT NULL,
    HireDate DATE NOT NULL
);

-- �������� ������� "�������"
CREATE TABLE Crews (
    CrewID INT PRIMARY KEY IDENTITY,
    FlightID INT REFERENCES Flights(FlightID),
    EmployeeID INT REFERENCES Employees(EmployeeID),
    Role NVARCHAR(50) NOT NULL
);




-- �������� ������� "�������(��� �������)"
CREATE TABLE ShoppingCart (
    ItemID INT PRIMARY KEY IDENTITY,
    FlightID INT REFERENCES Flights(FlightID),
    PassengerID INT REFERENCES Passengers(PassengerID),
    SeatNumber NVARCHAR(4) NOT NULL,
    TicketClass NVARCHAR(20) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL
);

--=============================================================--
--==========================���������==========================--
--=============================================================--


--==========================�������===========================--

SELECT * FROM Airplanes
-- ���������� ������ ��������
EXEC AddAirplane @Model = 'Airbus A321', @Capacity = 220, @ProductionYear = '2018-01-01';

--��������� ������� �� ��� ID
EXEC UpdateAirplane @AirplaneID = 1, @Model = 'Airbus A121', @Capacity = 230, @ProductionYear = '2018-01-01';

-- �������� �������� � ID = 1
EXEC DeleteAirplane @AirplaneID = 1;

-- ��������� ������ ���� ���������
EXEC GetAllAirplanes;

-- ���������� ���������� ��������
EXEC AddRandomAirplane;

-- �������� ���� ������� �� ������� Airplanes
EXEC DeleteAllAirplanes;


-- ����� �������� IDENTITY � ���������� � 1
DBCC CHECKIDENT ('Airplanes', RESEED, 0);
GO
DELETE FROM Airplanes


--===========================�����=============================--
EXECUTE AS USER = 'Customers'
-- ���������� ������ �����
EXEC AddFlight 'RTG', 'JFK', '2024-01-15T10:00:00', '2024-01-15T14:30:00', 1;

-- ���������� ������� ������ ������������� �����
EXEC UpdateFlight 1, 'RTG', 'JFK', '2024-01-15T11:00:00', '2024-01-15T15:30:00', 1;

-- �������� �����
EXEC DeleteFlight 1;

-- ��������� ���������� � ����� �� ID
EXEC GetFlightByID 1;

-- ��������� ������ ���� ������
EXEC GetAllFlights;

-- ��������� ������ ������ �� ���������
EXEC GetFlightsByAirport 'RTG';

-- ��������� ������ ������ �� 15 ������ 2024
EXEC GetFlightsByDate '2024-01-15';

EXEC AddRandomFlight

DBCC CHECKIDENT ('Flights', RESEED, 0);
GO

DELETE FROM Flights
--================���������============--


-- ���������� ������ ���������
EXEC AddPassenger @FirstName = 'John', @LastName = 'Doe', @PassportNumber = '1234567890', @BirthDate = '1980-03-10';

-- ���������� ���������� � ���������
EXEC UpdatePassenger @PassengerID = 1, @FirstName = 'John',  @LastName = 'Smith', @PassportNumber = '1234567890', @BirthDate = '1980-03-10';

-- �������� ���������
EXEC DeletePassenger @PassengerID = 1;

-- ��������� ���������� � ��������� �� ID
EXEC GetPassengerByID @PassengerID = 1;

-- ��������� ������ ���� ����������
EXEC GetAllPassengers;

-- ��������� ���������� � ��������� �� ������ ��������
EXEC GetPassengerByPassport @PassportNumber = '1234567890';

-- ���������� ��������� ����������

EXEC AddRandomPassenger;

-- ����� �������� IDENTITY � ���������� � 1
DBCC CHECKIDENT ('Passengers', RESEED, 0);
GO

DELETE FROM Passengers

--=====================������=============================--
-- ���������� ������ ������
EXEC AddTicket @FlightID = 1, @PassengerID = 5, @SeatNumber = '12A', @TicketClass = 'Economy', @Price = 250.00;

-- ���������� ���������� � ������
EXEC UpdateTicket @TicketID = 1, @FlightID = 1, @PassengerID = 5, @SeatNumber = '12A', @TicketClass = 'Business', @Price = 500.00; 

-- �������� ������
EXEC DeleteTicket @TicketID = 1;

-- ��������� ���������� � ������ �� ID
EXEC GetTicketByID @TicketID = 1;

-- ��������� ������ ���� �������
EXEC GetAllTickets;

-- ��������� ������ ������� �� ���� � ID
EXEC GetTicketsByFlight @FlightID = 1;

-- ��������� ������ �������, ��������� ���������� � ID 1
EXEC GetTicketsByPassenger @PassengerID = 1;

-- ���������� ��������� �������
DECLARE @i INT = 1;
WHILE @i <= 50
BEGIN
    EXEC AddRandomTicket;
    SET @i = @i + 1;
END;

DBCC CHECKIDENT ('Tickets', RESEED, 0);
GO

DELETE FROM Tickets

--=============����������================--

-- ���������� ������ ����������
EXEC AddEmployee @FirstName = 'Anna', @LastName = 'Petrova', @Position = 'Flight attendant', @HireDate = '2020-05-15';

-- ���������� ���������� � ����������
EXEC UpdateEmployee @EmployeeID = 1, @FirstName = 'Anna', @LastName = 'Petrova', @HireDate = '2020-05-15', @Position = 'Copilot'; 

-- �������� ����������
EXEC DeleteEmployee @EmployeeID = 1;

-- ��������� ���������� � ���������� �� ID
EXEC GetEmployeeByID @EmployeeID = 1;

-- ��������� ������ ���� �����������
EXEC GetAllEmployees;

-- ��������� ������ �������
EXEC GetEmployeesByPosition @Position = 'Copilot';

-- ���������� ��������� �����������
DECLARE @i INT = 1;
WHILE @i <= 20
BEGIN
    EXEC AddRandomEmployee;
    SET @i = @i + 1;
END;

DBCC CHECKIDENT ('Employees', RESEED, 0);
GO

DELETE FROM Employees

--================������===============--

-- ���������� ����� ������� � �����
EXEC AddCrewMember @FlightID = 1, @EmployeeID = 5, @Role = 'Flight attendant';

-- ���������� ���� ����� �������
EXEC UpdateCrewMember @CrewID = 1, @Role = 'Senior flight attendant';

-- �������� ����� ������� �� �����
EXEC DeleteCrewMember @CrewID = 1;

-- ��������� ������ ������� ��� ����� � ID 5
EXEC GetCrewByFlight @FlightID = 1;

-- ���������� ���������� ������� � ����� � ID 10
EXEC AddRandomCrew @FlightID = 5;



DBCC CHECKIDENT ('Crews', RESEED, 0);
GO

DELETE FROM Crews
--==================�������======================--

-- ��������� �������� �������� � ID 2
SELECT dbo.GetAirplaneAge(2) AS AirplaneAge;

-- �������� ����������� �������� � ID 1 �� ������������ ������
DECLARE @Available BIT;
SET @Available = dbo.IsAirplaneAvailable(1, '20231220', '20240105'); -- ������� ������ ���
SELECT CASE WHEN @Available = 1 THEN 'Available' ELSE 'Not available' END AS Availability;

-- ��������� ����� ����������� ���� ���������
SELECT dbo.GetTotalCapacity() AS TotalCapacity;

-- ��������� �������� �������� ���� ���������
SELECT dbo.GetAverageAirplaneAge() AS AverageAge;


-- ��������� ����������������� ����� � ID 10
SELECT dbo.GetFlightDuration(5) AS FlightDuration;

-- �������� ������� ��������� ���� � ������-������ �� ����� � ID 5
DECLARE @SeatsAvailable BIT;
SET @SeatsAvailable = dbo.AreSeatsAvailable(3, 'Business');
SELECT CASE WHEN @SeatsAvailable = 1 THEN 'Seats available' ELSE 'No seats available' END AS Availability;


-- ��������� ������� ����� ��������� � ID
SELECT dbo.GetPassengerFullName(5) AS PassengerName;

-- �������� ��������������� ��������� � ID
DECLARE @IsAdult BIT;
SET @IsAdult = dbo.IsPassengerAdult(6);
SELECT CASE WHEN @IsAdult = 1 THEN 'Adult' ELSE 'Minor' END AS AgeStatus;

-- ��������� ������ ���������� ��������� �������
SELECT dbo.GetTotalTicketsSold() AS TotalTicketsSold;

-- ��������� ����� ������� �� ������� ������� �� ���� � ID 15
SELECT dbo.GetRevenueByFlight(1) AS FlightRevenue;

-- ��������� ��������� ����������, � ������� ���� ������� ������ ����� �������
SELECT dbo.GetMostPopularDestination() AS MostPopularDestination;

-- ��������� ������� ���� ������
SELECT dbo.GetAverageTicketPrice() AS AverageTicketPrice;

-- ��������� ����� ������ ���������� � ID 12
SELECT dbo.GetEmployeeExperience(12) AS EmployeeExperience;

-- ��������� ���������� �������
SELECT dbo.GetTotalEmployeesByPosition('Pilot') AS NumberOfPilots;

SELECT dbo.IsCrewComplete(1) AS IsComplete;

--================������������ ���������================--



select * from Airplanes;
select * from Passengers;
select * from Employees;
select * from Crews;
select * from Tickets;
select * from Flights;
select * from ShoppingCart

Delete from Airplanes;
Delete from Passengers;
Delete from Employees;
Delete from Crews;
Delete from Tickets;
Delete from Flights;
Delete from ShoppingCart;



-- ����� ��������� ��� ���������� ������ � �������
EXEC AddToShoppingCart @FlightID, @PassengerID, @SeatNumber, @TicketClass, @Price;

DECLARE @TicketID INT = 2;

-- ����� ��������� ��� ��������� ������ � �������
EXEC ProcessTicket @TicketID;

EXEC GetAllAirplanes;
EXECUTE AS as user = 'Customer'

select current_user;
revert;
exec GetAllEmployees;
select * from Airplanes

SELECT DISTINCT local_tcp_port
FROM sys.dm_exec_connections
WHERE local_tcp_port IS NOT NULL;


--===============������������ ��=======================--
--������ ��
EXEC TotalPurge;


--������ ������

-- ���������� ������ ��������
EXEC AddAirplane @Model = 'Airbus A321', @Capacity = 220, @ProductionYear = '2018-01-01';
--��������� ������� �� ��� ID
EXEC UpdateAirplane @AirplaneID = 1, @Model = 'Airbus A121', @Capacity = 230, @ProductionYear = '2018-01-01';
-- �������� �������� � ID = 1
EXEC DeleteAirplane @AirplaneID = 1;

-- ��������� ������ ���� ���������
EXEC GetAllAirplanes;


--��������� ����
EXEC AddFlight 'RTG', 'JFK', '2024-10-15T10:00:00', '2024-10-15T14:30:00', 1;
EXEC GetAllFlights;

--��������� ����������� � ������ ������
-- ���������� ��������� �����������
DECLARE @i INT = 1;
WHILE @i <= 6
BEGIN
    EXEC AddRandomEmployee;
    SET @i = @i + 1;
END;
EXEC GetAllEmployees;

-- ���������� ���������� ������� � ����� � ID 1
EXEC AddRandomCrew @FlightID = 1;
EXEC GetAllCrew @FlightID = 1;

--������������ ������������
EXEC AddPassenger @FirstName = 'John', @LastName = 'Doe', @PassportNumber = '1234567890', @BirthDate = '1980-03-10';

EXEC GetAllPassengers;
--������������ ��������� ����� � �������

EXEC AddToShoppingCart @FlightID = 1, @PassengerID = 1, @SeatNumber = 'A23', @TicketClass = 'First', @Price = '200.0';

EXEC GetAllTickets;
--�������� ��������� �����

EXEC ProcessTicket @TicketID = 2;

EXEC GetAllCartData;
EXEC GetAllTickets;


DECLARE @airplaneCount INT = 1;
WHILE @airplaneCount <= 8
BEGIN
    EXEC AddRandomAirplane;
    SET @airplaneCount = @airplaneCount + 1;
END;

-- Flights (20,000)
DECLARE @flightCount INT = 1;
WHILE @flightCount <= 15
BEGIN
    EXEC AddRandomFlight;
    SET @flightCount = @flightCount + 1;
END;

-- Passengers (80,000)
DECLARE @passengerCount INT = 1;
WHILE @passengerCount <= 20
BEGIN
    EXEC AddRandomPassenger;
    SET @passengerCount = @passengerCount + 1;
END;

-- Tickets 
DECLARE @ticketCount INT = 1;
WHILE @ticketCount <= 1
BEGIN
    EXEC AddRandomTicket;
    SET @ticketCount = @ticketCount + 1;
END;

-- Employees (50)
DECLARE @employeeCount INT = 1;
WHILE @employeeCount <= 15
BEGIN
    EXEC AddRandomEmployee;
    SET @employeeCount = @employeeCount + 1;
END;

-- Crews (7 Fully Staffed Teams)
DECLARE @crewCount INT = 1;
WHILE @crewCount <= 2
BEGIN
    DECLARE @randomFlightID INT;
    SELECT TOP 1 @randomFlightID = FlightID FROM Flights ORDER BY NEWID();
    EXEC AddRandomCrew @FlightID = @randomFlightID;
    SET @crewCount = @crewCount + 1;
END;
SELECT * FROM ShoppingCart;
EXEC SortTable @TableName = 'Employees', @ColumnName = 'LastName', @SortOrder = 'DESC';
EXEC GetAllPassengers;
EXEC GetAllFlights;
EXEC GetAllTickets;

EXEC GetAllAirplanes
EXEC TotalPurge;
SELECT * FROM ShoppingCart







-- Airplanes (800)
DECLARE @airplaneCount INT = 1;
WHILE @airplaneCount <= 800
BEGIN
    EXEC AddRandomAirplane;
    SET @airplaneCount = @airplaneCount + 1;
END;

-- Flights (300)
DECLARE @flightCount INT = 1;
WHILE @flightCount <= 300
BEGIN
    EXEC AddRandomFlight;
    SET @flightCount = @flightCount + 1;
END;

-- Passengers (4000)
DECLARE @passengerCount INT = 1;
WHILE @passengerCount <= 4000
BEGIN
    EXEC AddRandomPassenger;
    SET @passengerCount = @passengerCount + 1;
END;

-- Tickets (3000)
DECLARE @ticketCount INT = 1;
WHILE @ticketCount <= 3000
BEGIN
    EXEC AddRandomTicket;
    SET @ticketCount = @ticketCount + 1;
END;

-- Employees (1000)
DECLARE @employeeCount INT = 1;
WHILE @employeeCount <= 1000
BEGIN
    EXEC AddRandomEmployee;
    SET @employeeCount = @employeeCount + 1;
END;

-- Crews (27)
DECLARE @crewCount INT = 1;
WHILE @crewCount <= 27
BEGIN
    DECLARE @randomFlightID INT;
    SELECT TOP 1 @randomFlightID = FlightID FROM Flights ORDER BY NEWID();
    EXEC AddRandomCrew @FlightID = @randomFlightID;
    SET @crewCount = @crewCount + 1;
END;

exec GetAllAirplanes
exec GetAllCrew @FlightID = 1;
exec GetAllEmployees
exec GetAllFlights
exec GetAllPassengers
exec GetAllTickets
exec GetAllCartData

