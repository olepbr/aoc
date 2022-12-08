#! /usr/bin/perl

use v5.32;
use warnings;
use utf8;

use File::Slurper qw(read_lines);
use Set::Object qw(set);

# array of lines -> split on , and - and make arrayref -> construct tuples of sets and put them into an array
my @tuples = map { [ set($_->[0]..$_->[1]), set($_->[2]..$_->[3]) ] } map { [ split(/-|,/, $_) ] } read_lines("input.txt");

# grep for tuples where either is subset of the other and count
my $fully_contained = scalar grep { $_->[0] <= $_->[1] || $_->[1] <= $_->[0] } @tuples;

# grep for tuples where intersection is > 0 and count
my $overlapping = scalar grep { ($_->[0] * $_->[1])->size } @tuples;

say "Among the pairs, $fully_contained ranges fully contain the other.";

say "Among the pairs, $overlapping ranges overlap."
