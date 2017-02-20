#!perl
use 5.006;
use strict;
use warnings;
use Test::More tests => 2;

BEGIN {
	use_ok( 'Jaipo' ) || print "Bail out!\n";
}

diag( "Testing Jaipo $Jaipo::VERSION, Perl $], $^X" );

my $j = Jaipo->new;
ok( $j );

$j->init();
