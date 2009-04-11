package Jaipo::Notify;
use warnings;
use strict;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors (qw/notifier/);

sub new {
	my $class = shift;
	my $arg = shift;	# should be "1" or the module name "Jaipo::Notify::SomeNotify::Module"
	my $self = {};
	bless $self , $class;
	$self->init($arg);
	return $self;
}

sub init {
	my $class = shift;
	my $notify_module = shift;
	$class->notifier( {} );
	
	if ( $notify_module eq "1" ) {		# use default notify module
		if( $^O =~ m/linux/i  ) {
			$notify_module = "Jaipo::Notify::LibNotify";
		} elsif ( $^O =~ m/darwin/i ) {
			$notify_module = "Jaipo::Notify::MacGrwol";
		}
	}
	
	require $notify_module;
	my @notify = $notify_module->new;	# [module_name,object]
	
	$class->notifier( $notify[1] ) if $notify[1];
	print "$notify_module Notifier Initialized\n";
	
}

sub create {
	my ($class,$args) = @_;
	$class->notifier->yell( $args->{message} );
}

1;

