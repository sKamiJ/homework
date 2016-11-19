--1
select * from EMPLOYEES where DEPARTMENT_ID = 100;
--2
select EMPLOYEE_ID,FIRST_NAME,DEPARTMENT_ID
from EMPLOYEES
where JOB_ID = 'SA_MAN';
--3
select EMPLOYEE_ID,SALARY,COMMISSION_PCT,SALARY * (1 + nvl(COMMISSION_PCT,0))
from EMPLOYEES;
--4
select *
from EMPLOYEES
where (DEPARTMENT_ID = 40 and JOB_ID = 'AD_ASST') or (DEPARTMENT_ID = 20 and JOB_ID = 'SA_REP'); 
--5
select *
from EMPLOYEES
where JOB_ID not in('Stock Manager','Purchasing Manager') and SALARY >= 2000;
--6
select distinct JOB_ID,JOB_TITLE
from JOBS
where JOB_ID in (select JOB_ID
                 from EMPLOYEES
                 where COMMISSION_PCT is not null);
--7
select *
from EMPLOYEES
where COMMISSION_PCT is null or SALARY * COMMISSION_PCT < 100;
--8
select * 
from EMPLOYEES
where FIRST_NAME not like '%S%';
--9
select FIRST_NAME,LAST_NAME,HIRE_DATE
from EMPLOYEES
order by HIRE_DATE asc;
--10
select e1.FIRST_NAME,e1.LAST_NAME,e2.FIRST_NAME,e2.LAST_NAME
from EMPLOYEES e1 join EMPLOYEES e2 on(e1.MANAGER_ID = e2.EMPLOYEE_ID);
--11
select *
from EMPLOYEES e1
where HIRE_DATE < (select HIRE_DATE
                   from EMPLOYEES e2
                   where e2.EMPLOYEE_ID = e1.MANAGER_ID);
--12
select d.DEPARTMENT_ID,DEPARTMENT_NAME,CITY,FIRST_NAME,LAST_NAME
from DEPARTMENTS d,LOCATIONS l,EMPLOYEES e
where d.MANAGER_ID = e.EMPLOYEE_ID and d.LOCATION_ID = l.LOCATION_ID;
--13
select *
from DEPARTMENTS d left join EMPLOYEES e on(d.DEPARTMENT_ID = e.DEPARTMENT_ID);
--14
select *
from EMPLOYEES e left join DEPARTMENTS d on(e.DEPARTMENT_ID = d.DEPARTMENT_ID);
--15
select EMPLOYEE_ID,FIRST_NAME,DEPARTMENT_NAME,JOB_TITLE,SALARY,COMMISSION_PCT
from EMPLOYEES e,DEPARTMENTS d,JOBS j
where e.DEPARTMENT_ID = d.DEPARTMENT_ID and e.JOB_ID = j.JOB_ID;
--16
select *
from DEPARTMENTS
where DEPARTMENT_ID in (select DEPARTMENT_ID
                        from EMPLOYEES);
--17
select *
from EMPLOYEES
where SALARY > (select SALARY
                from EMPLOYEES
                where EMPLOYEE_ID = 100);
--18
select *
from EMPLOYEES
where SALARY > (select avg(SALARY)
                from EMPLOYEES);
--19
select JOB_ID,max(SALARY)
from EMPLOYEES
group by JOB_ID;
--20
select DEPARTMENT_ID,count(*),avg(SALARY)
from EMPLOYEES
group by DEPARTMENT_ID;
--21
select JOB_ID,count(*),avg(SALARY)
from EMPLOYEES
group by JOB_ID;
--22
select DEPARTMENT_ID,JOB_ID,count(*),avg(SALARY)
from EMPLOYEES
group by DEPARTMENT_ID,JOB_ID;
--23
select JOB_ID
from EMPLOYEES
group by JOB_ID
having min(SALARY) > 5000;
--24
select *
from DEPARTMENTS d join EMPLOYEES e on(d.DEPARTMENT_ID = e.DEPARTMENT_ID)
where d.DEPARTMENT_ID in (select DEPARTMENT_ID
                          from EMPLOYEES
                          group by DEPARTMENT_ID
                          having avg(SALARY) < 6000);
