/************************************************************************************************************************************************
--This script creates a source database called DimModel_Sources and a target database called customer_trgt and merge both tables using SQL queries 
--Author: Hetti Jayawardena
--Script Date: 13.02.2021
************************************************************************************************************************************************/


--------------creating the dimenstional model source database------------
Create Database DimModel_database_test;
USE [DimModel_database_test]
GO


--creating the product type source table
Create Table ProductType_src
(ProdType nvarchar(50) NOT NULL PRIMARY KEY NONCLUSTERED,
ProductTypeDescription nvarchar(50) NULL)
GO


--creating the product source table
Create Table Product_src
(ProdId int NOT NULL PRIMARY KEY NONCLUSTERED,
ProductDescription nvarchar(50) NULL,
ProductUnitMeasure nvarchar(50) NULL,
QTYinHand int NULL,
ProdType nvarchar(50) NULL REFERENCES ProductType_src(ProdType))
GO  

--creating the CustomerSegment source table
Create Table CustomerSegment_src
(SegmentId int NOT NULL PRIMARY KEY NONCLUSTERED,
SegmentName nvarchar(50) NULL)
GO 



--creating the Customer source table
Create Table Customer_src
(CustomerId int NOT NULL PRIMARY KEY NONCLUSTERED, 
CustomerName nvarchar(50)NULL,
CustomerAdd nvarchar (50) NULL,
CustomerState nvarchar (50) NULL,
CustomerCity nvarchar (50) NULL,
CustomerCountry nvarchar (50) NULL,
CustomerSegmentId int NULL REFERENCES CustomerSegment_src(SegmentId)
)
GO 


--creating the Order Header source table
Create Table OrderHeader_src
(OrderId int NOT NULL PRIMARY KEY NONCLUSTERED,
OrderDate datetime NOT NULL,
CustomerId int NOT NULL REFERENCES Customer_src(CustomerId))
GO 



--creating the Order Header source table
Create Table OrderDetails_src
(OrderId int NOT NULL REFERENCES OrderHeader_src(OrderId),
ProductId int NOT NULL REFERENCES Product_src(ProdId),
QTY int NULL,
UnitPrice money NULL,
CONSTRAINT [PK_OrderDetails] PRIMARY KEY NONCLUSTERED
(
[OrderId],[ProductId]))
GO


--insert values to ProductType_src table
INSERT INTO ProductType_src(ProdType,ProductTypeDescription)
VALUES('Fish','from Sri Lanka');

INSERT INTO ProductType_src(ProdType,ProductTypeDescription)
VALUES('Diary','from Australia');

INSERT INTO ProductType_src(ProdType,ProductTypeDescription)
VALUES('Meat','from India');

INSERT INTO ProductType_src(ProdType,ProductTypeDescription)
VALUES('Fruits','from Germany');

INSERT INTO ProductType_src(ProdType,ProductTypeDescription)
VALUES('Rice','from China');


--insert values to Produc_src table
INSERT INTO Product_src(ProdId,ProductDescription,ProductUnitMeasure,QTYinHand,ProdType)
VALUES(1,'canned','see the label',100,'Fish');

INSERT INTO Product_src(ProdId,ProductDescription,ProductUnitMeasure,QTYinHand,ProdType)
VALUES(2,'bottles','see the top label',200,'Diary');

INSERT INTO Product_src(ProdId,ProductDescription,ProductUnitMeasure,QTYinHand,ProdType)
VALUES(3,'frozen packets','see the bottom label',300,'Meat');

INSERT INTO Product_src(ProdId,ProductDescription,ProductUnitMeasure,QTYinHand,ProdType)
VALUES(4,'canned','see the top label',400,'Fruits');

INSERT INTO Product_src(ProdId,ProductDescription,ProductUnitMeasure,QTYinHand,ProdType)
VALUES(5,'5 Kg packets','see the label',500,'Rice');



--insert values to CustomerSegment_src table
-------------------
INSERT INTO CustomerSegment_src(SegmentId,SegmentName)
VALUES(599,'Bradwast');

