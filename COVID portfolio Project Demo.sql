
SELECT * FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

--SELECT * FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

SELECT total_vaccinations FROM PortfolioProject..CovidVaccinations

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Looking for Total cases vs Total deaths in CHINA
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location like '%china%'
ORDER BY 1,2

-- Looking at Countries with Highest Infection Rate compared to population
SELECT Location, population, MAX(total_cases) AS HighestCount, MAX((total_cases/population))*100 AS 
PersentageInfected
FROM PortfolioProject..CovidDeaths
--WHERE Location like '%china%'
GROUP BY Location, population
ORDER BY PersentageInfected DESC

 -- Showing Countries with Highest Death Count per population
 SELECT location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
 FROM PortfolioProject..CovidDeaths
 WHERE continent IS NOT NULL
 GROUP BY location
 ORDER BY TotalDeathCount DESC

 -- Break down by continent
 -- Showing Continents with Highest Death Count per population
 SELECT continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
 FROM PortfolioProject..CovidDeaths
 WHERE continent IS NOT NULL
 GROUP BY continent
 ORDER BY TotalDeathCount DESC

 -- Global Numbers
 SELECT date, SUM(new_cases) AS New_cases, SUM(CAST(new_deaths AS int)),
 SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPersentage
 FROM PortfolioProject..CovidDeaths 
 WHERE continent IS NOT NULL
 GROUP BY date
 ORDER BY 1,2

 -- JOIN TWO TABLES
 -- Looking for the total population vs vaccinations
 SELECT p.continent, p.location, p.date, p.population, q.New_Vaccinations, 
 SUM(CAST(q.New_Vaccinations AS BIGINT)) OVER (Partition BY p.location ORDER BY p.location, p.date) AS 
 RollingPeopleVaccinated
 FROM PortfolioProject..CovidDeaths p JOIN PortfolioProject..CovidVaccinations q
 ON p.location = q.location AND p.date = q.date 
 WHERE p.continent IS NOT NULL
 ORDER BY 2,3

 -- Use CTE
 WITH PopulationVSVaccinations (Continent, Locaiton, Date, Population, New_Vaccinations, RollingPeopleVaccinated
 ) AS (SELECT p.continent, p.location, p.date, p.population, q.New_Vaccinations, 
 SUM(CAST(q.New_Vaccinations AS BIGINT)) OVER (Partition BY p.location ORDER BY p.location, p.date) AS 
 RollingPeopleVaccinated
 FROM PortfolioProject..CovidDeaths p JOIN PortfolioProject..CovidVaccinations q
 ON p.location = q.location AND p.date = q.date 
 WHERE p.continent IS NOT NULL
)
 SELECT * FROM PopulationVSVaccinations


 -- TEMP TABLE
 DROP TABLE IF EXISTS #PercentagePopulationVaccinated
 CREATE TABLE #PercentagePopulationVaccinated(
 Continent NVARCHAR(255),
 Location NVARCHAR(255),
 Date datetime,
 Population numeric,
 New_Vaccinations numeric,
 RollingPeopleVaccinated numeric)

 INSERT INTO #PercentagePopulationVaccinated
 SELECT p.continent, p.location, p.date, p.population, q.New_Vaccinations, 
 SUM(CAST(q.New_Vaccinations AS BIGINT)) OVER (Partition BY p.location ORDER BY p.location, p.date) AS 
 RollingPeopleVaccinated
 FROM PortfolioProject..CovidDeaths p JOIN PortfolioProject..CovidVaccinations q
 ON p.location = q.location AND p.date = q.date 
 WHERE p.continent IS NOT NULL
  
  SELECT *, (RollingPeopleVaccinated/Population)*100
  FROM #PercentagePopulationVaccinated

  -- create mutiple views for later visualizations
 CREATE VIEW PercentagePopulationVaccinated AS 
 SELECT p.continent, p.location, p.date, p.population, q.New_Vaccinations, 
 SUM(CAST(q.New_Vaccinations AS BIGINT)) OVER (Partition BY p.location ORDER BY p.location, p.date) AS 
 RollingPeopleVaccinated
 FROM PortfolioProject..CovidDeaths p JOIN PortfolioProject..CovidVaccinations q
 ON p.location = q.location AND p.date = q.date 
 WHERE p.continent IS NOT NULL

 SELECT * FROM PercentagePopulationVaccinated