--25
select FIRST_NAME,LAST_NAME
from EMPLOYEES e join DEPARTMENTS d on(e.DEPARTMENT_ID = d.DEPARTMENT_ID)
where DEPARTMENT_NAME = 'Sales';
--26
select *
from EMPLOYEES
where JOB_ID = (select JOB_ID
                from EMPLOYEES
                where EMPLOYEE_ID = 140);
--27
select FIRST_NAME,LAST_NAME,SALARY
from EMPLOYEES
where SALARY > all(select SALARY
                   from EMPLOYEES
                   where DEPARTMENT_ID = 30);
--28
select count(*),avg(SALARY),avg(round((sysdate-HIRE_DATE)/365))
from EMPLOYEES
group by DEPARTMENT_ID;
--29
select *
from EMPLOYEES
where SALARY in(select avg(SALARY)
                from EMPLOYEES
                group by DEPARTMENT_ID);
--30
select *
from EMPLOYEES e1
where SALARY > (select avg(SALARY)
                from EMPLOYEES e2
                where e1.DEPARTMENT_ID = e2.DEPARTMENT_ID
                group by e2.DEPARTMENT_ID);
--31
select e.*,AVG_SALARY
from EMPLOYEES e join (select DEPARTMENT_ID,avg(salary) AVG_SALARY
                       from EMPLOYEES
                       group by DEPARTMENT_ID) d on(e.DEPARTMENT_ID = d.DEPARTMENT_ID)
where SALARY > AVG_SALARY;
--32
select *
from EMPLOYEES
where SALARY > some(select SALARY
                    from EMPLOYEES
                    where DEPARTMENT_ID = 50);
--33
select *
from EMPLOYEES
where (SALARY,nvl(COMMISSION_PCT,0)) in (select SALARY,nvl(COMMISSION_PCT,0)
                                         from EMPLOYEES
                                         where DEPARTMENT_ID = 10);
--34
select *
from EMPLOYEES
where DEPARTMENT_ID in (select DEPARTMENT_ID
                        from EMPLOYEES
                        group by DEPARTMENT_ID
                        having count(*) > 10);
--35
select *
from DEPARTMENTS
where DEPARTMENT_ID in (select DEPARTMENT_ID
                        from EMPLOYEES
                        group by DEPARTMENT_ID
                        having min(SALARY) > 10000);
--36
select *
from DEPARTMENTS d join EMPLOYEES e on(d.DEPARTMENT_ID = e.DEPARTMENT_ID)
where d.DEPARTMENT_ID in (select DEPARTMENT_ID
                          from EMPLOYEES
                          group by DEPARTMENT_ID
                          having min(SALARY) > 5000);
--37
select *
from DEPARTMENTS
where DEPARTMENT_ID in (select DEPARTMENT_ID
                        from EMPLOYEES
                        group by DEPARTMENT_ID
                        having min(SALARY) >= 4000 and max(SALARY) <= 8000);
--38
select *
from DEPARTMENTS
where DEPARTMENT_ID in(select DEPARTMENT_ID
                       from EMPLOYEES
                       group by DEPARTMENT_ID
                       having count(*) >= all(select count(*)
                                              from EMPLOYEES
                                              group by DEPARTMENT_ID));
--39
select *
from (select *
      from EMPLOYEES
      where DEPARTMENT_ID = 30
      order by SALARY desc)
where rownum <= 3;
--40
select *
from (select e1.*,rownum rn
      from (select *
            from EMPLOYEES
            order by SALARY desc) e1) e2
where rn between 5 and 10;
--41
update EMPLOYEES e1
set SALARY = 1000 + (select avg(SALARY)
                     from EMPLOYEES e2
                     where e1.DEPARTMENT_ID = e2.DEPARTMENT_ID);
--42
select *
from EMPLOYEES
where last_day(HIRE_DATE) - 1 = HIRE_DATE;
--43
select *
from EMPLOYEES
where (sysdate-HIRE_DATE)/365 >= 10;
--44
select initcap(LAST_NAME),initcap(FIRST_NAME)
from EMPLOYEES;
--45
select *
from EMPLOYEES
where length(FIRST_NAME) = 6;
--46
select *
from EMPLOYEES
where FIRST_NAME like '_m%';
--47
select replace(FIRST_NAME,'s','S')
from EMPLOYEES;
--48
select *
from EMPLOYEES
where extract(month from HIRE_DATE) = 2;