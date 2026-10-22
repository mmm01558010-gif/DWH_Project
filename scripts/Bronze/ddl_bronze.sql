# /*

Project: Data Warehouse
Layer: Bronze
Script: Load Bronze Layer
Description:
This script creates the Bronze layer tables and a stored
procedure to load raw data from CRM and ERP CSV files.

Main Operations:
1. Create Bronze layer tables.
2. Truncate existing data before loading.
3. Load raw data using BULK INSERT.
4. Measure the loading duration for each table.
5. Handle errors using TRY...CATCH.

Source Systems:
- CRM
- ERP

Technologies:
- Microsoft SQL Server
- T-SQL
=======

*/

create table bronze.crm_cust_info(
cst_id int ,
cst_key nvarchar(50),
cst_firstname varchar(50),
cst_lastname varchar(50),
cst_material_status varchar(50),
cst_gndr varchar(1),
cst_create_date date
);
create table bronze.crm_prd_info(
prd_id int,
prd_key varchar(50),
prd_nm varchar(50),
prd_cost int,
prd_line varchar(3),
prd_start_dt datetime,
prd_end_dt datetime
);
create table bronze.crm_sales_details(
sls_ord_num varchar(50) ,
sls_prd_key varchar(50),
sls_cust_id int ,
sls_order_dt int,
sls_ship_dt int,
sls_due_dt int,
sls_salesi int,
sls_quantity int,
sls_price int
);

create table bronze.erp_loc_a101(
cid varchar(50),
cntry varchar(50)
);

create table bronze.erp_cust_az12(
cid varchar(50),
bdate date,
gen varchar(50)
);
create table bronze.erp_px_cat_g1v2(
id varchar(50),
cat varchar(50),
subcat varchar(50),
maintenance varchar(50)
);
create or alter procedure bronze.load_data
as
begin
declare @start_time datetime , @end_time datetime,@s_time datetime,@e_time datetime
begin try
set @s_time=getdate()
set @start_time=getdate()
print '============================'
print 'loading bronze layer'
print '============================'
print '----------------------------'
print 'loading crm tables'
print '----------------------------'
print 'truncating table:bronze.crm_cust_info'
truncate table bronze.crm_cust_info ;
print 'inserting data into: bronze.crm_cust_info'
bulk insert bronze.crm_cust_info 
from 'C:\Users\abden\OneDrive\Desktop\DWH_Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
with(
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time=getdate()
print 'load duration: '+cast(datediff(second,@start_time,@end_time) as varchar) +' second'
print '---------------------------------------------------------------'


set @start_time=getdate()
print 'truncating table:bronze.crm_prd_info'
truncate table bronze.crm_prd_info ;
print 'inserting data into: bronze.crm_prd_info'
bulk insert bronze.crm_prd_info
from 'C:\Users\abden\OneDrive\Desktop\DWH_Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
with(
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time=getdate()
print 'load duration: '+cast(datediff(second,@start_time,@end_time) as varchar) +' second'
print '---------------------------------------------------------------'


set @start_time=getdate()
print 'truncating table:bronze.crm_sales_details'
truncate table bronze.crm_sales_details ;
print 'inserting data into: bronze.crm_sales_details'
bulk insert bronze.crm_sales_details
from 'C:\Users\abden\OneDrive\Desktop\DWH_Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
with(
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time=getdate()
print 'load duration: '+cast(datediff(second,@start_time,@end_time) as varchar) +' second'
print '---------------------------------------------------------------'


set @start_time=getdate()
print 'truncating table:bronze.erp_cust_az12'
truncate table bronze.erp_cust_az12 ;
print 'inserting data into: bronze.erp_cust_az12'
bulk insert bronze.erp_cust_az12
from 'C:\Users\abden\OneDrive\Desktop\DWH_Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
with(
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time=getdate()
print 'load duration: '+cast(datediff(second,@start_time,@end_time) as varchar) +' second'
print '---------------------------------------------------------------'


set @start_time=getdate()
print 'truncating table:bronze.erp_loc_a101'
truncate table bronze.erp_loc_a101 ;
print 'inserting data into: bronze.erp_loc_a101'
bulk insert bronze.erp_loc_a101
from 'C:\Users\abden\OneDrive\Desktop\DWH_Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
with (
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time=getdate()
print 'load duration: '+cast(datediff(second,@start_time,@end_time) as varchar) +' second'
print '---------------------------------------------------------------'


set @start_time=getdate()
print 'truncating table:bronze.erp_px_cat_g1v2'
truncate table bronze.erp_px_cat_g1v2 ;
print 'inserting data into: bronze.erp_px_cat_g1v2'
bulk insert bronze.erp_px_cat_g1v2
from 'C:\Users\abden\OneDrive\Desktop\DWH_Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
with(
firstrow=2,
fieldterminator=',',
tablock
);
set @end_time=getdate()
print 'load duration: '+cast(datediff(second,@start_time,@end_time) as varchar) +' second'
print '---------------------------------------------------------------'
set @e_time=getdate()
print 'all duration of loading is: '+cast(datediff(second,@s_time,@e_time) as varchar) +' second'


end try
begin catch
print '============================'
print 'Error occured during loading bronze layer'
print 'error message'+cast(error_message() as varchar)
print 'error message'+cast(error_number() as varchar)
print 'error message'+cast(error_state() as varchar)
print '============================'
end catch
end;
