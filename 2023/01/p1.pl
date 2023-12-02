#! /usr/bin/perl

use v5.36;
use File::Slurper qw(read_lines);
use List::Util qw(sum);

my $sum = sum map { "$_->[0]$_->[-1]" } map { [ $_ =~ /(\d)/g ] } read_lines("input.txt");
say "The sum of all the calibration values is $sum.";
