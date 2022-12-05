#! /usr/bin/perl

use warnings;
use v5.32;
use utf8;

my $score = 0;

my @opp_moves = ("A", "B", "C");
open(my $in, "<", "input.txt") or die "Couldn't open input.txt: $!";

while (<$in>) {
	my ($opp_move, $player_move) = split /\s+/, $_;
	my $move_score = ord($player_move) - 87;
	my $opp_losing_move = $opp_moves[$move_score-2];
	say "Current score: $score";
	if ($opp_moves[$move_score-1] eq $opp_move) {
		say "$player_move & $opp_move are identical!";
		$score += (3 + $move_score);
	} elsif ($opp_move eq $opp_losing_move) {
		say "$player_move beats $opp_move!";
		$score += (6 + $move_score);
	} else {
		say "$player_move loses against $opp_move";
		$score += $move_score;
	}
}

say "The final score is $score.";
