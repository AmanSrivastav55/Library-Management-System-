create database library_DB;
 use library_DB ;
 
 create table Author ( Author_Id int primary key Auto_Increment,
					   Author_Name varchar(100) not null);

CREATE TABLE Categories (   CategoryID INT PRIMARY KEY AUTO_INCREMENT,
							CategoryName VARCHAR(100) NOT NULL
																	);                       
 create table Books( Book_Id int primary key Auto_increment, 
					 Title varchar(150) not null,
                     Author_Id int,
                     Category_Id int ,
                     Availability ENUM('Available','Borrowed') DEFAULT 'Available',
					 FOREIGN KEY (Author_Id) REFERENCES Author(Author_Id),
					 FOREIGN KEY (Category_Id) REFERENCES Categories(CategoryId)
																					);
                       
create table Members ( Member_Id int primary key auto_increment , 
					   Member_name varchar (100) not null,
                       Contact_Info varchar(255));
                       

create table Loans ( Loan_Id INT PRIMARY KEY AUTO_INCREMENT,
					 Book_Id INT,
					 Member_Id INT,
					 Issue_Date DATE,
					 Due_Date DATE,
					 Return_Date DATE,
					 FOREIGN KEY (Book_Id) REFERENCES Books(Book_Id),
					 FOREIGN KEY (Member_Id) REFERENCES Members(Member_Id)
																			);
                                                                            
INSERT INTO Author (Author_Name)
VALUES
('Harper Lee'),
('George Orwell'),
('F. Scott Fitzgerald'),
('Jane Austen'),
('J.D. Salinger'),
('Herman Melville'),
('Leo Tolstoy'),
('J.R.R. Tolkien'),
('J.K. Rowling'),
('Paulo Coelho');

select * from Author;

INSERT INTO Categories (CategoryName)
VALUES
('Classic Literature'),
('Dystopian'),
('Romance'),
('Historical'),
('Fantasy'),
('Philosophical Fiction');

select * from categories ;

INSERT INTO Books (Title, Author_Id, Category_Id, Availability)
VALUES
('To Kill a Mockingbird', 1, 1, 'Available'),
('1984', 2, 2, 'Available'),
('The Great Gatsby', 3, 1, 'Borrowed'),
('Pride and Prejudice', 4, 3, 'Available'),
('The Catcher in the Rye', 5, 1, 'Available'),
('Moby-Dick', 6, 4, 'Available'),
('War and Peace', 7, 4, 'Borrowed'),
('The Hobbit', 8, 5, 'Available'),
('Harry Potter and the Sorcerer''s Stone', 9, 5, 'Available'),
('The Alchemist', 10, 6, 'Available');

select * from books;

INSERT INTO Members (Member_Name, Contact_Info)
VALUES
('Alice Johnson', 'alice@example.com'),
('Bob Smith', 'bob@example.com'),
('Charlie Brown', 'charlie@example.com'),
('Diana Prince', 'diana@example.com'),
('Ethan Hunt', 'ethan@example.com');
					
                       
select * from members;

INSERT INTO Loans (Book_Id, Member_Id, Issue_Date, Due_Date, Return_Date)
VALUES
(3, 1, '2026-03-01', '2026-03-15', NULL),   
(7, 2, '2026-03-05', '2026-03-20', NULL);  

select * from Loans;

-- 1.List all available books. 
select Book_Id, Title from Books where Availability = 'Available';

-- 2.Show all members and their contact info.

select member_name, contact_info from members;

-- 3.Display all books written by 'George Orwell'. 

SELECT b.Title
FROM Books b
JOIN Author a ON b.Author_ID = a.Author_ID
WHERE a.Author_Name = 'George Orwell';

-- 4 List each book with its author and category name.

SELECT b.Book_Id, b.Title, a.Author_Name AS Author, c.CategoryName
FROM Books b
JOIN Author a ON b.Author_ID = a.Author_ID
JOIN Categories c ON b.Category_ID = c.CategoryID;

-- 5. Show which member borrowed 'The Great Gatsby'

SELECT m.Member_Name
FROM Loans l
JOIN Members m ON l.Member_Id = m.Member_Id
JOIN Books b ON l.Book_Id = b.Book_Id
WHERE b.Title = 'The Great Gatsby';

-- 6. Find all books borrowed by 'Alice Johnson'

SELECT b.Title
FROM Loans l
JOIN Members m ON l.Member_Id = m.Member_Id
JOIN Books b ON l.Book_Id = b.Book_Id
WHERE m.Member_Name= 'Alice Johnson' ;

