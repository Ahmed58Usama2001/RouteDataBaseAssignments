

--Part 1

--•	Using ITI Database and try to create the following Queries:

--1.
select super.St_Fname,count(super.st_Fname) [No of supervised students]
from Student std join student super
on super.St_Id=std.St_super
group by super.St_Fname

--2.
select topic.Top_Name,count(Course.Crs_Id) [No of Courses]
from Course join Topic
on course.Top_Id=Topic.Top_Id
group by Topic.Top_Name


--3.
select min(salary) [min Ins salary],max(salary) [max Ins salary]
from Instructor

--4.
select Ins_Name
from Instructor
where salary<(select AVG(salary) from Instructor)

--5.
select Dept_Name
from Department
where Dept_Id=(select top (1) Dept_Id
from Instructor
where salary is not null
order by salary)

--6.
select top (2) salary
from Instructor
order by salary desc

--7.
select AVG(salary) [Avg Instructors salaries]
from Instructor



--Part 2

--•	Using ITI Database

--1.
select student.St_Id [Student ID],ISNULL( Student.St_Fname,'')+' '+ISNULL( Student.St_Lname,'') [Student full name], Department.Dept_Name [Department name]
from Student join Department
on Student.Dept_Id=Department.Dept_Id 

--2.
select Ins_Name,coalesce(Salary,0)
from Instructor

--3.
select top (2) salary
from Instructor
order by salary desc



--Part 3

--• Use MyCompany DB
--DQL
--1.
select project.Pname,sum(Works_for.Hours)
from Project join Works_for
on Project.Pnumber=Works_for.Pno
group by  project.Pname

--2.
select Departments.Dname,Dnum
from Departments
where Departments.Dnum=(select top(1) Employee.Dno
from Employee
where Dno is not null
order by ssn )

--3.
select Departments.Dname, MAX(salary) [max salary], min(salary) [min salary], avg(salary) [avg salary]
from Departments join Employee
on Departments.Dnum=Employee.Dno
group by Departments.Dname

--4.
select Employee.Lname
from Employee, Departments
where Employee.SSN=Departments.MGRSSN and employee.SSN not in ( select essn from Dependent)

--5.
select Employee.Dno, Departments.Dname,count (employee.ssn) [No of employess]
from Employee,Departments
where Employee.Dno=Departments.Dnum and dno is not null
group by Employee.Dno, Departments.Dname
having avg (salary)<(select avg(salary)
from Employee)

--6.
select Employee.Fname+' '+Employee.Lname as fullname , Project.Pname
from employee,Works_for,Project
where Employee.SSN=Works_for.ESSn and works_for.Pno=Project.Pnumber
order by Project.Pname,Employee.Lname,Employee.Fname

--7.
select salary
from Employee
where Employee.SSN in (select top(2) ssn from Employee order by salary desc)

--8.
update Employee
set salary=salary+ (salary*.3)
from Employee,Works_for,Project
where Employee.SSN=Works_for.ESSn and Works_for.Pno=Project.Pnumber and Project.Pname='Al Rabwah'

--9.
SELECT Employee.SSN,Employee.Fname+' '+Employee.Lname as Fullname
FROM Employee
WHERE EXISTS (
    SELECT *
    FROM Employee,Dependent
    WHERE Dependent.ESSN=Employee.SSN
)

--DML
--1.
INSERT INTO Departments
values( 'DEPT IT',100,112233, '1-11-2006')


--2.
insert into Employee
values ('Ahmed', 'Usama', 102672,'5-8-2001','Elsanta Gharbia','M',3200,null,20)


--a.
update Departments
set MGRSSN=968574
where Dnum=100

--b.
update Departments
set MGRSSN=102672
where Dnum=20

--c.
insert into Employee
values ('Hany', 'Dahy', 102660,'9-9-2005','Mansoura Dakahlya','M',1200,null,20)

update Employee
set Superssn=102672
where SSN=102660 


--3.
update Dependent
set ESSN=102672
where ESSN=223344

update Departments
set MGRSSN=102672
where MGRSSN=223344

update Employee
set Superssn=102672
where Superssn=223344

update Works_for
set ESSn=102672
where ESSn=223344


delete from Employee
where SSN=223344
