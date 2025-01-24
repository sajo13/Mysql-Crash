
#create new database

CREATE DATABASE database mysql_crash;

#selecting the database
use mysql_crash;


-- Create 'departments' table with a Primary Key
CREATE TABLE departments (
                             department_id INT AUTO_INCREMENT,
                             department_name VARCHAR(100) NOT NULL,
                             PRIMARY KEY (department_id)
);

-- Create 'employees' table with a Foreign Key referencing 'departments'
CREATE TABLE employees (
                           employee_id INT AUTO_INCREMENT,
                           first_name VARCHAR(100),
                           last_name VARCHAR(100),
                           department_id INT,
                           PRIMARY KEY (employee_id),
                           FOREIGN KEY (department_id) REFERENCES departments(department_id)
);


-- Insert some departments
INSERT INTO departments (department_name) VALUES ('HR');
INSERT INTO departments (department_name) VALUES ('Engineering');
INSERT INTO departments (department_name) VALUES ('Marketing');

-- Insert employees with foreign key references to departments
INSERT INTO employees (first_name, last_name, department_id)
VALUES ('Sajo', 'Sunny', null);

INSERT INTO employees (first_name, last_name, department_id)
VALUES ('James', 'Smith', 2);

INSERT INTO employees (first_name, last_name, department_id)
VALUES ('Arun', 'Thomas', 1);


--Add foreign key after table creation

ALTER TABLE employees
    ADD CONSTRAINT fk_department
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE;

-- in laravel Foreign key add

Schema::create('posts', function (Blueprint $table) {
        $table->id(); // Primary key for the posts table
        $table->string('title');
        $table->text('content');
        $table->unsignedBigInteger('user_id'); // Foreign key column for users
        $table->timestamps();

        // Foreign key constraint
        $table->foreign('user_id') // 'user_id' is the foreign key
              ->references('id') // 'id' is the primary key in the 'users' table
              ->on('users') // The table that the foreign key references
              ->onDelete('cascade'); // If a user is deleted, delete all their posts
    });

-- Inner Join

SELECT CONCAT(emp.first_name, ' ', emp.last_name) AS full_name, dep.department_name
    FROM employees AS emp
    INNER JOIN departments AS dep
ON emp.department_id = dep.department_id;


-- LEFT JOIN (LEFT OUTER JOIN)

SELECT CONCAT(emp.first_name, ' ', emp.last_name) AS full_name, dep.department_name
        FROM employees AS emp
         LEFT JOIN departments AS dep
ON emp.department_id = dep.department_id;

-- RIGHT JOIN (RIGHT OUTER JOIN)

SELECT CONCAT(emp.first_name, ' ', emp.last_name) AS full_name, dep.department_name
        FROM employees AS emp
        RIGHT JOIN departments AS dep
ON emp.department_id = dep.department_id;

-- FULL JOIN (FULL OUTER JOIN)

SELECT CONCAT(emp.first_name, ' ', emp.last_name) AS full_name, dep.department_name
            FROM employees AS emp
         LEFT JOIN departments AS dep
ON emp.department_id = dep.department_id
UNION
SELECT CONCAT(emp.first_name, ' ', emp.last_name) AS full_name, dep.department_name
         FROM employees AS emp
         RIGHT JOIN departments AS dep
ON emp.department_id = dep.department_id;

-- CROSS JOIN

SELECT CONCAT(emp.first_name, ' ', emp.last_name) AS full_name, dep.department_name
    FROM employees AS emp
    CROSS JOIN departments AS dep;

-- SELF JOIN


CREATE TABLE employees (
            employee_id INT PRIMARY KEY,
            first_name VARCHAR(50),
            last_name VARCHAR(50),
            salary INT,
            manager_id INT,
            FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);


