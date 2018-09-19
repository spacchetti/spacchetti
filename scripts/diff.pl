#!/usr/bin/env perl

use strict;
use warnings;

use FindBin '$RealBin';

# diff.pl their-packages.json

my $ours = "packages.json";
my $theirs = $ARGV[0];

my $mine_setup = `perl $RealBin/summary.pl $ours > ours.txt`;
my $compare_setup = `perl $RealBin/compare.pl $theirs > compare.txt`;
print `colordiff -u ours.txt compare.txt`;
