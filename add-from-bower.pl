#!/usr/bin/perl -w

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
    print "Group file $file does not exist";
}
