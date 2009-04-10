use strict;
use warnings;
use inc::Module::Install;

# Define metadata
name           'Jaipo';
all_from       'lib/Jaipo.pm';

# Specific dependencies
requires 'Test::More'            => 0;
requires 'Hash::Merge'           => 0;
requires 'YAML::Syck'            => 0;
requires 'Class::Accessor::Fast' => 0;
# requires       'WWW::Plurk'            => 0,
# requires       'Net::Jaiku'            => 0,
requires 'Net::Twitter'          => 0;
requires 'Class::Accessor::Fast' => 0;
requires 'Text::Table'           => 0;
requires 'Number::RecordLocator' => 0;
requires 'Term::ReadLine'        => 0;
requires 'App::Cache'            => 0;
requires 'Data::Dumper::Simple'	=> 0;

if( $^O =~ m/darwin/i ) {
    recommends 'Mac::Glue'  => '1.30';
    recommends 'Mac::Growl' => '0.67';
}
elsif( $^O =~ m/linux/i )  {
    recommends 'Desktop::Notify' => '0';
}

# test_requires  'Test::More'  => '0.42';
# recommends     'Text::CSV_XS'=> '0.50';
# no_index       'directory'   => 'demos';
install_script 'bin/jaipo';
WriteAll;
