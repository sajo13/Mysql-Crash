
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
VALUES ('Sajo', 'Sunny', 1); -- John is in HR (department_id 1)

INSERT INTO employees (first_name, last_name, department_id)
VALUES ('James', 'Smith', 2); -- Jane is in Engineering (department_id 2)

INSERT INTO employees (first_name, last_name, department_id)
VALUES ('Arun', 'Thomas', 1); -- Alex is in HR (department_id 1)


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


