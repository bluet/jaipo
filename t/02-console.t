#!perl
use Test::More tests => 3;
BEGIN {
    use_ok('Jaipo::UI::Console');
    use_ok('Jaipo');
}

$jc = Jaipo::UI::Console->new;

ok( $jc );

$jc->init;





