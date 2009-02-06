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

}

sub load {
  # if can not find yml config file
  # load from default function , then write back to config file 

}


sub load_default_config {

  my $config =<<YAML

ClientPlugins:
    Twitter: { }
    Plurk: { }
    Jaiku: { }

YAML

}

1;
