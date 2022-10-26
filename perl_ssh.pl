#!/usr/bin/perl

use warnings;
use strict;

use Net::OpenSSH;

my $username = '';
my $host = '';
my $port = 0;
my $private_key = '';
my $passphrase = '';

if ($#ARGV == 4 ) {
    $username = $ARGV[0];
    $host = $ARGV[1];
    $port = $ARGV[2];
    $private_key = $ARGV[3];
    $passphrase = $ARGV[4];
}
else {
    print "Please provide username: ";
    $username = <STDIN>;
    chomp $username;

    print "Please provide server: ";
    $host = <STDIN>;
    chomp $host;

    print "Please provide port: ";
    $port = <STDIN>;
    chomp $port;

    print "Please provide path to key: ";
    $private_key = <STDIN>;
    chomp $private_key;

    print "Please provide private key's passphrase: ";
    $passphrase = <STDIN>;
    chomp $passphrase;
}
 
my $ssh = Net::OpenSSH->new($host, user => $username, port => $port, key_path => $private_key, passphrase => $passphrase);
$ssh->error and
  die "Couldn't establish SSH connection: ". $ssh->error;
 
$ssh->system("ls ~/") or
  die "remote command failed: " . $ssh->error;
 
my @ls = $ssh->capture("ls");
$ssh->error and
  die "remote ls command failed: " . $ssh->error;

