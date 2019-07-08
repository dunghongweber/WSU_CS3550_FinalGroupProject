/*
Contributors and Creators:
	Dung Hong
	Anthony Perez
*/
CREATE TABLE Brands_Group6
(
	BrandKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Brand varchar(40) NOT NULL,
	Active bit DEFAULT(1) NOT NULL
)

CREATE TABLE ComputerTypes_Group6
(
	ComputerTypeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerType varchar(25) NOT NULL
)

CREATE TABLE ComputerStatuses_Group6
(
	ComputerStatusKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerStatus varchar(50) NOT NULL,
	ActiveStatus bit NOT NULL  --an indicator of if this status means the computer is available or not
)

CREATE TABLE CPUTypes_Group6
(
	CPUTypeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	CPUType varchar(40) NOT NULL
)

CREATE TABLE Computers_Group6
(
	ComputerKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerTypeKey int NOT NULL,
	BrandKey int NOT NULL,    
	ComputerStatusKey int NOT NULL DEFAULT(0),
	PurchaseDate date NOT NULL,
	PurchaseCost money NOT NULL,
	MemoryCapacityInGB int NOT NULL,
	HardDriveCapacityinGB int NOT NULL,
	VideoCardDescription varchar (255),
	CPUTypeKey int NOT NULL,
	CPUClockRateInGHZ decimal (6, 4)
)

SET IDENTITY_INSERT Computers_Group6 ON
INSERT Computers_Group6 (ComputerKey, ComputerTypeKey, BrandKey, ComputerStatusKey, PurchaseDate, PurchaseCost, MemoryCapacityInGB,
	HardDriveCapacityinGB, VideoCardDescription, CPUTypeKey, CPUClockRateInGHZ) VALUES
	(1, 1, 1, 0, '1/1/2017', 1999.99, 32, 1024, 'Nvidia 1080', 1, 3.5),
	(2, 2, 4, 0, '1/1/2017', 2399.99, 16, 512, 'Nvidia GeForce GT 650M', 1, 2.5)
SET IDENTITY_INSERT Computers_Group6 OFF

CREATE TABLE Departments_Group6
(
	DepartmentKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Department varchar(255)
)

SET IDENTITY_INSERT Departments_Group6 ON
INSERT Departments_Group6 (DepartmentKey, Department) VALUES
	(1, 'CEO'),
	(2, 'Human Resources'),
	(3, 'Information Technology'),
	(4, 'Accounting')
SET IDENTITY_INSERT Departments_Group6 OFF

CREATE TABLE Employees_Group6
(
	EmployeeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	LastName varchar(25) NOT NULL,
	FirstName varchar(25) NOT NULL,
	Email varchar(50) NOT NULL,
	Hired date NOT NULL,
	Terminated date NULL,
	DepartmentKey int NOT NULL,
	SupervisorEmployeeKey int NOT NULL --CEO/Top of hierarchy should have their own EmployeeKey
)

SET IDENTITY_INSERT Employees_Group6 ON
INSERT Employees_Group6 (EmployeeKey, LastName, FirstName, Email, Hired, DepartmentKey, SupervisorEmployeeKey) VALUES
	(1, 'Ceo', 'John The', 'JCeo@thiscompany.com', '1/1/2017', 1, 1),
	(2, 'Brother', 'Big', 'BBrother@thiscompany.com', '1/1/2017', 2, 1),
	(3, 'Geek', 'Major', 'MGeek@thiscompany.com', '1/1/2017', 3, 1)
SET IDENTITY_INSERT Employees_Group6 OFF


CREATE TABLE EmployeeComputers_Group6
(
	EmployeeComputerKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeKey int NOT NULL,
	ComputerKey int NOT NULL,
	Assigned date NOT NULL,
	Returned date NULL
)

SET IDENTITY_INSERT ComputerStatuses_Group6 ON
	INSERT ComputerStatuses_Group6 (ComputerStatusKey, ComputerStatus, ActiveStatus) VALUES
    	(0, 'New', 1),
    	(1, 'Assigned', 1),
    	(2, 'Available', 1),
    	(3, 'Lost', 0),
    	(4, 'In for Repairs', 0),
    	(5, 'Retired', 1)
SET IDENTITY_INSERT ComputerStatuses_Group6 OFF

SET IDENTITY_INSERT CPUTypes_Group6 ON
INSERT CPUTypes_Group6 (CPUTypeKey, CPUType) VALUES
	(1, 'AMD'),
	(2, 'Intel'),
	(3, 'Samsung'),
	(4, 'Apple'),
	(5, 'Qualcomm')
SET IDENTITY_INSERT CPUTypes_Group6 OFF

SET IDENTITY_INSERT ComputerTypes_Group6 ON
INSERT ComputerTypes_Group6 (ComputerTypeKey, ComputerType) VALUES
	(1, 'Desktop'),
	(2, 'Laptop'),
	(3, 'Tablet'),
	(4, 'Phone')
SET IDENTITY_INSERT ComputerTypes_Group6 OFF

SET IDENTITY_INSERT Brands_Group6 ON
INSERT Brands_Group6 (BrandKey, Brand) VALUES
	(1, 'Apple'),
	(2, 'Samsung'),
	(3, 'Sony'),
	(4, 'HP'),
	(5, 'Acer'),
	(6, 'NVidia')
SET IDENTITY_INSERT Brands_Group6 OFF

ALTER TABLE Computers_Group6
	ADD CONSTRAINT FK_ComputerComputerTypes
	FOREIGN KEY (ComputerTypeKey)
	REFERENCES ComputerTypes_Group6 (ComputerTypeKey)

ALTER TABLE Computers_Group6
	ADD CONSTRAINT FK_ComputerBrands
	FOREIGN KEY (BrandKey)
	REFERENCES Brands_Group6 (BrandKey)

ALTER TABLE Computers_Group6
	ADD CONSTRAINT FK_ComputerComputerStatus
	FOREIGN KEY (ComputerStatusKey)
	REFERENCES ComputerStatuses_Group6 (ComputerStatusKey)

ALTER TABLE Computers_Group6
	ADD CONSTRAINT FK_ComputerCPUType
	FOREIGN KEY (CPUTypeKey)
	REFERENCES CPUTypes_Group6 (CPUTypeKey)

ALTER TABLE Employees_Group6
	ADD CONSTRAINT FK_EmployeeDepartment
	FOREIGN KEY (DepartmentKey)
	REFERENCES Departments_Group6 (DepartmentKey)

ALTER TABLE Employees_Group6
	ADD CONSTRAINT FK_EmployeeSupervisor
	FOREIGN KEY (SupervisorEmployeeKey)
	REFERENCES Employees_Group6 (EmployeeKey)

ALTER TABLE EmployeeComputers_Group6
	ADD CONSTRAINT FK_EmployeeComputerEmployee
	FOREIGN KEY (EmployeeKey)
	REFERENCES Employees_Group6 (EmployeeKey)

ALTER TABLE EmployeeComputers_Group6
	ADD CONSTRAINT FK_EmployeeComputerComputer
	FOREIGN KEY (ComputerKey)
	REFERENCES Computers_Group6 (ComputerKey)

