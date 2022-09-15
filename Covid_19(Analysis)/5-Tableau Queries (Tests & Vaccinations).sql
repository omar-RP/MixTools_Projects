-- TABLEAU QUERIES FOR TESTS & VACCINATIONS

--1- FOR CONTINENTS
--showing the "number of tests" (IN EACH CONTINENT) from the beginning until now
SELECT dea.continent,SUM(CAST(vac.new_tests AS numeric)) AS total_tests_count
FROM PortfolioProject.dbo.Covid_Deaths AS dea
	JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
	ON dea.location = vac.location
	AND dea.date = vac.date
	WHERE dea.continent is not null
	GROUP BY dea.continent
	ORDER BY 2 DESC


--2- FOR COUNTRIES
--showing the "number of tests" in each country from the beginning until now
SELECT location,SUM(CAST(new_tests AS numeric)) AS total_tests_count
	FROM PortfolioProject.dbo.Covid_Vaccinations
	WHERE continent is not null
	GROUP BY location
	ORDER BY 1 DESC



-- finding out the  TOTAL population who "GOT VACCINATED" and also the TOTAL of the ones who are "FULLY_VACCINATED"

--3- FOR CONTINENTS
-- finding out the percentage of TOTAL population who "GOT VACCINATED" and also the TOTAL of the ones who are "FULLY_VACCINATED" for each Continent 
--Using anothewre method of presenting the same data as above
-- BY creating a VIEW for this portion of data to be easy to visualize on "TABLEAU PUPLIC"

SELECT dea.location,MAX(dea.population)/1000000 AS Total_population_in_millions,MAX(CAST(vac.people_vaccinated AS numeric))/1000000 AS total_vaccinated_people_in_millions
,MAX(CAST(vac.people_fully_vaccinated AS numeric))/1000000 AS total_fully_vaccinated_people_in_millions, ROUND((MAX(CAST(vac.people_vaccinated AS numeric))/dea.population)*100,4) AS total_vaccin_people_percentage,ROUND((MAX(CAST(vac.people_fully_vaccinated AS numeric))/dea.population)*100,4) AS total_full_vaccin_people_percentage
FROM PortfolioProject.dbo.Covid_Deaths AS dea
JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
	WHERE dea.iso_code='OWID_EUR' OR dea.iso_code= 'OWID_NAM' OR dea.iso_code='OWID_SAM' OR dea.iso_code='OWID_OCE' OR dea.iso_code='OWID_ASI'OR dea.iso_code='OWID_AFR'
GROUP BY dea.location,dea.population





--4- for countries
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


--5- for countries (WITHOUT THE DATE)
-- finding out the percentage of TOTAL population who "GOT VACCINATED" and also the TOTAL of the ones who are "FULLY_VACCINATED" for each country 
-- i am gonna join the two tables i have together to get my percentages and use a "CTE" Table
WITH TotalVac (location,population,total_vaccinated_people,total_fully_vaccinated_people)
as(
SELECT dea.location,dea.population,MAX(CAST(vac.people_vaccinated AS numeric)) AS total_vaccinated_people
,MAX(CAST(vac.people_fully_vaccinated AS numeric))  AS total_fully_vaccinated_people
FROM PortfolioProject.dbo.Covid_Deaths AS dea
JOIN PortfolioProject.dbo.Covid_Vaccinations AS vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent is not null
GROUP BY dea.location,dea.population
)
SELECT *, ROUND((total_vaccinated_people/population)*100,4) AS total_vaccin_people_percentage,ROUND((total_fully_vaccinated_people/population)*100,4) AS total_full_vaccin_people_percentage
FROM TotalVac
