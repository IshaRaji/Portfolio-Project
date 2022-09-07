Select *
From PortfolioProject..CovidDeaths$
Where continent is not null
Order By 3, 4


--Select *
--From PortfolioProject..CovidVac$
--Order By 3, 4

--select Data that we are going to be using 

Select Location, date, total_cases, total_deaths, population
From PortfolioProject..CovidDeaths$
Where continent is not null
order By 1,2


--Loking at the toatl cases v total deaths
--Shows likelihood of dying if you contract covid in your country 

Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as Deathpercenage
From PortfolioProject..CovidDeaths$
Where location like '%Ghana%'
Where continent is not null
order By 1,2

-- Looking at the Total Cases vs Population
-- Shows what pecentage of population

Select Location, date, population, total_cases, (total_cases/population)*100 as PercenagePopulationInfected
From PortfolioProject..CovidDeaths$
Where location like '%Ghana%'
Where continent is not null
order By 1,2

--Looking at countries with highest infection rates compared to Population 

 Select continent, population, Max(total_cases)as HighestInfectionCount, Max(total_cases/population)*100 as PercenagePopulationInfected
From PortfolioProject..CovidDeaths$
--Where location like '%Ghana%'
Where continent is not null
Group By continent, Population
order By PercenagePopulationInfected desc


--Showing Countries With Death Count per Population

Select continent, Max(cast(total_deaths as int)) As TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%Ghana%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc

--Let's Break Things Down By Continent

--Showing The Continent With The Highest Death Count per Population


Select continent, Max(cast(total_deaths as int)) As TotalDeathCount
From PortfolioProject..CovidDeaths$
--Where location like '%Ghana%'
Where continent is not null
Group By continent
Order By TotalDeathCount desc


-- Global Numbers 

Select date, Sum(new_cases)as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as Deathpercenage
From PortfolioProject..CovidDeaths$
--Where location like '%Ghana%'
Where continent is not null
Group By date
order By 1,2

Select Sum(new_cases)as total_cases, Sum(cast(new_deaths as int)) as total_deaths, Sum(cast(new_deaths as int))/Sum(new_cases)*100 as Deathpercenage
From PortfolioProject..CovidDeaths$
--Where location like '%Ghana%'
Where continent is not null
--Group By date
order By 1,2



--Looking At Total Populationvs Vaccination 

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order By dea.location, dea.Date) as RollingpeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVac$ vac
  On dea.location = vac.location
   and dea.date =vac.date
   where dea.continent is not null
   Order By 2,3

-- USE CTE
With PopvsVac (Continent, Location, Date, Population, New_vaccination, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order By dea.location, dea.Date) as RollingpeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVac$ vac
  On dea.location = vac.location
   and dea.date =vac.date
   where dea.continent is not null
   --Order By 2,3
   )
   Select *, (RollingPeopleVaccinated/Population)*100
   From PopvsVac


   --TEMP TABLE

   Create Table #PercentPopulationVaccinated
   (
   Continent nvarchar(255),
   Location nvarchar(255),
   Date datetime,
   Population numeric,
   New_vaccinated numeric,
   RollingPeopleVaccinated numeric
   )

   Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order By dea.location, dea.Date) as RollingpeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVac$ vac
  On dea.location = vac.location
   and dea.date =vac.date
   where dea.continent is not null
   --Order By 2,3

   Select *, (RollingPeopleVaccinated/Population)*100
   From #PercentPopulationVaccinated



--Creating View To Store data For later Visualization

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, Sum(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order By dea.location, dea.Date) as RollingpeopleVaccinated
From PortfolioProject..CovidDeaths$ dea
Join PortfolioProject..CovidVac$ vac
  On dea.location = vac.location
   and dea.date =vac.date
   where dea.continent is not null
   --Order By 2,3