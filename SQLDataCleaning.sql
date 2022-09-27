/*In this project I will use numerous techniques to clean the data and analyis this data from different 
prospectus*/

use Projects

select * from ds_salaries

--The F1 column is just the index that is why we have to remove this.
alter table ds_salaries
drop column F1

--Now experience_level and many other column have the same short form.
--Let's check the unique values of experience_level column
select distinct(experience_level)
from ds_salaries

/*In this column EN means Entry-level
MI means Mid-level
SE means Senior
EX means Executive
*/
--Now let's change the values from short form to full form by creating procedure

select experience_level,
case when experience_level='EN' then 'Entry level'
	when experience_level='MI' then 'Mid level'
	when experience_level='SE' then 'Senior'
	when experience_level='EX' then 'Executive level'
	else experience_level
	end as FullForm
from ds_salaries

--Applying the changes into the original table
update ds_salaries
set experience_level=case when experience_level='EN' then 'Entry level'
	when experience_level='MI' then 'Mid level'
	when experience_level='SE' then 'Senior'
	when experience_level='EX' then 'Executive level'
	else experience_level
	end

select *
from ds_salaries

--Now the employment_type has some short form.
select distinct(employment_type)
from ds_salaries

/* There are four types of employees 
CT=Contract
FT=Full Time
PT=Part Time
FL=Freelance
*/
--Now let's change this into full forms

select employment_type,
case when employment_type='CT' then 'Contract'
	when employment_type='FL' then 'Freelance'
	when employment_type='FT' then 'Full Time'
	when employment_type='PT' then 'Part Time'
	else employment_type
	end
from ds_salaries

--Apply changes into original table
update ds_salaries
set employment_type=case when employment_type='CT' then 'Contract'
	when employment_type='FL' then 'Freelance'
	when employment_type='FT' then 'Full Time'
	when employment_type='PT' then 'Part Time'
	else employment_type
	end

select *
from ds_salaries


--Now company_size has some single word values that's need to be changed
select distinct(company_size)
from ds_salaries

/* There are 3 values that are unique
L=Large
M=Medium
S=Small
*/
--Now let's change these too
select company_size,
case when company_size='L' then 'Large'
	when company_size='M' then 'Medium'
	when company_size='S' then 'Small'
	else company_size
	end as Company_Size
from ds_salaries

--Apply Changes
update ds_salaries
set company_size=case when company_size='L' then 'Large'
	when company_size='M' then 'Medium'
	when company_size='S' then 'Small'
	else company_size
	end

select *
from ds_salaries

/* In this table there are a lot of irrelebant columns are there like 
salary the table has already salary_in_usd column so this column is just waste
another one that is salary_currency that is also not usefull at all because of salary_in_usd column
*/
--That is why we need to remove these columns

alter table ds_salaries
drop column salary,salary_currency

select *
from ds_salaries


/* Now lets change the remote_ratio column into varchar formate in which
0 means Not-Remote
50 means 50% remote and 50% not remote
100 means Remote
*/

select distinct(remote_ratio)
from ds_salaries

--Remote_ratio table is varchar so first I changed it into varchar
alter table ds_salaries 
alter column remote_ratio varchar(20)


select remote_ratio,
case when remote_ratio=0 then 'Not-Remote'
	when remote_ratio=50 then 'Medium level Remote'
	when remote_ratio=100 then 'Remote'
	else remote_ratio
	end as Job_ratio
from ds_salaries

--Apply changes
update ds_salaries
set remote_ratio=case when remote_ratio=0 then 'Not-Remote'
	when remote_ratio=50 then 'Medium level Remote'
	when remote_ratio=100 then 'Remote'
	else remote_ratio
	end


/*
Now the table has Country ISO codes for comapny_location column that's need to be fixed with Country names.
For this purpose I extracted ISO code and Country name from wikipedia by using Excel Query. 
*/

select *
from ds_salaries
order by company_location

--Now to get country name I join these two tables as self join

select * from Countries_with_ISO

--joining the tables
select names.[Country name]
from ds_salaries iso
inner join Countries_with_ISO names
on iso.company_location=names.[Alpha-2 code]

/*Updating the table with country names
*/

--Creating new column for less errors
alter table ds_salaries
add Companies_location varchar(100)

--Applying changes
update ds_salaries
set Companies_location=names.[Country name]
from ds_salaries iso
inner join Countries_with_ISO names
on iso.company_location=names.[Alpha-2 code]

