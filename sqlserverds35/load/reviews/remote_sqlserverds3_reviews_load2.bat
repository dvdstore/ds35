bcp ds3..reviews2 in ..\..\..\data_files\reviews\reviews.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> reviews2.log
bcp ds3..reviews_helpfulness2 in ..\..\..\data_files\reviews\review_helpfulness.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> review_helpfulness2.log
time /T > finished2.txt
exit
