--Part 1 (views)

--1.
Create view studendNameAndCourseName
as
select s.St_Fname +' '+ s.St_Lname [fullname] ,c.Crs_Name
from Student s,Stud_Course sc,Course c
where s.St_Id=sc.St_Id and sc.Crs_Id=c.Crs_Id and sc.Grade>50

select * from studendNameAndCourseName

--2.
create view InstructorNAmeAndTopicName (Instructor_name,Topic_name)
with encryption
as
select i.Ins_Name , t.Top_Name
from topic t,Course c,Instructor i,Ins_Course ic,Department d
where t.Top_Id=c.Top_Id and i.Ins_Id=ic.Ins_Id and ic.Crs_Id=c.Crs_Id and i.Ins_Id=d.Dept_Manager

--3.
CREATE VIEW dbo.InstructorNameAndDepartmentName
WITH SCHEMABINDING
AS
SELECT i.Ins_Name, d.Dept_Name
FROM dbo.Instructor i
JOIN dbo.Department d ON i.Dept_Id = d.Dept_Id
WHERE d.Dept_Name IN ('SD', 'Java');


--4.
CREATE VIEW V1
AS
SELECT *
FROM Student
WHERE st_address IN ('Alex', 'Cairo')
WITH CHECK OPTION

select * from V1


--5-->use company DB
create view projectandnumberofemployees
as
select Pname,COUNT(wf.ESSN) as NOofEmployees
from Project p,Works_for wf
where p.Pnumber=wf.Pno 
group by Pname

select * from projectandnumberofemployees


--Use Company DB

--1.
create view v_clerk
as
select wo.EmpNo,wo.ProjectNo,wo.Enter_Date
from Works_on wo
where wo.Job='clerk'

--2.
create view v_without_budget
as
select *
from HR.Project
where Budget=0 

--3.
create view v_count 
as 
select p.ProjectName, count(wo.job) as jobsNumber
from HR.Project p,Works_on wo
where p.ProjectNo=wo.ProjectNo
group by p.ProjectName

--4.
CREATE view v_project_p2  
as   
 select EmpNo  
 from v_clerk1  
 where ProjectNo = 'p2'  

--5.
alter view v_without_budget
as 
select*
from HR.Project p
where p.ProjectNo in(1,2)

--6.
DROP VIEW v_clerk;
DROP VIEW v_count;

--7.
create view employeeNumberAndEployeeLNameInDep2
as
select e.EmpNo ,e.EmpLname
from HR.Employee e
where e.DeptNo=2

--8.
create view EmployeeLNameContainsJ
as
select v.EmpLname
from employeeNumberAndEployeeLNameInDep2 v
where v.EmpLname like '%j%'


--9.
create view v_dept  
as   
select DeptNo, DeptName  
from Department

--10.
insert into v_dept
values(4,'Development')

--11.
Create view v_2006_check
as
select *
from Works_on
where Enter_Date>= '2006-01-01' and Enter_Date <= '2006-12-31'
with check option


--12.
CREATE VIEW SquareCalculationView
AS
SELECT number, number * number AS square
FROM
(
    SELECT 1 AS number UNION ALL
    SELECT 2 AS number UNION ALL
    SELECT 3 AS number UNION ALL
    SELECT 4 AS number UNION ALL
    SELECT 5 AS number UNION ALL
    SELECT 6 AS number UNION ALL
    SELECT 7 AS number UNION ALL
    SELECT 8 AS number UNION ALL
    SELECT 9 AS number UNION ALL
    SELECT 10 AS number
) AS numbers_table;

SELECT *
FROM SquareCalculationView;

---------------------------------------------------------------------------------------------------
--part 2
--1.
create proc SP_StudentsNumberPerDep @DepId int
as
select s.Dept_Id,count(s.st_id) as NoOfStudents
from Student s
where s.Dept_Id=@DepId
group by s.Dept_Id

SP_StudentsNumberPerDep 20

