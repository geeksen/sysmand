#!/usr/bin/perl

package sysmand;

use strict;
use warnings;
use vars qw(%cfg);

sub load_cfg
{
	my @cfg_files = &read_dir_and_find('../cfg/', '\.cfg$');
	if (0 == scalar @cfg_files)
	{
		return 0;
	}

	foreach my $cfg_file (@cfg_files)
	{
		open my $CFG, '<', '../cfg/' . $cfg_file or return 0;

		my $file = '';
		while (0 != (my $n = read $CFG, my $tmp, 1024)) { $file .= $tmp; }
		close $CFG;

		$file =~ s/\\r//g;
		my @lines = split /\n/, $file;

		$cfg_file =~ s/\.cfg$//g;
		foreach my $line (@lines)
		{
			my @pair = split /\=/, $line;
			$cfg{$cfg_file . '::' . &trim($pair[0])} = &trim($pair[1]);
		}
	}

	return 1;
}

sub read_dir_and_find
{
        my $path = $_[0];
        my $keyword = $_[1];

	if (! -d $path)
	{
		return ();
	}

        opendir(my $D, $path) or die $!;
        my @files = readdir $D;
        closedir $D;

        my @found = ();
        foreach my $file (@files)
        {
                if ($file =~ /^\./) { next; }
                if ($file =~ /$keyword/) { push @found, $file; }
        }

        return sort @found;
}

sub trim
{
	my $str = $_[0];

	$str =~ s/^\s+|\s+$//g;
	return $str;
}

1;
