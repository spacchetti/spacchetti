#!/usr/bin/env perl

use warnings;

=head1 verify.pl

This is a script for verifying a given package after setting up the package set.

Set up the package set by running `make setup`.

See L<the Spachetti repository|https://github.com/justinwoo/spacchetti> for more details.

Usage:

  verify.pl [package-name]

Example:

  ./verify.pl simple-json

  => ...
     Wrote new package behaviors to group file src/groups/paf31.dhall

=cut

my $numArgs = $#ARGV;

if ($numArgs < 0) {
  print "I need one arg for which package to verify\n";
  print "e.g. `./scripts/verify.pl simple-json`\n";
  exit;
}

my $input = $ARGV[0];
my $visited = {};

sub verify {
    my ($name) = @_;

    if ($visited{$name}) {
        return;
    }

    print "\ninstalling and verifying $name\n";
    print `psc-package install $name`;
    print `psc-package build -d`;

    $visited{$name} = 1;

    my @reverseDeps = `cat packages.json | jq 'to_entries[] | select(.value.dependencies[] | . == "$name") | .key'`;

    foreach my $target (@reverseDeps) {
        $target =~ s/"//g;
        verify($target);
    }
}

verify($input);
