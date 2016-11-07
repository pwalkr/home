#!/usr/bin/perl

use strict;
use warnings;

chomp(my $PREFIX=`date --date "last month" +%Y-%m`);

sub process_megabytes {
	my $file = shift;
	my %results = ();

	if (open my $mfh, $file) {
		while (<$mfh>) {
			my @entry = split ",", $_;
			# Skip header row
			if ($entry[0] eq "Date") {
				next;
			}
			if ($#entry gt 5) {
				if (! exists $results{$entry[3]}) {
					$results{$entry[3]} = 0;
				}
				$results{$entry[3]} += $entry[5];
			}
		}
		close($mfh);
	}

	print "Data Usage (kilobytes)\n";
	foreach (keys %results) {
		print "    $_: $results{$_}\n";
	}
}

sub process_messages {
	my $file = shift;
	my %results = ();

	if (open my $mfh, $file) {
		while (<$mfh>) {
			my @entry = split ",", $_;
			# Skip header row
			if ($entry[0] eq "Date") {
				next;
			}
				printf "$#entry $_";
			if ($#entry gt 4) {
				if (! exists $results{$entry[4]}) {
					$results{$entry[4]} = 0;
				}
				$results{$entry[4]} += 1;
			}
		}
		close($mfh);
	}

	print "SMS Messages\n";
	foreach (keys %results) {
		print "    $_: $results{$_}\n";
	}
}

&process_megabytes("megabytes3942947.csv");
&process_messages("messages3942947.csv");
