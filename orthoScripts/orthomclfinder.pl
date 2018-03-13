#!/usr/bin/perl
$id_file = $ARGV[0];
$mcl_out = $ARGV[1];
open (ID, "<$id_file");
	while(<ID>){
	chomp $_;
	$id = $_;
	open (MCL, "<$mcl_out");
		while(<MCL>){
		chomp $_;
		@arrayline = split('\t', $_);
		$group = shift(@arrayline);
		
			foreach my $parts (@arrayline){
			@genes = split('\|', $parts);
			print  $group."\t".$id."\t".$genes[3]."\n" if $id eq $genes[3];


			}	
	
		}
	



	}


	
