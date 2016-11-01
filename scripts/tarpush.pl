#!/usr/bin/perl

use strict;
use warnings;

sub usage {
print <<EOF;
Usage:
    tarpush.pl <bom file> <device ip>

This will push files in the bom to a device using "ssh root@<device ip>" and
piping to the tar command.

FIRST RUN: will NOT copy any files over. It is just a baseline md5sum sync.

The second and subsequent runs will copy files over as changed.

Typical Workflow:

    1. Flash device to latest "dev" image
    2. Navigate to http://<device ip>/#!/sshd and enable ssh with root access
    3. Checkout latest "dev" branch in source
    4. Run tarpush.pl to send ssh key and get baseline cache
    5. Done!
        Re-run tarpush.pl to push any modified files

EOF
exit;
}

if ($#ARGV < 1 or ! -f $ARGV[0]) {
	&usage();
}

my $BOM_CSV = $ARGV[0];
my $IP = $ARGV[1];

# Hashes using target files as keys (helps avoid duplicate sources)
my %BOM = ();
my %CACHE = ();

chomp(my $BOM_DIR = `cd "\$(dirname $BOM_CSV)"; pwd`);
my $CACHE_FILE = "/tmp/cache-tarpush_$IP";

#
# Primary logic:
#

&read_bom();

chomp( my $LINK_DIR = `mktemp -d` );

if (-f $CACHE_FILE) {
	&read_cache();
	&gen_links();
	&tar_push();
}
else {
	print "Sending ssh key for first sync\n";
	&send_key();

	# First run just syncs current md5
	foreach (sort keys %BOM) {
		print "CACHING: /$_ ($BOM_DIR/$BOM{$_}{source})\n";
		$CACHE{$_} = $BOM{$_}{md5sum}
	}
}

&write_cache();

system("rm --recursive --force $LINK_DIR");

#
# Utility Functions
#

# Copy ssh key to device so we only have to enter our password once.
sub send_key {
	my $retry = shift;
	my $output = `ssh-copy-id -o StrictHostKeyChecking=no root\@$IP 2>&1`;

	if ($output =~ "Connection refused") {
		print "Connection refused. Are you sure ssh is running?\n\n";
		print "Ensure ssh is enabled, allowing root access:\n";
		print "    http://$IP:10000/#!/sshd\n\n";
		exit 1;
	}
	# Device ID changes every time you reflash, this is not a bad thing.
	elsif ($output =~ "REMOTE HOST IDENTIFICATION HAS CHANGED") {
		if ($retry) {
			print "Unable to send ssh key\n";
			exit 1;
		}
		print "Device key has changed. Assuming reflash.\n";
		print "Clearing key and trying again.\n";
		system("ssh-keygen -R $IP");
		&send_key(1);
	}
	# Matching something looking like "Permission denied (publickey,password,keyboard-interactive)."
	elsif ($output =~ "Permission denied" and $output =~ "publickey" and $output =~ "password") {
		print "Permission denied. Are you sure you have the right password?\n";
		exit 1;
	}
	else {
		print $output;
	}
}

# Bom is a csv with the first two fields being <target>,<source>
sub read_bom {
	open (my $bfh, $BOM_CSV) or die "Failed to open BOM";
	while (<$bfh>) {
		chomp($_);
		if ($_ =~ /^([^,]+),([^,]+)(,.*)?$/) {
			if (exists $BOM{$1}) {
				print "Duplicate target found in bom: $1\n";
				next;
			}
			# We can only handle bom materials if files actually exist
			if (-f "$BOM_DIR/$2") {
				$BOM{$1} = {
					source => $2,
					md5sum => &getmd5("$BOM_DIR/$2")
				};
			}
		}
	}
	close($bfh);
}

# Read cache file of md5sum-style lines: <hash>  <target>
sub read_cache {
	open (my $cfh, $CACHE_FILE) or die "Failed to open cache";
	while (<$cfh>) {
		if ($_ =~ /^([^ ]+)  (.+)$/) {
			if (exists $CACHE{$2}) {
				print "Duplicate target found in cache: $2\n";
				next;
			}
			$CACHE{$2} = $1;
		}
	}
	close($cfh);
}

# Write cache file of md5sum-style lines: <hash>  <target>
sub write_cache {
	open (my $cfh, '>', $CACHE_FILE) or die "Failed to open cache";
	foreach (sort keys %CACHE) {
		print $cfh "$CACHE{$_}  $_\n";
	}
	close($cfh);
}

# Create a shadow directory of any files in the BOM that have been modified
sub gen_links {
	my $cached;

	foreach (sort keys %BOM) {
		if (exists $CACHE{$_}) {
			$cached = $CACHE{$_};
		}
		else {
			$cached = "";
		}

		if ($cached ne $BOM{$_}{md5sum}) {
			system("mkdir --parents \$(dirname $LINK_DIR/$_)");
			system("ln --symbolic $BOM_DIR/$BOM{$_}{source} $LINK_DIR/$_");
			print "/$_ ($BOM_DIR/$BOM{$_}{source})\n";
		}

		$CACHE{$_} = $BOM{$_}{md5sum};
	}
}

sub tar_push {
	if (`ls $LINK_DIR`) {
		system("cd $LINK_DIR && tar -hc * | ssh root\@$IP 'cd / 0>&1 &>/dev/null; tar -x'");
	}
}

sub getmd5 {
	if (`md5sum $_[0] 2>/dev/null` =~ /^([^ ]+)  /) {
		return $1;
	}
	return "";
}
