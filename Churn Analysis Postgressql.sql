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

/* Checking the churned rate in the database*/
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
with t1(gender,count1)
as (
    select gender , count(gender)
    from churn 
    where churned = '1'
    group by gender
	),
t2(gender,count0)
as(
   select gender , count(gender)
   from churn 
   where churned = '0'
  group by gender
  ),
t3(gender,count1,count0)
as(
   select t1.gender , t1.count1 , t2.count0
   from t1 
   inner join t2 on t1.gender = t2.gender
),
t4(gender,count1,count0,total_counts)
as(
   select gender,count1,count0,(count1+count0) as total_counts
   from t3
)
select gender,round((count1::decimal /total_counts)*100,1) as rate0 , round((count0::decimal /total_counts)*100,1) as rate1
from t4;


/* Getting number of bank clients in each geograpy */
select geography , count(geography)  as counts
from churn
group by geography
order by counts desc;

/* getting the churn rate by geography */
with t1(geography,count1)
as (
    select geography , count(geography)
    from churn 
    where churned = '1'
    group by geography
	),
t2(geography,count0)
as(
   select geography , count(geography)
   from churn 
   where churned = '0'
   group by geography
  ),
t3(geography,count1,count0)
as(
   select t1.geography , t1.count1 , t2.count0
   from t1 
   inner join t2 on t1.geography = t2.geography
),
t4(geography,count1,count0,total_counts)
as(
   select geography,count1,count0,(count1+count0) as total_counts
   from t3
)
select geography,round((count1::decimal /total_counts)*100,1) as rate0 , round((count0::decimal /total_counts)*100,1) as rate1
from t4;


/* Getting number of bank clients by  membership */
select isactivemember , count(isactivemember)  as counts
from churn
group by isactivemember
order by counts desc;

/* getting the churn rate by membership */
with t1(isactivemember,count1)
as (
    select isactivemember , count(isactivemember)
    from churn 
    where churned = '1'
    group by isactivemember
	),
t2(isactivemember,count0)
as(
   select isactivemember , count(isactivemember)
   from churn 
   where churned = '0'
  group by isactivemember
  ),
t3(isactivemember,count1,count0)
as(
   select t1.isactivemember , t1.count1 , t2.count0
   from t1 
   inner join t2 on t1.isactivemember = t2.isactivemember
),
t4(isactivemember,count1,count0,total_counts)
as(
   select isactivemember,count1,count0,(count1+count0) as total_counts
   from t3
)
select isactivemember,round((count1::decimal /total_counts)*100,1) as rate0 , round((count0::decimal /total_counts)*100,1) as rate1
from t4;


/* Getting number of bank clients by credit card ownership */
select hascrcard , count(hascrcard)  as counts
from churn
group by hascrcard
order by counts desc;

/* getting attrition rate by credit card ownership*/
with t1(hascrcard,count1)
as (
    select hascrcard , count(hascrcard)
    from churn 
    where churned = '1'
    group by hascrcard
	),
t2(hascrcard,count0)
as(
   select hascrcard , count(hascrcard)
   from churn 
   where churned = '0'
  group by hascrcard
  ),
t3(hascrcard,count1,count0)
as(
   select t1.hascrcard , t1.count1 , t2.count0
   from t1 
   inner join t2 on t1.hascrcard = t2.hascrcard
),
t4(hascrcard,count1,count0,total_counts)
as(
   select hascrcard,count1,count0,(count1+count0) as total_counts
   from t3
)
select hascrcard,round((count1::decimal /total_counts)*100,1) as rate0 , round((count0::decimal /total_counts)*100,1) as rate1
from t4;
