/*
Covid 19 Data Exploration 

Skills used: Joins, Windows Functions, Aggregate Functions, Converting Data Types

*/

-- Show what information havein the table
Select *
From CovidDeaths_2024
Where continent is not null 
order by 3,4

Select *
From CovidVaccinations_2024
Where continent is not null 
order by 3,4


-- Total Cases vs Total Deaths
-- Shows likelihood of dying if you contract covid in your country

Select Location, date, total_cases,total_deaths, (total_deaths/cast(total_cases as float))*100 as DeathPercentage
From CovidDeaths_2024
where continent is not null 
order by 1,2


-- Total Cases vs Population
-- Shows what percentage of population infected with Covid

Select Location, date, Population, total_cases,  (total_cases/population)*100 as InfectedPercentage
From CovidDeaths_2024
order by 1,2


-- Countries with Highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as InfectedCount,  Max((total_cases/population))*100 as InfectedPercentage
From CovidDeaths_2024
--Where location like '%states%'
Group by Location, Population
order by InfectedPercentage desc


-- Countries with Highest Death Count per Population

Select Location, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths_2024
Where continent is not null 
Group by Location
order by TotalDeathCount desc



-- GROUP BY CONTINENT
-- Showing contintents with total deaths count per population

Select continent, MAX(cast(Total_deaths as int)) as TotalDeathCount
From CovidDeaths_2024
Where continent is not null 
Group by continent
order by TotalDeathCount desc



-- Global Stat. until 18 Jan 2024
--Total_cases is cumulative. Therefore, it cannot be used for counting sum.

Select format(max(date),'yyyy-MM-dd') as Last_updated_date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths_2024
where continent is not null 
order by 1,2

-- Global Stat. for each day 
Select date,SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From CovidDeaths_2024
where continent is not null 
Group By date
order by 1,2

--
select 
a.Continent,a.location,a.population,a.date,a.total_cases,a.new_cases,a.total_deaths,a.new_deaths,a.reproduction_rate,a.icu_patients,a.hosp_patients,b.new_tests,b.positive_rate
,b.total_vaccinations,b.people_vaccinated as at_least_one_dose,b.people_fully_vaccinated as completed_primary_doses,b.total_boosters,b.new_vaccinations,b.new_people_vaccinated_smoothed,population_density,median_age,gdp_per_capita,
cardiovasc_death_rate,diabetes_prevalence,female_smokers,male_smokers,handwashing_facilities,life_expectancy
from
CovidDeaths_2024 a
inner join CovidVaccinations_2024 b
on a.date = b.date and a.location = b.location
where a.location = 'United States' --and a.date = '2023-05-09'
order by 4 desc


-- Shows Percentage of Population that has recieved at least one Covid Vaccine & fully vaccinated

WITH CTE as
(
select a.location,a.population
,MAX(cast(total_cases as int)) as TotalCasesCount
,max(cast(total_deaths as int)) as TotalDeathsCount
--,sum(cast(icu_patients as int)) as TotalIcu
--,sum(cast(hosp_patients as int)) as TotalHosp
,max(cast(b.people_vaccinated as bigint)) as TotalOneDose
,max(cast(b.people_fully_vaccinated as bigint)) as TotalFullyDoses
,max(cast(b.people_vaccinated as bigint))/a.population *100 as OneDosePopluationPercentage
,max(cast(b.people_fully_vaccinated as bigint))/a.population *100 as FullDosePopluationPercentage
from CovidDeaths_2024 a
inner join CovidVaccinations_2024 b
on a.date = b.date and a.location = b.location--and date between '2020-08-08' and '2024-01-13'
where a.continent is not null
group by a.location,a.population
)
select * from CTE
where OneDosePopluationPercentage < 100 AND FullDosePopluationPercentage < 100
and location = 'United States'
order by 8 desc





