package Jaipo::Notify;
use warnings;
use strict;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors (qw/notifier/);

sub new {
    my $class = shift;
    my $self = {};
    bless $self , $class;
    $self->init;
    return $self;
}

sub init {
    my $self = shift;
    $self->notifier( {} );
    if( $^O =~ m/linux/i  ) {
        $self->_init_linux;
    }
    elsif( $^O =~ m/darwin/i ) {
        $self->_init_osx;
    }
}

sub _init_linux {
    my $self = shift;
    require Jaipo::Notify::LibNotify;
    my $notify = Jaipo::Notify::LibNotify->new;
    $self->notifier( $notify );
}

sub _init_osx {
    my $self = shift;
    require Jaipo::Notify::MacGrowl;
    my $notify = Jaipo::Notify::MacGrowl->new;
    $self->notifier( $notify );
}

sub create {
    my ( $self, $args ) = @_;
    $self->notifier->yell( $args->{message} );
}

1;

