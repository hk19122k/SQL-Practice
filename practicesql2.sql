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

-- ✅ Get all students enrolled in "Advanced SQL"
SELECT s.name
FROM student s                  -- Start from student table
JOIN enrollments e              -- Join with enrollments table
  ON s.student_id = e.student_id   -- Match student_id
JOIN courses c                  -- Join with courses table
  ON c.course_id = e.course_id     -- Match course_id
WHERE c.title = 'Advanced SQL';    -- Only where course title is "Advanced SQL"

-- 🎯 OUTPUT: Returns name of students enrolled in "Advanced SQL"
-- +-------+
-- | name  |
-- +-------+
-- | Priya |
-- +-------+



-- ✅ Count number of students in each course
SELECT c.title, COUNT(e.student_id) AS c_stud
FROM courses c
JOIN enrollments e 
  ON c.course_id = e.course_id      -- Join enrollments to courses
GROUP BY c.course_id;               -- Group by course_id to count students

-- 🎯 OUTPUT: Title of each course with number of students
-- +---------------------+--------+
-- | title               | c_stud |
-- +---------------------+--------+
-- | Intro to Python     |   1    |
-- | Advanced SQL        |   1    |
-- | Data Science Basics |   1    |
-- | Core Java           |   1    |
-- | Web Development     |   1    |
-- +---------------------+--------+



-- ✅ Average rating per course
SELECT c.title, AVG(r.rating) AS avg_rating
FROM courses c
JOIN course_reviews r 
  ON r.course_id = c.course_id      -- Join reviews to courses
GROUP BY c.title;                   -- Group by course to calculate average

-- 🎯 OUTPUT: Average rating given to each course
-- +---------------------+-------------+
-- | title               | avg_rating  |
-- +---------------------+-------------+
-- | Intro to Python     |     5.0     |
-- | Advanced SQL        |     4.0     |
-- | Data Science Basics |     3.0     |
-- | Core Java           |     4.0     |
-- | Web Development     |     5.0     |
-- +---------------------+-------------+



-- ✅ Students who have not enrolled in any course
SELECT name 
FROM student
WHERE student_id NOT IN (
  SELECT student_id FROM enrollments   -- Get all enrolled student_ids
);

-- 🎯 OUTPUT: Students who are not in the enrollments table
-- Result: ❌ No rows returned (all students enrolled)



-- ✅ Courses and the names of instructors teaching them
SELECT c.title, i.name
FROM courses c
JOIN instructors i 
  ON c.instructor_id = i.instructor_id;  -- Match courses with instructors

-- 🎯 OUTPUT: Shows course title with instructor name
-- +---------------------+-----------------+
-- | title               | name            |
-- +---------------------+-----------------+
-- | Intro to Python     | Dr. Ramanujam   |
-- | Advanced SQL        | Prof. Meenakshi |
-- | Data Science Basics | Dr. Ilango      |
-- | Core Java           | Ms. Anitha      |
-- | Web Development     | Mr. Selvam      |
-- +---------------------+-----------------+



-- ✅ Top-rated course
SELECT c.title
FROM courses c
JOIN course_reviews r 
  ON c.course_id = r.course_id
GROUP BY c.title
ORDER BY AVG(r.rating) DESC   -- Order by average rating (high to low)
LIMIT 1;                      -- Return top 1 row only

-- 🎯 OUTPUT: Course with highest average rating
-- Result: Either "Intro to Python" or "Web Development" (both have 5.0)



-- ✅ Use of ROW_NUMBER() to rank students by age
SELECT name, age,
ROW_NUMBER() OVER (ORDER BY age DESC) AS rank_As
FROM student;

-- 🎯 OUTPUT: Assigns a rank to students based on descending age
-- +---------+-----+---------+
-- | name    | age | rank_As |
-- +---------+-----+---------+
-- | Vignesh |  25 |    1    |
-- | Priya   |  24 |    2    |
-- | Divya   |  23 |    3    |
-- | Arun    |  22 |    4    |
-- | Karthik |  21 |    5    |
-- +---------+-----+---------+



-- ✅ CTE to list students and their total enrollments
WITH top AS (                      -- Step 1: Create a temporary result (CTE)
  SELECT student_id, COUNT(*) AS list   -- Count how many enrollments per student
  FROM enrollments
  GROUP BY student_id
)
SELECT s.name, t.list             -- Step 2: Use the CTE result
FROM student s
JOIN top t 
  ON s.student_id = t.student_id;

-- 🎯 OUTPUT: Student name with number of courses enrolled
-- +---------+------+
-- | name    | list |
-- +---------+------+
-- | Arun    |  1   |
-- | Priya   |  1   |
-- | Karthik |  1   |
-- | Divya   |  1   |
-- | Vignesh |  1   |
-- +---------+------+
