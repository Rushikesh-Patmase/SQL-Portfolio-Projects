select * from CovidDeaths
order by 3,4 desc

select * from CovidVaccinations
order by 3,4 desc

--Selecting the data that is going to be used

select location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths

--Total Cases vs Total Deaths
--Likelihood of dying by Covid-19 in your country

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from CovidDeaths
where location like '%india%'
order by 1,2

--Total Cases vs Population
--Shows the population affected by Covid-19

select location, date, total_cases, population, (total_cases/population)*100 as Affected_Population
from CovidDeaths
where location like '%india%'
order by 1,2

--Looking at the countries with highest Infected Population

select top 10 location, MAX(total_cases) as Highest_Infected_Count, population, Max((total_cases/population))*100 as Affected_Population
from CovidDeaths
group by location,population
order by Affected_Population desc

--Looking at the Countries with highest Death Count

select location, max(cast(total_deaths as int)) as High_Death_Count, population, max(total_deaths/population)*100 as Death_Percentage 
from CovidDeaths
where continent is not null
group by location, population
order by High_Death_Count desc

--Looking at the Highest Death Rate by Continent

select location, max(cast(total_deaths as int)) as Highest_death_count
from CovidDeaths
where continent is null
group by location
order by Highest_death_count desc

--Global Numbers of cases by date

select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths, sum(cast(new_deaths as int))/sum(new_cases) * 100 as Total_Death_Percentage
from CovidDeaths
where continent is not null
--group by date
order by Total_Death_Percentage

--Total Population VS Vaccination

with POPvsVAC (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date,
dea.population) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *, (RollingPeopleVaccinated/population)*100 as Vaccinated_Percentage 
from POPvsVAC



--Temp Table

DROP Table if exists #PercentPeopleVaccinated
create table #PercentPeopleVaccinated(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
Vaccinations numeric,
RollingPeopleVaccinated numeric)

Insert into #PercentPeopleVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date,
dea.population) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from #PercentPeopleVaccinated
order by 2,3

--Creating View to store data for later visualization

create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date,
dea.population) as RollingPeopleVaccinated
from CovidDeaths dea
join CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from PercentPopulationVaccinated
