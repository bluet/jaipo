package Jaipo::Service::Jaiku;
use warnings;
use strict;
use Net::Jaiku;
use base qw/Jaipo::Service Class::Accessor::Fast/;
use utf8;

sub init {
	my $self   = shift;
	my $caller = shift;
	my $opt = $self->options;

	unless( $opt->{username} and $opt->{userkey} ) {

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
					{   userkey => {
							label       => 'API_Key',
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

	my $jaiku = Net::Jaiku->new( %$opt );

	unless( $jaiku ) {
		# XXX: need to implement logger:  Jaipo->log->warn( );
		print "jaiku init failed\n";
	}

	$self->core( $jaiku );
}


sub send_msg {
	my ( $self , $message ) = @_;
	return "ERROR_E_ARG_MSG" if not $message;	# E for Exist
	my $result = $self->core->setPresence(
		message => $message
	);
}


# updates from an user or himself if no args
sub read_user_timeline {
	my ( $self , $user ) = @_;
	$user ||= $self->options->{username};
	
	my $lines = $self->core->getUserFeed( user => $user );

	for ( @$lines ) {
		Jaipo->logger->info( "%s | %s | from %s " , $_->{user}->{name} , $_->{text} , $_->{source} );
	}
}


# updates from user's friends or channel
sub read_public_timeline {
	my $self = shift;

	my $lines = $self->core->getContactsFeed();
	#~ Structure:
		#~ title
		#~ url
		#~ stream[n]->icon
		#~ stream[n]->content
		#~ stream[n]->created_at
		#~ stream[n]->created_at_relative
		#~ stream[n]->comments
		#~ stream[n]->url
		#~ stream[n]->id
		#~ stream[n]->title
	for ( @$lines ) {
		# XXX TODO: use jaipo logger
		Jaipo->logger->info( "%s | %s | from %s " , $_->{user}->{name} , $_->{text} , $_->{source} );
	}
}


sub read_global_timeline {
	my $self = shift;

	my $lines = $self->core->getFeed();

	for ( @$lines ) {
		Jaipo->logger->info( "%+16s | %s | from %s " , $_->{user}->{name} , $_->{text} , $_->{source} );

	}

}


sub read_channel_timeline {
	my ( $self , $channel ) = @_;
	return "ERROR_E_ARG_CHANNEL" if not $channel;	# E for Exist
	
	my $lines = $self->core->getChannelFeed( channel => $channel );

	for ( @$lines ) {
		Jaipo->logger->info( "%s | %s | from %s " , $_->{user}->{name} , $_->{text} , $_->{source} );
	}
}


sub set_user_location {
	my ( $self , $location ) = @_;
	warn "ERROR_E_ARG_CHANNEL" if not $channel;	# E for Exist
	
	my $lines = $self->core->setPresence(
		"location" => "$location"
	);
}


sub get_user_info {
	my ( $self , $user ) = @_;
	$user ||= $self->options->{username};
	
	my $lines = $self->core->getUserInfo(
		user => $user
	);
	#~ Structure:
		#~ avatar
		#~ url
		#~ nick
		#~ first_name
		#~ last_name
		#~ contacts[n]->avatar
		#~ contacts[n]->url
		#~ contacts[n]->nick
		#~ contacts[n]->first_name
		#~ contacts[n]->last_name
	say Dumper $lines;
}


1;