INSERT INTO employees (employee_id, first_name, last_name, salary, manager_id) VALUES
        (1, 'John', 'Doe', 10000,NULL),       -- John has no manager (perhaps he's the CEO)
        (2, 'Jane', 'Smith', 20000,1),       -- Jane's manager is John (employee_id 1)
        (3, 'Tom', 'Brown', 20000, 1),        -- Tom's manager is John (employee_id 1)
        (4, 'Alice', 'Johnson', 20000, 2),    -- Alice's manager is Jane (employee_id 2)
        (5, 'Bob', 'White', 30000, 3);        -- Bob's manager is Tom (employee_id 3)

SELECT e.first_name AS employee_first_name,
       e.last_name AS employee_last_name,
       m.first_name AS manager_first_name,
       m.last_name AS manager_last_name
FROM employees e
         LEFT JOIN employees m ON e.manager_id = m.employee_id;


-- Group Results With Aggregate Functions

SELECT employee_id,
       SUM(salary) AS total_spent,
       AVG(salary) AS avg_spent,
       MIN(salary) AS min_spent,
       MAX(salary) AS max_spent
       FROM employees
       GROUP BY employee_id;



-- Multiple Joins in One Query

CREATE TABLE customers (
                           customer_id INT PRIMARY KEY,
                           customer_name VARCHAR(100),
                           city VARCHAR(50)
);

CREATE TABLE orders (
                        order_id INT PRIMARY KEY,
                        customer_id INT,
                        order_date DATE,
                        total_amount DECIMAL(10, 2),
                        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE products (
                          product_id INT PRIMARY KEY,
                          order_id INT,
                          product_name VARCHAR(100),
                          quantity INT,
                          FOREIGN KEY (order_id) REFERENCES orders(order_id)
);


INSERT INTO customers (customer_id, customer_name, city) VALUES
         (1, 'Alice Johnson', 'New York'),
         (2, 'Bob Smith', 'Los Angeles'),
         (3, 'Charlie Brown', 'Chicago'),
         (4, 'David White', 'Houston'),
         (5, 'Eva Green', 'San Francisco');

INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
         (1, 1, '2025-01-10', 250.75),
         (2, 2, '2025-01-12', 320.50),
         (3, 3, '2025-01-15', 150.00),
         (4, 1, '2025-01-20', 500.00),
         (5, 4, '2025-01-22', 45.99);

INSERT INTO products (product_id, order_id, product_name, quantity) VALUES
        (1, 1, 'Laptop', 1),
        (2, 1, 'Mouse', 2),
        (3, 2, 'Smartphone', 1),
        (4, 2, 'Headphones', 1),
        (5, 3, 'Tablet', 3),
        (6, 4, 'Keyboard', 1),
        (7, 5, 'Monitor', 2);


SELECT
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.order_date,
    o.total_amount,
    p.product_name,
    p.quantity
FROM
    customers c
        JOIN
    orders o ON c.customer_id = o.customer_id
        JOIN
    products p ON o.order_id = p.order_id;


-- Filtering Aggregated Data

-- Insert sample data into customers
INSERT INTO customers (customer_id, customer_name, city) VALUES
                                                             (1, 'Alice Johnson', 'New York'),
                                                             (2, 'Bob Smith', 'Los Angeles'),
                                                             (3, 'Charlie Brown', 'Chicago'),
                                                             (4, 'David White', 'Houston'),
                                                             (5, 'Eva Green', 'San Francisco');

-- Insert sample data into orders
INSERT INTO orders (order_id, customer_id, order_date, total_amount) VALUES
                                                                         (1, 3, '2025-01-10', 550.75),
                                                                         (2, 4, '2025-01-12', 520.50),
                                                                         (3, 5, '2025-01-15', 500.00),
                                                                         (4, 3, '2025-01-20', 5040.00),
                                                                         (5, 4, '2025-01-22', 4005.99);

-- Insert sample data into products
INSERT INTO products (product_id, order_id, product_name, quantity) VALUES
                                                                        (1, 1, 'Laptop', 1),
                                                                        (2, 1, 'Mouse', 2),
                                                                        (3, 2, 'Smartphone', 1),
                                                                        (4, 2, 'Headphones', 1),
                                                                        (5, 3, 'Tablet', 3),
                                                                        (6, 4, 'Keyboard', 1),
                                                                        (7, 5, 'Monitor', 2);

SELECT
    customer_id
FROM
    orders
GROUP BY
    customer_id
HAVING
    COUNT(order_id) > 1  -- Change to > 1 instead of > 2
   AND SUM(total_amount) > 500;


-- One-to-One Relationship

CREATE TABLE users (
                       user_id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) NOT NULL,
                       email VARCHAR(100) NOT NULL
);

CREATE TABLE user_profiles (
                               profile_id INT AUTO_INCREMENT PRIMARY KEY,
                               user_id INT,
                               first_name VARCHAR(50),
                               last_name VARCHAR(50),
                               date_of_birth DATE,
                               FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);



INSERT INTO users (username, email) VALUES ('Sajo007', 'sajo@example.com');
INSERT INTO user_profiles (user_id, first_name, last_name, date_of_birth)
VALUES (1, 'Sajo', 'Sunny', '1990-05-15');

SELECT u.username, u.email, p.first_name, p.last_name, p.date_of_birth
FROM users u
         JOIN user_profiles p ON u.user_id = p.user_id;

-- One-to-Many Relationship

CREATE TABLE users (
                       user_id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) NOT NULL,
                       email VARCHAR(100) NOT NULL
);

