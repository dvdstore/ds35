# perlsleep.pl
# Script to pause for a given amount of time. 
# Syntax to run - perlsleep.pl <number_of_seconds_to_sleep> 

use strict;
use warnings;

my $outputcsv;

my $number_of_seconds_to_sleep = $ARGV[0];


sleep($number_of_seconds_to_sleep);