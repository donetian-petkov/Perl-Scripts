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

my $smtpserver = 'es13.siteground.eu';
my $smtpport = 465;
my $smtpuser   = 'testing@donetianpetkov.com';
my $smtppassword = 'Siteground93!';

my $transport = Email::Sender::Transport::SMTP->new(
    host => $smtpserver,
    port => $smtpport,
    ssl => 'ssl',
    sasl_username => $smtpuser,
    sasl_password => $smtppassword,
    helo => 'testingdonetianpetkov'
);

my $email = Email::Simple->create(
  header => [
    To      => 'donetian.petkov@gmail.com',
    From    => $smtpuser,
    Subject => 'Hi! Test',
  ],
  body => $message,
);

sendmail($email, { transport => $transport });


print "Email Sent Successfully\n";
