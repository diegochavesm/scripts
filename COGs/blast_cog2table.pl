#!/usr/bin/perl -w

use strict;
use Bio::SearchIO;

my $whogfile = shift @ARGV;
my $covPerc = 50;
my $idtPerc = 50;

my @blasts = @ARGV;
my %categories = ();

## WHO FILE PROCESSING
open WHOG, "<", $whogfile or die "I can't open the whog file '$whogfile'\n";
my $tmp = $/;
$/="\n_______\n";
while(my $g=<WHOG>){
   chomp $g;
   next if $g =~ m/^[\n\s]*$/;
   $g =~ s/^\n*\[([A-Z]+)\] (COG\d+) ([^\n]*)// or die "I can't parse the category $.: $g\n";
   my @lets = split //, $1;
   my $cats = join ",", @lets;
   my $cog  = $2;
   my $cogDesc = $3;
   my @ORGS = split /\n  [A-Za-z]+:  /, $g;
   for my $org (@ORGS){
      next if $org =~ m/^[\n\s]*$/;
      $org =~s/[\s\n\r]+/\t/g;
      for my $entry(split "\t", $org){
         $categories{$entry} = "" unless defined $categories{$entry};
	 $categories{$entry}.= "\t$cats\t$cog\t$cogDesc\n";# for (@lets);#join("\n", @lets)."\n";
      }
   }
}
$/=$tmp;

#print "$_ $categories{$_}" for (keys %categories);

## BLAST OUTPUT ANALYSIS
for my $blastfile(@blasts){
   print "# Parsing $blastfile\n";
   die "$blastfile doesn't exist\n" unless -s $blastfile;
   my $blast_report = Bio::SearchIO->new(-file=>$blastfile, -format=>"blast");
   QRY:while(my $result=$blast_report->next_result()){
      SBJCT:while(my $best_hit=$result->next_hit()){
         if($best_hit->num_hsps() ne "-" &&
	 	$best_hit->num_hsps()>0 || 
		$best_hit->length('query')>=($covPerc*$result->query_length/300) ||
		$best_hit->hsp('best')->frac_identical()>=$idtPerc/100){
		
		#my @idsplit = split('\|', $best_hit->accession());
		#print "--->$idsplit[1]<----\n";
		


	    if(defined $categories{$best_hit->accession()}){
	#if(defined $categories{$idsplit[1]}){
	       print $result->query_name().$_."\n" for ( split "\n", $categories{$best_hit->accession()} );
		#print $result->query_name().$_."\n" for ( split "\n", $categories{$idsplit[1]} );
	       next QRY;
	    }else{
	       print "# Parsing error: entry ", $best_hit->accession(), " not found.\n";
	    }
	 }
      }
      print $result->query_name()."\t?\t?\t?\n";
   }
   print "# Parsing finished.\n";
}

#print $_,":",join(",",@{$categories{$_}}),"\n" for(keys %categories);


