Select SaleDate, CONVERT(Date, SaleDate) from
NashvilleHousing;

---It does not change the column values
Update NashvilleHousing
set SaleDate = CONVERT(Date, SaleDate);

--- Now we are addong new col in table and upadting it with correct date format 
Alter table NashvilleHousing
add SaleDatenew Date;

Update NashvilleHousing
set SaleDatenew = CONVERT(Date, SaleDate);

Select * from NashvilleHousing;

--- Now we can remove old date colm and change name of new date col
Alter table NashvilleHousing
drop column SaleDate;

Alter table NashvilleHousing
Change Column SaleDatenew to SaleDate;        ---not working

---Populating Proprty Address      
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress , ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null;

Update a 
Set a.PropertyAddress = ISNULL(a.PropertyAddress, b.PropertyAddress)
from NashvilleHousing a
join NashvilleHousing b 
on a.ParcelID = b.ParcelID
and a.[UniqueID ] != b.[UniqueID ]
where a.PropertyAddress is null;               ---now all null value are upadted the idea is that for same parcel id the property address must also same and unique id is uniue


---  Splitting property add into address and city
Select PropertyAddress, SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address from NashvilleHousing; 
Select PropertyAddress, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress)) as City from NashvilleHousing; 

Alter table NashvilleHousing
add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
set PropertySplitAddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) 
from NashvilleHousing;

Alter table NashvilleHousing
add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
set PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN(PropertyAddress))
from NashvilleHousing;

---  Splitting owner add into address and city and state
Select OwnerAddress, PARSENAME(Replace(OwnerAddress,',','.'),3) as Address from NashvilleHousing; 

Alter table NashvilleHousing
add OwnerSplitAddress Nvarchar(255);

Alter table NashvilleHousing
add OwnerSplitCity Nvarchar(255);

Alter table NashvilleHousing
add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
set  OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3);

Update NashvilleHousing
set  OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2);

Update NashvilleHousing
set  OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1);

---Change Y and N to yes and no in Soldasvacant
Select Distinct(SoldAsVacant) from NashvilleHousing;

--- This one note to remember how to use case in set
Update NashvilleHousing
set SoldAsVacant =
Case 
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end ;


---Remove dupliactes, though uniqueid is unique but still it may have same values for all cloumns     Note: not recommended on actual data use viwes or save real data first
--- here we can use widows functions like rownum and use CTE

With RownumCte as
(Select *, ROW_NUMBER() Over( Partition By ParcelID, PropertyAddress, SalePrice,SaleDatenew, LegalReference Order by UniqueId ) row
from NashvilleHousing) 

Select * from RownumCte
---Delete from RownumCte            --- to delete all duplicate values
where row > 1;


--- Remove unwanted columns  Note: not recommended on actual data, use viwes or save real data first
Select * from NashvilleHousing;

Alter table NashvilleHousing
drop Column TaxDistrict, PropertyAddress, OwnerAddress;