--2.
CREATE PROCEDURE SP_CheckProjectEmployees
AS
    DECLARE @EmployeeCount INT;
    SELECT @EmployeeCount = COUNT(*) FROM Works_for WHERE Pno = 100;
    IF @EmployeeCount >= 3
        PRINT 'The number of employees in project 100 is 3 or more';
    ELSE
    BEGIN
        PRINT 'The following employees work for project 100:';
        SELECT E.Fname, E.Lname
        FROM Works_for wf,Employee e
        where e.SSN=wf.ESSn and wf.pno = 100;
    END

--3.
CREATE PROCEDURE SP_ReplaceEmployeeInProject
    @OldEmployeeNumber INT,
    @NewEmployeeNumber INT,
    @ProjectNumber INT
AS
 UPDATE Works_for
 SET ESSn = @NewEmployeeNumber
 WHERE essn = @OldEmployeeNumber AND pno = @ProjectNumber;

 --4.
 CREATE TABLE AuditTable1 (
    ProjectNo INT,
    UserName VARCHAR(50),
    ModifiedDate DATE,
    Budget_Old int,
    Budget_New int
);

CREATE PROCEDURE SP_UpdateProjectBudget
    @ProjectNo INT,
    @NewBudget int
AS
    DECLARE @OldBudget int

    SELECT @OldBudget = Budget
    FROM HR.Project
    WHERE ProjectNo = @ProjectNo;

    UPDATE HR.Project
    SET Budget = @NewBudget
    WHERE ProjectNo = @ProjectNo;

    INSERT INTO AuditTable1 (ProjectNo, UserName, ModifiedDate, Budget_Old, Budget_New)
    VALUES (@ProjectNo, SUSER_NAME(), GETDATE(), @OldBudget, @NewBudget);

SP_UpdateProjectBudget 2,500

----------------------------------------------------------------------------------------------------------------------
--Part 3

--1.
CREATE PROCEDURE SP_CalculateSum
    @StartNumber INT,
    @EndNumber INT,
    @Sum INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentNumber INT;
    SET @CurrentNumber = @StartNumber;
    SET @Sum = 0;

    WHILE @CurrentNumber <= @EndNumber
    BEGIN
        SET @Sum = @Sum + @CurrentNumber;
        SET @CurrentNumber = @CurrentNumber + 1;
    END;
END;

DECLARE @Result INT;
EXEC SP_CalculateSum @StartNumber = 1, @EndNumber = 10, @Sum = @Result OUTPUT;
SELECT @Result AS Sum;

--2.
CREATE PROCEDURE CalculateCircleArea
    @Radius DECIMAL(10, 2),
    @Area DECIMAL(18, 2) OUTPUT
AS
SET @Area = PI() * POWER(@Radius, 2);

DECLARE @Result DECIMAL(18, 2);
EXEC CalculateCircleArea @Radius = 5, @Area = @Result OUTPUT;
SELECT @Result AS Area;


--3.
CREATE PROCEDURE CalculateAgeCategory
    @Age INT,
    @Category VARCHAR(20) OUTPUT
AS
    IF @Age < 18
        SET @Category = 'Child';
    ELSE IF @Age >= 18 AND @Age < 60
        SET @Category = 'Adult';
    ELSE
        SET @Category = 'Senior';

DECLARE @Result VARCHAR(20);
EXEC CalculateAgeCategory @Age = 25, @Category = @Result OUTPUT;
SELECT @Result AS Category;

--4.
CREATE PROCEDURE SP_CalculateStatistics
    @Numbers NVARCHAR(MAX),
    @MaxValue INT OUTPUT,
    @MinValue INT OUTPUT,
    @Average DECIMAL(18, 2) OUTPUT
AS
    DECLARE @NumberTable TABLE (Number INT);

    INSERT INTO @NumberTable (Number)
    SELECT CAST(value AS INT)
    FROM STRING_SPLIT(@Numbers, ',');

    SELECT
        @MaxValue = MAX(Number),
        @MinValue = MIN(Number),
        @Average = AVG(CAST(Number AS DECIMAL(18, 2)))
    FROM @NumberTable;

