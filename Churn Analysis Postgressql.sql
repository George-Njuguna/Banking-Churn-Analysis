/* Checking if the file has been imported */
Select * from churn
limit 10;

/* Checking the number distinct customers */
select count(distinct(customerid)) as number_of_customers 
from churn;

/* Checking churn counts */
select churned , count(churned) as counts
from churn
group by churned
order by counts desc;

/* Checking the churned rate */
select churned , round((counts / sum(counts) over()) * 100.0,2) as rate 
from( select churned , count(churned) as counts
      from churn
      group by churned ) as t
;

/* Getting the gender distribution */
select gender , count(gender)  as counts
from churn
group by gender
order by counts desc;


/* getting the churn rate by gender */
select gender , round((counts / sum(counts) over()) * 100 , 2 ) as rate 
from (select gender ,
             count(gender) as counts
	  from churn
	  group by gender) as t1
order by rate desc;

/* Getting number of bank clients in each geograpy */
select geography , count(geography)  as counts
from churn
group by geography
order by counts desc;

/* getting the churn rate by geography */
select geography , round((counts / sum(counts) over()) * 100 , 2 ) as rate 
from (select geography ,
             count(geography) as counts
	  from churn
	  group by geography) as t2
order by rate desc;

/* Getting number of bank clients by  membership */
select isactivemember , count(isactivemember)  as counts
from churn
group by isactivemember
order by counts desc;

/* getting the churn rate by membership */
select isactivemember , round((counts / sum(counts) over()) * 100 , 2 ) as rate 
from (select isactivemember ,
             count(isactivemember) as counts
	  from churn
	  group by isactivemember) as t3
order by rate desc;

/* Getting number of bank clients by credit card ownership */
select hascrcard , count(hascrcard)  as counts
from churn
group by hascrcard
order by counts desc;

/* getting the churn rate by credit card ownership */
select hascrcard , round((counts / sum(counts) over()) * 100 , 2 ) as rate 
from (select hascrcard ,
             count(hascrcard) as counts
	  from churn
	  group by hascrcard) as t4
order by rate desc;
