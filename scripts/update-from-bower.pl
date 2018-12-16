#!/usr/bin/env perl

use strict;
use warnings;
use FindBin '$RealBin';
use feature 'say';

=head1 update-from-bower.pl

This is a script for calling `from-bower` on all packages defined in the `packages.json` file. Make sure to delete `bower-info/` to not use cached information.

See L<the Spachetti repository|https://github.com/spacchetti/spacchetti> for more details.

=cut

my @deps = `jq 'keys[]' packages.json`;
my @pids = ();

foreach my $dep (@deps) {
    chomp ($dep);
    my $pid = fork;
    if (not defined $pid) {
        die "Could not fork at $dep";
    } elsif ($pid == 0) {
        say "prepare-bower for $dep";
        print `$RealBin/prepare-bower.pl $dep`;
        ($? != 0) ? die "Failed prepare-bower at $dep" : exit;
    } else {
        push @pids, $pid;
    }
}

for my $pid (@pids) {
    waitpid $pid, 0;
}

say "Finished prepare-bower";

foreach my $dep (@deps) {
  chomp ($dep);
  say "from-bower for $dep";
  print `$RealBin/from-bower.pl $dep`;
}

say "Finished from-bower";
