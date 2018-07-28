#!/usr/bin/env perl

use warnings;

=head1 update-from-bower.pl

This is a script for calling prepare-bower.pl in Spacchetti to update a package definition in an existing group.

See L<the Spachetti repository|https://github.com/justinwoo/spacchetti> for more details.

Usage:

  update-from-bower.pl [package-name]

Example:

  ./update-from-bower.pl behaviors

  => ...
     Wrote new package behaviors to group file src/groups/paf31.dhall

=cut
use FindBin '$RealBin';

my $numArgs = $#ARGV;

if ($numArgs < 0) {
  print "I need one arg for what the bower package name is without the preceding `purescript-`\n";
  print "e.g. `./scripts/update-from-bower.pl yargs`\n";
  exit;
}

my $input = $ARGV[0];
my $json = "bower-info/$input.json";

my $result = `perl $RealBin/prepare-bower.pl $input`;
my $matches = $result =~ /.*\/\/.*\/(.*)\//;

if ($matches < 1) {
    print "Could not extract group name from $result\n";
    exit;
}

chomp(my $version = "v" . `cat $json | jq '.latest.version' -r`);
chomp(my $url = `cat $json | jq '.latest.repository.url' -r`);

my $file = "src/groups/$1.dhall";

local $/ = undef;
open my $read, $file or die "Couldn't open file $file";
my $string = <$read>;
$string =~ s/(https:\/\/.*purescript-$input(\.git|)"[^"]*").*(")/$1$version$3/;
close $read;

open my $write, '>', $file or die "Couldn't open file $file";
print $write $string;
close $write;
print `make format`;

print "Updated $input to $version in $file\n";
