# Lingua::EN::Gender.pm
#
# $Id: Gender.pm,v 1.1.1.1 2003/08/22 21:37:30 eekim Exp $
#
# Copyright (c) Blue Oxen Associates 2003.  All rights reserved.
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself. 

package Lingua::EN::Gender;

use 5.006001;
use strict;
use warnings;
use vars qw($VERSION);

### variables

$VERSION = '1.0';

my %scoreTable = (
    the => 17,
    a => 6,
    some => 6,
    it => 2,
    with => -14,
    for => -4,
    not => -4,
    # possessive pronouns
    mine => -3,
    yours => -3,
    his => -3,
    hers => -3,
    its => -3,
    ours => -3
);

my %numbers = (
    'one' => 1,
    'two' => 1,
    'three' => 1,
    'four' => 1,
    'five' => 1,
    'six' => 1,
    'seven' => 1,
    'eight' => 1,
    'nine' => 1,
    'ten' => 1,
    'eleven' => 1,
    'twelve' => 1,
    'thirteen' => 1,
    'fourteen' => 1,
    'fifteen' => 1,
    'sixteen' => 1,
    'seventeen' => 1,
    'eighteen' => 1,
    'nineteen' => 1,
    'twenty' => 1,
    'thirty' => 1,
    'forty' => 1,
    'fourty' => 1,  # british spelling
    'fifty' => 1,
    'sixty' => 1,
    'seventy' => 1,
    'eighty' => 1,
    'ninety' => 1,
    'hundred' => 1,
    'thousand' => 1,
    'million' => 1,
    'billion' => 1,
    'trillion' => 1
);

### methods

sub new {
    my ($this, $text) = @_;
    my $self = {
        text => $text,
        words => &_getWords($text),
        score => undef
    };
    bless $self, $this;
    return $self;
}

sub text {
    my ($this, $text) = @_;

    if ($text) {
        $this->{text} = $text;
        $this->{words} = &_getWords($text);
        $this->{score} = undef;
    }
    return $this->{text};
}

sub words {
    my $this = shift;

    return @{$this->{words}};
}

sub numWords {
    my $this = shift;

    return scalar @{$this->{words}};
}

sub score {
    my $this = shift;

    if (defined $this->{score}) {
        return $this->{score};
    }
    else {
        my $score = 0;
        my $prevWasNumber = 0;
        foreach my $word (@{$this->{words}}) {
            if (&_number($word)) {
                if (!$prevWasNumber) {
                    $score += 5;
                    $prevWasNumber = 1;
                }
            }
            elsif (&_possessive($word)) {
                $score += -5;
                $prevWasNumber = 0;
            }
            elsif (&_negativeContraction($word)) {
                $score += -4;
                $prevWasNumber = 0;
            }
            else {
                $score += $scoreTable{$word} if ($scoreTable{$word});
                $prevWasNumber = 0;
            }
        }
        $this->{score} = $score;
        return $score;
    }
}

sub gender {
    my $this = shift;

    my $numWords = $this->numWords;
    my $score = $this->score;
    if ($score > $numWords) {
        return 'male';
    }
    elsif ($score < $numWords) {
        return 'female';
    }
    else {
        return 'androgynous';
    }
}

### private

sub _getWords {
    my $text = lc(shift);

    # convert compound words into separate words
    $text =~ s/\-+/ /gs;
    $text =~ s/\// /gs;
    # get rid of non-word characters
    $text =~ s/[^\w\s\']//gs;
    $text =~ s/^\'//gs;
    $text =~ s/\'$//gs;

    my @words = split(/\s+/, $text);
    return \@words;
}

sub _number {
    my $word = shift;

#    $word =~ s/[\.,]//g;
    if ($word =~ /^\d+$/) {
        return 1;
    }
    elsif ($numbers{$word}) {
        return 1;
    }
    else {
        return 0;
    }
}

sub _possessive {
    my $word = shift;

    if ($word eq "it's") {
        return 0;
    }
    elsif ($word =~ /\'s$/) {
        return 1;
    }
    else {
        return 0;
    }
}

sub _negativeContraction {
    my $word = shift;

    if ($word =~ /n\'t$/) {
        return 1;
    }
    else {
        return 0;
    }
}

1;
__END__

=head1 NAME

Lingua::EN::Gender - Guesses author's gender by analyzing text.

=head1 SYNOPSIS

  use Lingua::EN::Gender;

  my $text = "These are the days that try men's souls.";

  my $lingua = Lingua::EN::Gender->new($text);
  print $lingua->gender . "\n";  # male

=head1 ABSTRACT

  Lingua::EN::Gender guesses an author's gender by analyzing text
  using the Koppel-Argamon algorithm.

=head1 DESCRIPTION

This Perl module implements the Koppel-Argamon algorithm for guessing
an author's gender.  The algorithm was invented by Moshe Koppel
(Bar-Ilan University, Israel) and Shlomo Argamon (Illinois Institute
of Technology), and is described at:

  http://www.nytimes.com/2003/08/10/magazine/10wwln-test.html

=head2 ALGORITHM

Count the number of words in the document.

For each appearance of the following words, add the points indicated:

  "the"                    17
  "a"                       6
  "some"                    6
  number                    5
  "it"                      2
  "with"                  -14

  possessives,
    ending in "'s"         -5
    pronouns               -3

  "for"                    -4
  "not"                    -4
  word ending with "n't"    4

If the total score is greater than the total number of words, the
author is probably a male.  Otherwise, the author is probably a
female.

=head2 IMPLEMENTATION

The algorithm is fairly straightforward, although there are a few
twists and turns.  My implementation does the following:

  * Counts hyphenated words as two words.

  * Knows that "it's" is not a possessive pronoun.

  * Recognizes the British spelling of "fourty."

The biggest complication with my implementation is in how it handles
numbers.  If a number is preceded by another number, it only scores it
as a single number, even though it's counted as two words.  For
example:

  one hundred

is counted as one number (with a score of 5) and two words.  My
implementation does not handle the following situation correctly:

  First one.  Two next.

It would count this as one number (score 5) and four words, even
though it should be two numbers (score 10) and four words.  It
wouldn't be that difficult to handle these types of situations, but I
was lazy, and I don't think it will make much of a difference.  Maybe
in the next version.

=head1 SEE ALSO

McGrath, Charles.  "Sexed Texts."  I<New York Times Magazine>, August
10, 2003.  http://www.nytimes.com/2003/08/10/magazine/10WWLN.html

Ball, Philip.  "Computer program detects author gender."  I<Nature>,
July 18, 2003.  http://www.nature.com/nsu/030714/030714-13.html

I first discovered this work at:

  http://www.bookblog.net/gender/genie.html

=head1 AUTHOR

Eugene Eric Kim, E<lt>eekim@blueoxen.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) Blue Oxen Associates 2003.  All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
