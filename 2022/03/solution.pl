#! /usr/bin/perl

use v5.32;
use warnings;
use utf8;

use File::Slurper qw(read_lines);
use List::Util qw(reduce);
use Set::Scalar;

sub find_misplaced {
    my (@strs) = @_;
    my @commons;

    foreach (@strs) {
        my $strlen = length($_) / 2;
        my ($head, $tail) = unpack("A$strlen A$strlen", $_);
        my $head_set = Set::Scalar->new(split(//, $head));
        my $tail_set = Set::Scalar->new(split(//, $tail));
        push @commons, $head_set->intersection($tail_set)->members;
    }
    return @commons;
}

sub find_badges {
    my (@strs) = @_;
    my @badges;
    while (@strs) {
        # splice eats the array, nom nom
        my @cur_group = splice @strs, 0, 3;
        my ($head, $mid, $tail) = @cur_group;
        my $head_set = Set::Scalar->new(split(//, $head));
        my $mid_set = Set::Scalar->new(split(//, $mid));
        my $tail_set = Set::Scalar->new(split(//, $tail));
        my @common = $head_set->intersection($mid_set)->intersection($tail_set)->members;
        push @badges, @common;
    }
    return @badges;
}

sub calc_priority {
    my ($str) = @_;
    return $str =~ /[A-Z]/ ? (ord($str) - 38) : (ord($str) - 96);
}

sub reduce_sum {
    my ($func, @arr) = @_;
    return reduce { $a + calc_priority $b } 0, $func->(@arr);
}

my @test_strs = qw(vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw);

my @strs = read_lines("input.txt");

say "Sample input result part 1: ", reduce_sum(\&find_misplaced, @test_strs);
say "Sample input result part 2: ", reduce_sum(\&find_badges, @test_strs);
say "The sum of the priorities of the misplaced items is ", reduce_sum(\&find_misplaced, @strs);
say "The sum of the priorities of the badges is ", reduce_sum(\&find_badges, @strs);
