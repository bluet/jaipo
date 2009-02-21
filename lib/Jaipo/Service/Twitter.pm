package Jaipo::Service::Twitter;
use warnings;
use strict;
use Net::Twitter;
use base qw/Jaipo::Service Class::Accessor::Fast/;
use Text::Table;
use Lingua::ZH::Wrap 'wrap';
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
    my %twitter_opt = %{ $opt };

	# default options
 	$twitter_opt{useragent} = 'jaipopm';
 	$twitter_opt{source}    = 'jaipopm';
 	$twitter_opt{clienturl} = 'http://jaipo.org/';
 	$twitter_opt{clientver} = '0.001';
 	$twitter_opt{clientname} = 'Jaipo.pm';

	my $twitter = Net::Twitter->new( %twitter_opt );

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
	my $tb = Text::Table->new( @cols );
	return $tb;
}


sub layout_message {
	my $self = shift;
	my $lines = shift;
	local $Lingua::ZH::Wrap::columns = 30;
	local $Lingua::ZH::Wrap::overflow = 1;

	# force Message column to be 60 chars width or more.
	my $tb = $self->get_table( qw|User Source Message| );

    for ( @$lines ) {
		my $source = $_->{source};
		# $source =~ s{<a href="(.*?)">(.*?)</a>}{$2 ($1)};
		$source =~ s{<a href="(.*?)">(.*?)</a>}{$2};
		$tb->add( $_->{user}->{name} , $source , wrap( $_->{text} )  );
    }
	return $tb->table . "";
}


=head2 SERVICE OVERRIDE FUNCTIONS

=cut

sub send_msg {
	my ( $self , $message ) = @_;
	print "Sending..." if( Jaipo->config->app('Verbose') );
	my $result = $self->core->update({ status => $message });
	print "Done\n"    if( Jaipo->config->app('Verbose') );
}

# updates from user himself
sub read_user_timeline {
    my $self = shift;
    my $lines = $self->core->user_timeline;  # XXX: give args to this method
	Jaipo->logger->info( $self->layout_message( $lines ) );
}

# updates from user's friends or channel
sub read_public_timeline {
    my $self = shift;
    my $lines = $self->core->friends_timeline;  # XXX: give args to this method
	Jaipo->logger->info( $self->layout_message( $lines ) );
}


sub read_global_timeline {
    my $self = shift;
    my $lines = $self->core->public_timeline;  # XXX: give args to this method
	Jaipo->logger->info( $self->layout_message( $lines ) );
}




1;
