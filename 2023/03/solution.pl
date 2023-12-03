#! /usr/bin/perl

use v5.36;
use File::Slurper qw( read_lines );
use List::Util    qw( sum );

sub find_parts ($lines_ref) {
    my @sym_pos   = ();
    my %gear_hash = ();
    my @part_nos  = ();
    my @lines     = @{$lines_ref};

    # Find all symbols on every line and record their position as well as what
    # they are.
    for my $i ( 0 .. $#lines ) {
        my $line = $lines[$i];
        $sym_pos[$i] = {};
        while ( $line =~ /(\D)/g ) {
            if ( $1 ne '.' ) {
                $sym_pos[$i]{ $-[0] } = $1;
            }
        }
    }

    for my $i ( 0 .. $#lines ) {
        my $line = $lines[$i];

        # Go through every number.
        while ( $line =~ /(\d+)/g ) {
            my $start    = $-[0];
            my $end      = $+[0];
            my $prev_idx = $start - 1;

            # The previous character is a symbol.
            if ( $start > 0 && exists $sym_pos[$i]{$prev_idx} ) {
                my $prev_char = $sym_pos[$i]{$prev_idx};
                if ( $prev_char eq "*" ) {
                    my $gear_key = "$i-$prev_idx";
                    if ( exists $gear_hash{$gear_key} ) {
                        push @{ $gear_hash{$gear_key} }, $1;
                    }
                    else {
                        $gear_hash{$gear_key} = [$1];
                    }
                }
                push @part_nos, $1;
                next;
            }
            if ( $end < length($line) - 1 && exists $sym_pos[$i]{$end} ) {
                my $fol_char = $sym_pos[$i]{$end};
                if ( $fol_char eq "*" ) {
                    my $gear_key = "$i-$end";
                    if ( exists $gear_hash{$gear_key} ) {
                        push @{ $gear_hash{$gear_key} }, $1;
                    }
                    else {
                        $gear_hash{$gear_key} = [$1];
                    }
                }
                push @part_nos, $1;
                next;
            }
            my $valid = 0;
            if ( $i > 0 ) {
                my $prev_line = $i - 1;
                my $hr        = $sym_pos[$prev_line];
                my $new_start = $start > 0 ? $start - 1 : $start;
                for my $j ( $new_start .. $end ) {
                    if ( exists $hr->{$j} ) {
                        if ( $hr->{$j} eq "*" ) {
                            my $gear_key = "$prev_line-$j";
                            if ( exists $gear_hash{$gear_key} ) {
                                push @{ $gear_hash{$gear_key} }, $1;
                            }
                            else {
                                $gear_hash{$gear_key} = [$1];
                            }
                        }
                        push @part_nos, $1;
                        $valid = 1;
                        last;
                    }
                }
            }
            if ( !$valid && $i < $#lines ) {
                my $next_line = $i + 1;
                my $hr        = $sym_pos[$next_line];
                my $new_start = $start > 0 ? $start - 1 : $start;
                for my $j ( $new_start .. $end ) {
                    if ( exists $hr->{$j} ) {
                        if ( $hr->{$j} eq "*" ) {
                            my $gear_key = "$next_line-$j";
                            if ( exists $gear_hash{$gear_key} ) {
                                push @{ $gear_hash{$gear_key} }, $1;
                            }
                            else {
                                $gear_hash{$gear_key} = [$1];
                            }
                        }
                        push @part_nos, $1;
                        last;
                    }
                }
            }
        }
    }
    say "The sum of part numbers is " . sum(@part_nos) . ".";
    my $gear_sum = 0;
    map {
        my @arr = @{ $gear_hash{$_} };
        if ( scalar @arr == 2 ) { $gear_sum += $arr[0] * $arr[1]; }
    } keys %gear_hash;
    say "The sum of gear ratios is " . $gear_sum . ".";
}

my @test_lines = (
    '467..114..', '...*......', '..35..633.', '......#...',
    '617*......', '.....+.58.', '..592.....', '......755.',
    '...$.*....', '.664.598..',
);

find_parts( \@test_lines );

my @lines = read_lines("input.txt");
find_parts( \@lines );
