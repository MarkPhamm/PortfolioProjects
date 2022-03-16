select * from [PortfolioProject]..data_cleaned_2021$

select * from [PortfolioProject]..data_cleaned_2021$
order by [Avg Salary(K)] desc

--Count the numbers of title
select count(distinct [Job Title]) 
from [PortfolioProject]..data_cleaned_2021$

select count(distinct [company_txt]) 
from [PortfolioProject]..data_cleaned_2021$

Select distinct( [Sector]) 
from [PortfolioProject]..data_cleaned_2021$

Alter table [PortfolioProject]..data_cleaned_2021$
drop column [index],[Hourly],[Competitors],[Employer provided],[Job Description],[job_title_sim],[seniority_by_title]

Alter table [PortfolioProject]..data_cleaned_2021$
RENAME COLUMN  [Job Location] to 'State'


--Data Cleaning
--Drop Columns
alter table [PortfolioProject]..data_cleaned_2021$
drop column [Rating],[Salary Estimate],[Company Name],[Size],[Founded],[Type of ownership],[Revenue],[Age],[sas],[pytorch],[tensor],[hadoop],[flink],[mongo],[Degree],[keras]
--Check out jobs where the location is the same as the Headquarters
select * 
from [PortfolioProject]..data_cleaned_2021$
where Location = Headquarters

--Remove all job data where average salary is lower than 75k
delete from [PortfolioProject]..data_cleaned_2021$
where [Avg Salary(k)] < 75



Alter table [PortfolioProject]..data_cleaned_2021$
Alter column [Python] varchar

update [PortfolioProject]..data_cleaned_2021$
set [Python] = 'Y' 
where [Python] = '1'

update [PortfolioProject]..data_cleaned_2021$
set [Python] = 'N' 
where [Python] = '0'

Alter table [PortfolioProject]..data_cleaned_2021$
Alter column [aws] varchar

update [PortfolioProject]..data_cleaned_2021$
set [aws] = 'Y' 
where [aws]= '1'

update [PortfolioProject]..data_cleaned_2021$
set [aws] = 'N' 
where [aws] = '0'

Alter table [PortfolioProject]..data_cleaned_2021$
Alter column [spark] varchar

update [PortfolioProject]..data_cleaned_2021$
set [spark] = 'Y' 
where [spark]= '1'

update [PortfolioProject]..data_cleaned_2021$
set [spark] = 'N' 
where [spark] = '0'

Alter table [PortfolioProject]..data_cleaned_2021$
Alter column [sql] varchar

update [PortfolioProject]..data_cleaned_2021$
set [sql] = 'Y' 
where [sql]= '1'

update [PortfolioProject]..data_cleaned_2021$
set [sql] = 'N' 
where [sql] = '0'

Alter table [PortfolioProject]..data_cleaned_2021$
Alter column [excel] varchar

update [PortfolioProject]..data_cleaned_2021$
set [excel] = 'Y' 
where [excel]= '1'

update [PortfolioProject]..data_cleaned_2021$
set [excel] = 'N' 
where [excel] = '0'

Alter table [PortfolioProject]..data_cleaned_2021$
Alter column [excel] varchar

update [PortfolioProject]..data_cleaned_2021$
set [excel] = 'Y' 
where [excel]= '1'

update [PortfolioProject]..data_cleaned_2021$
set [excel] = 'N' 
where [excel] = '0'

Alter table [PortfolioProject]..data_cleaned_2021$
Alter column [tableau] varchar

update [PortfolioProject]..data_cleaned_2021$
set [tableau] = 'Y' 
where [tableau]= '1'

update [PortfolioProject]..data_cleaned_2021$
set [tableau] = 'N' 
where [tableau] = '0'

Alter table [PortfolioProject]..data_cleaned_2021$
Alter column [bi] varchar

update [PortfolioProject]..data_cleaned_2021$
set [bi] = 'Y' 
where [bi]= '1'

update [PortfolioProject]..data_cleaned_2021$
set [bi] = 'N' 
where [bi] = '0'




--Data Exploration

--Look at the salary of different types of Job Title: Acturial and Machine Learning seems to be a good fit
select distinct [Job Title], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerTitle, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
--where [Job Title] like 'Data Scientist%' 
group by [Job Title]
order by 2 desc

--Look at sector: remove all sectors that not fit interest, Techonlogy, Finance, and Insurance would be an ideal fit,
Select distinct( [Sector]) 
from [PortfolioProject]..data_cleaned_2021$

delete from [PortfolioProject]..data_cleaned_2021$
where [Sector] IN ('Agriculture & Forestry','Telecommunications','Biotech & Pharmaceuticals','Media','-1','Education','Travel & Tourism','Health Care','Agriculture & Forestry','Government')

select distinct [Sector], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerSector, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [Sector]
order by 2 desc

--Look at industry: Financial Analytics & Research would be an ideal fit
select distinct [Industry], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerIndustry, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [Industry]
order by 2 desc

--Look at companies: Visa Inc will be the best choice
select distinct [company_txt], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerCompany, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [company_txt]
having COUNT([Job Title]) >= 3
order by 2 desc


--Look at different skill
--Python skill increase salary by around 20%
select distinct [Python], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerLocation, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [Python]
having COUNT([Job Title]) >= 3
order by 2 desc

--aws increase salary by around 10%
select distinct [aws], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerLocation, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [aws]
having COUNT([Job Title]) >= 3
order by 2 desc

--People who don't know SQL actually earn more than people who do
select distinct [sql], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerLocation, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [sql]
having COUNT([Job Title]) >= 3

--People who don't know Excel actually earn more than people who do
select distinct [excel], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerLocation, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [excel]
having COUNT([Job Title]) >= 3
order by 2 desc

--People who don't know Tableau actually earn more than people who do
select distinct [tableau], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerLocation, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [tableau]
having COUNT([Job Title]) >= 3
order by 2 desc

--scikit increase salary by around 10%
select distinct [scikit], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerLocation, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [scikit]
having COUNT([Job Title]) >= 3
order by 2 desc



--Look at location and state
--Take a look at salary at different Location
select distinct [Location], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerLocation, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [Location]
having COUNT([Job Title]) >= 3
order by 2 desc

--Take a look at salary at different states: California and Illinois take first place
select distinct [Job Location], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerLocation, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [Job Location]
having COUNT([Job Title]) >= 3
order by 2 desc


--Using CTE and dense-rank to filter the top salary

select * from
(
select distinct [Sector], round(AVG([Avg Salary(k)]),2)*1000 as AverageSalaryPerSector, COUNT([Job Title]) as NumberOfJobRecord
from [PortfolioProject]..data_cleaned_2021$
group by [Sector]
having round(AVG([Avg Salary(k)]),2)*1000 > 100000
) as t
order by 2 desc


