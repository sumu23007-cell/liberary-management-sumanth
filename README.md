# Library Management System

**Project Type:** DBMS Mini Project  
**Course:** Bachelor of Computer Applications (BCA)  
**Database:** MySQL  
**Database Name:**  librarydb   
**Software:** MySQL Workbench  

## 1. Introduction

The Library Management System is a mini project developed using MySQL. It is designed to maintain records of library members, available books and book borrowing activities.

The main objective of this project is to understand how databases work and how SQL queries can be used to retrieve and manage information.

Using this database, we can identify popular books, check books that have not been returned, calculate late return fines and analyse borrowing activities.

## 2. Database Tables

The database consists of three tables.

### Members

Stores information about students and faculty members.

| Column | Description |
|---|---|
| member_id | Primary key |
| member_name | Name of the member |
| member_type | Student or Faculty |
| joined_date | Date of joining |

### Books

Stores information about the books available in the library.

| Column | Description |
|---|---|
| book_id | Primary key |
| title | Book name |
| author | Author name |
| category | Book category |
| price | Price of the book |
| copies_available | Number of available copies |

### Issues

Stores information about books borrowed by members.

| Column | Description |
|---|---|
| issue_id | Primary key |
| member_id | Foreign key referencing members |
| book_id | Foreign key referencing books |
| issue_date | Date when the book was issued |
| due_date | Expected return date |
| return_date | Actual return date |

## 3. Database Relationships

The database contains two one-to-many relationships.

- One member can have multiple issue records.
- One book can have multiple issue records.
- The issues table connects members and books.

The  issues  table contains foreign keys to maintain these relationships.

## 4. Sample Data

The following sample records are inserted into the database:

| Table | Total Records |
|---|---:|
| Members | 12 |
| Books | 15 |
| Issues | 32 |

The database includes both Student and Faculty members, along with books from different categories such as Programming, Database, Networking, Fiction, Science and Mathematics.

## 5. Fine Calculation

The library follows a fine rule of ₹2 for every day a book is returned late.

**Fine = Late Days × ₹2**

- Student borrowing period: 14 days.
- Faculty borrowing period: 30 days.
- Books returned after the due date are considered late.
- Books returned on the due date have no fine.
- Books with a NULL return date are considered currently issued.

## 6. SQL Concepts Used

The following SQL concepts are used in this project:

1. Database and table creation
2. Primary keys and foreign keys
3. SELECT and WHERE statements
4. Aggregate functions (COUNT and SUM)
5. GROUP BY and HAVING
6. ORDER BY and LIMIT
7. INNER JOIN and LEFT JOIN
8. Subqueries
9. NULL value handling
10. DATEDIFF function
11. Window functions using RANK()
12. Stored procedures
13. Triggers

## 7. Project Questions

The project consists of 15 questions divided into four phases.

**Phase 1 -  Database Basics**
- C1: Draw the Entity Relationship Diagram.
- C2: Find the total number of members, books and issue records.

**Phase 2 -  SQL Queries**
- C3: Find the number of titles and available copies in each category.
- C4: Find the top 5 most borrowed books.
- C5: Identify members who have never borrowed a book.
- C6: Display currently issued books with member names and due dates.
- C7: Find late returns and calculate their fines.
- C8: Calculate the total fine for each member.
- C9: Compare borrowing activities between students and faculty.
- C10: Rank members according to the number of books borrowed.
- C11: Identify the most popular book category.
- C12: Find books with zero available copies and pending issues.

**Phase 3 -  Database Automation**
- C13: Create a stored procedure to display a member's borrowing history.
- C14: Create a trigger to automatically reduce available copies when a new issue is inserted.

**Phase 4 -  Conclusion**
- C15: Suggest improvements to library management based on the query results.

## 8. Files Included

| File | Description |
|---|---|
|  schema.sql  | Creates the database and tables. |
|  insert_data.sql  | Inserts sample records into the database. |
|  queries.sql  | Contains SQL queries for C2 to C14. |
|  notes.md  | Contains query summaries and conclusions. |
|  erd.jpg  | Entity Relationship Diagram. |

## 9. How to Run the Project

1. Open MySQL Workbench.
2. Execute  schema.sql  to create the database and tables.
3. Execute  insert_data.sql  to insert the sample records.
4. Select the  librarydb  database.
5. Execute the queries from  queries.sql .
6. Check the output for each question.

To verify the records, run:

-->  sql
USE librarydb;

SELECT COUNT(*) FROM members;
SELECT COUNT(*) FROM books;
SELECT COUNT(*) FROM issues;
   

Expected output:

- Members: 12
- Books: 15
- Issues: 32

## 10. Learning Outcomes

Through this project, I learned how to create and manage relational databases using MySQL.

I gained practical knowledge of SQL queries, joins, aggregate functions, subqueries and window functions. I also learned how stored procedures and triggers can be used to automate database operations.

This project helped me understand how database concepts can be applied to a real-world library management system.

## 11. Conclusion

The Library Management System demonstrates how MySQL can be used to maintain and analyse library records. The queries help identify popular books, members with pending returns and late return fines.

Overall, this mini project helped me improve my practical understanding of database management and SQL.