/*******************************************************************
1] Design a table to store changes to computer assignments. 
You have to track every change of status, starting when a computer is added to the inventory, when it is lost, when it is assigned, reassigned, etc. 
You need datetime stamps when the change occured.  This will be key to the next three requests.
*******************************************************************/
CREATE TABLE ComputerStatusChanges_Group6
(
	ComputerStatusChangeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerKey int NOT NULL,
	ComputerStatusKey int NOT NULL,
	ChangedDate datetime DEFAULT(GETDATE())
)

ALTER TABLE ComputerStatusChanges_Group6
	ADD CONSTRAINT FK_ComputerChangeKey
	FOREIGN KEY (ComputerKey)		
	REFERENCES Computers_Group6 (ComputerKey)

ALTER TABLE ComputerStatusChanges_Group6
	ADD CONSTRAINT FK_StatusChangeKey
	FOREIGN KEY (ComputerStatusKey)
	REFERENCES ComputerStatuses_Group6 (ComputerStatusKey)

/*******************************************************************
Removing tables:
--Ryan Wheeler
DROP TABLE ComputerStatusChanges_Group6
DROP TABLE EmployeeComputers_Group6
DROP TABLE Employees_Group6
DROP TABLE Computers_Group6
DROP TABLE ComputerStatuses_Group6
DROP TABLE Brands_Group6
DROP TABLE ComputerTypes_Group6
DROP TABLE CPUTypes_Group6
DROP TABLE Departments_Group6

*/

/*
Some general rules for this assignment:

 - You can change the table structure if you feel it is necessary (the core structure is sound).  More likely, you'll want to add tables, constraints, columns, etc. to the existing structure.  Any changes you make need to be added to the script you turn in and well documented/commented.
 - Hard Drive size is always displayed in TB
 - Memory size is always displayed in GB
 - If I ask for the employee name, I want to see LastName, FirstName
 - Remember to start all your objects off with a prefix - for this project use "Group" followed by
	your number and an underscore (Group1_YourObjectGoesHere)
 - You can accomplish all the work utilizing the objects/structures we've talked about to date.  If you're not sure where to apply what, have a conversation and ask me for clarification.
 - Your overall goal is to complete the requested tasks and make your database retain good data quality and gracefully handle issues if they come up.


Assignment - you've been assigned to work with a web developer to develop out a computer inventory tracking system.  You'll be working on the data layer, providing interfaces for the web developer to consume with their ASP.NET code.  

You are expected, at a minimum, to complete the following tasks - 
*/

 /*- Create a view that shows all available computers (those that are new or available for 
reassignment).  Include all the computer specs, brand, etc. and, if applicable, the last person	who was assigned the machine (just in case you have any questions).  This list will be used to determine what computer to assign out.
*******************************************************************/
--Anthony Perez
CREATE VIEW
	AvailableComputers
	AS
    	SELECT
        	B.Brand,
        	CT.ComputerType,
        	C.MemoryCapacityInGB,
        	C.HardDriveCapacityinGB,
        	CPU.CPUType,
        	C.CPUClockRateInGHZ,
        	EC.FirstName [Previous Owner]
    	FROM
        	Computers_Group6 C
        	LEFT JOIN ComputerTypes_Group6 CT
            	ON C.ComputerTypeKey = CT.ComputerTypeKey
        	LEFT JOIN ComputerStatuses_Group6 CS
            	ON C.ComputerStatusKey = CS.ComputerStatusKey
        	LEFT JOIN Brands_Group6 B
            	ON C.BrandKey = B.BrandKey
        	LEFT JOIN CPUTypes_Group6 CPU
            	ON C.CPUTypeKey = CPU.CPUTypeKey
        	LEFT JOIN
            	(SELECT
                	E.FirstName,
                	E.LastName,
                	EC.ComputerKey,
                	EC.Returned
            	FROM
                		Employees_Group6 E
                	LEFT JOIN EmployeeComputers_Group6 EC
                    		ON E.EmployeeKey = EC.EmployeeKey
            	) EC
            	ON C.BrandKey = EC.ComputerKey
    	WHERE
        	CS.ComputerStatus = 'New'
        	OR
        	CS.ComputerStatus = 'Available'
/*******************************************************************
 - Create a view that shows all computers that are in for repair.  Include who the 
	computer belongs to, their email address, how long it has been in for repairs, 
	and the associated specs, brand, type, etc.  This list will be used to update those
	users that are waiting on repairs.
*******************************************************************/
--Anthony Perez
CREATE VIEW
	ComputersInRepair	
AS
	SELECT
		B.Brand,
		CT.ComputerType,
		C.MemoryCapacityInGB,
		C.HardDriveCapacityinGB,
		CPU.CPUType,
		C.CPUClockRateInGHZ,
		CSG.ChangedDate,
		EC.FirstName,
		EC.LastName,
		EC.Email
	FROM
		Computers_Group6 C
		LEFT JOIN ComputerTypes_Group6 CT
			ON C.ComputerTypeKey = CT.ComputerTypeKey
		LEFT JOIN CPUTypes_Group6  CPU
			ON C.CPUTypeKey = CPU.CPUTypeKey
		LEFT JOIN ComputerStatuses_Group6  CS
			ON C.ComputerStatusKey = CS.ComputerStatusKey
		LEFT JOIN Brands_Group6  B
			ON C.BrandKey = B.BrandKey
		LEFT JOIN ComputerStatusChanges_Group6 CSG
			ON C.ComputerKey = CSG.ComputerKey
		LEFT JOIN 
			(SELECT 
				E.FirstName,
				E.LastName,
				E.Email,
				EC.ComputerKey,
				EC.Returned
			FROM
				Employees_Group6 E
				LEFT JOIN EmployeeComputers_Group6  EC
					ON E.EmployeeKey = EC.EmployeeKey
			) EC
			ON C.BrandKey = EC.ComputerKey
	WHERE
		CS.ComputerStatusKey = 4
		
/*******************************************************************
 - Create a view that returns an employee list - should include their full name, email address, 
	their department, the number of computers they have, and who their supervisor is.  Only
	return active employees.
*******************************************************************/
--Ryan Wheeler
CREATE VIEW
	EmployeeList
	AS
	SELECT
		E.LastName AS Employee_LastName, 
		E.FirstName AS Employee_FirstName,
		E.Email,
		D.Department,
		COUNT(EC.EmployeeKey)[Total_Comps_Assigned],
		F.LastName AS Sup_LastName,
		F.FirstName AS Sup_FirstName
	FROM
		Employees_Group6 E
		LEFT JOIN Departments_Group6 D
			ON D.DepartmentKey = E.DepartmentKey
		LEFT JOIN EmployeeComputers_Group6 EC
			ON EC.EmployeeKey = E.EmployeeKey
		LEFT JOIN Employees_Group6 F
			ON E.SupervisorEmployeeKey = F.EmployeeKey
	WHERE
		E.Terminated IS NULL
		AND
		EC.Returned IS NULL
	GROUP BY
		E.FirstName, 
		E.LastName,
		E.Email,
		D.Department,
		F.LastName,
		F.FirstName


