#! /usr/bin/perl

use v5.36;
use File::Slurper qw(read_lines);
use List::Util qw(any);

my $max_red = 12;
my $max_green = 13;
my $max_blue = 14;

my @test_lines = (
"Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green",
"Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue",
"Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red",
"Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red",
"Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green",
);

my $id_sum = 0;

# The subsets are a red herring; we only really care about finding a number of
# (red|green|blue) higher than allowed somewhere in the game.
for my $line (read_lines("input.txt")) {
	my ($game_id, $rest) = $line =~ /Game (\d+): (.*)/;
	my @reds = $rest =~ /(\d+) red/g;
	my @blues = $rest =~ /(\d+) blue/g;
	my @greens = $rest =~ /(\d+) green/g;
	next if (any { $_ > $max_red } @reds) || (any { $_ > $max_green } @greens) || (any { $_ > $max_blue } @blues);
	$id_sum += $game_id;
}

say $id_sum;
