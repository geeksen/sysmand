#!/usr/bin/perl

use strict;

use lib qw(.); use sysmand;
use vars qw(%cfg); *cfg = \%sysmand::cfg;

print $cfg{path};
