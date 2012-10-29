package DeltaTime;

use v5.12;

use strict;
use warnings;
use utf8;

use DateTime;


sub datetime_to_delta {
    my ($self, $date) = @_;

    my $delta = time - ($date->epoch());

    return "Less than 20 seconds ago" if $delta < 20;
    return "Less than a minute ago" if $delta < 60;
    return int($delta/60) . " minutes ago" if $delta < 45 * 60;
    return "about an hour ago" if $delta < 120 * 60;
    return int($delta/(60*60)) . " hours ago" if $delta < 24 * 60 * 60;
    return "A day ago" if $delta < 48 * 60 * 60;
    return int($delta/(60*60*24)) . " days ago" if $delta < 30 * 24 * 60 * 60;
    return int($delta/(60*60*24*30)) . " months ago";
}


1;