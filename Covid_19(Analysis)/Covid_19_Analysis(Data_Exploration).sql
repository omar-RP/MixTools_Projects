SELECT * 
	FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	ORDER BY 3,4

-- selecting the data that i am gonna use
SELECT location,date,new_cases,total_cases,total_deaths,population
	FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	ORDER BY 1,2


--looking at total_cases VS total_deaths
-- showing the total probability of dying if you had covid_19 (Globaly)
SELECT SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS numeric)) AS total_deaths,ROUND(SUM(CAST(new_deaths AS numeric))/(SUM(new_cases))*100,4) AS death_percentages
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	ORDER BY 1,2


--looking at total_cases VS total_deaths
-- showing the probability of dying if you had covid_19 in each country
SELECT location,date,total_cases,total_deaths,ROUND((total_deaths/total_cases)*100,2) AS death_rate
	FROM PortfolioProject.dbo.Covid_Deaths
		ORDER BY 3

-- looking at total_cases VS total_deaths
-- showing the probability of dying if you had covid_19 in any country (EX:Italy & Germany)
SELECT continent,location,date,total_cases,total_deaths,ROUND((total_deaths/total_cases)*100,2) AS death_rate
	FROM PortfolioProject.dbo.Covid_Deaths
	WHERE location = 'Italy' OR location = 'Germany'
	ORDER BY 3

----looking at total_cases VS population
-- showing the total probability of infection of covid_19 (Globaly)
SELECT MAX(population) AS total_population,SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS numeric)) AS total_deaths,ROUND(SUM(CAST(new_deaths AS numeric))/(SUM(new_cases))*100,4) AS death_percentages
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE location = 'world'
	ORDER BY 1,2

--looking at total_cases VS population
-- showing the probability of infection of covid_19 in each country 
SELECT location,population,total_cases,ROUND((total_cases/population)*100,4) AS infection_rate
	FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	Group BY location,population,total_cases
	ORDER BY infection_rate DESC


-- looking at countries with highest infection rate compared to population Globaly 
SELECT continent,location,population,MAX(total_cases) AS total_infection_count,ROUND(MAX((total_cases/population))*100,4) AS highest_infection_rate, ROUND(AVG((total_cases/population))*100,4) AS average_infection_rate
	FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	GROUP BY continent,location,population
	ORDER BY highest_infection_rate DESC

-- showing the highest probability of infection of covid_19 in any country (EX:Italy & Germany)
SELECT location,population,MAX(total_cases) AS total_infections_count,ROUND(MAX((total_cases/population))*100,4) AS  highest_infection_rate, ROUND(AVG((total_cases/population))*100,4) AS average_infection_rate
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE location = 'Italy' OR location = 'Germany'
	GROUP BY location,population
	ORDER BY 1,2

-- finding the countries with the highest average_death_rate compared to the highest total_death_count & highest_total_cases_count  
SELECT continent,location,MAX(total_cases) AS total_cases_count,MAX(CAST(total_deaths AS numeric)) AS total_deaths_count,ROUND(AVG((CAST(total_deaths AS numeric)/total_cases))*100,2) AS average_death_rate
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	GROUP BY continent,location
	ORDER BY average_death_rate DESC
	


-- i would like to have more inclusive analysis for the covid_19 globaly by continent
-- I found out that the null values in the continent column have the correct total counts (infection OR deaths) 
-- showing the probabilities of infection of covid_19 in any continent and the average_infection_rate compared to the infection counts
SELECT iso_code,location,MAX(population)/1000000 AS total_population_millions,MAX(total_cases) AS total_infection_count,ROUND(MAX((total_cases/population))*100,4) AS highest_infection_rate, ROUND(AVG((total_cases/population))*100,4) AS average_infection_rate
	FROM PortfolioProject.dbo.Covid_Deaths
	WHERE iso_code='OWID_EUR' OR iso_code= 'OWID_NAM' OR iso_code='OWID_SAM' OR iso_code='OWID_OCE' OR iso_code='OWID_ASI'OR iso_code='OWID_AFR'
	GROUP BY  iso_code,location
	ORDER BY total_infection_count DESC

