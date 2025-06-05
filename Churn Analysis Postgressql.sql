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

/* Getting the active membership by gender*/

select gender , isactivemember , count(isactivemember) as counts
from churn
group by gender , isactivemember;


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

/*Getting the churn counts and rate by tenure*/
with t1(churned,grouped_tenure)
 as(
   select churned ,
    case 
      when tenure  < 3 then '<2'
      when tenure  >= 3 and tenure < 6 then '3-5'
      when tenure  >= 6 and tenure < 9 then '6-8'    /*grouping the tenures*/
      when tenure  > 8 then '>8'
    end as grouped_tenure
   from churn),
    t2(churned,grouped_tenure,counts)
 as(
   select churned , grouped_tenure , count(grouped_tenure)
   from t1 
   group by churned , grouped_tenure)
select 
       a.grouped_tenure as tenure,
       a.counts as churn_yes_counts,
       b.counts as churned_no_counts,
       round((a.counts::decimal/(a.counts + b.counts))*100,1) as rate1,
       round((b.counts::decimal/(a.counts + b.counts))*100,1) as rate0
from t2 a 
join t2 b 
 on a.grouped_tenure = b.grouped_tenure
where a.churned =  '1'
 and b.churned = '0'
order by rate1 desc;

/*Getting the churn counts and rate by age group*/
with t1(churned,grouped_age)
 as(
   select churned ,
    case 
      when age  < 30 then '<30'
      when age  >= 30 and age < 40 then '30-39'
      when age  >= 40 and age < 50 then '40-49'    /*grouping the ages*/
      when age  > 49 then '>50'
    end as grouped_age
   from churn),
    t2(churned,grouped_age,counts)
 as(
   select churned , grouped_age , count(grouped_age)
   from t1 
   group by churned , grouped_age)
select 
       a.grouped_age as age,
       a.counts as churn_yes_counts,
       b.counts as churned_no_counts,
       round((a.counts::decimal/(a.counts + b.counts))*100,1) as rate1,
       round((b.counts::decimal/(a.counts + b.counts))*100,1) as rate0
from t2 a 
join t2 b 
 on a.grouped_age = b.grouped_age
where a.churned =  '1'
 and b.churned = '0'
order by rate1 desc;

/*Getting the churn counts and rate by credit score*/
with t1(churned,creditscore)
 as(
   select churned ,
    case 
      when creditscore  < 500 then '<500'
      when creditscore  >= 500 and creditscore < 701 then '500-700'   /*grouping the credit score*/    
      when creditscore  > 700 then '>700'
    end as creditscore
   from churn),
    t2(churned,creditscore,counts)
 as(
   select churned , creditscore , count(creditscore)
   from t1 
   group by churned , creditscore)
select 
       a.creditscore as creditscore,
       a.counts as churn_yes_counts,
       b.counts as churned_no_counts,
       round((a.counts::decimal/(a.counts + b.counts))*100,1) as rate1,
       round((b.counts::decimal/(a.counts + b.counts))*100,1) as rate0
from t2 a 
join t2 b 
 on a.creditscore = b.creditscore
where a.churned =  '1'
 and b.churned = '0'
order by rate1 desc;

/*Getting the churn counts and rate by salary group*/
with t1(churned,estimatedsalary)
 as(
   select churned ,
    case 
      when estimatedsalary  < 50000 then '<50000'
      when estimatedsalary  >= 50000 and estimatedsalary < 100000 then '50000-100000'   /*grouping the Estimated salaries*/    
      when estimatedsalary  >= 100000 and estimatedsalary < 150000 then '100000-150000'       
      when estimatedsalary > 150000 then '>150000'
    end as estimatedsalary
   from churn),
    t2(churned,estimatedsalary,counts)
 as(
   select churned , estimatedsalary , count(estimatedsalary)
   from t1 
   group by churned , estimatedsalary)
select 
       a.estimatedsalary as estimatedsalary,
       a.counts as churn_yes_counts,
       b.counts as churned_no_counts,
       round((a.counts::decimal/(a.counts + b.counts))*100,1) as rate1,
       round((b.counts::decimal/(a.counts + b.counts))*100,1) as rate0
from t2 a 
join t2 b 
 on a.estimatedsalary = b.estimatedsalary
where a.churned =  '1'
 and b.churned = '0'
order by rate1 desc;

/*Getting the churn counts and rate by balance*/
with t1(churned,balance)
 as(
   select churned ,
    case 
      when balance  < 1 then '0'
      when balance  >= 1 and balance < 100000 then '1-10000'   /*grouping the balances*/    
      when balance  >= 10000 and balance < 150000 then '10000-150000'      
      when balance  > 150000 then '>150000'
    end as balance
   from churn),
    t2(churned,balance,counts)
 as(
   select churned , balance , count(balance)
   from t1 
   group by churned , balance)
select 
       a.balance as balance,
       a.counts as churn_yes_counts,
       b.counts as churned_no_counts,
       round((a.counts::decimal/(a.counts + b.counts))*100,1) as rate1,
       round((b.counts::decimal/(a.counts + b.counts))*100,1) as rate0
from t2 a 
join t2 b 
 on a.balance = b.balance
where a.churned =  '1'
 and b.churned = '0'
order by rate1 desc;