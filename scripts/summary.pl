#!/usr/bin/env perl

use strict;
use warnings;

=head1 summary.pl

Get a summary of a given package set. You should probably use `diff.pl` instead.

Example:

  ./scripts/summary.pl packages.json

=cut

my $target = $ARGV[0];

my @packages = `jq 'keys[]' $target -r`;

foreach my $package (@packages) {
  chomp($package);
  my $version = `jq '."$package".version' $target -r`;
  my @dependencies = `jq '."$package".dependencies[]' $target -r`;
  my $deps = join(",", @dependencies);
  $version =~ s/\n//g;
  $deps =~ s/\n//g;
  print "$package;$version;$deps\n";
}