-- showing the highest_death_count & average_death_rate for each continent compared to its total_population in millions
SELECT iso_code,location,MAX(population)/1000000 AS total_population_millions,MAX(CAST(total_deaths AS numeric)) AS total_deaths_count,ROUND(AVG((CAST(total_deaths AS numeric)/total_cases))*100,2) AS average_death_rate
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE iso_code='OWID_EUR' OR iso_code= 'OWID_NAM' OR iso_code='OWID_SAM' OR iso_code='OWID_OCE' OR iso_code='OWID_ASI'OR iso_code='OWID_AFR'
	GROUP BY iso_code,location
	ORDER BY total_deaths_count DESC

-- presenting Global_Numbers(total_cases,total_deaths,death_rate) for each day since the first day of counting for the pandemic
SELECT date,SUM(CAST(new_cases AS numeric)) AS total_cases,SUM(CAST(new_deaths AS int)) AS total_deaths,ROUND(SUM(CAST(new_deaths AS numeric))/SUM((total_cases))*100,4) AS death_rate
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	GROUP BY date
	ORDER BY 1,2

-- presenting Global_Numbers(total_cases,total_deaths,death_rate) from the beginning until now as a total in one row
SELECT SUM(CAST(new_cases AS numeric))/1000000 AS total_cases_millions,SUM(CAST(new_deaths AS numeric))/1000000 AS total_deaths_millions,ROUND(SUM(CAST(new_deaths AS numeric))/SUM((total_cases))*100,4) AS death_rate
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null



--MOVING NOW TO VIEW THE OTHER TABLE "Covid_Vaccinations"

SELECT * 
	FROM PortfolioProject.dbo.Covid_Vaccinations
	ORDER BY 3,4


--showing the "number of tests" (IN EACH CONTINENT) from the beginning until now
SELECT dea.continent,SUM(CAST(vac.new_tests AS numeric)) AS total_tests_count_in_millions
FROM PortfolioProject.dbo.Covid_Deaths AS dea
	JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent is not null
	GROUP BY dea.continent
	ORDER BY 2 DESC
	

--showing the "number of tests" in each country from the beginning until now
SELECT location,date,SUM(CAST(new_tests AS numeric)) AS total_tests_count 
	FROM PortfolioProject.dbo.Covid_Vaccinations
	WHERE continent is not null
	GROUP BY location,date
	ORDER BY 3 DESC
	
--showing the number of "total_vaccinations" VS "people_fully_vaccinated" 
--with the "fully_vaccinated_people_rate" (in each country) from the highest to the lowest
SELECT location,MAX(CAST(total_vaccinations AS numeric)) AS total_vaccinations , MAX(CAST(people_fully_vaccinated AS numeric)) AS fully_vaccnated_people,(MAX(CAST(people_fully_vaccinated AS numeric))/MAX(CAST(total_vaccinations AS numeric)))*100  AS fully_vaccinated_people_rate
	FROM PortfolioProject.dbo.Covid_Vaccinations
	WHERE continent is not null
	GROUP BY location
	ORDER BY fully_vaccinated_people_rate DESC




--looking at total population VS new vaccinations
-- got the total new_vaccination for each country and until any specific date
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS total_new_vaccinations
FROM PortfolioProject.dbo.Covid_Deaths AS dea
JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 2,3

--looking at total population VS new vaccinationd from another prespective
-- i will use a CTE table to do more advanced calculations.
WITH popVSvac(continent,location,date,population,new_vaccinations,total_new_vaccinations)
as
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(CONVERT(numeric,vac.new_vaccinations)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS total_new_vaccinations

FROM PortfolioProject.dbo.Covid_Deaths AS dea
JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
--ORDER BY 2,3
)
SELECT *,ROUND((total_new_vaccinations/population)*100,4) AS new_vaccinated_people_rate
FROM popVSvac


