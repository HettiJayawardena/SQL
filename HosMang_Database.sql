/************************************************************************************************************************************************
--This script creates and maintans values in a database for a Hospital management system 
--Author: Hetti Jayawardena
--Script Date: 04.01.2021
************************************************************************************************************************************************/


--------------creating the dimenstional model source database------------
Create Database Hospitality_Management_System_test;
USE [Hospitality_Management_System_test]
GO



--creating the DEPARTMENT table

Create Table DEPARTMENT
(D_NAME nvarchar(50) NOT NULL PRIMARY KEY,
 D_LOCATION nvarchar(50) NOT NULL,      
 D_FACILITIES  nvarchar(50) NOT NULL)
GO




--creating the ALL_DOCTORS table
Create Table ALL_DOCTORS
(DOC_NO int  NOT NULL PRIMARY KEY,
 DEPARTMENT_Name nvarchar(50) NOT NULL FOREIGN KEY REFERENCES DEPARTMENT(D_NAME))     
GO


--creating the DOC_REG table
Create Table DOC_REG
(
 DOC_NO int  NOT NULL  FOREIGN KEY REFERENCES ALL_DOCTORS(DOC_NO),
 D_NAME nvarchar(50) NOT NULL,
 Qualification nvarchar(50) NOT NULL,
 DOC_ADDRESS nvarchar(100) NOT NULL,
 PHONE_NUMBER int,
 SALARY  float,
 DATE_OF_JOINING datetime NOT NULL
 )  
 

 -- Constraint: Doctorís number entered should contain DR only as a prefix and must exist
--in ALL_DOCTORS table.??


--creating the DOC_ON_CALL table
Create Table DOC_ON_CALL
(
 D_NAME nvarchar(50) NOT NULL PRIMARY KEY,
 DOC_NO int  NOT NULL  FOREIGN KEY REFERENCES ALL_DOCTORS(DOC_NO),
 Qualification nvarchar(50) NOT NULL,
 DOC_ADDRESS nvarchar(100) NOT NULL,
 PHONE_NUMBER nvarchar(100) NOT NULL,  
 FEES_PER_CALL float
 )  
 



--creating the PAT_ENTRY table
Create Table PAT_ENTRY
(PT_NO int  NOT NULL PRIMARY KEY,  
 PT_NAME nvarchar(50) NOT NULL,
 PT_AGE int NOT NULL,
 SEX nvarchar(6) NOT NULL CHECK (SEX IN ('M', 'F')),
 PHONE_NUMBER nvarchar(100) NOT NULL,  
 PT_ADDRESS nvarchar(100) NOT NULL,
 PT_CITY nvarchar(50) NOT NULL, 
 PT_ENTRY_DATE datetime NOT NULL, 
 REF_DOC_NO int  NOT NULL FOREIGN KEY REFERENCES ALL_DOCTORS(DOC_NO),
 REF_DEPARTMENT nvarchar(50) NOT NULL FOREIGN KEY REFERENCES DEPARTMENT(D_NAME),
 DIAGNOSIS nvarchar(50) NOT NULL
 )   
GO


--Constraint: Patient number should begin with prefix PT. Sex should be M or F only.
--Doctorís name and department referred must exist.

--creating the PAT_CHKUP table
Create Table PAT_CHKUP
(PT_NO int  NOT NULL FOREIGN KEY REFERENCES PAT_ENTRY(PT_NO), 
 DOC_NO int NOT NULL FOREIGN KEY REFERENCES ALL_DOCTORS(DOC_NO), --additional FK reference i added do we need it??
 PT_AGE int NOT NULL,
 DATE_CHKUP datetime,
 DIAGNOSIS nvarchar(50) NOT NULL,  
 TREATMENT nvarchar(50) NOT NULL,
 PT_STATUS nvarchar(50) NOT NULL  --how to refer to other tables depending on the status?
 CONSTRAINT [PT_NO] PRIMARY KEY 
 )   
GO




--creating the PAT_ADMIT table
Create Table PAT_ADMIT
(PT_NO int  NOT NULL FOREIGN KEY REFERENCES PAT_ENTRY(PT_NO),
 ADVANCED_PAYMENT money NOT NULL,
 MODE_OF_PAYMENT nvarchar(50) NOT NULL, 
 ROOM_NUMBER int NOT NULL,
 DEPARTMENT_NAME nvarchar(50) NOT NULL FOREIGN KEY REFERENCES DEPARTMENT(D_NAME),
 DATE_OF_ADMISSION datetime,
 INIT_CONDITION nvarchar(50) NOT NULL,
 DIAGNOSIS nvarchar(50) NOT NULL,  
 TREATMENT nvarchar(50) NOT NULL,
 DOC_NO int NOT NULL  FOREIGN KEY REFERENCES ALL_DOCTORS(DOC_NO),
 ATTENDANT_NAME nvarchar(50) NOT NULL
 )   
GO