/*******************************************************************
 - Create a function (or functions) that will convert TB to GB and GB to TB. 
 Looking at the database, you can see that hard drive space is stored in GB but 
 the developer expects to be able to display TB (and doesn't want to do the conversion themselves). 
 They'll also be passing back TB when they manipulate computer inventory and you'll need to convert to GB to store.
*******************************************************************/
--function converts TB to GB
CREATE OR ALTER FUNCTION TBtoGB(@numTB int)
RETURNS int
AS
BEGIN
    RETURN @numTB*1000
END

--function converts GB to GB
CREATE OR ALTER FUNCTION GBtoTB(@numGB float)
RETURNS decimal(18,2)
AS
BEGIN
    RETURN @numGB/1000
END
/*
For testing those functions: 
drop function GBtoTB
drop function TBtoGB

SELECT
dbo.GBtoTB(C.HardDriveCapacityinGB),
C.HardDriveCapacityinGB
FROM
Computers_Group6 C
*/
/*******************************************************************
 - Create an inline table function that accepts a computer brand (or brand key) and returns 
 available computers of that brand back. 
 Return the same columns as you did in above computer inventory views.
*******************************************************************/
CREATE FUNCTION AvailableComputer
(
    @BrandID int
)
RETURNS @tempTable TABLE
(
    Brand varchar(255),
    ComputerType varchar(255),
    MemCap int,
    HardDriveCap int,
    CPUtype varchar(255),
    ClockRate int,
    ActiveID int,
    Cost decimal(18,2)
)
AS
BEGIN
	INSERT @tempTable (Brand, ComputerType, MemCap, HardDriveCap, CPUtype, ClockRate, ActiveID, Cost)

	SELECT
		B.Brand,
		CT.ComputerType,
		C.MemoryCapacityInGB,
		C.HardDriveCapacityinGB,
		CPUT.CPUType,
		C.CPUClockRateInGHZ,
		CSTT.ActiveStatus,
		C.PurchaseCost
	FROM
		Computers_Group6 C
		Inner Join ComputerTypes_Group6 CT ON CT.ComputerTypeKey = C.ComputerTypeKey
		Inner Join ComputerStatuses_Group6 CSTT ON CSTT.ComputerStatusKey = C.ComputerStatusKey
		Inner Join Brands_Group6 B ON B.BrandKey = C.BrandKey
		Inner Join CPUTypes_Group6 CPUT ON CPUT.CPUTypeKey = C.CPUTypeKey
	WHERE
		C.BrandKey = @BrandID
		AND
		CSTT.ActiveStatus = 1
RETURN
END
/*
--for testing this function: 
drop function AvailableComputer

SELECT * from dbo.AvailableComputer(1)
*/
--Dung Hong

/*******************************************************************
2] The web developer decides that the data layer is going to have to manage the audit
 logging of changes to computer statuses. Design the appropriate triggers to accomplish this,
 inserting data into the table you created above. 
*******************************************************************/

CREATE OR ALTER TRIGGER StatusChangeTrigger
ON Computers_group6
AFTER INSERT, UPDATE
AS
BEGIN
	INSERT ComputerStatusChanges_Group6 (ComputerKey,ComputerStatusKey)
	SELECT
		C.ComputerKey,
		C.ComputerStatusKey
	FROM
		inserted I
		INNER JOIN deleted d ON  d.ComputerKey = I.ComputerKey
		INNER JOIN Computers_Group6 C ON C.ComputerKey = I.ComputerKey
		WHERE C.ComputerStatusKey != D.ComputerStatusKey
			OR I.ComputerStatusKey = 0

END
/*******************************************************************
3] Create a view that shows all stolen/lost computers. Include who the computer belongs to,
when it was purchased, when it was lost, and amount depreciated, and how much is left.
To calculate this, we will assume a 36 month depreciation for desktops, 48 months for 
everything else (i.e each month we use up 1/36th or 1/48th of the original cost). 
You need to see how many months remain and multiple this by the original cost of the computer. 
A computer that costs 1800 will depreciate at $50 a month.
A computer lost after 13 months would have depreciated $650 and would still be worth $1150 (show these two values).
Maybe a function to compute depreciation? 
*******************************************************************/
CREATE OR ALTER FUNCTION Depreciation
(
	@date1 date,
	@date2 date,
	@PCtype int,
	@PCcost decimal
)
RETURNS int
AS
BEGIN
	DECLARE
	 @Result int
	 SET @Result = 1.00

	IF(@PCType = 1)
			SET @Result = @PCcost-(@PCcost*(Datediff(MONTH,@date1,@date2)/36))
	ELSE
			SET @Result= @PCcost-(@PCcost*(Datediff(MONTH,@date1,@date2)/48))
	Return @Result
END

CREATE OR ALTER VIEW PCdepreciation 
AS
	SELECT
		C.ComputerKey,
		E.FirstName,
		E.LastName,
		C.PurchaseDate,
		C.PurchaseCost,
		CSG.ChangedDate [Lost/StolenDate],
		--Depreciation Function
		dbo.Depreciation(C.purchaseDate,CSG.ChangedDate,C.ComputerTypeKey,C.PurchaseCost) [After Depreciation Value]

	FROM
		Computers_Group6 C
		JOIN ComputerStatuses_Group6 CS 
			ON C.ComputerStatusKey = CS.ComputerStatusKey
		LEFT JOIN EmployeeComputers_Group6 EC
			ON C.ComputerKey = EC.ComputerKey
		LEFT JOIN Employees_Group6 E
			ON E.EmployeeKey = EC.EmployeeKey
		LEFT JOIN ComputerStatusChanges_Group6 CSG
			ON C.ComputerKey = CSG.ComputerKey
	WHERE CS.ComputerStatusKey = 3



/*******************************************************************
4] Create a stored procedure/inline table function that shows the history of a computer- 
 starting with a record for when it was purchased all the way to when it is retired or lost.
 Include the computer information you did above, and where applicable the assigned employee 
 name and employee key.
*******************************************************************/
CREATE OR ALTER PROCEDURE PChistory
	@ComputerKey int
AS
	SELECT
		C.ComputerKey,
		B.Brand,
		CPU.CpuType,
		C.PurchaseDate,
		E.FirstName,
		E.LastName,
		E.EmployeeKey,
		CS.ComputerStatus,
		CSG.ChangedDate
	FROM
		Computers_Group6 C
		INNER JOIN ComputerStatusChanges_Group6 CSG 
			ON C.ComputerKey = CSG.ComputerKey
		LEFT JOIN Brands_Group6 B
			ON C.BrandKey = B.BrandKey
		LEFT JOIN CPUTypes_Group6 CPU
			ON C.CPUTypeKey = CPU.CPUTypeKey
		LEFT JOIN ComputerStatuses_Group6 CS 
			ON CSG.ComputerStatusKey = CS.ComputerStatusKey
		LEFT JOIN EmployeeComputers_Group6 EC
			ON C.ComputerKey = EC.ComputerKey
		LEFT JOIN Employees_Group6 E
			ON E.EmployeeKey = EC.EmployeeKey
	WHERE C.ComputerKey = @ComputerKey







