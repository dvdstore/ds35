# get_esxtop_vm_diskstats.pl
# Script to parse an esxtop file and provide a csv file with the columns for the VMs virtual disk performance
# Syntax to run - perl get_esxtop_vm_diskstats.pl <esxtop_file_to_be_parsed> <VMname> > <redirect output to the filename you choose>
# key parameters that are changed often are at the top of the file  

use strict;
use warnings;

my $esxtopinputfilename = $ARGV[0];
#my $VMname = $ARGV[1];
my $esxtopinputfile;
my @esxtoplines=();
my $esxtopHeader;
my @esxtopHeadervalues=();
my @esxtopColumnsToPrint=();
my @curline=();

# my $searchstring;
my $cpuutilsum = 0;
my $esxtopvalue = 0;

my $searchstring = $ARGV[1];

# $searchstring = "W2K19SQL5-nvme";

#Create the file to hold the reduced version of the input esxtop file
#$outputcsv = $esxtopinputfilename . '_avg_utiltime'  . '.csv';
#open (my $OUT, ">$outputcsv") || die("Can't open $outputcsv");




#open (my $OUT, ">$outputcsv") || die("Can't open $outputcsv");

#Open the target esxtop file and load contents into array
open(my $IN, "<$esxtopinputfilename");
@esxtoplines = <$IN>;
close($IN);

#Get esxtop header line and split it into it column names
$esxtopHeader = $esxtoplines[0];
@esxtopHeadervalues = split ",", $esxtopHeader;


my $i = 0;
foreach (@esxtopHeadervalues){
  #print "$_\n";
  if (index($_, $searchstring) != -1) { #Check to see if $searchstring is a substring of the current esxtopHeadervalues variable
    if (index($_, "Virtual Disk") != -1) {  #Select only the Virtaul Disk columns for the identified VM
      push(@esxtopColumnsToPrint, $i);  # Create list of the index of matching columns
	  #print "$_ \n";
	  }
	}
  $i++;
  }
  
# Iterate through the esxtop input file line by line, and output only the identified matching columns 
my $k =0;
my $j =0;  
for (my $k=0; $k <= $#esxtoplines; $k++){   
  @curline = split ",", $esxtoplines[$k];
  for  (my $j=0; $j <= $#esxtopColumnsToPrint; $j++){
    my $printindex = $esxtopColumnsToPrint[$j];
	chomp($printindex);
	$esxtopvalue = $curline[$printindex];
	if ($j > 0) { print ",";}      #except for the first column, print a comma to seperate the values
	print "$esxtopvalue";
  } 
  print "\n";
}




















