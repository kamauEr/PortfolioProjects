/* Cleaning Data in SQL Queries */

select * 
from PortfolioProject..NashvilleHousing

-- Standardizing the Date Format 

select SaleDateConverted, CONVERT(date,SaleDate)
from PortfolioProject.dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = CONVERT(date,SaleDate) 

alter table NashvilleHousing 
add SaleDateConverted date;

update NashvilleHousing
set SaleDateConverted = CONVERT(date,SaleDate) 

-- Populate Property Adress Column

select *
from PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, 
ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject..NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]

-- where a.PropertyAddress is null

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
from PortfolioProject.dbo.NashvilleHousing a
join PortfolioProject..NashvilleHousing b
    on a.ParcelID = b.ParcelID
	and a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null 

-- Breaking out Address into Individual Columns

select * 
from PortfolioProject..NashvilleHousing

select 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress)) as Address

from PortfolioProject..NashvilleHousing  

alter table NashvilleHousing 
add PropertySplitAddress nvarchar(255);

update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

alter table NashvilleHousing 
add PropertySplitCity nvarchar(255); 

update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress) +1, len(PropertyAddress))

select * 
from PortfolioProject..NashvilleHousing


select OwnerAddress
from PortfolioProject..NashvilleHousing 

select 
ParseName(Replace(OwnerAddress,',' , '.'),3),
ParseName(Replace(OwnerAddress,',' , '.'),2),
ParseName(Replace(OwnerAddress,',' , '.'),1)


from PortfolioProject..NashvilleHousing


alter table NashvilleHousing 
add OwnerSplitAddress nvarchar(255);

update NashvilleHousing
set OwnerSplitAddress = ParseName(Replace(OwnerAddress,',' , '.'),3)


alter table NashvilleHousing 
add OwnerSplitCity nvarchar(255);

update NashvilleHousing
set OwnerSplitCity = ParseName(Replace(OwnerAddress,',' , '.'),2)


alter table NashvilleHousing 
add OwnerSplitState nvarchar(255);

update NashvilleHousing
set OwnerSplitState = ParseName(Replace(OwnerAddress,',' , '.'),1)


-- Clean the Y and N to Yes and NO 

select distinct(SoldAsVacant),COUNT(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
, Case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = Case when SoldAsVacant = 'Y' then 'Yes'
		when SoldAsVacant = 'N' then 'No'
		else SoldAsVacant
end

-- Remove Duplicates 

with rowNumCTE as (
select *,
ROW_NUMBER()over (
Partition by ParcelID,
			PropertyAddress,
			SalePrice,
			SaleDate,
			LegalReference
			order by 
			UniqueID) row_num

from PortfolioProject..NashvilleHousing
-- order by ParcelID
)
select *
from rowNumCTE
where row_num > 1
-- order by PropertyAddress

-- Delete Unused Columns

select * 
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing 
drop column SaleDate,OwnerAddress,TaxDistrict,PropertyAddress

