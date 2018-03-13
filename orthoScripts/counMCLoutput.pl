#!/usr/bin/perl
$mcloutput = $ARGV[0];
open(MCL, "<$mcloutput");
my $count;
	while (<MCL>){
	chomp $_;
	@line = split ('\t', $_);
	$num = scalar (@line);
	$count+=$num;
	}
print $count."\n";
