DROP TABLE QIngredientSupplier
DROP TABLE QIngredientIngOrder
DROP TABLE QMenuItemIngredient
DROP TABLE QOrderMenuItem
DROP TABLE IngredientOrder
DROP TABLE InShopShift
DROP TABLE InStorePay
DROP TABLE PickupOrder
DROP TABLE DeliveryOrder
DROP TABLE PhoneOrder
DROP TABLE WalkInOrder
DROP TABLE DriverShift
DROP TABLE DriverPay
DROP TABLE Orders
DROP TABLE InStore
DROP TABLE Driver
DROP TABLE Shift
DROP TABLE StaffPayment
DROP TABLE Ingredient
DROP TABLE Supplier
DROP TABLE MenuItem
DROP TABLE Staff
DROP TABLE Customer

-- Create a table to store customer information
CREATE TABLE Customer (
 CustomerId CHAR(3) PRIMARY KEY, -- Unique identifier for each customer (Eg:
xxx)
 FirstName VARCHAR(50) NOT NULL, -- First name of the customer (must not be
null)
 Surname VARCHAR(50) NOT NULL, -- Last name of the customer (must not be
null)
 Phone VARCHAR(15) NOT NULL, -- Customer's contact phone number (must not
be null)
 Address VARCHAR(255) NOT NULL -- Customer's physical address (must not be
null)
);


-- Create a table to store staff information
CREATE TABLE Staff (
 StaffId CHAR(2) PRIMARY KEY, -- Unique identifier for each staff member
(Eg: xx)
 TaxFileNo VARCHAR(15) NOT NULL, -- Tax file number of the staff member
(must not be null)
 FirstName VARCHAR(50) NOT NULL, -- First name of the staff member (must
not be null)
 Surname VARCHAR(50), -- Last name of the staff member
 Phone VARCHAR(15), -- Staff member's contact phone number
 Description VARCHAR(255), -- Staff be Manager, Crew Member, or Cashier
 Address VARCHAR(255), -- Staff member's physical address
 Status VARCHAR(20), -- Staff member's employment status (e.g.,
active, inactive)
 AcName VARCHAR(50), -- Bank account name for payroll purposes
 BSB VARCHAR(10), -- Bank State Branch code for direct deposits
 AcNo VARCHAR(15) -- Bank account number for direct deposits
);

