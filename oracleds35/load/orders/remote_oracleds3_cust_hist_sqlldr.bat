sqlldr ds3/ds3@orads3vm2 CONTROL=cust_hist.ctl, LOG=jan_cust_hist.log, BAD=jan_cust_hist.bad, DATA=..\..\..\data_files\orders\jan_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2 CONTROL=cust_hist.ctl, LOG=feb_cust_hist.log, BAD=feb_cust_hist.bad, DATA=..\..\..\data_files\orders\feb_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2  CONTROL=cust_hist.ctl, LOG=mar_cust_hist.log, BAD=mar_cust_hist.bad, DATA=..\..\..\data_files\orders\mar_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2  CONTROL=cust_hist.ctl, LOG=apr_cust_hist.log, BAD=apr_cust_hist.bad, DATA=..\..\..\data_files\orders\apr_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2  CONTROL=cust_hist.ctl, LOG=may_cust_hist.log, BAD=may_cust_hist.bad, DATA=..\..\..\data_files\orders\may_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2  CONTROL=cust_hist.ctl, LOG=jun_cust_hist.log, BAD=jun_cust_hist.bad, DATA=..\..\..\data_files\orders\jun_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2  CONTROL=cust_hist.ctl, LOG=jul_cust_hist.log, BAD=jul_cust_hist.bad, DATA=..\..\..\data_files\orders\jul_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2  CONTROL=cust_hist.ctl, LOG=aug_cust_hist.log, BAD=aug_cust_hist.bad, DATA=..\..\..\data_files\orders\aug_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2  CONTROL=cust_hist.ctl, LOG=sep_cust_hist.log, BAD=sep_cust_hist.bad, DATA=..\..\..\data_files\orders\sep_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2  CONTROL=cust_hist.ctl, LOG=oct_cust_hist.log, BAD=oct_cust_hist.bad, DATA=..\..\..\data_files\orders\oct_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2  CONTROL=cust_hist.ctl, LOG=nov_cust_hist.log, BAD=nov_cust_hist.bad, DATA=..\..\..\data_files\orders\nov_cust_hist.csv 
sqlldr ds3/ds3@orads3vm2  CONTROL=cust_hist.ctl, LOG=dec_cust_hist.log, BAD=dec_cust_hist.bad, DATA=..\..\..\data_files\orders\dec_cust_hist.csv 
exit