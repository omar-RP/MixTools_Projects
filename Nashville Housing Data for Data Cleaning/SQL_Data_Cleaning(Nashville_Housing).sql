--Cleaning Data By using SQL Queries

SELECT * 
	FROM PortfolioProject.dbo.Nashville_Housing

------------------------------------------------

--1-Standarize Data Format

--change the "SalesDate" column format to more and remove any useless data from the cells

SELECT SaleDate, CAST(SaleDate AS date) 
	FROM PortfolioProject.dbo.Nashville_Housing

--OR

SELECT SaleDate, CONVERT(date, SaleDate) FROM PortfolioProject.dbo.Nashville_Housing


--NOTE : that make an extra column in the table beside the original one, BUT, we can modify the same table without adding any extra columns to the table.

--1st Solution
UPDATE PortfolioProject.dbo.Nashville_Housing
SET SaleDate = CONVERT(date,SaleDate)

SELECT SaleDateConverted 
	FROM PortfolioProject.dbo.Nashville_Housing
-- The Result (abviously it doesn't work at least with me and the column still with no modification)

--2nd Solution
ALTER TABLE PortfolioProject.dbo.Nashville_Housing
ADD SaleDateConverted Date;

UPDATE PortfolioProject.dbo.Nashville_Housing
SET SaleDateConverted = CONVERT(date,SaleDate)

SELECT SaleDate , SaleDateConverted
	FROM PortfolioProject.dbo.Nashville_Housing

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
DROP COLUMN SaleDate;

--THEN (Repeat & Modify )     

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
ADD SaleDate Date;

UPDATE PortfolioProject.dbo.Nashville_Housing
SET SaleDate  = CONVERT(date,SaleDateConverted)

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
DROP COLUMN SaleDateConverted;

SELECT SaleDate
	FROM PortfolioProject.dbo.Nashville_Housing

-- The Result (this solution was too long but it did accomplish the task perfectly )

---------------------------------------------------------------------------------------------------

--2-Populate Property Address Data

-- Starting With Reviewing Only The NULL Values In The "PropertyAddress" Column,THEN,
-- Have A Full Review Of The Columns Specialy The "ParcelID" To See That Null Addresses Have The Same "ParcelID" With Filled Adresses,SO
SELECT *
	FROM PortfolioProject.dbo.Nashville_Housing
	--WHERE PropertyAddress is null
	ORDER BY ParcelID

-- We Populate These Missing Data From The Filled Cells By FIRSTLY, Using Inner Join To The Same Table, to make sure that these "NULL" values have existed values that match the same "ParcelID"

SELECT a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress
	FROM PortfolioProject.dbo.Nashville_Housing AS a
	JOIN PortfolioProject.dbo.Nashville_Housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null

-- FINALY,WE updtae the original table by using the join tables method to fill the null cells with the correct values.
UPDATE a 
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	FROM PortfolioProject.dbo.Nashville_Housing AS a
	JOIN PortfolioProject.dbo.Nashville_Housing AS b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID ]
	WHERE a.PropertyAddress is null

-- we test the original table and no row appears after writing these lines searching for NULL values in the "PropertyAddress" column.
	SELECT *
	FROM PortfolioProject.dbo.Nashville_Housing
	WHERE PropertyAddress is null
	ORDER BY ParcelID

----------------------------------------------------------------------------------------------------------------------------------------

--3-Breaking Out Address Into Individual Columns (Address, City, State)

SELECT PropertyAddress
	FROM PortfolioProject.dbo.Nashville_Housing

--We SUBSTRING the address parts Based on The Delimeter Position (before and after it)
SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) AS address , 
SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress)) AS address
FROM PortfolioProject.dbo.Nashville_Housing 
	
ALTER TABLE PortfolioProject.dbo.Nashville_Housing
ADD PropertySplitAddress nvarchar(255);

UPDATE PortfolioProject.dbo.Nashville_Housing
SET PropertySplitAddress  = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
ADD PropertySplitCity nvarchar(255);

UPDATE PortfolioProject.dbo.Nashville_Housing
SET PropertySplitCity  = SUBSTRING(PropertyAddress, CHARINDEX(',' , PropertyAddress) +1, LEN(PropertyAddress))

