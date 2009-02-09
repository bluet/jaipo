package Jaipo::Console;
use warnings;
use strict;
use Jaipo;
use feature qw(:5.10);

my $j_obj;


=head1 SYNOPSIS

to enter jaipo console:

    $ jaipo console


enable Twitter service plugin
    > use Twitter

enable Plurk service plugin
    > use Plurk

enable RSS plugin
    > use RSS

enable IRC plugin
    > use IRC

to reply messages

    > r|replay  [key]  [message]

    > t|timeline (unread items)

    Service | User | Message
    twitter    fji    say something 
    ...
    ...
    ...

update messages
    > u|update [message]

setup location
    > l|location [location]


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
	$j_obj = Jaipo->new;
	$j_obj->init( $self );

}


sub execute {
	my $self = shift;
	my $cmd = shift;
	my $param = @_;

	given ($cmd) {
		when ('?') { }
		when ('r') { }
		when ('l') { }

		default {
			# do update status message if @_ is empty
			$j_obj->action("update", join(' ',$cmd,$param) );
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
