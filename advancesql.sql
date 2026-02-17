-- create table product
--
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

-- insert into product
--
INSERT INTO Products VALUES
(1, 'Keyboard', 'Electronics', 1200),
(2, 'Mouse', 'Electronics', 800),
(3, 'Chair', 'Furniture', 2500),
(4, 'Desk', 'Furniture', 5500);

-- create table sales
--
CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleDate DATE,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- insert into sales table
--
INSERT INTO Sales VALUES
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'),
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11');

-- question 6
--
WITH ProductRevenue AS (
    SELECT 
        P.ProductName,
        P.Category,
        (S.Quantity * P.Price) AS TotalRevenue
    FROM Sales S
    JOIN Products P ON S.ProductID = P.ProductID
)
SELECT 
    ProductName, 
    Category, 
    TotalRevenue
FROM ProductRevenue
WHERE TotalRevenue > 3000;

-- question 7
CREATE VIEW vw_CategorySummary AS
SELECT 
    Category,
    COUNT(ProductID) AS TotalProducts,
    AVG(Price) AS AveragePrice
FROM Products
GROUP BY Category;

SELECT * FROM vw_CategorySummary;

-- question 8
CREATE VIEW vw_ProductPricing AS
SELECT 
    ProductID, 
    ProductName, 
    Price
FROM Products;

-- to check
UPDATE vw_ProductPricing
SET Price = 1350
WHERE ProductID = 1;

-- question 9
DELIMITER //

CREATE PROCEDURE GetProductsByCategory(IN categoryName VARCHAR(50))
BEGIN
    SELECT 
        ProductID, 
        ProductName, 
        Price
    FROM Products
    WHERE Category = categoryName;
END //

DELIMITER ;


-- question 10
-- create archive table
--
CREATE TABLE ProductArchive (
    ProductID INT,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10, 2),
    DeletedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELIMITER //

-- create alter table
--
CREATE TRIGGER tr_AfterProductDelete
AFTER DELETE ON Products
FOR EACH ROW
BEGIN
    INSERT INTO ProductArchive (ProductID, ProductName, Category, Price)
    VALUES (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price);
END //

DELIMITER ;

-- to check
DELETE FROM Products WHERE ProductID = 1;
