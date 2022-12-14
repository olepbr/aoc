#! /usr/bin/perl

use v5.32;
use warnings;
use utf8;

use File::Slurper qw(read_lines);
use List::MoreUtils qw(first_index);

sub populate_stacks {
    my ($num_stacks, @stack_lines) = @_;
    my @stacks;
    foreach (@stack_lines) {
       for my $i (0..$num_stacks) {
        my $crate = substr $_, ($i*4), 3;
        push @{$stacks[$i]}, $crate if ($crate =~ /\[\w\]/ );
       } 
    }
    return map { [ reverse @{$_} ] } @stacks;
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
        push @{$stacks[$to]}, splice(@{$stacks[$from]}, -$amount, $amount);
    }
    top_printer(9001, @stacks);
}

my @lines = read_lines("input.txt");

# locate the line of the stack indicies ( 1 2 3…)
my $stack_cutoff = first_index{ $_ =~ / 1/ } @lines;

# get the number of stacks from the end of said line
my $num_stacks = substr($lines[$stack_cutoff], -2, 1)-1;

# splice out stack-describing lines
my @stack_lines = splice(@lines, 0, $stack_cutoff);

# throw away some lines we do not care about
splice(@lines, 0, 2);

my @part1_stacks = populate_stacks($num_stacks, @stack_lines);
my @part2_stacks = populate_stacks($num_stacks, @stack_lines);

my @commands = map { [ $_->[1], $_->[3]-1, $_->[5]-1 ] } map { [ split(" ", $_) ] } @lines;

cratemover_9000(\@commands, @part1_stacks);
cratemover_9001(\@commands, @part2_stacks);
