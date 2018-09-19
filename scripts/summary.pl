#!/usr/bin/env perl

use strict;
use warnings;

# summary of target packages.json file

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
