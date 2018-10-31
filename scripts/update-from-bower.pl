#!/usr/bin/env perl

use strict;
use warnings;
use FindBin '$RealBin';
use feature 'say';

=head1 update-from-bower.pl

This is a script for calling `from-bower` on all packages defined in the `packages.json` file. Make sure to delete `bower-info/` to not use cached information.

See L<the Spachetti repository|https://github.com/justinwoo/spacchetti> for more details.

=cut

my @deps = `jq 'keys[]' packages.json`;

foreach my $dep (@deps) {
  chomp ($dep);
  print `$RealBin/from-bower.pl $dep`;
}
