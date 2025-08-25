create database data_management_db;
use data_management_db;
create table customer_data_mgt1(ID int primary key,	Year_Birth text,Education varchar (50),Marital_Status varchar (50), Income text,kidhome int,
                              Teenhome int,Dt_Customer text, Recency int, MntWines int,	MntFruits int, MntMeatProducts int,	MntFishProducts int,
                              MntSweetProducts int, MntGoldProds int, NumDealsPurchases	int, NumWebPurchases int,	NumCatalogPurchases int,
                              NumStorePurchases int, NumWebVisitsMonth int,	AcceptedCmp3 int, AcceptedCmp4 int, AcceptedCmp5 int,
                              AcceptedCmp1 int, AcceptedCmp2 int, Response int,	Complain int, Country varchar (50));
rename table `customer_data_mgt1` to `marketing_data1`;

Load data infile "C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\marketing_data.csv" 
into table marketing_data1
fields terminated by "," 
enclosed by '"'
lines terminated by '\r\n'
ignore 1 lines;
select * from marketing_data1;

set sql_safe_updates = 0;
update marketing_data1
set `Dt_customer`= str_to_date(Dt_customer,"%m/%d/%Y");
alter table marketing_data1
modify column Dt_Customer date;
alter table marketing_data1
modify column Year_Birth int;

-- To Check for duplicates 
select Id,education,income,row_number() over(partition by id order by id desc) as duplicate_row from marketing_data1; 
-- To check for null Values
select * from marketing_data1 where income is null;
-- OR
SELECT * 
FROM marketing_data1
WHERE Income IS NULL
   OR Education IS NULL
   OR Marital_Status IS NULL
   OR KidHome IS NULL
   OR TeenHome IS NULL
   OR Recency IS NULL
   OR Dt_Customer IS NULL
   OR MntWines IS NULL
   OR MntFruits IS NULL
   OR MntMeatProducts IS NULL
   OR MntFishProducts IS NULL;

update marketing_data1
set education  = "Graduates" 
where education = "Graduation";
update marketing_data1
set education = "2nd Level"
where education = "2n Cycle";
update marketing_data1
set country = "Germany"
where country = "GER";
SELECT distinct (education)FROM marketing_data1;

alter table marketing_data1
add column marital_category varchar (50);
update marketing_data1
set marital_category = (select case when marital_status in ("married","together") then "Married"
     when marital_status in ("single","widow","divorced","alone") then "Single"
     else "Complicated"
     end);
alter table marketing_data1
add column educational_category varchar (50);
update marketing_data1
set educational_category = (select case when education in ("Basic","2nd level") then "Undergraduate"
     when education in ("Graduates") then "Graduate"
     else "Post-Graduate"
     end);

select ((select year(current_date()) as currentDate) - year_birth) as Age from marketing_data1;
alter table marketing_data1
add column Age varchar (50);
update marketing_data1
set Age = ((select max(Registered_date)) - year_birth); 
alter table marketing_data1
modify column age int;

select Age,
case when age <= 22 then "Gen Z"
     when age <= 38 then "Millennial"
     when age <= 54 then "Gen X"
     when age <= 73 then "Boomers"
     else "Silent Gen" 
     end as Age_bracket from marketing_data1;
alter table marketing_data1
add column Age_bracket varchar (50);
update marketing_data1
set Age_bracket = (select case when age <= 22 then "Gen Z"
     when age <= 38 then "Millennial"
     when age <= 54 then "Gen X"
     when age <= 73 then "Boomers"
     else "Silent Gen" 
     end as Age_bracket); 

alter table marketing_data1
add column Total_amount varchar (50);
update marketing_data1
set Total_amount = (select concat("$",(mntwines+mntfruits+mntmeatproducts+mntfishproducts+mntsweetproducts+mntgoldprods)));
set sql_safe_updates = 0;

alter table marketing_data1
add column child_status varchar(50);
update marketing_data1
set child_status = (select case when no_of_children >= 1 then "Have Child " else "Does not Have Child"
                      End);
    
alter table marketing_data1
add column  No_Of_Children Int;
update marketing_data1
set  no_of_children = (kidhome + Teenhome);

