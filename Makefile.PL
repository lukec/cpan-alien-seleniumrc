use inc::Module::Install;

# Check for Java
my $java = qx(which java) || '';
chomp $java;
die "Selenium RC requires that java is in the PATH (java='$java')\n" unless -x $java;

# Create the Makefile
name            'Alien-SeleniumRC';
all_from        'lib/Alien/SeleniumRC.pm';
build_requires  'Test::More'        => '0.42';
install_script  'bin/selenium-rc';

auto_install;
WriteAll;
