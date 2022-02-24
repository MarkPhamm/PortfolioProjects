--Cleaning Data in SQl Queries
Select * 
from PortfolioProject..NashvilleHousing

-- Stanardize Date Formate
Select SaleDate, CONVERT(date,Saledate)
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SaleDate = CONVERT(date,Saledate)

ALTER TABLE NashvilleHousing
Add SalesDateConverted Date

Update NashvilleHousing
SET SalesDateConverted = CONVERT(date,Saledate)

--Populate property Address data
Select *
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

--Checking Null and replace Null Value
Select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from PortfolioProject..NashvilleHousing a
JOIN PortfolioProject..NashvilleHousing b
ON a.ParcelID = b.ParcelID
AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null

Select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

--Breaking out Address into Individual Columns(Address, City) using SUBSTRING and CHARINDEX
SELECT 
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(256)

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) 


ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(256)

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


--Breaking out OwnerAddress into Individual Columns(Address, City, State) using PARSENAME
select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3),
PARSENAME(REPLACE(OwnerAddress,',','.'),2),
PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject..NashvilleHousing

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(256)
Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(256)
Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(256)
Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress,',','.'),1)

Select*
from PortfolioProject..NashvilleHousing

--Change Y and N to Yes and No in "Sold as Vacant" field

Select distinct(SoldasVacant),Count(SoldasVacant)
from PortfolioProject..NashvilleHousing
Group by SoldAsVacant
order by 2

Select SoldasVacant,
	CASE 
	when SoldasVacant ='Y' THEN 'Yes'
	when SoldasVacant ='N' THEN 'NO'
	ELSE SoldasVacant
	ENd
from PortfolioProject..NashvilleHousing

Update NashvilleHousing
SET SoldAsVacant =
	CASE 
	when SoldasVacant ='Y' THEN 'Yes'
	when SoldasVacant ='N' THEN 'NO'
	ELSE SoldasVacant
	ENd

--Remove Duplicate
--Using CTE

with RowNumCTE as
(
select *,
		ROW_NUMBER() Over(
		PARTITION BY ParcelID,
					 PropertyAddress,
					 SalePrice,
					 SaleDate,
					 LegalReference
					 ORDER BY UniqueID
					 ) row_num
from PortfolioProject..NashvilleHousing
--order by ParcelID
)
delete from RowNumCTE
where row_num>2;
select * from RowNumCTE
where row_num>2;

--Delete Unused Columns
Select * 
from PortfolioProject..NashvilleHousin

ALTER TABLE PortfolioProject..NashvilleHousin
Drop Column OwnerAddress, TaxDistrict, PropertyAddress,SaleDate