INSERT INTO CustomerSegment_src(SegmentId,SegmentName)
VALUES(699,'Bradwast');

INSERT INTO CustomerSegment_src(SegmentId,SegmentName)
VALUES(799,'Michal');

INSERT INTO CustomerSegment_src(SegmentId,SegmentName)
VALUES(899,'Paul');

INSERT INTO CustomerSegment_src(SegmentId,SegmentName)
VALUES(999,'Rahul');



--insert values to Customer_src table

INSERT INTO Customer_src(CustomerId,CustomerName,CustomerAdd,CustomerState,CustomerCity,CustomerCountry,CustomerSegmentId)
VALUES(599,'Harini','746 W. High Noon Ave.
Long Beach, Sri lanka','Western','Colombo','Sri Lanka',599);

INSERT INTO Customer_src(CustomerId,CustomerName,CustomerAdd,CustomerState,CustomerCity,CustomerCountry,CustomerSegmentId)
VALUES(999,'Muster','7031 Creekside Ave.
Monroe Township NJ 08831','New Jersey','New Jersey','USA',699);


INSERT INTO Customer_src(CustomerId,CustomerName,CustomerAdd,CustomerState,CustomerCity,CustomerCountry,CustomerSegmentId)
VALUES(899,'Rafael','921 Birchpond St.
Athens, GA 30605','Gorgeia','Rockwell','USA',799);


INSERT INTO Customer_src(CustomerId,CustomerName,CustomerAdd,CustomerState,CustomerCity,CustomerCountry,CustomerSegmentId)
VALUES(799,'Enrik','866 Marlborough Street
Suitland, MD 20746','New Jersey','New Jersey','USA',899);


INSERT INTO Customer_src(CustomerId,CustomerName,CustomerAdd,CustomerState,CustomerCity,CustomerCountry,CustomerSegmentId)
VALUES(699,'Jayawardena','Händelstr. 20','Baden Wüttenberg','Freiburg','Germany',999);





--insert values to Order Header_src table
INSERT INTO OrderHeader_src(OrderId,OrderDate,CustomerId)
VALUES(01,'2021-08-19',999);

INSERT INTO OrderHeader_src(OrderId,OrderDate,CustomerId)
VALUES(02,'2021-09-24',899);

INSERT INTO OrderHeader_src(OrderId,OrderDate,CustomerId)
VALUES(03,'2020-08-21',799);

INSERT INTO OrderHeader_src(OrderId,OrderDate,CustomerId)
VALUES(04,'2021-01-22',699);

INSERT INTO OrderHeader_src(OrderId,OrderDate,CustomerId)
VALUES(05,'2021-02-22',599);



--insert values to OrderDetails_src table
INSERT INTO OrderDetails_src(OrderId,ProductId,QTY,UnitPrice)
VALUES(01,1,19,10);

INSERT INTO OrderDetails_src(OrderId,ProductId,QTY,UnitPrice)
VALUES(02,2,29,20);

INSERT INTO OrderDetails_src(OrderId,ProductId,QTY,UnitPrice)
VALUES(03,3,19,13);

INSERT INTO OrderDetails_src(OrderId,ProductId,QTY,UnitPrice)
VALUES(04,4,59,30);

INSERT INTO OrderDetails_src(OrderId,ProductId,QTY,UnitPrice)
VALUES(05,5,39,40);





--------------------------------------------------------------------------
--------------------------------------------------------------------------
--------------------------------------------------------------------------


----------Creating the Target Database------------


-- create Table DimCustomer_trgt
CREATE TABLE DimCustomer_trgt(
CustomerKey INT NOT NULL PRIMARY KEY,
CustomerName VARCHAR(50),
CustomerSegID INT,
CustomerSegName VARCHAR(50)
);

-- create DimProuct_trgt
CREATE TABLE DimPrdouct_trgt(
ProductKey INT NOT NULL PRIMARY KEY,
ProductDescription VARCHAR(100),
ProductUnitMeasure VARCHAR(100),
ProductType VARCHAR(50),
ProductTypeDescr VARCHAR(100),
ProductUnitPrice INT
);



-- create DimGeography_trgt
CREATE TABLE DimGeography_trgt(
GeoKey INT NOT NULL PRIMARY KEY,
StateProvince VARCHAR(50),
City VARCHAR(50),
CountryRegionName VARCHAR(50),
)



--------------------------------------------------------------------------
--Insert Values

--Insert into DimGeography_trgt table
Insert Into DimGeography_trgt (
	GeoKey,
	StateProvince,
	City,
	CountryRegionName	
)
Select CustomerId,
	   CustomerState,
	   CustomerCity,
	   CustomerCountry
From Customer_src
	



---------------------------------------------------------------
--Insert into Dimcustomer_trgt table
Insert Into DimCustomer_trgt (
	CustomerKey	
)
Select CustomerId	
	From Customer_src


Merge DimCustomer_trgt as t

Using (Select * From Customer_src) as s
On (t.CustomerKey = s.CustomerID)
When Matched 
		Then Update	
		Set t.CustomerName = s.CustomerName
When Not Matched By Target 
Then Insert (CustomerName)
	Values(s.CustomerName)
When NOT MATCHED By SOURCE
Then Delete;


--Insert into DimCustomer_trgt table
Merge DimCustomer_trgt as t
Using  CustomerSegment_src as s
On (t.CustomerKey = s.SegmentId)
When Matched 
		Then Update	
		Set t.CustomerSegName = s.SegmentName,
			t.CustomerSegID =  s.SegmentId;



---------------------------------------------------------------


--Insert into DimProuct_trgt table
Insert Into DimPrdouct_trgt (
	ProductKey
)
Select ProdId
	From  Product_src



Merge DimPrdouct_trgt As DP_trgt  
Using (Select ProdId, ProductDescription, ProductUnitMeasure, Product_src.ProdType, UnitPrice, ProductTypeDescription
		From Product_src 
		Inner Join OrderDetails_src 
		On Product_src.ProdId = OrderDetails_src.OrderId
		Inner Join ProductType_src	
		On Product_src.ProdType = ProductType_src.ProdType
	) As Feed
	On  Feed.ProdId = DP_trgt.ProductKey
When Matched 
	 Then Update	
		Set DP_trgt.ProductDescription = Feed.ProductDescription,
			DP_trgt.ProductUnitMeasure = Feed.ProductUnitMeasure,
			DP_trgt.ProductType = Feed.ProdType,
			DP_trgt.ProductUnitPrice   = Feed.UnitPrice,
			DP_trgt.ProductTypeDescr   = Feed.ProductTypeDescription
When Not Matched 
	Then Insert (ProductDescription, ProductUnitMeasure, ProductType, ProductUnitPrice, ProductTypeDescr)
	     Values (Feed.ProductDescription, Feed.ProductUnitMeasure, Feed.ProdType, Feed.UnitPrice, Feed.ProductTypeDescription);    
	
			
--second method


--With t1 As 
--(
--Select  a.ProdId, a.ProductDescription, a.ProductUnitMeasure, a.ProdType, b.UnitPrice	 
--From Product_src a
--Left Join OrderDetails_src b
--On (a.ProdId = b.OrderId)
--)
--,t2 As (
--Select c.ProdId As ProductKey, 'NULL' As ProductAltKey, c.ProductDescription, c.ProductUnitMeasure, c.ProdType As ProductType, c.ProductDescription As ProductTypeDescr, c.UnitPrice As ProductUnitPrice
--From t1 c
--Left Join ProductType_src d
--On (c.ProdType = d.ProdType)
--)
--Insert Into DimProuct_trgt1
--Select * From t2;

--Select * from DimProuct_trgt
--Insert Into (DimProuct_trgt.ProductDescription,DimProuct_trgt.ProductUnitMeasure,DimProuct_trgt.ProductType,DimProuct_trgt.ProductTypeDescr,DimProuct_trgt.ProductUnitPrice)
--	   Values (t2.ProductDescription, t2.ProductUnitMeasure, t2.ProdType, t2.UnitPrice, t2.ProductTypeDescription);    



	





