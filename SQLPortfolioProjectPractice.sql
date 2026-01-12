SELECT * FROM PortfolioProject..CovidVaccinations


SELECT * FROM PortfolioProject..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 3,4;


SELECT Location, date, total_cases, population, (total_cases/population)*100 as totalCasesPercentage
FROM PortfolioProject..CovidDeaths
WHERE Location='India'
ORDER BY 1,2

SELECT Location, AVG(total_deaths) AS Avg_Deaths
FROM PortfolioProject..CovidDeaths
WHERE Location='India'

SELECT Location, MAX(total_deaths) as HighestDeaths
FROM PortfolioProject..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestDeaths DESC

SELECT SUM(new_cases)AS TotalNewCases, SUM(new_deaths) AS TotalNewDeaths
FROM PortfolioProject..CovidDeaths


SELECT * FROM PortfolioProject..CovidDeaths

SELECT * 
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location=Vac.location
	AND Dea.date=Vac.date


WITH PopVsVac(continent,location, date, population, New_Vaccinations, RollingVaccinations)
AS
(
SELECT Dea.continent,Dea.location, Dea.date, Dea.population,Vac.new_vaccinations, 
SUM(CAST(Vac.new_vaccinations AS float)) OVER (PARTITION BY Dea.location ORDER BY Dea.date) AS RollingTotalVacccinations
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location=Vac.location
	AND Dea.date=Vac.Date
WHERE Dea.continent IS NOT NULL
)
SELECT * , (RollingVaccinations/population)*100 AS RollingPercentage
FROM PopVsVac

DROP TABLE IF EXISTS #PercentPopVsVac

CREATE TABLE #PercentPopVsVac
(
Continent VARCHAR(255),
Location VARCHAR(255),
Date DATETIME,
Population NUMERIC,
New_Vaccinations NUMERIC,
RollingVac NUMERIC
)

INSERT INTO #PercentPopVsVac
SELECT Dea.continent,Dea.location, Dea.date, Dea.population,Vac.new_vaccinations, 
SUM(CAST(Vac.new_vaccinations AS float)) OVER (PARTITION BY Dea.location ORDER BY Dea.date) AS RollingTotalVacccinations
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location=Vac.location
	AND Dea.date=Vac.Date
WHERE Dea.continent IS NOT NULL

SELECT *
FROM #PercentPopVsVac

CREATE VIEW  PercentagePopVac
AS 
SELECT Dea.continent,Dea.location, Dea.date, Dea.population,Vac.new_vaccinations, 
SUM(CAST(Vac.new_vaccinations AS float)) OVER (PARTITION BY Dea.location ORDER BY Dea.date) AS RollingTotalVacccinations
FROM PortfolioProject..CovidDeaths Dea
JOIN PortfolioProject..CovidVaccinations Vac
	ON Dea.location=Vac.location
	AND Dea.date=Vac.Date
WHERE Dea.continent IS NOT NULL

SELECT *
FROM PercentagePopVac

