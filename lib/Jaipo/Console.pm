package Jaipo::Console;
use warnings;
use strict;
use Jaipo;
use feature qw(:5.10);

my $jobj;


=head1 SYNOPSIS

to enter jaipo console:

    $ jaipo console

    > use Twitter           # enable Twitter service plugin
    > use Plurk             # enable Plurk service plugin
    > use RSS               # enable RSS plugin
    > use IRC               # enable IRC plugin

to read reply messages

    > r|reply

to read user timeline
    > t|timeline 

    Service | User | Message
    twitter    fji    say something 
    ...
    ...
    ...

to read public timeline

    > p|public

to check user's profile

    > w|who [user id]


setup location
    > :l|location [location]

to reply to someone

    > :r|reply user, hey! how are you

to send direct message to someone. 

    > :d|direct user , hey! what's up

to send a message to a channel

    > :c|channel channel , cpan upload!

update messages
    > :u|update [message]



=cut


sub new {
	my $class = shift;
	my %args = @_;

	my $self = {};
	bless $self, $class;

	$self->_pre_init;
	return $self;
}


sub _pre_init {
	my $self = shift;

}


# setup service
sub setup_service {
	my ( $self , $args , $opt ) = @_;

	print "Init " , $args->{package_name} , ":\n";
	for my $column ( @{ $args->{require_args} } ) {
		my ($column_name , $column_option )  = each %$column;

		print $column_option->{label} , ":" ;
		my $val = <STDIN>;
		chomp $val;

		$opt->{$column_name} = $val;
	}

}


sub init {
	my $self = shift;

	# init Jaipo here
	$jobj = Jaipo->new;
	$jobj->init( $self );

}

sub print_help {
    my $self = shift;

    print <<HELP ;



HELP

}


sub execute {
	my $self = shift;
	my $cmd = shift;
	my $param = [ @_ ];

    # XXX: add trigger 
	given ($cmd) {
		when ('?') { $self->print_help }


		default {

			# do update status message if @_ is empty
			$jobj->action ( "update", join ( ' ', $cmd, $param ) );
		}
	}

}


sub run {
	my $self = shift;

	print <<'END';
_________________________________________
Jaipo Console

version 0.1
Type ? for help
END

	# read command from STDIN
	while (1) {
		print "jaipo> ";
		my $cmd = <STDIN>;
		chomp $cmd;
		my @args = split /\s+/ , $cmd;
		$self->execute (@args);
	}
}




1;
