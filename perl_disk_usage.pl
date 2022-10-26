#!/usr/bin/env perl
use strict;
use warnings;

use Filesys::DiskUsage qw(du);
use Number::Format;
use Email::Sender::Simple qw(sendmail);
use Email::Sender::Transport::SMTP ();
use Email::Simple ();
use Email::Simple::Creator ();
use Try::Tiny;

if (not @ARGV) {
    die "Usage: $0 DIRs\n";
}

my $directory = $ARGV[0];

print $directory . "\n";

my $message = '';
my $x = Number::Format -> new();

print "Calculating disk usage.... \n";

my %sizes = du({ 'make-hash' => 1 }, @ARGV);
foreach my $entry (sort {$sizes{$a} <=> $sizes{$b}} keys %sizes) {
    my $size = $x->format_bytes($sizes{$entry}, unit => 'M');
    $message = $message . "\n" . $entry . " => " . $size;
}

print "Do you want the disk usage calculations to be printed: yes / no \n";

my $print_calc = <STDIN>;
chomp $print_calc;

if (lc($print_calc) eq "yes") {
    print $message . "\n";
}

print "Should the disk usage be sent to your email address: yes / no \n";
my $should_mail = <STDIN>;
chomp $should_mail;

if (lc($should_mail) eq "yes") {

    my %smtp_configuration;

    $smtp_configuration{'server'} = '';
    $smtp_configuration{'port'} = 0;
    $smtp_configuration{'username'} = '';
    $smtp_configuration{'password'} = '';
    my $recipient = '';

    print "Provide valid SMTP configuration: \n";

    print "SMTP Server: ";
    $smtp_configuration{'server'} = <STDIN>;
    chomp $smtp_configuration{'server'};

    print "SMTP Port: ";
    $smtp_configuration{'port'} = <STDIN>;
    chomp $smtp_configuration{'port'};

    print "SMTP Username: ";
    $smtp_configuration{'username'} = <STDIN>;
    chomp $smtp_configuration{'username'};

    print "SMTP Password: ";
    $smtp_configuration{'password'} = <STDIN>;
    chomp $smtp_configuration{'password'};

    print "To which email address should the details be sent: ";
    $recipient = <STDIN>;
    chomp $recipient;

    for my $key ( keys %smtp_configuration ) {
        my $value = $smtp_configuration{$key};
        if ($value eq '') {
            print "Not all of the SMTP details were added. \n";
            exit 0;
        }
    }

    if ($recipient eq '') {
        print "The recipient can not be empty. \n";
        exit 0;
    }

    my $transport = Email::Sender::Transport::SMTP->new(
        host          => $smtp_configuration{'server'},
        port          => $smtp_configuration{'port'},
        ssl           => 'ssl',
        sasl_username => $smtp_configuration{'username'},
        sasl_password => $smtp_configuration{'password'}
    );

    my $email = Email::Simple->create(
        header => [
            To      => $recipient,
            From    => $smtp_configuration{'username'},
            Subject => "Disk usage for " . $directory,
        ],
        body   => $message,
    );

    try {
        sendmail($email, { transport => $transport });
    } catch {
        warn "caught error: $_";
        exit 0;
    };

    print "Email Sent Successfully\n";
}



