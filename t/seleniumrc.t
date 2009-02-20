#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 5;
use lib 'lib';

use constant MIN_PERL_TO_TEST => 5.006;
use constant MIN_PERL_MESSAGE => 'Need Perl >= ' . MIN_PERL_TO_TEST . ' to test';

my $command;
BEGIN {
    # mock system() for testing
    package Alien::SeleniumRC;
    use subs 'system';

    package main;
    *Alien::SeleniumRC::system = sub { $command = shift };

    use_ok 'Alien::SeleniumRC';
}

$Alien::SeleniumRC::VERBOSE = 0; # keep tests quiet

Jar_location: {
    is Alien::SeleniumRC::find_jar_location(), 'lib/Alien/SeleniumRC/selenium-server.jar';
}

my $java = 'java';
$java = 'sudo /usr/libexec/StartupItemContext `which java`' if $^O eq 'darwin';
Starting_server: {
  SKIP: {
      skip MIN_PERL_MESSAGE . ' start()', 2 unless ( $] >= MIN_PERL_TO_TEST );

      Alien::SeleniumRC::start();
      like $command, qr($java -jar \S+/+selenium-server\.jar\s*$);
      Alien::SeleniumRC::start('-port 8888');
      like $command, qr($java -jar \S+/+selenium-server\.jar\s-port 8888$);
    }
}

Server_help: {
  SKIP: {
      skip MIN_PERL_MESSAGE . ' help()', 1 unless ( $] >= MIN_PERL_TO_TEST );

      Alien::SeleniumRC::help();
      like $command, qr($java -jar \S+/+selenium-server\.jar\s-help$);
    }
}
