package Jaipo::Service;
use warnings;
use strict;
use base qw/Class::Accessor::Fast/;



=head1 FUNCTIONS

=head2 new

=cut

sub new {
	my $class = shift;
	return bless {} , $class;
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

1;

