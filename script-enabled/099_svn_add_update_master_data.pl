#!/usr/bin/perl

use strict;
use warnings;

use lib qw(../lib); use sysmand;
use vars qw(%cfg); *cfg = \%sysmand::cfg;

my $svn = '/usr/bin/svn';

my $path = $cfg{'sysmand::path'} . '/www_data/tools/game';
my $lock = '/home/super/perl_scripts/master_data/svn_sync.lock';

my @games = ('flow');
my @versions = ('develop');

&main;

sub main
{
	# Check Lock
	if (-e $lock)
	{
		return;
	}

	# Create Lock
	system $cp . ' /dev/null '  . $lock;

	foreach my $game (@games)
	{
		foreach my $version (@versions)
		{
			my @XMLs = &read_dir_and_filter($path . '/' . $game . '/autobahn/xml/' . $version, 'xml');

			my @reverse_sorted_XMLs = sort { $b cmp $a } @XMLs;

			my $prev_filename = '';
			foreach my $XML (@reverse_sorted_XMLs)
			{
				my @splited = split('-', $XML);
				my $filename = $splited[0];
				my $revision = $splited[2];
				my $userid = $splited[3];
				$userid =~ s/.xml//g;

				if ($prev_filename eq $filename) { next; }

				system $svn . ' update ' . $path . '/' . $game . '/autobahn/svn/' . $version  . '/' . $filename . '.xml';
				#print "\n";
				system $cp . ' -f ' . $path . '/' . $game . '/autobahn/xml/' . $version . '/' . $XML . ' ' . $path . '/' . $game . '/autobahn/svn/' . $version . '/' . $filename . '.xml';
				#print "\n";
				system $svn . ' add ' . $path . '/' . $game . '/autobahn/svn/' . $version  . '/' . $filename . '.xml';
				#print "\n";

				my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime((stat $path . '/' . $game . '/autobahn/xml/' . $version . '/' . $XML)[10]);
				system $svn . ' commit -m "' . $filename . ' rev-' . $revision . ' by ' . $userid . ' at ' . sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec) . '" ' . $path . '/' . $game . '/autobahn/svn/' . $version  . '/' . $filename . '.xml';
				#print "\n";

				my $class_name = '';
				my @filenames_splitted = split('_', $filename);
				foreach my $filename_splitted (@filenames_splitted)
				{
					if ('master' eq $filename_splitted) { last; }
					$class_name .= ucfirst($filename_splitted);
				}

				open my $DEFAULT_INFO, '>', $path . '/' . $game . '/autobahn/svn_client_master/Info/Default' . $class_name . 'Info.cs';
				print $DEFAULT_INFO get('http://172.16.0.21/tools/autobahn/defaultinfo_cs.php?game=' . $game . '&version=develop&master=' . $filename . '&revision=0');
				close $DEFAULT_INFO;

				system $svn . ' update ' . $path . '/' . $game . '/autobahn/svn_client_master/Info/Default' . $class_name . 'Info.cs';
				#print "\n";
				system $svn . ' add ' . $path . '/' . $game . '/autobahn/svn_client_master/Info/Default' . $class_name . 'Info.cs';
				#print "\n";
				system $svn . ' commit -m "' . $filename . ' rev-' . $revision . ' by ' . $userid . ' at ' . sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec) . '" ' . $path . '/' . $game . '/autobahn/svn_client_master/Info/Default' . $class_name . 'Info.cs';
				#print "\n";

				open my $MASTER_DB, '>', $path . '/' . $game . '/autobahn/svn_client_master/DB/' . $class_name . 'MasterDB.cs';
				print $MASTER_DB get('http://172.16.0.21/tools/autobahn/masterdb_cs_client.php?game=' . $game . '&version=develop&master=' . $filename . '&revision=0');
				close $MASTER_DB;

				system $svn . ' update ' . $path . '/' . $game . '/autobahn/svn_client_master/DB/' . $class_name . 'MasterDB.cs';
				#print "\n";
				system $svn . ' add ' . $path . '/' . $game . '/autobahn/svn_client_master/DB/' . $class_name . 'MasterDB.cs';
				#print "\n";
				system $svn . ' commit -m "' . $filename . ' rev-' . $revision . ' by ' . $userid . ' at ' . sprintf("%04d-%02d-%02d %02d:%02d:%02d", $year + 1900, $mon + 1, $mday, $hour, $min, $sec) . '" ' . $path . '/' . $game . '/autobahn/svn_client_master/DB/' . $class_name . 'MasterDB.cs';
				#print "\n";

				$prev_filename = $filename;
			}
		}
	}

	system $rm . ' ' . $lock;
}
