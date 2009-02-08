#!perl

use Test::More tests => 2;

BEGIN {
	use_ok( 'Jaipo' );
}

diag( "Testing Jaipo $Jaipo::VERSION, Perl $], $^X" );

$j = Jaipo->new;
ok( $j );

$j->init();
