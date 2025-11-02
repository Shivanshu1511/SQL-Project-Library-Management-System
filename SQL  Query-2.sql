-- Advance SQL query 
USE sql_project2_db;

-- Identify Members with Overdue Books
-- Write a query to identify members who have overdue books (assume a 500-day return period). Display the member's_id, member's name, book title, issue date, and days overdue.
Select 
m.member_id,
m.member_name,
iss.issued_book_name,
iss.issued_date,
  DATEDIFF(CURRENT_DATE, iss.issued_date) as over_dues_days
FROM issued_status as iss
JOIN 
members as m
    ON m.member_id = iss.issued_member_id
    Where DATEDIFF(CURRENT_DATE, iss.issued_date)>500
    order by DATEDIFF(CURRENT_DATE, iss.issued_date) ;


