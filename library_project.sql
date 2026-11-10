CREATE DATABASE librarydb;
USE librarydb;

CREATE TABLE members (
    member_id   INT          PRIMARY KEY AUTO_INCREMENT,
    member_name VARCHAR(100) NOT NULL,
    member_type VARCHAR(10)  NOT NULL,
    joined_date DATE         NOT NULL
);

CREATE TABLE books (
    book_id          INT          PRIMARY KEY AUTO_INCREMENT,
    title            VARCHAR(150) NOT NULL,
    author           VARCHAR(100) NOT NULL,
    category         VARCHAR(50)  NOT NULL,
    price            DECIMAL(8,2) NOT NULL,
    copies_available INT          NOT NULL DEFAULT 1
);

CREATE TABLE issues (
    issue_id    INT  PRIMARY KEY AUTO_INCREMENT,
    member_id   INT  NOT NULL,
    book_id     INT  NOT NULL,
    issue_date  DATE NOT NULL,
    due_date    DATE NOT NULL,
    return_date DATE NULL,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id)   REFERENCES books(book_id)
);



-- ---------- members (6) ----------
INSERT INTO members (member_id, member_name, member_type, joined_date) VALUES
(1,'Aarav Sharma','Student','2025-06-10'),
(2,'Diya Patel','Student','2025-07-02'),
(3,'Rohan Mehta','Student','2025-08-15'),
(4,'Ananya Iyer','Faculty','2026-01-20'),
(5,'Kabir Singh','Student','2026-03-05'),
(6,'Meera Nair','Faculty','2026-09-01');

-- ---------- books (10) ----------
INSERT INTO books (book_id, title, author, category, price, copies_available) VALUES
( 1,'Database System Concepts','Silberschatz','Computer Science',650,4),
( 2,'SQL Fundamentals','John Viescas','Computer Science',480,4),
( 3,'Clean Code','Robert Martin','Computer Science',520,3),
( 4,'Operating System Concepts','Silberschatz','Computer Science',590,0),
( 5,'Discrete Mathematics','Kenneth Rosen','Mathematics',410,2),
( 6,'Linear Algebra','Gilbert Strang','Mathematics',380,2),
( 7,'Indian History','Romila Thapar','History',300,1),
( 8,'World War II','Antony Beevor','History',350,0),
( 9,'Fundamentals of Physics','Halliday','Science',620,2),
(10,'Organic Chemistry','Paula Bruice','Science',700,0);

-- ---------- issues (10) ----------
INSERT INTO issues (issue_id, member_id, book_id, issue_date, due_date, return_date) VALUES
( 1,1,1,'2026-08-01','2026-08-15','2026-08-20'),  -- late 5
( 2,5,1,'2026-09-01','2026-09-15','2026-09-20'),  -- late 5
( 3,3,1,'2026-10-20','2026-11-03',NULL),          -- open, overdue 7
( 4,4,4,'2026-10-12','2026-10-26',NULL),          -- open, overdue 15
( 5,2,2,'2026-09-10','2026-09-24','2026-09-30'),  -- late 6
( 6,1,2,'2026-08-15','2026-08-29','2026-08-29'),  -- on time (boundary)
( 7,1,7,'2026-09-20','2026-10-04',NULL),          -- open, overdue 37
( 8,5,8,'2026-11-05','2026-11-19',NULL),          -- open, not due
( 9,2,5,'2026-11-01','2026-11-15',NULL),          -- open, not due
(10,4,9,'2026-10-15','2026-10-29','2026-11-02');  -- late 4

-- Phase 1 — Know your data

-- C2. How many members, books and issue records are there?
SELECT
    (select count(*) from members)as MemberCount,
    (select count(*) from books)  as BooksCount,
    (select count(*) from issues) as IssuesCount;

-- Phase 2 — Business questions

-- C3. How many titles and total copies are there in each category?
SELECT category,count(title) as total_titles,sum(copies_available) as total_copies from books group by category;

