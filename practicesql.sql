CREATE DATABASE vel;
USE vel;
CREATE TABLE Students (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    age INT,
    grade CHAR(1)
);

INSERT INTO Students VALUES (1, 'haris', 14, 'A');
INSERT INTO Students VALUES (2, 'sree', 15, 'B');
INSERT INTO Students VALUES (3, 'paul', 13, 'A');
INSERT INTO Students VALUES (4, 'hunt', 7, 'B');

select * from students;  
select * from students where grade = 'A';
update students set age = 13 where id =2;
delete from students where id = '2';
SELECT * FROM Students ORDER BY age DESC;
SELECT * FROM Students WHERE name LIKE 'H%'; -- Names starting with A
SELECT * FROM Students WHERE grade IN ('A', 'B');
SELECT * FROM Students WHERE age BETWEEN 13 AND 15;
SELECT grade, COUNT(*) FROM Students GROUP BY grade;
SELECT grade, COUNT(*) FROM Students GROUP BY grade HAVING COUNT(*) > 1;

CREATE TABLE Courses (
    course_id INT,
    course_name VARCHAR(50)
);

CREATE TABLE Enrollments (
    student_id INT,
    course_id INT
);

SELECT Students.name, Courses.course_name
FROM Students
JOIN Enrollments ON Students.id = Enrollments.student_id
JOIN Courses ON Courses.course_id = Enrollments.course_id;

-- Find students older than the average age --Subqueries
SELECT * FROM Students
WHERE age > (SELECT AVG(age) FROM Students);

SELECT name,
  CASE 
    WHEN grade = 'A' THEN 'Excellent'
    WHEN grade = 'B' THEN 'Good'
    ELSE 'Average'
  END AS performance
FROM Students;

-- union and union all
SELECT name FROM Students WHERE grade = 'A'
UNION
SELECT name FROM Students WHERE age < 15;

-- Window Functions (RANK, ROW_NUMBER)
INSERT INTO Students VALUES (5, 'bibo', 14, 'B');

select name,grade,
rank() over (order by age desc) as Rank_it
from students;

select name,grade,
row_number() over (order by age desc) as Rank_it
from students;

-- CTE (Common Table Expression)
with top as(
   select min(age) as high_age from students
   )
   select name,high_age
   from students,top
   where students.age = top.high_age;


-- Self Join
select a.name as stu1 , b.name as stu2
from students a, students b
where a.age = b.age and a.id != b.id;


-- Find Duplicate Rows
select name,count(*)
from students
group by name
having count(*) >1 ;

-- Delete Duplicate rows
delete from students 
where id not in(
select min(id) 
from students
group by name, age, grade
);

Select * from students;

-- Second highest age
select max(age)
from students
where age < (select max(age) from students);









