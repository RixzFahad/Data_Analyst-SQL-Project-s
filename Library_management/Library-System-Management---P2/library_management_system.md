# 📚 Library Management System - Project Documentation

## **Database: NAOKO**

```sql
CREATE DATABASE NAOKO;
USE NAOKO;
```

This project manages a **library system** including **branches, employees, books, members, book issuance, and returns**.

---

## **1. Tables Creation**

### **1.1 Branch Table**

```sql
CREATE TABLE branch(
    branch_id VARCHAR(50) PRIMARY KEY,
    manager_id VARCHAR(50),
    branch_address VARCHAR(50),
    contact_number VARCHAR(50)
);
SELECT * FROM branch;
```

- Stores information about **library branches**.
- `manager_id` references an employee as the **branch manager**.

---

### **1.2 Employees Table**

```sql
CREATE TABLE employees(
    employee_id VARCHAR(10) PRIMARY KEY,
    employee_name VARCHAR(25),
    position VARCHAR(15),
    salary INT,
    branch_id VARCHAR(25)
);
SELECT COUNT(*) FROM employees;
```

- Stores **employee details** and their **assigned branch**.
- Foreign key `branch_id` links to `branch`.

---

### **1.3 Books Table**

```sql
CREATE TABLE books(
    isbn VARCHAR(20) PRIMARY KEY,
    book_tittle VARCHAR(75),
    category VARCHAR(10),
    rental_pricce FLOAT,
    status_book VARCHAR(20),
    author VARCHAR(30),
    publisher VARCHAR(55)
);
SELECT * FROM books;
```

- Stores book metadata: **title, category, rental price, status, author, publisher**.

---

### **1.4 Members Table**

```sql
CREATE TABLE members(
    member_id VARCHAR(20) PRIMARY KEY,
    member_name VARCHAR(30),
    member_address VARCHAR(50),
    reg_date DATE
);
SELECT * FROM members;
```

- Stores **library member information**.
- Tracks registration date.

---

### **1.5 Issued Status Table**

```sql
CREATE TABLE issued_status(
    issued_id VARCHAR(20) PRIMARY KEY,
    issued_member_id VARCHAR(20),
    issued_book_name VARCHAR(70),
    issued_date DATE,
    issued_book_isbn VARCHAR(50),
    issued_emp_id VARCHAR(50)
);
```

- Tracks books **issued to members**.
- References **members, books, and employees** via foreign keys.

---

### **1.6 Return Status Table**

```sql
CREATE TABLE return_status(
    return_id VARCHAR(10) PRIMARY KEY,
    issued_id VARCHAR(10),
    return_book_name VARCHAR(70),
    return_date DATE,
    return_book_isbn VARCHAR(20)
);
SELECT * FROM return_status;
```

- Tracks **returned books**.
- Links to `issued_status` using `issued_id`.

---

## **2. Foreign Key Constraints**

```sql
ALTER TABLE issued_status
ADD CONSTRAINT fk_members
FOREIGN KEY (issued_member_id)
REFERENCES members (member_id);

ALTER TABLE issued_status
ADD CONSTRAINT fk_books
FOREIGN KEY (issued_book_isbn)
REFERENCES books (isbn);

ALTER TABLE issued_status
ADD CONSTRAINT fk_employees
FOREIGN KEY (issued_emp_id)
REFERENCES employees (employee_id);

ALTER TABLE employees
ADD CONSTRAINT fk_branch
FOREIGN KEY (branch_id)
REFERENCES branch (branch_id);

ALTER TABLE return_status
ADD CONSTRAINT fk_issued_status
FOREIGN KEY (issued_id)
REFERENCES issued_status (issued_id);
```

- Ensures **data integrity** between tables.

---

## **3. Data Fixes & Adjustments**

```sql
ALTER TABLE issued_status
MODIFY issued_book_isbn VARCHAR(20);

ALTER TABLE issued_status
MODIFY issued_emp_id VARCHAR(10);

ALTER TABLE return_status
MODIFY issued_id VARCHAR(20);

ALTER TABLE issued_status ENGINE=InnoDB;
ALTER TABLE return_status ENGINE=InnoDB;
```

- Ensures **column size matches references** and **InnoDB supports foreign keys**.

---

## **4. Queries for System Insights**

