#!/usr/bin/env perl

use strict;
use warnings;

use FindBin '$RealBin';

=head1 diff.pl

Get a diff between the local package set and the other package set.

Example:

  ./scripts/diff.pl ../package-sets/packages.json

=cut

my $ours = "packages.json";
my $theirs = $ARGV[0];

my $mine_setup = `perl $RealBin/summary.pl $ours > ours.txt`;
my $compare_setup = `perl $RealBin/compare.pl $theirs > compare.txt`;
print `colordiff -u ours.txt compare.txt`;
