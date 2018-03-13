#!/usr/bin/perl
$genes = $ARGV[0];
open (GENES, "<", $genes);
#open (MSTOC, ">core.multistockholm");


$groupnum=0;
        while(<GENES>){
                chomp $_;
                @clust = split ('\t', $_);
                $size = @clust;

                print "$groupnum.pssm\t Exist :)..." if (-e "./$groupnum.pssm");
	        print "group: $groupnum\n";
                $groupnum++;

        }