-- 7. Count how many books are in each category

SELECT c.CategoryName, COUNT(*) AS Total_Books
FROM Books b
JOIN Categories c ON b.Category_ID = c.CategoryID
GROUP BY c.CategoryName;

-- 8. Find the total number of books currently borrowed

select count(*) as Borrowed_Book
	from books 
		where Availability = 'Borrowed';

-- 9. Show how many books each author has written

SELECT a.Author_Name AS Author, COUNT(*) AS BooksWritten
FROM Books b
JOIN Author a ON b.Author_ID = a.Author_ID
GROUP BY a.Author_Name;

-- 10. List all loans that are overdue

SELECT m.Member_Name, b.Title, l.Due_Date
FROM Loans l
JOIN Members m ON l.Member_ID = m.Member_ID
JOIN Books b ON l.Book_ID = b.Book_ID
WHERE l.Return_Date IS NULL AND l.Due_Date < CURDATE();

-- 11. Show all books borrowed in March 2026

SELECT b.Title, l.Issue_Date
FROM Loans l
JOIN Books b ON l.Book_ID = b.Book_ID
WHERE YEAR(l.Issue_Date) = 2026;

-- 12. Find members who returned books late

SELECT m.Member_Name, b.Title, l.Due_Date, l.Return_Date
FROM Loans l
JOIN Members m ON l.Member_ID = m.Member_ID
JOIN Books b ON l.Book_ID = b.Book_ID
WHERE l.Return_Date > l.Due_Date;

-- 13. Top 3 most borrowed books

SELECT b.Title, COUNT(*) AS Times_Borrowed
FROM Loans l
JOIN Books b ON l.Book_ID = b.Book_ID
GROUP BY b.Title
ORDER BY Times_Borrowed DESC
LIMIT 3;

-- 14. Members who borrowed more than 2 books
SELECT m.Name, COUNT(*) AS BooksBorrowed
FROM Loans l
JOIN Members m ON l.MemberID = m.MemberID
GROUP BY m.Name
HAVING COUNT(*) > 2;

-- 15. Books that have never been borrowed

SELECT Book_id,Title
FROM Books
WHERE Book_ID NOT IN (SELECT Book_ID FROM Loans);

-- 16 Add a new author “Mark Twain”
INSERT INTO Author(Author_Name) VALUES ('Mark Twain');

-- 17 - Add a new category “Adventure”
INSERT INTO Categories (CategoryName) VALUES ('Adventure');

-- 18 - Add a new book “Adventures of Huckleberry Finn”

INSERT INTO Books (Title, Author_ID, Category_ID, Availability)
VALUES ('Adventures of Huckleberry Finn', 11, 7, 'Available');

-- 19 Register a new member “Sophia Williams”
INSERT INTO Members (Member_Name, Contact_Info)
VALUES ('Sophia Williams', 'sophia@example.com');
								 
-- 20 - Update availability of “The Great Gatsby”

UPDATE Books SET Availability = 'Available'
WHERE Title = 'The Great Gatsby';

-- 21 Change contact info of “Bob Smith”

UPDATE Members SET Contact_Info = 'bob.smith@newmail.com'
WHERE Member_Name = 'Bob Smith';

-- 22  Extend due date of Loan_ID = 1 by 7 days

UPDATE Loans SET Due_Date = DATE_ADD(Due_Date, INTERVAL 7 DAY)
WHERE Loan_ID = 1;

--  23 - Delete book “Moby-Dick”
DELETE FROM Books WHERE Title = 'Moby-Dick';

-- 24  Remove member “Charlie Brown”

DELETE FROM Members WHERE Member_Name = 'Charlie Brown';

-- 25 - Delete all returned loans
DELETE FROM Loans WHERE Return_Date IS NOT NULL;


-- 26 Issue a new loan (Sophia borrows Harry Potter)

INSERT INTO Loans (Book_ID, Member_ID, Issue_Date, Due_Date, Return_Date)
VALUES (9, 6, CURDATE(), DATE_ADD(CURDATE(), INTERVAL 14 DAY), NULL);

UPDATE Books SET Availability = 'Borrowed'
WHERE Book_ID = 9;


-- 27 Return a book (Alice returns The Great Gatsby)

UPDATE Loans
SET Return_Date = CURDATE()
WHERE Book_ID = 3 AND Member_ID = 1 ;

UPDATE Books SET Availability = 'Available'
WHERE Book_ID = 3;

select * from author;
select * from books;
select * from categories;
select * from loans;
select * from members;