alter table marketing_data1
add column Total_Number_Of_Purchase int;
update marketing_data1
set Total_Number_Of_Purchase = (numwebpurchases + numcatalogpurchases + numstorepurchases); 

alter table marketing_data1
add column registered_date varchar (50);
update marketing_data1
set registered_date = year(dt_customer); 

select id,sum(income) as avg_income from marketing_data1
group by id;

select count(*) as total_customers from marketing_data1;
select sum(income) as Total_Income from marketing_data1;

select right(income,10) from marketing_data1;
update marketing_data1
set income = replace (income,"$"," ");
update marketing_data1
set total_amount = replace (total_amount,"$"," ");
alter table marketing_data1
modify column total_amount int;
alter table second_marketingdata
modify column Monetary int;


select sum(income) from marketing_data1;
select id,avg(income) as avg_income from marketing_data1
group by id; 

-- Advanced Queries
-- Total income
select concat("$",sum(income)) as total_income from marketing_data1;
-- Average income per customer
select concat("$",round(avg(income),2)) as avg_income_per_customer from marketing_data1;
-- Average recency
select round(avg(recency),2) as avg_recency from marketing_data1;
-- Average Frequency
select round(avg(Frequency),0) as avg_Frequency from second_marketingdata;
-- Average Monetary
select round(avg(monetary),2) as avg_monetary from second_marketingdata;


select "AcceptedCmp1" as Campaign_Acceptance,count(AcceptedCmp1) as Number_of_campaign from marketing_data1
where AcceptedCmp1 > 0
group by AcceptedCmp1
union all
select "AcceptedCmp2",count(AcceptedCmp2) from marketing_data1
where AcceptedCmp2 > 0
group by AcceptedCmp2
union all
select "AcceptedCmp3",count(AcceptedCmp3) from marketing_data1
where AcceptedCmp3 > 0
group by AcceptedCmp3
union all
select "AcceptedCmp4",count(AcceptedCmp4) from marketing_data1
where AcceptedCmp4 > 0
group by AcceptedCmp4
union all
select "AcceptedCmp5",count(AcceptedCmp5) from marketing_data1
where AcceptedCmp5 > 0 
group by AcceptedCmp5;


select "AcceptedCmp1" as Campaign_Acceptance,marital_category,count(id) as Number_of_campaign from marketing_data1
where AcceptedCmp1 > 0
group by AcceptedCmp1,marital_category
union all
select "AcceptedCmp2",marital_category,count(id) from marketing_data1
where AcceptedCmp2 > 0
group by AcceptedCmp2,marital_category
union all
select "AcceptedCmp3",marital_category,count(id) from marketing_data1
where AcceptedCmp3 > 0
group by AcceptedCmp3,marital_category
union all
select "AcceptedCmp4",marital_category,count(id) from marketing_data1
where AcceptedCmp4 > 0
group by AcceptedCmp4,marital_category
union all
select "AcceptedCmp5",marital_category,count(id) as MA from marketing_data1
where AcceptedCmp5 > 0 
group by AcceptedCmp5,Marital_category;


select "AcceptedCmp1" as Campaign_Acceptance,educational_category,count(id) as Number_of_campaign from marketing_data1
where AcceptedCmp1 > 0
group by AcceptedCmp1,educational_category
union all
select "AcceptedCmp2",educational_category,count(id) from marketing_data1
where AcceptedCmp2 > 0
group by AcceptedCmp2,educational_category
union all
select "AcceptedCmp3",educational_category,count(id) from marketing_data1
where AcceptedCmp3 > 0
group by AcceptedCmp3,educational_category
union all
select "AcceptedCmp4",educational_category,count(id) from marketing_data1
where AcceptedCmp4 > 0
group by AcceptedCmp4,educational_category
union all
select "AcceptedCmp5",educational_category,count(id) as MA from marketing_data1
where AcceptedCmp5 > 0 
group by AcceptedCmp5,educational_category;


