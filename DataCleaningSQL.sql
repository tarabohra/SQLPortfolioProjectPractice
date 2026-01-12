SELECT * FROM PortfolioProject..NashvilleHousing

SELECT SaleDateCoverted
FROM PortfolioProject..NashvilleHousing

UPDATE PortfolioProject..NashvilleHousing
SET SaleDateCoverted=CONVERT(DATETIME, SaleDate)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD SaleDateCoverted DATETIME

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN SaleDateCoverted

SELECT *
FROM PortfolioProject..NashvilleHousing
WHERE PropertyAddress IS NULL

SELECT a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.UniqueID <> b.UniqueID


UPDATE a
SET PropertyAddress=ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
	ON a.ParcelID=b.ParcelID
	AND a.UniqueID <> b.UniqueID
WHERE a.PropertyAddress IS NULL


SELECT 
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address, 
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) AS State
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertyAddressSplit NVARCHAR(255)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD PropertyCity NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET PropertyAddressSplit=SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

UPDATE PortfolioProject..NashvilleHousing
SET PropertyCity=SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) 

SELECT OwnerAddress
FROM PortfolioProject..NashvilleHousing

SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerAddressSplit NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerAddressSplit=PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerAddressCity NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerAddressCity=PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE PortfolioProject..NashvilleHousing
ADD OwnerAddressState NVARCHAR(255)

UPDATE PortfolioProject..NashvilleHousing
SET OwnerAddressState=PARSENAME(REPLACE(OwnerAddress,',','.'),1)

SELECT DISTINCT SoldAsVacant, COUNT(SoldAsVacant)
FROM PortfolioProject..NashvilleHousing
GROUP BY SoldAsVacant

SELECT SoldAsVacant,
CASE
	WHEN SoldAsVacant=0 THEN 'No'
	WHEN SoldAsVacant=1 THEN 'Yes'
END
FROM PortfolioProject..NashvilleHousing

ALTER TABLE PortfolioProject..NashvilleHousing
ALTER COLUMN SoldAsVacant NVARCHAR(3)

UPDATE PortfolioProject..NashvilleHousing
SET SoldAsVacant=
CASE
	WHEN SoldAsVacant=0 THEN 'No'
	WHEN SoldAsVacant=1 THEN 'Yes'
END

--REMOVE DUPLICATES

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY UniqueID
		) Row_No
FROM PortfolioProject..NashvilleHousing
)
SELECT * FROM RowNumCTE
WHERE Row_No>1

WITH RowNumCTE AS(
SELECT *,
	ROW_NUMBER() OVER(
	PARTITION BY 
		ParcelID,
		PropertyAddress,
		SalePrice,
		SaleDate,
		LegalReference
		ORDER BY UniqueID
		) Row_No
FROM PortfolioProject..NashvilleHousing
)
DELETE FROM RowNumCTE
WHERE Row_No>1

--DELETE UNUSED COLUMNS

ALTER TABLE PortfolioProject..NashvilleHousing
DROP COLUMN OwnerAddress, PropertyAddress

