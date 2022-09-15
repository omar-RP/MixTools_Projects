-- SPECIFIED QUERIES TO PRESENT ON TABLEAU PUPLIC
-- focuses on INFECTIONS & DEATHS (counts / rates) OVER COUNTRIES AND CONTINENTS AND THE WHOLE GLOBE

--1-
----looking at total_cases VS population
-- showing the total probability of infection of covid_19 (Globaly)
SELECT population AS total_population,SUM(new_cases) AS total_cases,ROUND(SUM(new_cases)/MAX(population)*100,4) AS infection_rate
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE LOCATION='world'
		GROUP BY  population
		ORDER BY 1,2

--2-
-- i would like to have more inclusive analysis for the covid_19 globaly by continent
-- I found out that the null values in the continent column have the correct total counts (infection OR deaths) 
-- showing the probabilities of infection of covid_19 in any continent and the average_infection_rate compared to the infection counts
SELECT iso_code,location,MAX(population) AS total_population,MAX(total_cases) AS total_infection_count,ROUND(MAX(total_cases)/MAX(population)*100,4) AS highest_infection_rate, ROUND(AVG((total_cases/population))*100,4) AS average_infection_rate
	FROM PortfolioProject.dbo.Covid_Deaths
	WHERE iso_code='OWID_EUR' OR iso_code= 'OWID_NAM' OR iso_code='OWID_SAM' OR iso_code='OWID_OCE' OR iso_code='OWID_ASI'OR iso_code='OWID_AFR' 
	GROUP BY  iso_code,location
	ORDER BY total_infection_count DESC

--3-
-- looking at countries with highest infection rate compared to population Globaly 
SELECT continent,location,population,MAX(total_cases) AS total_infection_count,ROUND(MAX((total_cases/population))*100,4) AS highest_infection_rate, ROUND(AVG((total_cases/population))*100,4) AS average_infection_rate
	FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	GROUP BY continent,location,population
	ORDER BY highest_infection_rate DESC

--3.5-
-- looking at countries with highest infection rate compared to population Globaly foe each day
SELECT continent,location,date,population,MAX(total_cases) AS total_infection_count,ROUND(MAX((total_cases/population))*100,4) AS highest_infection_rate, ROUND(AVG((total_cases/population))*100,4) AS average_infection_rate
	FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	GROUP BY continent,location,population,date
	ORDER BY highest_infection_rate DESC

--4-
----looking at total_cases VS total_deaths
-- showing the total probability of dying if you had covid_19 (Globaly)
SELECT MAX(population) AS total_population,SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS numeric)) AS total_deaths,ROUND(SUM(CAST(new_deaths AS numeric))/(SUM(new_cases))*100,4) AS death_percentages
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE location = 'world'
	ORDER BY 1,2


--5-
	-- showing the total probability of dying if you had covid_19 (in EACH CONTINENT)
SELECT location,SUM(new_cases) AS total_cases,SUM(CAST(new_deaths AS numeric)) AS total_deaths,ROUND(SUM(CAST(new_deaths AS numeric))/(SUM(new_cases))*100,4) AS death_percentages
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE iso_code='OWID_EUR' OR iso_code= 'OWID_NAM' OR iso_code='OWID_SAM' OR iso_code='OWID_OCE' OR iso_code='OWID_ASI'OR iso_code='OWID_AFR' 
	GROUP BY  location
	ORDER BY 4 DESC


--6-
-- finding the countries with the highest average_death_rate compared to the highest total_death_count & highest_total_cases_count  
SELECT continent,location,MAX(total_cases) AS total_cases_count,MAX(CAST(total_deaths AS numeric)) AS total_deaths_count,ROUND(AVG((CAST(total_deaths AS numeric)/total_cases))*100,2) AS average_death_rate
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	GROUP BY continent,location
	ORDER BY average_death_rate DESC

--6.5-
-- finding the countries with the highest average_death_rate compared to the highest total_death_count & highest_total_cases_count for each day
SELECT continent,location,date,MAX(total_cases) AS total_cases_count,MAX(CAST(total_deaths AS numeric)) AS total_deaths_count,ROUND(AVG((CAST(total_deaths AS numeric)/total_cases))*100,2) AS average_death_rate
FROM PortfolioProject.dbo.Covid_Deaths
	WHERE continent is not null
	GROUP BY continent,location,date
	ORDER BY average_death_rate 