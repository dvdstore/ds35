# ds3_run_and_parse_results.pl
# Script to run DS3 and mpstat and iostat, capture all the results into text files, and then parse them into a CSV
# Syntax to run - perl ds3_run_and_parse_results.pl <title of test> 
# key parameters that are changed often are at the top of the file  

use strict;
use warnings;

my @threads_list = (4,10,12,14);
my $num_drivers = 10;
my $ds3_target = "10.133.255.57";

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
my $ds3threads;
my $mpstatidletotal;
my $mpstatcpupct;
my $iostatiopstotal;
my $iostatiopsavg;
my $iostatsrvtimetotal;
my $iostatsrvtimeavg;
my $iostatnumvalues;
my $outputcsv;

my $title = $ARGV[0];

foreach my $i (0 .. $#threads_list) {

  print "start cmd /c plink -pw ca\$hc0w root\@${ds3_target} mpstat 10 36 ^>  ${threads_list[$i]}thread${title}mpstat.out\n";   
  #`start cmd /c plink -pw ca\$hc0w root\@10.133.255.192 mpstat 10 36 ^>  ${threads_list[$i]}thread${title}mpstat.out\n`;
  system("start cmd /c plink -pw ca\$hc0w root\@${ds3_target} mpstat 10 36 ^>  ${threads_list[$i]}thread${title}mpstat.out");
  system("start cmd /c plink -pw ca\$hc0w root\@${ds3_target} iostat -d -x sdb sdc 10 36 ^> ${threads_list[$i]}thread${title}iostat.out");
  foreach my $j (1 .. ($num_drivers-1)){
    print  "start cmd /c ds35oracledriver.exe --config_file=param35vds.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}${j}.csv\n"; 
    system("start cmd /c ds35oracledriver.exe --config_file=param35vds.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}${j}.csv");
  }
  print "ds35oracledriver.exe --config_file=param35vds.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}${num_drivers}.csv\n";
  `ds35oracledriver.exe --config_file=param35vds.txt --n_threads=${threads_list[$i]} --out_filename=${threads_list[$i]}threads${title}${num_drivers}.csv`;
  print "End of Test $i. Sleeping 60 seconds before next test\n";
  sleep(60);
}

$outputcsv = $title . 'results.csv';

open (my $OUT, ">$outputcsv") || die("Can't open $outputcsv");

print $OUT "Threads,OPM,ART,CPU,IOPS,LATENCY\n";  #output file header

# Loop through the thread counts and get the results added to the outputcsv

foreach my $j (0 .. $#threads_list) {
  my $ds3outfilename = $threads_list[$j] .  'threads' . $title . '1.csv';
  my $ds3mpstatfilename = $threads_list[$j] .  'thread' . $title . 'mpstat.out';
  my $ds3iostatfilename = $threads_list[$j] .  'thread' . $title . 'iostat.out';

  print "$ds3outfilename \n";
  print "$ds3mpstatfilename \n";
  print "$ds3iostatfilename \n";

  # Get OPM and ART from first DS3 output files, one loop per driver output
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
  print "Avg OPM - $ds3opm Avt RT - $ds3art \n";

  #Get mpstat average utilization
  $ds3mpstatfile = `type $ds3mpstatfilename`;
  chomp($ds3mpstatfile);
  @mpstatlines = split "\n", $ds3mpstatfile;
  $mpstatidletotal = 0;
  foreach my $i (5 .. $#mpstatlines) {
    @mpstatvalues = split / /, $mpstatlines[$i];
    $mpstatidletotal = $mpstatidletotal + $mpstatvalues[$#mpstatvalues];
  }
  $mpstatcpupct = 100 - ($mpstatidletotal / ($#mpstatlines - 4));
  print "\n";
  print "Avg CPU usage - $mpstatcpupct \n";

  #Get iostat avg IOPs and service time (latency)
  $ds3iostatfile = `type $ds3iostatfilename`;
  chomp($ds3iostatfile);
  @iostatlines = split '\n', $ds3iostatfile;
  $iostatiopstotal = 0;
  $iostatsrvtimetotal = 0;
  $iostatnumvalues = 0;
  foreach my $i (4 .. $#iostatlines) {
    @iostatvalues = split ' ', $iostatlines[$i];
    if (($#iostatvalues >= 0) && ($iostatvalues[0] eq 'sdb')) {
      $iostatiopstotal = $iostatiopstotal + $iostatvalues[2] + $iostatvalues[3];
      $iostatsrvtimetotal = $iostatsrvtimetotal + $iostatvalues[9];
      $iostatnumvalues = $iostatnumvalues + 1;
    }
	if (($#iostatvalues >= 0) && ($iostatvalues[0] eq 'sdc')) {
      $iostatiopstotal = $iostatiopstotal + $iostatvalues[2] + $iostatvalues[3];
      $iostatsrvtimetotal = $iostatsrvtimetotal + $iostatvalues[9];
    }
  }
  $iostatiopsavg = $iostatiopstotal / $iostatnumvalues;
  $iostatsrvtimeavg = $iostatsrvtimetotal / $iostatnumvalues;
  print "Avg IOPs - $iostatiopsavg  Avg Srv Time - $iostatsrvtimeavg \n";
  print "threads list value at $j = $threads_list[$j]  number of drivers = $num_drivers\n";
  $ds3threads = $threads_list[$j] * $num_drivers;  #multiply threads by num_drivers becuase the mulitple drivers

  print "$ds3threads,$ds3opm,$ds3art,$mpstatcpupct,$iostatiopsavg,$iostatsrvtimeavg\n";
  print $OUT "$ds3threads,$ds3opm,$ds3art,$mpstatcpupct,$iostatiopsavg,$iostatsrvtimeavg\n";
  

} # end loop for all thread counts
close $OUT;

