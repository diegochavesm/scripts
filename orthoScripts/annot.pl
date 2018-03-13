#!/usr/bin/perl
$genomes = $ARGV[0]; #.. 25N.protCode.list
$mclout = $ARGV[1];  #.. mclOutput
$synonim = $ARGV[2]; #.. 25N_Synonyms.table
open(CODE,"<$genomes");
%code = {};
        while (<CODE>){
        chomp $_;
        @codearray = split ('\t', $_);
        $code{$codearray[0]} = $codearray[1];
        }
open(SYNO, "<$synonim");

%synonim={};
	while(<SYNO>){
	next if $_ !~ m/^[0-9]/;
	chomp $_;
	@synoline = split ('\t', $_);
	$synonim{$synoline[0]} = "$synoline[1]\t$synoline[2]";	
	}
open (MCL,"<$mclout");
$count = 0;
	while(<MCL>){
	print "Group$count\t";
	chomp $_;
	@mclline = split ('\t', $_);
		foreach $gene(@mclline){
		@group = split ('\|', $code{$gene});
		$gi = $group[1];
		@name = split ('\t', $synonim{$gi});
		
		print $name[1]."\t"; #the hash called %synonim{number} have the names and the synonyms name=0 synonyms = 1
		
		@identificators = split ('\|', $code{$gene}); #this array contain the Gi and the RefSeq identificators $identificators[1]=Gi, $identificators[3]=RefSeq ID
		#print $identificators[1]."\t";

		}
	$count++;
	print "\n";
	}

