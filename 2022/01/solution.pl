#! /usr/bin/perl

use v5.32;
use warnings;

use List::Util qw(sum);

my $cur_sum = 0;
my $top_sum = 0;
my @sums;

open(my $in, "<", "input.txt") or die "Can't open input.txt: $!";

while (<$in>) {
	if (/^$/) {
		if ($cur_sum > $top_sum) {
			say "Previous top: $top_sum. New top: $cur_sum." if $top_sum != 0;
			$top_sum = $cur_sum;
		}
		push @sums, $cur_sum;
		$cur_sum = 0;
	} else {
		$cur_sum += $_;
	}
}

@sums = sort @sums;

my $three_sum = sum @sums[($#sums-2)..$#sums];

say "The top elf is carrying $sums[-1] calories.";
say "The top three elves are carrying $three_sum calories in total.";