-- Create a table to store MenuItem information
CREATE TABLE MenuItem (
 ItemCode CHAR(5) PRIMARY KEY, -- Unique identifier for the item
 Name VARCHAR(255) NOT NULL, -- Name of the menu item (required)
 Size VARCHAR(50), -- Size of the item (optional)
 Price DECIMAL(10, 2) NOT NULL, -- Price of the item (required)
 Description TEXT -- Description of the item
);
--Supplier table for recording supplier information
CREATE TABLE Supplier (
 SupplierID CHAR(5) PRIMARY KEY, -- Unique identifier for the supplier
 Name VARCHAR(255) NOT NULL, -- Name of the supplier (required)
 Phone VARCHAR(20), -- Phone number of the supplier
 Address VARCHAR(255), -- Address of the supplier
 eMail VARCHAR(255), -- Email address of the supplier
 ContactPerson VARCHAR(100) -- Name of the contact person at the supplier
);
--Ingredient table for recording ingredient information
CREATE TABLE Ingredient (
 IngredientCode CHAR(5) PRIMARY KEY, -- Unique identifier for the
ingredient
 Name VARCHAR(255) NOT NULL, -- Name of the ingredient
(required)
 StockUnit VARCHAR(50), -- Unit of measurement for stock
 Description TEXT, -- Description of the ingredient
 StockLevelAtStockTake DECIMAL(10, 2), -- Stock level at the last stock
take
 DateOfLastStockTake DATE, -- Date of the last stock take
 SuggestedStockLevel DECIMAL(10, 2), -- Suggested stock level for the
ingredient
 ReorderLevel DECIMAL(10, 2), -- Reorder level for the ingredient
 Type VARCHAR(50) -- Type or category of the
ingredient
);
-- InStore table
CREATE TABLE InStore (
 StaffId CHAR(2),
 HourlyRate DECIMAL(10, 2) DEFAULT 15.00, --Default value of 15.00
 ShiftNo INT,
 PRIMARY KEY (StaffId),
 FOREIGN KEY (StaffId) REFERENCES Staff (StaffId) ON UPDATE CASCADE ON DELETE
CASCADE
);
-- Driver table
CREATE TABLE Driver (
 StaffId CHAR(2),
 DriverLicNo INT,
 RatePerDelivery DECIMAL(10, 2),
 ShiftNo INT,
PRIMARY KEY ( StaffId ),
 FOREIGN KEY (StaffId) REFERENCES Staff (StaffId) ON UPDATE CASCADE ON DELETE
CASCADE
);
--Create the Shift table
CREATE TABLE Shift (
 ShiftNo INT PRIMARY KEY, -- Unique identifier for each shift
 StartDateTime DATETIME, -- Date and time when the shift starts
 HoursPaid DECIMAL(5, 2) -- Number of hours paid for the shift
);
--Create the Orders table
CREATE TABLE Orders (
 OrderId CHAR(5) PRIMARY KEY,
 OrderDateTime DATETIME,
 OrderType VARCHAR(50),
 TotalAmountDue DECIMAL(10, 2) DEFAULT 0.00, -- Default value 0.00
 PaymentMethod VARCHAR(50),
 PaymentApprovalNo VARCHAR(50) DEFAULT NULL, -- Default value NULL
 Status VARCHAR(50),
 CustomerId CHAR(3),
 StaffId CHAR(2),
 FOREIGN KEY (CustomerId) REFERENCES Customer(CustomerId) ON UPDATE CASCADE ON
DELETE CASCADE,
 FOREIGN KEY (StaffId) REFERENCES Instore(StaffId) ON UPDATE CASCADE ON DELETE
CASCADE
);
-- Create the WalkInOrder table
CREATE TABLE WalkInOrder (
 OrderId CHAR(5) PRIMARY KEY,
 WalkInTime DATETIME,
 FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON UPDATE CASCADE ON DELETE
CASCADE
);
-- Create the PhoneOrder table
CREATE TABLE PhoneOrder (
 OrderId CHAR(5) PRIMARY KEY,
 TimeCallAnswered DATETIME,
 TimeCallTerminated DATETIME,
 FOREIGN KEY (OrderId) REFERENCES Orders(OrderId) ON UPDATE CASCADE ON DELETE
CASCADE
);
-- Create the StaffPayment table
CREATE TABLE StaffPayment (
 RecordId INT PRIMARY KEY,
 GrossPay DECIMAL(10, 2) DEFAULT 0.00, -- Default value 0.00
 TaxWithHeld DECIMAL(10, 2) DEFAULT 0.00, -- Default value 0.00
 TotalAmountPaid DECIMAL(10, 2),
 PaymentDate DATE,
 PayPeriodStartDate DATE,
 PayPeriodEndDate DATE,
 StaffId CHAR(2),
 FOREIGN KEY (StaffId) REFERENCES Staff(StaffId) ON UPDATE CASCADE ON DELETE
CASCADE
);
--DriverPay table for staff payments related to delivery work
CREATE TABLE DriverPay (
 PaidDeliveryRate DECIMAL(10, 2), -- The rate paid to the staff for deliveries
 DeliveriesPaid INT, -- The number of deliveries for which the
staff is paid
 RecordId INT PRIMARY KEY, -- Unique identifier for the payment
 FOREIGN KEY (RecordId) REFERENCES StaffPayment (RecordId) ON UPDATE CASCADE ON
DELETE CASCADE
);
-- Create the DriverShift table
CREATE TABLE DriverShift (
 NoOfDeliveries INT,
 ShiftNo INT,
 RecordId INT,
 StaffId CHAR(2),
 PRIMARY KEY (ShiftNo),
 FOREIGN KEY (ShiftNo) REFERENCES Shift(ShiftNo) ON DELETE NO ACTION ON UPDATE
NO ACTION,
 FOREIGN KEY (RecordId) REFERENCES DriverPay(RecordId) ON DELETE NO ACTION ON
UPDATE NO ACTION,
 FOREIGN KEY (StaffId) REFERENCES Driver(StaffId) ON DELETE NO ACTION ON UPDATE
NO ACTION
);
-- Create the DeliveryOrder table
CREATE TABLE DeliveryOrder (
 OrderId CHAR(5) PRIMARY KEY,
 DeliveryAddress VARCHAR(255),
 DeliveryTime DATETIME,
 ShiftNo INT,
 FOREIGN KEY (OrderId) REFERENCES PhoneOrder(OrderId) ON UPDATE CASCADE ON
DELETE CASCADE,
 FOREIGN KEY (ShiftNo) REFERENCES DriverShift(ShiftNo) ON UPDATE CASCADE ON
DELETE CASCADE
);
-- Create the PickupOrder table
CREATE TABLE PickupOrder (
 OrderId CHAR(5) PRIMARY KEY, -- Unique identifier for the pickup order
 DeliveryAddress VARCHAR(255), -- Address for the pickup order
 DeliveryTime DATETIME, -- Time for the pickup order
 FOREIGN KEY (OrderId) REFERENCES PhoneOrder (OrderId) ON UPDATE CASCADE ON
DELETE CASCADE
);
--InStorePay table for staff payments related to in-store work
CREATE TABLE InStorePay (
 PaidHourlyRate DECIMAL(10, 2), -- The hourly rate paid to the staff
 HoursPaid DECIMAL(5, 2), -- The number of hours for which the staff is
paid
 RecordId INT PRIMARY KEY, -- Unique identifier for the payment record
 FOREIGN KEY (RecordId) REFERENCES StaffPayment (RecordId) ON UPDATE CASCADE ON
DELETE CASCADE
);
--InShopShift table for recording in-store staff shifts
CREATE TABLE InShopShift (
 NoOfHours DECIMAL(5, 2), -- The number of hours worked in the shift
 ShiftNo INT, -- Unique identifier for the shift
 RecordId INT, -- Identifier for the related in-store payment
record
 StaffId CHAR(2), -- Staff identifier
 PRIMARY KEY (ShiftNo),
 FOREIGN KEY (ShiftNo) REFERENCES Shift (ShiftNo) ON DELETE NO ACTION ON UPDATE
NO ACTION,
 FOREIGN KEY (RecordId) REFERENCES InStorePay (RecordId) ON DELETE NO ACTION ON
UPDATE NO ACTION,
 FOREIGN KEY (StaffId) REFERENCES InStore (StaffId) ON DELETE NO ACTION ON
UPDATE NO ACTION
);
--IngredientOrder table for recording ingredient orders
CREATE TABLE IngredientOrder (
 IngredientOrderNo CHAR(10) PRIMARY KEY, -- Unique identifier for the ingredient
order
 DateIssued DATE, -- Date when the order was issued
 DateSupplied DATE, -- Date when the ingredients were
supplied
 Total DECIMAL(10, 2), -- Total cost of the order
 Status VARCHAR(50), -- Status of the order
 Description TEXT, -- Description of the order
 SupplierID CHAR(5), -- Identifier for the supplier providing
the ingredients
 FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID) ON UPDATE CASCADE ON
