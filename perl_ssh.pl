#!/usr/bin/perl

use warnings;
use strict;

use Net::OpenSSH;

my %ssh_configuration;

$ssh_configuration{'username'} = '';
$ssh_configuration{'host'} = '';
$ssh_configuration{'port'} = 0;
$ssh_configuration{'key'} = '';
$ssh_configuration{'passphrase'} = '';

if ($#ARGV == 4) {
    $ssh_configuration{'username'} = $ARGV[0];
    $ssh_configuration{'host'} = $ARGV[1];
    $ssh_configuration{'port'} = $ARGV[2];
    $ssh_configuration{'key'} = $ARGV[3];
    $ssh_configuration{'passphrase'} = $ARGV[4];
}
else {
    print "Please provide SSH username: ";
    $ssh_configuration{'username'} = <STDIN>;
    chomp $ssh_configuration{'username'};

    print "Please provide server: ";
    $ssh_configuration{'host'} = <STDIN>;
    chomp $ssh_configuration{'host'};

    print "Please provide port: ";
    $ssh_configuration{'port'} = <STDIN>;
    chomp $ssh_configuration{'port'};

    print "Please provide path to key: ";
    $ssh_configuration{'key'} = <STDIN>;
    chomp $ssh_configuration{'key'};

    print "Please provide private key's passphrase: ";
    $ssh_configuration{'passphrase'} = <STDIN>;
    chomp $ssh_configuration{'passphrase'};
}

print "Provide the command, which should be executed on the remote machine: ";
my $cmd = <STDIN>;
chomp $cmd;

print "Connecting via SSH... \n";

my $ssh = Net::OpenSSH->new(
                      $ssh_configuration{'host'},
    user           => $ssh_configuration{'username'},
    port           => $ssh_configuration{'port'},
    key_path       => $ssh_configuration{'key'},
    passphrase     => $ssh_configuration{'passphrase'});
$ssh->error and
    die "Couldn't establish SSH connection: " . $ssh->error;

my $ssh_output = $ssh->capture($cmd);
$ssh->error and
    die "Couldn't execute the SSH command: " . $ssh->error;

open(OUTFILE, ">./ssh_output.txt") || die "Can't open ssh_output.txt for writing!\n";
print OUTFILE $ssh_output;
close(OUTFILE);

undef $ssh;