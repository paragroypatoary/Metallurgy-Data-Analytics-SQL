-- ====================================================================
-- PROJECT: FOUNDRY PRODUCTION METRICS & COST OPTIMIZATION
-- AUTHOR: PARAG ROY PATOARY (NIAMT RANCHI)
-- DESCRIPTION: INDUSTRY 4.0 DATA ANALYTICS FOR QUALITY CONTROL
-- ====================================================================

-- 1. Database Initialization
CREATE DATABASE NIAMT_Industrial_Project;
USE NIAMT_Industrial_Project;

-- 2. Creating Production Logs Table (Melt-shop Operations)
CREATE TABLE Production_Logs (
    Batch_ID INT PRIMARY KEY,
    Component_Name VARCHAR(50),
    Pouring_Temp_Celsius INT,
    Carbon_Percent DECIMAL(4,2),
    Silicon_Percent DECIMAL(4,2),
    Status VARCHAR(20)
);

-- 3. Creating Cost & Scrap Logs Table (Financial Impact)
CREATE TABLE Cost_Logs (
    Batch_ID INT,
    Raw_Material_Cost_INR INT,
    Electricity_Cost_INR INT,
    Scrap_Weight_KG INT,
    FOREIGN KEY (Batch_ID) REFERENCES Production_Logs(Batch_ID)
);

-- 4. Inserting Realistic Foundry Operational Dataset
INSERT INTO Production_Logs VALUES 
(101, 'Brake Drum', 1420, 3.45, 2.10, 'Passed'),
(102, 'Flywheel',   1380, 3.20, 1.85, 'Defective'),
(103, 'Brake Drum', 1450, 3.50, 2.15, 'Passed'),
(104, 'Cylinder Block', 1350, 3.10, 1.70, 'Defective'),
(105, 'Flywheel',   1410, 3.40, 2.05, 'Passed'),
(106, 'Brake Drum', 1390, 3.25, 1.90, 'Defective'),
(107, 'Cylinder Block', 1430, 3.55, 2.20, 'Passed');

INSERT INTO Cost_Logs VALUES 
(101, 15000, 4500, 0),
(102, 18000, 5000, 45),  
(103, 15500, 4600, 0),
(104, 25000, 7000, 85),  
(105, 17500, 5200, 0),
(106, 16000, 4800, 40),  
(107, 24500, 6800, 0);

-- ====================================================================
-- DATA ANALYTICS & INSIGHT QUERIES (FOR REPORT & PRESENTATION)
-- ====================================================================

-- Query 1: Defect Root Cause Analysis (Thermal & Chemical Windows)
SELECT Status, 
       AVG(Pouring_Temp_Celsius) AS Avg_Temperature_C, 
       AVG(Carbon_Percent) AS Avg_Carbon_Pct
FROM Production_Logs
GROUP BY Status;

-- Query 2: Financial Loss & Scrap Generation Analysis
SELECT P.Component_Name, 
       SUM(C.Raw_Material_Cost_INR + C.Electricity_Cost_INR) AS Total_Financial_Loss_INR,
       SUM(C.Scrap_Weight_KG) AS Total_Scrap_Generated_KG
FROM Production_Logs P
JOIN Cost_Logs C ON P.Batch_ID = C.Batch_ID
WHERE P.Status = 'Defective'
GROUP BY P.Component_Name;
