#######V3. 19.03.2018... changes were done in order to include a variable named $until, which contains the number of the groups, in previous versions the user should set the number directly inside the script, now does it taking in account the argument $num_groups

#!/usr/bin/perl
$table_total = $ARGV[0]; #(every 4rd column is a normal comparison)
$num_groups = $ARGV[1];    ### here is the total number of columns of the file, must be first check if is divided by 4 or 5 or the numbers of groups.

`rm kwalis_dunn.OUT.txt`;

chomp $num_groups;

open (TAB, "<$table_total");
	while(<TAB>){
	chomp $_;
	@names = split ('\t', $_);
	last;
	}

$num_col = @names;
print "Number of total columns is:$num_col\n";

open (R, ">Rcommands");
open (ROUND_TAB, ">table2R.tmp");
#open (OUT, ">kwalis_dunn_OUT.tmp");
open (OUT2, ">kwalis_dunn.OUT.txt");
print OUT2 "comparison\tz-statistic\tP-value_adj\n";

	######IMPORTANT
	for ($i = 1; $i<=$num_col;$i+=$num_groups){  #### here is possible to change the number $++ for the number of comparison you wanna do, so $++4 means in groups of 4 $++5 groups of 5 and so on
	############### set the $i+= number #######
	open (R, ">Rcommands");
	open (ROUND_TAB, ">table2R.tmp");
	
	$until = $i+$num_groups-1; 

		#for ($in = $i; $in<= $i+4; $in ++){  #here the for iterates over the colums to used as imput of the R, named table2R.tmp
		for ($in = $i; $in<=$until; $in ++){
		print ROUND_TAB `awk '{if (\$$in !~ /NA/)print \$$in\"\\t\"\"$names[$in-1]\"}' $table_total | sed '1d' `;
		}

	print R "library(dunn.test)\ntable_round<-read.table(\"\.\/table2R.tmp\")\nnumber<-unlist(table_round\$V1)\ncat<-unlist(table_round\$V2)\ntable=dunn.test(number,cat, method=\"bh\", list=TRUE, label=TRUE, table=FALSE)\ntable = cbind.data.frame(table\$comparisons,table\$Z,table\$P.adjusted)\nwrite.table(table, file=\"results.R.tsv\", sep=\"\\t\", col.names=F, row.names=F)\n";
	close(ROUND_TAB);
	close(R);
	open (OUT, ">kwalis_dunn_OUT.tmp");
	#print `R --vanilla <Rcommands` . "<<<<<<<<<";
	#`R --vanilla <Rcommands | grep "^[a-zA-Z_\s]\+"`;   #### with this part just take out of the R command the table, must be carefuly check with a different REGex depending of the names of every column
	#`cat results.R.tsv >> kwalis_dunn_OUT.txt`;
	#$res1 = `R --vanilla <Rcommands | grep "^[A-Z][0-9]"`; 
	$res2 = `R --vanilla <Rcommands | grep "chi-squared"`;   #### retreive the pvalue, based int the test. 
	print OUT "$res2";
	close(OUT);
	`R --vanilla <Rcommands`;
	`cat kwalis_dunn_OUT.tmp >> kwalis_dunn.OUT.txt`;
	`cat results.R.tsv | sed 's/\"//g' >> kwalis_dunn.OUT.txt`;
	#print OUT "$res1";
	`rm Rcommands`;
	`rm results.R.tsv`;


	}

`rm *.tmp`;
