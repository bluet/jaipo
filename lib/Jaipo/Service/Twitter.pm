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
		# XXX TODO: simplify this, let it like jifty dbi schema  or
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

	Jaipo->config->set_service_option( 'Twitter' , $opt );

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


=head2 PRIVATE FUNCTIONS

=cut


sub get_table {
	my $self = shift;
	my @cols = @_;
	use Text::Table;
	my $tb = Text::Table->new( @cols );
	return $tb;
}


=head2 SERVICE OVERRIDE FUNCTIONS

=cut

sub send_msg {
	my ( $self , $message ) = @_;
	my $result = $self->core->update({ status => $message });

}

# updates from user himself
sub read_user_timeline {
    my $self = shift;
    my $lines = $self->core->user_timeline;  # XXX: give args to this method

	use Lingua::ZH::Wrap 'wrap';

	local $Lingua::ZH::Wrap::columns = 30;
	local $Lingua::ZH::Wrap::overflow = 1;

	# force Message column to be 60 chars width or more.

	my $tb = $self->get_table( qw|User Message Source| );
    for ( @$lines ) {
		$tb->add( $_->{user}->{name} , wrap( $_->{text} ) , $_->{source} );
    }
	Jaipo->logger->info( "" . $tb->table );
}

# updates from user's friends or channel
sub read_public_timeline {
    my $self = shift;

    my $lines = $self->core->friends_timeline;  # XXX: give args to this method

	my $tb = $self->get_table( qw|User Message Source| );
    for ( @$lines ) {
		$tb->add( $_->{user}->{name} , $_->{text} , $_->{source} );
    }
	Jaipo->logger->info( $tb->table );

}


sub read_global_timeline {
    my $self = shift;

    my $lines = $self->core->public_timeline;  # XXX: give args to this method

	my $tb = $self->get_table( qw|User Message Source| );
    for ( @$lines ) {
		$tb->add( $_->{user}->{name} , $_->{text} , $_->{source} );
    }
	Jaipo->logger->info( $tb->table );
}




1;