CREATE TABLE posts (
                       post_id INT AUTO_INCREMENT PRIMARY KEY,
                       user_id INT,
                       title VARCHAR(255),
                       content TEXT,
                       FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- Inserting users
INSERT INTO users (username, email) VALUES ('alice', 'alice@example.com');
INSERT INTO users (username, email) VALUES ('bob', 'bob@example.com');

-- Inserting posts
INSERT INTO posts (user_id, title, content) VALUES (1, 'Post 1 by Alice', 'Content of post 1');
INSERT INTO posts (user_id, title, content) VALUES (1, 'Post 2 by Alice', 'Content of post 2');
INSERT INTO posts (user_id, title, content) VALUES (2, 'Post 1 by Bob', 'Content of post 1');


SELECT u.username, p.title, p.content
FROM users u
         JOIN posts p ON u.user_id = p.user_id;


-- Many-to-Many Relationship

CREATE TABLE students (
                          student_id INT AUTO_INCREMENT PRIMARY KEY,
                          name VARCHAR(50)
);

CREATE TABLE courses (
                         course_id INT AUTO_INCREMENT PRIMARY KEY,
                         course_name VARCHAR(100)
);

CREATE TABLE student_courses (
                                 student_id INT,
                                 course_id INT,
                                 PRIMARY KEY (student_id, course_id),
                                 FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
                                 FOREIGN KEY (course_id) REFERENCES courses(course_id) ON DELETE CASCADE
);


-- Inserting students
INSERT INTO students (name) VALUES ('John Doe');
INSERT INTO students (name) VALUES ('Jane Smith');

-- Inserting courses
INSERT INTO courses (course_name) VALUES ('Math 101');
INSERT INTO courses (course_name) VALUES ('History 101');

-- Enroll students in courses
INSERT INTO student_courses (student_id, course_id) VALUES (1, 1);  -- John Doe in Math 101
INSERT INTO student_courses (student_id, course_id) VALUES (1, 2);  -- John Doe in History 101
INSERT INTO student_courses (student_id, course_id) VALUES (2, 1);  -- Jane Smith in Math 101



SELECT s.name AS student_name, c.course_name
FROM students s
         JOIN student_courses sc ON s.student_id = sc.student_id
         JOIN courses c ON sc.course_id = c.course_id;

# Unique key constraints

CREATE TABLE users (
                       user_id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) NOT NULL,
                       email VARCHAR(100) NOT NULL,
                       UNIQUE (email)  -- This ensures that email addresses are unique
);


-- Valid insertion
INSERT INTO users (username, email) VALUES ('john_doe', 'john.doe@example.com');

-- Attempting to insert a duplicate email will result in an error
INSERT INTO users (username, email) VALUES ('jane_doe', 'john.doe@example.com');


SELECT * FROM users;

#Create Index to speedup seach query column

CREATE TABLE users (
                       user_id INT AUTO_INCREMENT PRIMARY KEY,
                       username VARCHAR(50) NOT NULL,
                       email VARCHAR(100) NOT NULL
);


INSERT INTO users (username, email) VALUES ('john_doe', 'john.doe@example.com');

EXPLAIN SELECT * FROM users WHERE email = 'john.doe@example.com';

CREATE INDEX idx_email ON users(email);

-- ***************************************
-- Optimization Tips for MySQL Queries
-- ***************************************

/*
  1. **Limit the Columns**:
     - Avoid using SELECT * in your queries.
     - Instead, only select the columns you actually need.
     - This reduces the amount of data MySQL needs to retrieve and can drastically improve performance, especially for large tables.
*/

-- Example: Instead of selecting all columns, select only the columns you need
SELECT username, email FROM users WHERE email = 'john.doe@example.com';


/*
  2. **Avoid OR in WHERE Clauses**:
     - Using OR conditions can be inefficient because MySQL has to scan different indexes or tables to satisfy the condition.
     - Instead of using OR, consider:
       a) Rewriting the query
       b) Using UNION to combine the results of multiple queries
*/

-- Example with OR (not optimal)
SELECT * FROM users WHERE email = 'john.doe@example.com' OR username = 'johndoe';

-- Optimized version using UNION to avoid OR (faster for large datasets)
SELECT * FROM users WHERE email = 'john.doe@example.com'
UNION
SELECT * FROM users WHERE username = 'johndoe';


/*
  3. **Use EXISTS Instead of IN**:
     - If you are using a subquery with IN, it may be less efficient because MySQL must evaluate all the values returned by the subquery.
     - The EXISTS keyword can sometimes be more efficient, especially if the subquery returns many rows.
     - EXISTS stops as soon as it finds the first match, making it more efficient than IN when dealing with large datasets.
*/

-- Example with IN (less efficient)
SELECT * FROM orders o
WHERE o.user_id IN (
    SELECT user_id FROM users WHERE email = 'john.doe@example.com'
);

