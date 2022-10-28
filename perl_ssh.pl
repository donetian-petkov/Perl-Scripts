#!/usr/bin/perl

use warnings;
use strict;

use Net::OpenSSH;

my %ssh_configuration;

if ($#ARGV == 4) {
    $ssh_configuration{'username'} = $ARGV[0];
    $ssh_configuration{'host'} = $ARGV[1];
    $ssh_configuration{'port'} = $ARGV[2];
    $ssh_configuration{'key'} = $ARGV[3];
    $ssh_configuration{'passphrase'} = $ARGV[4];
}
else {
    print "You must provide valid key-based SSH credentials: \n";

    print "Please provide the username: ";
    $ssh_configuration{'username'} = <STDIN>;
    chomp $ssh_configuration{'username'};

    print "Please provide the server: ";
    $ssh_configuration{'host'} = <STDIN>;
    chomp $ssh_configuration{'host'};

    print "Please provide the port: ";
    $ssh_configuration{'port'} = <STDIN>;
    chomp $ssh_configuration{'port'};

    if ($ssh_configuration{'port'} !~ m/\d+/) {
        print "The port must be a number! \n";
        print "Please enter the port again: ";
        $ssh_configuration{'port'} = <STDIN>;
        chomp $ssh_configuration{'port'};
    }

    print "Please provide the path to the key: ";
    $ssh_configuration{'key'} = <STDIN>;
    chomp $ssh_configuration{'key'};

    print "Please provide the private key's passphrase: ";
    system ("stty -echo");
    $ssh_configuration{'passphrase'} = <STDIN>;
    system ("stty echo");
    chomp $ssh_configuration{'passphrase'};

    for my $key ( keys %ssh_configuration ) {
        my $value = $ssh_configuration{$key};
        if ($value eq '') {
            print "You have not submitted all of the required details! \n";
            exit;
        }
    }

    print "\n";
}

print "Provide the command, which should be executed on the remote machine: \n";

my $cmd = <STDIN>;

if ($cmd eq '') {
    print "You have provided an empty SSH command!";
    exit;
}

print "Connecting via SSH... \n";

my $ssh = Net::OpenSSH->new(
    $ssh_configuration{'host'},
    user       => $ssh_configuration{'username'},
    port       => $ssh_configuration{'port'},
    key_path   => $ssh_configuration{'key'},
    passphrase => $ssh_configuration{'passphrase'}
);
$ssh->error and
    die "Couldn't establish SSH connection: " . $ssh->error;

print "Successfully connected to SSH!\n";

my $ssh_output = $ssh->capture($cmd);
$ssh->error and
    die "Couldn't execute the SSH command: " . $ssh->error;

open(OUTFILE, ">./ssh_output.txt") || die "Can't open ssh_output.txt for writing!\n";
print OUTFILE $ssh_output;
close(OUTFILE);

undef $ssh;

print "SSH Command Executed Successfully and the output has been saved to ssh_output.txt! \n";