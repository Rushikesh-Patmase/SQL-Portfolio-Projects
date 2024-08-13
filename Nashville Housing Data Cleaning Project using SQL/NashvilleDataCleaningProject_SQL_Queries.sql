/*

SQL Queries For Data Cleaning Project

*/

--select * from NashvilleHousing

----------------------------------------------------------------------------

-- Standarize Date Format

----------------------------------------------------------------------------

--select SaleDate, CONVERT(date, SaleDate)
--from NashvilleHousing

--update NashvilleHousing
--set SaleDate = CONVERT(date, SaleDate)

--Alter table NashvilleHousing
--add SaleDateConverted date;

--update NashvilleHousing
--set SaleDateConverted = CONVERT(date, SaleDate);

--select * from NashvilleHousing

--------------------------------------------------------------------------------

--Populate Property Address Data

--------------------------------------------------------------------------------

--select *
--from NashvilleHousing
----where PropertyAddress is null
--order by ParcelID

--select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress, b.PropertyAddress)
--from NashvilleHousing as a
--join NashvilleHousing as b
--on a.ParcelID = b.ParcelID
--and a.[UniqueID ] != b.[UniqueID ]
--where a.PropertyAddress is null

--update a
--set a.PropertyAddress = isnull(a.PropertyAddress, b.PropertyAddress)
--from NashvilleHousing as a
--join NashvilleHousing as b
--on a.ParcelID = b.ParcelID
--and a.[UniqueID ] != b.[UniqueID ]
--where a.PropertyAddress is null

--select * from NashvilleHousing

-------------------------------------------------------------------------------------

--Breaking out Address into individual columns (Area, City, State)

-------------------------------------------------------------------------------------

--select PropertyAddress, SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1) as Address,
--SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as State
--from NashvilleHousing

--alter table NashvilleHousing
--add PropertySplitAddress nvarchar(255), PropertySplitCity nvarchar(255);

--update NashvilleHousing
--set PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) - 1);

--update NashvilleHousing
--set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress));

--select * from NashvilleHousing

--alter table NashvilleHousing
--add OwnerSplitAddress nvarchar(255),
--OwnerSplitCity nvarchar(255),
--OwnerSplitState nvarchar(255);

--update NashvilleHousing
--set OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',', '.'),3)

--update NashvilleHousing
--set OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',' ,'.'), 2)

--update NashvilleHousing
--set OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'), 1)

--select * from NashvilleHousing
--where OwnerAddress is not null

--------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

--------------------------------------------------------------------------------

--select distinct(SoldAsVacant), count(SoldAsVacant) as Count
--from NashvilleHousing
--group by SoldAsVacant
--order by Count

--select SoldAsVacant,
--case when SoldAsVacant = 'Y' then 'Yes'
--	when SoldAsVacant = 'N' then 'No'
--	else SoldAsVacant
--end
--from NashvilleHousing

--update NashvilleHousing
--set SoldAsVacant = case when SoldAsVacant = 'Y' then 'Yes'
--	when SoldAsVacant = 'N' then 'No'
--	else SoldAsVacant
--	end

---------------------------------------------------------------------------

-- Remove Duplicates

---------------------------------------------------------------------------

--WITH RowNumCTE as (
--select *,
--	ROW_NUMBER() Over (
--	Partition By ParcelID,
--				PropertyAddress,
--				SalePrice,
--				SaleDate,
--				LegalReference
--				Order By
--				UniqueID ) row_num
--from NashvilleHousing
--)
--delete
--from RowNumCTE
--where row_num > 1
----order by ParcelID

--------------------------------------------------------------------------------

-- Delete unused columns

--------------------------------------------------------------------------------

--select *
--from NashvilleHousing

--alter table NashvilleHousing
--drop column PropertyAddress, TaxDistrict, SaleDate, OwnerAddress

--------------------------------------------------------------------------------