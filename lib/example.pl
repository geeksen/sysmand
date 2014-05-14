#!/usr/bin/perl

use strict;
use warnings;

use Data::Dumper;

use lib qw(.); use sysmand;
use vars qw(%cfg); *cfg = \%sysmand::cfg;

if (0 == &sysmand::load_cfg)
{
	print "load_cfg failed\n";
	exit;
}

print Dumper(%cfg);
