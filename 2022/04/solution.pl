#! /usr/bin/perl

use v5.32;
use warnings;
use utf8;

use File::Slurper qw(read_lines);
use Set::Object qw(set);

sub count_ranges {
    my (@ranges) = @_;
    my $fully_contained = 0;
    my $overlapping = 0;
    foreach (@ranges) {
        my ($first, $second) = split /,/, $_;
        my ($fstart, $fend) = split /-/, $first;
        my ($sstart, $send) = split /-/, $second;
        my $first_set = set($fstart..$fend);
        my $second_set = set($sstart..$send);
        $fully_contained += 1 if ($first_set <= $second_set || $second_set <= $first_set);
        $overlapping += 1 if (scalar ($first_set * $second_set)->members);
    }
    return ($fully_contained, $overlapping);
}

my @pairs = read_lines("input.txt");

my ($fully_contained, $overlapping) = count_ranges(@pairs);

say "Among the pairs, $fully_contained ranges fully contain the other.";

say "Among the pairs, $overlapping ranges overlap."
