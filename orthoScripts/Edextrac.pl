#!/usr/bin/perl
$corelist = $ARGV[0];
$genome = $ARGV[1];
chomp $genome;
#print $genome."\n";
$group = 0;
open (CORE, "<", $corelist);
	while (<CORE>){
		chomp $_;
		@clust = split("\t", $_);
		print $group."\t";
                	foreach my $ed (@clust){
                	print $ed."\t" if $ed =~ m/^$genome[0-9]+/;
                	}
		$group++;
		print "\n";
	}
