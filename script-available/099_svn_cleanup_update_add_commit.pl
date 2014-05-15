#!/usr/bin/perl

use strict;
use warnings;

use lib qw(../lib); use sysmand;
use vars qw(%cfg); *cfg = \%sysmand::cfg;

my $svn = '/usr/bin/svn';

my $path = '/var/www-data/game01';
my $lock = '/var/www-data/game01-lock/game01.lock';

&main;

sub main
{
	my $debug = ' > /dev/null 2> /dev/null';
	if (0 != scalar @ARGV && $ARGV[0] eq '--debug')
	{
		$debug = '';
	}

	if (0 == &sysmand::load_cfg)
	{
		if ('' ne $debug)
		{
			print "&sysmand::load_cfg failed\n";
			return;
		}
		exit;
	}

	# Check Lock
	if (-e $lock)
	{
		return;
	}

	# Create Lock
	system $cfg{'sysmand::cp'} . ' /dev/null '  . $lock . $debug;

	system $svn . ' cleanup ' . $path . $debug;
	#print "\n";

	system $svn . ' update ' . $path . $debug;
	#print "\n";

	system $svn . ' add ' . $path . '/*.*' . $debug;
	#print "\n";

	system $svn . ' commit -m "auto-commit by sysmand" ' . $path . '/*.*' . $debug;
	#print "\n";

	# Remove Lock
	system $cfg{'sysmand::rm'} . ' ' . $lock . $debug;
}
