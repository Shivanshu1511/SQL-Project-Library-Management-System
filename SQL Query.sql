-- SQL quries 
-- Create Database 
create database sql_project2_db;
-- Create table for branches, employees, members, books, issued status, and return status. Each table includes relevant columns and relationships
use sql_project2_db;
Create table branches(
branch_id varchar(10) primary key, 
manager_id varchar(10),
branch_address varchar(30),
contact_no varchar(15)
);
desc branches;
-- create employee table 
Create table employees(
emp_id	varchar(10) primary key ,
emp_name varchar(25),
position varchar(15),
salary int, 
branch_id varchar(15),
FOREIGN KEY (branch_id) REFERENCES  branches(branch_id)
);
Desc employees;

-- create table members
create table members(
member_id varchar(15) Primary key, 
member_name	 varchar(30),
member_address varchar(50),
reg_date date
);
Desc members;

-- create table books
create table books(
isbn VARCHAR(50) PRIMARY KEY,
            book_title VARCHAR(80),
            category VARCHAR(30),
            rental_price DECIMAL(10,2),
            status VARCHAR(10),
            author VARCHAR(30),
            publisher VARCHAR(30)
);
Desc books;
-- create table issued status 
create table issued_status(
  issued_id VARCHAR(10) PRIMARY KEY,
            issued_member_id VARCHAR(30),
            issued_book_name VARCHAR(80),
            issued_date DATE,
            issued_book_isbn VARCHAR(50),
            issued_emp_id VARCHAR(10),
            FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
            FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id),
            FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn) 
);
Desc issued_status;

-- create table return status

Create table return_status(
   return_id VARCHAR(10) PRIMARY KEY,
            issued_id VARCHAR(30),
            return_book_name VARCHAR(80),
            return_date DATE,
            return_book_isbn VARCHAR(50),
            FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);
Desc return_status;

Select * from branches;
Select* from employees;
Select * from books;
Select* from issued_status;
Select* from members;
select *from return_status;

-- CRUD  operations 
-- create new records 
Insert Into books(isbn, book_title,	category, rental_price,	status,	author,	publisher)
values ('978-0-7432-7356-5', 'The Great Gatsby', 'Fiction', 8.50, 'no', 'F. Scott Fitzgerald', 'Charles Scribner\'s Sons');

-- Update an Existing Member's Address

UPDATE members
SET member_address = '125 Oak Street'
WHERE member_id = 'C103'

-- Delete a Record from the Issued Status Table

Delete FROM issued_status
WHERE   issued_id =   'IS121';

-- Retrieve All Books Issued by a Specific Employee
Select * from issued_status 
Where issued_member_id = 'C109';

-- List Members Who Have Issued More Than One Book

Select count(issued_id), issued_member_id from issued_status
group by issued_member_id
having count(issued_id)>=2
order by count(issued_id);

-- CTAS (Create Table As Select)

  -- Create Summary Tables:
  Create table book_issued_cnt as 
  Select  b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
  From issued_status as ist
  join books as b
  ON ist.issued_book_isbn = b.isbn
  Group by b.isbn,b.book_title;
  
  Desc book_issued_cnt;
  
  Select * from book_issued_cnt;
  
-- Retrieve All Books in a Specific Category
select * from books
where category ='Children';

select * from books 
where category = 'Classic';

Select * from books
where category ='Fiction'; 

Select * from books
where category ='Fantasy'; 

Select Count(*) as total_books, category  
from books 
group by category 
order by count(*); 

-- Find Total Rental Income by Category
SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY category;

-- List Members Who Registered in the Last 180 Day
Select * from members 
WHERE reg_date >= CURRENT_DATE - INTERVAL 180 Day ;

-- or use Date_sub function where it's standard Syntax is 
-- *DATE_SUB(date, INTERVAL value unit)*
-- *CURRENT_DATE* built in function in MySQL which return todays date

SELECT * FROM members
WHERE reg_date >= DATE_SUB(CURRENT_DATE, INTERVAL 180 DAY);

-- List Employees with Their Branch Manager's Name and their branch details

SELECT 
    e1.emp_id,
    e1.emp_name,
    e1.position,
    e1.salary,
    b.*,
    e2.emp_name as manager
FROM employees as e1
JOIN 
branch as b
ON e1.branch_id = b.branch_id    
JOIN
employees as e2
ON e2.emp_id = b.manager_id

-- Create a Table of Books with Rental Price Above a Certain Threshold

CREATE TABLE expensive_books AS
SELECT * FROM books
WHERE rental_price > 7.00;

-- Retrieve the List of Books Not Yet Returned
SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;


-- Advanced SQL Operations


