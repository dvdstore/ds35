# get_esxtop_avg_by_col_name.pl
# Script to parse an esxtop file and provide the average for the Physcial Cpu(_Total)% Util Time column
# Syntax to run - perl ds3_esxtop_avg_by_col_name.pl <esxtop_file_to_be_parsed> 
# key parameters that are changed often are at the top of the file  

use strict;
use warnings;

my $esxtopinputfilename = $ARGV[0];
my $VMname = $ARGV[1];
my $esxtopinputfile;
my @esxtoplines=();
my $esxtopHeader;
my @esxtopHeadervalues=();
my @esxtopColumnsToPrint=();
my @curline=();

my $searchstring;
my $cpuutilsum = 0;
my $cpuvalue = 0;

my $title = $ARGV[0];

#Create the file to hold the reduced version of the input esxtop file
#$outputcsv = $esxtopinputfilename . '_avg_utiltime'  . '.csv';
#open (my $OUT, ">$outputcsv") || die("Can't open $outputcsv");


$searchstring = "Physical Cpu(_Total)\\% Util Time";

#open (my $OUT, ">$outputcsv") || die("Can't open $outputcsv");

# print $OUT "Threads,OPM,ART,CPU,IOPS,LATENCY\n";  #output file header

#Open the target esxtop file and load contents into array
open(my $IN, "<$esxtopinputfilename");
@esxtoplines = <$IN>;
close($IN);

#Get esxtop header line and split it into it column names
$esxtopHeader = $esxtoplines[3];
@esxtopHeadervalues = split ",", $esxtopHeader;
#print "Total number of Columns in file: $#esxtopHeadervalues\n";


my $i = 0;
foreach (@esxtopHeadervalues){
  if (index($_, $searchstring) != -1) { #Check to see if $searchstring is a substring of the current esxtopHeadervalues variable
    push(@esxtopColumnsToPrint, $i);  # Create list of the index of matching columns
	}
  $i++;
  }
  
# Iterate through the esxtop input file line by line, and output only the identified matching columns 
my $k =0;
my $j =0;  
for (my $k=10; $k <= $#esxtoplines; $k++){   #start k at 10 to skip the first 10 lines
  @curline = split ",", $esxtoplines[$k];
  for  (my $j=0; $j <= $#esxtopColumnsToPrint; $j++){
    my $printindex = $esxtopColumnsToPrint[$j];
	chomp($printindex);
	$cpuvalue = $curline[$printindex];
	$cpuvalue =~ tr/"//d;        #strip off "s from the string
	$cpuutilsum = $cpuutilsum + $cpuvalue;
 } 
}

#print "The average is " . ($cpuutilsum / ($#esxtoplines - 9)) . "\n";  #subtract 9 to adjust for skipping the first 10 lines
 
print ($cpuutilsum / ($#esxtoplines - 9));


