-- Optimized version using EXISTS (faster for large datasets)
SELECT * FROM orders o
WHERE EXISTS (
    SELECT 1 FROM users u WHERE u.user_id = o.user_id AND u.email = 'john.doe@example.com'
);


/*
  4. **Avoid DISTINCT if Possible**:
     - The DISTINCT keyword requires MySQL to sort the result set, which can be expensive.
     - If you do not absolutely need unique rows, avoid using DISTINCT.
     - If only filtering on unique values, consider using GROUP BY instead of DISTINCT.
*/

-- Example with DISTINCT (inefficient if unnecessary)
SELECT DISTINCT email FROM users;

-- Optimized version without DISTINCT (faster)
SELECT email FROM users;

-- Alternatively, you can use GROUP BY if you're aggregating results
SELECT email FROM users GROUP BY email;

-- 1. When you define a foreign key constraint in MySQL, the database automatically creates an index
--    on the foreign key column in the child table if there is no existing index on it.
-- 2. This index is used to enforce referential integrity and speed up queries that involve joins or
--    lookups on the foreign key column.
-- 3. You can use `SHOW INDEX` to verify the index on the foreign key column.

CREATE TABLE customers (
                           customer_id INT AUTO_INCREMENT PRIMARY KEY,   -- Primary Key for `customers`
                           first_name VARCHAR(100),
                           last_name VARCHAR(100),
                           email VARCHAR(100)
);

CREATE TABLE orders (
                        order_id INT AUTO_INCREMENT PRIMARY KEY,   -- Primary Key for `orders`
                        order_date DATE,
                        customer_id INT,                           -- Foreign Key referencing `customers`
                        amount DECIMAL(10, 2),
                        FOREIGN KEY (customer_id) REFERENCES customers(customer_id)   -- Foreign Key Constraint
);

SHOW INDEX FROM orders;

-- Fetch the Most Popular Authors
-- Authors Table: Contains author information
CREATE TABLE authors (
                         author_id INT AUTO_INCREMENT PRIMARY KEY,
                         first_name VARCHAR(100),
                         last_name VARCHAR(100)
);

-- Books Table: Contains book information with a foreign key referencing authors table
CREATE TABLE books (
                       book_id INT AUTO_INCREMENT PRIMARY KEY,
                       title VARCHAR(255),
                       author_id INT,
                       FOREIGN KEY (author_id) REFERENCES authors(author_id)
);


-- Insert data into authors table
INSERT INTO authors (first_name, last_name)
VALUES
    ('George', 'Orwell'),
    ('J.K.', 'Rowling'),
    ('J.R.R.', 'Tolkien');

-- Insert data into books table
INSERT INTO books (title, author_id)
VALUES
    ('1984', 1),
    ('Animal Farm', 1),
    ("Harry Potter and the Philosopher\'s Stone", 2),
('Harry Potter and the Chamber of Secrets', 2),
('The Hobbit', 3);


SELECT a.first_name, a.last_name, COUNT(b.book_id) AS books_written
FROM authors a
LEFT JOIN books b ON a.author_id = b.author_id
GROUP BY a.author_id
ORDER BY books_written DESC;

-- ***************************************
-- 1. Create Movies and Rentals Tables
-- ***************************************

-- Create movies table
CREATE TABLE movies (
                        movie_id INT AUTO_INCREMENT PRIMARY KEY,
                        title VARCHAR(255),
                        release_year INT
);

-- Create rentals table
CREATE TABLE rentals (
                         rental_id INT AUTO_INCREMENT PRIMARY KEY,
                         movie_id INT,
                         rental_date DATE,
                         return_date DATE,
                         FOREIGN KEY (movie_id) REFERENCES movies(movie_id)
);

-- ***************************************
-- 2. Insert Sample Data into Movies and Rentals Tables
-- ***************************************

-- Insert data into movies table
INSERT INTO movies (title, release_year)
VALUES
    ('The Matrix', 1999),
    ('Inception', 2010),
    ('The Godfather', 1972);

-- Insert data into rentals table
INSERT INTO rentals (movie_id, rental_date, return_date)
VALUES
    (1, '2025-01-01', '2025-01-02'),
    (1, '2025-01-02', '2025-01-03'),
    (2, '2025-01-01', '2025-01-02'),
    (3, '2025-01-02', '2025-01-03'),
    (2, '2025-01-03', '2025-01-04');

-- ***************************************
-- 3. Calculate Average Rentals Per Day
-- ***************************************

SELECT AVG(daily_rentals) AS avg_rentals_per_day
FROM (
         SELECT rental_date, COUNT(*) AS daily_rentals
         FROM rentals
         GROUP BY rental_date
     ) AS daily_counts;
