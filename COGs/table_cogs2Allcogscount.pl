#!/usr/bin/perl
#======================================================================================================#
####this script count the numbers of COGs cathegories coming from a cat file of genomes like this:####=#
#  #genome1											      =#
#  gi_302347804_ref_YP_003815442.1 S       COG5551 Uncharacterized conserved protein		      =#
#  gi_302347806_ref_YP_003815444.1 L       COG1468 RecB family exonuclease			      =#
#  #genome2											      =#
#  idprotein	cogGenCategorie	COGnumber	Cogdescription  				      =#
#  use a table of all of cogs categories							      =#
########################################################################################################

## cogs index, for all cogs the number will be zero COGNNN===> 0
$allcogsfile = $ARGV[0];
open (COGS, "<$allcogsfile");
my %cogs;
$count = 0;
	while(<COGS>){
	chomp $_;
	$cogs{$_}= "$count";
	}  
#subrutine counting cogs per genome=============================
sub cogscount{
%$genomename;
#print "$genomename\n";
@cogs;
	while(<GENO>){
	chomp $_;
	@line = split('\t', $_);
	last if m/^#/;
	#print $line[2]."\t";

		if ($line[2] ~~ @cogs){
                $newcount = $$genomename{$line[2]};
                $newcount++;
                $$genomename{$line[2]} = "$newcount";
                }else{
                my $count = 1;
                push (@cogs, $line[2]);
                $$genomename{$line[2]} = "$count";
                }

	}
}
#===============================================================

$allgenomesfile = $ARGV[1];
my @genomearray;
my %cogs2dim;

open (GENO, "<$allgenomesfile");
	SUB: while(<GENO>){
	chomp $_;
	$genomename = substr($_, 1) if m/^#/;
	#print $_."/n";	
		if ($_ =~ m/^#/){
		push (@genomearray, $genomename);
		&cogscount($genomename);
		#print "entre\n";
		}
	}

print "COG_num\t";
print join ("\t",@genomearray);
print "\n";

	foreach $cogtotal (sort keys %cogs){
	print "$cogtotal\t";
		foreach $name (@genomearray){
		$value = $$name{$cogtotal};
		print "$value\t" if $value != 0;
		print "0\t" if $value == 0;

		}
	print "\n";


	}

