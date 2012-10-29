package Twet;

use v5.12;

use Moose;
use utf8;
binmode STDOUT, ":utf8";


has 'tweet_count' => (
    is => 'rw',
    isa => 'Int',
    default => 0,
);

has 'format_length' => (
    is => 'ro',
    isa => 'Int',
    default => 6,
);

has 'twetter' => (
    is => 'ro',
    isa => 'Net::Twitter',
    required => 1,
    );

sub tweet {
    my ($self,$twet) = @_;
    eval {
        if (length $twet > 140) {
            print "Twet was too long, was " . length $twet . " characters\n";
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

    print $self->formatted_count() . " >\t";
    while(<>) {
        chomp $_;
        $self->tweet($_);
        print $self->formatted_count() . " >\t";
    }

}

sub formatted_count {
    my $self = shift;

    my $digit_count = ($self->tweet_count > 0) ? log($self->tweet_count)/log(10) : 0;

    if ($digit_count < $self->format_length) {
        return " " x ($self->format_length - $digit_count) . $self->tweet_count;
    }
    else {
        return $self->tweet_count;
    }
}

1;
