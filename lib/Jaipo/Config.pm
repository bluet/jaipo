package Jaipo::Config;
use warnings;
use strict;
use Hash::Merge;
use YAML::Syck;
Hash::Merge::set_behavior ('RIGHT_PRECEDENT');

use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors (qw/stash/);

use vars qw/$CONFIG/;

sub new {
	my $class = shift;
	my %args = @_;

	my $self = {};
	bless $self , $class;
	$self->stash( {} );

	$self->load;

	return $self;
}

sub app_config_path {
	my $self = shift;

	# get application config path
	# windows , unix	or ...

}

sub app { return shift->_get( application => @_ ) }

sub user { return shift->_get( user => @_ ) }

# A teeny helper
sub _get { return $_[0]->stash->{ $_[1] }{ $_[2] } }


sub save {
	my ( $self , $config ) = @_;

}

sub load {
	my $self = shift;

	# if we can not find yml config file
	# load from default function , then write back to config file
	my $config;

	if ( not -e "$ENV{HOME}/.jaipo.yml" ) {
		$config = $self->load_default_config;
		$self->stash ($config);
	}

	# load user jaipo yaml config from file here
	return $config;

}

sub load_default_config {

	# move this to a file later
	my $config = <<YAML;
---
application:
    Services:
        - Twitter:
            username: Test
    Plugins: {}
user: {}

YAML
	use YAML;
	return YAML::Load( $config );

}

1;
