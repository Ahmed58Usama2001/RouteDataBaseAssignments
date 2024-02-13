--PArt1

--•	Create a trigger to prevent anyone from inserting a new record in the Department table ( Display a message for user to tell him that he can’t insert a new record in that table )

create trigger trig01
on department
instead of insert
as
select 'You can not insert a new record to Department table'

insert into department (dept_id)
values(52542)

---------------------------------
create table studentAudit(
serverUserName varchar(50),
Date Date,
Note varchar(500)
)

create trigger trig02
on student 
after insert
as
declare @note varchar(500)
   SET @Note = SUSER_SNAME()+ ' inserted a new row with Key = ' + CAST((SELECT St_Id FROM inserted) AS nvarchar) +
               ' in table Student.';
insert into studentAudit
values(SUSER_SNAME(),getdate(),@note)

insert into student(st_id)
values(430)

create trigger trig03
on student
instead of delete
as
declare @note varchar(500)
   SET @Note = SUSER_SNAME()+ ' try to delete Row with id = ' + CAST((SELECT St_Id FROM deleted) AS nvarchar);
insert into studentAudit
values(SUSER_SNAME(),getdate(),@note)

delete from Student
where st_id=1


---------------------------------------------------------------------------------------------
--Part 2

--Use MyCompany DB:
--•	Create a trigger that prevents the insertion Process for Employee table in March.

create trigger trig04
on employee
instead of insert
as
if FORMAT(getdate(),'MMMM')!='March'
insert into Employee
select * from inserted 


insert into Employee (SSN)
values(53)


--Use SD32-Company:
create table AuditTable
(ProjectNo int,
username varchar(50),
modifiedDate date,
budgetold int,
budgetnew int)


create trigger trig05
on HR.project
after update
as
if update(budget)
begin
insert into AuditTable
select  inserted.ProjectNo,SUSER_SNAME(),GETDATE(),DELETED.Budget,INSERTED.Budget
from inserted,deleted
where inserted.ProjectNo=deleted.ProjectNo
end;


update HR.Project
set budget=93268
where projectno=2 


-------------------------------------------------------------------------------------------
--Part 03

--•	Create an index on column (Hiredate) that allows you to cluster the data in table Department. What will happen?

create nonclustered index myindex01
on department (Manager_hiredate)

--Improved query performance: Creating an index on the "Hiredate" column can enhance the performance of queries that involve filtering, sorting, or joining data based on the "Hiredate" column. The database engine can use the index to quickly locate the relevant data, resulting in faster query execution times.


--•	Create an index that allows you to enter unique ages in the student table. What will happen?
create unique index myindex02
on student(st_age)
--When creating a unique index on a column that already contains repeated values, the creation of the unique index will fail. This is because the unique constraint requires that each value in the indexed column be unique.


--•	Try to Create Login Named(RouteStudent) who can access Only student and Course tables from ITI DB then allow him to select and insert data into tables and deny Delete and update
CREATE LOGIN RouteStudentLogin WITH PASSWORD = 'password';


CREATE USER RouteStudent01 FOR LOGIN RouteStudentLogin;


GRANT SELECT, INSERT ON student TO RouteStudent01;
GRANT SELECT, INSERT ON course TO RouteStudent01;


DENY DELETE, UPDATE ON student TO RouteStudent01;
DENY DELETE, UPDATE ON course TO RouteStudent01;


