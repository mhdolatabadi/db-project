CREATE TABLE Phase3.Personnel
(
  Personnel_Id char(4) NOT NULL,
  First_Name varchar(20) NOT NULL,
  Last_Name varchar(20) NOT NULL,
  Birthdate date,
  Email varchar(20),
  Salary int NOT NULL,
  Card_No char(16) NOT NULL,
  Hiring_Date date NOT NULL,
  Phone_No char(10),
  PRIMARY KEY (Personnel_Id)
);

CREATE TABLE Phase3.Deliverer
(
  Plate_No char(8),
  Vehicel_Year year,
  Model varchar(20),
  Is_Available bool not null,
  Personnel_Id char(4) not null,
  primary key (Personnel_Id),
  foreign key (Personnel_Id) references Personnel(Personnel_Id)
);

CREATE TABLE Phase3.Warehouse
(
  Warehouse_Id char(4) NOT NULL,
  Location varchar(20) NOT NULL,
  PRIMARY KEY (Warehouse_Id)
);

create table Phase3.Personnel_Phone_No
(
  Phone_No char(10) NOT NULL,
  Personnel_Id char(4) NOT NULL,
  PRIMARY KEY (Phone_No, Personnel_Id),
  FOREIGN KEY (Personnel_Id) references Personnel(Personnel_Id)
);

CREATE TABLE Phase3.Product
(
  Product_Id char(4) NOT NULL,
  p_name varchar(20) NOT NULL,
  Price INT NOT NULL,
  Brand varchar(20),
  Expire_Date date,
  Weight INT,
  Quantity INT NOT NULl,
  p_description varchar(100),
  Warehouse_Id char(4) NOT NULL,
  PRIMARY KEY (Product_Id),
  FOREIGN KEY (Warehouse_Id) references Warehouse(Warehouse_Id)
);

CREATE TABLE Phase3.Employee
(
  Education varchar(20) NOT NULL,
  Is_Manager bool default false,
  Personnel_Id char(4) NOT NULL,
  Warehouse_Id char(4),
  Manager_Personnel_Id char(4),
  PRIMARY KEY (Personnel_Id),
  FOREIGN KEY (Personnel_Id) references Personnel(Personnel_Id),
  FOREIGN KEY (Warehouse_Id) references Warehouse(Warehouse_Id),
  FOREIGN KEY (Manager_Personnel_Id) references Employee(Personnel_Id)
);

CREATE TABLE Phase3.Category
(
  Category_Id char(4) NOT NULL,
  c_name varchar(20) NOT NULL,
  c_description varchar(100),
  Personnel_Id char(4) NOT NULL,
  PRIMARY KEY (Category_Id),
  FOREIGN KEY (Personnel_Id) references Employee(Personnel_Id)
);

CREATE TABLE Phase3.Discount
(
  d_code char(4) NOT NULL,
  Expire_Date date NOT NULL,
  Max_Amount INT NOT NULL,
  Remain INT NOT NULL,
  Is_Valid bool NOT NULL,
  Percent INT NOT NULL check (percent <= 100 and percent > 0),
  Required_Score INT,
  Personnel_Id char(4) NOT NULL,
  PRIMARY KEY (d_code),
  FOREIGN KEY (Personnel_Id) references Employee(Personnel_Id)
);

CREATE TABLE Phase3.Accounts
(
  a_password varchar(20) NOT NULL,
  Username varchar(20) NOT NULL,
  Credit INT default 0,
  a_code char(4) NOT NULL,
  PRIMARY KEY (Username),
  FOREIGN KEY (a_code) references Discount(d_code)
);

CREATE TABLE Phase3.Address
(
  Province varchar(20) NOT NULL,
  City varchar(20) NOT NULL,
  Other varchar(100) NOT NULL,
  Username char(4) NOT NULL,
  PRIMARY KEY (Province, City, Other, Username),
  FOREIGN KEY (Username) references Accounts(Username)
);

CREATE TABLE Phase3.Orders
(
  Order_Id char(4) NOT NULL,
  Order_Time datetime NOT NULL,
  Tax INT NOT NULL,
  o_comment varchar (100),
  Deliver_Time datetime,
  o_status char(1) default 0,
  deliverer_id char(4),
  Province varchar (20) NOT NULL,
  City varchar (20) NOT NULL,
  Other varchar (100) NOT NULL,
  Username varchar (20) NOT NULL,
  d_code char(4),
  PRIMARY KEY (Order_Id),
  FOREIGN KEY (deliverer_id) references Deliverer(Personnel_Id),
  FOREIGN KEY (Province, City, Other, Username) references Address(Province, City, Other, Username),
  FOREIGN KEY (d_code) references Discount(d_code)
);




CREATE TABLE Phase3.Cart
(
  Total_Price INT NOT NULL,
  Username varchar(20) NOT NULL,
  PRIMARY KEY (Username),
  FOREIGN KEY (Username) references Accounts(Username)
);

CREATE TABLE Phase3.Customer_Info
(
  c_name varchar(20),
  Phone char(10),
  Email varchar(20),
  Username varchar(20) NOT NULL,
  PRIMARY KEY (Username),
  FOREIGN KEY (Username) references Accounts(Username)
);



CREATE TABLE Phase3.Category_Detail
(
  Product_Id char(4) NOT NULL,
  Category_Id char(4) NOT NULL,
  PRIMARY KEY (Product_Id, Category_Id),
  FOREIGN KEY (Product_Id) references Product(Product_Id),
  FOREIGN KEY (Category_Id) references Category(Category_Id)
);

CREATE TABLE Phase3.Cart_Detail
(
  Product_Id char(4) NOT NULL,
  Username varchar(20) NOT NULL,
  PRIMARY KEY (Product_Id, Username),
  FOREIGN KEY (Product_Id) references Product(Product_Id),
  FOREIGN KEY (Username) references Cart(Username)
);

CREATE TABLE Phase3.Order_Detail
(
  Is_Returned bool default false,
  Amount INT NOT NULL,
  Order_Id char(4) NOT NULL,
  Product_Id char(4) NOT NULL,
  PRIMARY KEY (Order_Id, Product_Id),
  FOREIGN KEY (Order_Id) references Orders(Order_Id),
  FOREIGN KEY (Product_Id) references Product(Product_Id)
);

CREATE view Phase3.Report_V as
select sum(Price) as total_shopping, count(distinct Order_Id) as Shopping_No, username from Phase3.Order_Detail, Phase3.Orders, Phase3.Product
group by Username;

create view Phase3.manager_v as
select first_name, last_name, email, salary, phone_no, personnel_id from Phase3.Employee, Phase3.Personnel
where manager_id = '1111';

CREATE view Phase3.Delivery_V as
select phone, customer_name, order_id, province, city, other, username from Phase3.Address, Phase3.Orders, Phase3.Accounts;

CREATE view Phase3.Shopping_V as
select p_name, price, brand, p_description, is_available, product_id from Phase3.Product;