-- Remove the original column and keep the new columns to represent the full address accurately .

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
DROP COLUMN PropertyAddress;

SELECT *
	FROM PortfolioProject.dbo.Nashville_Housing



--Note: will use a new function and way easier on the "OwnerAddress" Column (separating Address components to make it more Appropriate)

SELECT *
	FROM PortfolioProject.dbo.Nashville_Housing

SELECT OwnerAddress
	FROM PortfolioProject.dbo.Nashville_Housing

--NOTE:in the "PARSENAME" column, i will have to use "REPLACE" function as PARSENAME function only works with comma delimiter only and the delimiter here is a dot.
--Also, AS PARSENAME function is counting delimeters backward, i will start with the "THIRD" delimiter until the "FIRST" one .
SELECT
	PARSENAME(REPLACE(OwnerAddress,',', '.'),3),
	PARSENAME(REPLACE(OwnerAddress,',', '.'),2),
	PARSENAME(REPLACE(OwnerAddress,',', '.'),1)
	FROM PortfolioProject.dbo.Nashville_Housing

-- NOW, time to make these these changes permenant by altering and updating the table for the new columns .
ALTER TABLE PortfolioProject.dbo.Nashville_Housing
ADD OwnerSplitAddress nvarchar(255);

UPDATE PortfolioProject.dbo.Nashville_Housing
SET OwnerSplitAddress  = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
ADD OwnerSplitCity nvarchar(255);

UPDATE PortfolioProject.dbo.Nashville_Housing
SET OwnerSplitCity  = PARSENAME(REPLACE(OwnerAddress,',', '.'),2)

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
ADD OwnerSplitState nvarchar(255);

UPDATE PortfolioProject.dbo.Nashville_Housing
SET OwnerSplitState  = PARSENAME(REPLACE(OwnerAddress,',', '.'),1)

SELECT *
	FROM PortfolioProject.dbo.Nashville_Housing


---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- IMPORTANT NOTE : this time i won't delete the Original Column as i discovered that, most of the previous code lines the depend on the original column won't work again as the column dosn't exist anymore 
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--4- change the Y AND N to Yes AND No in "SoldAsVacant" column cells .

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
	FROM PortfolioProject.dbo.Nashville_Housing
	GROUP BY SoldAsVacant
	ORDER BY 2

--Now, i will use the "CASE" function to replace the "Y" and "N" with "YES" And "NO"
SELECT SoldAsVacant,
	CASE WHEN SoldAsVacant ='Y' THEN 'YES'
	WHEN SoldAsVacant ='N' THEN 'NO'
	ELSE SoldAsVacant
	END
	FROM PortfolioProject.dbo.Nashville_Housing

--NOW, i will update the table with the new modifications On The "SoldAsVacant" Column.
UPDATE PortfolioProject.dbo.Nashville_Housing
SET SoldAsVacant = CASE WHEN SoldAsVacant ='Y' THEN 'YES'
	WHEN SoldAsVacant ='N' THEN 'NO'
	ELSE SoldAsVacant
	END

--Checking the results	
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
	FROM PortfolioProject.dbo.Nashville_Housing
	GROUP BY SoldAsVacant
	ORDER BY 2


-----------------------------------------------------------------------------------------------------------------------------

--5-Remove Duplicates

-- i will use "ROW_NUMBER" To get rid of repeated and duplicate rows in my dataset.

WITH RowNumCTE AS (
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY ParcelID,
				PropertySplitAddress,
				PropertySplitCity,
				SalePrice,
				SaleDate,
				LegalReference
				ORDER BY UniqueID
				) row_num
	FROM PortfolioProject.dbo.Nashville_Housing
	)
SELECT *
	FROM RowNumCTE
	WHERE row_num > 1
	ORDER BY  PropertySplitAddress

----------------------------------------------------------------------------------------------------------------------------

--6- Delete Unused Columns

SELECT *
	FROM PortfolioProject.dbo.Nashville_Housing

ALTER TABLE PortfolioProject.dbo.Nashville_Housing
	DROP COLUMN OwnerAddress,TaxDistrict

SELECT *
	FROM PortfolioProject.dbo.Nashville_Housing

-----------------------------------------------------------------------














