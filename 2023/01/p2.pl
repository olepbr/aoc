#! /usr/bin/perl

use v5.36;
use File::Slurper qw(read_lines);

my %dig_hash = (
	"one" => 1,
	"two" => 2,
	"three" => 3,
	"four" => 4,
	"five" => 5,
	"six" => 6,
	"seven" => 7,
	"eight" => 8,
	"nine" => 9,
);

my @digits = map { [ $_ =~ /(?=(\d|one|two|three|four|five|six|seven|eight|nine))/g ] } read_lines("input.txt");

my $sum = 0;
for my $dig_ref (@digits) {
	my $l = $dig_ref->[0];
	my $r = $dig_ref->[-1];
	if (exists $dig_hash{$l}) {
		$l = $dig_hash{$l};
	}
	if (exists $dig_hash{$r}) {
		$r = $dig_hash{$r};
	}
	$sum += "$l$r";
}

say "The correct sum is $sum.";
