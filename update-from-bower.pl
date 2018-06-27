#!/usr/bin/perl -w

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

my $numArgs = $#ARGV;

if ($numArgs < 0) {
  print "I need one arg for what the bower package name is without the preceding `purescript-`\n";
  print "e.g. `update-from-bower.pl yargs`";
  exit;
}

my $input = $ARGV[0];
my $json = $input . ".json";

my $result = `perl prepare-bower.pl $input`;
my $matches = $result =~ /.*\/\/.*\/(.*)\//;

if ($matches < 1) {
    print "Could not extract group name from $result";
    exit;
}

chomp(my $version = "v" . `cat $json | jq '.latest.version' -r`);
print $version;
chomp(my $url = `cat $json | jq '.latest.repository.url' -r`);

my $file = "src/groups/$1.dhall";

local $/ = undef;
open my $read, $file or die "Couldn't open file $file";
my $string = <$read>;
$string =~ s/(https:\/\/.*$input.*"[^"]*").*(")/$1$version$2/;
print $string;
close $read;

open my $write, '>', $file or die "Couldn't open file $file";
print $write $string;
close $write;
print `./format.sh`;

print "Updated $input to $version in $file";
