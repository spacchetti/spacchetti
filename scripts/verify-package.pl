#!/usr/bin/env perl

use warnings;
use strict;
use feature 'say';
use FindBin '$RealBin';

=head1 verify-package.pl

Script to verify a single package given that all of the packages have been installed via Psc-Package2Nix

Example: ./scripts/validate.pl simple-json

=cut

if ($#ARGV < 0) {
    die "Need an argument for package to validate";
}

my $json = 'packages.json';

my $input = $ARGV[0];

my @direct_deps = `jq '."${input}".dependencies | values[]' $json -r`;

my %visited = ();

sub getDeps {
    my ($name) = @_;
    chomp($name);

    if ($visited{$name}) {
        return;
    }

    $visited{$name} = 1;

    my @transitive_deps = `jq '."${name}".dependencies | values[]' $json -r`;

    foreach my $target (@transitive_deps) {
        getDeps($target);
    }
}

foreach my $target (@direct_deps) {
    getDeps($target);
}

my @deps = keys %visited;

my $globs = "";

sub add_glob {
    my ($dep) = @_;
    chomp(my $version = `jq '."${dep}".version' $json -r`);
    my $glob = ".psc-package/testing/${dep}/${version}/src/**/*.purs";
    $globs .= "'$glob' ";
}

add_glob $input;
add_glob($_) for @deps;

my $result = `purs compile $globs +RTS -N1 -RTS`;

if ($? == 0) {
    say "verified $input";
} else {
    die $result;
}
