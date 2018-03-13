#!/usr/bin/perl
$mclout = $ARGV[0];
open (MCL, "<", $mclout);
	B1: while (<MCL>){
		@arraynames = ();
		#@listgenomes = ();
		chomp $_;
		@clust = split ('\t', $_);
		$size = @clust;
		foreach my $i (@clust){	
			@idparts = split ('\|', $i);
			$idgenome = shift(@idparts);
			
			push(@listgenomes, $idgenome) unless @$idgenome;		
			@$idgenome = () unless @$idgenome;
		
			push(@$idgenome, $i);
			
			#print "@$idgenome\n";	
				}
		

		}

foreach $geno (@listgenomes){
	open (GENOME, ">", "$geno.genes");
	print $geno."\n";
	foreach $genes (@$geno){
	print GENOME $genes."\n"
	}
}


	

