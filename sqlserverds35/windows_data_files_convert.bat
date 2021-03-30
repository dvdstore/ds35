REM windows_data_files_convert.bat 
REM DVD Store Database Version 3 - Convert .csv loader files in /data_files to windows style endings
REM This file was created to allow for the conversion of the sample small .csv files that are included
REM with the DVD Store.  Load .csv files created with by the Install_DVDStore.pl script can be specified
REM to be windows files at creation and do not need to be converted.  
REM Copyright (C) 2016 VMware, Inc. <djaffe@vmware.com> and <tmuirhead@vmware.com>
REM Last updated 1/14/16

cd ..\data_files\cust
ren us_cust.csv us_cust_temp.csv
ren row_cust.csv row_cust_temp.csv
type us_cust_temp.csv|more /P>us_cust.csv
type us_cust_temp.csv|more /P>row_cust.csv
del us_cust_temp.csv
del row_cust_temp.csv
cd ..\orders
ren apr_cust_hist.csv apr_cust_hist_temp.csv
ren apr_orderlines.csv apr_orderlines_temp.csv
ren apr_orders.csv apr_orders_temp.csv
ren aug_cust_hist.csv aug_cust_hist_temp.csv
ren aug_orderlines.csv aug_orderlines_temp.csv
ren aug_orders.csv aug_orders_temp.csv
ren dec_cust_hist.csv dec_cust_hist_temp.csv
ren dec_orderlines.csv dec_orderlines_temp.csv
ren dec_orders.csv dec_orders_temp.csv
ren feb_cust_hist.csv feb_cust_hist_temp.csv
ren feb_orderlines.csv feb_orderlines_temp.csv
ren feb_orders.csv feb_orders_temp.csv
ren inv.csv inv_temp.csv
ren jan_cust_hist.csv jan_cust_hist_temp.csv
ren jan_orderlines.csv jan_orderlines_temp.csv
ren jan_orders.csv jan_orders_temp.csv
ren jul_cust_hist.csv jul_cust_hist_temp.csv
ren jul_orderlines.csv jul_orderlines_temp.csv
ren jul_orders.csv jul_orders_temp.csv
ren jun_cust_hist.csv jun_cust_hist_temp.csv
ren jun_orderlines.csv jun_orderlines_temp.csv
ren jun_orders.csv jun_orders_temp.csv
ren mar_cust_hist.csv mar_cust_hist_temp.csv
ren mar_orderlines.csv mar_orderlines_temp.csv
ren mar_orders.csv mar_orders_temp.csv
ren may_cust_hist.csv may_cust_hist_temp.csv
ren may_orderlines.csv may_orderlines_temp.csv 
ren may_orders.csv may_orders_temp.csv
ren nov_cust_hist.csv nov_cust_hist_temp.csv
ren nov_orderlines.csv nov_orderlines_temp.csv
ren nov_orders.csv nov_orders_temp.csv
ren oct_cust_hist.csv oct_cust_hist_temp.csv
ren oct_orderlines.csv oct_orderlines_temp.csv
ren oct_orders.csv oct_orders_temp.csv
ren sep_cust_hist.csv sep_cust_hist_temp.csv
ren sep_orderlines.csv sep_orderlines_temp.csv
ren sep_orders.csv sep_orders_temp.csv
type apr_cust_hist_temp.csv|more /P>apr_cust_hist.csv 
type apr_orderlines_temp.csv|more /P>apr_orderlines.csv 
type apr_orders_temp.csv|more /P>apr_orders.csv 
type aug_cust_hist_temp.csv|more /P>aug_cust_hist.csv 
type aug_orderlines_temp.csv|more /P>aug_orderlines.csv 
type aug_orders_temp.csv|more /P>aug_orders.csv 
type dec_cust_hist_temp.csv|more /P>dec_cust_hist.csv 
type dec_orderlines_temp.csv|more /P>dec_orderlines.csv 
type dec_orders_temp.csv|more /P>dec_orders.csv 
type feb_cust_hist_temp.csv|more /P>feb_cust_hist.csv 
type feb_orderlines_temp.csv|more /P>feb_orderlines.csv 
type feb_orders_temp.csv|more /P>feb_orders.csv 
type inv_temp.csv|more /P>inv.csv 
type jan_cust_hist_temp.csv|more /P>jan_cust_hist.csv 
type jan_orderlines_temp.csv|more /P>jan_orderlines.csv 
type jan_orders_temp.csv|more /P>jan_orders.csv 
type jul_cust_hist_temp.csv|more /P>jul_cust_hist.csv 
type jul_orderlines_temp.csv|more /P>jul_orderlines.csv 
type jul_orders_temp.csv|more /P>jul_orders.csv 
type jun_cust_hist_temp.csv|more /P>jun_cust_hist.csv 
type jun_orderlines_temp.csv|more /P>jun_orderlines.csv 
type jun_orders_temp.csv|more /P>jun_orders.csv 
type mar_cust_hist_temp.csv|more /P>mar_cust_hist.csv 
type mar_orderlines_temp.csv|more /P>mar_orderlines.csv 
type mar_orders_temp.csv|more /P>mar_orders.csv 
type may_cust_hist_temp.csv|more /P>may_cust_hist.csv 
type may_orderlines_temp.csv|more /P>may_orderlines.csv 
type may_orders_temp.csv|more /P>may_orders.csv 
type nov_cust_hist_temp.csv|more /P>nov_cust_hist.csv 
type nov_orderlines_temp.csv|more /P>nov_orderlines.csv 
type nov_orders_temp.csv|more /P>nov_orders.csv 
type oct_cust_hist_temp.csv|more /P>oct_cust_hist.csv 
type oct_orderlines_temp.csv|more /P>oct_orderlines.csv 
type oct_orders_temp.csv|more /P>oct_orders.csv 
type sep_cust_hist_temp.csv|more /P>sep_cust_hist.csv 
type sep_orderlines_temp.csv|more /P>sep_orderlines.csv 
type sep_orders_temp.csv|more /P>sep_orders.csv
del *_temp.csv 
cd ..\prod
ren inv.csv inv_temp.csv
ren prod.csv prod_temp.csv
type inv_temp.csv|more /P>inv.csv
type prod_temp.csv|more /P>prod.csv
del prod_temp.csv
del inv_temp.csv
cd ..\membership
ren membership.csv membership_temp.csv
type membership_temp.csv|more /P>membership.csv
del membership_temp.csv
cd ..\reviews
ren reviews.csv reviews_temp.csv
ren review_helpfulness.csv review_helpfulness_temp.csv
type reviews_temp.csv|more /P>reviews.csv
type review_helpfulnes_temp.csv|more /P>review_helpfulness.csv
del reviews_temp.csv
del review_helpfulness_temp.csv
cd ..\..\sqlserverds3