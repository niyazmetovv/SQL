USE lessons;

--1
DROP TABLE IF EXISTS student;

CREATE TABLE student
(
   id INT,
   name VARCHAR(55),
   age INT
);

ALTER TABLE student
ALTER COLUMN id INT NOT NULL;


--2

DROP TABLE IF EXISTS product;
CREATE TABLE product
(
   product_id INT UNIQUE,
   product_name VARCHAR(55),
   price DECIMAL
);

DECLARE @unique_name NVARCHAR(255);

SELECT @unique_name = name
FROM sys.key_constraints
WHERE parent_object_id = OBJECT_ID('product') AND type = 'UQ';

IF @unique_name IS NOT NULL
    EXEC('ALTER TABLE product DROP CONSTRAINT ' + @unique_name);


ALTER TABLE product
ADD CONSTRAINT UQ_product UNIQUE(product_id, product_name);

--3

DROP TABLE IF EXISTS orders;

CREATE TABLE orders
(
    order_id INT PRIMARY KEY,
	  customer_name VARCHAR(55),
	  order_date DATE
);
 
DECLARE @primary_key_name VARCHAR(255);

SELECT @primary_key_name = name
FROM sys.key_constraints
WHERE parent_object_id = OBJECT_ID('orders') and TYPE = 'PK';

IF @primary_key_name IS NOT NULL
    EXEC('ALTER TABLE orders DROP CONSTRAINT ' + @primary_key_name);

ALTER TABLE orders
ADD CONSTRAINT PK_orders PRIMARY KEY(order_id);

--4

DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS category;

CREATE TABLE category
(
   category_id INT PRIMARY KEY,
   category_name VARCHAR(55)
);

DROP TABLE IF EXISTS item;

CREATE TABLE item
(
     item_id INT PRIMARY KEY,
	 item_name VARCHAR(55),
	 category_id INT,
	 CONSTRAINT FK_item  FOREIGN KEY (category_id) REFERENCES category(category_id)
)

ALTER TABLE item
DROP CONSTRAINT FK_item;




ALTER TABLE item
ADD CONSTRAINT FK_item_category FOREIGN KEY (category_id) REFERENCES category(category_id);

--5

DROP TABLE IF EXISTS account;

CREATE TABLE account
(
   account_id INT CONSTRAINT PK_account PRIMARY KEY,
   balance DEC CONSTRAINT CHK_balance CHECK(balance >= 0),
   account_type VARCHAR(255) CONSTRAINT CHK_type CHECK(account_type = 'Saving' OR account_type = 'Checking')
);

ALTER TABLE account DROP CONSTRAINT CHK_balance;
ALTER TABLE account DROP CONSTRAINT CHK_type;

ALTER TABLE account ADD CONSTRAINT CHK_balance CHECK (balance >= 0);
GO
ALTER TABLE account ADD CONSTRAINT CHK_type CHECK (account_type IN ('Saving', 'Checking'));
GO

--6

DROP TABLE IF EXISTS customer

CREATE TABLE customer
(
    customer_id INT PRIMARY KEY,
	name VARCHAR(55),
	city VARCHAR(255) CONSTRAINT DF_city DEFAULT 'Uknown'
);

ALTER TABLE customer DROP CONSTRAINT DF_city;

ALTER TABLE customer ADD CONSTRAINT DF_city DEFAULT 'Uknown' FOR city;

--7

DROP TABLE IF EXISTS invoice;

CREATE TABLE invoice
(
	invoice_id INT IDENTITY(1, 1), --default values are also 1 and 1
	amount DECIMAL(10,2)
);

INSERT INTO invoice (amount)
VALUES
	(100.50),
	(200.75),
	(150.00),
	(300.25),
	(400.80);

SELECT * FROM invoice;

SET IDENTITY_INSERT invoice ON;

INSERT INTO invoice (invoice_id) VALUES (100);

SET IDENTITY_INSERT invoice OFF;

--8

DROP TABLE IF EXISTS books;

CREATE TABLE books
(
	book_id INT PRIMARY KEY IDENTITY,
	title VARCHAR(255) NOT NULL,
	price DECIMAL(10,2) CHECK(price > 0),
	genre VARCHAR(255) DEFAULT 'Unknown'
)

INSERT INTO books (title, price) VALUES ('Untitled Book', 20.00);

INSERT INTO books (title, price, genre) VALUES (NULL, 10.99, 'Mystery');

INSERT INTO books (title, price, genre) VALUES ('Free Book', 0, 'Education');

INSERT INTO books (title, price, genre) VALUES ('Free Book', 0.01, 'Education');

SELECT * FROM books;


--9

DROP DATABASE IF EXISTS library;

CREATE DATABASE library;

USE library;

DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS Member;
DROP TABLE IF EXISTS Loan;

CREATE TABLE Book (
    book_id INT IDENTITY PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    author VARCHAR(255) NOT NULL,
    published_year INT CHECK (published_year > 0)
);

CREATE TABLE Member (
    member_id INT IDENTITY PRIMARY KEY,
    name VARCHAR(55) NOT NULL,
    email VARCHAR(255) UNIQUE DEFAULT 'No email',
    phone_number VARCHAR(20) NOT NULL
);


CREATE TABLE Loan (
    loan_id INT IDENTITY PRIMARY KEY,
    book_id INT,
    member_id INT,
    loan_date DATE NOT NULL,
    return_date DATE NULL,
    CONSTRAINT FK_Book FOREIGN KEY (book_id) REFERENCES Book(book_id),
    CONSTRAINT FK_Member FOREIGN KEY (member_id) REFERENCES Member(member_id)
);

INSERT INTO Member (name, email, phone_number) 
VALUES
	('Alice', 'alice@example.com', '123-456-7890'),
	('Bob', 'bob@example.com', '987-654-3210'),
	('John', 'john@example.com', '555-666-7777');


INSERT INTO Book (title, author, published_year) VALUES
    ('1984', 'George Orwell', 1949),
    ('To Kill a Mockingbird', 'Harper Lee', 1960),
    ('The Great Gatsby', 'F.Scott Fitzgerald', 1925);



INSERT INTO Loan (book_id, member_id, loan_date) VALUES (1, 1, '2024-02-01');
INSERT INTO Loan (book_id, member_id, loan_date) VALUES (2, 2, '2024-02-03');
INSERT INTO Loan (book_id, member_id, loan_date) VALUES (3, 3, '2024-02-05');
INSERT INTO Loan (book_id, member_id, loan_date) VALUES (2, 1, '2024-02-10');


SELECT * FROM Book;
SELECT * FROM Member;
SELECT * FROM Loan;
