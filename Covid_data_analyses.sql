Select * from
PortfolioProject.dbo.CovidDeaths
--where new_cases = '0' and continent is not Null
order by 1;

--Total cases vs total deaths
Select location, date, total_deaths,total_cases, (total_deaths/total_cases)* 100 as death_percentage from
PortfolioProject.dbo.CovidDeaths
--where location = 'India'
order by 1,2;


--Total cases vs population in India
Select location, date, population, total_cases, (total_cases/population)* 100 as PercentPopulationInfected from
PortfolioProject.dbo.CovidDeaths
--where location = 'India'
order by 1,2;

--Country's highest infection rate with population
Select location, max (total_cases) as HighestInfectionCount, population,  
((max (total_cases)/population)* 100) as PercentPopulationInfected from
PortfolioProject.dbo.CovidDeaths
group by location, population
order by PercentPopulationInfected desc; 

--Country's highest death count
--Here datatype of total_deaths is nvarchar so we have to change its datatype to int
Select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject.dbo.CovidDeaths
group by location
order by HighestDeathCount desc;
--Here in output we will get oaction as world and continent as well but we want only countries so we need to add one more condition

--Country's highest death count
Select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject.dbo.CovidDeaths
group by location, continent
having continent is not Null
order by HighestDeathCount desc;

--Country's highest death count another way
Select location, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject.dbo.CovidDeaths
where continent is not Null
group by location, continent
order by HighestDeathCount desc;

--Continent with highest death count
Select continent, max(cast(total_deaths as int)) as HighestDeathCount
from PortfolioProject.dbo.CovidDeaths
where continent is not Null
group by continent
order by HighestDeathCount desc;


--Globally

--Death perct across the world on diff days
Select date, sum(cast(new_cases as int)) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercent
from PortfolioProject..CovidDeaths
where continent is not Null
group by date
order by 1,2;

--death percent globally
Select sum(cast(new_cases as int)) as total_cases, sum(cast(new_deaths as int)) as total_deaths, 
sum(cast(new_deaths as int))/sum(new_cases)* 100 as DeathPercent
from PortfolioProject..CovidDeaths
where continent is not Null;


Select * from
PortfolioProject.dbo.CovidVaccinations
--where new_cases = '0' and continent is not Null
order by date;

--Joining both tables
Select * from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date;

--Total Population vs vaccinations
Select sum(dea.population) as TotalPopulation, sum(cast(vac.total_vaccinations as float)) as Total_vaccinations,
sum(cast(vac.people_fully_vaccinated as float)) as PeopleVaccinatedFully
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not Null;


--Population vs vaccinations on daily baises
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not Null
order by 2,3;


--Total Population vs vaccinations 
--CET
With PopVsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not Null
)
Select * , (RollingPeopleVaccinated/Population) *100 as VaccinatedPercent
from PopVsVac;


-- Using Temp Table to perform Calculation on Partition By in previous query
-- Using drop comand is a good practise otherwise if you run this command again with out without modifications you will get errors

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View to store data for later visualizations

Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null ;



