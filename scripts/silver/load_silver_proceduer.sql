use MY_DWH;
create or alter procedure silver.load_silver_layer as
begin
print'>>>truncating table silver.crm_cust_info' 
truncate table silver.crm_cust_info
print'>>>inserting data into silver.crm_cust_info' 

insert into silver.crm_cust_info([cst_id],[cst_key],[cst_firstname],[cst_lastname],[cst_material_status],[cst_gndr],[cst_create_date])
(
select [cst_id],
[cst_key],
trim(cst_firstname) 
as cst_firstname,
trim(cst_lastname) 
as cst_lastname,
case when [cst_material_status] ='M' 
then 'Married' 
when [cst_material_status]='S' 
then 'Single' 
else 'Unknown'  
end as [cst_material_status],
case when cst_gndr ='M' 
then 'Male' 
when cst_gndr='F' 
then 'Female' 
else 'Unknown' 
end as cst_gndr,
[cst_create_date]
from(
select *
,ROW_NUMBER()
over(partition by cst_id order by cst_create_date desc) 
as row_num 
from bronze.crm_cust_info where cst_id is not null ) 
as t
where row_num=1)

/*****************************************************/

print'>>>truncating table silver.crm_prd_info' 
truncate table silver.crm_prd_info
print'>>>inserting data silver.crm_prd_info' 

insert into silver.crm_prd_info(
prd_id ,
cat_id ,
prd_key ,
prd_nm ,
prd_cost ,
prd_line ,
prd_start_dt ,
prd_end_dt
)
select 
prd_id,
substring(prd_key,7,len(prd_key)) as prd_key,
replace(SUBSTRING(prd_key,1,5),'-','_') as cat_id,
prd_nm,
isnull(prd_cost,0) as prd_cost,
case when UPPER(trim(prd_line))='M' then 'Mountain'
	 when UPPER(trim(prd_line))='S' then 'Other Sales'
	 when UPPER(trim(prd_line))='R' then 'Road'
	 when UPPER(trim(prd_line))='T' then 'Touring'
	 else 'a/n' end as prd_line,
cast(prd_start_dt as date) as prd_start_dt,
cast(lead(prd_start_dt) over(partition by prd_key order by prd_start_dt )-1 as date) as prd_end_dt
from bronze.crm_prd_info

/*****************************************************/

print'>>>truncating table silver.crm_sales_details' 
truncate table silver.crm_sales_details
print'>>>inserting data into silver.crm_sales_details' 
insert into silver.crm_sales_details(sls_ord_num  ,
sls_prd_key ,
sls_cust_id  ,
sls_order_dt ,
sls_ship_dt ,
sls_due_dt ,
sls_salesi ,
sls_quantity ,
sls_price )

SELECT  [sls_ord_num]
      ,[sls_prd_key]
      ,[sls_cust_id]
      ,case when([sls_order_dt])=0 or len([sls_order_dt])!=8 then null
	  else cast(cast([sls_order_dt] as varchar)as date) end as [sls_order_dt]
      ,case when([sls_ship_dt])=0 or len([sls_ship_dt])!=8 then null
	  else cast(cast([sls_ship_dt] as varchar)as date) end as [sls_ship_dt]
      ,case when([sls_due_dt])=0 or len([sls_due_dt])!=8 then null
	  else cast(cast([sls_due_dt] as varchar)as date) end as [sls_due_dt]
      ,case when sls_price is null or sls_price<0   then abs(sls_salesi)/sls_quantity
	  else sls_price end  as sls_price,
	  sls_quantity
	  ,case when sls_salesi is null or sls_salesi<0 or sls_salesi !=abs(sls_price)*sls_quantity then abs(sls_price)*sls_quantity
	  else sls_salesi end as sls_sales
	  from bronze.crm_sales_details


/*****************************************************/

print'>>>truncating table silver.erp_cust_az12' 
truncate table silver.erp_cust_az12
print'>>>inserting data into silver.erp_cust_az12' 
insert into silver.erp_cust_az12(cid,bdate,gen)

select * from (select 
case when cid like 'NAS%' then SUBSTRING(cid,4,len(cid))
else cid end as cid,
case when bdate>getdate()
then null
else bdate end as bdate,
case when gen='F' then 'Female'
when gen ='M' then 'Male'
when gen is null or gen like ' %' then 'a/n' 
else gen end as gen

from bronze.erp_cust_az12

 )d 


/*****************************************************/

print'>>>truncating table silver.erp_loc_a101' 
truncate table silver.erp_loc_a101
print'>>>inserting data into silver.erp_loc_a101' 

insert into silver.erp_loc_a101(cid,cntry)
select REPLACE(cid,'-','')as cid,
case
when cntry in ('United States','US','USA') then 'USA'
when cntry ='DE' then 'Germany'
when cntry is null or cntry like ' %' then 'a/n'
else cntry end as cntry


from bronze.erp_loc_a101

/*****************************************************/

print'>>>truncating table silver.erp_px_cat_g1v2' 
truncate table silver.erp_cust_az12
print'>>>inserting data into silver.erp_px_cat_g1v2' 
insert into silver.erp_px_cat_g1v2(id,cat,subcat,maintenance)
select
* 
from 
bronze.erp_px_cat_g1v2

end
/******************************************************/
exec silver.load_silver_layer

