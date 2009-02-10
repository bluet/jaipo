package Jaipo::Logger;
use warnings;
use strict;


sub new {
    my $class = shift;

    my $self = {};


    bless $self, $class;
    return $self;
}


sub warn {


}

sub info {
    my $self = shift;
    my $line = shift;

    my @args = @_;

    printf( $line , @args );
    print "\n";
}


1;
