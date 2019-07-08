CREATE TABLE Brands
(
	BrandKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Brand varchar(40) NOT NULL,
	Active bit DEFAULT(1) NOT NULL
)

CREATE TABLE ComputerTypes
(
	ComputerTypeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerType varchar(25) NOT NULL
) 

CREATE TABLE ComputerStatuses
(
	ComputerStatusKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	ComputerStatus varchar(50) NOT NULL,
	ActiveStatus bit NOT NULL  --an indicator of if this status means the computer is available or not
)

CREATE TABLE CPUTypes
(
	CPUTypeKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	CPUType varchar(40) NOT NULL
)

CREATE TABLE Computers
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

SET IDENTITY_INSERT Computers ON
INSERT Computers (ComputerKey, ComputerTypeKey, BrandKey, ComputerStatusKey, PurchaseDate, PurchaseCost, MemoryCapacityInGB, 
	HardDriveCapacityinGB, VideoCardDescription, CPUTypeKey, CPUClockRateInGHZ) VALUES
	(1, 1, 1, 0, '1/1/2017', 1999.99, 32, 1024, 'Nvidia 1080', 1, 3.5),
	(2, 2, 4, 0, '1/1/2017', 2399.99, 16, 512, 'Nvidia GeForce GT 650M', 1, 2.5)
SET IDENTITY_INSERT Computers OFF

CREATE TABLE Departments
(
	DepartmentKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	Department varchar(255)
)

SET IDENTITY_INSERT Departments ON
INSERT Departments (DepartmentKey, Department) VALUES
	(1, 'CEO'),
	(2, 'Human Resources'),
	(3, 'Information Technology'),
	(4, 'Accounting')
SET IDENTITY_INSERT Departments OFF

CREATE TABLE Employees
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

SET IDENTITY_INSERT Employees ON
INSERT Employees (EmployeeKey, LastName, FirstName, Email, Hired, DepartmentKey, SupervisorEmployeeKey) VALUES
	(1, 'Ceo', 'John The', 'JCeo@thiscompany.com', '1/1/2017', 1, 1),
	(2, 'Brother', 'Big', 'BBrother@thiscompany.com', '1/1/2017', 2, 1),
	(3, 'Geek', 'Major', 'MGeek@thiscompany.com', '1/1/2017', 3, 1)
SET IDENTITY_INSERT Employees OFF


CREATE TABLE EmployeeComputers
(
	EmployeeComputerKey int IDENTITY(1,1) PRIMARY KEY NOT NULL,
	EmployeeKey int NOT NULL,
	ComputerKey int NOT NULL,
	Assigned date NOT NULL,
	Returned date NULL
)

SET IDENTITY_INSERT ComputerStatuses ON
	INSERT ComputerStatuses (ComputerStatusKey, ComputerStatus, ActiveStatus) VALUES 
		(0, 'New', 1),
		(1, 'Assigned', 1),
		(2, 'Available', 1),
		(3, 'Lost', 0),
		(4, 'In for Repairs', 0), 
		(5, 'Retired', 1)
SET IDENTITY_INSERT ComputerStatuses OFF

SET IDENTITY_INSERT CPUTypes ON 
INSERT CPUTypes (CPUTypeKey, CPUType) VALUES 
	(1, 'AMD'), 
	(2, 'Intel'), 
	(3, 'Samsung'), 
	(4, 'Apple'), 
	(5, 'Qualcomm')
SET IDENTITY_INSERT CPUTypes OFF

SET IDENTITY_INSERT ComputerTypes ON
INSERT ComputerTypes (ComputerTypeKey, ComputerType) VALUES 
	(1, 'Desktop'),
	(2, 'Laptop'),
	(3, 'Tablet'),
	(4, 'Phone')
SET IDENTITY_INSERT ComputerTypes OFF

SET IDENTITY_INSERT Brands ON
INSERT Brands (BrandKey, Brand) VALUES
	(1, 'Apple'),
	(2, 'Samsung'),
	(3, 'Sony'),
	(4, 'HP'),
	(5, 'Acer'),
	(6, 'NVidia')
SET IDENTITY_INSERT Brands OFF

