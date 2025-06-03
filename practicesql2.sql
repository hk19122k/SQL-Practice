create database student;
use student;

CREATE TABLE student (
    student_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    age INT
);

CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    expertise VARCHAR(100)
);

CREATE TABLE courses (
    course_id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(100),
    description TEXT,
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY AUTO_INCREMENT,
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    FOREIGN KEY (student_id) REFERENCES student(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

CREATE TABLE course_reviews (
    review_id INT PRIMARY KEY AUTO_INCREMENT,
    course_id INT,
    student_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    review_text TEXT,
    FOREIGN KEY (course_id) REFERENCES courses(course_id),
    FOREIGN KEY (student_id) REFERENCES student(student_id)
);

INSERT INTO student (name, email, age) VALUES
('Arun', 'arun@example.com', 22),
('Priya', 'priya@example.com', 24),
('Karthik', 'karthik@example.com', 21),
('Divya', 'divya@example.com', 23),
('Vignesh', 'vignesh@example.com', 25);

INSERT INTO instructors (name, email, expertise) VALUES
('Dr. Ramanujam', 'ramanujam@example.com', 'Python'),
('Prof. Meenakshi', 'meenakshi@example.com', 'SQL'),
('Dr. Ilango', 'ilango@example.com', 'Data Science'),
('Ms. Anitha', 'anitha@example.com', 'Java'),
('Mr. Selvam', 'selvam@example.com', 'Web Development');

INSERT INTO courses (title, description, instructor_id) VALUES
('Intro to Python', 'Learn Python from scratch', 1),
('Advanced SQL', 'Deep dive into SQL queries', 2),
('Data Science Basics', 'Introduction to Data Science concepts', 3),
('Core Java', 'Object-oriented programming with Java', 4),
('Web Development', 'HTML, CSS, and JavaScript basics', 5);

INSERT INTO enrollments (student_id, course_id, enrollment_date) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-01-05'),
(3, 3, '2024-02-01'),
(4, 4, '2024-02-03'),
(5, 5, '2024-02-05');

INSERT INTO course_reviews (course_id, student_id, rating, review_text) VALUES
(1, 1, 5, 'Excellent explanation in Tamil!'),
(2, 2, 4, 'Very detailed and helpful'),
(3, 3, 3, 'Good, but needed more examples'),
(4, 4, 4, 'Clear and practical'),
(5, 5, 5, 'Perfect course for beginners!');

-- Get all students enrolled in "Advanced SQL"
select  s.name
from student s
join enrollments e on s.student_id = e.student_id
join courses c on c.course_id = e.course_id
where c.title = 'Advanced SQL';

-- Count number of students in each course
select c.title , count(e.student_id) as c_stud
from courses c
join enrollments e on c.course_id = e.course_id
group by c.course_id;  

-- Average rating per course
select c.title , avg(r.rating) as c_stud
from courses c
join course_reviews r on r.course_id = c.course_id
group by c.title;

-- Students who have not enrolled in any course
 select name from student
 where student_id not in (
 select student_id from enrollments
 );
 
-- Courses and the names of instructors teaching them
 select c.title,i.name
 from courses c
 join instructors i on c.instructor_id  = i.instructor_id ;

-- Top-rated course (learnt useage of limit here)
SELECT c.title
FROM courses c
JOIN course_reviews r ON c.course_id = r.course_id
GROUP BY c.title 
Limit 1;

-- Use of ROW_NUMBER() to rank students by age
select name,age,
row_number() over(order by age desc) as rank_As
from student;

-- CTE to list students and their total enrollments
with top as(
select student_id, count(*) as list
from enrollments
group by student_id
)
select s.name,t.list
from student s
join top t on s.student_id = t.student_id;

