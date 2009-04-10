#!/usr/bin/perl

use warnings;
use strict;
use utf8;

use Jaipo;
my $jaipo = Jaipo->new(
	"ui"			=> "console",
	"service"	=> "all",
);
$jaipo->init;
$jaipo->run;

__END__
This is how a client which's using Jaiku, should be.