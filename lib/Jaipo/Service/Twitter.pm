package Jaipo::Service::Twitter;
use warnings;
use strict;
use Net::Twitter;
use base qw/Jaipo::Service Class::Accessor::Fast/;


sub init {
	my $self   = shift;
	my $caller = shift;
	my $opt = $self->options;

	unless( $opt->{username} and $opt->{password} ) {

		# request to setup parameter
		$caller->setup_service ( {
				package_name => __PACKAGE__,
				require_args => {
					username => { label => 'Username', description => '' },
					password => { label => 'Password', description => '' },
		} } , $opt );
	}

	my $twitter = Net::Twitter->new( %$opt );
	$self->core( $twitter );
}


1;
