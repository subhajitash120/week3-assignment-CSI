CREATE DATABASE CSI3
use CSI3

------------------TASK1------------------

create table project (task_id int , starting_date date, end_date date);

insert into project values
(1, '2015-10-1', '2015-10-2'),
(2, '2015-10-2', '2015-10-3'),
(3, '2015-10-3', '2015-10-4'),
(4, '2015-10-13', '2015-10-14'),
(5, '2015-10-14', '2015-10-15'),
(6, '2015-10-28', '2015-10-29'),
(7, '2015-10-30', '2015-10-31')


SELECT starting_Date, min(end_date)
FROM 
 (SELECT starting_date FROM project WHERE starting_date NOT IN (SELECT end_date FROM project)) a ,
 (SELECT end_Date FROM project WHERE end_date NOT IN (SELECT starting_date FROM project)) b
WHERE starting_date < end_date
GROUP BY starting_date
ORDER BY DATEDIFF(DAY,starting_date, end_date) ASC, starting_date ASC;


	-----------TASK2---------------

	create table Students (id int , names varchar(40));
	create table Friends (id int , friend_id int);
	create table Packages (id int , salary float);

	insert into Students values
	(1, 'Ashley'),
	(2, 'Samantha'),
	(3, 'Julia'),
	(4, 'scarlet');

	insert into Friends values
	(1, 2),
	(2, 3),
	(3, 4),
	(4, 1);

	insert into Packages values
	(1, 15.20),
	(2, 10.06),
	(3,11.55),
	(4, 12.12);


	SELECT s1.names
FROM 
    (
        SELECT s.ID, s.names, p.Salary
        FROM Students s
        JOIN Packages p ON s.ID = p.ID
    ) s1
JOIN 
    (
        SELECT f.ID, p.Salary [Friend_Salary]
        FROM Friends f
        JOIN Packages p ON f.Friend_ID = p.ID
    ) s2 ON s1.ID = s2.ID
WHERE s1.Salary < s2.Friend_Salary
ORDER BY s2.Friend_Salary


------------TASK3--------------

create table Functions (X int , Y int);

insert into Functions values
(20,20),(20,20),(20,21),(23,22),(22,23),(21,20);

SELECT f1.X, f1.Y FROM Functions AS f1 
WHERE f1.X = f1.Y AND
(SELECT COUNT(*) FROM Functions WHERE X = f1.X AND Y = f1.Y) > 1
UNION
SELECT f1.X, f1.Y from Functions AS f1
WHERE EXISTS(SELECT X, Y FROM Functions WHERE f1.X = Y AND f1.Y = X AND f1.X < X)
ORDER BY X;

-------------TASK4-------------

create table Contests(contest_id int, hacker_id int, names varchar(20));
create table Colleges(college_id int, contest_id int)
create table Challenges(challenge_id int, college_id int)
create table View_Stats(challenge_id int, total_views int, total_unique_views int)
create table Submission_Stats(challenge_id int, total_submissions int,total_accepted_submissions int)

insert into Contests values
(66406, 17973,'Rose'),
(66556, 79153,'Angela'),
(94828, 80275,'Frank');

insert into Colleges values
(11219,66406),
(32473,66556),
(56685,94828);

insert into Challenges values
(18765, 11219),
(47127, 11219),
(60292, 32473),
(72974, 56685);

insert into View_Stats values
(47127,26,19),
(47127,15,14),
(18765,43,10),
(18765,72,13),
(75516,35,17),
(60292,11,10),
(72974,41,15),
(75516,75,11);

insert into Submission_Stats values
(75516,34,12),
(47127,27,10),
(47127,56,18),
(75516,74,12),
(75516,83,8),
(72974,68,24),
(72974,82,14),
(47127,28,11);

