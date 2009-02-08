package Jaipo::Console;
use warnings;
use strict;
use Jaipo;

my $j_obj;

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
	my ( $self , $args ) = @_;

	use Data::Dumper::Simple;
	warn Dumper( $args );


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

	# do post if @_ is empty
	unless( @_ ) {
		$j_obj->action("post", $cmd );
	}
	# else we execute command
	else {
		my $param = shift;


	}


}


sub run {
	my $self = shift;

	print <<'END';
_________________________________________
Jaipo Console

version 0.1
Type :? for help
END

	# read command from STDIN
	while (1) {
		print "jaipo> ";
		my $cmd = <STDIN>;
		chomp $cmd;

		$self->execute ($cmd);

	}
}




1;
