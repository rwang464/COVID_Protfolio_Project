
SELECT * FROM PortfolioProject..CovidDeaths
ORDER BY 3,4

--SELECT * FROM PortfolioProject..CovidVaccinations
--ORDER BY 3,4

SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location like '%china%'
ORDER BY 1,2

SELECT Location, population, MAX(total_cases) AS HighestCount, MAX((total_cases/population))*100 AS 
PersentageInfected
FROM PortfolioProject..CovidDeaths
--WHERE Location like '%china%'
GROUP BY Location, population
ORDER BY 1,2

 SELECT location, MAX(CAST(total_deaths as int)) AS TotalDeathCount
 FROM PortfolioProject..CovidDeaths
 WHERE continent IS NOT NULL
 GROUP BY location
 ORDER BY TotalDeathCount DESC

 SELECT continent, MAX(CAST(total_deaths as int)) AS TotalDeathCount
 FROM PortfolioProject..CovidDeaths
 WHERE continent IS NOT NULL
 GROUP BY continent
 ORDER BY TotalDeathCount DESC


 SELECT date, SUM(new_cases) AS New_cases, SUM(CAST(new_deaths AS int)),
 SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPersentage
 FROM PortfolioProject..CovidDeaths 
 WHERE continent IS NOT NULL
 GROUP BY date
 ORDER BY 1,2

 SELECT p.continent, p.location, p.date, p.population
 FROM PortfolioProject..CovidDeaths p JOIN PortfolioProject..CovidVaccinations q
 ON p.location = q.location AND p.date = q.date 
 WHERE p.continent IS NOT NULL
 ORDER BY 2,3

