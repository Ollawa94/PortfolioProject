select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4

--selecting data we are using

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- looking at total cases vs total deaths
-- shows likelihood of dying if you contract covid in your country

select location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like'%states%'
and continent is not null
order by 1,2

-- looking at Total cases vs Population - shows what percentage of poupulation got covid

select location, date, total_cases,population, (total_cases/population)*100
as Percentpopulationinfected
from PortfolioProject..CovidDeaths
where location like'%states%'
and continent is not null
order by 1,2

-- looking at countries with highest infexction rate compared to population

select continent, population, max(total_cases) as HighestInfectionCount, max((total_cases/population))*100
as Percentpopulationinfected
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent, population
order by Percentpopulationinfected desc

-- showing countries with highest death count per population

select continent, max(cast(total_deaths as int)) as TotaldeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotaldeathCount desc

-- Lets break things down by continent 
-- showing continent with the highest death count

select continent, max(cast(total_deaths as int)) as TotaldeathCount
from PortfolioProject..CovidDeaths
where continent is not null
Group by continent
order by TotaldeathCount desc

--select location, max(cast(total_deaths as int)) as TotaldeathCount
--from PortfolioProject..CovidDeaths
--where continent is null
--Group by location
--order by TotaldeathCount desc

-- Global Numbers

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100
as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
Group by Date
order by 1,2

-- Getting total cases acorss the world

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths,
sum(cast(new_deaths as int))/sum(new_cases)*100
as DeathPercentage
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

-- Looking at Total Population vs Vaccination
select *
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date


select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int))
over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 1,2,3

-- Use CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int))
over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
)
select*, (RollingPeopleVaccinated/population)*100 as PercentageRPV
from PopvsVac

-- Temp Table

-- drop table if exist  #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated(
continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

insert into #PercentPopulationVaccinated

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int))
over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 1,2,3
select*, (RollingPeopleVaccinated/population)*100 as PercentageRPV
from #PercentPopulationVaccinated

-- Create view to store data for later visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int))
over (Partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null


select*
from PercentPopulationVaccinated