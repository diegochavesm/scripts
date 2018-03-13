#!/usr/bin/perl
$corefilelow = $ARGV[0];
$corefilebig = $ARGV[1];
$numgenome_low = $ARGV[2];


open (TMP, ">", "core2add.log");
open(CORELOW, "<$corefilelow");
%groups;
$grou_num = 0;
	while(<CORELOW>){
	chomp $_;
	@line = split ("\t", $_);
	$groups{$grou_num}="@line";
	$grou_num++;
	}
#print ">]\n";
#foreach (sort {$a<=>$b} keys %groups) {
 #   print "$_ : $groups{$_}\n";
  #}


open(COREUP, "<$corefilebig");

     B2:while(<COREUP>){
	chomp $_;
	@upline = split ("\t", $_);
	$count_line =0;
	foreach $up_id (@upline){


		foreach $key (sort {$a<=>$b}  keys %groups) {
		@low_line = split (" ", $groups{$key});

		if ($up_id ~~ @low_line){
		$count_line++;
		#print "$up_id\t$key\n";

		}	
		    #print "$_ : $groups{$_}\n";
 	#exit;	
		 }
	
	#exit;

	}

	#print "genes: $count_line\n";
	if($count_line >= $numgenome_low){
	print "$_\n";

	}


	print TMP "$count_line\t$_\n";

	}

close TMP;
close CORELOW;
close COREUP;

