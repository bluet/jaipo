#!/usr/bin/perl
use Jaipo::Notify::LibNotify;
use Data::Dumper;

my $notify = Jaipo::Notify::LibNotify->new;
my $notification = $notify->yell("lalala");
print Dumper $notify->timeout;
$notify->timeout(10);
$notify->display("display");
#print Dumper $notification;
#sleep 10;
