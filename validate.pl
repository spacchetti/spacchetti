#!/usr/bin/perl -w

=head1 validate.pl

This is a script for quickly validating the package set and its dependencies.

Set up the package set by running `make setup`.

See L<the Spachetti repository|https://github.com/justinwoo/spacchetti> for more details.

Usage:

  validate.pl [package-name]

Example:

  ./validate.pl simple-json

  => ...
     Wrote new package behaviors to group file src/groups/paf31.dhall

=cut

my @packages = `jq 'keys[]' packages.json -r`;

my $validated = {};

sub validate {
    my ($name) = @_;

    if ($validated{$name}) {
        return;
    }

    if (grep /^$name$/, @packages) {
        $validated{$name} = 1;
    } else {
        print "could not find $name declared in packages.json\n";
        exit;
    }
}

foreach my $name (@packages) {
    chomp($name = $name);
    my @deps = `jq '."$name".dependencies | values[]' packages.json -r`;

    foreach my $target (@deps) {
        chomp($target = $target);
        validate($target);
    }
}

print "validated packages' dependencies\n";
