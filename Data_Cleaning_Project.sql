 
 -- Cleaning Data in SQL Queries

 SELECT * FROM PortfolioProject..NashvilleHousing

 -- Standardize Date Format
 SELECT SaledateConverted, CONVERT(Date, Saledate)
 FROM PortfolioProject..NashvilleHousing

 UPDATE NashvilleHousing
 SET Saledate = CONVERT(Date, Saledate)

 ALTER TABLE NashvilleHousing
 ADD SaledateConverted Date;

 UPDATE NashvilleHousing
 SET SaledateConverted = CONVERT(Date, Saledate)

 -- Populate Property Address Data
 SELECT * FROM PortfolioProject..NashvilleHousing --WHERE PropertyAddress IS NOT NULL
 ORDER BY ParcelID

 -- Removing the duplicated Data
 SELECT p.ParcelID, p.PropertyAddress, q.ParcelID, q.PropertyAddress, ISNULL(p.PropertyAddress, q.PropertyAddress)
 FROM PortfolioProject..NashvilleHousing p JOIN PortfolioProject..NashvilleHousing q 
 ON p.ParcelID = q.ParcelID AND p.[UniqueID ] <> q.[UniqueID ]
 WHERE p.PropertyAddress IS NULL

 UPDATE p 
 SET PropertyAddress = ISNULL(p.PropertyAddress, q.PropertyAddress)
 FROM PortfolioProject..NashvilleHousing p JOIN PortfolioProject..NashvilleHousing q 
 ON p.ParcelID = q.ParcelID AND p.[UniqueID ] <> q.[UniqueID ]
 WHERE p.PropertyAddress IS NULL

 -- Breaking out Address into Individual colunms
 SELECT PropertyAddress
 FROM PortfolioProject..NashvilleHousing

 SELECT 
 SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 ) AS Address, 
 SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) AS Address
 FROM PortfolioProject..NashvilleHousing

 ALTER TABLE NashvilleHousing
 ADD PropertySplitAddress NVARCHAR(255);

 UPDATE NashvilleHousing
 SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1 )

 ALTER TABLE NashvilleHousing
 ADD PropertySplitCity NVARCHAR(255);

 UPDATE NashvilleHousing
 SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))

 --1808  FOX CHASE DR, GOODLETTSVILLE, TN
 SELECT 
 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3),
 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2),
 PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1) 
 FROM PortfolioProject..NashvilleHousing

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitAddress NVARCHAR(255);

 UPDATE NashvilleHousing
 SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitCity NVARCHAR(255);

 UPDATE NashvilleHousing
 SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

 ALTER TABLE NashvilleHousing
 ADD OwnerSplitState NVARCHAR(255);

 UPDATE NashvilleHousing
 SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

 SELECT *
 FROM PortfolioProject..NashvilleHousing

 -- Change Y AND N to YES AND NO in "Sold as Vacant" field
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant
ORDER BY 2

SELECT SoldAsVacant, CASE 
WHEN SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant END
FROM PortfolioProject..NashvilleHousing

UPDATE NashvilleHousing
SET SoldAsVacant = CASE 
WHEN SoldAsVacant = 'Y' THEN 'YES'
WHEN SoldAsVacant = 'N' THEN 'NO'
ELSE SoldAsVacant END

-- Remove Duplicates
WITH RowNumCTE AS(
SELECT *, ROW_NUMBER() OVER(PARTITION BY 
ParcelID, PropertyAddress, SaleDate, LegalReference ORDER BY UniqueID) Row_num
FROM PortfolioProject..NashvilleHousing 
--ORDER BY ParcelID
)
DELETE FROM RowNumCTE
WHERE Row_num > 1
--ORDER BY PropertyAddress

-- Delete unused columns
SELECT *
FROM PortfolioProject..NashvilleHousing 

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDate
