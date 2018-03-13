#!/usr/bin/perl
#$headers = $ARGV[0];
#### this script is to run wilkcoxon text on a high amount of data, as an arguments use a table in wich the columns are samples. all the comparisons are 2x2. as a second argument takes if the test is paired = P or unpaired = U ###
####################
$table = $ARGV[0];
$paired = $ARGV[1];
$pair = "T" if $paired =~ m/P/;
$pair = "F" if $paired =~ m/U/; 
print "running for paired = $pair\n";
#open (HEAD, "<$headers"); # or the names of the columsn
open (OUT, ">wilk_OUT.txt");
open (HEADER, ">headers.txt");
print HEADER `head -n 1 $table`;
close(HEADER);
open(HEAD, "<headers.txt");
open (PVAL, ">pvalues");
print PVAL " Comp\tPvalue\tPadjBH\n";
$counter = 0;
	while (<HEAD>){
	chomp $_;
	@headline = split ('\t', $_);
		for ($i=0; $i<@headline; $i++){
		open (R, ">Rcommands");
		print R "prismtable<-read.table(\"\.\/$table\", header=TRUE)\nwilcox.test(prismtable\$$headline[$i], prismtable\$$headline[$i+1], paired=$pair)\n";
		close(R);
		$res1 = `R --vanilla <Rcommands | grep "p-value"`;
		chomp $res1;
		print OUT "$headline[$i]\t$headline[$i+1]\t$res1\n";
		@pvalues = split ('=', $res1);
		print PVAL "$headline[$i]-$headline[$i+1]\t$pvalues[2]\tNA\n";
		$i++;
		`rm Rcommands`;
		}
	}
close (PVAL);
open (R2, ">Rcommands");
print R2 "pvalue_table<-read.table(\"\.\/pvalues\", header=TRUE)\npvalue_table\$PadjBH <-p.adjust(pvalue_table\$Pvalue, \"BH\")\nwrite.table(pvalue_table, sep=\"\\t\", file=\"PvalAdj.tsv\")";
`R --vanilla <Rcommands`;
`rm Rcommands headers.txt pvalues`;



close(OUT);
