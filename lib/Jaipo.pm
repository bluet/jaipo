package Jaipo;
use warnings;
use strict;
use feature qw(:5.10);
use Jaipo::Config;
use Jaipo::Logger;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors (qw/config/);

use vars qw/$CONFIG $LOGGER $HANDLER $PUB_SUB @PLUGINS @SERVICES/;

=encoding utf8

=head1 NAME

Jaipo - Jaiku (and other micro-blogging sites) Client

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';

=head1 DESCRIPTION

Jaipo ( 宅噗 )

This project was starting for Jaiku.com, but now going to support as-much-as-we-can micro-blogging sites.

"Jaiku" pronunced close to "宅窟" in Chinese, which means an area full of computer/internet users, and it really is one of the most popular sites recently. As jaiku is part of google and growing, there're still only few linux client.

Jaipo is a lightweight command line Jaiku Client base on RickMeasham's Net::Jaiku perl module.

Bcoz it's writen in perl, so it can run on any OS and any machine with perl. I got the first feedback that somebody use it on ARM embedded system at May 2008.

Now you can read feeds, send message, and set location with Jaipo.

=cut

=head1 FUNCTIONS

=head2 new

=cut

sub new {
	my $class = shift;
	my %args  = @_;
	my $self  = {};

	bless $self, $class;
	return $self;
}

=head2 config

return L<Jaipo::Config>

=cut

sub config {
	my $class = shift;
	$CONFIG = shift if (@_);
	$CONFIG ||= Jaipo::Config->new ();
	return $CONFIG;
}

=head2 services

=cut

sub services {
	my $class = shift;
	@SERVICES = @_ if @_;
	return @SERVICES;
}


sub logger {
    my $class = shift;
    $LOGGER = shift if ( @_ );
    return $LOGGER;
}

=head2 init 

=cut

sub init {
	my $self = shift;
	my $caller = shift;

	# prereserve arguments for service plugin
	# my $args = {
	#
	# };

	# we initialize service plugin class here
	# Set up plugins
	my @services;
	my @services_to_load = @{ Jaipo->config->app ('Services') };

	my @plugins;
	my @plugins_to_load;

	for ( my $i = 0; my $service = $services_to_load[$i]; $i++ ) {

		# Prepare to learn the plugin class name
		my ($service_name) = keys %{$service};

		my $class;

		# Is the plugin name a fully-qualified class name?
		if ( $service_name =~ /^Jaipo::Service::/ ) {
			# app-specific plugins use fully qualified names, Jaipo service plugins may
			$class = $service_name;
		}

		# otherwise, assume it's a short name, qualify it
		else {
			$class = "Jaipo::Service::" . $service_name;
		}

		# Load the service plugin options
		my %options = ( %{ $service->{$service_name} } );

		next if( ! defined $options{OnLoad} ) ;

		# Load the service plugin code
        $self->_try_to_require( $class );
		# Jaipo::ClassLoader->new(base => $class)->require;

		# Initialize the plugin and mark the prerequisites for loading too
		my $plugin_obj = $class->new( %options );
		$plugin_obj->init( $caller ) ;
		push @services, $plugin_obj;
		foreach my $name ($plugin_obj->prereq_plugins) {
		    next if grep { $_ eq $name } @plugins_to_load;
		    push @plugins_to_load, {$name => {}};
		}
	}

	# All plugins loaded, save them for later reference
	Jaipo->services (@services);

	# XXX: need to implement plugin loader

    # Logger turn on
    Jaipo->logger( Jaipo::Logger->new );


	# warn "No supported service provider initialled!\n" if not $has_site;
}


=head2 _require

=cut

sub _require {
    my $self = shift;
    my %args = @_;
    my $class = $args{module};

    return 1 if $self->_already_required( $class );

    my $file = $class;
    $file .= '.pm' unless $file =~ /\.pm$/ ;
    $file =~ s|::|/|g;

    my $retval = eval  {CORE::require "$file"} ;
    my $error = $@;
    if (my $message = $error) { 
        $message =~ s/ at .*?\n$//;
        if ($args{'quiet'} and $message =~ /^Can't locate $file/) {
            return 0;
        }
        elsif ( $error !~ /^Can't locate $file/) {
            die $error;
        } else {
            #Jifty->log->error(sprintf("$message at %s line %d\n", (caller(1))[1,2]));
            return 0;
        }
    }
}


=head2 _already_required

=cut

sub _already_required {
    my $self = shift;
    my $class = shift;
    my ( $path ) = ( $class =~ s|::|/|g );
    $path .= '.pm';
    return $INC{ $path } ? 1 : 0;
}



=head2 _try_to_require 

=cut

sub _try_to_require {
    my $self = shift;
    my $module = shift;
    $self->_require( module => $module,  quiet => 0);
}



=head2 find_plugin

Find plugins by name.

=cut

sub find_plugin {
    my $self = shift;
    my $name = shift;

    my @plugins = grep { $_->isa($name) } Jaipo->plugins;
    return wantarray ? @plugins : $plugins[0];
}


=head2 find_plugin_config