/*******************************************************************
 - Adding new employees. Return the key of the newly created employee, 
 or an error message/code if something doesn't work. 
*******************************************************************/
CREATE PROCEDURE CreateNewEmployee
	@LastName varchar(25),
	@FirstName varchar(25),
	@Email varchar(50),
	@Hired date,
	@DepartmentKey int,
	@SupervisorEmployeeKey int,
	@EmployeeKey int OUTPUT,
	@ErrorCode int OUTPUT
AS
BEGIN TRY
	INSERT Employees_Group6 (LastName, FirstName, Email, Hired, DepartmentKey,SupervisorEmployeeKey)
		VALUES (@LastName, @FirstName, @Email, @Hired, @DepartmentKey, @SupervisorEmployeeKey)

    SET @EmployeeKey = SCOPE_IDENTITY()
    RETURN @EmployeeKey

END TRY
BEGIN CATCH
	SET @ErrorCode = ERROR_NUMBER()
	RETURN @ErrorCode
END CATCH

/*--For testing this procedure:
drop procedure CreateNewEmployee
*/
/******************************************************************
Updating
 an employee What happens if the employee is a 
 manager for other people? I expect you to make this 
 stored procedure bulletproof - don't expect the web 
 developer to think about these things…

-Update Employee’s Department
-Josh
******************************************************************/
CREATE PROCEDURE UpdateDepartment
@EmployeeKey int,
@DepartmentKey int,
@Success int OUTPUT,
@ErrorCode int OUTPUT
AS
BEGIN TRY
    declare @test int
    set @test = (select E.DepartmentKey from Departments_Group6 E where E.DepartmentKey == @test)
    --check if the department exists
    if(@test is null)
   	 begin
   	 --update new supervisor of the desired employee
   	 update Employees_Group6
   	 set DepartmentKey  = @DepartmentKey
   	 where EmployeeKey = @EmployeeKey

   		 --return if success
   		 set @Success = 1
   		 return @Success
   	 end
    else
   	 begin
   		 --return if fail
   		 set @ErrorCode = 1
   		 return @ErrorCode
   	 end
END TRY
BEGIN CATCH
    --return error
    set @ErrorCode = ERROR_NUMBER()
    return @ErrorCode
END CATCH
/*******************************************************************
 Creating a new department. Return the key of the newly created
 department or an error message/code if something doesn't work.
 Also, don't allow duplicate department names…
*******************************************************************/
CREATE OR ALTER PROCEDURE CreateNewDepartment
	@Department varchar(225),
	@DepartmentKey int OUTPUT,
	@ErrorCode int OUTPUT
AS
BEGIN TRY
    IF((select count(*) from Departments_Group6 D where D.Department = @Department) < 1 )
    BEGIN
   		INSERT Departments_Group6(Department)
   			VALUES (@Department)

   		SET @DepartmentKey = SCOPE_IDENTITY()
   	RETURN @DepartmentKey
    END
    ELSE
    BEGIN
   		SET @ErrorCode = 1
   		RETURN @ErrorCode
    END
END TRY
BEGIN CATCH
	SET @ErrorCode = ERROR_NUMBER()
	RETURN @ErrorCode
END CATCH

/*--For testing this procedure:
drop procedure CreateNewDepartment

select * from Departments_Group6
*/
/*******************************************************************
Update the supervisor of an employee or employees.  
Make sure it is a valid, active supervisor. *******************************************************************/
CREATE PROCEDURE UpdateSupervisor
@EmployeeKey int,
@SupervisorKey int,
@Success int OUTPUT,
@ErrorCode int OUTPUT
AS
BEGIN TRY
    DECLARE @test date
    SET @test = (SELECT E.Terminated FROM Employees_Group6 E WHERE E.EmployeeKey = @SupervisorKey)
    --check if the supervisor is already terminated
    IF(@test is null)
   	BEGIN
   	 --update new supervisor of the desired employee
   		UPDATE Employees_Group6
   		SET SupervisorEmployeeKey = @SupervisorKey
		WHERE EmployeeKey = @EmployeeKey
   		 --return if success
   		SET @Success = 1
   		RETURN @Success
   	END
    ELSE
   	BEGIN
   		 --return if fail
   		SET @ErrorCode = 1
   		RETURN @ErrorCode
   	END
END TRY
BEGIN CATCH
    --return error
    SET @ErrorCode = ERROR_NUMBER()
    RETURN @ErrorCode
END CATCH
/*
drop procedure UpdateSupervisor

DECLARE @CaptureUpdateSupervisor int
DECLARE @ErrorUpdateSupervisor int
EXEC UpdateSupervisor  '1', '5',@Success = @CaptureUpdateSupervisor OUTPUT, @ErrorCode = @ErrorUpdateSupervisor OUTPUT
SELECT @CaptureUpdateSupervisor[Success], @ErrorUpdateSupervisor[ErrorCode]

select * from Employees_Group6
*/
/*******************************************************************
 Terminate an employee.  Harder one - what happens to an employee's equipment when they are terminated
*******************************************************************/
/************************BY DUNG HONG**********/
create procedure TerminateEmployee
@EmployeeKey int,
@Success int OUTPUT,
@ErrorCode int OUTPUT
AS
BEGIN TRY
    declare @test date
    set @test = (select E.Terminated from Employees_Group6 E where E.EmployeeKey = @EmployeeKey)
    --check if the employee is already terminated
    if(@test is null)
    begin
   	 --get the date when terminate this employee
   	 declare @datechange date = getdate()

   	 --terminate employee in Employee table
   	 update Employees_Group6
   	 set Terminated = @datechange
   	 where EmployeeKey = @EmployeeKey
   	 /*
   	 use this reset for testing:

   	 update Employees_Group6
   	 set Terminated = Null
   	 where EmployeeKey = 1
   	 */

   	 --return all the computers this employee has
   	 update EmployeeComputers_Group6
   	 set Returned = @datechange
   	 where EmployeeKey = @EmployeeKey
   	 /*
   	 use this reset for testing:

   	 update EmployeeComputers_Group6
   	 set Returned = NULL
   	 where EmployeeKey = 1
   	 */

   	 /*
   	 --update all of this computer to AVAILABLE status
   	 --because when terminate an employee
   	 --all of his/her devices are Available for assigning
   	 */
   	 declare @TotalRow int --max of FOR LOOP
   	 declare @CurrentRow int --start point of FOR LOOP

   	 --temp table for storing all devices of terminaated employee
   	 declare @temptable TABLE (RowID int not null primary key identity(1,1),
   	 TheComputerKey int)

   	 --insert all devices of terminated employee to temptable
   	 insert into @temptable(TheComputerKey)
   	 select EC.ComputerKey from EmployeeComputers_Group6 EC
   	 where EC.EmployeeKey = @EmployeeKey
   	 --set Max of FOR LOOP as number of rows of temptable
   	 set @TotalRow = @@ROWCOUNT

   	 --start for loop at 0
   	 set @CurrentRow = 0

   	 --implement FOR LOOP using WHILE in TSQL
   	 While @CurrentRow < @TotalRow
   	 begin
   		 set @CurrentRow = @CurrentRow + 1    --increasement 1

   		 declare @TheKey int --temporary variable

   		 --store the ComputerKey in a row of the temptable into temp var
   		 set @TheKey = (select T.TheComputerKey from @temptable T where T.RowID = @CurrentRow)
   		 
   		 --perform insert to update status of the device
   		 --(statuskey 2 = Available)
   		 --in the ComputerStatusChanges_Group6 table
   		 insert into ComputerStatusChanges_Group6(ComputerKey, ComputerStatusKey,ChangedDate)
   		 values (@TheKey, 2, @datechange)
   	 end

   	 --return if success
   	 set @Success = 1
   	 return @Success
    end
    else
    begin
   	 --return if fail
   	 set @ErrorCode = 1
   	 return @ErrorCode
    end
