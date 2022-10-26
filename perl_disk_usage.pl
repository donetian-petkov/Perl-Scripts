#!/usr/bin/env perl
use strict;
use warnings;
 
use Filesys::DiskUsage qw(du);
use Number::Format;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP ();
use Email::Simple ();
use Email::Simple::Creator (); 

if (not @ARGV) {
    die "Usage: $0 DIRs\n";
}
 
my $message = '';
my $x = new Number::Format;

my %sizes = du({'make-hash' => 1}, @ARGV);
foreach my $entry (sort { $sizes{$a} <=> $sizes{$b} } keys %sizes) {
    my $size = $x -> format_bytes($sizes{$entry}, unit => 'M'); 
    print "$entry => $size\n";
    $message = $message . "\n" . $entry . " => " . $size ;
}

my $smtp_server = '';
my $smtp_port = 0;
my $smtp_username   = '';
my $smtp_password = '';

my $should_mail = 0;

print "Should the disk usage be sent to your email address: yes / no \n";
if (<STDIN> eq "yes") {
    $should_mail = 1;

    print "Provide valid SMTP configuration: \n";

    print "SMTP Server: ";
    $smtp_server = <STDIN>;
    chomp $smtp_server;

    print "SMTP Port: ";
    $smtp_port = <STDIN>;
    chomp $smtp_port;

    print "SMTP Username: ";
    $smtp_username = <STDIN>;
    chomp $smtp_username;

    print "SMTP Password: ";
    $smtp_password = <STDIN>;
    chomp $smtp_password;

    print "To which email address should the details be sent: ";
    $recipient = <STDIN>;
    chomp $recipient;
}


my $transport = Email::Sender::Transport::SMTP->new(
    host => $smtp_server,
    port => $smtp_port,
    ssl => 'ssl',
    sasl_username => $smtp_username,
    sasl_password => $smtp_password,
    helo => 'testingdonetianpetkov'
);

my $email = Email::Simple->create(
  header => [
    To      => 'donetian.petkov@gmail.com',
    From    => $smtp_username,
    Subject => 'Hi! Test',
  ],
  body => $message,
);

sendmail($email, { transport => $transport });


print "Email Sent Successfully\n";