-- C4. What are the top 5 most borrowed books?
SELECT b.title, COUNT(i.issue_id) AS times_borrowed
FROM books b
INNER JOIN issues i ON b.book_id = i.book_id
GROUP BY b.book_id, b.title
ORDER BY times_borrowed DESC
LIMIT 5;

-- C5. Which members have never borrowed a book?
SELECT m.member_name, m.member_type
FROM members m
LEFT JOIN issues i ON m.member_id = i.member_id
WHERE i.issue_id IS NULL;

-- C6. Which books are currently issued (not returned)?
SELECT m.member_name, b.title, i.due_date
FROM issues i
INNER JOIN members m ON i.member_id = m.member_id
INNER JOIN books b ON i.book_id = b.book_id
WHERE i.return_date IS NULL;

-- C7. Which books were returned late? Calculate days late and fine.
SELECT m.member_name, b.title, 
       DATEDIFF(i.return_date, i.due_date) AS days_late,
       DATEDIFF(i.return_date, i.due_date) * 2 AS fine
FROM issues i
INNER JOIN members m ON i.member_id = m.member_id
INNER JOIN books b ON i.book_id = b.book_id
WHERE i.return_date > i.due_date;

-- C8. What is the total fine per member?
SELECT m.member_name, 
       SUM(DATEDIFF(i.return_date, i.due_date) * 2) AS total_fine
FROM issues i
INNER JOIN members m ON i.member_id = m.member_id
WHERE i.return_date > i.due_date
GROUP BY m.member_id, m.member_name
HAVING SUM(DATEDIFF(i.return_date, i.due_date) * 2) > 0;

-- C9. Compare Student vs Faculty usage.
SELECT m.member_type, COUNT(i.issue_id) AS total_borrowed
FROM members m
INNER JOIN issues i ON m.member_id = i.member_id
GROUP BY m.member_type;

-- C10. Rank the members by the number of books they borrowed, using RANK().
SELECT m.member_name, 
       COUNT(i.issue_id) AS books_borrowed,
       RANK() OVER (ORDER BY COUNT(i.issue_id) DESC) AS rank_number
FROM members m
LEFT JOIN issues i ON m.member_id = i.member_id
GROUP BY m.member_id, m.member_name;

-- C11. Which category is the most popular among members?
SELECT b.category, COUNT(i.issue_id) AS total_issues
FROM issues i
INNER JOIN books b ON i.book_id = b.book_id
GROUP BY b.category
ORDER BY total_issues DESC;

-- C12. Which books have zero copies available and also have pending (not returned) issues? Use a subquery.
SELECT b.book_id, b.title 
FROM books b
WHERE b.copies_available = 0 
  AND EXISTS (
      SELECT 1 
      FROM issues i 
      WHERE i.book_id = b.book_id 
        AND i.return_date IS NULL
  );


-- Phase 3 — Automate

-- C13. Write a stored procedure member_history(member_id).
DELIMITER //
CREATE PROCEDURE member_history(IN p_member_id INT)
BEGIN
    SELECT b.title, i.issue_date, i.return_date
    FROM issues i
    INNER JOIN books b ON i.book_id = b.book_id
    WHERE i.member_id = p_member_id;
END //
DELIMITER ;

-- Test:
CALL member_history(1);

-- C14. Create a trigger: when a row is inserted in a copy of the issues table, reduce copies_available by 1.
-- Make copies of the tables first
CREATE TABLE books_copy AS SELECT * FROM books;
CREATE TABLE issues_copy AS SELECT * FROM issues;

-- Create the trigger
DELIMITER //
CREATE TRIGGER trg_issues_insert
AFTER INSERT ON issues_copy
FOR EACH ROW
BEGIN
    UPDATE books_copy 
    SET copies_available = copies_available - 1 
    WHERE book_id = NEW.book_id;
END //
DELIMITER ;

-- Test: Give Book 6 (which has 2 copies) to member 3
INSERT INTO issues_copy (issue_id, member_id, book_id, issue_date, due_date, return_date) 
VALUES (101, 3, 6, '2026-11-10', '2026-11-24', NULL);

-- Check the result:
SELECT book_id, title, copies_available FROM books_copy WHERE book_id = 6;