END TRY
BEGIN CATCH
    --return error
    set @ErrorCode = ERROR_NUMBER()
    return @ErrorCode
END CATCH
/*
need to create the ComputerStatusChanges_Group6 table
with valid data to test this procedure:

drop procedure TerminateEmployee

DECLARE @CaptureTerminateEmp int
DECLARE @ErrorTerminateEmp int
EXEC TerminateEmployee  '1', @Success = @CaptureTerminateEmp OUTPUT, @ErrorCode = @ErrorTerminateEmp OUTPUT
SELECT @CaptureTerminateEmp[Success], @ErrorTerminateEmp[ErrorCode]

select * from Employees_Group6
select * from EmployeeComputers_Group6
select * from ComputerStatusChanges_Group6
select * from ComputerStatuses_Group6
*/

/*******************************************************************
 - Create a new computer.  Return the key of the newly created computer, or an error message/code.
*******************************************************************/
CREATE OR ALTER PROCEDURE CreateNewComputer
	@ComputerTypeKey int,
	@BrandKey int,
	@ComputerStatusKey int,
	@PurchaseDate date,
	@PurchaseCost money,
	@MemoryCapacityInGB int,
	@HardDriveCapacityinGB int,
	@VideoCardDescription varchar (255),
	@CPUTypeKey int,
	@CPUClockRateInGHZ decimal (6, 4),
	@ComputerKey int OUTPUT,
	@ErrorCode int OUTPUT
AS
BEGIN TRY

	-- A hardcap of $10,000 has been put in place for the cost of any one computer.  Under no circumstances should the database have something above this.

	IF @HardDriveCapacityinGB >= 5000
	BEGIN
		THROW 1, 'Error: Too much memory', 21;
	END

	-- A hardcap of $10,000 has been put in place for the cost of any one computer.  Under no circumstances should the database have something above this.

	IF @PurchaseCost >= 10000
	BEGIN
		THROW 16556, 'An Error Occurred', 42;
	END

	INSERT
		Computers_Group6(ComputerTypeKey, BrandKey, ComputerStatusKey,
		PurchaseDate, PurchaseCost, MemoryCapacityInGB, HardDriveCapacityinGB,
		VideoCardDescription, CPUTypeKey, CPUClockRateInGHZ)
		VALUES
		(@ComputerTypeKey, @BrandKey, @ComputerStatusKey,
		@PurchaseDate, @PurchaseCost, @MemoryCapacityInGB, @HardDriveCapacityinGB,
		@VideoCardDescription, @CPUTypeKey, @CPUClockRateInGHZ)

		SET @ComputerKey = SCOPE_IDENTITY()
		RETURN @ComputerKey
END TRY
BEGIN CATCH
	SET @ErrorCode = ERROR_NUMBER()
	RETURN @ErrorCode
END CATCH
/*
For testing this procedure:
drop procedure CreateNewComputer

select * from Computers_Group6
*/

/*******************************************************************
Assign/reassign a computer.  Shouldn't allow computers that are in for repair, lost, or retired to be assigned out.
*******************************************************************/

/****Ryan****
 - Assign/reassign a computer.  Shouldn't allow computers that are in for repair, lost, or retired to be assigned out.
 
CREATE PROCEDURE AssignComputer
@EmployeeKey int,
@ComputerKey int,
@EmployeeComputerKey int OUTPUT,
@ErrorCode int OUTPUT
AS
BEGIN TRY	
	IF((SELECT C.ComputerStatusKey FROM Computers_Group6 C WHERE C.ComputerKey = @ComputerKey) < 3)
	BEGIN
		DECLARE @DateChange date = getdate()
		DECLARE @CountOfComps int
		DECLARE @CountOfLaptops int
--Checking total sum of Desktops
		SELECT
			COUNT(C.ComputerKey)
		FROM
			Computers_Group6 C
		INNER JOIN EmployeeComputers_Group6 EC
			ON EC.ComputerKey = C.ComputerKey
		WHERE
			EC.EmployeeKey = @EmployeeKey
			AND
			C.ComputerKey = 1
			AND
			EC.Returned IS NULL
			AND
			C.ComputerTypeKey = 1
		HAVING
			COUNT(C.ComputerKey) = @CountOfComps
--Checking total sum of Laptops
		SELECT
			COUNT(C.ComputerKey)
		FROM
			Computers_Group6 C
			INNER JOIN EmployeeComputers_Group6 EC
				ON EC.ComputerKey = C.ComputerKey
		WHERE
			EC.EmployeeKey = @EmployeeKey
			AND
			C.ComputerKey = 1
			AND
			EC.Returned IS NULL
			AND
			C.ComputerTypeKey = 2
		HAVING
			COUNT(C.ComputerKey) = @CountOfLaptops
--Trying to set up Constraints for only 2 desktops
		SELECT
			COUNT(EC.ComputerKey)[Total]
		FROM
			EmployeeComputers_Group6 EC
		LEFT JOIN Employees_Group6 E
			ON E.EmployeeKey = EC.EmployeeKey
		LEFT JOIN Computers_Group6 C
			ON C.ComputerKey = EC.ComputerKey
		WHERE
			EC.EmployeeKey = @EmployeeKey
			OR
			EC.Returned IS NULL
			AND
			C.ComputerTypeKey = 1
--Trying to set up Contraints for only 1 laptop
		SELECT
			COUNT(EC.ComputerKey)[Total]
		FROM
			EmployeeComputers_Group6 EC
		LEFT JOIN Employees_Group6 E
			ON E.EmployeeKey = EC.EmployeeKey
		LEFT JOIN Computers_Group6 C
			ON C.ComputerKey = EC.ComputerKey
		WHERE
			EC.EmployeeKey = @EmployeeKey
			OR
			EC.Returned IS NULL
			AND
			C.ComputerTypeKey = 2
--If statement Error checking (Desktop)
		IF(COUNT(EC.ComputerKey) > 2) 
		BEGIN
			SET @ErrorCode = 1
			RETURN @ErrorCode
		END
--If Statement Error Checking (Laptop)
		IF(COUNT(EC.ComputerKey) > 1) 
		BEGIN
			SET @ErrorCode = 1
			RETURN @ErrorCode
		END

		UPDATE EmployeeComputers_Group6
		SET Returned = @DateChange
		WHERE ComputerKey = @ComputerKey

		INSERT INTO EmployeeComputers_Group6(EmployeeKey, ComputerKey, Assigned)
		VALUES(@EmployeeKey, @ComputerKey, @DateChange)

		SET @EmployeeComputerKey = SCOPE_IDENTITY()

		INSERT INTO ComputerStatusChanges_Group6(ComputerKey, ComputerStatusKey, DateChanged)
		VALUES(@ComputerKey, '1', @DateChange)

		RETURN @EmployeeComputerKey
	END
	ELSE
	BEGIN
		SET @ErrorCode = 1
		RETURN @ErrorCode
	END	
END TRY
BEGIN CATCH
	SET @ErrorCode = ERROR_NUMBER()
	RETURN @ErrorCode
END CATCH
*/