DECLARE @MaxResult INT;
DECLARE @MinResult INT;
DECLARE @AvgResult DECIMAL(18, 2);

EXEC SP_CalculateStatistics @Numbers = '5, 10, 15, 20, 25',
                         @MaxValue = @MaxResult OUTPUT,
                         @MinValue = @MinResult OUTPUT,
                         @Average = @AvgResult OUTPUT;

SELECT @MaxResult AS MaxValue,
       @MinResult AS MinValue,
       @AvgResult AS Average;


----------------------------------------------------------------------------------------------------------------

--Part 4
--1.
create database Routecompany

CREATE TABLE Department (
    DeptNo INT PRIMARY KEY,
    DeptName VARCHAR(50),
    Location VARCHAR(50)
);

INSERT INTO Department 
VALUES (1, 'Research', 'NY'),
       (2, 'Accounting', 'DS');


CREATE TABLE Employee (
    EmpNo INT PRIMARY KEY,
    EmpFname VARCHAR(50) NOT NULL,
    EmpLname VARCHAR(50) NOT NULL,
    DeptNo INT references department(deptno),
    Salary int UNIQUE,
);

insert into Department
values(3,null,null)

INSERT INTO Employee 
VALUES (25348, 'Mathew', 'Smith', 3, 2500),
       (10102, 'Ann', 'Jones', 3, 3000),
       (18316, 'John', 'Barrymore', 1, 2400),
       (29346, 'James', 'James', 2, 2800),
       (9031, 'Lisa', 'Bertoni', 2, 4000),
       (2581, 'Elisa', 'Hansel', 2, 3600),
       (28559, 'Sybl', 'Moser', 1, 2900);


INSERT INTO Project 
VALUES (1, 'Apollo', 120000),
       (2, 'Gemini', 95000),
       (3, 'Mercury', 185600);

insert into works_on
values(11111,1,null,null)
--The INSERT statement conflicted with the FOREIGN KEY constraint "FK_Works_on_Employee". The conflict occurred in database "Routecompany", table "dbo.Employee", column 'EmpNo'.


insert into works_on
values(10102  ,1,null,null)
--it will be added normally as their is no foreign key conflict. This employee exists in employee table

update Employee
set EmpNo=22222
where EmpNo=10102
--The UPDATE statement conflicted with the REFERENCE constraint "FK_Works_on_Employee". The conflict occurred in database "Routecompany", table "dbo.Works_on", column 'EmpNo'.

delete from Employee
where EmpNo=10102
--The DELETE statement conflicted with the REFERENCE constraint "FK_Works_on_Employee". The conflict occurred in database "Routecompany", table "dbo.Works_on", column 'EmpNo'.


alter table employee
add TelephoneNumber varchar(20)

ALTER TABLE Employee
DROP COLUMN TelephoneNumber;



--2.

CREATE SCHEMA Company;

ALTER SCHEMA Company TRANSFER dbo.Department;

ALTER SCHEMA Company TRANSFER dbo.Project;

create schema HR
alter schema HR transfer dbo.employee


--3.
update Company.project
set budget=budget*1.1
WHERE ProjectNo IN (
    SELECT ProjectNo
    FROM Works_on
    WHERE EmpNo = 10102 AND Job = 'Manager'
);

--4.
update company.Department
set DeptName='sales'
where DeptNo =(select DeptNo
from HR.Employee
where EmpFname='James')

--5.
UPDATE Works_on
SET Enter_Date = '2007-12-12'
WHERE ProjectNo = 1 AND EmpNo IN (
    SELECT EmpNo
    FROM HR.Employee e,company.Department d
    WHERE e.DeptNo=d.DeptNo and d.DeptName='Sales'
);

--6.
DELETE FROM Works_on
WHERE EmpNo IN (
    SELECT EmpNo
    FROM HR.Employee
    WHERE DeptNo IN (
        SELECT DeptNo
        FROM company.Department
        WHERE Location = 'KW'
    )
);

















