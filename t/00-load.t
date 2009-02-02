#!perl -T

use Test::More tests => 1;

BEGIN {
	use_ok( 'Jaipo' );
}

diag( "Testing Jaipo $Jaipo::VERSION, Perl $], $^X" );
