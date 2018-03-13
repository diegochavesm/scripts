#!/usr/bin/perl

#use strict;
$filein = $ARGV[0];

my %cat = ();
my @gen_cat = ("J","A","K","L","B","D","Y","V","T","M","N","Z","W","U","O","C","G","E","F","H","I","P","Q","R","S");
open (OUT, ">", "$filein.COGS");

foreach (@gen_cat){ 
	open (TAB, "<$filein");
	$name = $_;
	print "$name\n";
	while(<TAB>){
		chomp;
		next if m/^#/;
		m/^[^\t]+\t([A-Z,?]+)\t/ or die "I can't parse the line $.: '$_'\n";
		next if $1 eq '?';
		my $line = $_;
		my @c = split ',',$1;
		for my $x(@c){
			$cat{$x} = 0 unless defined $cat{$x};
			$cat{$x}++;
			print  OUT "$name\t$line\n" if $x eq $name;

		}
	}	
close(TAB);

}


#for my $x (sort keys %cat){
#	print "$x\t".$cat{$x}."\n";
#}
