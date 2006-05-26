#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 5;
use lib 'lib';

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

Starting_server: {
    Alien::SeleniumRC::start();
    like $command, qr(java -jar \S+/+selenium-server\.jar\s*$);
    Alien::SeleniumRC::start('-port 8888');
    like $command, qr(java -jar \S+/+selenium-server\.jar\s-port 8888$);
}

Server_help: {
    Alien::SeleniumRC::help();
    like $command, qr(java -jar \S+/+selenium-server\.jar\s-help$);
}
