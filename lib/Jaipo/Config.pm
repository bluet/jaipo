package Jaipo::Config;
use warnings;
use strict;
use Hash::Merge;
use YAML::Syck;
Hash::Merge::set_behavior('RIGHT_PRECEDENT');

use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors(qw/stash/);

use vars qw/$CONFIG/;

sub new {
  my $self = shift;

}

sub app_config_path {
  my $self = shift;

  # get application config path
  # windows , unix  or ...


}

sub load {
  my $self = shift;

  # if we can not find yml config file
  # load from default function , then write back to config file 
  my $config;

  if( not -e "$ENV{HOME}/.jaipo.yml"  ) {
      $yaml = $self->load_default_config;
      $config = YAML::Load( $yaml );
      $self->stash( $config );
  }


  # load user jaipo yaml config from file here

  
  return $config;

}

sub load_default_config {
  # move this to a file later
  my $config =<<YAML

ServiceProviders:
    Twitter: { }
    Plurk: { }
    Jaiku: { }

YAML

}

1;