DELETE CASCADE
);
--QuantityOrderMenuItem table for recording quantity ordered for menu items
CREATE TABLE QOrderMenuItem (
 ItemCode CHAR(5) PRIMARY KEY, -- Identifier for the menu item and primary key
 OrderDate DATE, -- Date of the order
 QuantityOrdered INT, -- Quantity of the menu item ordered
 OrderId CHAR(5), -- Identifier for the overall order
 FOREIGN KEY (ItemCode) REFERENCES MenuItem (ItemCode) ON UPDATE CASCADE ON
DELETE CASCADE,
 FOREIGN KEY (OrderId) REFERENCES Orders (OrderId) ON UPDATE CASCADE ON DELETE
CASCADE
);
-- Define the QuantityMenuItemIngredient table for recording quantities of
ingredients used in menu items
CREATE TABLE QMenuItemIngredient (
 ItemCode CHAR(5) PRIMARY KEY, -- Identifier for the menu item and primary
key
 IngredientCode CHAR(5), -- Identifier for the ingredient
 QuantityUsed DECIMAL(10, 2), -- Quantity of the ingredient used
 FOREIGN KEY (ItemCode) REFERENCES MenuItem (ItemCode) ON UPDATE CASCADE ON
DELETE CASCADE,
 FOREIGN KEY (IngredientCode) REFERENCES Ingredient (IngredientCode) ON UPDATE
CASCADE ON DELETE CASCADE
);
--QuantityIngredientIngOrder table for recording quantities of ingredients ordered
in ingredient orders
CREATE TABLE QIngredientIngOrder (
 IngredientOrderNo CHAR(10) PRIMARY KEY, -- Identifier for the ingredient order
and primary key
 IngredientCode CHAR(5), -- Identifier for the ingredient
 QuantityOrdered DECIMAL(10, 2), -- Quantity of the ingredient ordered
 FOREIGN KEY (IngredientOrderNo) REFERENCES IngredientOrder (IngredientOrderNo)
ON UPDATE CASCADE ON DELETE CASCADE,
 FOREIGN KEY (IngredientCode) REFERENCES Ingredient (IngredientCode) ON UPDATE
CASCADE ON DELETE CASCADE
);
--QuantityIngredientSupplier table for recording quantities of ingredients supplied
by suppliers
CREATE TABLE QIngredientSupplier (
 IngredientOrderNo CHAR(10) PRIMARY KEY, -- Identifier for the ingredient order
and primary key
 SupplierID CHAR(5), -- Identifier for the supplier
 PricePerUnit DECIMAL(10, 2), -- Price per unit of the ingredient
 FOREIGN KEY (SupplierID) REFERENCES Supplier (SupplierID) ON DELETE NO ACTION
ON UPDATE NO ACTION,
 FOREIGN KEY (IngredientOrderNo) REFERENCES IngredientOrder (IngredientOrderNo)
ON DELETE NO ACTION ON UPDATE NO ACTION
);





