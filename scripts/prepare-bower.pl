#!/usr/bin/perl -w

=head1 prepare-bower.pl

This is a script for preparing a snippet for adding to a Dhall file of Spacchetti package definitions.

See L<the Spachetti repository|https://github.com/justinwoo/spacchetti> for more details.

Usage:

  prepare-bower.pl [package-name]

Example:

  ./prepare-bower.pl yargs

  => yargs = mkPackage
     [
       "console",
       "either",
       "exceptions",
       "foreign",
       "unsafe-coerce"
     ]
     "https://github.com/paf31/purescript-yargs.git"
     "4.0.0"

=cut

my $numArgs = $#ARGV;

if ($numArgs < 0) {
  print "I need one arg for what the bower package name is without the preceding `purescript-`\n";
  print "e.g. `./scripts/prepare-bower.pl yargs`\n";
  exit;
}

my $input = $ARGV[0];
my $json = "bower-info/$input.json";

unless(-e $json) {
    print `mkdir -p bower-info`;
    print `bower info purescript-$input --json > $json`;
}

chomp(my $dependencies = `cat $json | jq '.latest.dependencies' | jq 'keys | map(.[11:])'`);
chomp(my $version = `cat $json | jq '.latest.version'`);
chomp(my $url = `cat $json | jq '.latest.repository.url'`);
my $from = 'git:';
my $to = "https:";
$url =~ s/$from/$to/;

# bower doesn't believe in telling us the correct tag names
unless ($version =~ /v/) {
    $version =~ s/"//g;
    $version = "\"v$version\"";
}

my $output = <<END_TEMPLATE;
$input = mkPackage
$dependencies
$url
$version
END_TEMPLATE

print $output
