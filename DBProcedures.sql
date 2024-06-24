use aviasales;

--=============================================================--
--==========================���������==========================--
-- �������� ��������� ��� ����������� ��������� ������
CREATE PROCEDURE ShowTableStructure
AS
BEGIN
    -- ������ ��� ��������� ���������� � �������� � �� ��������
    SELECT 
        t.name AS TableName,
        c.name AS ColumnName,
        tp.name AS DataType,
        c.max_length AS MaxLength,
        c.is_nullable AS IsNullable,
        c.is_identity AS IsIdentity,
        ISNULL(pk.is_primary_key, 0) AS IsPrimaryKey,
        ISNULL(fk.is_foreign_key, 0) AS IsForeignKey
    FROM 
        sys.tables t
    INNER JOIN 
        sys.columns c ON t.object_id = c.object_id
    INNER JOIN 
        sys.types tp ON c.user_type_id = tp.user_type_id
    LEFT JOIN 
        (SELECT 
             ic.object_id, ic.column_id, 1 AS is_primary_key
         FROM 
             sys.index_columns ic
         INNER JOIN 
             sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
         WHERE 
             i.is_primary_key = 1) pk ON c.object_id = pk.object_id AND c.column_id = pk.column_id
    LEFT JOIN 
        (SELECT 
             fk.parent_object_id, fkc.parent_column_id, 1 AS is_foreign_key
         FROM 
             sys.foreign_keys fk
         INNER JOIN 
             sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id) fk ON c.object_id = fk.parent_object_id AND c.column_id = fk.parent_column_id
    ORDER BY 
        t.name, c.column_id;

    -- ������ ��� ��������� ���������� � ������� ������
    SELECT 
        fk.name AS FKName,
        tp.name AS ParentTable,
        cp.name AS ParentColumn,
        tr.name AS ReferencedTable,
        cr.name AS ReferencedColumn
    FROM 
        sys.foreign_keys fk
    INNER JOIN 
        sys.foreign_key_columns fkc ON fk.object_id = fkc.constraint_object_id
    INNER JOIN 
        sys.tables tp ON fkc.parent_object_id = tp.object_id
    INNER JOIN 
        sys.columns cp ON fkc.parent_object_id = cp.object_id AND fkc.parent_column_id = cp.column_id
    INNER JOIN 
        sys.tables tr ON fkc.referenced_object_id = tr.object_id
    INNER JOIN 
        sys.columns cr ON fkc.referenced_object_id = cr.object_id AND fkc.referenced_column_id = cr.column_id
    ORDER BY 
        fk.name;
END;

--=============================�������=============================--


-- ��������� ���������� ������ ��������
CREATE PROCEDURE AddAirplane
    @Model NVARCHAR(50),
    @Capacity INT,
    @ProductionYear DATE
AS
BEGIN
    INSERT INTO Airplanes (Model, Capacity, ProductionYear)
    VALUES (@Model, @Capacity, @ProductionYear);
END;
GO


-- ��������� ���������� ���������� � ��������
CREATE PROCEDURE UpdateAirplane
    @AirplaneID INT,
    @Model NVARCHAR(50),
    @Capacity INT,
    @ProductionYear DATE
AS
BEGIN
    UPDATE Airplanes
    SET Model = @Model, Capacity = @Capacity, ProductionYear = @ProductionYear
    WHERE AirplaneID = @AirplaneID;
END;
GO

-- ��������� �������� ��������
CREATE PROCEDURE DeleteAirplane
    @AirplaneID INT
AS
BEGIN
    DELETE FROM Airplanes
    WHERE AirplaneID = @AirplaneID;
END;
GO

-- ��������� ��������� ���������� � �������� �� ID
CREATE PROCEDURE GetAirplaneByID
    @AirplaneID INT
AS
BEGIN
    SELECT * FROM Airplanes
    WHERE AirplaneID = @AirplaneID;
END;
GO

-- ��������� ��������� ������ ���� ���������
CREATE PROCEDURE GetAllAirplanes
AS
BEGIN
    SELECT * FROM Airplanes;
END;
GO

-- ��������� ��������� ������ ��������� �� ������
CREATE PROCEDURE GetAirplanesByModel
    @Model NVARCHAR(50)
AS
BEGIN
    SELECT * FROM Airplanes
    WHERE Model = @Model;
END;
GO

-- ��������� ���������� ���������� ��������
CREATE PROCEDURE AddRandomAirplane
AS
BEGIN
    DECLARE @RandomModel NVARCHAR(50);
    DECLARE @RandomCapacity INT;
    DECLARE @RandomYear DATE;

    -- ������ ��������� ������� ���������
    DECLARE @Models TABLE (Model NVARCHAR(50));
    INSERT INTO @Models VALUES 
    ('Airbus A318'), ('Airbus A319'), ('Airbus A320'), ('Airbus A321'), ('Airbus A330'),
    ('Airbus A340'), ('Airbus A350'), ('Airbus A380'), ('Boeing 737'), ('Boeing 747'),
    ('Boeing 757'), ('Boeing 767'), ('Boeing 777'), ('Boeing 787'), ('Embraer E170'),
    ('Embraer E175'), ('Embraer E190'), ('Embraer E195'), ('Bombardier CRJ700'), ('Bombardier CRJ900'),
    ('Bombardier CRJ1000'), ('ATR 42'), ('ATR 72'), ('Sukhoi Superjet 100'), ('Mitsubishi Regional Jet');

    SELECT TOP 1 @RandomModel = Model FROM @Models ORDER BY NEWID();

    -- ��������� ��������� ����������� (150-400)
    SELECT @RandomCapacity = ROUND((350 - 150) * RAND() + 150, 0);

    -- ��������� ���������� ���� ������������ (2000-2023)
    SELECT @RandomYear = DATEADD(YEAR, ROUND((23 - 0) * RAND() + 0, 0), '20000101');

    -- ���������� ���������������� ��������
    INSERT INTO Airplanes (Model, Capacity, ProductionYear)
    VALUES (@RandomModel, @RandomCapacity, @RandomYear);
END;
GO



-- ��������� �������� ���� ���������
CREATE PROCEDURE DeleteAllAirplanes
AS
BEGIN
    DELETE FROM Airplanes;
