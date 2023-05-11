Select *
from [portfolio project] ..['covid death']
order by 3,4

--Select *
--from [portfolio project] ..['covid vaccination']
--order by 3,4

Select Location, date, total_cases, new_cases, total_deaths, population
from [portfolio project] ..['covid death']
order by 1,2

-- total cases vs total deaths
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from [portfolio project] ..['covid death']
where location like '%india%'
order by 1,2

--total cases vs population
Select Location, date, population, total_cases , (total_cases/population )*100 as DeathPercentage
from [portfolio project] ..['covid death']
where location like '%india%'
order by 1,2

-- looking at countries with highest infection rate compared to population
Select Location, population, MAX(total_cases) as HighestInfectionCount, MAX((total_cases/population ))*100 as PercentagePopulationInfectes
from [portfolio project] ..['covid death']
--where location like '%india%'
group by location, population
order by PercentagePopulationInfectes desc

-- showing countries with highest death count per population
Select Location, MAX(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project] ..['covid death']
--where location like '%india%'
where continent is not null
group by location
order by TotalDeathCount desc
 
-- BY CONTINENT
Select continent, MAX(cast(total_deaths as int)) as TotalDeathCount
from [portfolio project] ..['covid death']
--where location like '%india%'
where continent is not null
group by continent
order by TotalDeathCount desc

-- Global Numbers
Select  SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(new_cases) * 100 as DeathPercentage
from [portfolio project]..['covid death']
where continent is not null
--group by date
order by 1,2 

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(cast(vac.new_vaccinations as int)) OVER (Partition by dea.location)
from [portfolio project]..['covid death'] dea
join [portfolio project]..['covid vaccination'] vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by 2,3