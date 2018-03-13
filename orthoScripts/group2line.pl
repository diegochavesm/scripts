#!/usr/bin/perl
$mcloutput = $ARGV[0];
open (MCL,"<$mcloutput");
$num = 0;
	while (<MCL>){
	print "Group".$num."\t";
	print $_;
	$num++
	}