END;
GO

--====================�����====================--


-- ��������� �������� ���� ������
CREATE PROCEDURE DeleteAllFlights
AS
BEGIN
    DELETE FROM Flights;
END;
GO


-- ��������� ���������� ������ �����
CREATE PROCEDURE AddFlight
    @DepartureAirport NVARCHAR(3),
    @ArrivalAirport NVARCHAR(3),
    @DepartureTime DATETIME,
    @ArrivalTime DATETIME,
    @AirplaneID INT
AS
BEGIN
    INSERT INTO Flights (DepartureAirport, ArrivalAirport, DepartureTime, ArrivalTime, AirplaneID)
    VALUES (@DepartureAirport, @ArrivalAirport, @DepartureTime, @ArrivalTime, @AirplaneID);
END;
GO

-- ��������� ���������� ���������� � �����
CREATE PROCEDURE UpdateFlight
    @FlightID INT,
    @DepartureAirport NVARCHAR(3),
    @ArrivalAirport NVARCHAR(3),
    @DepartureTime DATETIME,
    @ArrivalTime DATETIME,
    @AirplaneID INT
AS
BEGIN
    UPDATE Flights
    SET DepartureAirport = @DepartureAirport, ArrivalAirport = @ArrivalAirport, 
        DepartureTime = @DepartureTime, ArrivalTime = @ArrivalTime, AirplaneID = @AirplaneID
    WHERE FlightID = @FlightID;
END;
GO

-- ��������� �������� �����
CREATE PROCEDURE DeleteFlight
    @FlightID INT
AS
BEGIN
    DELETE FROM Flights
    WHERE FlightID = @FlightID;
END;
GO

-- ��������� ��������� ���������� � ����� �� ID
CREATE PROCEDURE GetFlightByID
    @FlightID INT
AS
BEGIN
    SELECT * FROM Flights
    WHERE FlightID = @FlightID;
END;
GO

-- ��������� ��������� ������ ���� ������
CREATE PROCEDURE GetAllFlights
AS
BEGIN
    SELECT * FROM Flights;
END;
GO

-- ��������� ��������� ������ ������ �� ���������
CREATE PROCEDURE GetFlightsByAirport
    @Airport NVARCHAR(3)
AS
BEGIN
    SELECT * FROM Flights
    WHERE DepartureAirport = @Airport OR ArrivalAirport = @Airport;
END;
GO

-- ��������� ��������� ������ ������ �� ������������ ����
CREATE PROCEDURE GetFlightsByDate
    @Date DATE
AS
BEGIN
    SELECT * FROM Flights
    WHERE CAST(DepartureTime AS DATE) = @Date;
END;
GO

-- ��������� ���������� ���������� �����
CREATE PROCEDURE AddRandomFlight
AS
BEGIN
    DECLARE @RandomDepartureAirport NVARCHAR(3);
    DECLARE @RandomArrivalAirport NVARCHAR(3);
    DECLARE @RandomDepartureTime DATETIME;
    DECLARE @RandomArrivalTime DATETIME;
    DECLARE @RandomAirplaneID INT;

    -- ������ ��������� ����������
    DECLARE @Airports TABLE (AirportCode NVARCHAR(3));
    INSERT INTO @Airports VALUES ('RTG'), ('JFK'), ('LAX'), ('LHR'), ('CDG'), ('HND');

    -- ����� ��������� ���������� ����������� � ��������
    SELECT TOP 1 @RandomDepartureAirport = AirportCode FROM @Airports ORDER BY NEWID();
    SELECT TOP 1 @RandomArrivalAirport = AirportCode FROM @Airports WHERE AirportCode != @RandomDepartureAirport ORDER BY NEWID();

    -- ��������� ��������� ���� ������ � ��������� ��������� 30 ����
    SELECT @RandomDepartureTime = DATEADD(DAY, ROUND((29 - 0) * RAND() + 0, 0), GETDATE());
    SET @RandomDepartureTime = DATEADD(HOUR, ROUND((23 - 0) * RAND() + 0, 0), @RandomDepartureTime); -- ��������� ���


    -- ��������� ��������� ���� ������� (�� 1-5 ����� ����� ������)
    SELECT @RandomArrivalTime = DATEADD(HOUR, ROUND((5 - 1) * RAND() + 1, 0), @RandomDepartureTime);

    -- ����� ���������� ��������
    SELECT TOP 1 @RandomAirplaneID = AirplaneID FROM Airplanes ORDER BY NEWID();

    -- ���������� ���������������� �����
    INSERT INTO Flights (DepartureAirport, ArrivalAirport, DepartureTime, ArrivalTime, AirplaneID)
    VALUES (@RandomDepartureAirport, @RandomArrivalAirport, @RandomDepartureTime, @RandomArrivalTime, @RandomAirplaneID);
END;
GO


-- �������� ��������� "���������� ������"


--=============���������============--

-- ��������� ���������� ������ ���������
CREATE PROCEDURE AddPassenger
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @PassportNumber NVARCHAR(20),
    @BirthDate DATE
AS
BEGIN
    INSERT INTO Passengers (FirstName, LastName, PassportNumber, BirthDate)
    VALUES (@FirstName, @LastName, @PassportNumber, @BirthDate);
END;
GO

-- ��������� ���������� ���������� � ���������
CREATE PROCEDURE UpdatePassenger
    @PassengerID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @PassportNumber NVARCHAR(20),
    @BirthDate DATE
AS
BEGIN
    UPDATE Passengers
    SET FirstName = @FirstName, LastName = @LastName, 
        PassportNumber = @PassportNumber, BirthDate = @BirthDate
    WHERE PassengerID = @PassengerID;
END;
GO

-- ��������� �������� ���������
CREATE PROCEDURE DeletePassenger
    @PassengerID INT
AS
BEGIN
    DELETE FROM Passengers
    WHERE PassengerID = @PassengerID;
END;
GO

-- ��������� ��������� ���������� � ��������� �� ID
CREATE PROCEDURE GetPassengerByID
    @PassengerID INT
AS
BEGIN
    SELECT * FROM Passengers
    WHERE PassengerID = @PassengerID;
