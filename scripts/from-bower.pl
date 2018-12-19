#!/usr/bin/env perl

use warnings;
use strict;
use feature 'say';
use FindBin '$RealBin';

=head1 from-bower.pl

This is a script for calling prepare-bower.pl in Spacchetti to add or update a package definition using mkPackage to a package group.

See L<the Spachetti repository|https://github.com/spacchetti/spacchetti> for more details.

Usage:

  from-bower.pl [package-name]

Example:

  ./from-bower.pl behaviors

  => ...
     Wrote new package behaviors to group file src/groups/paf31.dhall

=cut

my $numArgs = $#ARGV;

if ($numArgs < 0) {
  print "I need one arg for what the bower package name is without the preceding `purescript-`\n";
  print "e.g. `./scripts/from-bower.pl yargs`\n";
  exit;
}

my $input = $ARGV[0];

my $result = `perl $RealBin/prepare-bower.pl $input`;
my $matches = $result =~ /.*\/\/.*\/(.*)\//;

if ($matches < 1) {
    print "Could not extract group name from $result\n";
    exit;
}

my $file = "src/groups/$1.dhall";

my $check = `jq '."$input"?' packages.json`;
chomp($check);

if ($check eq 'null') {
    if (-e $file) {
        local $/ = undef;
        open my $read, $file or die "Couldn't open file $file";
        my $string = <$read>;

        $string =~ s/}//;
        my $output = $string . ",$result}";
        close $read;

        open my $write, '>', $file or die "Couldn't open existing file $file";
        print $write $output;
        close $write;
        print `make format`;

        print "Wrote new package $input to group file $file\n";
    } else {
        my $output = "let mkPackage = ./../mkPackage.dhall in {$result}";

        open my $write, '>', $file or die "Couldn't open new file $file";
        print $write $output;
        close $write;
        print `make format`;

        print "Wrote new package $input to group file $file\n";
    }
} else {
    local $/ = undef;
    open my $read, $file or die "Couldn't open existing file $file";
    my $string = <$read>;
    $string =~ s/$input =\s*mkPackage\s*\[[^\]]*\][^"]*"[^\s]*"\s*"[^\s]*"/$result/s;
    close $read;

    open my $write, '>', $file or die "Couldn't open new file $file";
    print $write $string;
    close $write;
    print `make format`;

    print "Updated $input in $file\n";
}
