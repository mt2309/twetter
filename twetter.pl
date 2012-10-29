#!/usr/bin/perl

use strict;
use warnings;
use utf8;

use Net::Twitter;
use YAML::XS qw(LoadFile);
use Carp;
use Getopt::Long;
use Term::ANSIColor;

my $interactive = 0;
my $config_location = "/Users/mthorpe/.twitter_info";
my $stream = 0;

GetOptions (
	"interactive" => \$interactive,
    "config:s"    => \$config_location,
    "stream"      => \$stream
	);

if ($interactive && $stream) {
    die pod2usage("Can't be interactive and stream at the same time");
}

my $config = LoadFile($config_location);

my $twetter = Net::Twitter->new(
	traits				=> [qw/OAuth API::REST/],
    consumer_key        => $config->{consumer_key},
    consumer_secret     => $config->{consumer_secret},
    access_token        => $config->{access_token},
    access_token_secret => $config->{access_secret}
);

sub tweet($) {
	my $twet = shift;
    eval {
        if (length $twet > 140) {
            print "Twet was too long, was " . length $twet . " characters\n";
        } 
        else {
            $twetter->update({ status => $twet });
        }    
    };
    if ($@) {
        print $@;
    }
	
}

if ($stream) {
    stream_tweets();
}
if (!$interactive and @ARGV > 0) {
    foreach my $tweet (@ARGV) {
        tweet $tweet;
        sleep 1;
    }
}
else {
	streaming_tweet();
}

sub streaming_tweet {
	while(<>) {
        chomp $_;
		tweet $_;
	}
}

sub stream_tweets {
    eval {
        my $statuses = $twetter->friends_timeline({ count => 30 });
        for my $status (reverse @$statuses) {
            print "$status->{created_at} $status->{user}{screen_name}> $status->{text}\n\n";
        }
    };
    if ( my $err = $@) {
        print $err;
    }
    sleep 20;
    print color("red"), "Starting new stream!\n", color("reset");
    stream_tweets();
}