#!/usr/bin/perl
###############################################################
#Parser para resultados de blast, basado en bioperl 5.0.0  ####
###############################################################
use strict;
use Bio::SearchIO;
my $blast = $ARGV[0];
my $evalue_user = $ARGV[1];
my $ratio_user= $ARGV[2];
my $report = Bio::SearchIO->new(-file=>$blast, -format=>"blast");

my @idarray;

#open OUT, ">", "filter_in.out";
#open OUT1, ">", "filter_out.out";
print "#name\tQAcc\tS_Start\tS_end\tSub_len\tQ_length\tAlnLen\tScore\tPercent_id\tEval\tRatio\tCoverage\tDesc\n"; 
#print "qid\thAcc\tName\tQStart\tQend\tS_start\tS_end\tQuerry_length\tAln_Length\tE-value\tScore\tbits\tID_percent\tRatio\tCoverage\tSbjct_strand\tType\tDescrip\n";
  	while(my $result = $report->next_result()){
		my $qAcc = $result->query_accession();
		my $querylength = $result->query_length();
		my $id = $result->query_name();
		my $descrip = $result->query_description();     
			while (my $hit = $result->next_hit()){
				my $hAcc = $hit->accession();
				my $desc = $hit->description();
				my $hsp = $hit->hsp ('best');
				my $hsp = $hit->hsp();
				my $name = $hit->name();
				my $len1 = $hit->length;
				next unless $hit->hsps;
					my $pvalue = $hsp->pvalue();
					my $r_type = $hsp->algorithm;				
					my $evalue = $hsp->evalue();
					my $score = $hsp->score();

					my $qseq = $hsp->hit_string();

					my $alnL = $hsp->length('total');
					my $qryL = $hsp->length('query');
					my $sbjL = $hsp->length('hit');
					my $frac_id = $hsp->frac_identical('total');

					my $Qstart = $hsp->start('query');
					my $Qend = $hsp->end('querry');	 
					my $Sstart = $hsp->start('sbjct');
					my $Send = $hsp->end('sbjct');
					my $sstrand = $hsp->strand('sbjct');

					my $numidentical = $hsp->num_conserved();
					my $bits = $hsp->bits();
					my $percentid = $hsp->percent_identity();
     					
					#proteins blastX
					#my $ratio = ((($alnL*3)*$percentid)/$querylength);
					#my $coverage = ((($sbjL*3)*100)/$querylength);
					
					# just for nucleotides
					my $ratio = (($qryL*$percentid)/$querylength);
					my $coverage = (($qryL*100)/$querylength);	
		
		

				if ($evalue_user != 0 & $ratio_user == 0){
				  	if ($evalue <= $evalue_user){
					print OUT "$qAcc\t$hAcc\t$desc\t$evalue\t$score\t$qryL\t$sbjL\t$alnL\t$percentid\t$ratio\n"; 
								}else{
					   print OUT1 "1out$qAcc\t$hAcc\t$descrip\t$evalue\t$score\t$qryL\t$sbjL\t$alnL\t$percentid\t$ratio\n"; 
					#last;
						}
					}

				if ($evalue_user == 0 & $ratio_user != 0){
					if ($ratio >= $ratio_user){
                                           print OUT "2in$qAcc\t$hAcc\t$descrip\t$evalue\t$score\t$qryL\t$sbjL\t$alnL\t$percentid\t$ratio\n"; 
                                                                }else{
                                           print OUT1 "2out$qAcc\t$hAcc\t$descrip\t$evalue\t$score\t$qryL\t$sbjL\t$alnL\t$percentid\t$ratio\n"; 
                                        last;
					}
				}

				if ($evalue_user != 0 & $ratio_user != 0){
					if ($evalue <= $evalue_user & $ratio >= $ratio_user){
                                           print OUT "3in$qAcc\t$hAcc\t$descrip\t$evalue\t$score\t$qryL\t$sbjL\t$alnL\t$percentid\t$ratio\n"; 
                                                                }else{
                                           print OUT1 "3out$qAcc\t$hAcc\t$descrip\t$evalue\t$score\t$qryL\t$sbjL\t$alnL\t$percentid\t$ratio\n"; 
                                                                        }
                                        #last;
									}
				else {
					#print "$qAcc\t$hAcc\t$name\t$Qstart\t$Qend\t$Sstart\t$Send\t$len1\t$querylength\t$alnL\t$evalue\t$score\t$bits\t$percentid\t>>$ratio\t$coverage\t$sstrand\t$r_type\t$desc\n" if $evalue <= 0.01;
					print "$name\t$qAcc\t$len1\t$querylength\t$alnL\t$score\t$percentid\t$evalue\t$ratio\t$coverage\t$desc\n" if $evalue <= 0.01;	
					

					#last if ($hAcc 4~~ @idarray);
					#push(@idarray, $hAcc);	
					#print "@idarray\t";
					#print ">$hAcc\n$qseq\n";
				#next;
				#last if $hit->rank == 3;
				last;	
					}

		}
		
 }                    	
	


close OUT;
close OUT1;
exit