ALTER TABLE Computers 
	ADD CONSTRAINT FK_ComputerComputerTypes 
	FOREIGN KEY (ComputerTypeKey) 
	REFERENCES ComputerTypes (ComputerTypeKey)

ALTER TABLE Computers
	ADD CONSTRAINT FK_ComputerBrands
	FOREIGN KEY (BrandKey) 
	REFERENCES Brands (BrandKey)

ALTER TABLE Computers
	ADD CONSTRAINT FK_ComputerComputerStatus
	FOREIGN KEY (ComputerStatusKey) 
	REFERENCES ComputerStatuses (ComputerStatusKey)

ALTER TABLE Computers
	ADD CONSTRAINT FK_ComputerCPUType
	FOREIGN KEY (CPUTypeKey) 
	REFERENCES CPUTypes (CPUTypeKey)

ALTER TABLE Employees
	ADD CONSTRAINT FK_EmployeeDepartment
	FOREIGN KEY (DepartmentKey)
	REFERENCES Departments (DepartmentKey)

ALTER TABLE Employees
	ADD CONSTRAINT FK_EmployeeSupervisor
	FOREIGN KEY (SupervisorEmployeeKey)
	REFERENCES Employees (EmployeeKey)

ALTER TABLE EmployeeComputers
	ADD CONSTRAINT FK_EmployeeComputerEmployee
	FOREIGN KEY (EmployeeKey)
	REFERENCES Employees (EmployeeKey)

ALTER TABLE EmployeeComputers
	ADD CONSTRAINT FK_EmployeeComputerComputer
	FOREIGN KEY (ComputerKey)
	REFERENCES Computers (ComputerKey)


