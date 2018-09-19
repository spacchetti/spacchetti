#!/usr/bin/env perl

use strict;
use warnings;

# compare.pl their-packages.json

my $ours = "packages.json";
my $theirs = $ARGV[0];

my @packages = `jq 'keys[]' $ours -r`;

foreach my $package (@packages) {
    chomp($package);

    my $check = `jq '."$package"' $theirs -r`;
    chomp($check);

    if ($check eq 'null') {
        print "$package|NO ENTRY\n";
    } else {
        my $version = `jq '."$package".version' $theirs -r`;
        my @dependencies = `jq '."$package".dependencies[]' $theirs -r`;
        my $deps = join(",", @dependencies);
        $version =~ s/\n//g;
        $deps =~ s/\n//g;
        print "$package;$version;$deps\n";
    }
}
