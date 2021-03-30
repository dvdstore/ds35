bcp ds3..reviews1 in ..\..\..\data_files\reviews\reviews.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> reviews1.log
bcp ds3..reviews_helpfulness1 in ..\..\..\data_files\reviews\review_helpfulness.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> review_helpfulness1.log
time /T > finished1.txt
exit
