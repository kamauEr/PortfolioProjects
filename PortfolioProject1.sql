                                          /* An SQL Project that analyzez Kenya's COVID DATA

                 Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types   */
                                                            

-- Looking at Total Cases vs Total Deaths in the Country as at 2023-08-23.
-- Death percentage column - shows the Likely hood of dying if you contract covid in Kenya.

select location,date, total_cases,total_deaths,
(cast(total_deaths as float) / cast(total_cases as float))* 100 as "Death Percentage" 

from PortfolioProject..covidDeaths
where location = 'Kenya'
order by 1,2 

-- Looking at Total Cases vs Population.
-- Shows what percentage of population got covid.

select location,date, population, total_cases,
(cast(total_cases as float) / cast(population as float))* 100 as "Percentage of People infected with covid" 

from PortfolioProject..covidDeaths
where location like '%enya'
order by 1,2

-- looking at countries inn Africa with the highest infection rate compared to Population. 

select location, population, max(total_cases) as "Highest Infection Count",
max((cast(total_cases as float) / cast(population as float))) * 100 as " Maximum Percentage of People  with covid" 
from PortfolioProject..covidDeaths
where continent like '%frica'
group by population, location
order by " Maximum Percentage of People  with covid" desc

-- Showing African Countries with highest death count per population

select location, max(cast(total_deaths as int)) as "Total death count"
from PortfolioProject..covidDeaths
where continent like '%f_ica'
group by location
order by "Total death count" desc

-- Showing Continents with Highest Death Counts per Population

select continent, max(cast(total_deaths as int)) as "Total death count"
from PortfolioProject..covidDeaths
where continent is not null
group by continent
order by "Total death count"desc

-- Global COVID Numbers
select
date, SUM(new_cases) as "Total new cases per day", SUM(cast(new_deaths as int)) as "Total deaths per day" ,
sum(cast(new_deaths as int))/ nullif(sum(new_cases),0) * 100 as 'Death percentage'

from PortfolioProject..covidDeaths
-- where location = 'Kenya'
where continent is not null
group by date
order by 1,2

-- looking at total population vs total vaccinations

select dea.continent,dea.location,dea.date,
vac.new_vaccinations , sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location 
order by dea.location, dea.date ) as "rolling people vaccinated"
--, ('rolling people vaccinated'/population) *100
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVaccinations vac
	on dea.location = vac.location 
	and 
	dea.date = vac.date
where dea.continent is not null
order by 2,3

-- Using CTE 
with PopvsVac
(continent,location,date, population,new_vaccinations, "rolling people vaccinated")
as (
select dea.continent,dea.location,dea.date, dea.population,
vac.new_vaccinations , sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location 
order by dea.location, dea.date ) as "rolling people vaccinated"
--, ('rolling people vaccinated'/population) *100
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVaccinations vac
	on dea.location = vac.location 
	and 
	dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select * , ("rolling people vaccinated"/population)*100 as "Percentage of Vaccinated people"
from PopvsVac
where location = 'Kenya'

-- Temp table 

drop table if exists #percentpopulationvaccinated
create table #percentpopulationvaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
"rolling people vaccinated" numeric
)
insert into #percentpopulationvaccinated
select dea.continent,dea.location,dea.date, dea.population,
vac.new_vaccinations , sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location 
order by dea.location, dea.date ) as "rolling people vaccinated"
--, ('rolling people vaccinated'/population) *100
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVaccinations vac
	on dea.location = vac.location 
	and 
	dea.date = vac.date
where dea.continent is not null
--order by 2,3
select * , ("rolling people vaccinated"/population)*100 as "Percentage of Vaccinated people"
from  #percentpopulationvaccinated
where location = 'Kenya'
order by new_vaccinations desc

-- creating view to store date for later visualisations

create view percentagepopulationvaccinated
as 
select dea.continent,dea.location,dea.date, dea.population,
vac.new_vaccinations , sum(cast(vac.new_vaccinations as bigint)) over (partition by dea.location 
order by dea.location, dea.date ) as "rolling people vaccinated"
--, ('rolling people vaccinated'/population) *100
from PortfolioProject..covidDeaths dea
join PortfolioProject..covidVaccinations vac
	on dea.location = vac.location 
	and 
	dea.date = vac.date
where dea.continent is not null
-- order by 2,3
select * from percentagepopulationvaccinated


