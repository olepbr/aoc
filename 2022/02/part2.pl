#! /usr/bin/perl

use warnings;
use v5.32;
use utf8;

my $score = 0;

my @opp_moves = ("Rock", "Paper", "Scissors");

my %move_hash = (
	"A" => {
		"name" => "rock",
		"score" => 1,
		"X" => "C",
		"Y" => "A",
		"Z" => "B",
	},
	"B" => {
		"name" => "paper",
		"score" => 2,
		"X" => "A",
		"Y" => "B",
		"Z" => "C",
	},
	"C" => {
		"name" => "scissors",
		"score" => 3,
		"X" => "B",
		"Y" => "C",
		"Z" => "A",
	},
);

my %score_hash = ("X" => 0, "Y" => 3, "Z" => 6);

sub get_move_and_score {
	my ($opp_move, $result) = @_;
	my $move = $move_hash{$opp_move}{$result};
	my $score = $move_hash{$move}{"score"} + $score_hash{$result};
	return ($move_hash{$move}{"name"}, $score);
}

open(my $in, "<", "input.txt") or die "Couldn't open input.txt: $!";

while (<$in>) {
	my ($opp_move, $result) = split /\s+/, $_;
	my $opp_move_name = $move_hash{$opp_move}{"name"};
	my ($move_name, $move_score) = get_move_and_score($opp_move, $result);
	if ($result eq "X") {
		say "Need to lose.\nOpponent played $opp_move_name => we choose $move_name.";
		$score += $move_score;
	} elsif ($result eq "Y") {
		say "Need to draw.\nOpponent played $opp_move_name => we choose $move_name.";
		$score += $move_score;
	} else {
		say "Need to win.\nOpponent played $opp_move_name => we choose $move_name.";
		$score += $move_score;
	}
}

say "Our final score is $score.";
