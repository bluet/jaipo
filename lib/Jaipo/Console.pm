package Jaipo::Console;
use warnings;
use strict;
use Jaipo;
use utf8;
use feature qw(:5.10);

my $jobj;

=encoding utf8

=head1 SYNOPSIS

to enter Jaipo console:

    $ jaipo console

    > use Twitter           # enable Twitter service plugin
    > use Plurk             # enable Plurk service plugin
    > use RSS               # enable RSS plugin
    > use IRC               # enable IRC plugin

Jaipo will automatically save your configuration, you only need to use 'use'
at first time.

to read all messeges
    > r

    Service |   User   | Message
    twitter    c9s       oh hohoho !
    plurk      xxx       剛喝完咖啡.
    ...
    ...
    ...

to read messages on Jaiku.com

    > :jaiku :r

to read someone's messages on Jaiku.com

    > :jaiku :r UnitedNation

to read public timeline

    > p

to check user's profile

    > w|who IsYourDaddy

setup location on Jaiku
    > :jaiku l 我在墾丁，天氣情。

to reply to someone's post on plurk.com

    > :plurk #2630 呆丸朱煮好棒

to send direct message to someone on twitter

    > :twitter d mama 媽，我阿雄啦！

to send a message to a channel on Jaiku

    > :jaiku #TVshow 媽，我上電視了！(揮手)

create a regular expression filter for twitter timeline

    > filter /cor[a-z]*s/i  :twitter


=head1 Command Reference

=head2 Global Commands

r
p
...

=head2 Service Commands 

:[service]  [message]

:[service]  :[action] [arguments]

=head2 


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

r       to read all messages


:[service]  [message]
:[service]  :[action]  [arguments]

HELP

}


sub parse {
	my $self = shift;
	my $line = shift;

    # XXX: add trigger 
	given ($line) {

        when ( m/^:/ ) {
            # dispatch to service
            my ($service,$rest_line) = ( $line =~ m/^:(\w+)\s+(.*)/i );
            $jobj->dispatch_to_service( $service , $rest_line );
        }

        # built-in commands
        when ( m/^(u|use)\s/i ) {
            # init service plugins

        }

        when ( m/^(r|read)\s/i ) {  
            $jobj->action ( "read_user_timeline", $line );

        }

        when ( m/^(p|public)\s/i ) { 
            $jobj->action ( "read_public_timeline", $line );

        }

        when ( m/^(g|global)\s/i ) { 
            $jobj->action ( "read_global_timeline", $line );

        }

        when ( m/^(f|filter)\s/i ) { 
            my ($cmd,$action,@params) = split /\s+/ , $line;

        }

		when ( '?' ) { 
            $self->print_help 
        }

		default {

			# do update status message if @_ is empty
            $jobj->action ( "send_msg", $line );
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
Type :[service] :? for service plugin help
END

	# read command from STDIN
	while (1) {
		print "jaipo> ";
		my $line = <STDIN>;
		chomp $line;
		$self->parse ( $line );
	}
}



1;
