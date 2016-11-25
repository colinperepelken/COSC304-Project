
/*
	2Kyle16 SQL DDL
	Authors: Colin Bernard, Zachary Grafton, Maria Guenter, Brittany Miller, Mackenzie Salloum
	Date Created: 10/30/2016
*/

-- a registered user (must have an account to place an order)
CREATE TABLE AccountHolder (
	cid INTEGER NOT NULL,
	username VARCHAR(12) NOT NULL UNIQUE,
	password VARCHAR(15) NOT NULL,
	email VARCHAR(254),
	birthDate DATE,
	name VARCHAR(50),
	PRIMARY KEY (cid)
);

-- Sublass of AccountHolder
CREATE TABLE AdminUser (
	cid INTEGER NOT NULL,
	PRIMARY KEY (cid),
	FOREIGN KEY (cid) REFERENCES AccountHolder(cid)
		ON DELETE CASCADE -- delete in Admin if account holder is deleted.
		ON UPDATE CASCADE
);

CREATE TABLE Product (
	pid INTEGER AUTO_INCREMENT,
	cost DECIMAL(10,2),
	pname VARCHAR(50),
	description VARCHAR(250),
	image VARCHAR(100),
	wid INTEGER NOT NULL,
	inventory INTEGER,
	PRIMARY KEY (pid)
);

-- FIXED: made own entity instead of multi-valued attribute. Colin.
CREATE TABLE ProductCategory (
	cid INTEGER NOT NULL,
	pid INTEGER NOT NULL,
	category VARCHAR(50) NOT NULL,
	PRIMARY KEY (cid),
	FOREIGN KEY (pid) REFERENCES Product(pid)
		ON DELETE NO ACTION
		ON UPDATE CASCADE
);

-- Subclass of Product
CREATE TABLE Ticket (
	pid INTEGER NOT NULL,
	ticketDate DATETIME,
	location VARCHAR(100),
	PRIMARY KEY (pid),
	FOREIGN KEY (pid) REFERENCES Product(pid)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE Warehouse (
	wid INTEGER NOT NULL,
	street VARCHAR(50),
	city VARCHAR(50),
	province VARCHAR(50),
	PRIMARY KEY (wid)
);

CREATE TABLE CustomerOrder (
	oid INTEGER NOT NULL,
	orderDate DATE,
	prodCost DECIMAL(10,2),
	street VARCHAR(50),
	city VARCHAR(50),
	province VARCHAR(50),
	country VARCHAR(50),
	hasShipped BOOLEAN,
	cartTotal DECIMAL(10,2), -- relationship attribute
	cid INTEGER NOT NULL, -- FK to AccountHolder
	shippingType VARCHAR(13),
	shippingCost DECIMAL(10,2),
	paymentType VARCHAR(13),
	paymentCost DECIMAL(10,2),
	PRIMARY KEY (oid),
	FOREIGN KEY (cid) REFERENCES AccountHolder(cid)
		ON DELETE CASCADE -- if a customer is deleted, their order is lost
		ON UPDATE CASCADE,
	FOREIGN KEY (shippingType) REFERENCES ShippingOption(shippingType)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION,
	FOREIGN KEY (paymentType) REFERENCES PaymentMethod(paymentType)
		ON DELETE NO ACTION
		ON UPDATE NO ACTION
);

CREATE TABLE HasProduct (
	oid INTEGER NOT NULL,
	pid INTEGER NOT NULL,
	quantity INTEGER,
	PRIMARY KEY (oid, pid),
	FOREIGN KEY (oid) REFERENCES CustomerOrder(oid)
		ON DELETE CASCADE
		ON UPDATE CASCADE,
	FOREIGN KEY (pid) REFERENCES Product(pid)
		ON DELETE CASCADE
		ON UPDATE CASCADE
);

CREATE TABLE ShippingOption (
	shippingType VARCHAR(13) CHECK (shippingType IN ('Express', 'Regular', 'International')), 
	PRIMARY KEY (shippingType)
);

CREATE TABLE PaymentMethod (
	paymentType VARCHAR(20) CHECK (paymentType IN ('Paypal', 'VISA', 'Mastercard')),
	PRIMARY KEY (paymentType)
);