END;
GO

-- ��������� ��������� ������ ���� ����������
CREATE PROCEDURE GetAllPassengers
AS
BEGIN
    SELECT * FROM Passengers;
END;
GO

-- ��������� ��������� ���������� � ��������� �� ������ ��������
CREATE PROCEDURE GetPassengerByPassport
    @PassportNumber NVARCHAR(20)
AS
BEGIN
    SELECT * FROM Passengers
    WHERE PassportNumber = @PassportNumber;
END;
GO

-- ��������� ���������� ���������� ���������
CREATE PROCEDURE AddRandomPassenger
AS
BEGIN
    DECLARE @RandomFirstName NVARCHAR(50);
    DECLARE @RandomLastName NVARCHAR(50);
    DECLARE @RandomPassportNumber NVARCHAR(20);
    DECLARE @RandomBirthDate DATE;

   DECLARE @FirstNames TABLE (FirstName NVARCHAR(50));
INSERT INTO @FirstNames VALUES 
    ('John'), ('Mary'), ('Alex'), ('Helen'), ('Dmitry'), ('Anna'), ('Sergey'), ('Olga'),
    ('Andrew'), ('Tatiana'), ('Vladimir'), ('Natalie'), ('Michael'), ('Catherine'), ('Alexander'), ('Julia'),
    ('Maxim'), ('Svetlana'), ('Nikita'), ('Irina');
DECLARE @LastNames TABLE (LastName NVARCHAR(50));
INSERT INTO @LastNames VALUES 
    ('Johnson'), ('Smith'), ('Brown'), ('Taylor'), ('Williams'), ('Jones'), ('Davis'), ('Miller'),
    ('Wilson'), ('Moore'), ('Taylor'), ('Anderson'), ('Thomas'), ('Jackson'), ('White'), ('Harris'),
    ('Martin'), ('Thompson');


    -- ����� ���������� ����� � �������
    SELECT TOP 1 @RandomFirstName = FirstName FROM @FirstNames ORDER BY NEWID();
    SELECT TOP 1 @RandomLastName = LastName FROM @LastNames ORDER BY NEWID();

    -- ��������� ���������� ������ �������� (10 ����)
    SELECT @RandomPassportNumber = CAST(RAND() * 100000000 AS bigint);

    -- ��������� ��������� ���� �������� (1950-2005)
    SELECT @RandomBirthDate = DATEADD(YEAR, ROUND((55 - 0) * RAND() + 0, 0), '19500101');

    -- ���������� ���������������� ���������
    INSERT INTO Passengers (FirstName, LastName, PassportNumber, BirthDate)
    VALUES (@RandomFirstName, @RandomLastName, @RandomPassportNumber, @RandomBirthDate);
END;
GO

-- ��������� �������� ���� ������
CREATE PROCEDURE DeleteAllPassengers
AS
BEGIN
    DELETE FROM Passengers;
END;
GO


--==============������==================--
CREATE PROCEDURE AddToShoppingCart
    @FlightID INT,
    @PassengerID INT,
    @SeatNumber NVARCHAR(4),
    @TicketClass NVARCHAR(20),
    @Price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO ShoppingCart (FlightID, PassengerID, SeatNumber, TicketClass, Price)
    VALUES (@FlightID, @PassengerID, @SeatNumber, @TicketClass, @Price);
END;


CREATE PROCEDURE ProcessTicket
    @TicketID INT
AS
BEGIN
    DECLARE @FlightID INT;
    DECLARE @PassengerID INT;
    DECLARE @SeatNumber NVARCHAR(4);
    DECLARE @TicketClass NVARCHAR(20);
    DECLARE @Price DECIMAL(10, 2);

    -- ��������� ������ ������ �� ������� �� ID
    SELECT 
        @FlightID = FlightID,
        @PassengerID = PassengerID,
        @SeatNumber = SeatNumber,
        @TicketClass = TicketClass,
        @Price = Price
    FROM ShoppingCart
    WHERE ItemID = @TicketID;

    -- ������� ������ ������ � ������� Tickets
    INSERT INTO Tickets (FlightID, PassengerID, SeatNumber, TicketClass, Price)
    VALUES (@FlightID, @PassengerID, @SeatNumber, @TicketClass, @Price);

    -- �������� ������ ������ �� �������
    DELETE FROM ShoppingCart WHERE ItemID = @TicketID;
END;

CREATE PROCEDURE GetAllCartData
AS
BEGIN
SELECT * FROM ShoppingCart;
END;

-- ��������� ���������� ������ ������
CREATE PROCEDURE AddTicket
    @FlightID INT,
    @PassengerID INT,
    @SeatNumber NVARCHAR(4),
    @TicketClass NVARCHAR(20),
    @Price DECIMAL(10, 2)
AS
BEGIN
    INSERT INTO Tickets (FlightID, PassengerID, SeatNumber, TicketClass, Price)
    VALUES (@FlightID, @PassengerID, @SeatNumber, @TicketClass, @Price);
END;
GO

-- ��������� ���������� ���������� � ������
CREATE PROCEDURE UpdateTicket
    @TicketID INT,
    @FlightID INT,
    @PassengerID INT,
    @SeatNumber NVARCHAR(4),
    @TicketClass NVARCHAR(20),
    @Price DECIMAL(10, 2)
AS
BEGIN
    UPDATE Tickets
    SET FlightID = @FlightID, PassengerID = @PassengerID, 
        SeatNumber = @SeatNumber, TicketClass = @TicketClass, Price = @Price
    WHERE TicketID = @TicketID;
END;
GO

-- ��������� �������� ������
CREATE PROCEDURE DeleteTicket
    @TicketID INT
AS
BEGIN
    DELETE FROM Tickets
    WHERE TicketID = @TicketID;
END;
GO

EXEC AddRandomFlight;
SELECT TOP 1 *
FROM Flights
ORDER BY FlightID DESC;

-- ��������� ��������� ���������� � ������ �� ID
CREATE PROCEDURE GetTicketByID
    @TicketID INT
AS
BEGIN
    SELECT * FROM Tickets
    WHERE TicketID = @TicketID;
END;
GO

