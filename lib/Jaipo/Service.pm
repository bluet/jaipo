package Jaipo::Service;
use warnings;
use strict;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors (qw/core options/);


=head1 FUNCTIONS

=head2 new

=cut

sub new {
	my $class = shift;
	my %options = @_;

	my $self = {};
	bless $self , $class;

	$self->options( \%options );

	return $self;
}

=head2 init

=cut

sub init {
	my $self = shift;

}


=head2 new_request

called right before every request

=cut

sub new_request {
	my $self = shift;

}





=head2 prereq

Returns an array of plugin module names that this plugin depends on.

=cut 

sub prereq_plugins {
	return ();
}


=head1 service methods



=cut
sub send_msg {

}


sub set_location {

}


sub read_timeline {

}

sub read_public_timeline {


}

sub create_filter {

}


sub remove_filter {

}




1;