SELECT con.contest_id, con.hacker_id, con.names, SUM(sg.total_submissions), SUM(sg.total_accepted_submissions),
SUM(vg.total_views), SUM(vg.total_unique_views)
FROM Contests AS con 
JOIN Colleges AS col
ON con.contest_id = col.contest_id
JOIN Challenges AS cha 
ON cha.college_id = col.college_id
LEFT JOIN
(SELECT ss.challenge_id, SUM(ss.total_submissions) AS total_submissions, SUM(ss.total_accepted_submissions) AS total_accepted_submissions FROM 
Submission_Stats AS ss GROUP BY ss.challenge_id) AS sg
ON cha.challenge_id = sg.challenge_id
LEFT JOIN
(SELECT vs.challenge_id, SUM(vs.total_views) AS total_views, SUM(total_unique_views) AS total_unique_views FROM View_Stats AS vs GROUP BY vs.challenge_id) AS vg
ON cha.challenge_id = vg.challenge_id
GROUP BY con.contest_id, con.hacker_id, con.names
HAVING SUM(sg.total_submissions)+
       SUM(sg.total_accepted_submissions)+
       SUM(vg.total_views)+
       SUM(vg.total_unique_views) > 0
ORDER BY con.contest_id;


-------------TASK5---------------


create table Hackers (hacker_id int, name varchar(20))
create table Submissions(submission_date date, submission_id int, hacker_id int, score int)

insert into Hackers values
(15758, 'Rose'),
(20703, 'Angela'),
(36396, 'Frank'),
(38289, 'Patrick'),
(44065, 'Lisa'),
(53473, 'Kimberly'),
(62529, 'Bonny'),
(79722, 'Michael');

insert into Submissions values
('2016-03-01', 8494, 20703,0),
('2016-03-01', 22403, 53473,15),
('2016-03-01', 23965, 79722,60),
('2016-03-01', 30173, 36396,70),
('2016-03-02', 34928, 20703,0),
('2016-03-02', 38740, 15758,60),
('2016-03-02', 42769, 79722,25),
('2016-03-02', 44364, 79722,60),
('2016-03-03', 45440, 20703,0),
('2016-03-03', 49050, 36396,70),
('2016-03-03', 50273, 79722,5),
('2016-03-04', 50344, 20703,0),
('2016-03-04', 51360, 44065,90),
('2016-03-04', 54404, 53473,65),
('2016-03-04', 61533, 79722,45),
('2016-03-05', 72852, 20703,0),
('2016-03-05', 74546, 38289,0),
('2016-03-05', 76487, 62529,0),
('2016-03-05', 82439, 36396,10),
('2016-03-05', 90006, 36396,40),
('2016-03-06', 90404, 20703,0);


with MaxSubEachDay as (
    select submission_date,
           hacker_id,
           RANK() OVER(partition by submission_date order by SubCount desc, hacker_id) as Rn
    FROM
    (select submission_date, hacker_id, count(1) as SubCount 
     from submissions
     group by submission_date, hacker_id
     ) subQuery
), DayWiseRank as (
    select submission_date,
           hacker_id,
           DENSE_RANK() OVER(order by submission_date) as dayRn
    from submissions
), HackerCntTillDate as (
select outtr.submission_date,
       outtr.hacker_id,
       case when outtr.submission_date='2016-03-01' then 1
            else 1+(select count(distinct a.submission_date)                         from submissions a where a.hacker_id = outtr.hacker_id and                              a.submission_date<outtr.submission_date)
        end as PrevCnt,
        outtr.dayRn
from DayWiseRank outtr
), HackerSubEachDay as (
    select submission_date,
    count(distinct hacker_id) HackerCnt
from HackerCntTillDate
  where PrevCnt = dayRn
group by submission_date
)
select HackerSubEachDay.submission_date,
       HackerSubEachDay.HackerCnt,
       MaxSubEachDay.hacker_id,
       Hackers.name
from HackerSubEachDay
inner join MaxSubEachDay
 on HackerSubEachDay.submission_date = MaxSubEachDay.submission_date
