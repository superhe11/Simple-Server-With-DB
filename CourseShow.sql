-- �	���������� ���� ��� �������������� �� � �������.
EXECUTE AS USER = 'Customers';
EXECUTE AS USER = 'Owner';
SELECT CURRENT_USER;
REVERT;


--Customer
EXEC AddToShoppingCart @FlightID = 1, @PassengerID = 1, @SeatNumber = 'A23', @TicketClass = 'First', @Price = '200.0';
EXEC DeleteTicket @TicketID = 3005
EXEC GetAllTickets;
EXEC GetAllCartData;
EXEC ProcessTicket @TicketID = 1;
EXEC GetAllTickets; --������
Select * from Airplanes --������
EXEC GetAllPassengers;

--�	����������� ������� �������� ��������: �����, ����, �������.
EXEC ShowTableStructure;
EXEC GetAllTickets
Exec GetAllFlights



--�	����������� ���������� ��������������: ����������, ��������������, �������� ������, ����������, ������� �������.
EXEC TotalPurge;
EXEC GetAllPassengers;
-- ���������� ������ ��������
EXEC AddAirplane @Model = 'Airbus A321', @Capacity = 2, @ProductionYear = '2018-01-01';
--��������� ������� �� ��� ID
EXEC UpdateAirplane @AirplaneID = 2, @Model = 'Airbus A121', @Capacity = 230, @ProductionYear = '2018-01-01';
-- �������� �������� � ID = 1
EXEC DeleteAirplane @AirplaneID = 2;
-- ��������� ������ ���� ���������
EXEC GetAllAirplanes;


--��������� ����
EXEC AddFlight 'RTG', 'JFK', '2024-10-15T10:00:00', '2024-10-15T14:30:00', 3;
EXEC GetAllFlights;

--��������� ����������� � ������ ������
DECLARE @i INT = 1;
WHILE @i <= 6
BEGIN
    EXEC AddRandomEmployee;
    SET @i = @i + 1;
END;
EXEC GetAllEmployees;

-- ���������� ���������� ������� � ����� � ID 1
EXEC AddRandomCrew @FlightID = 2;
EXEC GetAllCrew @FlightID = 1;

--������������ ������������
EXEC AddPassenger @FirstName = 'John', @LastName = 'Doe', @PassportNumber = '1234567890', @BirthDate = '1980-03-10';

EXEC GetAllPassengers;

--������������ ��������� ����� � �������
EXEC AddToShoppingCart @FlightID = 1, @PassengerID = 1, @SeatNumber = 'A23', @TicketClass = 'First', @Price = '200.0';
EXEC GetAllCartData;


--��������� �����
EXEC ProcessTicket @TicketID = 1;
EXEC GetAllTickets;
EXEC GetAllCartData;


--�	�������� ������� ���������� ������ � ��.
EXEC SortTable @TableName = 'Employees', @ColumnName = 'LastName', @SortOrder = 'DESC';

--� �������� ������� ������ ������ � ��.
 EXEC GetAirplanesByModel @Model = 'Boeing 777';

 -- ��������� ���������� � ����� �� ID
EXEC GetFlightByID 1;

-- ��������� ������ ���� ������
EXEC GetAllFlights;

-- ��������� ���������� � ��������� �� ID
EXEC GetPassengerByID @PassengerID = 1;

-- ��������� ������ ���� ����������
EXEC GetAllPassengers;

-- ��������� ���������� � ��������� �� ������ ��������
EXEC GetPassengerByPassport @PassportNumber = '12345678';


--�	�������� ����������� ������� � �������� ������� �������������.
-- ����������

--� ����������� ����������� �������� ������� (����� � ���-�� ��������� ������� �� ���������� �������).

EXEC GetTicketSalesReport @StartDate = '2023-01-01', @EndDate = '2025-01-01'; 


--�	����������� ������� ��������� ������ (���-�� ������, ������� ���������� ����, ������� ���� �������).

EXEC GetFlightCount;

EXEC GetAverageTicketPrice;
--================================(������)================================
-- ����� �������� ���������
EXEC dbo.FillAirports;
SELECT * FROM AIRPORTS;

EXEC SELECTAIRPORTS;

-- �������� ����������� ������� �� ������� Code
CREATE CLUSTERED INDEX IX_Airports_Code ON dbo.Airports (Code);
SELECT * FROM dbo.Airports WHERE Code = 'JFK';

--===============================(�������)===================================
use aviasales;
-- ������ ������������� ������� ��� ��������� �������� �������� � �����
SELECT dbo.GetAirplaneAge(1);

-- ������ ������������� ������� ��� �������� ����������� ��������
DECLARE @StartDate DATETIME = '2024-09-15';
DECLARE @EndDate DATETIME = '2024-03-08';
SELECT dbo.IsAirplaneAvailable(1, @StartDate, @EndDate);

DECLARE @StartDate DATETIME = '2024-15-09';
DECLARE @EndDate DATETIME = '2024-15-11';
SELECT dbo.IsAirplaneAvailable(1, @StartDate, @EndDate);

Select * from Flights

-- ������ ������������� ������� ��� ��������� ����������������� ����� � �����
SELECT dbo.GetFlightDuration(1);

-- ������ ������������� ������� ��� ��������� ������� ����� ���������
SELECT dbo.GetPassengerFullName(1);

-- ������ ������������� ������� ��� ��������� ����� ������� �� ������� ������� �� ������������ ����
SELECT dbo.GetRevenueByFlight(1);

-- ������ ������������� ������� ��� ��������� ��������� ����������, � ������� ���� ������� ������ ����� �������
SELECT dbo.GetMostPopularDestination();

-- ������ ������������� ������� ��� ��������� ����� ������ ���������� � �����
SELECT dbo.GetEmployeeExperience(1);

-- ������ ������������� ������� ��� ��������� ���������� ����������� ������������ ���������
SELECT dbo.GetTotalEmployeesByPosition('Pilot');

-- ������ ������������� ������� ��� ��������, ������������� �� ������
SELECT dbo.IsCrewComplete(1);

--================(��������)===================

--CREATE
EXEC AddTicket @FlightID = 1, @PassengerID = 5, @SeatNumber = '12A', @TicketClass = 'Economy', @Price = 250.00;

--UPDATE
EXEC UpdateTicket @TicketID = 1, @FlightID = 1, @PassengerID = 5, @SeatNumber = '12A', @TicketClass = 'Business', @Price = 500.00; 

--DELETE
EXEC DeleteTicket @TicketID = 1;

--Overextend
DECLARE @i INT = 1;
WHILE @i <= 220
BEGIN
    EXEC AddRandomTicket;
    SET @i = @i + 1;
END;
select * from Tickets
select * from Flights
Delete from Tickets;
EXEC AddAirplane @Model = 'Airbus A321', @Capacity = 2, @ProductionYear = '2018-01-01';
select * from Airplanes;