-- ��������� ��������� ������ ���� �������
CREATE PROCEDURE GetAllTickets
AS
BEGIN
    SELECT * FROM Tickets;
END;
GO

-- ��������� ��������� ������ ������� �� ������������ ����
CREATE PROCEDURE GetTicketsByFlight
    @FlightID INT
AS
BEGIN
    SELECT * FROM Tickets
    WHERE FlightID = @FlightID;
END;
GO

-- ��������� ��������� ������ �������, ��������� ������������ ����������
CREATE PROCEDURE GetTicketsByPassenger
    @PassengerID INT
AS
BEGIN
    SELECT * FROM Tickets
    WHERE PassengerID = @PassengerID;
END;
GO

-- ��������� ���������� ���������� ������
CREATE PROCEDURE AddRandomTicket
AS
BEGIN
    DECLARE @RandomFlightID INT;
    DECLARE @RandomPassengerID INT;
    DECLARE @RandomSeatNumber NVARCHAR(4);
    DECLARE @RandomTicketClass NVARCHAR(20);
    DECLARE @RandomPrice DECIMAL(10, 2);

    -- ������ ��������� ������� �������
    DECLARE @TicketClasses TABLE (TicketClass NVARCHAR(20));
    INSERT INTO @TicketClasses VALUES ('Economy'), ('Business'), ('First');

    -- ����� ���������� ����� � ���������
    SELECT TOP 1 @RandomFlightID = FlightID FROM Flights ORDER BY NEWID();
    SELECT TOP 1 @RandomPassengerID = PassengerID FROM Passengers ORDER BY NEWID();

    -- ��������� ���������� ������ ����� (��� 1-30, ����� A-F)
    SELECT @RandomSeatNumber = CAST(RAND() * 30 + 1 AS NVARCHAR(20)) + CHAR(CAST(RAND() * 6 + 65 AS INT));

    -- ����� ���������� ������ ������
    SELECT TOP 1 @RandomTicketClass = TicketClass FROM @TicketClasses ORDER BY NEWID();

    -- ��������� ��������� ���� (100-1000)
    SELECT @RandomPrice = ROUND((1000 - 100) * RAND() + 100, 2);

	 -- ��������� ���������� ������ ����� (��� 1-30, ����� A-F)
    DECLARE @RandomRow INT;
    DECLARE @RandomSeat CHAR(1);

    SELECT @RandomRow = CAST(RAND() * 30 + 1 AS INT);
    SELECT @RandomSeat = CHAR(CAST(RAND() * 6 + 65 AS INT));

    SET @RandomSeatNumber = CAST(@RandomRow AS NVARCHAR(20)) + @RandomSeat;

    -- ���������� ���������������� ������
    INSERT INTO Tickets (FlightID, PassengerID, SeatNumber, TicketClass, Price)
    VALUES (@RandomFlightID, @RandomPassengerID, @RandomSeatNumber, @RandomTicketClass, @RandomPrice);
END;
GO

--=================����������============--

-- ��������� ���������� ������ ����������
CREATE PROCEDURE AddEmployee
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Position NVARCHAR(50),
    @HireDate DATE
AS
BEGIN
    INSERT INTO Employees (FirstName, LastName, Position, HireDate)
    VALUES (@FirstName, @LastName, @Position, @HireDate);
END;
GO

-- ��������� ���������� ���������� � ����������
CREATE PROCEDURE UpdateEmployee
    @EmployeeID INT,
    @FirstName NVARCHAR(50),
    @LastName NVARCHAR(50),
    @Position NVARCHAR(50),
    @HireDate DATE
AS
BEGIN
    UPDATE Employees
    SET FirstName = @FirstName, LastName = @LastName, 
        Position = @Position, HireDate = @HireDate
    WHERE EmployeeID = @EmployeeID;
END;
GO

-- ��������� �������� ����������
CREATE PROCEDURE DeleteEmployee
    @EmployeeID INT
AS
BEGIN
    DELETE FROM Employees
    WHERE EmployeeID = @EmployeeID;
END;
GO

-- ��������� ��������� ���������� � ���������� �� ID
CREATE PROCEDURE GetEmployeeByID
    @EmployeeID INT
AS
BEGIN
    SELECT * FROM Employees
    WHERE EmployeeID = @EmployeeID;
END;
GO

-- ��������� ��������� ������ ���� �����������
CREATE PROCEDURE GetAllEmployees
AS
BEGIN
    SELECT * FROM Employees;
END;
GO

-- ��������� ��������� ������ ����������� �� ���������
CREATE PROCEDURE GetEmployeesByPosition
    @Position NVARCHAR(50)
AS
BEGIN
    SELECT * FROM Employees
    WHERE Position = @Position;
END;
GO

-- ��������� ���������� ���������� ����������





--==================������==================--
-- ��������� ���������� ����� ������� � �����
CREATE PROCEDURE AddCrewMember
    @FlightID INT,
    @EmployeeID INT,
    @Role NVARCHAR(50)
AS
BEGIN
    INSERT INTO Crews (FlightID, EmployeeID, Role)
    VALUES (@FlightID, @EmployeeID, @Role);
END;
GO

-- ��������� ���������� ���� ����� �������
CREATE PROCEDURE UpdateCrewMember
    @CrewID INT,
    @Role NVARCHAR(50)
AS
BEGIN
    UPDATE Crews
    SET Role = @Role
    WHERE CrewID = @CrewID;
END;
GO

-- ��������� �������� ����� ������� �� �����
CREATE PROCEDURE DeleteCrewMember
    @CrewID INT
AS
BEGIN
    DELETE FROM Crews
    WHERE CrewID = @CrewID;
END;
GO

-- ��������� ��������� ������ ������� ��� �����
CREATE PROCEDURE GetCrewByFlight
    @FlightID INT
AS
BEGIN
    SELECT c.CrewID, e.FirstName, e.LastName, c.Role
    FROM Crews c
    JOIN Employees e ON c.EmployeeID = e.EmployeeID
    WHERE c.FlightID = @FlightID;
END;
GO

CREATE PROCEDURE AddRandomCrew
    @FlightID INT