select "AcceptedCmp1" as Campaign_Acceptance,Age_bracket,count(id) as Number_of_campaign from marketing_data1
where AcceptedCmp1 > 0
group by AcceptedCmp1,Age_bracket
union all
select "AcceptedCmp2",Age_bracket,count(id) from marketing_data1
where AcceptedCmp2 > 0
group by AcceptedCmp2,Age_bracket
union all
select "AcceptedCmp3",Age_bracket,count(id) from marketing_data1
where AcceptedCmp3 > 0
group by AcceptedCmp3,Age_bracket
union all
select "AcceptedCmp4",Age_bracket,count(id) from marketing_data1
where AcceptedCmp4 > 0
group by AcceptedCmp4,Age_bracket
union all
select "AcceptedCmp5",Age_bracket,count(id) as MA from marketing_data1
where AcceptedCmp5 > 0 
group by AcceptedCmp5,Age_bracket;



-- Customer demography info
-- Number of customer
select count(id) as No_of_Customers from marketing_data1;
-- Number of customer by educational background
select educational_category,count(id) as Customer_by_ED_category from marketing_data1
group by educational_category
order by Customer_by_ED_category;
-- Number of customer by marital status
select marital_category,count(id) as customer_by_Maritalcategory from marketing_data1
group by marital_category
order by customer_by_Maritalcategory;
-- No of customer by generation
select age_bracket,count(id) as Customer_by_Generation from marketing_data1
group by Age_bracket
order by Customer_by_Generation;
-- Total money spent by educational category
select educational_category,concat("$",sum(total_amount)) as Total_Amount_by_EducationalCategory from marketing_data1
group by educational_category
order by Total_Amount_by_EducationalCategory;
--
select marital_category,concat("$",sum(total_amount)) as Total_Amount_by_MaritalCategory from marketing_data1
group by marital_category
order by Total_Amount_by_maritalCategory;
-- Total money spent by country
select country,concat("$",sum(total_amount)) as Totalamount_by_Country from marketing_data1
group by country
order by Totalamount_by_Country;
-- Total spending by generatiom 
select age_bracket,concat("$",sum(total_amount)) as Totalamount_by_Generation from marketing_data1
group by Age_bracket
order by Totalamount_by_Generation desc;
-- Total spending by child status
select child_status,concat("$",sum(total_amount)) as Totalamount_by_childstatus from marketing_data1
group by child_status
order by Totalamount_by_childstatus;
-- Purchase frequency by country
select country,sum(total_number_of_purchase) as purchase_frequency_by_Country from marketing_data1
group by country
order by purchase_frequency_by_Country;

-- Purchasing channel 
-- Educational
select educational_category,count(numwebpurchases) as WebPurchases from marketing_data1
group by educational_category
order by webpurchases;
-- Country
select country,count(numwebpurchases) as WebPurchases from marketing_data1
group by country
order by webpurchases;
-- Marital category
select marital_category,count(numwebpurchases) as WebPurchases from marketing_data1
group by marital_category
order by WebPurchases;
-- Total Web visits/registered month
select registered_date, sum(NumWebVisitsMonth) as Totalwebvisit from marketing_data1
group by registered_date
order by registered_date asc;

-- Campaign Acceptance Information 
-- alter table marketing_data1
-- add column Total_Number_Of_AcceptedCpn int;
-- update marketing_data1
-- set Total_Number_Of_AcceptedCpn = (AcceptedCmp1+AcceptedCmp2+AcceptedCmp3+AcceptedCmp4+AcceptedCmp5);
-- Acceptance by Marital Category
select marital_category,count(total_number_of_acceptedcpn) as AcceptedCampaign from marketing_data1
group by marital_category
order by AcceptedCampaign;
-- Acceptance by Educational_category 
select educational_category,count(total_number_of_acceptedcpn) as AcceptedCampaign from marketing_data1
group by educational_category
order by AcceptedCampaign;
-- Acceptance by Generation 
select age_bracket,count(total_number_of_acceptedcpn) as AcceptedCampaign from marketing_data1
group by Age_bracket
order by AcceptedCampaign;

-- Response Information 
-- Response by Marital Category 
select marital_category,sum(response) as Total_Response from marketing_data1
group by marital_category
order by Total_response;
-- Response by Educational category
select educational_category,sum(response) as Total_Response from marketing_data1
group by educational_category
order by Total_response;
-- Response by Generation
select Age_bracket,sum(response) as Total_Response from marketing_data1
group by Age_bracket
order by Total_response;

