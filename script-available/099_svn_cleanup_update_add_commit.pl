#!/usr/bin/perl

use strict;
use warnings;

my $path = '/var/www-data/site01';
my $lock = '/var/www-data/site01-lock/site01.lock';

my $cp = '/bin/cp';
my $rm = '/bin/rm';
my $svn = '/usr/bin/svn';

&main;

sub main
{
	my $debug = ' > /dev/null 2> /dev/null';
	if (0 != scalar @ARGV && $ARGV[0] eq '--debug')
	{
		$debug = '';
	}

	# Check Lock
	if (-e $lock)
	{
		return;
	}

	# Create Lock
	system $cp . ' /dev/null '  . $lock . $debug;

	system $svn . ' cleanup ' . $path . $debug;
	#print "\n";

	system $svn . ' update ' . $path . $debug;
	#print "\n";

	system $svn . ' add ' . $path . '/*.*' . $debug;
	#print "\n";

	system $svn . ' commit -m "auto-commit by sysmand" ' . $path . '/*.*' . $debug;
	#print "\n";

	# Remove Lock
	system $rm . ' ' . $lock . $debug;
}
