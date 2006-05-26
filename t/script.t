#!/usr/bin/perl
use strict;
use warnings;
use Test::More tests => 2;

my $src = 'bin/selenium-rc';

Script_compiles: {
    like qx($^X -Ilib -c $src 2>&1), qr/OK/;
}

Arguments_passed_through: {
    like qx($^X -Ilib $src -help 2>&1), qr/usage/i;
}
