package Jaipo::UI;

use warnings;
use strict;
#~ use Smart::Comments;
use base qw/Class::Accessor::Fast/;
__PACKAGE__->mk_accessors (qw/core options trigger_name sp_id/);

=encoding utf8

=head1 NAME

Jaipo::UI - UI dispacher

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 SYNOPSIS


	use Jaipo::UI;
	
	my $ui = Jaipo::UI->new("console");

=head1 FUNCTIONS

=head2 new

Return a UI object.

=cut


sub new {
	my $class = shift;
	my $arg = shift;	# should be "1" or the module name "Jaipo::Notify::SomeNotify::Module"
	my $self = {};
	bless $self , $class;
	$self->init($arg);
	return $self;
}

sub init {
	my $class = shift;
	my $notify_module = shift;
	$class->notifier( {} );
	
	if ( $notify_module eq "1" ) {		# use default notify module
		if( $^O =~ m/linux/i  ) {
			$notify_module = "Jaipo::Notify::LibNotify";
		} elsif ( $^O =~ m/darwin/i ) {
			$notify_module = "Jaipo::Notify::MacGrwol";
		}
	}
	
	require $notify_module;
	my @notify = $notify_module->new;	# [module_name,object]
	
	$class->notifier( $notify[1] ) if $notify[1];
	print "$notify_module Notifier Initialized\n";
	
}

sub create {
	my ($class,$args) = @_;
	$class->notifier->yell( $args->{message} );
}

=head1 AUTHOR

BlueT - Matthew Lien - 練喆明, C<< <BlueT at BlueT.org> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-jaipo-ui at rt.cpan.org>, or through
the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Jaipo-UI>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Jaipo::UI


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=Jaipo-UI>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/Jaipo-UI>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/Jaipo-UI>

=item * Search CPAN

L<http://search.cpan.org/dist/Jaipo-UI>

=back


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2009 BlueT - Matthew Lien - 練喆明, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut

1; # End of Jaipo::UI
