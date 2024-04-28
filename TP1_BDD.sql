-- On créée le Schema 

-- On créée les Tables 
 CREATE TABLE LibraryCatalog(
   BookID int AUTO_INCREMENT,
   Title VARCHAR(50),
   Years INT,
   PRIMARY KEY(BookID)
);

CREATE TABLE Author(
   AuthorID VARCHAR(50),
   AuthorsName VARCHAR(50),
   PRIMARY KEY(AuthorID)
);

CREATE TABLE Borrower(
   BorrowerID int AUTO_INCREMENT,
   BorrowerName VARCHAR(50),
   BorrowerEmail VARCHAR(50),
   PRIMARY KEY(BorrowerID)
);

CREATE TABLE Genre_(
   GenreID VARCHAR(50) NOT NULL,
   GenreDescription VARCHAR(50),
   GenreTypicalAgeRange VARCHAR(50),
   PRIMARY KEY(GenreID)
);

CREATE TABLE Loan(
   LoanID INT AUTO_INCREMENT,
   LoanDate DATE,
   ReturnDate DATE,
   BorrowerID INT NOT NULL,
   BookID INT NOT NULL,
   PRIMARY KEY(LoanID),
   UNIQUE(BookID),
   FOREIGN KEY(BorrowerID) REFERENCES Borrower(BorrowerID),
   FOREIGN KEY(BookID) REFERENCES LibraryCatalog(BookID)
);

CREATE TABLE Writes(
   BookID INT,
   AuthorID VARCHAR(50),
   OrdAuthor INT,
   PRIMARY KEY(BookID, AuthorID),
   FOREIGN KEY(BookID) REFERENCES LibraryCatalog(BookID),
   FOREIGN KEY(AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE Appartient(
   BookID INT,
   GenreID VARCHAR(50),
   PRIMARY KEY(BookID, GenreID),
   FOREIGN KEY(BookID) REFERENCES LibraryCatalog(BookID),
   FOREIGN KEY(GenreID) REFERENCES Genre_(GenreID)
);

-- Insertions d'éléments dans les tables 

-- Insertion dans LibraryCatalog
INSERT INTO LibraryCatalog (Title, Years) VALUES
('Harry Potter and the Philosopher''s Stone', 1997),
('To Kill a Mockingbird', 1960),
('1984', 1949);

-- Insertion dans Author
INSERT INTO Author (AuthorID, AuthorsName) VALUES
('JKR', 'J.K. Rowling'),
('Harper', 'Harper Lee'),
('Orwell', 'George Orwell');

-- Insertion dans Borrower
INSERT INTO Borrower (BorrowerName, BorrowerEmail) VALUES
('John Doe', 'john.doe@example.com'),
('Jane Smith', 'jane.smith@example.com');

-- Insertion dans  Genre_
INSERT INTO Genre_ (GenreID, GenreDescription, GenreTypicalAgeRange) VALUES
('FIC', 'Fiction', 'Adult'),
('CLAS', 'Classics', 'Adult'),
('DYS', 'Dystopian', 'Young Adult');

-- Insertion  dans Loan
INSERT INTO Loan (LoanDate, ReturnDate, BorrowerID, BookID) VALUES
('2024-04-01', '2024-04-15', 1, 1),
('2024-03-15', '2024-04-10', 2, 2),
('2024-04-10', '2024-04-24', 1, 3);

-- Insertion  dans  Writes
INSERT INTO Writes (BookID, AuthorID, OrdAuthor) VALUES
(1, 'JKR', 1),
(2, 'Harper', 1),
(3, 'Orwell', 1);

-- Insertion dans Appartient
INSERT INTO Appartient (BookID, GenreID) VALUES
(1, 'FIC'),
(2, 'CLAS'),
(3, 'DYS');

-- On effectue des requetes pour verifier les eventuels anomalies et redondances 

-- On vérifie qu'il n'y a pas de Doublons dans les auteurs
SELECT AuthorID, COUNT(*) AS Count
FROM Author
GROUP BY AuthorID
HAVING COUNT(*) > 1;

--On verifie que chaque livre est bien associé a un auteur
SELECT lc.Title
FROM LibraryCatalog lc
LEFT JOIN Writes w ON lc.BookID = w.BookID
WHERE w.BookID IS NULL;


--On verifie que les prets ne peuvent pas etre realiser sans livre
SELECT l.LoanID
FROM Loan l
LEFT JOIN LibraryCatalog lc ON l.BookID = lc.BookID
WHERE lc.BookID IS NULL;

--On verifie que les prets ne peuvent pas etre realisé sans emprunteur
SELECT l.LoanID
FROM Loan l
LEFT JOIN Borrower b ON l.BorrowerID = b.BorrowerID
WHERE b.BorrowerID IS NULL;

--On liste les emprunteurs qui ont du retard
SELECT DISTINCT BorrowerName
FROM Borrower b
JOIN Loan l ON b.BorrowerID = l.BorrowerID
WHERE ReturnDate < LoanDate;

--On liste les livres écrits pour un auteur choisit
SELECT Title
FROM LibraryCatalog lc
JOIN Writes w ON lc.BookID = w.BookID
JOIN Author a ON w.AuthorID = a.AuthorID
WHERE AuthorsName = 'J.K. Rowling';
