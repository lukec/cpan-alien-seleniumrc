package Alien::SeleniumRC;
use strict;
use warnings;

our $VERSION = '0.02';
our $VERBOSE = 1;

use 5.006;

sub start {
    my $args = shift || '';
    my $jarfile = find_jar_location();

    my $cmd = "java -jar $jarfile $args";
    print "Running $cmd\n" if $VERBOSE;
    system($cmd);
    print "Selenium server has finished\n" if $VERBOSE;
}

sub help {
    # ignore the return code of selenium-server.jar -help
    start('-help');
}

sub find_jar_location {
    my $pm_location = $INC{'Alien/SeleniumRC.pm'};
    (my $src_location = $pm_location) =~ s#\.pm#/selenium-server.jar#;
    die "Can't find $src_location!" unless -e $src_location;
    return $src_location;
}

1;

=head1 NAME

Alien::SeleniumRC - Packages the Selenium Remote Control server.

=head1 SYNOPSIS

  use Alien::SeleniumRC;
  Alien::SeleniumRC::start();

=head1 DESCRIPTION

The Selenium RC home page is at L<http://openqa.org/selenium-rc>

Selenium Remote Control is a test tool that allows you to write
automated web application UI tests in any programming language against
any HTTP website using any mainstream JavaScript-enabled browser.

Selenium Remote Control provides a Selenium Server, which can
automatically start/stop/control any supported browser. It works by
using Selenium Core, a pure-HTML+JS library that performs automated
tasks in JavaScript.

=head1 METHODS

=head2 C<start>

This method launches the Selenium RC server bundled in this package.
This call will block until the server is killed.

The first argument passed to start() will be passed to
selenium-server.jar as a command line argument.

=head2 C<help>

Prints the selenium-server.jar usage.

=head1 SEE ALSO

L<WWW::Selenium>, L<Test::WWW::Selenium>

Selenium Remote Control home page: L<http://openqa.org/selenium-rc>

Selenium home page: L<http://openqa.org/selenium>

Selenium Core home page: L<http://openqa.org/selenium-core>

=head1 LICENSE

This software is released under the same terms as perl itself.
If you don't know what that means visit http://perl.com/

Copyright 2006 by Luke Closs

All rights Reserved

=head1 AUTHOR

Luke Closs <selenium-rc@awesnob.com>

=cut
