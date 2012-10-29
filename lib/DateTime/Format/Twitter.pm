package DateTime::Format::Twitter;

use v5.12;

use strict;
use warnings;
use utf8;

use DateTime;

my %months = (
    Jan => 1,
    Feb => 2,
    Mar => 3,
    Apr => 4,
    May => 5,
    Jun => 6,
    Jul => 7,
    Aug => 8,
    Sep => 9,
    Oct => 10,
    Nov => 11,
    Dec => 12, 
    );


sub parse_twitter_date {
    my ($self, $date) = @_;

    # Twitter dates are in this crazy format
    # Mon Oct 29 12:08:32 +0000 2012
    if (my ($day_of_week, $month, $day_of_month, $hour, $minute, $second, $year) = $date =~ /^(\w+)\s+(\w+)\s+(\d+)\s+(\d+):(\d+):(\d+)\s+\+0000\s+(\d+)/ ) {
        return DateTime->new(
            day => $day_of_month, 
            month => $months{$month}, 
            year => $year,
            hour => $hour,
            minute => $minute,
            second => $second);
    }
    # If it fails, return the current date.
    else {
        return DateTime->now();
    }
}

1;