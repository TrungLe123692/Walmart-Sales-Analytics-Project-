/*
	  --Data Cleaning--
							*/


--Date Standardization


Select SaleDate, CONVERT(date, SaleDate) from nashville_housing


ALTER TABLE nashville_housing
ALTER COLUMN SaleDate date;


--Null Address population


Select * from nashville_housing
where PropertyAddress is NULL


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) as PropertyAddressCorrected
from nashville_housing a
join nashville_housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
and a.PropertyAddress is NUll


Update a
set a.PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from nashville_housing a
join nashville_housing b
on a.ParcelID = b.ParcelID
and a.[UniqueID ] <> b.[UniqueID ]
and a.PropertyAddress is NUll


-- Breaking Address into Segments (Address, City, State)


Select SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1) as Address, 
SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress)) as City
from nashville_housing


Alter Table nashville_housing
add PropertyStreetAddress varchar(255)


Update nashville_housing
set PropertyStreetAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',', PropertyAddress)-1)


Alter Table nashville_housing
add PropertyCity varchar(255)


Update nashville_housing
set PropertyCity = SUBSTRING(PropertyAddress,CHARINDEX(',', PropertyAddress)+1,LEN(PropertyAddress))


Select PARSENAME(REPLACE(OwnerAddress,',','.'), 1)
from nashville_housing


Alter Table nashville_housing
add OwnerStreetAddress varchar(255),
OwnerCity varchar(255),
OwnerState varchar(255)


Update nashville_housing
set OwnerStreetAddress = PARSENAME(REPLACE(OwnerAddress,',','.'), 3),
OwnerCity = PARSENAME(REPLACE(OwnerAddress,',','.'), 2),
OwnerState = PARSENAME(REPLACE(OwnerAddress,',','.'), 1)


--Remove inconsistencies in SoldAsVacant Bool-type Column


Select distinct(SoldAsVacant), count(SoldAsVacant)
from nashville_housing
group by SoldAsVacant


Update nashville_housing
set SoldAsVacant = Case 
When SoldAsVacant = 'N' THEN 'No'
When SoldAsVacant = 'Y' THEN 'Yes'
else SoldAsVacant
End


--Remove Duplicates


With MarkDuplicates as (
Select *, 
	ROW_NUMBER() over (
	PARTITION BY ParcelID,
	PropertyAddress,
	SaleDate,
	SalePrice,
	LegalReference
	Order By UniqueID 
	) RowNum
from nashville_housing
)

Delete from MarkDuplicates
where RowNum > 1


--Remove unused columns


Alter Table nashville_housing
Drop column PropertyAddress, OwnerAddress, TaxDistrict


/*

	Cleaning Completed

						 */


Select * from nashville_housing
