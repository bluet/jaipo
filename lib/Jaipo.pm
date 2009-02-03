package Jaipo;

use warnings;
use strict;

my %service_providers;

sub initialize {
	my $jaiku = new Net::Jaiku(
		username => $ID,
		userkey  => $API_KEY
	);
}

sub send_msg {
	my $message = shift;
	my $site = shift;
	print "\033[1mSending message...\033[0m\n";
	
	my $rv;
	my $has_site;
	
	if ($site =~ /jaiku/i) {
		$rv = $jaiku->setPresence(
			message => $message
		);
		$has_site++;
	}
	if ($site =~ /twitter/i) {
		1;
		$has_site++;
	}
	if ($site =~ /plurk/i) {
		1;
		$has_site++;
	}
	
	warn "Unsupport Site!\n" if not $has_site;
	return $rv;	# success if not undef
}

sub set_location {
	my $location = shift;
	my $site = shift;
	
	my $rv;
	my $has_site;
	
	if ($site =~ /jaiku/i) {
		my $rv = $jaiku->setPresence(
			location => $location
		);
		$has_site++;
	}
	
	warn "Unsupport Site!\n" if not $has_site;
	return $rv;	# success if not undef
}

sub _log_last_id {
	# write those id to a file, so that we can check later
	if (not -e "$ENV{HOME}/.jaipo") {
		print "\nThis is the \033[1mfirst time\033[0m you try me?\n";
		mkdir("$ENV{HOME}/.jaipo") or die $!;
	}
	if (not -e "$ENV{HOME}/.jaipo/last-id.log") {
		print "\033[1mThis might be kinda hurt\033[0m..........just kidding :p\n";
	}
	open LOG, ">$ENV{HOME}/.jaipo/last-id.log" or die $!;
	#~ print LOG "$_\n" for @_;
	#~ print "Current: $_[0]-$_[1]";
	print LOG "$_[0]-$_[1]";
	close LOG;
}

sub _compare_last_msg_id {
	# compare the (PostID, CommentID)
	my @old_id;
	if (not -e "$ENV{HOME}/.jaipo" or not -e "$ENV{HOME}/.jaipo/last-id.log") {
		print "\nYou \033[1mCan Not\033[0m check about if I have \033[1mAnything NEW For You\033[0m without \033[1mTouching Me First!!\033[0m\n";
		print "So Now, Plz read me by using \033[1m \$ jaipo r\033[0m  before you wanna do anything : 3\n";
		exit;
	}
	open LOG, "<$ENV{HOME}/.jaipo/last-id.log" or die $!;
	@old_id = split/-/,$_ for <LOG>;
	close LOG;
	( $old_id[0] == $_[0] and $old_id[1] == $_[1] ) ? 0 : 1 ;
}

sub _user_id_key {
	# check user name and API key
	# can use XXX::ConfigFile module
	my @user_login;
	if (not -e "$ENV{HOME}/.jaipo" or not -e "$ENV{HOME}/.jaipo/user.login") {
		print "no user.login config file\n";
		exit;
	}
	open USER, "<$ENV{HOME}/.jaipo/user.login" or die $!;
	while (<USER>) {chomp; push @user_login, $_};
	close USER;
	return \@user_login;
}

sub _tabs {
	my $string = shift;
	length $string < 8 ? return "\t\t\t" : length $string < 18 ? return "\t\t" : return "\t" ;;
}

=head1 NAME

Jaipo - JAIku (and other micro-blogging sites) POster

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';


=head1 DESCRIPTION

Jaipo (宅噗)

This project was starting for Jaiku.com, but now going to support as-much-as-we-can micro-blogging sites.

"Jaiku" pronunced close to "宅窟" in Chinese, which means an area full of computer/internet users, and it really is one of the most popular sites recently. As jaiku is part of google and growing, there're still only few linux client.

Jaipo is a lightweight command line Jaiku Client base on RickMeasham's Net::Jaiku perl module.

Bcoz it's writen in perl, so it can run on any OS and any machine with perl. I got the first feedback that somebody use it on ARM embedded system at May 2008.

Now you can read feeds, send message, and set location with Jaipo.

=head1 EXPORT



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

1; # End of Jaipo
