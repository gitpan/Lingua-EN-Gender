#!/usr/bin/perl
#
# gender.pl
#
# $Id: gender.pl,v 1.1.1.1 2003/08/22 21:37:30 eekim Exp $
#
# Copyright (c) Blue Oxen Associates 2003.  All rights reserved.
#
# This library is free software; you can redistribute it and/or modify
# it under the same terms as Perl itself. 

use IO::File;
use Lingua::EN::Gender;
use strict;
use warnings;

my $numFiles = scalar @ARGV;
my $lingua = Lingua::EN::Gender->new;
undef $/;
while (<>) {
    $lingua->text($_);
    print "$ARGV:\t" if ($numFiles > 1);
    print $lingua->gender . "\t";
    print $lingua->score . "\t";
    print $lingua->numWords . "\n";
}

__END__

=head1 NAME

gender.pl - Determines author's gender by analyzing text.

=head1 SYNOPSIS

  gender.pl file1.txt [file2.txt ...]

  gender.pl < file.txt

  cat file.txt | gender.pl

=head1 DESCRIPTION

Uses the Koppel-Argamon algorithm (implemented in Lingua::EN::Gender)
for determining the gender of a text's author.

Returns the gender, score, and number of words in tab-delimited form.

=head1 SEE ALSO

L<Lingua::EN::Gender>

=head1 AUTHOR

Eugene Eric Kim, E<lt>eekim@blueoxen.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (c) Blue Oxen Associates 2003.  All rights reserved.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself. 

=cut
