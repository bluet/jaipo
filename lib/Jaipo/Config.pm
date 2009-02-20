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

	# XXX: get application config path for different platform
	# windows , unix	or ...
	return $ENV{HOME} . '/.jaipo.yml';
}

sub app { return shift->_get( application => @_ ) }

sub user { return shift->_get( user => @_ ) }

# A teeny helper
sub _get { return $_[0]->stash->{ $_[1] }{ $_[2] } }


sub save {
	my  $self  = shift;
	my  $config_filepath = shift || $self->app_config_path;

    use Data::Dumper::Simple;
    warn Dumper( $self->stash );

	open CONFIG_FH , ">" , $config_filepath;
	print CONFIG_FH Dump( $self->stash );
	close CONFIG_FH;
}


sub set_service_option {
	my $self = shift;
	my $sp_name = shift;
	my $opt = shift;

	my $new_config = $self->stash;
	my @sps = @{ $self->app('Services') };
	for( my $i=0; $i < scalar @sps ; $i++ ) {
		my $c_spname = join q{},keys %{ $sps[$i] } ;
		$new_config->{application}{Services}->[$i]->{ $c_spname } = $opt
			if( $c_spname eq $sp_name );
	}
	$self->stash( $new_config );
}

=head2 find_service_option

Returns a config hash

=cut

sub find_service_option {
	my $self = shift;
	my $name = shift;

	my @services = @{ $self->app ('Services') };

	# @services = grep { $name eq shift keys $_ }, @services;

	my @configs = ();
	map { my ($p)=keys %$_; 
			push @configs,values %$_ 
			if $p =~ m/\Q$name/ } @services;
	return wantarray ? @configs : $configs[0];
}

=head2 load

=cut

sub load {
	my $self = shift;
	my $config_filepath = shift || $self->app_config_path;

	# if we can not find yml config file
	# load from default function , then write back to config file
	my $config;

	if ( -e $config_filepath ) {  # XXX: check config version
		$config = LoadFile( $config_filepath );
		$self->stash ($config);
	} 
	else {
		$config = $self->load_default_config;
		$self->stash ($config);
		# write back
		$self->save( $config_filepath );
	}

	# load user jaipo yaml config from file here
	return $config;

}

sub load_default_config {

	# move this to a file later
	my $config = <<YAML;
---
application:
    Verbose: 1
    SavePassword: 0
    Services:
        - Twitter:
            enable: 1
            username: Test
    Plugins: {}
user: {}

YAML
	return Load( $config );

}

1;
