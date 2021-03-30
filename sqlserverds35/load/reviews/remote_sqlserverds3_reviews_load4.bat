bcp ds3..reviews4 in ..\..\..\data_files\reviews\reviews.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> reviews4.log
bcp ds3..reviews_helpfulness4 in ..\..\..\data_files\reviews\review_helpfulness.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> review_helpfulness4.log
time /T > finished4.txt
exit