inner join Hackers
 on Hackers.hacker_id = MaxSubEachDay.hacker_id
where MaxSubEachDay.Rn=1


-----------TASK6-----------------


create table STATION( ID int, CITY varchar(21), STATE varchar(2), LAT_N int, LONG_W int)

select ROUND(ABS(MAX(LAT_N) - MIN(LAT_N)) + ABS(MAX(LONG_W) - MIN(LONG_W)), 4) FROM STATION;


-------------------TASK7----------------------


SELECT LISTAGG(PRIME_NUMBER,'&') WITHIN GROUP (ORDER BY PRIME_NUMBER)
FROM(
SELECT L PRIME_NUMBER
FROM(
SELECT LEVEL L
FROM DUAL
CONNECT BY LEVEL <= 1000),
(SELECT LEVEL M FROM DUAL CONNECT BY LEVEL <= 1000)
WHERE M <= L
GROUP BY L
HAVING COUNT(CASE WHEN L/M = TRUNC(L/M) THEN 'Y' END) = 2
ORDER BY L);


------------------TASK8-----------------


create table OCCUPATIONS(Name varchar(20), OCCUPATION varchar(20));
insert into OCCUPATIONS values
('Samantha','Doctor'),
('Julia','Actor'),
('Maria','Actor'),
('Meera','Singer'),
('Ashely','Professor'),
('Ketty','Professor'),
('Christeen','Professor'),
('Jane','Actor'),
('Jenny','Doctor'),
('Priya','Singer');


Select Doctor, Professor, Singer, Actor from (
 SELECT  name, 
               occupation,
        ROW_NUMBER() OVER (PARTITION BY occupation ORDER BY name) AS row_number
      FROM OCCUPATIONS
)dt
PIVOT (
    MAX(name)
    FOR [Occupation] IN ([Doctor],  [Professor],
                       [Singer],  [Actor])
)pt
ORDER BY row_number;


------------TASK9-------------------


create table BST(N int, P int)

insert into BST values
(1,2), (3,2),(6,8),(9,8),(2,5),(8,5),(5,null);

SELECT N,
CASE
WHEN P IS NULL THEN 'Root'
WHEN N IN (SELECT P FROM BST) THEN 'Inner'
ELSE 'Leaf'
END
FROM BST
ORDER by N;


----------------------TASK10---------------------


create table company(company_code varchar(20), founder varchar(20))
create table lead_manager(lead_manager_code varchar(20), company_code varchar(20))
create table senior_manager(senior_manager_code varchar(20),lead_manager_code varchar(20), company_code varchar(20))
create table manager(manager_code varchar(20),senior_manager_code varchar(20),lead_manager_code varchar(20), company_code varchar(20))
create table employee(employee_code varchar(20),manager_code varchar(20),senior_manager_code varchar(20),lead_manager_code varchar(20), company_code varchar(20))

insert into company values
('C1', 'Monika'), ('C2','Samantha');

insert into lead_manager values
('LM1','C1'), ('LM2','C2');

insert into senior_manager values
('SM1','LM1','C1'), ('SM2','LM2','C2'),('SM3','LM3','C3');

insert into manager values
('M1','SM1','LM1','C1'), ('M2','SM3','LM2','C2'),('M3','SM3','LM2','C2');

insert into employee values
('E1','M1','SM1','LM1','C1'), ('E2','M1','SM1','LM1','C1'),('E3','M2','SM3','LM2','C2') ,('E4','M3','SM3','LM2','C2')


SELECT c.company_code, c.founder, 
COUNT(DISTINCT e.lead_manager_code), 
COUNT(DISTINCT e.senior_manager_code), 
COUNT(DISTINCT e.manager_code), 
COUNT(DISTINCT e.employee_code) 
FROM company c
JOIN employee e ON c.company_code = e.company_code 
GROUP BY c.company_code, c.founder 
ORDER BY c.company_code;



