#!/usr/bin/perl -w

use strict;
use Bio::SearchIO;

my $whogfile = shift @ARGV;
my @blasts = @ARGV;
my %categories = ();
open WHOG, "<", $whogfile or die "I can't open the whog file '$whogfile'\n";
my $tmp = $/;
$/="\n_______\n";
while(my $g=<WHOG>){
   chomp $g;
   next if $g =~ m/^[\n\s]*$/;
   $g =~ s/^\n*\[([A-Z]+)\] (COG\d+) ([^\n]*)// or die "I can't parse the category $.: $g\n";
   my @lets = split //, $1;
   my @ORGS = split /\n  [A-Za-z]+:  /, $g;
   for my $org (@ORGS){
      next if $org =~ m/^[\n\s]*$/;
      $org =~s/[\s\n\r]+/\t/g;
      for my $entry(split "\t", $org){
         $categories{$entry} = "" unless defined $categories{$entry};
	 $categories{$entry}.= join("\n", @lets)."\n";
      }
   }
}
$/=$tmp;

for my $blastfile(@blasts){
   print "Parsing $blastfile\n";
   die "$blastfile doesn't exist\n" unless -s $blastfile;
   my $blast_report = Bio::SearchIO->new(-file=>$blastfile, -format=>"blast");
   QRY:while(my $result=$blast_report->next_result()){
      SBJCT:while(my $best_hit=$result->next_hit()){
         if(int($best_hit->num_hsps())>0 && 
		$best_hit->length('query')>=66 &&
		 $best_hit->hsp('best')->frac_identical()>=0.4){
	    if(defined $categories{$best_hit->accession()}){
	       print $categories{$best_hit->accession()};
	       next QRY;
	    }else{
	       print "Parsing error: entry ", $best_hit->accession(), " not found.\n";
	    }
	 }
      }
      print "?\n";
   }
   print "Parsing finished.\n";
}

#print $_,":",join(",",@{$categories{$_}}),"\n" for(keys %categories);


