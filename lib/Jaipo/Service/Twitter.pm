package Jaipo::Service::Twitter;
use warnings;
use strict;
use Net::Twitter;
use base qw/Jaipo::Service Class::Accessor::Fast/;
use utf8;

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

sub send_msg {
	my ( $self , $message ) = @_;
	my $result = $self->core->update({ status => $message });

}

# updates from user himself
sub read_user_timeline {
    my $self = shift;
    my $lines = $self->core->user_timeline;  # XXX: give args to this method

    for ( @$lines ) {
        print $_->{text} , "\n";

    }

}

# updates from user's friends or channel
sub read_public_timeline {
    my $self = shift;

    my $lines = $self->core->friends_timeline;  # XXX: give args to this method

    for ( @$lines ) {
        # XXX TODO: use jaipo logger
        print $_->{text} , "\n";

    }

}


sub read_global_timeline {
    my $self = shift;

    my $lines = $self->core->public_timeline;  # XXX: give args to this method

    for ( @$lines ) {
        print $_->{text} , "\n";

    }

}




1;