-- Complaints Information 
-- Complaints by Marital Category
select marital_category,sum(complain) as Total_complain from marketing_data1
group by marital_category
order by Total_complain;
-- Complain by Educational category
select educational_category,sum(complain) as Total_complain from marketing_data1
group by educational_category
order by Total_complain;
-- Complain by Generation
select Age_bracket,sum(complain) as Total_complain from marketing_data1
group by Age_bracket
order by Total_complain; 
select * from marketing_data1;
select concat("$",sum(total_amount)) as Total_sales from marketing_data1;
-- Total sales by Educational_category
select educational_category,concat("$",sum(total_amount)) as Total_sales from marketing_data1
group by educational_category;
-- Total sales by marital_category
select marital_category,concat("$",sum(total_amount)) as Total_sales from marketing_data1
group by marital_category;
-- Total sales by Age bracket
select Age_bracket,concat("$",sum(total_amount)) as Total_sales from marketing_data1
group by Age_bracket;




-- Write CTE queries to calculate the response rates for each campaign
-- Campaign rate 1
with CTE as (select sum(acceptedcmp1) as Totalacceptedcmp1 from marketing_data1)
select round(totalacceptedcmp1/(select sum(total_number_of_acceptedcpn) from marketing_data1),2) as C_Rate_1 from CTE;

-- Campaign rate 2
with CTE as (select sum(acceptedcmp2) as Totalacceptedcmp2 from marketing_data1)
select round(totalacceptedcmp2/(select sum(total_number_of_acceptedcpn) from marketing_data1),2) as C_Rate_2 from CTE;

-- Campaign rate 3
with CTE as (select sum(acceptedcmp3) as Totalacceptedcmp3 from marketing_data1)
select round(totalacceptedcmp3/(select sum(total_number_of_acceptedcpn) from marketing_data1),2) as C_Rate_3 from CTE;

-- Campaign rate 4
with CTE as (select sum(acceptedcmp4) as Totalacceptedcmp4 from marketing_data1)
select round(totalacceptedcmp4/(select sum(total_number_of_acceptedcpn) from marketing_data1),2) as C_Rate_4 from CTE;

-- Campaign rate 5
with CTE as (select sum(acceptedcmp5) as Totalacceptedcmp5 from marketing_data1)
select round(totalacceptedcmp5/(select sum(total_number_of_acceptedcpn) from marketing_data1),2) as C_Rate_5 from CTE;

-- Idenify customers who have accepted multiple campaigns and analyze their behaviour
select total_number_of_acceptedcpn,count(id) from marketing_data1
where total_number_of_acceptedcpn >1
group by total_number_of_acceptedcpn;

Create table Second_MarketingData as select * from marketing_data1;
select * from second_marketingdata;

alter table Second_MarketingData
drop column Total_Number_Of_AcceptedCpn;

alter table second_marketingdata
rename column `Total_amount` to `Monetary`;
alter table second_marketingdata 
add column Monetaryrank int; 
alter table second_marketingdata 
add column Recencyyrank int;
alter table second_marketingdata 
add column Frequencyrank int;

update second_marketingdata 
set Monetaryrank = (select ntile(5) over (order by monetary asc) as MonetaryRank);
set sql_safe_updates = 0;
update second_marketingdata 
set Recencyyrank = (select ntile(5) over (order by monetary desc) as Recencyyrank);
update second_marketingdata 
set Frequencyrank = (select ntile(5) over (order by monetary asc) as Frequencyrank);
select * FROM second_marketingdata;
set sql_safe_updates = 0;
-- Calculating RFM Rank
with RFM as (select Id,Recency,Frequency,Monetary from second_marketingdata)
select *, ntile(3) over (order by Recency desc) as rfm_recency,
		  ntile(3) over (order by Frequency asc) as rfm_frequency,
          ntile(3) over (order by Monetary asc) as rfm_monetary from  RFM;

-- Calculate RFM Score
With RFM as (select Id,Recency,Frequency,Monetary from second_marketingdata group by id,recency,frequency,monetary),
rfm_calculation as (select *,ntile(3) over (order by Recency desc) as rfm_recency,
		  ntile(3) over (order by Frequency asc) as rfm_frequency,
          ntile(3) over (order by Monetary asc) as rfm_monetary from  RFM)
