#! /usr/bin/perl

use warnings;
use v5.32;

my @opp_moves = ("A", "B", "C");
my $score = 0;

open(my $in, "<", "input.txt") or die "Couldn't open input.txt: $!";

while (<$in>) {
	my ($opp_move, $player_move) = split /\s+/, $_;
	my $move_score = ord($player_move) - 87;
	my $opp_losing_move = $opp_moves[$move_score-2];
	if ($opp_moves[$move_score-1] eq $opp_move) {
		say "$player_move & $opp_move are identical; it's a draw.";
		$score += (3 + $move_score);
	} elsif ($opp_move eq $opp_losing_move) {
		say "$player_move beats $opp_move; we win.";
		$score += (6 + $move_score);
	} else {
		say "$player_move loses against $opp_move; opponent wins.";
		$score += $move_score;
	}
}

say "Our final score is $score.";