--Data Insertion starts here
-- Inserting data into the Customer table
INSERT INTO Customer (CustomerId, FirstName, Surname, Phone, Address)
VALUES
 ('111', 'John', 'Doe', '555-123-4567', '123 Main Street'),
 ('112', 'Jane', 'Smith', '555-987-6543', '456 Elm Avenue'),
 ('113', 'Bob', 'Johnson', '555-555-5555', '789 Oak Road'),
('114', 'Sarah', 'Johnson', '555-777-8888', '321 Pine Lane'),
 ('115', 'Michael', 'Brown', '555-444-3333', '555 Cedar Street'),
('116', 'David', 'Williams', '555-222-1111', '999 Maple Avenue'),
 ('117', 'Linda', 'Martinez', '555-333-2222', '123 Elm Street'),
 ('118', 'William', 'Anderson', '555-888-7777', '456 Oak Lane'),
 ('119', 'Emily', 'Taylor', '555-999-8888', '789 Cedar Road'),
 ('120', 'Richard', 'Moore', '555-666-5555', '234 Birch Street');
--Inserting data into the Staff table
INSERT INTO Staff (StaffId, TaxFileNo, FirstName, Surname, Phone, Description,
Address, Status, AcName, BSB, AcNo)
VALUES
 ('11', '123-45-6789', 'John', 'Doe', '555-123-4567', 'Manager', '123 Main St,
City', 'Active', 'John Doe', '123456', '12345678'),
 ('12', '987-65-4321', 'Jane', 'Smith', '555-234-5678', 'Crew Member', '456 Elm
St, Town', 'Active', 'Jane Smith', '987654', '87654321'),
 ('13', '456-78-9012', 'Robert', 'Johnson', '555-345-6789', 'Cashier', '789 Oak
St, Village', 'Inactive', 'Robert Johnson', '456789', '98761234'),
 ('14', '789-01-2345', 'Lisa', 'Wilson', '555-456-7890', 'Manager', '101 Pine
St, County', 'Active', 'Lisa Wilson', '789012', '23456789'),
 ('15', '234-56-7890', 'Michael', 'Brown', '555-567-8901', 'Crew Member', '202
Cedar St, Borough', 'Inactive', 'Michael Brown', '234567', '89012345'),
 ('16', '345-67-8901', 'Emily', 'Davis', '555-678-9012', 'Cashier', '303 Birch
St, Township', 'Active', 'Emily Davis', '345678', '90123456'),
 ('17', '567-89-0123', 'David', 'Jones', '555-789-0123', 'Manager', '404 Maple
St, District', 'Active', 'David Jones', '567890', '01234567'),
 ('18', '678-90-1234', 'Sarah', 'Lee', '555-890-1234', 'Crew Member', '505
Willow St, Region', 'Inactive', 'Sarah Lee', '678901', '12345678'),
 ('19', '890-12-3456', 'James', 'Wilson', '555-901-2345', 'Cashier', '606 Cedar
St, Province', 'Active', 'James Wilson', '890123', '23456789'),
 ('20', '012-34-5678', 'Laura', 'Smith', '555-012-3456', 'Manager', '707 Oak St,
State', 'Active', 'Laura Smith', '012345', '34567890');
-- Insert data into the MenuItem table
INSERT INTO MenuItem (ItemCode, Name, Size, Price, Description)
VALUES
 ('M0001', 'Hamburger', 'Regular', 5.99, 'Classic beef burger'),
 ('M0002', 'Cheeseburger', 'Regular', 6.49, 'Burger with cheese'),
 ('M0003', 'Chicken Sandwich', 'Regular', 6.99, 'Grilled chicken sandwich'),
 ('M0004', 'Fries', 'Regular', 2.99, 'Crispy potato fries'),
 ('M0005', 'Soda', 'Small', 1.99, 'Carbonated soft drink'),
 ('M0006', 'Pizza Slice', 'Large', 4.99, 'Delicious pizza slice'),
 ('M0007', 'Salad', 'Regular', 4.49, 'Fresh garden salad'),
 ('M0008', 'Pasta', 'Large', 7.99, 'Homemade pasta dish'),
 ('M0009', 'Ice Cream', 'Small', 3.99, 'Sweet vanilla ice cream'),
 ('M0010', 'Smoothie', 'Medium', 5.49, 'Refreshing fruit smoothie');
 -- Insert data into the Supplier table
INSERT INTO Supplier (SupplierID, Name, Phone, Address, eMail, ContactPerson)
VALUES
 ('S0001', 'Fresh Food Inc.', '555-111-1111', '123 Supplier St',
'info@freshfood.com', 'John Supplier'),
 ('S0002', 'Bulk Ingredients Ltd.', '555-222-2222', '456 Distributor Dr',
'info@bulkingredients.com', 'Alice Distributor'),
 ('S0003', 'Farm to Table Produce', '555-333-3333', '789 Farm Rd',
'info@farmtotable.com', 'Bob Farmer'),
 ('S0004', 'Beverage World', '555-444-4444', '101 Beverage Ave',
'info@beverageworld.com', 'Laura Beverage'),
 ('S0005', 'Meat Master', '555-555-5555', '246 Meat Blvd',
'info@meatmaster.com', 'Mark Meat'),
 ('S0006', 'Fresh Veggies Co.', '555-666-6666', '789 Veggie Ln',
'info@freshveggies.com', 'Sarah Veggie'),
 ('S0007', 'Dairy Delights', '555-777-7777', '456 Dairy Rd',
'info@dairydelights.com', 'David Dairy'),
 ('S0008', 'Seafood Sensations', '555-888-8888', '101 Seafood St',
'info@seafoodsensations.com', 'Samantha Seafood'),
 ('S0009', 'Bakery Bliss', '555-999-9999', '246 Bakery Ave',
'info@bakerybliss.com', 'Brian Baker'),
 ('S0010', 'Spice Emporium', '555-101-1010', '123 Spice Rd',
'info@spiceemporium.com', 'Linda Spice');
-- Insert dummy data into the Ingredient table
INSERT INTO Ingredient (IngredientCode, Name, StockUnit, Description,
StockLevelAtStockTake, DateOfLastStockTake, SuggestedStockLevel, ReorderLevel,
Type)
VALUES
 ('In001', 'Flour', 'Kilograms', 'All-purpose flour', 500.00, '2023-10-15',
200.00, 100.00, 'Dry Goods'),
 ('In002', 'Tomatoes', 'Pounds', 'Fresh red tomatoes', 150.50, '2023-10-15',
50.00, 30.00, 'Produce'),
 ('In003', 'Chicken', 'Pounds', 'Boneless chicken breast', 100.25, '2023-10-15',
40.00, 20.00, 'Meat'),
 ('In004', 'Milk', 'Liters', 'Whole milk', 200.75, '2023-10-15', 80.00, 50.00,
'Dairy'),
 ('In005', 'Lettuce', 'Pounds', 'Fresh lettuce', 50.25, '2023-10-15', 20.00,
10.00, 'Produce'),
 ('In006', 'Pasta', 'Kilograms', 'Spaghetti pasta', 60.00, '2023-10-15', 30.00,
15.00, 'Dry Goods'),
 ('In007', 'Onions', 'Pounds', 'Yellow onions', 40.50, '2023-10-15', 15.00,
10.00, 'Produce'),
 ('In008', 'Cheese', 'Kilograms', 'Cheddar cheese', 80.25, '2023-10-15', 30.00,
20.00, 'Dairy'),
 ('In009', 'Beef', 'Pounds', 'Ground beef', 90.75, '2023-10-15', 40.00, 30.00,
'Meat'),
 ('In010', 'Rice', 'Kilograms', 'Long-grain rice', 75.00, '2023-10-15', 25.00,
15.00, 'Dry Goods');
-- Inserting data into the InStore table
INSERT INTO InStore (StaffId, HourlyRate, ShiftNo)
VALUES
 ('11', 10.50, 1),
 ('12', 9.75, 2),
 ('13', 11.00, 3),
 ('14', 10.25, 4),
 ('15', 12.00, 5);
-- Inserting data into the Driver table
INSERT INTO Driver (StaffId, DriverLicNo, RatePerDelivery, ShiftNo)
VALUES
 ('16', 123456, 5.50, 6),
 ('17', 789012, 6.25, 7),
 ('18', 345678, 5.75, 8),
 ('19', 901234, 6.00, 9),
 ('20', 567890, 7.00, 10);
-- Inserting data into the Shift table
INSERT INTO Shift (ShiftNo, StartDateTime, HoursPaid)
VALUES
 (1, '2023-10-25 08:00:00', 8.5),
 (2, '2023-10-25 09:30:00', 7.25),
 (3, '2023-10-25 12:00:00', 6.75),
 (4, '2023-10-25 14:30:00', 7.0),
 (5, '2023-10-26 07:00:00', 8.0),
 (6, '2023-10-26 08:30:00', 6.5),
 (7, '2023-10-26 11:00:00', 7.75),
 (8, '2023-10-26 14:00:00', 7.25),
 (9, '2023-10-27 09:00:00', 7.5),
 (10, '2023-10-29 14:00:00', 7.25);
 -- Inserting data into the Orders table
INSERT INTO Orders (OrderId, OrderDateTime, OrderType, TotalAmountDue,
PaymentMethod, PaymentApprovalNo, Status, CustomerId, StaffId)
VALUES
 ('ORD01', '2023-10-25 14:30:00', 'Online', 100.50, 'Credit Card', '123456789',
'Processing', '111', '11'),
 ('ORD02', '2023-10-26 10:45:00', 'In-Store', 75.25, 'Cash', '987654321',
'Completed', '112', '12'),
 ('ORD03', '2023-10-27 16:15:00', 'Online', 150.75, 'PayPal', '456789123',
'Processing', '113', '13'),
 ('ORD04', '2023-10-28 12:20:00', 'In-Store', 45.99, 'Credit Card', '789123456',
'Completed', '114', '14'),
 ('ORD05', '2023-10-29 09:00:00', 'Online', 200.00, 'PayPal', '567891234',
'Processing', '115', '15'),
('ORD06', '2023-10-30 15:45:00', 'Online', 80.99, 'Credit Card', '234567890',
'Processing', '116', '11'),
 ('ORD07', '2023-10-31 11:10:00', 'In-Store', 60.75, 'Cash', '876543210',
'Completed', '117', '12'),
 ('ORD08', '2023-11-01 13:25:00', 'Online', 125.50, 'PayPal', '678901234',
'Processing', '118', '13'),
 ('ORD09', '2023-11-02 08:30:00', 'In-Store', 95.25, 'Credit Card', '345678901',
'Completed', '119', '14'),
 ('ORD10', '2023-11-03 17:20:00', 'Online', 175.00, 'PayPal', '789012345',
'Processing', '120', '15');
-- Insert data into the WalkInOrder table
INSERT INTO WalkInOrder (OrderId, WalkInTime)
VALUES
 ('ORD01', '2023-10-25 14:30:00'),
 ('ORD02', '2023-10-26 10:45:00'),
 ('ORD03', '2023-10-27 16:15:00'),
 ('ORD04', '2023-10-28 12:20:00'),
 ('ORD05', '2023-10-29 09:00:00');
-- Insert data into the PhoneOrder table
INSERT INTO PhoneOrder (OrderId, TimeCallAnswered, TimeCallTerminated)
VALUES
 ('ORD06', '2023-10-25 14:30:00', '2023-10-25 14:45:00'),
 ('ORD07', '2023-10-26 10:45:00', '2023-10-26 11:10:00'),
 ('ORD08', '2023-10-27 16:15:00', '2023-10-27 16:30:00'),
 ('ORD09', '2023-10-28 12:20:00', '2023-10-28 12:40:00'),
 ('ORD10', '2023-10-29 09:00:00', '2023-10-29 09:20:00');
-- Insert data into the StaffPayment table
INSERT INTO StaffPayment (RecordId, GrossPay, TaxWithHeld, TotalAmountPaid,
PaymentDate, PayPeriodStartDate, PayPeriodEndDate, StaffId)
VALUES
 (1, 1500.00, 300.00, 1200.00, '2023-10-01', '2023-09-16', '2023-09-30', '11'),
 (2, 1400.00, 280.00, 1120.00, '2023-10-01', '2023-09-16', '2023-09-30', '12'),
 (3, 1600.00, 320.00, 1280.00, '2023-10-01', '2023-09-16', '2023-09-30', '13'),
 (4, 1450.00, 290.00, 1160.00, '2023-10-01', '2023-09-16', '2023-09-30', '14'),
 (5, 1550.00, 310.00, 1240.00, '2023-10-01', '2023-09-16', '2023-09-30', '15'),
(6, 1500.00, 300.00, 1200.00, '2023-11-01', '2023-10-01', '2023-10-15',
'16'),
 (7, 1400.00, 280.00, 1120.00, '2023-11-01', '2023-10-01', '2023-10-15', '17'),
 (8, 1600.00, 320.00, 1280.00, '2023-11-01', '2023-10-01', '2023-10-15', '18'),
 (9, 1450.00, 290.00, 1160.00, '2023-11-01', '2023-10-01', '2023-10-15', '18'),
 (10, 1550.00, 310.00, 1240.00, '2023-11-01', '2023-10-01', '2023-10-15', '20');
-- Insert data into the DriverPay table
INSERT INTO DriverPay (PaidDeliveryRate, DeliveriesPaid, RecordId)
VALUES
 (5.00, 10, 1),
 (5.50, 12, 2),
 (4.75, 8, 3),
 (6.00, 14, 4),
 (5.25, 11, 5),
 (5.75, 13, 6),
 (4.50, 9, 7),
 (6.25, 15, 8),
 (5.00, 10, 9),
 (6.50, 16, 10);
 -- Inserting data into the DriverShift table
INSERT INTO DriverShift (NoOfDeliveries, ShiftNo, RecordId, StaffId)
VALUES
 (10, 1, 1, '16'),
 (8, 2, 2, '17'),
 (12, 3, 3, '18'),
 (5, 4, 4, '19'),
 (9, 5, 5, '20');
-- Inserting data into the DeliveryOrder table
INSERT INTO DeliveryOrder (OrderId, DeliveryAddress, DeliveryTime, ShiftNo)
VALUES
 ('ORD06', '123 Main St, Cityville', '2023-10-26 14:00:00', 1),
 ('ORD07', '456 Elm St, Townsville', '2023-10-26 15:30:00', 2),
 ('ORD08', '789 Oak St, Villagetown', '2023-10-26 16:45:00', 3),
 ('ORD09', '101 Pine St, Hamletville', '2023-10-26 17:15:00', 4),
 ('ORD10', '202 Maple St, Boroughtown', '2023-10-26 18:30:00', 5);
-- Insert data into the PickupOrder table
INSERT INTO PickupOrder (OrderId, DeliveryAddress, DeliveryTime)
VALUES
 ('ORD06', '123 Main St, City, State', '2023-10-26 14:00:00'),
 ('ORD07', '456 Elm St, City, State', '2023-10-27 10:30:00'),
 ('ORD08', '789 Oak St, City, State', '2023-10-28 16:45:00'),
 ('ORD09', '321 Pine St, City, State', '2023-10-29 12:15:00'),
 ('ORD10', '654 Birch St, City, State', '2023-10-30 18:00:00');
-- Insert data into the InStorePay table
INSERT INTO InStorePay (PaidHourlyRate, HoursPaid, RecordId)
VALUES
 (15.00, 40.5, 1),
 (14.50, 37.0, 2),
 (16.00, 45.5, 3),
 (13.75, 32.0, 4),
 (15.25, 38.5, 5);
 -- Insert 5 rows of data into the table
INSERT INTO InShopShift (NoOfHours, ShiftNo, RecordId, StaffId)
VALUES (8.5, 1, 1, '11'),
 (7.0, 2, 2, '12'),
 (9.0, 3, 3, '13'),
 (6.5, 4, 4, '14'),
 (7.5, 5, 5, '15');
-- Inserting data into the table
INSERT INTO IngredientOrder (IngredientOrderNo, DateIssued, DateSupplied, Total,
Status, Description, SupplierID)
VALUES
 ('IO001', '2023-10-01', '2023-10-05', 500.00, 'Delivered', 'First ingredient
order', 'S0001'),
 ('IO002', '2023-10-03', '2023-10-06', 750.00, 'Delivered', 'Second ingredient
order', 'S0002'),
 ('IO003', '2023-10-05', '2023-10-08', 600.00, 'Delivered', 'Third ingredient
order', 'S0003'),
 ('IO004', '2023-10-08', '2023-10-10', 450.00, 'Delivered', 'Fourth ingredient
order', 'S0004'),
 ('IO005', '2023-10-10', '2023-10-14', 800.00, 'In Progress', 'Fifth ingredient
order', 'S0005'),
 ('IO006', '2023-10-12', '2023-10-16', 550.00, 'In Progress', 'Sixth ingredient
order', 'S0006'),
 ('IO007', '2023-10-15', '2023-10-18', 700.00, 'In Progress', 'Seventh
ingredient order', 'S0007'),
 ('IO008', '2023-10-18', '2023-10-21', 900.00, 'Ordered', 'Eighth ingredient
order', 'S0008'),
 ('IO009', '2023-10-20', '2023-10-24', 600.00, 'Ordered', 'Ninth ingredient
order', 'S0009'),
 ('IO010', '2023-10-23', '2023-10-27', 750.00, 'Ordered', 'Tenth ingredient
order', 'S0010');
-- Insert data into the table
INSERT INTO QOrderMenuItem (ItemCode, OrderDate, QuantityOrdered, OrderId)
VALUES
 ('M0001', '2022-10-01', 3, 'ORD01'),
 ('M0002', '2023-10-01', 2, 'ORD02'),
 ('M0003', '2021-10-01', 4, 'ORD03'),
 ('M0004', '2023-10-02', 1, 'ORD04'),
 ('M0005', '2022-10-02', 5, 'ORD05'),
 ('M0006', '2023-10-03', 2, 'ORD06'),
 ('M0007', '2021-10-03', 3, 'ORD07'),
 ('M0008', '2023-10-03', 2, 'ORD08'),
 ('M0009', '2024-10-04', 1, 'ORD09'),
 ('M0010', '2023-10-04', 3, 'ORD10');
-- Insert data into the QMenuItemIngredient table
INSERT INTO QMenuItemIngredient (ItemCode, IngredientCode, QuantityUsed)
VALUES
 ('M0001', 'In001', 2.5),
 ('M0002', 'In002', 1.0),
 ('M0003', 'In003', 1.0),
 ('M0004', 'In004', 0.5),
 ('M0005', 'In005', 3.0),
 ('M0006', 'In006', 1.5),
 ('M0007', 'In007', 2.0),
 ('M0008', 'In008', 1.0),
 ('M0009', 'In009', 2.5),
 ('M0010', 'In010', 1.5);
-- Insert data into the QIngredientIngOrder table
INSERT INTO QIngredientIngOrder (IngredientOrderNo, IngredientCode,
QuantityOrdered)
VALUES
 ('IO001', 'In001', 20.0),
 ('IO002', 'In002', 10.0),
 ('IO003', 'In003', 15.0),
 ('IO004', 'In004', 30.0),
 ('IO005', 'In005', 5.0),
 ('IO006', 'In006', 12.0),
 ('IO007', 'In007', 25.0),
 ('IO008', 'In008', 18.0),
 ('IO009', 'In009', 8.0),
 ('IO010', 'In010', 11.0);
 -- Insert data into the QIngredientSupplier table
INSERT INTO QIngredientSupplier (IngredientOrderNo, SupplierID, PricePerUnit)
VALUES
 ('IO001', 'S0001', 2.5),
 ('IO002', 'S0002', 3.0),
 ('IO003', 'S0003', 2.2),
 ('IO004', 'S0004', 2.6),
 ('IO005', 'S0005', 1.8),
 ('IO006', 'S0006', 2.0),
 ('IO007', 'S0007', 1.5),
 ('IO008', 'S0008', 1.9),
 ('IO009', 'S0009', 3.2),
 ('IO010', 'S0010', 2.8);


 --Queries
 --Q1
SELECT FirstName, Surname, HourlyRate
FROM Staff
JOIN InStore ON InStore.StaffId = Staff.StaffId
WHERE Staff.StaffId = '11';
--Q2
SELECT Shift.ShiftNo, Shift.StartDateTime, Shift.HoursPaid
FROM Staff
JOIN DriverShift ON Staff.StaffId = DriverShift.StaffId
JOIN Shift ON DriverShift.ShiftNo = Shift.ShiftNo
WHERE Staff.FirstName = 'James'
 AND Staff.Surname = 'Wilson'
 AND Shift.StartDateTime BETWEEN '2023-10-26 14:00:00' AND '2029-10-26 14:00:00';
--Q3
SELECT O.OrderId, O.OrderDateTime, O.OrderType, O.TotalAmountDue, O.PaymentMethod,
O.PaymentApprovalNo, O.Status, C.FirstName, C.Surname
FROM Orders O
JOIN Customer C ON O.CustomerId = C.CustomerId
JOIN WalkInOrder WIO ON O.OrderId = WIO.OrderId
WHERE C.FirstName = 'John'
 AND C.Surname = 'Doe'
 AND O.OrderDateTime BETWEEN '2023-10-26 10:45:00' AND '2023-11-02 08:30:00'
 AND O.OrderType = 'In-Store';
--Q4
SELECT DISTINCT M.Name
FROM MenuItem M
JOIN QOrderMenuItem Q ON M.ItemCode = Q.ItemCode
WHERE YEAR(Q.OrderDate) = YEAR('2023');
--Q5