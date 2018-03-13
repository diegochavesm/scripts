#!/usr/bin/perl/
$mclout = $ARGV[0];
open (MCL, "<$mclout");
	while(<MCL>){
	chomp $_;
	@groups = split ('\t', $_ );
	foreach $i (@groups){
	@name = split ('\|', $i);
	print $name[0]."\t";
	}	
	print "\n";
	}
