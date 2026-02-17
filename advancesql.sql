-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Feb 17, 2026 at 05:19 PM
-- Server version: 9.1.0
-- PHP Version: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `advancesql`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `GetProductsByCategory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `GetProductsByCategory` (IN `categoryName` VARCHAR(50))   BEGIN
    SELECT 
        ProductID, 
        ProductName, 
        Price
    FROM Products
    WHERE Category = categoryName;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `productarchive`
--

DROP TABLE IF EXISTS `productarchive`;
CREATE TABLE IF NOT EXISTS `productarchive` (
  `ProductID` int DEFAULT NULL,
  `ProductName` varchar(100) DEFAULT NULL,
  `Category` varchar(50) DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  `DeletedAt` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `productarchive`
--

INSERT INTO `productarchive` (`ProductID`, `ProductName`, `Category`, `Price`, `DeletedAt`) VALUES
(1, 'Keyboard', 'Electronics', 1350.00, '2026-02-17 17:17:39');

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `ProductID` int NOT NULL,
  `ProductName` varchar(100) DEFAULT NULL,
  `Category` varchar(50) DEFAULT NULL,
  `Price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`ProductID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`ProductID`, `ProductName`, `Category`, `Price`) VALUES
(2, 'Mouse', 'Electronics', 800.00),
(3, 'Chair', 'Furniture', 2500.00),
(4, 'Desk', 'Furniture', 5500.00);

--
-- Triggers `products`
--
DROP TRIGGER IF EXISTS `tr_AfterProductDelete`;
DELIMITER $$
CREATE TRIGGER `tr_AfterProductDelete` AFTER DELETE ON `products` FOR EACH ROW BEGIN
    INSERT INTO ProductArchive (ProductID, ProductName, Category, Price)
    VALUES (OLD.ProductID, OLD.ProductName, OLD.Category, OLD.Price);
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `sales`
--

DROP TABLE IF EXISTS `sales`;
CREATE TABLE IF NOT EXISTS `sales` (
  `SaleID` int NOT NULL,
  `ProductID` int DEFAULT NULL,
  `Quantity` int DEFAULT NULL,
  `SaleDate` date DEFAULT NULL,
  PRIMARY KEY (`SaleID`),
  KEY `ProductID` (`ProductID`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `sales`
--

INSERT INTO `sales` (`SaleID`, `ProductID`, `Quantity`, `SaleDate`) VALUES
(1, 1, 4, '2024-01-05'),
(2, 2, 10, '2024-01-06'),
(3, 3, 2, '2024-01-10'),
(4, 4, 1, '2024-01-11');

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_categorysummary`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vw_categorysummary`;
CREATE TABLE IF NOT EXISTS `vw_categorysummary` (
`AveragePrice` decimal(14,6)
,`Category` varchar(50)
,`TotalProducts` bigint
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_productpricing`
-- (See below for the actual view)
--
DROP VIEW IF EXISTS `vw_productpricing`;
CREATE TABLE IF NOT EXISTS `vw_productpricing` (
`Price` decimal(10,2)
,`ProductID` int
,`ProductName` varchar(100)
);

-- --------------------------------------------------------

--
-- Structure for view `vw_categorysummary`
--
DROP TABLE IF EXISTS `vw_categorysummary`;

DROP VIEW IF EXISTS `vw_categorysummary`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_categorysummary`  AS SELECT `products`.`Category` AS `Category`, count(`products`.`ProductID`) AS `TotalProducts`, avg(`products`.`Price`) AS `AveragePrice` FROM `products` GROUP BY `products`.`Category` ;

-- --------------------------------------------------------

--
-- Structure for view `vw_productpricing`
--
DROP TABLE IF EXISTS `vw_productpricing`;

DROP VIEW IF EXISTS `vw_productpricing`;
CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_productpricing`  AS SELECT `products`.`ProductID` AS `ProductID`, `products`.`ProductName` AS `ProductName`, `products`.`Price` AS `Price` FROM `products` ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
