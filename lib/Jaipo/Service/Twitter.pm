package Jaipo::Service::Twitter;
use warnings;
use strict;
use Net::Twitter;
use base qw/Jaipo::Service Class::Accessor::Fast/;

__PACKAGE__->mk_accessors (qw/core/);

sub init {
	my $self = shift;
	my %opt = @_;
	my $twitter = Net::Twitter->new( %opt );

	$self->core( $twitter );
}



1;
