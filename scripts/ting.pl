#!/usr/bin/perl

use strict;
use warnings;

chomp(my $file_megabytes = `ls | grep "^megabytes" | tail -1`);
chomp(my $file_messages = `ls | grep "^messages" | tail -1`);
chomp(my $file_minutes = `ls | grep "^minutes" | tail -1`);

&process("Kilobytes", $file_megabytes, 2, 4);
&process("Minutes", $file_minutes, 4, 11);
&process("Messages", $file_messages, 3, -1);

sub process {
	my $label = shift;
	my $file = shift;
	my $index_name = shift;
	my $index_value = shift;
	my %results = ();

	if (open my $mfh, $file) {
		while (<$mfh>) {
			$_ =~ s/"[^"]*"//g;
			my @entry = split ",", $_;
			# Skip header row
			if ($entry[0] eq "Date") {
				next;
			}
			if ($#entry > $index_name and $#entry > $index_value) {
				if (! exists $results{$entry[$index_name]}) {
					$results{$entry[$index_name]} = 0;
				}
				if ($index_value > 0) {
					$results{$entry[$index_name]} += $entry[$index_value];
				}
				else {
					$results{$entry[$index_name]} += 1;
				}
			}
		}
		close($mfh);
	}

	print "$label:\n";
	foreach (keys %results) {
		print "    $_: $results{$_}\n";
	}
}
