#!/usr/bin/perl
$genes = $ARGV[0];
$database = $ARGV[1];
open (GENES, "<", $genes);
#open (MSTOC, ">core.multistockholm");
open (LIST, ">corelist.list");


$groupnum=0;
	while(<GENES>){
                chomp $_;
                @clust = split ('\t', $_);
                $size = @clust;

		#print "$groupnum.pssm\t Exist :)..." if (-e "./$groupnum.pssm");

		#next if (-e "./$groupnum.pssm");


		open (SEQ, ">", "sequences.fasta");
			foreach $k (@clust){
			print SEQ "\>$k\n";
			print SEQ `blastdbcmd -db "$database" -dbtype prot -entry "$k" -outfmt \%s`; 
			}
		`/home/diego/software/muscle3.8.31_i86linux64 -in sequences.fasta -out sequences.aln -clwstrict`;
		`psiblast -subject dummy.fasta -in_msa sequences.aln -out_pssm $groupnum.pssm`;
		print LIST "$groupnum.pssm\n";	
		`cons -sequence sequences.aln -name $groupnum -outseq cons.fasta`;
		`mv sequences.aln ./alignments/$groupnum.aln`;
		`mv cons.fasta ./cons/$groupnum.cons`;
		#@seqs = ("sequences.aln");
                #&fastatostock(@seqs,$groupnum); 
		print "group: $groupnum\n";
		$groupnum++;

	}












