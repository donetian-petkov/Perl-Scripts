# Perl-Scripts

## perl_ssh.pl

The perl_ssh.pl script connects to an account over SSH and can execute one or several commands separated by semi-colon on the account. 
The output is then saved in ssh_output.txt file.

**Usage:** perl perl_ssh.pl $username $hostname $port $path_to_key $passphrase

Also, simply executing **perl perl_ssh.pl** will prompt you for the above mentioned information as well.

**Example:**

```
26.10.2022 [16:17]  > donetianpetkov > ~/ perl perl_ssh.pl
You must provide valid key-based SSH credentials:
Please provide the username: ***********
Please provide the server: ***********
Please provide the port: ***********
Please provide the path to the key: ***********
Please provide the private key's passphrase:
Provide the command, which should be executed on the remote machine:
path="***********"; wp option get home --path=$path ; wp plugin status --path=$path | grep U ; wp theme status --path=$path | grep U;
Connecting via SSH...
Successfully connected to SSH!
SSH Command Executed Successfully and the output has been saved to ssh_output.txt!
```
```
26.10.2022 [16:19]  > donetianpetkov > ~ > cat ssh_output.txt
https://www.donetianpetkov.com
 UA **********                  7.2.4
 UA **********                    1.3.4
 UA **********                  19.8
Legend: A = Active, I = Inactive, M = Must Use, D = Drop-In, U = Update Available
 UI **********    1.9
 UI ********** 1.5
 UI ********** 1.1
Legend: I = Inactive, A = Active, U = Update Available
```

Note: the connection is key-based as this is the primary way our customers connect to our servers.  

Dependencies: Net::OpenSSH

## perl_disk_usage.pl

The script calculates the disk usage on a given directory (or the files inside), sorts the usage and provides two options for the output to be given back:

1) Either by being displayed directly on the terminal 

or

2) by sending it to an email address, provided that the person inputs valid credentials for SSL-based SMTP connection

**Usage:** perl perl_disk_usage.pl $directory

**Example:**

```
26.10.2022 [16:30]  > donetianpetkov > ~/ perl perl_disk_usage.pl test/*
Calculating disk usage....
Do you want the disk usage calculations to be printed: yes / no
yes

test/test.txt => 0M
test/test2.txt => 0M
test/test4.txt => 500M
test/test3.txt => 1,024M

Should the disk usage be sent to your email address: yes / no
no
```

```
26.10.2022 [16:30]  > donetianpetkov > ~/ perl perl_disk_usage.pl test/*
Calculating disk usage....
Do you want the disk usage calculations to be printed: yes / no
no

Should the disk usage be sent to your email address: yes / no
yes

Provide valid SMTP configuration:
SMTP Server: ***********
SMTP Port: ***********
SMTP Username: ***********
SMTP Password: ***********
To which email address should the details be sent: ***********

Email Sent Successfully
```