Create Table PAT_DIS
(PT_NO int  NOT NULL UNIQUE FOREIGN KEY REFERENCES PAT_ENTRY(PT_NO), 
 PAYMENT_MADE money NOT NULL,
 MODE_OF_PAYMENT nvarchar(50) NOT NULL, 
 DATE_OF_DIS datetime,
 TREATMENT_GIVEN nvarchar(50) NOT NULL,
 TREATMENT_ADVICE nvarchar(50) NOT NULL,
 )   
GO



Create Table PAT_REGI
(PT_NO int  NOT NULL FOREIGN KEY REFERENCES PAT_ENTRY(PT_NO), 
 DIAGNOSIS nvarchar(50) NOT NULL, 
 DATE_OF_VISIT datetime,
 TREATMENT_GIVEN nvarchar(50) NOT NULL,
 MEDICINE_RECOMMENDED nvarchar(50) NOT NULL,
 TREATMENT_STATUS nvarchar(50) NOT NULL
 )   
GO




--creating the Patient Peoration table
Create Table PAT_OPR
(PT_NO int  NOT NULL UNIQUE FOREIGN KEY REFERENCES PAT_ENTRY(PT_NO),  --Constraint: Patient number should exist in PAT_ENTRY table.
 DATE_OF_ADMISSION datetime,
 DATE_OF_OPERATION datetime,
 DOC_NO int NOT NULL FOREIGN KEY REFERENCES ALL_DOCTORS(DOC_NO),
 DEPARTMENT nvarchar(50) NOT NULL,
 OPR_THEATER_NO int NOT NULL,
 TYPE_OF_OPR nvarchar(50) NOT NULL,
 PT_CONDTION_BEFORE nvarchar(50) NOT NULL,
 PT_CONDTION_AFTER nvarchar(50) NOT NULL,
 TREATMENT_ADVICE nvarchar(50) NOT NULL
 )   
GO


--creating the ROOM DETAILS table
Create Table ROOM_DETAILS
(ROOM_NO int  NOT NULL PRIMARY KEY, --Constraint: Patient number should exist in PAT_ENTRY table.
 ROOM_TYPE nvarchar(50) NOT NULL  CHECK (ROOM_TYPE IN ('G', 'P')),
 ROOM_STATUS nvarchar(50) NOT NULL CHECK (ROOM_STATUS IN ('Y', 'N')),
 PT_NO int NOT NULL FOREIGN KEY REFERENCES PAT_ENTRY(PT_NO),        --if occupied, then patient number, patient name, charges per day, etc??? how to implement this
 PT_NAME nvarchar(50) NOT NULL,
 CHARGE_PER_DAY money
 )   
GO

------------------------------------------------------------------------------------------------------------------------------------------------------------
-----Inserting Values------

INSERT INTO DEPARTMENT(D_NAME, D_LOCATION, D_FACILITIES)
VALUES ('Sergery Department', 'Colombo', 'Operation facilities are not available'),
	   ('Gynecology', 'Berlin', 'Female doctors are available'), 
       ('Neurology', 'Postdam', 'MRI scanner is available'),
       ('OPD', 'Bonn', 'Sergery is available '),
	   ('Dental Department','Freiburg', 'Modern Dental equipments are available');



INSERT INTO  ALL_DOCTORS(DOC_NO, DEPARTMENT_Name)
VALUES (1,  'Dental Department'),
	   (2,  'Gynecology'), 
       (3,  'Neurology'),
       (4,  'OPD'),
	   (5,  'Sergery Deartment');



INSERT INTO DOC_REG(DOC_NO, D_NAME, Qualification, DOC_ADDRESS, PHONE_NUMBER, SALARY, DATE_OF_JOINING)
VALUES (1,  'Harini Prasadi', 'PhD',  'Susa Straﬂe Berlin', 003493443, 49990,'2020-02-15'),
	   (2,  'Susan Pereira', 'MBBS',  'Osler Straﬂe Bonn', 0034433, 49438,'2021-01-14'), 
       (3,  'Jane Smith','PhD',  'Osler Straﬂe Karlsruhe', 00345653, 49930,'2019-03-25');



INSERT INTO  DOC_ON_CALL(DOC_NO ,D_NAME ,Qualification, DOC_ADDRESS ,PHONE_NUMBER,FEES_PER_CALL)
VALUES ( 4, 'Oliver Nader','MBBS','18, O Straﬂe Bonn', 0049990, 300),
	   ( 5,  'Roher Nieder', 'MBBS', '58, Laune Straﬂe Bonn',003455433, 400);
       

 