/**********Dung Hong********/
create or alter procedure AssignDevice
@EmployeeKey int,
@ComputerKey int,
@EmployeeComputerKey int OUTPUT,
@ErrorCode int OUTPUT
AS
BEGIN TRY
    --check if the device is not in repair or lost
	if((select C.ComputerStatusKey from Computers_Group6 C where C.ComputerKey = @ComputerKey) < 3)
	begin
   	 --if the device is a desktop
   	 if((select C.ComputerTypeKey from Computers_Group6 C where C.ComputerKey = 2) = 1)
   	 begin
   		 --if employee already has less than 2 desktop
   		 if((select
   			 COUNT(EC.EmployeeKey)[TotalDesktop]
   			 from
   			 EmployeeComputers_Group6 EC
   			 inner join
   			 Computers_Group6 C ON EC.ComputerKey = C.ComputerKey
   			 Where C.ComputerTypeKey = 1
   			 and
   			 EC.EmployeeKey = @EmployeeKey
   			 and
   			 EC.Returned is null) < 2
   			 )
   		 begin
   			 
   			  --get the date when assign this computer
   			 declare @datechange date = getdate()

   			 --if there is an employee who had this device
   			 --set that device to return for that employee
   			 update EmployeeComputers_Group6
   			 set Returned = @datechange
   			 where ComputerKey = @ComputerKey

   			 --insert new employee and assigned device in the table
   			 INSERT INTO EmployeeComputers_Group6(EmployeeKey, ComputerKey, Assigned)
   			 VALUES(@EmployeeKey, @ComputerKey, @datechange)

   			 set @EmployeeComputerKey = SCOPE_IDENTITY()

   			 --update the Status History of the device
   			 insert into ComputerStatusChanges_Group6(ComputerKey,
   			 ComputerStatusKey, ChangedDate)
   			 values
   			 (@ComputerKey,'1', @datechange)

   			 return @EmployeeComputerKey
   		 end
   		 else
   		 begin
   			 set @ErrorCode = 1
   			  return @ErrorCode
   		 end
   	 end
   	 --if the device is a laptop
   	 else if((select C.ComputerTypeKey from Computers_Group6 C where C.ComputerKey = @ComputerKey) = 2)
   	 begin
   		 --if employee already has less than 1 laptop
   		 if((select
   			 COUNT(EC.EmployeeKey)[TotalLaptop]
   			 from
   			 EmployeeComputers_Group6 EC
   			 inner join
   			 Computers_Group6 C ON EC.ComputerKey = C.ComputerKey
   			 Where C.ComputerTypeKey = 2
   			 and
   			 EC.EmployeeKey = @EmployeeKey
   			 and
   			 EC.Returned is null) < 1
   			 )
   		 begin
   			 
   			  --get the date when assign this computer
   			 declare @datechange1 date = getdate()

   			 --if there is an employee who had this device
   			 --set that device to return for that employee
   			 update EmployeeComputers_Group6
   			 set Returned = @datechange1
   			 where ComputerKey = @ComputerKey

   			 --insert new employee and assigned device in the table
   			 INSERT INTO EmployeeComputers_Group6(EmployeeKey, ComputerKey, Assigned)
   			 VALUES(@EmployeeKey, @ComputerKey, @datechange1)

   			 set @EmployeeComputerKey = SCOPE_IDENTITY()

   			 --update the Status History of the device
   			 insert into ComputerStatusChanges_Group6(ComputerKey,
   			 ComputerStatusKey, ChangedDate)
   			 values
   			 (@ComputerKey,'1', @datechange1)

   			 return @EmployeeComputerKey
   		 end
   		 else
   		 begin
   			 set @ErrorCode = 1
   			  return @ErrorCode
   		 end
   	 end
   	 --if the device is not a laptop or desktop
   	 else
   	 begin
   		 declare @datechange2 date = getdate()

   		 update EmployeeComputers_Group6
   		 set Returned = @datechange2
   		 where ComputerKey = @ComputerKey

   		 INSERT INTO EmployeeComputers_Group6(EmployeeKey, ComputerKey, Assigned)
   		 VALUES(@EmployeeKey, @ComputerKey, @datechange2)

   		 set @EmployeeComputerKey = SCOPE_IDENTITY()

   		 insert into ComputerStatusChanges_Group6(ComputerKey,
   		 ComputerStatusKey, ChangedDate)
   		 values
   		 (@ComputerKey,'1', @datechange2)

   		 return @EmployeeComputerKey
   	 end
	end
	else
	begin
    	set @ErrorCode = 1
    	return @ErrorCode
	end
END TRY
BEGIN CATCH
	set @ErrorCode = ERROR_NUMBER()
	return @ErrorCode
END CATCH
/*
drop procedure AssignDevice

DECLARE @CaptureAssignDevice int
DECLARE @ErrorAssignDevice int
EXEC AssignDevice  '2','2', @EmployeeComputerKey = @CaptureAssignDevice OUTPUT, @ErrorCode = @ErrorAssignDevice OUTPUT
SELECT @CaptureAssignDevice[EmployeeComputerKey], @ErrorAssignDevice[ErrorCode]

select * from Employees_Group6
select * from Computers_Group6
select * from ComputerStatuses_Group6
select * from ComputerTypes_Group6
select * from EmployeeComputers_Group6
select * from ComputerStatusChanges_Group6
*/
/**********Dung Hong********/


/*******************************************************************
 - Change the status of a computer (lost computers, in for repairs, etc.)
*******************************************************************/
CREATE OR ALTER PROCEDURE UpdateComputerStatus
	@ComputerKey int,
	@ComputerStatusKey int,
	@Success int OUTPUT,
	@ErrorCode int OUTPUT
AS
BEGIN TRY
    UPDATE Computers_Group6
    SET ComputerStatusKey = @ComputerStatusKey
    WHERE ComputerKey = @ComputerKey

    SET @Success = 1
    RETURN @Success
END TRY
BEGIN CATCH
    SET @ErrorCode = ERROR_NUMBER()
    RETURN @ErrorCode
END CATCH
/*For testing this procedure: 
drop procedure UpdateComputerStatus

select * from Computers_Group6
*/
/*******************************************************************
 - Return a computer
*******************************************************************/
CREATE OR ALTER PROCEDURE ReturnAComputer
    @EmployeeKey int,
	@ComputerKey int,
    @Success int OUTPUT,
	@ErrorCode int OUTPUT
