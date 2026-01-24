-- Library Management System --
CREATE DATABASE NAOKO;
USE NAOKO;
-- Creating Branch Table --
CREATE TABLE branch(
branch_id VARCHAR(50) PRIMARY KEY,
manager_id VARCHAR(50),
branch_address VARCHAR(50),
contact_number VARCHAR(50)
);
SELECT * FROM branch;

-- Creating Employees Table --
CREATE TABLE employees(
employee_id VARCHAR(10) PRIMARY KEY,
employee_name VARCHAR(25),
position VARCHAR(15),
salary int,
branch_id VARCHAR(25)
);
SELECT COUNT(*) FROM employees;

-- Creating Book TAble --
CREATE TABLE books(
isbn VARCHAR (20) PRIMARY KEY,
book_tittle VARCHAR(75),
category VARCHAR(10),
rental_pricce FLOAT,
status_book VARCHAR(20),
author VARCHAR(30),
publisher VARCHAR(55)
);
SELECT * FROM books;

-- Creating Table Member's --
CREATE TABLE members(
member_id VARCHAR(20) PRIMARY KEY,
member_name VARCHAR(30),
member_address VARCHAR(50),
reg_date DATE
);
SELECT * FROM members;

-- Creating Issued Status --
CREATE TABLE issued_status(
issued_id VARCHAR(20) PRIMARY KEY,
issued_member_id VARCHAR(20),
issued_book_name VARCHAR(70),
issued_date DATE,
issued_book_isbn VARCHAR(50),
issued_emp_id VARCHAR(50)
);

-- Creating Return Status --
CREATE TABLE return_status(
return_id VARCHAR(10) PRIMARY KEY,
issued_id VARCHAR(10),
return_book_name VARCHAR(70),
return_date DATE,
return_book_isbn VARCHAR(20)
);
SELECT * FROM return_status;

-- Foreign Key's Members --
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members (member_id);

-- Foreign Key's Books --
ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books (isbn);

-- Foreign Key's Employee's --
ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees (employee_id);

-- Other Foreign Key's --
ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch (branch_id);

-- Return Status Foreign key --
ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status (issued_id);






-- Fixing --
SHOW TABLE STATUS WHERE Name = 'employees';
SHOW INDEX FROM employees;
ALTER TABLE employees
ADD PRIMARY KEY (employee_id);



ALTER TABLE issued_status
MODIFY issued_book_isbn VARCHAR(20);

SELECT issued_book_isbn
FROM issued_status
WHERE issued_book_isbn IS NOT NULL
AND issued_book_isbn NOT IN (
    SELECT isbn FROM books
);
INSERT INTO books (isbn)
SELECT DISTINCT issued_book_isbn
FROM issued_status
WHERE issued_book_isbn NOT IN (
    SELECT isbn FROM books
);
ALTER TABLE issued_status
MODIFY issued_emp_id VARCHAR(10);

SELECT issued_id
FROM return_status
WHERE issued_id NOT IN (
    SELECT issued_id FROM issued_status
);

INSERT INTO issued_status (issued_id)
SELECT DISTINCT issued_id
FROM return_status
WHERE issued_id NOT IN (
    SELECT issued_id FROM issued_status
);
DESC issued_status;
DESC return_status;

ALTER TABLE return_status
MODIFY issued_id VARCHAR(20);

ALTER TABLE issued_status ENGINE=InnoDB;
ALTER TABLE return_status ENGINE=InnoDB;



-- My Own Querries About This Project -- 
-- 1. CHECK ISSUED BOOK DETAILS (MOST IMPORTANT)
SELECT 
    i.issued_id,
    m.member_name,
    b.book_tittle,
    b.isbn,
    e.employee_name,
    i.issued_date
FROM issued_status i
JOIN members m ON i.issued_member_id = m.member_id
JOIN books b ON i.issued_book_isbn = b.isbn
JOIN employees e ON i.issued_emp_id = e.employee_id;

-- 2. CHECK RETURNED BOOK DETAILS
SELECT
    r.return_id,
    r.return_date,
    i.issued_id,
    b.book_tittle,
    b.isbn
FROM return_status r
JOIN issued_status i ON r.issued_id = i.issued_id
JOIN books b ON r.return_book_isbn = b.isbn;

-- 3. CHECK EMPLOYEES WITH THEIR BRANCH
SELECT
    e.employee_id,
    e.employee_name,
    e.position,
    b.branch_address,
    b.contact_number
FROM employees e
JOIN branch b ON e.branch_id = b.branch_id;

-- 4. Check Branch Manager
SELECT
    b.branch_id,
    e.employee_name AS manager_name,
    b.branch_address