/*
Some general rules for this assignment:

 - You can change the table structure if you feel it is necessary (the core structure is sound).  More likely, you'll want to add tables, constraints, columns, etc. to the existing structure.  Any changes you make need to be added to the script you turn in and well documented/commented.
 - Hard Drive size is always displayed in TB
 - Memory size is always displayed in GB
 - If I ask for the employee name, I want to see LastName, FirstName
 - Remember to start all your objests off with a prefix - for this project use "Group" followed by
	your number and an underscore (Group1_YourObjectGoesHere)
 - You can accomplish all the work utilizing the objects/structures we've talked about to date.  If you're not sure where to apply what, have a conversation and ask me for clarification.
 - Your overall goal is to complete the requested tasks and make your database retain good data quality and gracefully handle issues if they come up.


Assignment - you've been assigned to work with a web developer to develop out a computer inventory tracking system.  You'll be working on the data layer, providing interfaces for the web developer to consume with their ASP.NET code.  

You are expected, at a minimum, to complete the following tasks - 

 - Create a view that shows all available computers (those that are new or available for 
	reassignment).  Include all the computer specs, brand, etc. and, if applicable, the last person
	who was assigned the machine (just in case you have any questions).  This list will
	be used to determine what computer to assign out.

 - Create a view that shows all computers that are in for repair.  Include who the 
	computer belongs to, their email address, how long it has been in for repairs, 
	and the associated specs, brand, type, etc.  This list will be used to update those
	users that are waiting on repairs.

 - Create a view that returns an employee list - should include their full name, email address, 
	their department, the number of computers they have, and who their supervisor is.  Only
	return active employees.

 - Create a function (or functions) that will convert TB to GB and GB to TB.  Looking at the database, you can
	see that hard drive space is stored in GB but the developer expects to be able to display TB (and doesn't
	want to do the conversion themselves).  They'll also be passing back TB when they manipulate computer inventory
	and you'll need to convert to GB to store.

 - Create an inline table function that accepts a computer brand (or brand key) and returns available computers of 
	that brand back.  Return the same columns as you did in above computer inventory views.

 - Design a table to store changes to computer assignments.  You have to track every change of status, starting when a 
	computer is added to the inventory, when it is lost, when it is assigned, reassigned, etc.  You need datetime stamps
	when the change occured.  This will be key to the next three requests.

 - The web developer decides that the data layer is going to have to manage the audit logging of changes to computer statuses.
	Design the appropriate triggers to accomplish this, inserting data into the table you created above. 

 - Create a view that shows all stolen/lost computers.  Include who the computer belongs to, when it
	was purchased, when it was lost, and amount depreciated, and how much is left.  To calculate this, 
	we will assume a 36 month depreciation for desktops, 48 months for everything else (i.e each month we use up 1/36th or 1/48th 
	of the original cost).  You need to see how many months remain and multiple this by the original cost
	of the computer.  A computer that costs 1800 will depreciate at $50 a month.  A computer lost after
	13 months would have depreciated $650 and would still be worth $1150 (show these two values).  Maybe a function
	to compute depreciation?

 - Create a stored procedure/inline table function that shows the history of a computer - starting with a record for when 
	it was purchased all the way to when it	is retired or lost.  
	Include the computer information you did above, and where applicable the assigned employee name and 
	employee key.

Create stored procedures that complete the below tasks.  You can combine as you feel is appropriate.  As a general rule of thumb,
	you can expect the web developer to pass you keys (not the string values).  You however cannot expect that they'll 
	always pass you valid information...  Make sure you take this into account as you're designing/coding the following 
	stored procedures.

 - Adding new employees.  Return the key of the newly created employee, or an error message/code if something doesn't work.
 - Updating an employee
 - Creating a new department.  Return the key of the newly created department or an error message/code if something doesn't work.
	Also, don't allow duplicate department names...
 - Update the supervisor of an employee or employees.  Make sure it is a valid, active supervisor.
 - Terminate an employee.  Harder one - what happens to an employee's equipment when they are terminated?
	What happens if the employee is a manager for other people?  I expect you to make this stored procedure
	bullet proof - don't expect the web developer to think about these things...
 - Create a new computer.  Return the key of the newly created computer, or an error message/code.
 - Assign/reassign a computer.  Shouldn't allow computers that are in for repair, lost, or retired to be assigned out.
 - Change the status of a computer (lost computers, in for repairs, etc.)
 - Return a computer
 - Retire a computer.  Make sure the computer is fully depreciated, or do not let it be retired.

Your compliance officer is adamant that certain safegaurds are installed in the database.  Consider the following:

 - No individual can have more than two working desktops or one working laptop assigned to them at any given time.
 - A hardcap of $10,000 has been put in place for the cost of any one computer.  Under no circumstances should the database
	have something above this.
 - Worried about piracy and bandwidth consumption, they have also institued a hard cap of hard drive space on any given 
	machine to 5TB.
 - Do not let anyone delete a computer record.  Can't happen!  We have to prove that no equipment is being purchased
	and removed from our systems to sell privately.  Instead of a delete, the computer should be retired, or
	made available (depending on its depreciation status).

Last, add features, safegaurds, etc. that help ensure the original goal - good data quality and graceful error handling.



Once your code is completed, provide scripts to complete the following (including display of output variables or errors as 
	applicable).

 - Create the department 'Business Intelligence'
 - Add two valid employee, both part of Business Intelligence
 - Try to add an employee, passing in a department that doesn't exist
 - Try to add an employee, passing in a supervisor that is no longer active (what should this do?)
 - Update an employees department to 'Human Resources'
 - Try to update an employees department to 'Moon Staff' (assuming that 'Moon Staff' doesn't exist
	in your database).  
 - Update an employees supervisor to an active employee
 - Try updating an employees supervisor to an inactive employee.  Should this work?
 - Create a new Mac Book pro laptop for Major Geek.  Use whatever specs you can find off the Apple
	web page.  Make sure the laptop gets assigned to Major Geek
 - Terminate employee #3 (Major Geek)
 - A query using your inline table function to display available apple computers
 - A query (using inline view or stored procedure) that shows the history of a specific computer
	in your database.
 - Deal with the CEO losing his laptop.
 - Add two computers of your own chosing
 - Query that shows all available computers/devices
 - Assign one of the new machines to the CEO
 - Return it and assign the other machine (the CEO hated your first choice)
 - Try to retire the second machine you assigned to the CEO (he's picky...)
 - Query that leverages your view for depreciation values of lost equipment

 - And any other queries/code execution to show your awesomeness

*/
