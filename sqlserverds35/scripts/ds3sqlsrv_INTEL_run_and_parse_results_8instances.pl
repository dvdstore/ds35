# ds3_run_and_parse_results.pl
# Script to run DS3 and mpstat and iostat, capture all the results into text files, and then parse them into a CSV
# Syntax to run - perl ds3_new_run_and_parse_results.pl <title of test> 
# key parameters that are changed often are at the top of the file  

use strict;
use warnings;

#my @threads_list = (8,9,10,11,12);
#my @threads_list = (12,13,14,15,16,17,18,28);
#my @threads_list = (26,27,28,29);
#my @threads_list = (32,33,34,35,36);
#my @threads_list = (12,14,16,18,20,22,24);
#my @threads_list = (16,18,20,22,24,26);
my @threads_list = (8,12,16,20);
#my @threads_list = (12);
my $num_drivers = 16;
my $ds3_target = "10.133.255.63";
my $esx_target = "w1-outperf28.eng.vmware.com";
my $intervals = 45;  # number of stats collection intervals 
my $delay = 10;      # time between each stats collection interval

my $ds3outputfile;
my $ds3outputfile2;
my $ds3mpstatfile;
my $ds3iostatfile;
my $lastline;
my @ds3lines=();
my @ds3values=();
my @mpstatlines=();
my @mpstatvalues=();
my @iostatlines=();
my @iostatvalues=();
my $ds3opm;
my $ds3art;
my $ds3cpu;
my $ds3threads;
my $mpstatidletotal;
my $mpstatcpupct;
my $iostatiopstotal;
my $iostatiopsavg;
my $iostatsrvtimetotal;
my $iostatsrvtimeavg;
my $iostatnumvalues;
my $esxtopcpuavg;
my $outputcsv;

my $title = $ARGV[0];

foreach my $i (0 .. $#threads_list) {

  #driver 1 for instance 1
    print  "start cmd /c ds35sqlserverdriver.exe --config_file=param1.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}1.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param1.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}1.csv");
	system("start cmd /c plink -pw \"\" root\@${esx_target} esxtop -b -d ${delay} -n ${intervals} ^> ${threads_list[$i]}thread${title}esxtop.csv");
    #system("start cmd /c plink -pw ca\$hc0w root\@${esx_target} esxtop -b -d ${delay} -n ${intervals} ^> ${threads_list[$i]}thread${title}esxtop.csv");
  #driver 2 for instance 1_2	
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param1_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}2.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param1_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}2.csv");
	
  #driver 3 for instance 2
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}3.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}3.csv");
	
#driver 4 for instance 2_2	
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param2_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}4.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param2_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}4.csv");
	
  #driver 5 for instance 3
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param3.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}5.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param3.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}5.csv");
	
#driver 6 for instance 3_2	
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param3_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}6.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param3_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}6.csv");
	
  #driver 7 for instance 4
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param4.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}7.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param4.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}7.csv");
		
  #driver 8 for instance 4_2
    print  "start cmd /c ds35sqlserverdriver.exe --config_file=param4_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}8.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param4_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}8.csv");
  
  #driver 9 for instance 5
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param5.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}9.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param5.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}9.csv");
	
  #driver 10 for instance 5_2
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param5_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}10.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param5_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}10.csv");
	
#driver 11 for instance 6	
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param6.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}11.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param6.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}11.csv");
	
  #driver 12 for instance 6_2
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param6_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}12.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param6_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}12.csv");
	
#driver 13 for instance 7	
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param7.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}13.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param7.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}13.csv");
	
  #driver 14 for instance 7_2
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param7_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}14.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param7_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}14.csv");
   #driver 15 for instance 8
	print  "start cmd /c ds35sqlserverdriver.exe --config_file=param8.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}15.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param8.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}15.csv");
		
			
	
	
  #driver 16 for instance 8_2
  print "ds35sqlserverdriver.exe --config_file=param8_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}${num_drivers}.csv --windows_perf_host=$ds3_target\n";
  `ds35sqlserverdriver.exe --config_file=param8_2.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}${num_drivers}.csv --windows_perf_host=$ds3_target`;
  print "End of Test $i. Sleeping 60 seconds before next test\n";
  sleep(60);
}

$outputcsv = $title . 'results.csv';

open (my $OUT, ">$outputcsv") || die("Can't open $outputcsv");

print $OUT "Threads,OPM,ART,CPU,ESXHOSTCPU\n";  #output file header

# Loop through the thread counts and get the results added to the outputcsv

foreach my $j (0 .. $#threads_list) {
  my $ds3outfilename = $threads_list[$j] .  'threads' . $title . '1.csv';
  my $ds3esxtopfilename = $threads_list[$j] . 'thread' . $title . 'esxtop.csv';	
  
  print "$ds3outfilename \n";
  print "$ds3esxtopfilename \n";	
  
  # Get OPM ART and CPU from first DS3 output files, one loop per driver output
  $ds3opm = 0;
  $ds3art = 0;
  
  foreach my $k (1 .. $num_drivers){
    $ds3outfilename = $threads_list[$j] .  'threads' . $title . $k . '.csv';
	$ds3outputfile = `type $ds3outfilename`;
	chomp($ds3outputfile);
	@ds3lines = split "\n", $ds3outputfile;
	foreach my $i (0 .. $#ds3lines) {
      $lastline = $ds3lines[$i];
    }
    @ds3values = split ",", $lastline;
    $ds3opm = $ds3opm + $ds3values[2];
    $ds3art = $ds3art + $ds3values[4];
  }
  $ds3art = ($ds3art / $num_drivers);
  
  # Get CPU util from the last driver output - this allows the CPU to only be collected by one driver program to avoid error when getting CPU from all drivers
  $ds3cpu = 0;
  $ds3outfilename = $threads_list[$j] .  'threads' . $title . $num_drivers . '.csv';
  chomp($ds3outputfile);
  @ds3lines = split "\n", $ds3outputfile;
  foreach my $i (0 .. $#ds3lines) {
    $lastline = $ds3lines[$i];
  }
  @ds3values = split ",", $lastline;
  $ds3cpu = $ds3cpu + $ds3values[8];
    
  print "Avg OPM - $ds3opm Avg RT - $ds3art Avg CPU Util - $ds3cpu \n";
  

  #Get mpstat average utilization
  #$ds3mpstatfile = `type $ds3mpstatfilename`;
  #chomp($ds3mpstatfile);
  #@mpstatlines = split "\n", $ds3mpstatfile;
  #$mpstatidletotal = 0;
  #foreach my $i (5 .. $#mpstatlines) {
  #  @mpstatvalues = split / /, $mpstatlines[$i];
  #  $mpstatidletotal = $mpstatidletotal + $mpstatvalues[$#mpstatvalues];
  #}
  #$mpstatcpupct = 100 - ($mpstatidletotal / ($#mpstatlines - 4));
  #print "\n";
  #print "Avg CPU usage - $mpstatcpupct \n";

  $esxtopcpuavg = `perl get_esxtop_avg_utiltime.pl $ds3esxtopfilename`;
  print "esxtop CPU % Util for host $esxtopcpuavg\n";
  
  print "threads list value at $j = $threads_list[$j]  number of drivers = $num_drivers\n";
  $ds3threads = $threads_list[$j] * $num_drivers;  #multiply threads by num_drivers becuase the mulitple drivers

  print "$ds3threads,$ds3opm,$ds3art,$ds3cpu,$esxtopcpuavg\n";
  print $OUT "$ds3threads,$ds3opm,$ds3art,$ds3cpu,$esxtopcpuavg\n";
  

} # end loop for all thread counts
close $OUT;

