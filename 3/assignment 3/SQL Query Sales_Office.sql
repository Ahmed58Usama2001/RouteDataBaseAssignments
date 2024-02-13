create database sales_office

use sales_office

create table office(
Number int primary key identity(1, 1),
location varchar(25) not null,
Emp_id int
)

create table employee(
ID int primary key identity (10,10),
Name varchar(25) not null,
Off_number int references office(Number)

)

alter table office
add foreign key (Emp_id) references employee (ID)


create table property(
ID int primary key identity (100,100),
Address varchar(25),
City varchar(25),
State varchar(25),
Code int not null,
Off_Number int references office(Number)
)

create table owner(
ID int primary key identity (1000,1000),
Name varchar(25) not null,
)

create table prop_owner(
Own_ID int references owner(ID),
Prop_ID int references property(ID),
precent decimal
primary key(Own_ID,Prop_ID)
)

insert into office
values('cairo',null)

insert into office
values('Alex',null)

insert into employee
values('Ahmed Usama',null),
('Nashwa Zahra',null)

insert into property
values ('45','Tanta','Algharbia','123',null),
('45','Zifta','Algharbia','456',null)

insert into owner
values('Hany Elghaish'),
('Reda Elbasiony')

insert into prop_owner
values(1000,100,50.4),
(2000,200,87.5)
