#! /usr/bin/perl

use v5.32;
use warnings;
use utf8;

use File::Slurper qw(read_lines);
use List::MoreUtils qw(first_index);

sub populate_stacks {
    my ($stack_cutoff, $num_stacks, @stack_lines) = @_;
    my @stacks;
    for (my $i = $stack_cutoff-1; $i >= 0; $i--) {
       for (my $j = 0; $j < $num_stacks; $j++) {
        my $crate = substr $stack_lines[$i], ($j*4), 3;
        push @{$stacks[$j]}, $crate if ($crate =~ /\[\w\]/ );
       } 
    }
    return @stacks;
}

sub top_printer {
    my ($model_no, @stacks) = @_;
    say "CrateMover $model_no left the following crates at the top of each stack: ", join "", map { substr(pop @{$_}, 1, 1) } @stacks;
}

sub cratemover_9000 {
    my ($commands, @stacks) = @_;
    foreach (@{$commands}) {
        my ($amount, $from, $to) = @{$_};
        for (1..$amount) {
            push @{$stacks[$to]}, pop @{$stacks[$from]};
        }
    }
    top_printer(9000, @stacks);
}

sub cratemover_9001 {
    my ($commands, @stacks) = @_;
    foreach (@{$commands}) {
        my ($amount, $from, $to) = @{$_};
        my $from_length = scalar @{$stacks[$from]};
        push @{$stacks[$to]}, splice(@{$stacks[$from]}, -$amount, $amount);
    }
    top_printer(9001, @stacks);
}

my @lines = read_lines("input.txt");

# locate the line of the stack indicies ( 1 2 3…)
my $stack_cutoff = first_index{ $_ =~ / 1/ } @lines;

# get the number of stacks from the end of said line
my $num_stacks = substr $lines[$stack_cutoff], -2, 1;

# splice out stack-describing lines
my @stack_lines = splice(@lines, 0, $stack_cutoff);

# throw away some lines we do not care about
splice(@lines, 0, 2);

my @part1_stacks = populate_stacks($stack_cutoff, $num_stacks, @stack_lines);
my @part2_stacks = populate_stacks($stack_cutoff, $num_stacks, @stack_lines);

my @commands = map { [ $_->[1], $_->[3]-1, $_->[5]-1 ] } map { [ split(" ", $_) ] } @lines;

cratemover_9000(\@commands, @part1_stacks);
cratemover_9001(\@commands, @part2_stacks);
