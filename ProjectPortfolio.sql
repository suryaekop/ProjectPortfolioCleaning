Select * From project_portfolio.dbo.Sheet1$;


-- Standarize Date Format
Select SaleDateConverted, CONVERT(date, SaleDate)
FROM project_portfolio..Sheet1$;

Update Sheet1$
SET SaleDate = CONVERT(date, SaleDate);

Alter Table Sheet1$
Add SaleDateConverted Date;

Update Sheet1$
SET SaleDateConverted = CONVERT(date, SaleDate);


--Populate Property Adress Data
Select *
FROM project_portfolio..Sheet1$
--where PropertyAddress is null;
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM project_portfolio..Sheet1$ a
JOIN project_portfolio..Sheet1$ b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null;

update a
set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
FROM project_portfolio..Sheet1$ a
JOIN project_portfolio..Sheet1$ b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


--Breaking out address into individual column (Address, City, State)
Select PropertyAddress
FROM project_portfolio..Sheet1$;
--where PropertyAddress is null;
--order by ParcelID

Select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress)) as Address
FROM project_portfolio..Sheet1$;


Alter Table Sheet1$
Add PropertySplitAddress Nvarchar(255);

Update Sheet1$
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1);

Alter Table Sheet1$
Add PropertySplitCity Nvarchar(255);

Update Sheet1$
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) + 1, LEN(PropertyAddress));



Select *
FROM project_portfolio..Sheet1$;

Select OwnerAddress
FROM project_portfolio..Sheet1$;

select
PARSENAME(Replace(OwnerAddress, ',', '.'),3),
PARSENAME(Replace(OwnerAddress, ',', '.'),2),
PARSENAME(Replace(OwnerAddress, ',', '.'),1)
FROM project_portfolio..Sheet1$;

Alter Table Sheet1$
Add OwnerSplitAddress Nvarchar(255);

Update Sheet1$
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress, ',', '.'),3)

Alter Table Sheet1$
Add OwnerSplitCity Nvarchar(255);

Update Sheet1$
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress, ',', '.'),2)

Alter Table Sheet1$
Add OwnerSplitState Nvarchar(255);

Update Sheet1$
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress, ',', '.'),1)

Select *
FROM project_portfolio..Sheet1$;


--Change Y and N to yes and no in "Sold as Vacant" Field
select distinct(SoldAsVacant), Count(SoldAsVacant)
FROM project_portfolio..Sheet1$
Group by SoldAsVacant
order by 2;



Select SoldAsVacant,
	Case 
		WHEN SoldAsVacant = 'Y' Then 'Yes'
		WHEN SoldAsVacant = 'N' Then 'No'
	ELse SoldAsVacant
	End
FROM project_portfolio..Sheet1$

Update Sheet1$
set SoldAsVacant = Case 
		WHEN SoldAsVacant = 'Y' Then 'Yes'
		WHEN SoldAsVacant = 'N' Then 'No'
	ELse SoldAsVacant
	End


-- Remove Duplicates

with RowNumCTE as (
select *,
	ROW_NUMBER() over(
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num
FROM project_portfolio..Sheet1$
--order by row_num desc
)

SELECT *
From RowNumCTE
where row_num > 1
--order by PropertyAddress


SELECT *
FROM project_portfolio..Sheet1$


--Delete Unsued Columns

SELECT *
FROM project_portfolio..Sheet1$

Alter Table Sheet1$
DROP COLUMN PropertyAddress, OwnerAddress, TaxDistrict

Alter Table Sheet1$
DROP COLUMN SaleDate