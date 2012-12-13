package Twet::Latex;

use strict;
use warnings;

use v5.12;
use utf8;

my %commands = (
    '\pm' => '±',
);

my $pat = join '|', map quotemeta, keys %commands;
my $regex = qr/$pat/;

sub format_string {
    my $string = shift;

    $string =~ s/($regex)/$commands{$1}/go;
    return $string;
}