select *,rfm_recency + rfm_frequency + rfm_monetary as rfm_score, concat(rfm_recency,rfm_frequency,rfm_monetary) as rfm from rfm_calculation;

-- Customer Segmentation(write queries to calculate recency, frequency and monetary value for each customer.)
select *, 
       case when rfm in (311,312,311) then "New Customers"
            when rfm in (111,121,131,122,133,112,132) then "Lost Customers" 
            when rfm in (212,313,123,221,211,232) then "Regualar Customers"
            when rfm in (223,222,213,322,231,321,331) then "Loyal Customers"
            when rfm in (333,332,323,233) then "Champion Customers"
            End as RFM_segment
from (with rfm as (select id,recency,frequency,monetary from second_marketingdata),
           rfm_calculation as (select *, ntile(3) over (order by Recency desc) as rfm_recency,
		  ntile(3) over (order by Frequency asc) as rfm_frequency,
          ntile(3) over (order by Monetary asc) as rfm_monetary from  RFM)
          select *,rfm_recency + rfm_frequency + rfm_monetary as rfm_score, 
          concat(rfm_recency,rfm_frequency,rfm_monetary) as rfm from rfm_calculation) as rfm_derived;
          
-- perfom an RFM analysis to identify high-value customers. 
With rfm as (select id,recency,frequency,monetary
from second_marketingdata),
rfm_calculation as (Select *,ntile(3) over (order by recency) AS rfm_recency,
                             ntile(3) over (order by frequency asc) AS rfm_frequency,
                             ntile(3) over (order by monetary) AS rfm_monetary
                             from rfm),
rfm_derived as (select *, rfm_recency + rfm_frequency + rfm_monetary as rfm_score,
concat( rfm_recency, rfm_frequency, rfm_monetary) as rfm
from rfm_calculation)
select case 
            when rfm in (311,312,311) then "New Customers"
            when rfm in (111,121,131,122,133,112,132) then "Lost Customers" 
            when rfm in (212,313,123,221,211,232) then "Regualar Customers"
            when rfm in (223,222,213,322,231,321,331) then "Loyal Customers"
            when rfm in (333,332,323,233) then "Champion Customers"
            End as RFM_segment,
            count(id) as number_of_customers
            from rfm_derived
            group by rfm_segment;

select "wines" as product_category, concat("$",sum(MntWines)) as total_spent from marketing_data1
union all
select "fruits", concat("$",sum(MntFruits)) from marketing_data1
union all
select "meat products", concat("$",sum(MntMeatProducts)) from marketing_data1
union all
select "fish products", concat("$",sum(MntFishProducts)) from marketing_data1
union all
select "sweet products", concat("$",sum(MntSweetProducts)) from marketing_data1
union all
select "gold products", concat("$",sum(MntGoldProds)) from marketing_data1
order by total_spent desc;

select * from marketing_data1;


select "web" as purchase_category, concat("$",sum(numwebpurchases)) as total_amount_purchased from marketing_data1
union all 
select "catalog", concat("$",sum(NumCatalogPurchases)) from marketing_data1
union all
select "store", concat("$",sum(NumStorePurchases)) from marketing_data1
order by total_amount_purchased desc;


With rfm as (select id,recency,frequency,monetary
from second_marketingdata),
rfm_calculation as (Select *,ntile(3) over (order by recency) AS rfm_recency,
                             ntile(3) over (order by frequency asc) AS rfm_frequency,
                             ntile(3) over (order by monetary) AS rfm_monetary
                             from rfm),
rfm_derived as (select *, rfm_recency + rfm_frequency + rfm_monetary as rfm_score,
concat( rfm_recency, rfm_frequency, rfm_monetary) as rfm
from rfm_calculation)
select case 
            when rfm in (311,312,311) then "New Customers"
            when rfm in (111,121,131,122,133,112,132) then "Lost Customers" 
            when rfm in (212,313,123,221,211,232) then "Regualar Customers"
            when rfm in (223,222,213,322,231,321,331) then "Loyal Customers"
            when rfm in (333,332,323,233) then "Champion Customers"
            End as RFM_segment,
            concat("$",sum(monetary)) as TotalSales
            from rfm_derived
            group by rfm_segment
            order by TotalSales desc;

 
            
            
            