AS
BEGIN
    -- Temporary table to store available employees (excluding pilots and copilots later)
    DECLARE @AvailableCrew TABLE (EmployeeID INT, Position NVARCHAR(50));

    -- Select employees with appropriate positions
    INSERT INTO @AvailableCrew
    SELECT EmployeeID, Position FROM Employees
    WHERE Position IN ('Pilot', 'Copilot', 'Flight attendant');

    -- Assign pilot (ensure uniqueness)
    DECLARE @SelectedPilotID INT;
    SELECT TOP 1 @SelectedPilotID = EmployeeID FROM @AvailableCrew WHERE Position = 'Pilot' ORDER BY NEWID();
    EXEC AddCrewMember @FlightID, @SelectedPilotID, 'Pilot';

    -- Assign copilot (exclude already selected pilot)
    DECLARE @SelectedCopilotID INT;
    SELECT TOP 1 @SelectedCopilotID = EmployeeID FROM @AvailableCrew WHERE Position = 'Copilot' AND EmployeeID <> @SelectedPilotID ORDER BY NEWID();
    EXEC AddCrewMember @FlightID, @SelectedCopilotID, 'Copilot';

    -- Create a temporary table excluding the selected pilot and copilot
    DECLARE @AvailableAttendants TABLE (EmployeeID INT);
    INSERT INTO @AvailableAttendants
    SELECT EmployeeID FROM @AvailableCrew
    WHERE EmployeeID NOT IN (@SelectedPilotID, @SelectedCopilotID) AND Position = 'Flight attendant';

    -- Assign flight attendants (ensure uniqueness and exclude pilot/copilot)
    DECLARE @NumAttendants INT = CAST(RAND() * 3 + 3 AS INT);
    WHILE @NumAttendants > 0
    BEGIN
        DECLARE @AttendantID INT;
        SELECT TOP 1 @AttendantID = EmployeeID FROM @AvailableAttendants ORDER BY NEWID();
        EXEC AddCrewMember @FlightID, @AttendantID, 'Flight attendant';
        
        -- Remove assigned attendant from the pool
        DELETE FROM @AvailableAttendants WHERE EmployeeID = @AttendantID;
        SET @NumAttendants = @NumAttendants - 1;
    END;
END;
GO
CREATE PROCEDURE GetAllCrew
@FlightID INT
AS
BEGIN
SELECT * FROM CREWS WHERE FlightID = @FlightID;
END;
GO


--===========�������=================--

--===========�������================--