AS
BEGIN TRY
    if((select EC.Returned from EmployeeComputers_Group6 EC where EC.ComputerKey = 1 AND EC.EmployeeKey = 1) IS NULL)
    begin
   	 Declare @DateReturn date = GETDATE()

   	 Update EmployeeComputers_Group6
   	 SET Returned = @DateReturn
   	 Where ComputerKey = @ComputerKey
   	 AND EmployeeKey = @EmployeeKey

   	 INSERT ComputerStatusChanges_Group6(ComputerKey,ComputerStatusKey,ChangedDate)
   	 Values (@ComputerKey,2,@DateReturn)

   	 SET @Success = 1
   	 Return @Success
    end
    else
    begin
   	 SET @ErrorCode = 1
   	 Return @ErrorCode
    end
END TRY
BEGIN CATCH
	SET @ErrorCode = ERROR_NUMBER()
	RETURN @ErrorCode
END CATCH

/*
drop procedure ReturnAComputer

declare @SuccessReturn int
declare @ErrorReturn int
exec ReturnAComputer '2','2', @Success = @SuccessReturn OUTPUT, @ErrorCode = @ErrorReturn OUTPUT
select @SuccessReturn[Return Success], @ErrorReturn [REturn fail]

select * from Employees_Group6
select * from Computers_Group6
select * from ComputerStatuses_Group6
select * from ComputerTypes_Group6
select * from EmployeeComputers_Group6
select * from ComputerStatusChanges_Group6
*/

/*******************************************************************
 - Retire a computer.  Make sure the computer is fully depreciated, or do not let it be retired.
*******************************************************************/
CREATE OR ALTER PROCEDURE UpdateComputerStatus
	@ComputerKey int,
	@ComputerStatusKey int,
	@Success int OUTPUT,
	@ErrorCode int OUTPUT
AS
BEGIN TRY
	UPDATE Computers_Group6
	SET ComputerStatusKey = @ComputerStatusKey
	WHERE ComputerKey = @ComputerKey

     INSERT ComputerStatusChanges_Group6(ComputerKey,ComputerStatusKey,ChangedDate)
	Values (@ComputerKey,@ComputerStatusKey,GETDATE())


	SET @Success = 1
	RETURN @Success
END TRY
BEGIN CATCH
	SET @ErrorCode = ERROR_NUMBER()
	RETURN @ErrorCode
END CATCH

/*******************************************************************
For testing this procedure:
drop procedure RetireAComputer

select * from Computers_Group6
*******************************************************************/
--by Dung Hong

6] Your compliance officer is adamant that certain safeguards are installed in the database. Consider the following:

/*
Anthony - Do not let anyone delete a computer record.  Can't happen! 
 We have to prove that no equipment is being purchased and removed from
 our systems to sell privately. Instead of a delete, the computer
 should be retired, or made available (depending on its depreciation status).
************/

/*
Once your code is completed, provide scripts to complete the following
(including display of output variables or errors as applicable).
*/

/*******************************************************************
 - Create the department 'Business Intelligence'
*******************************************************************/
DECLARE @CaptureCreateDep int
DECLARE @ErrorCreateDep int
EXEC CreateNewDepartment  'Business Intelligence', @DepartmentKey = @CaptureCreateDep OUTPUT, @ErrorCode = @ErrorCreateDep OUTPUT
SELECT @CaptureCreateDep[Departmentkey], @ErrorCreateDep[ErrorCode]

/*******************************************************************
 - Add two valid employee, both part of Business Intelligence
*******************************************************************/
DECLARE @CaptureCreateEmp int
DECLARE @ErrorCreateEmp int
EXEC CreateNewEmployee  'English','Johny', 'johnyenglish@thiscomapny.com', '1/21/2018', '5',  '4', @EmployeeKey = @CaptureCreateEmp OUTPUT, @ErrorCode = @ErrorCreateEmp OUTPUT
SELECT @CaptureCreateEmp[Employeekey], @ErrorCreateEmp[ErrorCode]

--2nd employee
DECLARE @CaptureCreateEmp int
DECLARE @ErrorCreateEmp int
EXEC CreateNewEmployee  'Ventura','Ace', 'aceventurah@thiscomapny.com', '2/16/2017', '5',  '4', @EmployeeKey = @CaptureCreateEmp OUTPUT, @ErrorCode = @ErrorCreateEmp OUTPUT
SELECT @CaptureCreateEmp[Employeekey], @ErrorCreateEmp[ErrorCode]

/*******************************************************************
 - Try to add an employee, passing in a department that doesn't exist
*******************************************************************/

-- Gives out error code if the department doesn’t exist
DECLARE @CaptureCreateEmp int
DECLARE @ErrorCreateEmp int
EXEC CreateNewEmployee  'Ventura','Ace', 'aceventurah@thiscomapny.com', '2/16/2017', '8',  '4', @EmployeeKey = @CaptureCreateEmp OUTPUT, @ErrorCode = @ErrorCreateEmp OUTPUT
SELECT @CaptureCreateEmp[Employeekey], @ErrorCreateEmp[ErrorCode]

/*******************************************************************
 - Try to add an employee, passing in a supervisor that
  is no longer active (what should this do?)
*******************************************************************/
--try to terminate Employee 2
DECLARE @CaptureTerminateEmp int
DECLARE @ErrorTerminateEmp int
EXEC TerminateEmployee  '2', @Success = @CaptureTerminateEmp OUTPUT, @ErrorCode = @ErrorTerminateEmp OUTPUT
SELECT @CaptureTerminateEmp[Success], @ErrorTerminateEmp[ErrorCode]

--give out error code when create new employee with supervisor as employee 2
DECLARE @CaptureCreateEmp int
DECLARE @ErrorCreateEmp int
EXEC CreateNewEmployee  ‘Bob','John', bobjohn@thiscomapny.com', '1/23/2018', '5',  '2', @EmployeeKey = @CaptureCreateEmp OUTPUT, @ErrorCode = @ErrorCreateEmp OUTPUT
SELECT @CaptureCreateEmp[Employeekey], @ErrorCreateEmp[ErrorCode]


/*******************************************************************
 - Update an employees department to 'Human Resources'
*******************************************************************/
DECLARE @UpdateSuccess int
DECLARE @UpdateErrCode int

EXEC UpdateDepartment '4','2', @Success = @UpdateSuccess OUTPUT, @ErrorCode = @UpdateErrCode OUTPUT
SELECT @UpdateSuccess[Success], @UpdateErrCode[ErrorCode]

Select * from Employees_Group6


/*******************************************************************
 - Try to update an employees department to 'Moon Staff' (assuming that 'Moon Staff' doesn't exist in your database). 
*******************************************************************/
--Moon staff invalid info Employees departments updated by department key
--Attempted update to invalid departmentKey
DECLARE @UpdateSuccess int
DECLARE @UpdateErrCode int