select * from ds_salaries

/* Now in the same way the column name employee_residence has ISO codes.
That is why I change this too with inner join method
*/

select iso.[Country name],salary.employee_residence
from ds_salaries salary
inner join Countries_with_ISO iso
on salary.employee_residence=iso.[Alpha-2 code]

--Creating new column
alter table ds_salaries
add Employees_residence varchar(100)

--Updating the values
update ds_salaries
set Employees_residence=iso.[Country name]
from ds_salaries salary
inner join Countries_with_ISO iso
on salary.employee_residence=iso.[Alpha-2 code]

select * 
from ds_salaries
order by employee_residence

/*Now lets check the unique values of Employees_residence
*/
select distinct(Employees_residence)
from ds_salaries

/*Now here mostly countries has some issues as it has some unusuall letters with countries name.
So I use Case statement to remove this noise.
*/

select Employees_residence,
case when Employees_residence='Bolivia (Plurinational State of)' then 'Bolivia'
	when Employees_residence='Iran (Islamic Republic of)' then 'Iran'
	when Employees_residence='Moldova (the Republic of)' then 'Moldova'
	when Employees_residence='Netherlands (the)' then 'Netherland'
	when Employees_residence='Philippines (the)' then 'Philippine'
	when Employees_residence='Russian Federation (the)' then 'Russian Federation'
	when Employees_residence='United Arab Emirates (the)' then 'United Arab Emirate'
	when Employees_residence='United Kingdom of Great Britain and Northern Ireland (the)' then 'United Kingdom of Great Britain and Northern Ireland'
	when Employees_residence='United States of America (the)' then 'United State of America'
	else Employees_residence
	end
from ds_salaries


/*updating the column with new names
*/

update ds_salaries
set employee_residence=case when Employees_residence='Bolivia (Plurinational State of)' then 'Bolivia'
	when Employees_residence='Iran (Islamic Republic of)' then 'Iran'
	when Employees_residence='Moldova (the Republic of)' then 'Moldova'
	when Employees_residence='Netherlands (the)' then 'Netherland'
	when Employees_residence='Philippines (the)' then 'Philippine'
	when Employees_residence='Russian Federation (the)' then 'Russian Federation'
	when Employees_residence='United Arab Emirates (the)' then 'United Arab Emirate'
	when Employees_residence='United Kingdom of Great Britain and Northern Ireland (the)' then 'United Kingdom of Great Britain and Northern Ireland'
	when Employees_residence='United States of America (the)' then 'United State of America'
	else Employees_residence
	end

--Look for any error
select *
from ds_salaries

/* Now the issues are in Compnaies_location column so now I tackle this will same process
*/

select distinct(Companies_location)
from ds_salaries

select Companies_location,
case
	when Companies_location='Iran (Islamic Republic of)' then 'Iran'
	when Companies_location='Moldova (the Republic of)' then 'Moldova'
	when Companies_location='Netherlands (the)' then 'Netherland'
	when Companies_location='Russian Federation (the)' then 'Russian Federation'
	when Companies_location='United Arab Emirates (the)' then 'United Arab Emirate'
	when Companies_location='United Kingdom of Great Britain and Northern Ireland (the)' then 'United Kingdom of Great Britain and Northern Ireland'
	when Companies_location='United States of America (the)' then 'United State of America'
	else Companies_location
	end
from ds_salaries

--Applying the changes
update ds_salaries
set company_location=case
	when Companies_location='Iran (Islamic Republic of)' then 'Iran'
	when Companies_location='Moldova (the Republic of)' then 'Moldova'
	when Companies_location='Netherlands (the)' then 'Netherland'
	when Companies_location='Russian Federation (the)' then 'Russian Federation'
	when Companies_location='United Arab Emirates (the)' then 'United Arab Emirate'
	when Companies_location='United Kingdom of Great Britain and Northern Ireland (the)' then 'United Kingdom of Great Britain and Northern Ireland'
	when Companies_location='United States of America (the)' then 'United State of America'
	else Companies_location
	end


--Check for more clearance
select distinct(employee_residence)
from ds_salaries

select distinct(company_location)
from ds_salaries

--Now delete all the irrelevant columns from the table
alter table ds_salaries
drop column Companies_location,Employees_residence

select *
from ds_salaries

/*				Now data is cleaned				*/