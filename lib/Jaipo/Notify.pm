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
    my $class = shift;
    $class->notifier( {} );
    if( $^O =~ m/linux/i  ) {
        $class->_init_linux;
    }
    elsif( $^O =~ m/darwin/i ) {
        $class->_init_osx;
    }
}

sub _init_linux {
    my $class = shift;
    use Jaipo::Notify::LibNotify;
    my $notify = Jaipo::Notify::LibNotify->new;
    $class->notifier( $notify );
    print "Desktop::Notify Notifier Initialized\n";
}

sub _init_osx {
    use Mac::Growl;
    Mac::Growl::RegisterNotifications( 'Jaipo', ['Updates' ] , [ 'Updates' ] );
    print "Mac::Growl Notifier Initialized\n";
}

sub create {
    my ( $class, $args ) = @_;
    if ( $^O =~ m/linux/i ) {
        $class->_create_linux($args);
    }
    elsif ( $^O =~ m/darwin/i ) {
        $class->_create_osx($args);
    }
}

sub _create_osx {
    my ($class,$args) = @_;
    Mac::Growl::PostNotification( 'Jaipo',  'Updates'  , 'Jaipo', $args->{message} );
}

sub _create_linux {
    my ($class,$args) = @_;
    $class->notifier->yell( $args->{message} );
}


1;