-- finding out the  TOTAL population who "GOT VACCINATED" and also the TOTAL of the ones who are "FULLY_VACCINATED" for each country and until any specific date
-- i am gonna join the two tables i have together to get my percentages 
SELECT dea.location,dea.date,dea.population,MAX(CAST(vac.people_vaccinated AS numeric)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS total_vaccinated_people
,MAX(CAST(vac.people_fully_vaccinated AS numeric)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS total_fully_vaccinated_people
FROM PortfolioProject.dbo.Covid_Deaths AS dea
JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2,3

---- finding out the percentage of total population who "GOT VACCINATED" and also the ones who are "FULLY_VACCINATED"
---- i am gonna join the two tables i have together to get my percentages
SELECT dea.location,dea.date,dea.population,(CAST(vac.people_vaccinated AS numeric)/dea.population)*100 AS vaccinated_people_percentage,(CAST(vac.people_fully_vaccinated AS numeric)/dea.population)*100 AS fully_vaccinated_people_percentage
FROM PortfolioProject.dbo.Covid_Deaths AS dea
JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
ORDER BY 1,2,3



-- finding out the percentage of TOTAL population who "GOT VACCINATED" and also the TOTAL of the ones who are "FULLY_VACCINATED" for each country and until any specific date
-- i am gonna join the two tables i have together to get my percentages and use a "CTE" Table
WITH TotalVac (continent,location,date,population,total_vaccinated_people,total_fully_vaccinated_people)
as(
SELECT dea.continent,dea.location,dea.date,dea.population,MAX(CAST(vac.people_vaccinated AS numeric)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS total_vaccinated_people
,MAX(CAST(vac.people_fully_vaccinated AS numeric)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS total_fully_vaccinated_people
FROM PortfolioProject.dbo.Covid_Deaths AS dea
JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
)
SELECT *, ROUND((total_vaccinated_people/population)*100,4) AS total_vaccin_people_percentage,ROUND((total_fully_vaccinated_people/population)*100,4) AS total_full_vaccin_people_percentage
FROM TotalVac



-- CREATE TEMP TABLE (to get the same outcome that i got from the CTE table but i am gonna use A TEMP this time)
DROP TABLE IF EXISTS #TotalVaccinationPercentage
CREATE TABLE #TotalVaccinationPercentage
(
continent nvarchar (255),
location  nvarchar (255),
date datetime,
population numeric,
total_vaccinated_people numeric,
total_fully_vaccinated_people numeric
)
insert into #TotalVaccinationPercentage
SELECT dea.continent,dea.location,dea.date,dea.population,MAX(CAST(vac.people_vaccinated AS numeric)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS total_vaccinated_people
,MAX(CAST(vac.people_fully_vaccinated AS numeric)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS total_fully_vaccinated_people
FROM PortfolioProject.dbo.Covid_Deaths AS dea
JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null

SELECT *, ROUND((total_vaccinated_people/population)*100,4) AS total_vaccin_people_percentage,ROUND((total_fully_vaccinated_people/population)*100,4) AS total_full_vaccin_people_percentage
FROM #TotalVaccinationPercentage



--Using anothewre method of presenting the same data as above
-- BY creating a VIEW for this portion of data to be easy to visualize on "TABLEAU PUPLIC"
CREATE VIEW TotalVaccinationPercentages AS
SELECT dea.continent,dea.location,dea.date,dea.population,MAX(CAST(vac.people_vaccinated AS numeric)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS total_vaccinated_people
,MAX(CAST(vac.people_fully_vaccinated AS numeric)) OVER (partition by dea.location ORDER BY dea.location,dea.date) AS total_fully_vaccinated_people
FROM PortfolioProject.dbo.Covid_Deaths AS dea
JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null

SELECT *, ROUND((total_vaccinated_people/population)*100,4) AS total_vaccin_people_percentage,ROUND((total_fully_vaccinated_people/population)*100,4) AS total_full_vaccin_people_percentage
FROM TotalVaccinationPercentages