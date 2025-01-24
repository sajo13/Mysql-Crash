
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