-- ������� ��������� �������� �������� � �����
CREATE FUNCTION GetAirplaneAge (@AirplaneID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Age INT;
    SELECT @Age = DATEDIFF(YEAR, ProductionYear, GETDATE())
    FROM Airplanes
    WHERE AirplaneID = @AirplaneID;
    RETURN @Age;
END;
GO

-- ������� �������� ����������� ��������
CREATE FUNCTION IsAirplaneAvailable (@AirplaneID INT, @StartDate DATETIME, @EndDate DATETIME)
RETURNS BIT
AS
BEGIN
    DECLARE @Result BIT; -- ��������� ���������� ��� ����������

    -- �������� ������� �������������� ������
    IF EXISTS (SELECT 1 FROM Flights 
               WHERE AirplaneID = @AirplaneID
                 AND DepartureTime <= @EndDate AND ArrivalTime >= @StartDate)
        SET @Result = 0; -- ������� �� ��������
    ELSE
        SET @Result = 1; -- ������� ��������

    RETURN @Result; -- ���������� ���������
END;
GO

-- ������� ��������� ����� ����������� ���� ���������
CREATE FUNCTION GetTotalCapacity ()
RETURNS INT
AS
BEGIN
    DECLARE @TotalCapacity INT;
    SELECT @TotalCapacity = SUM(Capacity) FROM Airplanes;
    RETURN @TotalCapacity;
END;
GO

-- ������� ��������� �������� �������� ���� ���������
CREATE FUNCTION GetAverageAirplaneAge ()
RETURNS DECIMAL(5, 2)
AS
BEGIN
    DECLARE @AverageAge DECIMAL(5, 2);
    SELECT @AverageAge = AVG(DATEDIFF(YEAR, ProductionYear, GETDATE())) FROM Airplanes;
    RETURN @AverageAge;
END;
GO

--===============�����===================--

-- ������� ��������� ����������������� ����� � �����
CREATE FUNCTION GetFlightDuration (@FlightID INT)
RETURNS DECIMAL(5, 2)
AS
BEGIN
    DECLARE @Duration DECIMAL(5, 2);
    SELECT @Duration = DATEDIFF(MINUTE, DepartureTime, ArrivalTime) / 60.0
    FROM Flights
    WHERE FlightID = @FlightID;
    RETURN @Duration;
END;
GO

CREATE FUNCTION AreSeatsAvailable (@FlightID INT, @TicketClass NVARCHAR(20))
RETURNS BIT
AS
BEGIN
    DECLARE @AvailableSeats INT;
    DECLARE @BookedSeats INT;
    DECLARE @Result BIT; -- ��������� ���������� ��� ����������

    -- ��������� ���������� ���� � �������� ��� ������� ������
    SELECT @AvailableSeats = a.Capacity
    FROM Flights f
    JOIN Airplanes a ON f.AirplaneID = a.AirplaneID
    WHERE f.FlightID = @FlightID;

    -- ��������� ���������� ��������������� ���� �� ����� � ������ ������
    SELECT @BookedSeats = COUNT(*)
    FROM Tickets
    WHERE FlightID = @FlightID AND TicketClass = @TicketClass;

    -- �������� ������� ��������� ����
    IF @AvailableSeats > @BookedSeats
        SET @Result = 1; -- ���� ��������� �����
    ELSE
        SET @Result = 0; -- ��� ��������� ����

    RETURN @Result; -- ���������� ���������
END;
GO

--=======================���������=====================--

-- ������� ��������� ������� ����� ���������
CREATE FUNCTION GetPassengerFullName (@PassengerID INT)
RETURNS NVARCHAR(101)
AS
BEGIN
    DECLARE @FullName NVARCHAR(101);
    SELECT @FullName = FirstName + ' ' + LastName
    FROM Passengers
    WHERE PassengerID = @PassengerID;
    RETURN @FullName;
END;
GO

-- ������� �������� ��������������� ���������
CREATE FUNCTION IsPassengerAdult (@PassengerID INT)
RETURNS BIT
AS
BEGIN
    DECLARE @BirthDate DATE;
    DECLARE @IsAdult BIT; -- ��������� ���������� ��� ����������

    SELECT @BirthDate = BirthDate FROM Passengers WHERE PassengerID = @PassengerID;

    -- ��������, ������ �� �������� 18 ���
    IF DATEDIFF(YEAR, @BirthDate, GETDATE()) >= 18
        SET @IsAdult = 1; -- ����������������
    ELSE
        SET @IsAdult = 0; -- ������������������

    RETURN @IsAdult; -- ���������� ���������
END;
GO

-- ������� ��������� ������ ���������� ��������� �������
CREATE FUNCTION GetTotalTicketsSold ()
RETURNS INT
AS
BEGIN
    DECLARE @TotalTickets INT;
    SELECT @TotalTickets = COUNT(*) FROM Tickets;
    RETURN @TotalTickets;
END;
GO

-- ������� ��������� ����� ������� �� ������� ������� �� ������������ ����
CREATE FUNCTION GetRevenueByFlight (@FlightID INT)
RETURNS DECIMAL(12, 2)
AS
BEGIN
    DECLARE @Revenue DECIMAL(12, 2);
    SELECT @Revenue = SUM(Price) FROM Tickets WHERE FlightID = @FlightID;
    RETURN @Revenue;
END;
GO

-- ������� ��������� ��������� ����������, � ������� ���� ������� ������ ����� �������
CREATE FUNCTION GetMostPopularDestination ()
RETURNS NVARCHAR(3)
AS
BEGIN
    DECLARE @Destination NVARCHAR(3);
    SELECT TOP 1 @Destination = ArrivalAirport
    FROM Tickets t
    JOIN Flights f ON t.FlightID = f.FlightID
    GROUP BY ArrivalAirport
    ORDER BY COUNT(*) DESC;
    RETURN @Destination;
END;
GO

-- ������� ��������� ������� ���� ������
CREATE FUNCTION GetAverageTicketPrice ()
RETURNS DECIMAL(10, 2)
AS
BEGIN
    DECLARE @AveragePrice DECIMAL(10, 2);
    SELECT @AveragePrice = AVG(Price) FROM Tickets;
    RETURN @AveragePrice;
END;
GO

-- ������� ��������� ����� ������ ���������� � �����
CREATE FUNCTION GetEmployeeExperience (@EmployeeID INT)
RETURNS INT
AS
BEGIN
    DECLARE @Experience INT;
    SELECT @Experience = DATEDIFF(YEAR, HireDate, GETDATE())
    FROM Employees
    WHERE EmployeeID = @EmployeeID;
    RETURN @Experience;
END;
GO

-- ������� ��������� ���������� ����������� ������������ ���������
CREATE FUNCTION GetTotalEmployeesByPosition (@Position NVARCHAR(50))
RETURNS INT
AS
BEGIN
    DECLARE @TotalEmployees INT;
    SELECT @TotalEmployees = COUNT(*) FROM Employees WHERE Position = @Position;
    RETURN @TotalEmployees;
END;
GO

CREATE FUNCTION IsCrewComplete (@FlightID INT)
RETURNS varchar(20)
AS
BEGIN
    DECLARE @PilotCount INT;
    DECLARE @CopilotCount INT;
    DECLARE @FlightAttendantCount INT;
    DECLARE @IsComplete varchar(20); -- ��������� ���������� ��� ����������

    -- �������� ���������� �������, ������ ������� � ���������������
    SELECT @PilotCount = COUNT(*) FROM Crews WHERE FlightID = @FlightID AND Role = 'Pilot';
    SELECT @CopilotCount = COUNT(*) FROM Crews WHERE FlightID = @FlightID AND Role = 'Copilot';
    SELECT @FlightAttendantCount = COUNT(*) FROM Crews WHERE FlightID = @FlightID AND Role = 'Flight attendant';

    -- �������� ������� ������, ������� ������ � ���� �� 3 ���������������
    IF @PilotCount > 0 AND @CopilotCount > 0 AND @FlightAttendantCount >= 3
        SET @IsComplete = 'Crew Complete'; -- ������ �������������
    ELSE
        SET @IsComplete = 'Crew is not complete'; -- ������ �� �������������

    RETURN @IsComplete; -- ���������� ���������
END;
GO

CREATE PROCEDURE TotalPurge
AS
BEGIN
DBCC CHECKIDENT ('Tickets', RESEED, 0);
DELETE FROM Tickets
DBCC CHECKIDENT ('Crews', RESEED, 0);
DELETE FROM Crews
DBCC CHECKIDENT ('Flights', RESEED, 0);
DELETE FROM Flights
DBCC CHECKIDENT ('Employees', RESEED, 0);
DELETE FROM Employees
DBCC CHECKIDENT ('ShoppingCart', RESEED, 0);
DELETE FROM ShoppingCart
DBCC CHECKIDENT ('Airplanes', RESEED, 0);
DELETE FROM Airplanes
DBCC CHECKIDENT ('Passengers', RESEED, 0);
DELETE FROM Passengers;
END;


CREATE PROCEDURE SortTable
(
    @TableName NVARCHAR(128),  -- ��� �������
    @ColumnName NVARCHAR(128), -- ��� ������� ��� ����������
    @SortOrder NVARCHAR(4) = 'ASC' -- ������� ���������� (ASC ��� DESC)
)
AS
BEGIN
    -- �������� ������� �������
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TableName)
    BEGIN
        PRINT '������: ������� "' + @TableName + '" �� �������.';
        RETURN;
    END;

    -- �������� ������� �������
    IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = @TableName AND COLUMN_NAME = @ColumnName)
    BEGIN
        PRINT '������: ������� "' + @ColumnName + '" �� ������ � ������� "' + @TableName + '".';
        RETURN;
    END;

    -- �������� ������� ����������
    IF @SortOrder NOT IN ('ASC', 'DESC')
    BEGIN
        PRINT '������: �������� ������� ����������. ���������� ��������: ASC, DESC.';
        RETURN;
    END;

    -- ���������� ������������� SQL-�������
    DECLARE @sql NVARCHAR(MAX);
    SET @sql = N'SELECT * FROM ' + QUOTENAME(@TableName) + N' ORDER BY ' + QUOTENAME(@ColumnName) + N' ' + @SortOrder;

    -- ���������� ������������� SQL-�������
    EXEC sp_executesql @sql;
