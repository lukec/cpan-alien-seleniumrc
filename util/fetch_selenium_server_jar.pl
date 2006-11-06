#!/usr/bin/perl
use strict;
use warnings;
use LWP::Simple;
use Archive::Zip qw(:ERROR_CODES :CONSTANTS);
use File::Copy qw/copy/;
use File::Path qw/rmtree/;

# Fetches a selenium-server.jar file from the nightly selenium-rc release
# tarball and puts it in the lib tree:
#  lib/Alien/SeleniumRC/selenium-server.jar

my $nightly_url = 'http://release.openqa.org/selenium-remote-control/nightly/'
		  . 'selenium-remote-control-0.8.2-SNAPSHOT.zip';
my $src_dir = fetch_and_extract($nightly_url);

my $src_jar = "$src_dir/server/selenium-server.jar";
die "Can't find $src_jar!" unless -e $src_jar;

my $jar_dest = 'lib/Alien/SeleniumRC/selenium-server.jar';
print "Copying $src_jar to $jar_dest...\n";
copy($src_jar => $jar_dest) or die "Can't copy $src_jar to $jar_dest: $!";
exit;

sub fetch_and_extract {
    my $url = shift;
    (my $zip_file = $url) =~ s#.+/##;
    unless (-e $zip_file) {
	    print "Fetching $url...\n";
	    getstore($url, $zip_file);
	    die "Couldn't fetch $url!" unless -e $zip_file;
    }

    print "Reading $zip_file...\n";
    my $zip = Archive::Zip->new;
    unless ($zip->read($zip_file) == AZ_OK) {
	    die "Failed to read $zip_file";
    }

    (my $src_dir = $zip_file) =~ s#\.zip$##;
    if (-d $src_dir) {
	    print "Removing old $src_dir...\n";
	    rmtree $src_dir;
    }
    print "Extracting to $src_dir...\n";
    $zip->extractTree;
    return $src_dir;
}
