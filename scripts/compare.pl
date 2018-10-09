#!/usr/bin/env perl

use strict;
use warnings;

=head1 compare.pl

Compare our package set to theirs. You should probably use `diff.pl` instead.

Example:

  ./scripts/compare.pl ../package-sets/packages.json

=cut

my $ours = "packages.json";
my $theirs = $ARGV[0];

my @my_packages = `jq 'keys[]' $ours -r`;

foreach my $package (@my_packages) {
    chomp($package);

    my $check = `jq '."$package"' $theirs -r`;
    chomp($check);

    if ($check eq 'null') {
        print "$package|NO ENTRY IN THEIRS\n";
    } else {
        my $version = `jq '."$package".version' $theirs -r`;
        my @dependencies = `jq '."$package".dependencies[]' $theirs -r`;
        my $deps = join(",", @dependencies);
        $version =~ s/\n//g;
        $deps =~ s/\n//g;
        print "$package;$version;$deps\n";
    }
}

my @their_packages = `jq 'keys[]' $theirs -r`;

foreach my $package (@their_packages) {
    chomp($package);

    my $check = `jq '."$package"' $ours -r`;
    chomp($check);

    if ($check eq 'null') {
        print "$package|NO ENTRY IN OURS\n";
    }
}
