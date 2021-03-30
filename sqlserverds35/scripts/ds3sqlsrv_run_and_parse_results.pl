# ds3_run_and_parse_results.pl
# Script to run DS3 and mpstat and iostat, capture all the results into text files, and then parse them into a CSV
# Syntax to run - perl ds3_run_and_parse_results.pl <title of test> 
# key parameters that are changed often are at the top of the file  

use strict;
use warnings;

#my @threads_list = (8,9,10,11,12);
#my @threads_list = (12,13,14,15,16,17,18,28);
#my @threads_list = (26,27,28,29);
#my @threads_list = (8,9,10,11);
my @threads_list = (1,2,3,5,6,7,8);
my $num_drivers = 2;
my $ds3_target = "10.133.255.57;10.133.255.57;10.133.255.57;10.133.255.57";
my $esx_target = "w1-outperf29.eng.vmware.com";
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

  foreach my $j (1 .. ($num_drivers-1)){
    print  "start cmd /c ds35sqlserverdriver.exe --config_file=param.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}${j}.csv\n"; 
    system("start cmd /c ds35sqlserverdriver.exe --config_file=param.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}${j}.csv");
	system("start cmd /c plink -pw ca\$hc0w root\@${esx_target} esxtop -b -d ${delay} -n ${intervals} ^> ${threads_list[$i]}thread${title}esxtop.csv");
  }
  print "ds35sqlserverdriver.exe --config_file=param.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}${num_drivers}.csv --windows_perf_host=$ds3_target\n";
  `ds35sqlserverdriver.exe --config_file=param.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}${num_drivers}.csv --windows_perf_host=$ds3_target`;
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

