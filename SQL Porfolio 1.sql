Select *
From PortfolioProject..['Covid Death']
order by 3,4

Select *
From PortfolioProject..['Covid Vaccinations']
order by 3,4




--Select Data that we are using
Select Location, date, total_cases, new_cases,total_deaths, population
From PortfolioProject..['Covid Death']
order by 1,2;



-- Total Cases vs Total Deaths
-- Show likelyhood in percentage to die in your country
Select Location, date, total_cases,total_deaths,round(total_deaths/total_cases*100,2) as 'DeathPercentage'
From PortfolioProject..['Covid Death']
where location like '%states%'
order by 1,2


 

-- Total Cases vs Total Population
-- Show the percentage of Population who got Covid
Select Location, date, total_cases,population,round((total_cases/population)*100,5) as 'PopulationCasePercentage'
From PortfolioProject..['Covid Death']
-- where location like '
order by 1,2



--Looking at country with highest infection rates
select  Location, MAX(total_cases) as HighestInfectionCount,population, ROUND(MAX(total_cases)/Population*100,2) as 'HighestPercentageInfection'
from PortfolioProject..['Covid Death']
GROUP BY location, population
Order BY HighestPercentageInfection desc



--Looking at country total death count
Select Location, max(cast(total_deaths as integer)) as TotalDeathCount
From PortfolioProject..['Covid Death']
where continent is not null
group by location 
	order by TotalDeathCount desc



-- Break things down by continent
Select continent, max(cast(total_deaths as integer)) as TotalDeathCount
From PortfolioProject..['Covid Death']
where continent is not null
group by continent 
order by TotalDeathCount desc



-- Looking at income
Select location, max(cast(total_deaths as integer)) as TotalDeathCount
From PortfolioProject..['Covid Death']
where location like '%income%' 
group by location
order by TotalDeathCount desc;


--Looking at country with highest death rates
select  Location, MAX(total_deaths) as HighestDeathCount,population, ROUND(MAX(total_deaths)/Population*100,2) as 'HighestDeathPercentage'
from PortfolioProject..['Covid Death']
GROUP BY location, population
Order BY HighestDeathPercentage desc


--Global number
select date, sum(cast(new_deaths as int)) as TotalDeathGlobally, sum(new_cases) as TotalCaseGlobally,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject..['Covid Death']
where continent is not null
GROUP BY date
Order by date;



--Look at the total vacination rates
--Using CTE
with popvsvac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated) as
(
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..['Covid Death'] dea
join PortfolioProject..['Covid Vaccinations'] vac
	On dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/Population)*100
from popvsvac



--Using Temptable
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert Into #PercentPopulationVaccinated
select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..['Covid Death'] dea
join PortfolioProject..['Covid Vaccinations'] vac
	On dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null;
--order by 2,3

select * from #PercentPopulationVaccinated



--Create a view
GO
Create view View1 as
(
Select dea.continent, dea.location, dea.date,dea.population,vac.new_vaccinations,
sum(convert(bigint,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..['Covid Death'] dea
join PortfolioProject..['Covid Vaccinations'] vac
	On dea.date = vac.date
	and dea.location = vac.location
where dea.continent is not null
)
--order by 2,3






