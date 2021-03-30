bcp ds3..reviews5 in ..\..\..\data_files\reviews\reviews.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> reviews5.log
bcp ds3..reviews_helpfulness5 in ..\..\..\data_files\reviews\review_helpfulness.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> review_helpfulness5.log
time /T > finished5.txt
exit
