create database shivanand;
use shivanand;
create table customers
(album_id int primary key,
title varchar(25),
artist_id int8)
# (here data is imported)
select * from customers;

# Q1.SENIOR MOST EMPLOYEE BASED ON JOB TITLE.

SELECT * From EMPLOYEE2
order by levels desc
limit 1;

# Q2. WHERE COUNTRY HAS MOST INVOICES. 

SELECT COUNT(*) AS c, billing_country 
FROM invoice2
GROUP BY billing_country
ORDER BY c DESC


# Q3: What are top 3 values of total invoice?

SELECT total 
FROM invoice2
ORDER BY total DESC

# Q4 /* Q4: Which city has the best customers? 
# Write a query that returns one city that has the highest sum of invoice totals. 
# Return both the city name & sum of all invoice totals .

SELECT billing_city,SUM(total) AS InvoiceTotal
FROM invoice2
GROUP BY billing_city
ORDER BY InvoiceTotal DESC
LIMIT 1;

# Q 6 .no of gold medal per swimmer who won only gold medals.

CREATE TABLE events (
ID int,
event varchar(255),
YEAR INt,
GOLD varchar(255),
SILVER varchar(255),
BRONZE varchar(255)
);
INSERT INTO events VALUES (1,'100m',2016, 'Amthhew Mcgarray','donald','barbara');
INSERT INTO events VALUES (2,'200m',2016, 'Nichole','Alvaro Eaton','janet Smith');
INSERT INTO events VALUES (3,'500m',2016, 'Charles','Nichole','Susana');
INSERT INTO events VALUES (4,'100m',2016, 'Ronald','maria','paula');
INSERT INTO events VALUES (5,'200m',2016, 'Alfred','carol','Steven');
INSERT INTO events VALUES (6,'500m',2016, 'Nichole','Alfred','Brandon');
INSERT INTO events VALUES (7,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (8,'200m',2016, 'Thomas','Dawn','catherine');
INSERT INTO events VALUES (9,'500m',2016, 'Thomas','Dennis','paula');
INSERT INTO events VALUES (10,'100m',2016, 'Charles','Dennis','Susana');
INSERT INTO events VALUES (11,'200m',2016, 'jessica','Donald','Stefeney');
INSERT INTO events VALUES (12,'500m',2016,'Thomas','Steven','Catherine');

select * from events;

WITH CTE1 AS (
select G.GOLD
from events G
LEFT JOIN (select SILVER from events) S on G.GOLD = S.SILVER
LEFT JOIN (select BRONZE from events) B on G.GOLD = B.BRONZE
WHERE S.SILVER IS NULL AND B.BRONZE IS NULL
)
SELECT GOLD AS PLAYER_NAME, COUNT(GOLD) AS NO_OF_GOLDS FROM CTE1
GROUP BY GOLD;

# Q.7  employee salary more than managerc salary.

create table emp_manager(emp_id int,emp_name varchar(50),salary int(20),manager_id int(10));
insert into emp_manager values(	1	,'Ankit',	10000	,4	);
insert into emp_manager values(	2	,'Mohit',	15000	,5	);
insert into emp_manager values(	3	,'Vikas',	10000	,4	);
insert into emp_manager values(	4	,'Rohit',	5000	,2	);
insert into emp_manager values(	5	,'Mudit',	12000	,6	);
insert into emp_manager values(	6	,'Agam',	12000	,2	);
insert into emp_manager values(	7	,'Sanjay',	9000	,2	);
insert into emp_manager values(	8	,'Ashish',	5000	,2	);

select e.emp_id,e.emp_name,m.emp_name as manager_name,e.salary,m.salary 
as manager_salary from emp_manager e
inner join emp m on e.manager_id=m.emp_id
where e.salary>m.salary;

# Q 8 . convert rows to column.(pivot).

create table emp_compensation (
emp_id int,
salary_component_type varchar(20),
val int
);
insert into emp_compensation
values (1,'salary',10000),(1,'bonus',5000),(1,'hike_percent',10)
, (2,'salary',15000),(2,'bonus',7000),(2,'hike_percent',8)
, (3,'salary',12000),(3,'bonus',6000),(3,'hike_percent',7);
select * from emp_compensation;
Select emp_id
,SUM(case when salary_component_type = 'salary' then val end) as Salary
,SUM(case WHEN salary_component_type = 'bonus' then val end) as  Bonus
,SUM(case when salary_component_type = 'hike_percent' then val end) as hike_percent
from emp_compensation
group by emp_id;

# Q.9 EMPLOYEE WHOSESALARY IS SAME IN SAME DEPARTMENT. 

CREATE TABLE emp_salary
(emp_id INTEGER  NOT NULL,
    name VARCHAR(20)  NOT NULL,
    salary VARCHAR(30),
    dept_id INTEGER);


INSERT INTO emp_salary
(emp_id, name, salary, dept_id)
VALUES(101, 'sohan', '3000', '11'),
(102, 'rohan', '4000', '12'),
(103, 'mohan', '5000', '13'),
(104, 'cat', '3000', '11'),
(105, 'suresh', '4000', '12'),
(109, 'mahesh', '7000', '12'),
(108, 'kamal', '8000', '11');

( select * from(select *,count(rn) over(partition by rn) as same from(select *,rank() over(order by dept_id, salary)rn from emp_salary)a)b
where same = 2 )

# Q.10 derive points table from data.

create table icc_world_cup
(Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

select * from icc_world_cup;

SELECT team_name, count(1) as no_of_matches_played,sum(win_flag) as no_of_matches_won,count(1)-sum(win_flag)as no_of_losses
from(
select team_1 as team_name,case when team_1=winner then 1 else 0 end
as win_flag from icc_world_cup UNION ALL
select team_2 as team_name,case when team_2=winner then 1 else 0 end as win_flag
from icc_world_cup) A
group by team_name
order by no_of_matches_won desc