END;
--=============��������============--

CREATE TRIGGER tr_Tickets_CapacityCheck
ON Tickets
AFTER INSERT
AS
BEGIN
    -- �������� ���������� � ����������� �������
    DECLARE @InsertedFlightID INT;
    SELECT @InsertedFlightID = FlightID FROM inserted;

    -- �������� ����������� �������� ��� �����
    DECLARE @AirplaneCapacity INT;
    SELECT @AirplaneCapacity = a.Capacity
    FROM Flights f
    JOIN Airplanes a ON f.AirplaneID = a.AirplaneID
    WHERE f.FlightID = @InsertedFlightID;

    -- �������� ���������� �������, ��������� �� ���� ����
    DECLARE @SoldTicketsCount INT;
    SELECT @SoldTicketsCount = COUNT(*) FROM Tickets WHERE FlightID = @InsertedFlightID;

    -- ���������, ��������� �� ���������� ��������� ������� ����������� ��������
    IF @SoldTicketsCount > @AirplaneCapacity
    BEGIN
        -- ����������� ������ � ���������� ����������
        ROLLBACK TRANSACTION;
        THROW 50001, '������: ������ ������� ������ �������, ��� ����������� ��������.', 1;
    END;
END;

CREATE TRIGGER tr_Airplanes_Insert
ON Airplanes
AFTER INSERT
AS
BEGIN
    PRINT 'New airplane added to the database.';

   
END;
GO

CREATE TRIGGER tr_Airplanes_Update
ON Airplanes
AFTER UPDATE
AS
BEGIN
    PRINT 'Airplane information updated.';

    
END;
GO

CREATE TRIGGER tr_Airplanes_Delete
ON Airplanes
AFTER DELETE
AS
BEGIN
    PRINT 'Airplane deleted from the database.';

END;
GO



CREATE TRIGGER tr_Flights_Insert
ON Flights
AFTER INSERT
AS
BEGIN
    PRINT 'New flight added to the schedule.';
END;
GO

CREATE TRIGGER tr_Flights_Update
ON Flights
AFTER UPDATE
AS
BEGIN
    PRINT 'Flight information updated.';
END;
GO

CREATE TRIGGER tr_Flights_Delete
ON Flights
AFTER DELETE
AS
BEGIN
    PRINT 'Flight removed from the schedule.';
END;
GO


CREATE TRIGGER tr_Passengers_Insert
ON Passengers
AFTER INSERT
AS
BEGIN
    PRINT 'New passenger registered.';
END;
GO

CREATE TRIGGER tr_Passengers_Update
ON Passengers
AFTER UPDATE
AS
BEGIN
    PRINT 'Passenger information updated.';
END;
GO

CREATE TRIGGER tr_Passengers_Delete
ON Passengers
AFTER DELETE
AS
BEGIN
    PRINT 'Passenger data removed.';
END;
GO

CREATE TRIGGER tr_Tickets_Insert
ON Tickets
AFTER INSERT
AS
BEGIN
    PRINT 'New ticket purchased.';
END;
GO

CREATE TRIGGER tr_Tickets_Update
ON Tickets
AFTER UPDATE
AS
BEGIN
    PRINT 'Ticket information updated.';

    
END;
GO

CREATE TRIGGER tr_Tickets_Delete
ON Tickets
AFTER DELETE
AS
BEGIN
    PRINT 'Ticket cancelled.';
END;
GO

CREATE TRIGGER tr_Employees_Insert
ON Employees
AFTER INSERT
AS
BEGIN
    PRINT 'New employee hired.';
END;
GO

CREATE TRIGGER tr_Employees_Update
ON Employees
AFTER UPDATE
AS
BEGIN
    PRINT 'Employee information updated.';
END;
GO

CREATE TRIGGER tr_Employees_Delete
ON Employees
AFTER DELETE
AS
BEGIN
    PRINT 'Employee data removed.';
END;
GO


CREATE TRIGGER tr_Crews_Insert
ON Crews
AFTER INSERT
AS
BEGIN
    PRINT 'Crew member assigned to a flight.';
END;
GO

CREATE TRIGGER tr_Crews_Update
ON Crews
AFTER UPDATE
AS
BEGIN
    PRINT 'Crew member role updated.';
END;
GO

CREATE TRIGGER tr_Crews_Delete
ON Crews
AFTER DELETE
AS
BEGIN
    PRINT 'Crew member removed from a flight.';
END;
GO

-- Stored Procedure for Ticket Sales Report
CREATE PROCEDURE GetTicketSalesReport 
    @StartDate DATE,
    @EndDate DATE
AS
BEGIN
    -- Validate input parameters
    IF @StartDate > @EndDate
    BEGIN
        RAISERROR('Start date cannot be greater than end date.', 16, 1);
        RETURN;
    END;

    -- Select ticket sales data for the specified time period
    SELECT 
        f.DepartureAirport,
        f.ArrivalAirport,
        COUNT(t.TicketID) AS TicketsSold
    FROM Tickets t
    JOIN Flights f ON t.FlightID = f.FlightID
    WHERE t.FlightID IN (SELECT FlightID FROM Flights WHERE DepartureTime >= @StartDate AND DepartureTime <= @EndDate)
    GROUP BY f.DepartureAirport, f.ArrivalAirport
    ORDER BY f.DepartureAirport, f.ArrivalAirport;
END;
GO

-- Procedure to count flights
CREATE PROCEDURE GetFlightCount
AS
BEGIN
    SELECT COUNT(*) AS TotalFlights FROM Flights;
END;
GO

-- Procedure to calculate average travel distance
CREATE PROCEDURE GetAverageTravelDistance
AS
BEGIN
    SELECT AVG(dbo.CalculateDistance(f.DepartureAirport, f.ArrivalAirport)) AS AverageDistance
    FROM Flights f;
