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
	}

	# default options
# 	$opt->{useragent} = 'Jaipo (Perl)';
# 	$opt->{source}    = 'Jaipo (Perl)';
# 	$opt->{clienturl} = '';
# 	$opt->{clientver} = '';
# 	$opt->{clientname} = '';

	my $twitter = Net::Twitter->new( %$opt );

	unless( $twitter ) {
		# XXX: need to implement logger:  Jaipo->log->warn( );
		print "twitter init failed\n";
	}

	$self->core( $twitter );
}

sub update {
	my ( $self , $message ) = @_;
	my $result = $self->core->update({ status => $message });

}

sub user_timeline {
    my ( $self ) = @_;

}

sub reply {

}


1;
