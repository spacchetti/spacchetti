#!/usr/bin/env perl

=head1 copy-changes.pl

copy a given package of ours to theirs

=cut

use warnings;
use strict;

my ($pkg, $version) = @ARGV;

my $target = "../package-sets/packages.json";
my $packages = "packages.json";

chomp(my $output = `jq '."${pkg}"' $packages`);

print `jq '."${pkg}" = $output' $target > temp.json && mv temp.json $target`;
