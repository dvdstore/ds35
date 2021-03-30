# get_esxtop_avg_column.pl
# Script to parse an esxtop file and provide the average for the specified column
# Syntax to run - perl ds3_esxtop_avg_column.pl <esxtop_file_to_be_parsed> <column number, based on 0 start> 
# key parameters that are changed often are at the top of the file  

use strict;
use warnings;

my $esxtopinputfilename = $ARGV[0];
my $esxtopinputfile;
my @esxtoplines=();
my $esxtopHeader;
my @esxtopHeadervalues=();
my $esxtopColumnToPrint= $ARGV[1];
my @curline=();

my $cpuutilsum = 0;
my $cpuvalue = 0;

my $title = $ARGV[0];


#Open the target esxtop file and load contents into array
open(my $IN, "<$esxtopinputfilename");
@esxtoplines = <$IN>;
close($IN);

#Get esxtop header line and split it into it column  names
$esxtopHeader = $esxtoplines[0];
@esxtopHeadervalues = split ",", $esxtopHeader;
#print "Total number of Columns in file: $#esxtopHeadervalues\n";

 
# Iterate through the esxtop input file line by line, and output only the average of the identified column 
my $k =0;
my $j =0;  
for (my $k=10; $k <= $#esxtoplines; $k++){   #start k at 10 to skip the first 10 lines
  @curline = split ",", $esxtoplines[$k];
  #for  (my $j=0; $j <= $esxtopColumnToPrint; $j++){
    my $printindex = $esxtopColumnToPrint;
	chomp($printindex);
	$cpuvalue = $curline[$printindex];
	$cpuvalue =~ tr/"//d;        #strip off "s from the string
	$cpuutilsum = $cpuutilsum + $cpuvalue;
 
}

#print "The average is " . ($cpuutilsum / ($#esxtoplines - 9)) . "\n";  #subtract 9 to adjust for skipping the first 10 lines
 
print ($cpuutilsum / ($#esxtoplines - 9));


