INSERT INTO  PAT_ENTRY(PT_NO, PT_NAME, PT_AGE, SEX ,PHONE_NUMBER, PT_ADDRESS, PT_CITY, PT_ENTRY_DATE, REF_DOC_NO, REF_DEPARTMENT, DIAGNOSIS)
VALUES (10,  'Naomi Johnson', 72, 'F', 003434243,'48 Desrer Straﬂe Bonn','Kˆln','2020-01-15', 1, 'Dental Department', 'Upper Teeth Decay'),
	   (22,  'Emma Dietenberg', 36, 'F', 003464433, '78, Neiger Straﬂe Frankfurt', 'Frankfurt','2020-11-14',3,'Neurology', 'Nerve problems'), 
       (35,  'Alice Dudler', 67, 'F', 00345433, 'Osler Straﬂe Karlsruhe','Karlsruhe','2019-03-25', 5,'Sergery Deartment', 'Tumor'),
       (42,  'Oliver Hunter',22, 'M',  0034585343, '66, Nieder Straﬂe Freiburg', 'Freiburg', '2019-02-15', 4,'OPD', 'Operation side effects'),
	   (53,  'Hetti Jayawardena', 71, 'F',  0038886443, '54 Robert Straﬂe Kˆln', 'Kˆln','2018-08-15', 2, 'Gynecology','Sever menopause');


 

INSERT INTO  PAT_CHKUP(PT_NO, DOC_NO, PT_AGE, DATE_CHKUP, DIAGNOSIS, TREATMENT,PT_STATUS)
VALUES (10,  1, 72, '2020-01-15', 'Upper Teeth Decay','Operation','Still in Progress'),
	   (22,  3, 36, '2020-11-14', 'Nerve problems','Dental Department','Progressed'),
       (35,  5, 67, '2019-03-25', 'Throat Cancer','Operation','Progressing'),
       (42,  4, 22, '2019-02-15', 'Head Tumor','Operation','Operation side effects'),
	   (53,  2, 31, '2018-08-15', 'Pregnancy','Gynecology','Cured');



INSERT INTO  PAT_ADMIT(PT_NO, ADVANCED_PAYMENT, MODE_OF_PAYMENT, ROOM_NUMBER, DEPARTMENT_NAME, DATE_OF_ADMISSION, INIT_CONDITION, DIAGNOSIS, TREATMENT, DOC_NO, ATTENDANT_NAME)
VALUES (10,  200, 'Credit Card', 114, 'Dental Department','2020-01-15','Good', 'Upper Teeth Decay','Operation',1, 'Silvia'),
	   (22,  100, 'Credit Card', 113, 'Gynecology','2017-01-16', 'Worse', 'Nerve problems','Neurology',2, 'Robert'),
       (35,  300, 'Credit Card', 112, 'Neurology','2010-03-15', 'Worse', 'Tumor', 'Operation side effects', 3, 'Klaus'),
       (42,  400, 'Credit Card', 124, 'OPD','2020-01-15','Operation side effects','Worse','Sever menopause', 4, 'Mia'),
	   (53,  250, 'Credit Card', 164, 'Sergery Deartment','2019-03-23','¥Good','Sever menopause','Gynecology',5, 'Denter');



INSERT INTO  PAT_OPR(PT_NO, DATE_OF_ADMISSION, DATE_OF_OPERATION,  DOC_NO, DEPARTMENT, OPR_THEATER_NO, TYPE_OF_OPR, PT_CONDTION_BEFORE, PT_CONDTION_AFTER,TREATMENT_ADVICE)
VALUES (10, '2020-11-14', '2020-11-15', 1, 'Dental Department', 10, 'General', 'Unconcisouss', 'Conciouss', 'Recommeded medicine'),
	   (22, '2020-11-14', '2020-11-17', 2, 'Gynecology', 23, 'Complex','concisouss', 'Conciouss', 'Recommeded medicine'),
       (35, '2019-03-25', '2019-03-27', 3, 'Neurology', 34, 'Complex','concisouss', 'Still in progress', 'Recommeded medicine'),
       (42,  '2019-02-15', '2019-02-18', 4, 'OPD', 32, 'Simple','concisouss', 'concisouss', ' focus on side effects'),
	   (53,  '2018-08-15', '2018-08-18', 5, 'Sergery Department', 31, 'Complex','concisouss', 'stable', ' focus on side effects');


INSERT INTO  ROOM_DETAILS(ROOM_NO,ROOM_TYPE, ROOM_STATUS, PT_NO, PT_NAME, CHARGE_PER_DAY)
VALUES (734, 'P','Y', 10, 'Naomi Johnson', 400),
	   (222, 'G', 'N', NULL, NULL, 300), 
       (535,  'G', 'N', NULL, NULL, 100),
       (342, 'P', 'N', NULL, NULL, 400),
	   (523,  'G', 'N', NULL, NULL, 350);







SELECT * FROM DEPARTMENT;
SELECT * FROM ALL_DOCTORS;

SELECT * FROM DOC_REG
SELECT * FROM DOC_ON_CALL;
SELECT * FROM PAT_ENTRY;
SELECT * FROM PAT_ADMIT;
SELECT * FROM PAT_OPR;
SELECT * FROM ROOM_DETAILS;