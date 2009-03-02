package Jaipo::Console;
use warnings;
use strict;
use Jaipo;
use utf8;
use feature qw(:5.10);

my $jobj;

$|=1;
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

to update status

    > :突然下起大雨。

to read all messeges
    > r

    Service |   User   | Message
    twitter    c9s       oh hohoho !
    plurk      xxx       剛喝完咖啡.
    ...
    ...
    ...

to read messages on Jaiku.com

    > jaiku r

to read someone's messages on Jaiku.com

    > jaiku r UnitedNation

to read public timeline

    > p

to check user's profile

    > w IsYourDaddy

setup location on Jaiku

    > jaiku l 我在墾丁，天氣情。

to update post to Twitter

    > twitter :雨停了

to reply to someone's post on Twiwter

    > twitter reply Someone 呆丸朱煮好棒

to send direct message to someone on twitter

    > twitter send mama 媽，我阿雄啦！

to follow someone on twitter

    > twitter follow mama

to send a message to a channel on Jaiku

    > jaiku #TVshow 媽，我上電視了！(揮手)

create a regular expression filter for twitter timeline

    > filter /cor[a-z]*s/i  :twitter

enter service-only mode

    > only twitter
    :twitter>

    > only jaiku
    :jaiku>


=head1 Command Reference

=head2 Global Commands

=item r  

read user updates

=item p  

read friend updates

=item g  

read global updates

=head2 Service Commands 

[SERVICE] :[MESSAGE]

[SERVICE] [ACTION] [ ARGUMENTS .. ]

=head3 Jaiku

=head3 Twitter

=item ? 

help message

=item rd 

read direct messages

=item rr

read reply messages

=item rp

read public messages

=item rf

read followed timeline messages

=item sd [ID]  [MESSAGE]

send direct message

=item sr [ID]  [MESSAGE]

send reply message

=item w [ID]

check someone's profile

=item l [LOCATION]

LOCATION is a string, which will be updated to your profile

=item f [ID]

follow someone

=item show friends

show friends

=item show followers

show followers

=head1 Functions

=head2 new

=cut

sub new {
	my $class = shift;
	my %args = @_;

	my $self = {};
	bless $self, $class;

	$self->_pre_init;
	return $self;
}

=head2 _pre_init

=cut

sub _pre_init {
	my $self = shift;
    binmode STDOUT,":utf8";

}


=head2 setup service

=cut 

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

=head2 init

=cut

sub init {
	my $self = shift;
	$self->print_welcome;

	# init Jaipo here
	$jobj = Jaipo->new;
	$jobj->init( $self );


}

=head2 print_help 

=cut

sub print_help {
    my $self = shift;

    print <<HELP ;

r       to read all messages


:[service]  [message]
:[service]  :[action]  [arguments]

HELP

}


=head2 print_welcome

=cut

sub print_welcome {
	print <<'END';
_________________________________________
Jaipo Console

version 0.1
Type ? for help
Type :[service] :? for service plugin help

END

}


=head2 process_built_in_commands 

=cut

sub process_built_in_commands {
    my ($self ,$line ) = @_;

    $line =~ s/^://;

    # XXX: add trigger 
	given ($line) {

        # eval code
        # such like:   eval $jobj->_list_trigger;
        when ( m/^eval (.*)$/i ) {
            # eval a code
            my $code = $1;
            eval $1;
        }

        when ( m/^conf\s+edit$/i ) { 
			my $editor = $ENV{EDITOR} || 'nano' ;
			my $file = Jaipo->config->app_config_path;

			print "Launching editor .. $editor\n";
			qx{$editor $file};

        }

        when ( m/^conf\s+save$/i ) {
            # TODO
            # save configuration 

        }

        when ( m/^conf\s+load$/i ) {
            # TODO
            # load configuration
            # when user modify configuration by self, user can reload
            # configuration


        }


        # built-in commands
        # TODO:
        #
		when (m/^(?:u|use)\s*/i) {
            $line =~ s/;$//;
            my @ops = split /\s+/,$line;
            shift @ops; # shift out use command
            my ( $service_name , $trigger_name ) = @ops;

			# init service plugins
			# TODO:
			# check if user specify trigger name
			if ( !$service_name ) {
				$jobj->list_triggers;
			}
            else {
                $service_name = ucfirst $service_name;
                $trigger_name ||= lc $service_name;
                print "Trying to load $service_name => $trigger_name\n";
                $jobj->runtime_load_service ( $self, $service_name, $trigger_name );
                print "Done\n";
            }
		}


        when ( m/^(r|read)/i ) {  
            $jobj->action ( "read_user_timeline", $line );

        }

        when ( m/^(p|public)/i ) { 
            $jobj->action ( "read_public_timeline", $line );

        }

        when ( m/^(g|global)/i ) { 
            $jobj->action ( "read_global_timeline", $line );

        }


        # something like filter create /regexp/  :twitter:public
        when ( m/^(f|filter)\s/i ) { 
            my ($cmd,$action,@params) = split /\s+/ , $line;

        }

		when ( '?' ) { 
            $self->print_help 
        }

        # try to find the trigger , if match then do it
        # or show up command not found
		default {

            # dispatch to service
            my ($service_tg,$rest_line) = ( $line =~ m/^(\w+)\s*(.*)/i );
            # $jobj->dispatch_to_service( $service_tg , $rest_line );

            # find a servcie plugin by trigger 

            # parse line 
            # if find sub command , execute the sub command
            # if not, we should posting text to service

		}
	}


}

sub parse {
	my $self = shift;
	my $line = shift;

    $line =~ s/^\s*//g;
    $line =~ s/\s*$//g;

	return unless $line;

    if( $line =~ m/^:/ ) {
        # do update status message if string start with ":"
        $line =~ s/^://;
        $jobj->action ( "send_msg", $line );
    }
    else {
        $self->process_built_in_commands( $line );
    }

}



sub run {
	my $self = shift;


	# read command from STDIN
    binmode STDIN,":utf8";
	while (1) {
		print "jaipo> ";
		my $line = <STDIN>;
		chomp $line;
		$self->parse ( $line );
	}
}



1;