### **4.1 Check Issued Book Details**

```sql
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
```

- Lists all **books currently issued**, including **member and employee details**.

---

### **4.2 Check Returned Book Details**

```sql
SELECT
    r.return_id,
    r.return_date,
    i.issued_id,
    b.book_tittle,
    b.isbn
FROM return_status r
JOIN issued_status i ON r.issued_id = i.issued_id
JOIN books b ON r.return_book_isbn = b.isbn;
```

- Lists all **returned books** with issued book reference.

---

### **4.3 Employees with Branch Details**

```sql
SELECT
    e.employee_id,
    e.employee_name,
    e.position,
    b.branch_address,
    b.contact_number
FROM employees e
JOIN branch b ON e.branch_id = b.branch_id;
```

- Shows **employee and branch info**.

---

### **4.4 Branch Manager Details**

```sql
SELECT
    b.branch_id,
    e.employee_name AS manager_name,
    b.branch_address
FROM branch b
JOIN employees e ON b.manager_id = e.employee_id;
```

- Retrieves **branch manager names** with branch addresses.

---

### **4.5 Full System View (Issued + Returned + Branch)**

```sql
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
```

- Comprehensive view for **issued and returned books** across branches.

---

### **4.6 Books Issued but Not Yet Returned**

```sql
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
```

- Shows books **still with members** (not returned).

---

## **5. Project Tasks & Solutions**

### **5.1 Add New Book**

```sql
INSERT INTO books (isbn, book_tittle, category, rental_pricce, status_book, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
```

- Added **new book record**.

---

### **5.2 Update Member Address**

```sql
UPDATE members
SET member_address = 'jaganpur'
WHERE member_id = 'C101';
```

- Updates **member address**.

---

### **5.3 Delete Issued Record**

```sql
DELETE FROM issued_status
WHERE issued_id IN ('IS121', 'IS103');
```

- Deletes **specific issued book records**.

---

### **5.4 Books Issued by Specific Employee**

```sql
SELECT *
FROM issued_status
WHERE issued_emp_id = 'E107';
```

- Lists books **issued by employee E107**.

---

### **5.5 Members Who Issued More Than One Book**

```sql
SELECT
    issued_emp_id,
    COUNT(issued_id) AS total_issued
FROM issued_status
GROUP BY issued_emp_id
HAVING COUNT(issued_id) > 1;
```

- Finds **employees issuing more than one book**.

---

### **5.6 Summary Table (CTAS)**

```sql
CREATE TABLE issued_count AS
SELECT
    b.isbn,
    b.book_tittle,
    COUNT(ist.issued_id) AS no_issued
FROM books AS b
JOIN issued_status AS ist
    ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_tittle;
```

- Creates **summary of books and issue counts**.

---

### **5.7 Retrieve Books by Category**

```sql
SELECT * FROM books
WHERE category = 'classic';
```

---

### **5.8 Total Rental Amount per Category**

```sql
SELECT
    b.category,
    SUM(b.rental_pricce) AS total_rental_amount
FROM books AS b
JOIN issued_status AS ist
    ON ist.issued_book_isbn = b.isbn
GROUP BY b.category;
```

---

### **5.9 Members Registered in Last 180 Days**

```sql
SELECT
    member_id,
    member_name,
    member_address,
    reg_date
FROM members
WHERE reg_date BETWEEN '2024-01-01' AND '2024-12-31';
```

---

### **5.10 Employees with Branch Manager Details**

```sql
SELECT
    e.employee_id,
    e.employee_name,
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
```

---

### **5.11 Books with Rental Price Above 7 USD**

```sql
CREATE TABLE books_price_greater_than_seven AS
SELECT * FROM books
WHERE rental_pricce > 7;

SELECT * FROM books_price_greater_than_seven;
```

---

### **5.12 Retrieve List of Books Not Yet Returned**

```sql
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
```

---

## **6. Observations & Knowledge Points**

1. **Database Normalization:** Separate tables for branches, employees, members, books, issued, and returned books.
2. **Foreign Keys:** Maintain **data integrity**.
3. **LEFT JOIN Usage:** Identify **books not yet returned**.
4. **CTAS (Create Table As Select):** Useful for **summary tables and reports**.
5. **Practical Applications:** Suitable for **library dashboards**, branch reports, and member tracking.