EXEC UpdateDepartment '4','12', @Success = @UpdateSuccess OUTPUT, @ErrorCode = @UpdateErrCode OUTPUT
SELECT @UpdateSuccess[Success], @UpdateErrCode[ErrorCode]


/*******************************************************************
 - Update an employees supervisor to an active employee
*******************************************************************/
DECLARE @CaptureUpdateSupervisor int
DECLARE @ErrorUpdateSupervisor int
EXEC UpdateSupervisor  '4', '1',@Success = @CaptureUpdateSupervisor OUTPUT, @ErrorCode = @ErrorUpdateSupervisor OUTPUT
SELECT @CaptureUpdateSupervisor[Success], @ErrorUpdateSupervisor[ErrorCode]
/*******************************************************************
 - Try updating an employees supervisor to an inactive employee. Should this work?
*******************************************************************/
--Terminate Employee
DECLARE @CaptureTerminateEmp int
DECLARE @ErrorTerminateEmp int
EXEC TerminateEmployee  '1', @Success = @CaptureTerminateEmp OUTPUT, @ErrorCode = @ErrorTerminateEmp OUTPUT
SELECT @CaptureTerminateEmp[Success], @ErrorTerminateEmp[ErrorCode]

--Tries to update employees supervisor to inactive employee
DECLARE @CaptureUpdateSupervisor int
DECLARE @ErrorUpdateSupervisor int
EXEC UpdateSupervisor  '4', '3',@Success = @CaptureUpdateSupervisor OUTPUT, @ErrorCode = @ErrorUpdateSupervisor OUTPUT
SELECT @CaptureUpdateSupervisor[Success], @ErrorUpdateSupervisor[ErrorCode]
/*******************************************************************
 - Create a new Mac Book pro laptop for Major Geek.  Use whatever specs you can find 
 off the Apple web page.  Make sure the laptop gets assigned to Major Geek
*******************************************************************/
--create a Mac Book pro laptop
DECLARE @CaptureOutput int
DECLARE @ErrorOutput varchar(255)
EXEC CreateNewComputer  '2','1', '1', '3/22/2018', '1299', '8', '128', 'Intel Iris Plus Graphics 640', '2', '2.3', @ComputerKey = @CaptureOutput OUTPUT, @ErrorCode = @ErrorOutput OUTPUT
SELECT @CaptureOutput[ComputerKey], @ErrorOutput [Error]

--assign it to Major Geek
DECLARE @CaptureAssignDevice int
DECLARE @ErrorAssignDevice int
EXEC AssignDevice  '3','3', @EmployeeComputerKey = @CaptureAssignDevice OUTPUT, @ErrorCode = @ErrorAssignDevice OUTPUT
SELECT @CaptureAssignDevice[EmployeeComputerKey], @ErrorAssignDevice[ErrorCode]

/*******************************************************************
 - Terminate employee #3 (Major Geek)
*******************************************************************/
--Terminate Employee #3
DECLARE @CaptureTerminateEmp int
DECLARE @ErrorTerminateEmp int
EXEC TerminateEmployee  '3', @Success = @CaptureTerminateEmp OUTPUT, @ErrorCode = @ErrorTerminateEmp OUTPUT
SELECT @CaptureTerminateEmp[Success], @ErrorTerminateEmp[ErrorCode]

/*******************************************************************
 - A query using your inline table function to display available apple computers
*******************************************************************/

SELECT * from dbo.AvailableComputer(1)

/*******************************************************************
 - A query (using inline view or stored procedure) that shows the history of a specific computer in your database.
*******************************************************************/

 EXEC PChistory 1

/*******************************************************************
 - Deal with the CEO losing his laptop.
*******************************************************************/
--update LOST status for CEO laptop
declare @SuccessUpdatePCstt int
declare @ErrorUpdatePCstt int
exec UpdateComputerStatus '2', '3', @Success = @SuccessUpdatePCstt OUTPUT, @ErrorCode = @ErrorUpdatePCstt OUTPUT
select @SuccessUpdatePCstt[Update Done], @ErrorUpdatePCstt[Update Fail]


/*******************************************************************
 - Add two computers of your own chosing
*******************************************************************/
--Add Macbook Air to database
DECLARE @CaptureOutput int
DECLARE @ErrorOutput varchar(255)
EXEC CreateNewComputer  '2','1', '0', '3/22/2018', '999', '8', '128', 'Intel HD Graphics 6000', '2', '2.9', @ComputerKey = @CaptureOutput OUTPUT, @ErrorCode = @ErrorOutput OUTPUT
SELECT @CaptureOutput[ComputerKey], @ErrorOutput [Error]

--Add Imac to database
DECLARE @CaptureOutput int
DECLARE @ErrorOutput varchar(255)
EXEC CreateNewComputer  '1','1', '0', '3/22/2018', '1499', '32', '512', 'Radeon Pro 560 with 4GB of VRAM', '2', '3.4', @ComputerKey = @CaptureOutput OUTPUT, @ErrorCode = @ErrorOutput OUTPUT
SELECT @CaptureOutput[ComputerKey], @ErrorOutput [Error]

/*******************************************************************
- Query that shows all available computers/devices
*******************************************************************/

SELECT * FROM AvailableComputers

/*******************************************************************
 - Assign one of the new machines to the CEO
*******************************************************************/
DECLARE @CaptureAssignDevice int
DECLARE @ErrorAssignDevice int
EXEC AssignDevice  '1','4', @EmployeeComputerKey = @CaptureAssignDevice OUTPUT, @ErrorCode = @ErrorAssignDevice OUTPUT
SELECT @CaptureAssignDevice[EmployeeComputerKey], @ErrorAssignDevice[ErrorCode]

/*******************************************************************
 - Return it and assign the other machine (the CEO hated your first choice)

*******************************************************************/
--return a 1st assigned computer of CEO
declare @SuccessReturn int
declare @ErrorReturn int
exec ReturnAComputer '1','4', @Success = @SuccessReturn OUTPUT, @ErrorCode = @ErrorReturn OUTPUT
select @SuccessReturn[Return Success], @ErrorReturn [REturn fail]

--assign 2nd device to CEO
DECLARE @CaptureAssignDevice int
DECLARE @ErrorAssignDevice int
EXEC AssignDevice  '1','5', @EmployeeComputerKey = @CaptureAssignDevice OUTPUT, @ErrorCode = @ErrorAssignDevice OUTPUT
SELECT @CaptureAssignDevice[EmployeeComputerKey], @ErrorAssignDevice[ErrorCode]

/*******************************************************************
 - Try to retire the second machine you assigned to the CEO (he's picky...)
*******************************************************************/

declare @SuccessRetire int
declare @ErrorRetire int
exec RetireAComputer '5', @Success = @SuccessRetire OUTPUT, @ErrorCode = @ErrorRetire OUTPUT
select @SuccessRetire[Retire Done], @ErrorRetire[Retire Fail]

/*******************************************************************
 - Query that leverages your view for depreciation values of lost equipment
*******************************************************************/

Select * FROM Dbo.PCdepreciation 

/*******************************************************************
 - And any other queries/code execution to show your awesomeness
*******************************************************************/


