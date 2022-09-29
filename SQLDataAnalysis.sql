use Projects

select *
from ds_salaries

/*
First of all, let's see what is the average salary in each country
*/

select company_location,AVG(salary_in_usd) as Annual_Income
from ds_salaries
group by company_location
order by avg(salary_in_usd) desc

/*Hence United State of America is on the second number with $144055.26,
followed by Russian Federation on top with $157500*/

/*
Now let's see which data_scientist job title has more income
*/

select job_title,AVG(salary_in_usd)
from ds_salaries
group by job_title
order by avg(salary_in_usd) desc
--It is clear that Data Analytics Lead is earning more than other job titles

/*
Now Let's see in what are the TOP 10 countries who are paying more to Top 1 job_title by using sub Query
*/

select company_location, job_title, AVG(salary_in_usd)
from ds_salaries
where job_title=(select Top 1 job_title from ds_salaries group by job_title order by avg(salary_in_usd) desc)
group by company_location,job_title
order by AVG(salary_in_usd)
--Only USA has this job title and paying.


/*
Now which country has more jobs for data scientist
*/

select company_location,count(job_title)
from ds_salaries
group by company_location
order by count(job_title) desc
--As we can see United state of America is the biggest market for data scientist


/*
Now from which country people come from for a data scientist job
*/

select * from ds_salaries

select employee_residence,COUNT(job_title)
from ds_salaries
group by employee_residence
order by COUNT(job_title) desc
--Numbers look same with minor change


/*
Does Company_size effect the salary
*/

select company_size,AVG(salary_in_usd) as Average_Salary
from ds_salaries
group by company_size
order by Average_Salary desc
--The answer is Yes Large companies paying more than samll one's



--Now let's check the job title unique values
select distinct(job_title)
from ds_salaries

--Now let's how many each title occure
select job_title,COUNT(job_title)
from ds_salaries
group by job_title
order by COUNT(job_title) desc
--Now as we see many job_titles only occure 1,2,3 or 4 time that's make no sense

/*
Now show the only jobs title with 5 or more job titles and see which one has more salary
*/

select job_title,AVG(salary_in_usd)
from ds_salaries
group by job_title
having COUNT(job_title)>=5
order by AVG(salary_in_usd) desc
--Here Principal Data Scientist is earning more than others

/*
Countries with highest paying jobs with job_title occures more than 3 time
*/

select company_location,job_title,AVG(salary_in_usd) as AverageSalary
from ds_salaries
group by company_location,job_title
having COUNT(job_title)>=4
order by company_location,AverageSalary


/*
Does remote ratio effect the salary or not
*/

select remote_ratio,AVG(salary_in_usd) as AverageSalary
from ds_salaries
group by remote_ratio
order by AverageSalary
--This is strange that 50% or Medium level Remote working people earns more than others
--However if you work from home than you will get less salary than work from office


/*
Which Job_title is more remote 
*/
select job_title,count(remote_ratio) as Remote_Jobs_Count
from ds_salaries
where remote_ratio='Remote'
group by job_title
order by Remote_Jobs_Count desc
--Data Engineer has more Remote jobs, while Data Scientist is on second position with 79


select *
from ds_salaries

/*
How much the salaries changes with year
*/

select work_year,AVG(salary_in_usd)
from ds_salaries
group by work_year
order by AVG(salary_in_usd) desc
--The answer is yes the salaries have changed with time


/*
In which year the salary with which job title and employee type is more.
*/

select experience_level,job_title,AVG(salary_in_usd)
from ds_salaries
group by experience_level,job_title
order by experience_level desc,AVG(salary_in_usd) desc
--Executive level employee with Principla Data Engineer skills has more money


/*
Create CTE with work year, experience level, salary, company_location,job_title
And apply different conditions to check do analysis
*/

with salary_CTE as
(
select work_year,job_title,company_location,avg(salary_in_usd) as Average_Salary
from ds_salaries
group by work_year,job_title,company_location
--order by work_year desc,avg(salary_in_usd) desc
)
--Let's which top 5 professionals have more salary in USA in 2022
select top 5*
from salary_CTE
where company_location='United State of America' and work_year=2022
order by work_year desc,Average_Salary desc

/* 
Create the Temp table and see which professional gets more income in Pakistan
*/
--drop table #salary_data if exit
create table #salary_data(
work_year int,
job_title varchar(100),
company_location varchar(100),
remote_ratio varchar(30),
Average_salary bigint
)

--Insert the values into these columns
insert into #salary_data
select work_year,job_title,company_location,remote_ratio,Avg(salary_in_usd)
from ds_salaries
group by work_year,job_title,company_location,remote_ratio


select * 
from #salary_data
where company_location='Pakistan'
order by Average_salary desc
--In 2022 Data Analystics Engineer has more earning and his/her job is not remote with $20000


/*what are the 10 professional has more salary and show full detail of the profession
by creating procedures
*/
create procedure top_10_professions
as
select top 10 AVG(salary_in_usd) as Top_10,work_year,experience_level,employment_type,
job_title,employee_residence,remote_ratio,company_location,company_size
from ds_salaries
group by work_year,experience_level,employment_type,
job_title,employee_residence,remote_ratio,company_location,company_size
order by Top_10 desc

exec top_10_professions
/*Here top 10 professions are from the same country USA and top paying job is Principal Data Engineer
and his/her work is totally remote as a full time employee in large company.
*/




