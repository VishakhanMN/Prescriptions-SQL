
--------------------------2.1---------------------------------
CREATE DATABASE PrescriptionsDB;

Select * from dbo.Drugs;

Select * from dbo.Medical_Practice;

Select * from dbo.Prescriptions1;

CREATE TABLE Medical_Practice(
PRACTICE_CODE nvarchar(50) NOT NULL PRIMARY KEY,
PRACTICE_NAME nvarchar(50) NOT NULL,
ADDRESS_1 nvarchar(50) NOT NULL,
ADDRESS_2 nvarchar(50) NULL,
ADDRESS_3 nvarchar(50) NULL,
ADDRESS_4 nvarchar(50) NULL,
POSTCODE nvarchar(50) NOT NULL
);


CREATE TABLE Drugs(
BNF_CODE nvarchar(50) NOT NULL PRIMARY KEY,
CHEMICAL_SUBSTANCE_BNF_DESCR nvarchar(100) NOT NULL,
BNF_DESCRIPTION nvarchar(100) NOT NULL,
BNF_CHAPTER_PLUS_CODE nvarchar(100) NOT NULL
);

DROP TABLE Prescriptions
CREATE TABLE Prescriptions(
PRESCRIPTION_CODE int NOT NULL PRIMARY KEY,
PRACTICE_CODE nvarchar(50) NOT NULL,
BNF_CODE nvarchar(50) NOT NULL,
QUANTITY float NOT NULL,
ITEMS smallint NOT NULL,
ACTUAL_COST money NOT NULL
);

ALTER TABLE dbo.Prescriptions
ADD FOREIGN KEY (PRACTICE_CODE) REFERENCES Medical_Practice(PRACTICE_CODE);

ALTER TABLE dbo.Prescriptions
ADD FOREIGN KEY (BNF_CODE) REFERENCES Drugs(BNF_CODE);


INSERT INTO Medical_Practice
SELECT DISTINCT PRACTICE_CODE,PRACTICE_NAME,ADDRESS_1,ADDRESS_2,ADDRESS_3,ADDRESS_4,POSTCODE
From dbo.Medical_Practice1;

INSERT INTO Drugs
SELECT DISTINCT BNF_CODE,CHEMICAL_SUBSTANCE_BNF_DESCR,BNF_DESCRIPTION,BNF_CHAPTER_PLUS_CODE
From Drugs1;

INSERT INTO Prescriptions
SELECT DISTINCT PRESCRIPTION_CODE,PRACTICE_CODE,BNF_CODE,QUANTITY,ITEMS,ACTUAL_COST
FROM dbo.Prescriptions1;


Select * from Drugs;

Select * from Prescriptions;

Select * from Medical_Practice;

--------------------------2.2---------------------------------

Select * from Drugs where BNF_DESCRIPTION LIKE '%tablet%' or BNF_DESCRIPTION LIKE '%capsule%';


--------------------------2.3---------------------------------

Select ROUND(p.QUANTITY,1)*p.ITEMS AS Total_Quantity,m.PRACTICE_NAME,p.QUANTITY,p.ITEMS,p.PRACTICE_CODE
From Prescriptions p
INNER JOIN Medical_Practice m
ON p.PRACTICE_CODE = m.PRACTICE_CODE;

--------------------------2.4---------------------------------

Select distinct CHEMICAL_SUBSTANCE_BNF_DESCR AS Chemical_Substance from Drugs;


--------------------------2.5---------------------------------

Select COUNT(BNF_CHAPTER_PLUS_CODE) AS 'Prescription Count',d.BNF_CHAPTER_PLUS_CODE,
MAX(p.ACTUAL_COST) AS Max_Cost,MIN(p.ACTUAL_COST) AS Min_Cost,AVG(p.ACTUAL_COST) AS Average_Cost
from Drugs d
INNER JOIN Prescriptions p ON d.BNF_CODE = p.BNF_CODE
GROUP BY d.BNF_CHAPTER_PLUS_CODE;

--------------------------2.6---------------------------------
Select m.PRACTICE_NAME,p.ACTUAL_COST from Prescriptions p
INNER JOIN Medical_Practice m
ON p.PRACTICE_CODE = m.PRACTICE_CODE
Where ACTUAL_COST > 4000
ORDER BY p.ACTUAL_COST DESC;

--------------------------2.7 b---------------------------------
Select m.PRACTICE_NAME,COUNT(p.PRACTICE_CODE) AS 'Practice Code Count' from Prescriptions p
INNER JOIN Medical_Practice m
ON p.PRACTICE_CODE = m.PRACTICE_CODE
GROUP BY m.PRACTICE_NAME
HAVING COUNT(p.PRACTICE_CODE) >100;

--------------------------2.7 a---------------------------------
Select m.PRACTICE_NAME,p.ACTUAL_COST, IIF(ACTUAL_COST>=50,'Expensive','Not Expensive') AS 'Expense Status'
from Prescriptions p
INNER JOIN Medical_Practice m
ON p.PRACTICE_CODE = m.PRACTICE_CODE;

--------------------------2.7 d---------------------------------

SELECT m.PRACTICE_NAME, p.PRACTICE_CODE, p.ACTUAL_COST,p.QUANTITY,
  CASE 
     WHEN ACTUAL_COST*QUANTITY >= 2500 THEN 'Expensive'
     WHEN ACTUAL_COST*QUANTITY >=1000  AND ACTUAL_COST*QUANTITY < 2500 THEN 'Moderate'
     ELSE 'Inexpensive' 
  END AS Price_Category
FROM Prescriptions p
INNER JOIN Medical_Practice m
ON p.PRACTICE_CODE = m.PRACTICE_CODE;



SELECT p.PRACTICE_CODE,p.ACTUAL_COST,p.PRESCRIPTION_CODE,p.QUANTITY,m.PRACTICE_NAME FROM Prescriptions p
INNER JOIN Medical_Practice m
ON p.PRACTICE_CODE = m.PRACTICE_CODE
WHERE p.Quantity NOT BETWEEN 10 AND 50;

Select * from Prescriptions

--------------------------2.7 c---------------------------------

SELECT PRACTICE_NAME, ISNULL(ADDRESS_1,' ')+ISNULL(ADDRESS_2,' ')+ISNULL(ADDRESS_3,' ')+ISNULL(ADDRESS_4,' ')+POSTCODE AS 'Full Address'
FROM Medical_Practice
WHERE PRACTICE_NAME LIKE '[UTS]%';

--------------------------2.7 e---------------------------------

SELECT TOP 10 CHEMICAL_SUBSTANCE_BNF_DESCR, COUNT(CHEMICAL_SUBSTANCE_BNF_DESCR) AS 'Count of Chemical Substance'
FROM Drugs
GROUP BY CHEMICAL_SUBSTANCE_BNF_DESCR
ORDER BY COUNT(CHEMICAL_SUBSTANCE_BNF_DESCR) DESC

--------------------------2.7 f---------------------------------

Select m.PRACTICE_NAME,p.ACTUAL_COST,p.ITEMS,p.QUANTITY from Medical_Practice m
INNER JOIN Prescriptions p
ON p.PRACTICE_CODE = m.PRACTICE_CODE
WHERE m.ADDRESS_4 IN ('LANCASHIRE')
