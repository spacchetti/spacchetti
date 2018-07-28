#!/usr/bin/env perl

use warnings;

# input file, i.e. usually packages.json
my $input = $ARGV[0] || 'packages.json';

my @packages = `jq 'keys[]' $input -r`;

my @results = ();

sub get_sha {
    my ($name) = @_;

    my $version = `jq '.["$name"].version' $input`;
    my $repo = `jq '.["$name"].repo' $input`;
    chomp($version = $version);
    chomp($repo = $repo);

    my $sha256 = `nix-prefetch-git $repo --rev "$version" --quiet | jq '.sha256'`;
    chomp($sha256 = $sha256);

    push @results, "\"$name\": $sha256";
}

foreach my $name (@packages) {
    chomp($name = $name);
    print "getting $name\n";
    get_sha($name);
}

my $result = join ", ", @results;
my $output= "{ $result }";

print "prepared results, writing to git-sha.json\n";

my $file = "git-sha.json";
open my $write, '>', $file or die "Couldn't open file $file";
print $write $output;
close $write;
print `make format`;
