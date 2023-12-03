#! /usr/bin/perl

use v5.36;
use File::Slurper qw( read_lines );
use List::Util    qw( max );

my @test_lines = (
    "Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
    "Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
    "Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
    "Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
    "Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
);

# grep for number of reds, greens and blues. take max of each list, which will
# be the minimum number needed.

my $power_sum = 0;
for my $line ( read_lines("input.txt") ) {
    my $min_reds   = max $line =~ /(\d+) red/g;
    my $min_blues  = max $line =~ /(\d+) blue/g;
    my $min_greens = max $line =~ /(\d+) green/g;
    $power_sum += $min_reds * $min_greens * $min_blues;
}
say $power_sum;
