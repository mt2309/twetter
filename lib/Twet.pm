package Twet;

use v5.12;

use Moose;
use utf8;
use AnyEvent;
use AnyEvent::Twitter::Stream;
use Data::Dumper;
use URI::Find;
use Term::ReadLine;

binmode STDOUT, ":utf8";

use Term::ANSIColor;

has 'tweet_count' => (
    is => 'rw',
    isa => 'Int',
    default => 0,
);

has 'format_length' => (
    is => 'ro',
    isa => 'Int',
    default => 3,
);

has 'datetime_parser' => (
    is => 'ro',
    isa => 'DateTime::Format::Twitter',
    default => sub {return DateTime::Format::Twitter->new();},
);

has 'twetter' => (
    is => 'ro',
    isa => 'Net::Twitter',
    required => 0
    );

sub tweet {
    my ($self,$twet) = @_;

    my $length = 0;
    my $finder = URI::Find->new(sub {$length += length shift;});
    my $how_many = $finder->find(\$twet);

    eval {
        if (((length $twet) - $length + ($how_many * 13)) > 140) {
            print "Tweet was too long, was " . length $twet . " characters\n";
        }
        else {
            $self->twetter->update({ status => $twet });
        }
    };
    if ($@) {
        print $@;
    }
    else {
        $self->tweet_count($self->tweet_count + 1)
    }
}

sub interactive {
    my ($self) = @_;

    my $term = new Term::ReadLine 'Twet';

    while(defined ($_ = $term->readline($self->formatted_count()))) {
        chomp $_;
        $self->tweet($_);
    }
}

sub split_tweet {
    my ($self) = @_;

    # Grab all of stdin into a single string
    my $string_to_tweet = join("\n",<>);
    # Split on whitespace
    my @array_to_tweet = split(/\s/,$string_to_tweet);

    my $length = 0;
    my $tweet = "";

    # Vaguely hacky manner of doing this.
    # I think there's a case in which this would double tweet.
    foreach my $word (@array_to_tweet) {
        $length += length $word;
        if ($length > 140) {
            say "Tweeting: $tweet";
            $self->tweet($tweet);
            $length = length $word;
            $tweet = $word;
        }
        else {
            $tweet = $tweet . " " . $word;
        }
    }
    if ($tweet ne "") {
        say "Tweeting: $tweet";
        $self->tweet($tweet);
    }
}

sub stream_timeline {
    my ($self, $config) = @_;

    my $cv = AE::cv;

    $cv->begin;

    my $listener = AnyEvent::Twitter::Stream->new(
        consumer_key        => $config->{consumer_key},
        consumer_secret     => $config->{consumer_secret},
        token               => $config->{access_token},
        token_secret        => $config->{access_secret},
        method              => "userstream",
        on_tweet            => sub {
            my $tweet = shift; $self->stream_tweet($tweet);
        },
        timeout             => 60,
    );

    $cv->recv;
}

sub stream_tweet {
    my ($self, $status) = @_;

    if (defined $status->{user}) {
        my $date = $self->datetime_parser->parse_datetime($status->{created_at});
        my $formatted_date = DeltaTime::datetime_to_delta($date);
        print "$status->{user}{screen_name}> $status->{text}\n$formatted_date\n\n";
    }
}

sub formatted_count {
    my $self = shift;

    my $digit_count = ($self->tweet_count > 0) ? log($self->tweet_count)/log(10) : 0;

    if ($digit_count < $self->format_length) {
        return " " x ($self->format_length - $digit_count) . $self->tweet_count . " >\t";
    }
    else {
        return $self->tweet_count . " >\t";
    }
}

1;
