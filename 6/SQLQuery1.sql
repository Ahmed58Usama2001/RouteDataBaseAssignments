--part 1 Use ITI DB

--1.
select *
from (select *,ROW_NUMBER() over (partition by dept_id order by salary desc) as RN
from instructor) as NewTable
where Salary is not null and RN<=2

--2.
select *
from (select *,ROW_NUMBER() over (partition by dept_id order by newid()) as RN
from student) as NewTable
where RN=1


--part 2 Restore adventureworks2012 Database Then :

--1.
SELECT SalesOrderID, ShipDate
FROM Sales.SalesOrderHeader
WHERE ShipDate >= '2002-07-28' AND ShipDate <= '2014-07-29';

--2.
select ProductID,Name
from Production.Product
where StandardCost <110

--3.
select ProductID,Name
from Production.Product
where Weight is null

--4.
select ProductID,Name
from Production.Product
where color in ('silver','black','red')

--5.
select ProductID,Name
from Production.Product
where name like 'b%'

--6.
	UPDATE Production.ProductDescription
SET Description = 'Chromoly steel_High of defects'
WHERE ProductDescriptionID = 3

--7.
SELECT *
FROM Production.ProductDescription
WHERE Description LIKE '%[_]%';

--8.
select distinct HireDate
from HumanResources.Employee

--9.
select concat('The ',Name,' is only! ',ListPrice) as ProductInfo
from Production.Product
where ListPrice between 100 and 120
order by ListPrice


--part 3 Use ITI DB:
--1.
create Function GetMonthNameByDate(@inputDate Date)
returns varchar(20) -- Function Signature
begin
	declare @MonthtName varchar(20)
	Select @MonthtName = DATENAME(MONTH,CAST(@inputDate AS DATETIME))
	return @MonthtName
end
     
Select	Dbo.GetMonthNameByDate(CAST('2023-08-27' AS DATE))

--2.

CREATE FUNCTION GetValuesBetween
(
    @startValue INT,
    @endValue INT
)
RETURNS @result TABLE (Value INT)
AS
BEGIN
    WHILE @startValue <= @endValue
    BEGIN
        INSERT INTO @result (Value) VALUES (@startValue)
        SET @startValue = @startValue + 1
    END

    RETURN
END;


SELECT Value
FROM dbo.GetValuesBetween(1, 5);


--3.

create Function GetDepNameandStdNameByStdNo(@stdNo int)
returns table 

as
return
	(select d.Dept_Name,s.St_Fname+' '+s.St_Lname as StdName
	from student s,Department d
	where s.Dept_Id=d.Dept_Id and s.St_Id=@stdNo
	)
     
Select *
from Dbo.GetDepNameandStdNameByStdNo(1)


--4.
create function getmessagebyStdId(@stdID int)
returns varchar(60)

begin 
declare @firstName varchar(20)
declare @lastName varchar(20)
 DECLARE @message varchar(60)
select @firstName=Student.St_Fname,@lastName=Student.St_Lname
from Student
where Student.St_Id=@stdID

if(@firstName is null and @lastName is null)
  SET @message = 'First name & last name are null'
ELSE IF (@firstName IS NULL)
  SET @message = 'First name is null'
ELSE IF (@lastName IS NULL)
  SET @message = 'Last name is null'
ELSE
  SET @message = 'First name & last name are not null'

return @message
end

select dbo.getmessagebyStdId(13)
select dbo.getmessagebyStdId(12)


--5.
create FUNCTION FormatManagerHiringDate (@dateFormat INT)
RETURNS TABLE
AS
RETURN
(
    SELECT d.Dept_Name,i.Ins_Name,
           CASE 
               WHEN @dateFormat = 1 THEN CONVERT(VARCHAR(50), d.Manager_hiredate, 101) -- MM/DD/YYYY
               WHEN @dateFormat = 2 THEN CONVERT(VARCHAR(50), d.Manager_hiredate, 103) -- DD/MM/YYYY
               WHEN @dateFormat = 3 THEN CONVERT(VARCHAR(50), d.Manager_hiredate, 120) -- YYYY-MM-DD
               ELSE CONVERT(NVARCHAR(50), d.Manager_hiredate, 101) -- Default: MM/DD/YYYY
           END AS FormattedHiringDate
    FROM Department d,Instructor i
	where d.Dept_Id=i.Dept_Id and d.Dept_Manager=i.Ins_Id
);


select *
from dbo.FormatManagerHiringDate(3)


--6.
CREATE FUNCTION GetStudentName (@inputString VARCHAR(50))
RETURNS @result TABLE (NameValue VARCHAR(50))
AS
BEGIN
    IF (@inputString = 'first name')
    BEGIN
        INSERT INTO @result (NameValue)
        SELECT ISNULL(Student.St_Fname, 'Not found') AS FirstName
        FROM Student
    END
    ELSE IF (@inputString = 'last name')
    BEGIN
        INSERT INTO @result (NameValue)
        SELECT ISNULL(Student.St_Lname, 'Not found') AS LastName
        FROM Student
    END
    ELSE IF (@inputString = 'full name')
    BEGIN
        INSERT INTO @result (NameValue)
        SELECT ISNULL(Student.St_Fname + ' ' + Student.St_Lname, 'Not found') AS FullName
        FROM Student
    END
    
    RETURN
END;


select *
from dbo.GetStudentName('last name')
