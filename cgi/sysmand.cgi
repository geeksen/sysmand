#!/usr/bin/perl

# //////
# --@-@
#     >  Geeksen's Lab.
# ____/  http://www.geeksen.com/
#
# Copyright (c) 2014 Terry Geeksen
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

use strict;
use warnings;
no warnings 'uninitialized';

use lib qw(../lib); use sysmand;
use vars qw(%cfg); *cfg = \%sysmand::cfg;

use CGI qw/:param :header :upload/;

# Conf
my $KEY = 'too_many_secrets'; # encryption key
my $TIMEZONE = '+0900';       # +0900, KST, GMT ..

# CGI
my $q;

my $script_name = $ENV{'SCRIPT_NAME'};
my $server_name = $ENV{'SERVER_NAME'};
my $server_port = $ENV{'SERVER_PORT'};
my $remote_addr = $ENV{'REMOTE_ADDR'};

my $N;
my $M;

my ($num, $mode, $type, $back, $page, $time);
my ($email, $userid, $passwd, $pop_server, $mimepart);

my $buf = '';
my $total = 0;

&Main;

sub Main {
    $q = new CGI;

    $mode = $q->param('mode');
    $back = int($q->param('back'));
    $page = int($q->param('page'));
    $time = time();
    $userid = &smdXORCrypt($q->cookie(-name=>'smdUSERID'));
    $passwd = &smdXORCrypt($q->cookie(-name=>'smdPASSWD'));

    if ($back > -1) { $back++; }

    if ($q->param('userid') ne '') {
        $userid = $q->param('userid');
        $passwd = $q->param('passwd');
    }

       if ($mode eq 'logout')   { &Logout;   }
    else  { &LoginForm; }
}

sub Logout {
    my $cookie = $q->cookie(
        -name=>'smdUSERID',
        -value=>'',
        -path=>'/',
        -domain=>$server_name,
    );

    print $q->header(
        -charset=>'utf-8',
        -cookie=>[$cookie],
    );
    &Reload($script_name);
}

sub LoginForm {
    print $q->header(-charset=>'utf-8');
    &Head('Login');
    print <<EOT;
<span class='right'><a href='http://www.geeksen.com'>Download Source</a></span>

<form method='post' action='$script_name'>
<fieldset>

<div>
  <label>UserID</label>
  <input type='text' name='userid'>
  <input type='hidden' name='mode' value='list'>
</div>

<div>
  <label>Passwd</label>
  <input type='password' name='passwd'>
  <input type='submit' value='Login'>
</div>

</fieldset>
</form>

</div>
EOT
    &Tail;
}

sub Head {
    my $title = $_[0];

    print <<EOT;
<!DOCTYPE html>

<html>
<head>
  <title>Geeksen Mail</title>
  <meta charset='utf-8'>
  <meta name='viewport' content='initial-scale=1'>
  <style type='text/css'>
    body {
      background-color:#fff; color:#666;
      font-size:.8em; font-family:tahoma, geneva, sans-serif;
    }

    .root { width:770px }

    .left { float:left }
    .right { float:right }

    a { color:#06c; text-decoration:none }
    a:hover { color:#06c; text-decoration:underline }

    h2 { color:#666; font-weight:normal }

    form { clear:both; margin:0 }
    fieldset {
      border:1px solid #eee; padding-left:1.5em; padding-bottom:1.5em
    }
    label {
      margin-top:1.2em; margin-bottom:.2em; display:block; font-weight:bold
    }

    input { font-family:tahoma, geneva, sans-serif }
    .input-text { width:400px; }

    textarea {
      width:740px; height:300px; font-size:1em;
      font-family:tahoma, geneva, sans-serif
    }

    .nav-top { margin-bottom:.5em }
    .nav-bottom { margin-top:.5em }

    table { width:100%; border:1px solid #ddd; border-collapse:collapse }
    .hover tr:hover { background-color:#eee }

    th {
      background-color:#eee;
      border:1px solid #ddd; border-collapse:collapse; padding:.5em
    }
    td { border:1px solid #ddd; border-collapse:collapse; padding:.5em }
    .th-fixed-width { width:150px }

    .pagination {
       border-bottom:1px solid #ddd;
       margin-top:.5em; padding-bottom:.8em; text-align:center
    }
    .history_go { border:0; background-color:#fff; color:#06c }
  </style>
</head>

<body>
<div class='root'>

<h2 class='left'>$title</h2>
EOT
}

sub Tail {
    print <<EOT;

</body>
</html>
EOT
}

sub Error {
    my $message = $_[0];

    print $q->header(-charset=>'utf-8');
    &Head($message);
    print "\n</div>\n</body>\n</html>";

    exit;
}

sub Reload {
    my $url = $_[0];

    print "<!DOCTYPE html>";
    print "\n\n";
    print "<html>\n<head>\n";
    print "  <title>Reload</title>\n";
    print "  <meta http-equiv='refresh' content='0;url=$url'>\n";
    print "</head>\n<body>\n</body>\n</html>";

    exit;
}

sub smdXORCrypt {
    my $str = $_[0];
    my $key = $KEY;

    while (length($key) < length($str)) {
        $key .= $key;
    }

    my $xor = '';
    for my $i (0 .. (length($str) - 1)) {
        $xor .= substr($str, $i, 1) ^ substr($key, $i, 1);
    }

    return $xor;
}

