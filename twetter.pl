#!/usr/bin/perl

use v5.12;
use lib 'lib';

use strict;
use warnings;
use utf8;
binmode STDOUT, ":utf8";

use Net::Twitter;
use YAML::XS qw(LoadFile);
use Carp;
use Getopt::Long;
use Term::ANSIColor;
use DateTime;
use DateTime::Format::Twitter;
use DeltaTime;
use Twet;
use Pod::Usage;

my ($interactive, $stream, $split_tweet, $config_location, $help, $all) = (0,0,0,0,0,0);
$config_location = $ENV{"HOME"} . "/.twitter_info";

GetOptions (
	"interactive" => \$interactive,
    "stream"      => \$stream,
    "split"       => \$split_tweet,
    "config:s"    => \$config_location,
    "all"         => \$all,
    "help"        => \$help
	) or pod2usage(-verbose => 99, -sections => "OPTIONS");

if ($help) {
    pod2usage(-verbose => 3);
}

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

my $tweeter = Twet->new(twetter => $twetter);

if ($stream) {
    say "Streaming!";
    $tweeter->stream_timeline($config,$all);
}
if ($split_tweet) {
    say "Splitting the tweets";
    $tweeter->split_tweet();
}
elsif (!$interactive and @ARGV > 0) {
    foreach my $tweet (@ARGV) {
        $tweeter->tweet($tweet);
        sleep 1;
    }
}
else {
	$tweeter->interactive();
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

