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
		# XXX TODO: we need to simplify this, let it like jifty dbi schema  or
		# something
		$caller->setup_service ( {
				package_name => __PACKAGE__,
				require_args => [ {
						username => {
							label       => 'Username',
							description => '',
							type        => 'text'
						}
					},
					{   password => {
							label       => 'Password',
							description => '',
							type        => 'text'
						} } ]
			},
			$opt
		);

		use Data::Dumper::Simple;
		warn Dumper( $opt );

	}

	my $twitter = Net::Twitter->new( %$opt );
	$self->core( $twitter );
}


1;
