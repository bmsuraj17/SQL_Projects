/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/


use [portfolio project]
select * from CovidVaccinations$;
select *  from CovidDeaths$;


SELECT * from CovidDeaths$
order by 3,4;
select * from [portfolio project]..CovidVaccinations$
order by 3,4;

-- Select Data that we are going to be starting with

Select Location, date, total_cases, new_cases, total_deaths, population
From [portfolio project]..CovidDeaths$
order by 1,2

--Analysing total cases vs total deaths
-- Shows likelihood of dying if you contract covid in your country

SELECT location,date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as DeathPercentage  
from CovidDeaths$
where location like '%India%'
order by location,date;

-- Total Cases vs Population
-- Shows the percentage of population infected with Covid

SELECT location,date,population,total_cases,
(total_cases/population)*100 as PopulationInfected 
from CovidDeaths$
--where location like '%India%'
order by location,date;

-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  
Max((total_cases/population))*100 as MaxPopulationInfected
From [portfolio project]..CovidDeaths$
--Where location like '%india%'
Group by location,population
order by MaxPopulationInfected desc

-- Countries with Highest Death Count per Population

SELECT location,max(cast(total_deaths as int)) as HighestDeathCount
from [portfolio project]..CovidDeaths$
where continent is not null
group by location
order by highestdeathcount desc



-- BREAKING THINGS DOWN BY CONTINENT

-- Showing contintents with the highest death count per population

SELECT continent,max(cast(total_deaths as int)) as HighestDeathCount
from [portfolio project]..CovidDeaths$
where continent is not null
group by continent
order by highestdeathcount desc


--Global Numbers

SELECT sum(new_cases) as TotalNewCases,
sum(cast (new_deaths as int)) as TotalNewDeaths ,(sum(cast (new_deaths as int))/sum(new_cases))*100 as DeathPercentage
from CovidDeaths$
where continent is not null
--group by date
order by totalnewcases;

--Showing Total Population vs Vaccinations

-- Shows Percentage of Population that has recieved at least one Covid Vaccine

SELECT d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast (v.new_vaccinations as int)) over(partition by d.location order by d.date) as RollVaccinatedPeople from CovidDeaths$ d 
join CovidVaccinations$ v 
on d.location=v.location and d.date=v.date 
where d.continent is not null
order by 2,3;


-- Using CTE to perform Calculation on Partition By in previous query


WITH vaccpop  
as (
SELECT d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast (v.new_vaccinations as int)) over(partition by d.location order by d.date) as RollVaccinatedPeople from CovidDeaths$ d 
join CovidVaccinations$ v 
on d.location=v.location and d.date=v.date 
where d.continent is not null)
--order by 2,3)

SELECT *,(RollVaccinatedPeople/population)*100 from vaccpop
order by 2,3;

SELECT location,max(RollVaccinatedPeople)/max(population)*100 as PopulationVaccinated from vaccpop
where location='india'
group by location;


-- Creating View to store data for later visualizations

--Creating view for HighestVaccinatedPopulationPercent in India

CREATE View India_Vaccine_Percent as


with vaccpop  
as (
SELECT d.continent,d.location,d.date,d.population,v.new_vaccinations,
sum(cast (v.new_vaccinations as int)) over(partition by d.location order by d.date) as RollVaccinatedPeople from CovidDeaths$ d 
join CovidVaccinations$ v 
on d.location=v.location and d.date=v.date 
where d.continent is not null)
--order by 2,3)

SELECT location,max(RollVaccinatedPeople)/max(population)*100 as PopulationVaccinated from vaccpop
where location='india'
group by location;

Select * from [portfolio project]..India_Vaccine_Percent;





