#!/usr/bin/perl -w

=head1 add-from-bower.pl

This is a script for calling prepare-bower.pl in Spacchetti to add a package definition using mkPackage to a package group.

See L<the Spachetti repository|https://github.com/justinwoo/spacchetti> for more details.

Usage:

  add-from-bower.pl [package-name]

Example:

  ./add-from-bower.pl behaviors

  => ...
     Wrote new package behaviors to group file src/groups/paf31.dhall

=cut

my $numArgs = $#ARGV;

if ($numArgs < 0) {
  print "I need one arg for what the bower package name is without the preceding `purescript-`\n";
  print "e.g. `prepare-bower.pl yargs`";
  exit;
}

my $input = $ARGV[0];

my $result = `perl prepare-bower.pl $input`;
my $matches = $result =~ /.*\/\/.*\/(.*)\//;

if ($matches < 1) {
    print "Could not extract group name from $result";
    exit;
}

my $file = "src/groups/$1.dhall";
if (-e $file) {
    local $/ = undef;
    open my $read, $file or die "Couldn't open file $file";
    my $string = <$read>;

    $string =~ s/}//;
    my $output = $string . ",$result}";
    close $read;

    open my $write, '>', $file or die "Couldn't open file $file";
    print $write $output;
    close $write;
    print `./format.sh`;

    print "Wrote new package $input to group file $file";
} else {
    my $output = "let mkPackage = ./../mkPackage.dhall in  {$result}";

    open my $write, '>', $file or die "Couldn't open file $file";
    print $write $output;
    close $write;
    print `./format.sh`;

    print "Wrote new package $input to group file $file";
}
