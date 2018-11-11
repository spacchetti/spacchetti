#!/usr/bin/env perl

use warnings;
use strict;
use feature 'say';
use FindBin '$RealBin';

=head1 verify-set.pl

Verify the entire set.

=cut

my @pids;

my @targets = `jq 'keys | sort | values[]' packages.json -r`;

foreach my $target (@targets) {
    my $pid = fork;

    if (not defined $pid) {
        die "could not fork";
    } elsif ($pid == 0) {
        print `$RealBin/verify-package.pl $target`;

        if ($? != 0) {
            say "Failed to verify target: $target";
            kill "TERM", $pid;
        } else {
            exit;
        }
    } else {
        push @pids, $pid;
    }
}

for my $pid (@pids) {
    waitpid $pid, 0;
}

say "Done verifying.";