-----------------TASK11------------------
--------(same question as task 2)------------


---------------Task12----------------


create table t (ctc int, job_family varchar(20),country varchar(20), city varchar(20) );

insert into t values 
             (12000, 'service', 'india', 'delhi'),
             (15000, 'management', 'australia', 'melbourne'),
             (16000, 'it executive', 'india', 'delhi'),
             (16000, 'service', 'india', 'jaipur'),
             (14000, 'management', 'australia', 'sydney'),
             (10000, 'Billing', 'canada', 'Toronto'),
             (20000, 'Billing', 'canada', 'montreal'),
             (15000, 'service', 'canada', 'toronto'),
             (18000, 'Billing', 'india', 'pune'),
             (22000, 'it executive', 'india', 'pune'),
             (20000, 'Billing', 'india', 'mumbai'),
             (12000, 'management', 'india', 'delhi'),
             (14000, 'management', 'india', 'noida'),
             (19000, 'management', 'canada', 'toronto'),
             (19000, 'management', 'canada', 'montreal')

	 
	 select job_family, country,
       sum(ctc) * 1.0 / sum(case when country = 'India' then sum(ctc) end) over (partition by job_family) as ratio
from t
group by country, job_family
order by country


--------------------------TASK13-----------------------------


-- Create the BUData table
CREATE TABLE BUData (
    BU VARCHAR(50),
    Month DATE,
    Cost DECIMAL(10, 2),
    Revenue DECIMAL(10, 2)
);

-- Insert sample data into BUData
INSERT INTO BUData (BU, Month, Cost, Revenue)
VALUES
('BU1', '2023-01-01', 10000.00, 20000.00),
('BU1', '2023-02-01', 12000.00, 22000.00),
('BU2', '2023-01-01', 8000.00, 18000.00),
('BU2', '2023-02-01', 9000.00, 19000.00),
('BU3', '2023-01-01', 15000.00, 25000.00),
('BU3', '2023-02-01', 16000.00, 26000.00);


-- Calculate the cost and revenue by BU and month
WITH BUCostRevenue AS (
    SELECT
        BU,
        Month,
        SUM(Cost) AS TotalCost,
        SUM(Revenue) AS TotalRevenue
    FROM BUData
    GROUP BY BU, Month
)
-- Calculate the ratio
SELECT
    BU,
    Month,
    TotalCost,
    TotalRevenue,
    (TotalCost * 1.0 / TotalRevenue) AS CostRevenueRatio
FROM BUCostRevenue;


                          ----------------TASK14-----------------------


-- Create the Employees table
CREATE TABLE Employees (
    SubBand VARCHAR(50),
    Headcount INT
);

-- Insert sample data into Employees
INSERT INTO Employees (SubBand, Headcount)
VALUES
('SubBand1', 100),
('SubBand2', 150),
('SubBand3', 200),
('SubBand4', 250),
('SubBand5', 300);


-- Assuming there's a way to calculate total headcount
SELECT
    SubBand,
    SUM(Headcount) AS TotalHeadcount,
    (SUM(Headcount) * 100.0 / (SELECT SUM(Headcount) FROM Employees)) AS HeadcountPercentage
FROM Employees
GROUP BY SubBand;


------------------------TASK15-----------------------


-- Create the Employees table
CREATE TABLE Employees1 (
    EmployeeID INT,
    Salary DECIMAL(10, 2)
);

-- Insert sample data into Employees
INSERT INTO Employees1(EmployeeID, Salary)
VALUES
(1, 70000.00),
(2, 75000.00),
(3, 80000.00),
(4, 85000.00),
(5, 90000.00),
(6, 95000.00),
(7, 100000.00);

WITH RankedSalaries AS (
    SELECT
        EmployeeID,
        Salary,
        ROW_NUMBER() OVER (PARTITION BY 1 ORDER BY Salary DESC) AS Rank
    FROM Employees1
)
SELECT
    EmployeeID,
    Salary
