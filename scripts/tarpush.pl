#!/usr/bin/perl

sub usage {
print <<EOF;
Usage:
    tarpush.pl <bom file> <device ip>

EOF
exit;
}

if (! -f $ARGV[0]) {
	&usage();
}

my $BOM_CSV = $ARGV[0];
chomp(my $BOM_DIR = `cd "\$(basename "\$(dirname $BOM_CSV)")"; pwd`);
my %BOM = ();

my $IP = $ARGV[1];
my $CACHE_FILE = "/tmp/cache-tarpush_$IP";

my %CACHE = ();

chomp( my $LINK_DIR = `mktemp -d` );

&read_bom();

if (-f $CACHE_FILE) {
	&read_cache();
	&gen_links();
	&tar_push();
}
else {
	# First run, just dump to cache and write
	foreach (sort keys %BOM) {
		print "caching /$_ ($BOM_DIR/$BOM{$_}{source})\n";
		$CACHE{$_} = $BOM{$_}{md5sum}
	}
}

&write_cache();

system("rm --recursive --force $LINK_DIR");


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

sub write_cache {
	open (my $cfh, '>', $CACHE_FILE) or die "Failed to open cache";
	foreach (sort keys %CACHE) {
		print $cfh "$CACHE{$_}  $_\n";
	}
	close($cfh);
}

sub gen_links {
	my $cached;

	foreach (sort keys %BOM) {
		if (exists $CACHE{$_}) {
			$cached =  $CACHE{$_};
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
