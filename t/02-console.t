#!perl
use Test::More tests => 3;
BEGIN {
    use_ok('Jaipo::Console');
    use_ok('Jaipo');
}

$jc = Jaipo::Console->new;

ok( $jc );

$jc->init;





