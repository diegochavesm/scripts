#!/usr/bin/perl
$catefile = $ARGV[0];


my @gen_cat = ("J","A","K","L","B","D","Y","V","T","M","N","Z","W","U","O","C","G","E","F","H","I","P","Q","R","S");

foreach (@gen_cat){
$name = $_;

my %categories;
my %cogcounts;
my @cogs;
open (CAT, "< $catefile");
	while (<CAT>){
	chomp $_;
	@line = split '\t', $_;
	$gen_cat = shift(@line);
	#print $gen_cat."\n";
	next if $gen_cat !~ $name;
	

		if ($line[2] ~~ @cogs){
		$newcount = $cogcounts{$line[2]};
		$newcount++;
		$cogcounts{$line[2]} = "$newcount";
		}else{
		my $count = 1;
		push (@cogs, $line[2]);
		$cogcounts{$line[2]} = "$count";
		$categories{$line[2]} = "$name\t$line[3]";
		}
	}

	for my $key(sort keys %cogcounts){
	my $value = $cogcounts{$key};
	my $name  = $categories{$key};
	print "$key\t$value\t$name\n";
	}


}
