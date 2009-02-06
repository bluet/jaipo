package Jaipo::Service;
use warnings;
use strict;
use base qw/Class::Accessor::Fast/;

sub new {
	my $class = shift;
	return bless {} , $class;
}

sub init {
	my $self = shift;

}


=head2 new_request

called right before every request

=cut

sub new_request {
	my $self = shift;


}


1;

