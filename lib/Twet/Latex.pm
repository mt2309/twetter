package Twet::Latex;

use strict;
use warnings;

use v5.12;
use utf8;

my %commands = (
    '\pm' => '±',
    '\to' => '→',
    '\Rightarrow' => '⇒',
    '\Leftrightarrow' => '⇔',
    '\forall' => '∀',
    '\partial' => '∂',
    '\exists' => '∃',
    '\emptyset' => '∅',
    '\nabla' => '∇',
    '\in' => '∈',
    '\not\in' => '∉',
    '\prod' => '∏',
    '\sum' => '∑',
    '\surd' => '√',
    '\infty' => '∞',
    '\wedge' => '∧',
    '\vee' => '∨',
    '\cap' => '∩',
    '\cup' => '∪',
    '\int' => '∫',
    '\approx' => '≈',
    '\neq' => '≠',
    '\equiv' => '≡',
    '\leq' => '≤',
    '\geq' => '≥',
    '\subset' => '⊂',
    '\supset' => '⊃',
    '\cdot' => '⋅',
    '^\circ' => '°',
    '\times' => '×',
    '\lfloor' => '⌊',
    '\rfloor' => '⌋',
    '\lceil' => '⌈',
    '\rceil' => '⌉'
);

my $pat = join '|', map quotemeta, keys %commands;
my $regex = qr/$pat/;

sub format_string {
    my $string = shift;

    $string =~ s/($regex)/$commands{$1}/go;
    return $string;
}
