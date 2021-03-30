# esxtop_parse_by_VMname.pl
# Script to parse output from esxtop -b output and reduce to just the columns of data realated to a given VM name
# Syntax to run - perl esxtop_parse_by_VMname.pl <title of test> 
# key parameters that are changed often are at the top of the file  
# Todd Muirhead August 2017

use strict;
use warnings;

my $outputcsv;

my $esxtopinputfilename = $ARGV[0];
my $VMname = $ARGV[1];
my $esxtopinputfile;
my @esxtoplines=();
my $esxtopHeader;
my @esxtopHeadervalues=();
my @esxtopColumnsToPrint=();
my @curline=();

#Create the file to hold the reduced version of the input esxtop file
$outputcsv = $esxtopinputfilename . '_reduced_' . $VMname . '.csv';
open (my $OUT, ">$outputcsv") || die("Can't open $outputcsv");

#Open the target esxtop file and load contents into array
open(my $IN, "<$esxtopinputfilename");
@esxtoplines = <$IN>;
close($IN);

#Get esxtop header line and split it into it column names
$esxtopHeader = $esxtoplines[0];
@esxtopHeadervalues = split ",", $esxtopHeader;
print "Total number of Columns in file: $#esxtopHeadervalues\n";


my $i = 0;
foreach (@esxtopHeadervalues){
  if (index($_, $VMname) != -1) { #Check to see if $VMname is a substring of the current esxtopHeadervalues variable
    push(@esxtopColumnsToPrint, $i);  # Create list of the index of matching columns
	}
  $i++;
  }
print "Number of matching columns found: $#esxtopColumnsToPrint\n";  
  
# Iterate through the esxtop input file line by line, and output only the identified matching columns to the new file
my $k =0;
my $j =0;  
for (my $k=0; $k <= $#esxtoplines; $k++){
  @curline = split ",", $esxtoplines[$k];
  for  (my $j=0; $j <= $#esxtopColumnsToPrint; $j++){
    my $printindex = $esxtopColumnsToPrint[$j];
	chomp($printindex);
	if ($j < 1)       
      { print $OUT "$curline[$printindex]"; 
	  }
	else  
	  { print $OUT ",$curline[$printindex]";
	  }
 }
 print $OUT "\n";
}
close $OUT;

print "All matching columns in new file $esxtopinputfilename\n";

