#! /usr/bin/perl

use v5.32;
use warnings;
use utf8;

use File::Slurper qw(read_lines);
use Set::Object qw(set);

my @tuples = map { [ (set($_->[0]..$_->[1]), set($_->[2]..$_->[3])) ] } map { [ split(/-|,/, $_) ] } read_lines("input.txt");

my $fully_contained = scalar grep { $_->[0] <= $_->[1] || $_->[1] <= $_->[0] } @tuples;

my $overlapping = scalar grep { scalar ($_->[0] * $_->[1])->members } @tuples;

say "Among the pairs, $fully_contained ranges fully contain the other.";

say "Among the pairs, $overlapping ranges overlap."
