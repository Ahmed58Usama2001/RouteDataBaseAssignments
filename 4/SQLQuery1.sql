
--part 1 --⮚	Restore MyCompany Database and then:

--1.
select * 
from employee

--2.
select Fname, Lname, Salary , Dno
from employee

--3.
select pname,Plocation,Dnum
from project

--4.
select Fname + ' ' + Lname as Fullname , 0.1*(Salary*12) [ANNUAL COMM ]
from employee

--5.
select SSN,Fname + ' ' + Lname as Fullname
from employee
where Salary>1000

--6.
select SSN,Fname + ' ' + Lname as Fullname
from employee
where Salary*12>10000

--7.
select Fname + ' ' + Lname as Fullname,salary
from employee
where sex='f'

--8.
select Dnum,Dname
from Departments
where MGRSSN=968574

--9.
select pnumber,Pname,Plocation
from project
where Dnum=10




--part 2 ⮚	Restore ITI Database and then:

--1.
select distinct Ins_Name
from Instructor

--2.
select i.Ins_Name,d.Dept_Name
from Instructor i left outer join Department d
on i.Dept_Id=d.Dept_Id

--3.
select s.St_Fname+' '+s.St_Lname [Full name],c.Crs_Name
from Student s,Stud_Course sc,Course c
where s.St_Id=sc.St_Id and sc.Crs_Id=c.Crs_Id and Grade is not null

--Bouns
select @@VERSION --This statement returns the version information of the SQL Server instance that you are connected to.
select @@SERVERNAME --This statement returns the name of the SQL Server instance that you are connected to.
--In SQL Server, the prefix @@ is used to indicate a system variable. System variables are predefined variables provided by SQL Server that store information about the server, the current session, or other system-related details. These variables can be used in Transact-SQL statements to retrieve specific information.



--part 3 ⮚ Using MyCompany Database and try to  create the following Queries:

--1.
select d.MGRSSN,d.Dname,d.MGRSSN,e.Fname+ ' ' +e.Lname [MGR name]
from Departments d,Employee e
where d.MGRSSN=e.SSN

--2.
select d.Dname,p.Pname
from Departments d,Project p
where d.Dnum=p.Dnum

--3.
select d.ESSN,d.Dependent_name,d.Sex,d.Bdate,e.Fname+' '+e.Lname [employee name]
from Dependent d, Employee e
where d.ESSN=e.SSN

--4.
select Pnumber,Pname,plocation
from Project
where city='cairo' or City='alex'

--5.
select *
from Project
where Pname like 'a%'

--6.
select * 
from Employee
where Dno=30 and (salary between 1000 and 2000)


--7.
select Fname +' '+Lname as Fullname
from Employee e,Project p, Works_for wf
where e.SSN=wf.ESSn and wf.Pno=p.Pnumber and e.Dno=10 and wf.Hours>=10 and p.Pname='AL Rabwah'

--8.
select emp.Fname+' '+emp.Lname [employee name]
from Employee emp, Employee super
where  super.Fname='kamel' and super.Lname='mohamed' and super.SSN=emp.Superssn


--9.
select e.Fname+' '+e.Lname [Employee name], p.Pname
from Employee e,Works_for wf,Project p
where e.SSN=wf.ESSn and wf.Pno=p.Pnumber
order by p.Pname

--10.
select p.Pnumber, d.Dname, e.Lname,e.Address,e.Bdate
from Project p,Departments d, Employee e
where p.City='cairo' and p.Dnum=d.Dnum and d.MGRSSN=e.SSN


--11.
select super.SSN,super.Fname,super.Lname,super.Address,super.Bdate,super.Dno,super.Salary,super.Sex
from Employee emp, Employee super
where super.SSN=emp.Superssn

--12
select *
from Employee e left outer join Dependent d
on d.ESSN=e.SSN