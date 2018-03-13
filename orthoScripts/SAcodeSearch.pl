#!/usr/bin/perl
$mclannot = $ARGV[0]; #the orthomcl anot witht he terms to retreive
$code = $ARGV[1]; #code to retrieve for example SAS or COL
open (MCL, "<$mclannot");
	while (<MCL>){
	chomp $_;
	@annotaline = split ('\t', $_);
	print $annotaline[0]."\t";
		foreach $a (@annotaline){
		#print $a."\n";
		print $a."\t" if $a =~ m/^SAUSA300_[0-9]+$/;

		}	
	print "\n";
	
	}
