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
  '\rceil' => '⌉',
  '\alpha' => 'α',
  '\iota' => 'ι',
  '\varrho' => 'ϱ',
  '\beta' => 'β',
  '\kappa' => 'κ',
  '\sigma' => 'σ',
  '\gamma' => 'γ',
  '\lambda' => 'λ',
  '\varsigma' => 'ς',
  '\delta' => 'δ',
  '\mu' => 'μ',
  '\tau' => 'τ',
  '\epsilon' => 'ϵ',
  '\nu' => 'ν',
  '\upsilon' => 'υ',
  '\varepsilon' => 'ε',
  '\xi' => 'ξ',
  '\phi' => 'ϕ',
  '\zeta' => 'ζ',
  'o' => 'ο',
  '\varphi' => 'φ',
  '\eta' => 'η',
  '\pi' => 'π',
  '\chi' => 'χ',
  '\theta' => 'θ',
  '\varpi' => 'ϖ',
  '\psi' => 'ψ',
  '\vartheta' => 'ϑ',
  '\rho' => 'ρ',
  '\omega' => 'ω',
  '\Gamma' => 'Γ',
  '\Xi' => 'Ξ',
  '\Phi' => 'Φ',
  '\Delta' => 'Δ',
  '\Pi' => 'Π',
  '\Psi' => 'Ψ',
  '\Theta' => 'Θ',
  '\Sigma' => 'Σ',
  '\Omega' => 'Ω',
  '\Lambda' => 'Λ',
  '\Upsilon' => 'Υ',
  '\aleph' => 'ℵ',
  '\forall' => '∀',
  '\hbar' => 'ℏ',
  '\emptyset' => '∅',
  '\exists' => '∃',
  '\imath' => 'ı',
  '\nabla' => '∇',
  '\neg' => '¬',
  '\jmath' => 'j',
  '\surd' => '√',
  '\ell' => 'ℓ',
  '\top' => '⊤',
  '\natural' => '♮',
  '\wp' => '℘',
  '\bot' => '⊥',
  '\sharp' => '♯',
  '\Re' => 'ℜ',
  '\|' => '∥',
  '\clubsuit' => '♣',
  '\Im' => 'ℑ',
  '\angle' => '∠',
  '\diamondsuit' => '♢',
  '\partial' => '∂',
  '\triangle' => '△',
  '\heartsuit' => '♡',
  '\infty' => '∞',
  '\spadesuit' => '♠',
  '\Box' => '□',
  '\Diamond' => '◇',
  '\sum' => '∑',
  '\bigcap' => '⋂',
  '\bigodot' => '⨀',
  '\prod' => '∏',
  '\bigcup' => '⋃',
  '\bigotimes' => '⨂',
  '\coprod' => '∐',
  '\bigsqcup' => '⨆',
  '\bigoplus' => '⨁',
  '\int' => '∫',
  '\bigvee' => '⋁',
  '\biguplus' => '⨄',
  '\oint' => '∮',
  '\bigwedge' => '⋀',
  '\pm' => '±',
  '\cap' => '∩',
  '\vee' => '∨',
  '\mp' => '∓',
  '\cup' => '∪',
  '\wedge' => '∧',
  '\setminus' => '∖',
  '\uplus' => '⊎',
  '\oplus' => '⊕',
  '\cdot' => '⋅',
  '\sqcap' => '⊓',
  '\ominus' => '⊖',
  '\times' => '×',
  '\sqcup' => '⊔',
  '\otimes' => '⊗',
  '\ast' => '∗',
  '\triangleleft' => '◁',
  '\oslash' => '⊘',
  '\star' => '⋆',
  '\triangleright' => '▷',
  '\odot' => '⊙',
  '\diamond' => '⋄',
  '\wr' => '≀',
  '\dagger' => '†',
  '\circ' => '∘',
  '\bigcirc' => '◯',
  '\ddagger' => '‡',
  '\bullet' => '∙',
  '\bigtriangleup' => '△',
  '\amalg' => '⨿',
  '\div' => '÷',
  '\bigtriangledown' => '▽',
  '\unlhd' => '⊴',
  '\lhd' => '⊲',
  '\rhd' => '⊳',
  '\unrhd' => '⊵',
  '\leq' => '≤',
  '\geq' => '≥',
  '\equiv' => '≡',
  '\prec' => '≺',
  '\succ' => '≻',
  '\sim' => '∼',
  '\preceq' => '≼',
  '\succeq' => '≽',
  '\simeq' => '≃',
  '\ll' => '≪',
  '\gg' => '≫',
  '\asymp' => '≍',
  '\subset' => '⊂',
  '\supset' => '⊃',
  '\approx' => '≈',
  '\subseteq' => '⊆',
  '\supseteq' => '⊇',
  '\cong' => '≅',
  '\sqsubseteq' => '⊑',
  '\sqsupseteq' => '⊒',
  '\bowtie' => '⋈',
  '\in' => '∈',
  '\ni' => '∋',
  '\propto' => '∝',
  '\vdash' => '⊢',
  '\dashv' => '⊣',
  '\models' => '⊨',
  '\smile' => '⌣',
  '\mid' => '∣',
  '\doteq' => '≐',
  '\frown' => '⌢',
  '\parallel' => '∥',
  '\perp' => '⊥',
  '\sqsubset' => '⊏',
  '\sqsupset' => '⊐',
  '\Join' => '⨝',
  '\not<' => '≮',
  '\not>' => '≯',
  '\not=' => '≠',
  '\not\leq' => '≰',
  '\not\geq' => '≱',
  '\not\equiv' => '≢',
  '\not\prec' => '⊀',
  '\not\succ' => '⊁',
  '\not\sim' => '≁',
  '\not\preceq' => '⋠',
  '\not\succeq' => '⋡',
  '\not\simeq' => '≄',
  '\not\subset' => '⊄',
  '\not\supset' => '⊅',
  '\not\approx' => '≉',
  '\not\subseteq' => '⊈',
  '\not\supseteq' => '⊉',
  '\not\cong' => '≇',
  '\not\sqsubseteq' => '⋢',
  '\not\sqsupseteq' => '⋣',
  '\not\asymp' => '≭',
  '\leftarrow' => '←',
  '\longleftarrow' => '⟵',
  '\uparrow' => '↑',
  '\Leftarrow' => '⇐',
  '\Longleftarrow' => '⟸',
  '\Uparrow' => '⇑',
  '\rightarrow' => '→',
  '\longrightarrow' => '⟶',
  '\downarrow' => '↓',
  '\Rightarrow' => '⇒',
  '\Longrightarrow' => '⟹',
  '\Downarrow' => '⇓',
  '\leftrightarrow' => '↔',
  '\longleftrightarrow' => '⟷',
  '\updownarrow' => '↕',
  '\Leftrightarrow' => '⇔',
  '\Longleftrightarrow' => '⟺',
  '\Updownarrow' => '⇕',
  '\mapsto' => '↦',
  '\longmapsto' => '⟼',
  '\nearrow' => '↗',
  '\hookleftarrow' => '↩',
  '\hookrightarrow' => '↪',
  '\searrow' => '↘',
  '\leftharpoonup' => '↼',
  '\rightharpoonup' => '⇀',
  '\swarrow' => '↙',
  '\leftharpoondown' => '↽',
  '\rightharpoondown' => '⇁',
  '\nwarrow' => '↖',
  '\rightleftharpoons' => '⇌',
  '\leadsto' => '↝',
);

my @keys = sort { length($a) <=> length($b)
  or
$a cmp $b
} keys %commands;

my $pat = join '|', map quotemeta, reverse @keys;
my $regex = qr/$pat/;

sub format_string {
  my $string = shift;

  $string =~ s/($regex)/$commands{$1}/go;
  return $string;
}