FROM RankedSalaries
WHERE Rank <= 5;


-------------------------TASK16-----------------------------


-- Create the ExampleTable
CREATE TABLE ExampleTable (
    ColumnA INT,
    ColumnB INT
);

-- Insert sample data into ExampleTable
INSERT INTO ExampleTable (ColumnA, ColumnB)
VALUES
(10, 20),
(30, 40),
(50, 60);

UPDATE ExampleTable
SET
    ColumnA = ColumnA + ColumnB,
    ColumnB = ColumnA - ColumnB,
    ColumnA = ColumnA - ColumnB;


-----------------------TASK17---------------------


-- Create a login
CREATE LOGIN YourLoginName WITH PASSWORD = 'YourPassword';

-- Create a user for the login
CREATE USER YourUserName FOR LOGIN YourLoginName;

-- Add the user to the db_owner role
ALTER ROLE db_owner ADD MEMBER YourUserName;


----------------------------TASK18--------------------------


-- Create the EmployeeCosts table
CREATE TABLE EmployeeCosts (
    BU VARCHAR(50),
    Month DATE,
    EmployeeID INT,
    Cost DECIMAL(10, 2),
    Weight DECIMAL(5, 2)
);

-- Insert sample data into EmployeeCosts
INSERT INTO EmployeeCosts (BU, Month, EmployeeID, Cost, Weight)
VALUES
('BU1', '2023-01-01', 1, 2000.00, 1.2),
('BU1', '2023-01-01', 2, 3000.00, 1.5),
('BU1', '2023-02-01', 1, 2500.00, 1.3),
('BU1', '2023-02-01', 2, 3500.00, 1.6),
('BU2', '2023-01-01', 3, 1800.00, 1.1),
('BU2', '2023-01-01', 4, 2800.00, 1.4),
('BU2', '2023-02-01', 3, 2300.00, 1.2),
('BU2', '2023-02-01', 4, 3300.00, 1.5);

-- Calculate the weighted average cost
WITH WeightedCosts AS (
    SELECT
        BU,
        Month,
        SUM(Cost * Weight) AS WeightedSum,
        SUM(Weight) AS TotalWeight
    FROM EmployeeCosts
    GROUP BY BU, Month
)
-- Calculate the weighted average
SELECT
    BU,
    Month,
    (WeightedSum / TotalWeight) AS WeightedAvgCost
FROM WeightedCosts;



----------------------TASK19------------------------


create table emp (id int, name varchar (20), salary int)

insert into emp values
(1, 'kristeen', 1420),
(2,'ashley', 2006),
(3, 'julia', 2210),
(4, 'maria', 3000);

select cast(ceiling(avg(cast(salary as float)) - avg(cast(replace(salary, '0', '') as float))) as int) 
from emp


------------------------------TASK20-----------------------


-- Create the SourceTable
CREATE TABLE SourceTable (
    ID INT PRIMARY KEY,
    Data VARCHAR(100)
);

-- Create the DestinationTable
CREATE TABLE DestinationTable (
    ID INT PRIMARY KEY,
    Data VARCHAR(100)
);

-- Insert sample data into SourceTable
INSERT INTO SourceTable (ID, Data)
VALUES
(1, 'Data1'),
(2, 'Data2'),
(3, 'Data3');

-- Insert sample data into DestinationTable
INSERT INTO DestinationTable (ID, Data)
VALUES
(1, 'Data1');

-- Copy new data from SourceTable to DestinationTable
INSERT INTO DestinationTable (ID, Data)
SELECT s.ID, s.Data
FROM SourceTable s
LEFT JOIN DestinationTable d ON s.ID = d.ID
WHERE d.ID IS NULL;

-- Verify the data in DestinationTable
SELECT * FROM DestinationTable;






