#!/usr/bin/perl

use v5.12;
use lib 'lib';

use strict;
use warnings;
use utf8;

use Net::Twitter;
use YAML::XS qw(LoadFile);
use Carp;
use Getopt::Long;
use Term::ANSIColor;
use DateTime;
use DateTime::Format::Twitter;
use DeltaTime;

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
            say $status->{created_at};
            my $date = DateTime::Format::Twitter->parse_twitter_date($status->{created_at});
            my $formatted_date = DeltaTime->datetime_to_delta($date);
            print "$status->{user}{screen_name}> $status->{text}\n$formatted_date\n\n";
        }
    };
    if ( my $err = $@) {
        print $err;
    }
    sleep 20;
    print color("red"), "Starting new stream!\n", color("reset");
    stream_tweets();
}

=head1 NAME

Twetter - a command line client for Twitter

=head1 DESCRIPTION

I wasn't happy with any of the current Twitter command line clients, so I wrote my own.

=head1 OPTIONS

=over 8

=item B<--interactive>

Allows you to write tweets as you want - reads from STDIN, a newline posts the tweet.

eg: twetter --interactive < my_cool_tweets.txt

=item B<--stream>

Fetches the last 30 tweets on your timeline

=item B<ARGV>

Passing a list of escaped strings one after the other will tweet them

eg: twetter 'this is one tweet' 'this is another'

=back

=head1 CAVEATS

Currently uses a quite bad method of authentication - everything is hardcoded for my own profile and Twitter account.

=head1 AUTHOR

Michael Thorpe <mt2309@ic.ac.uk>