END;
GO

-- Procedure to calculate average ticket price

CREATE PROCEDURE GetAverageTicketPrice
AS
BEGIN
    SELECT AVG(Price) AS AverageTicketPrice FROM Tickets;
END;
GO
--=================������==============

-- �������� �������� ���������
-- �������� �� ������� ��������� � � ��������, ���� ��� ����������
IF OBJECT_ID('dbo.FillAirports', 'P') IS NOT NULL
    DROP PROCEDURE dbo.FillAirports;
GO

-- �������� �������� ���������
CREATE PROCEDURE dbo.FillAirports
AS
BEGIN
    -- �������� ������� Airports � ������������������ ��������� ������
    IF OBJECT_ID('dbo.Airports', 'U') IS NOT NULL
        DROP TABLE dbo.Airports;

    CREATE TABLE dbo.Airports (
        AirportID UNIQUEIDENTIFIER NOT NULL DEFAULT NEWID(),
        Code VARCHAR(3) NOT NULL,
        FullName VARCHAR(255) NOT NULL,
        Country VARCHAR(50) NOT NULL,
        City VARCHAR(100) NOT NULL,
        CONSTRAINT PK_Airports_AirportID PRIMARY KEY NONCLUSTERED (AirportID)
    );

    -- �������� ����� ��� ������������ ���������� ������� �������
    DECLARE @i INT = 1;
    DECLARE @Code VARCHAR(3);
    DECLARE @FullName VARCHAR(255);
    DECLARE @Country VARCHAR(50);
    DECLARE @City VARCHAR(100);

    WHILE @i <= 100000
    BEGIN
        -- ��������� ��������� ������
        SET @Code = (SELECT TOP 1 Code FROM (VALUES 
            ('SVO'), ('JFK'), ('LAX'), ('LHR'), ('CDG'), ('HND'), ('DXB'), ('HKG'), ('SIN'), ('PVG')) AS Codes(Code) ORDER BY NEWID());
        SET @FullName = (SELECT TOP 1 FullName FROM (VALUES 
            ('�����������'), 
            ('John F. Kennedy International Airport'), 
            ('Los Angeles International Airport'), 
            ('Heathrow Airport'), 
            ('Charles de Gaulle Airport'), 
            ('Narita International Airport'), 
            ('Dubai International Airport'), 
            ('Hong Kong International Airport'), 
            ('Changi Airport'), 
            ('Shanghai Pudong International Airport')) AS FullNames(FullName) ORDER BY NEWID());
        SET @Country = (SELECT TOP 1 Country FROM (VALUES 
            ('������'), 
            ('���'), 
            ('���'), 
            ('��������������'), 
            ('�������'), 
            ('������'), 
            ('���'), 
            ('�����'), 
            ('��������'), 
            ('�����')) AS Countries(Country) ORDER BY NEWID());
        SET @City = (SELECT TOP 1 City FROM (VALUES 
            ('������'), 
            ('���-����'), 
            ('���-��������'), 
            ('������'), 
            ('�����'), 
            ('�����'), 
            ('�����'), 
            ('�������'), 
            ('��������'), 
            ('������')) AS Cities(City) ORDER BY NEWID());

        -- ������� ������ � ������� Airports
        INSERT INTO dbo.Airports (Code, FullName, Country, City)
        VALUES (@Code, @FullName, @Country, @City);

        SET @i = @i + 1;
    END;
END;
GO

-- ����� �������� ���������
EXEC dbo.FillAirports;




CREATE PROCEDURE SELECTAIRPORTS
as
begin 
-- ������
-- ������ ��� ��������� ���������� ���������� � ������ ������
WITH CountryAirports AS (
    SELECT 
        Country,
        COUNT(*) AS AirportCount
    FROM 
        dbo.Airports
    GROUP BY 
        Country
),
-- ������ ��� ��������� ������������� ���������� ���������� � ����� ������
MaxCountryAirports AS (
    SELECT 
        MAX(AirportCount) AS MaxCount
    FROM 
        CountryAirports
),
-- ������ ��� ��������� ����� � ���������� ����������� ����������
TopCountries AS (
    SELECT 
        CountryAirports.Country,
        CountryAirports.AirportCount
    FROM 
        CountryAirports
    JOIN 
        MaxCountryAirports ON CountryAirports.AirportCount = MaxCountryAirports.MaxCount
),
-- ������ ��� ��������� ������� � ������� � ���������� ����������� ����������
CityAirports AS (
    SELECT 
        City,
        Country,
        COUNT(*) AS AirportCount
    FROM 
        dbo.Airports
    WHERE 
        Country IN (SELECT Country FROM TopCountries)
    GROUP BY 
        City, Country
)
-- ��������� ������ ��� ������ ����������
SELECT 
    ca.Country,
    ca.City,
    ca.AirportCount
FROM 
    CityAirports ca
ORDER BY 
    ca.Country, ca.AirportCount DESC, ca.City;
	END;
	GO


--===============����=================--
-- ���� dbowner � ������ ��������
CREATE ROLE dbowner;
-- �������������� ���� �� ���������� ���� �������� ���� public
GRANT EXECUTE TO dbowner;
GRANT EXECUTE ON GetAllPassengers TO dbowner

-- �������������� ���� �� CRUD-�������� ��� ���� ������ ���� db_datareader
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO dbowner

-- ���� customer � ������������ ��������
CREATE ROLE customer;
GRANT EXECUTE ON AddToShoppingCart TO customer;
GRANT EXECUTE ON GetAllCartData TO customer;
GRANT EXECUTE ON ProcessTicket TO customer;
GRANT EXECUTE ON GetTicketByID TO customer;
GRANT EXECUTE ON GetFlightByID TO customer;
GRANT EXECUTE ON AddToShoppingCart TO customer;
GRANT EXECUTE ON GetAllCartData TO customer;

ALTER ROLE dbowner ADD MEMBER "Owner";
ALTER ROLE customer ADD MEMBER "Customers";


--===============================================================================

CREATE NONCLUSTERED INDEX IX_Passengers_PassportNumber ON Passengers (PassportNumber);
DROP INDEX IX_Passengers_PassportNumber 


