#!/usr/bin/perl
$mclout = $ARGV[0];
$genomenum = $ARGV[1];
open (MCL, "<", $mclout);

open (OUT, ">", "$genomenum.core");
open (PARAL,">", "$genomenum.paralogs");
	B1: while (<MCL>){
		@arraynames = ();
		chomp $_;
		@clust = split ('\t', $_);
		
		$groupname = shift (@clust) if $clust[0] =~ m/^Group/ ;
		

		$size = @clust;
		$paralog = 0;
		B2: foreach my $i (@clust){	
			@idparts = split ('\|', $i);
			$idgenome = shift(@idparts);

				
				if ($idgenome ~~ @arraynames){
				#print PARAL "$_\n";
				#$paralog = 1;

				next B2;
				}



			push(@arraynames, $idgenome);
		}

	#print OUT "$groupname\t" if $groupname =~ m/^Group/ and @arraynames >= $genomenum ;
	#print PARAL "$groupname\t" if $groupname =~ m/^Group/ and  @arraynames < $genomenum;

	print OUT "$_\n" if @arraynames >= $genomenum;
	print PARAL "$_\n" if @arraynames < $genomenum;

	}