FROM branch b
JOIN employees e ON b.manager_id = e.employee_id;

 -- 5. FULL SYSTEM VIEW (ONE MASTER QUERY)
 SELECT
    i.issued_id,
    m.member_name,
    b.book_tittle,
    e.employee_name AS issued_by,
    br.branch_address,
    i.issued_date,
    r.return_date
FROM issued_status i
JOIN members m ON i.issued_member_id = m.member_id
JOIN books b ON i.issued_book_isbn = b.isbn
JOIN employees e ON i.issued_emp_id = e.employee_id
JOIN branch br ON e.branch_id = br.branch_id
LEFT JOIN return_status r ON i.issued_id = r.issued_id;

-- 6.FIND ISSUED BUT NOT RETURNED BOOKS (VERY IMPORTANT)
SELECT
    i.issued_id,
    m.member_name,
    b.book_tittle,
    i.issued_date
FROM issued_status i
JOIN members m ON i.issued_member_id = m.member_id
JOIN books b ON i.issued_book_isbn = b.isbn
LEFT JOIN return_status r ON i.issued_id = r.issued_id
WHERE r.return_id IS NULL;

SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM books;
SELECT * FROM members;
SELECT * FROM issued_status;
SELECT * FROM return_status;



-- PROJECT TASK --



-- 1. Create a New Book Record -- "978-1-60129-456-2", 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')
INSERT INTO books (isbn, book_tittle, category, rental_pricce,status_book, author, publisher)
VALUES( "978-1-60129-456-2", 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');

SELECT * FROM 
books
WHERE author = 'Harper Lee';
-- 2. Update Any Member Address
SELECT * FROM members;
UPDATE members
SET member_address = 'jaganpur'
WHERE member_id = 'C101';

-- 3. Objective: Delete the record with issued_id = 'IS104' from the issued_status table

SELECT * FROM issued_status;

DELETE FROM issued_status
WHERE issued_id = 'IS121';

DELETE FROM issued_status
WHERE issued_id = 'IS103';

-- 4. Task 4: Retrieve All Books Issued by a Specific Employee -- Objective: Select all books issued by the employee with emp_id = 'E101'

SELECT *
FROM issued_status 
WHERE issued_emp_id = 'E107';

-- Task 5: List Members Who Have Issued More Than One Book -- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT * FROM issued_status;

SELECT 
    issued_emp_id,
    COUNT(issued_id) AS total_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;

-- 6. 3. CTAS (Create Table As Select) Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results – each book and total book_issued_cnt
CREATE TABLE issued_count
As
SELECT 
    b.isbn,
    b.book_tittle,

    COUNT(ist.issued_id) AS no_issued
FROM books AS b
JOIN issued_status AS ist
    ON ist.issued_book_isbn = b.isbn
GROUP BY 
    b.isbn,
    b.book_tittle;


DESC books;


SELECT * FROM issued_count;


-- 7. REtrive All Book From A Category

SELECT * FROM books
WHERE category = 'classic';

-- 8. Find The Total Rental Amount From Each Category

SELECT 
		category,
SUM(rental_pricce) As Total_pay
FROM books
GROUP BY category;

SELECT 
    b.category,
    SUM(b.rental_pricce) AS total_rental_amount
FROM books AS b
JOIN issued_status AS ist
    ON ist.issued_book_isbn = b.isbn
GROUP BY 
    b.category;


-- 9. List Members Who Registered in the Last 180 Days

INSERT INTO members (member_id, member_name, member_address, reg_date)
VALUES
('C145', 'sam', '145 Main St', '2024-06-01'),
('C178', 'john', '133 Main St', '2024-05-01');

SELECT 
    member_id,
    member_name,
    member_address,
    reg_date
FROM members
WHERE reg_date BETWEEN '2024-01-01' AND '2024-12-31';


SELECT * FROM members;


-- 10. List employees with their branch manager’s name and branch details

SELECT 
    e.employee_id,
    e.employee_name,            -- fixed column name
    e.position,
    br.branch_id,
    br.branch_address,
    br.contact_number,
    m.employee_name AS branch_manager
FROM employees AS e
JOIN branch AS br
    ON e.branch_id = br.branch_id
LEFT JOIN employees AS m
    ON br.manager_id = m.employee_id;
    
    
-- Task 11: Create a Table of Books with Rental Price Above a Certain Threshold 7USD:

CREATE TABLE books_price_greater_than_seven
AS
SELECT * FROM Books
WHERE rental_pricce > 7;

SELECT * FROM
books_price_greater_than_seven;

-- Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
    ist.issued_id,
    ist.issued_member_id,
    ist.issued_book_name,
    ist.issued_book_isbn,
    ist.issued_date,
    ist.issued_emp_id
FROM issued_status AS ist
LEFT JOIN return_status AS rs
    ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;











