#!/usr/bin/perl -w

my $numArgs = $#ARGV;

if ($numArgs < 0) {
  print "I need one arg for what the bower package name is without the preceding `purescript-`\n";
  print "e.g. `prepare-mkpkg.pl yargs`";
  exit;
}

my $input = $ARGV[0];
my $json = $input . ".json";

unless(-e $json) {
    print `bower info purescript-$input --json > $json`;
}

my $dependencies = `cat $json | jq '.latest.dependencies' | jq 'keys | map(.[11:])'`;
my $version = `cat $json | jq '.latest.version'`;
my $url = `cat $json | jq '.latest.repository.url'`;
my $from = 'git:';
my $to = "https:";
$url =~ s/$from/$to/;

my $output = <<END_TEMPLATE;
$input = mkPackage
$dependencies$url$version
END_TEMPLATE

print $output