Returns a config hash

=cut

sub find_plugin_config {
	my $self = shift;
	my $name = shift;

	my @services = @{ Jaipo->config->app ('Services') };

	# @services = grep { $name eq shift keys $_ }, @services;

	my @configs = ();
	map { my ($p)=keys %$_; 
			push @configs,values %$_ 
			if $p =~ m/\Q$name/ } @services;
	return wantarray ? @configs : $configs[0];
}


=head2 runtime_load_service 


=cut

sub runtime_load_service {
	my $self = shift;
	my $caller = shift;
	my $service_name = shift;

 	my $class = "Jaipo::Service::" . ucfirst $service_name;

	my $options = $self->find_plugin_config( $service_name );

 	# Load the service plugin code
 	$self->_try_to_require( $class );
 	# Jaipo::ClassLoader->new(base => $class)->require;
 
 	my $plugin_obj = $class->new( %$options );
 	$plugin_obj->init( $caller ) ;

	my @services = Jaipo->services;

 	push @services, $plugin_obj;
 	foreach my $name ($plugin_obj->prereq_plugins) {
	# next if grep { $_ eq $name } @plugins_to_load;
	#push @plugins_to_load, {$name => {}};
 	}

	Jaipo->services (@services);

}



=head2 dispatch_to_service SERVICE, MESSAGE

command start with C<:[service]> ( e.g. C<:twitter> or C<:plurk> ) something
like that will call the servcie dispatch method,  service plugin will decide
what to do with.

=cut

sub dispatch_to_service {
    my ( $service , $line ) = @_;


}

=head2 action ACTION, PARAM

=cut

sub action {
	my ( $self , $action , $param ) = @_;
	my @services = Jaipo->services;
	foreach my $service ( @services ) {

		if( UNIVERSAL::can($service, $action) ) {
			$service->$action( $param );
		}

		else {
			# service plugin doesn't support this kind of action
		}
	}

}


=head2 send_msg SITE

=cut

# XXX: still need to implement
sub send_msg {
	my $self = shift;
	my $message = shift;
	#~ say "\033[1mSending message...\033[0m";
	
	# do pulling foreach services
	my @services = Jaipo->services;
	foreach my $service ( @services ) {
		$service->send( $message );  # need to implement send method for service plugins
	}
}

=head2 set_location SITE

=cut

# need to make sure if service provides set_location function
sub set_location {
	my $self = shift;
	my $location = shift;
	my $site     = shift;

	my $rv;
	my $has_site;

	if ( $site =~ /jaiku/i ) {
		my $rv = $self->setPresence ( location => $location );
		$has_site++;
	}

	warn "Unsupport Site!\n" if not $has_site;
	return $rv;    # success if not undef
}

=head2 _log_last_id 

=cut

sub _log_last_id {
	my $self = shift;

	# write those id to a file, so that we can check later
	if ( not -e "$ENV{HOME}/.jaipo" ) {
		say "\nThis is the \033[1mfirst time\033[0m you try me?";
		mkdir ("$ENV{HOME}/.jaipo") or die $!;
	}
	if ( not -e "$ENV{HOME}/.jaipo/last-id.log" ) {
		say "\033[1mThis might be kinda hurt\033[0m..........just kidding :p";
	}
	open LOG, ">$ENV{HOME}/.jaipo/last-id.log" or die $!;

	#~ print LOG "$_\n" for @_;
	#~ print "Current: $_[0]-$_[1]";
	print LOG "$_[0]-$_[1]";
	close LOG;
}

=head2 _compare_last_msg_id

=cut

sub _compare_last_msg_id {
	my $self = shift;

	# compare the (PostID, CommentID)
	my @old_id;
	if (   not -e "$ENV{HOME}/.jaipo"
		or not -e "$ENV{HOME}/.jaipo/last-id.log" )
	{
		say
			"\nYou \033[1mCan Not\033[0m check about if I have \033[1mAnything NEW For You\033[0m without \033[1mTouching Me First!!\033[0m";
		say
			"So Now, Plz read me by using \033[1m \$ jaipo r\033[0m  before you wanna do anything : 3";
		exit;
	}
	open LOG, "<$ENV{HOME}/.jaipo/last-id.log" or die $!;
	@old_id = split /-/, $_ for <LOG>;
	close LOG;
	( $old_id[0] == $_[0] and $old_id[1] == $_[1] ) ? 0 : 1;
}

=head2 _user_id_key

=cut



=head2 _tabs 

=cut

sub _tabs {
	my $string = shift;
	      length $string < 8  ? return "\t\t\t"
		: length $string < 18 ? return "\t\t"
		:                       return "\t";
}

=head1 AUTHOR

BlueT, C<< <bluet at blue.org> >>
Cornelius, C<< cornelius.howl at gmail.com >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-jaipo at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Jaipo>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

	perldoc Jaipo


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Jaipo>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Jaipo>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Jaipo>

=item * Search CPAN

L<http://search.cpan.org/dist/Jaipo/>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 , all rights reserved.

This program is released under the following license: GPL


=cut

1;    # End of Jaipo
