package Lingua::EN::Gender;
#
# Does nifty things with inflecting pronouns for gender
#
# Last updated by gossamer on Thu Jul 16 19:33:23 EST 1998
#

use strict;
use vars qw($VERSION @ISA @EXPORT @EXPORT_OK @genders %pronoun);

require Exporter;

@ISA = qw(Exporter);
@EXPORT = qw( pronoun genders );
@EXPORT_OK = qw();
$VERSION = "0.01";

=head1 NAME

Lingua::EN::Gender - Inflect pronouns for gender

=head1 SYNOPSIS

   use Lingua::EN::Gender;

   XXX example here

=head1 DESCRIPTION


=cut

###################################################################
# Some constants                                                  #
###################################################################

@genders = ["neuter", "male", "female", "either", "spivak", "splat", "plural", "egotistical", "royal", "2nd", "sie/hir", "zie/zir"];

$pronoun{"subjective"} = ["it", "he", "she", "s/he", "e", "*e", "they", "I", "we", "you", "sie", "zie"];
$pronoun{"objective"} = ["it", "him", "her", "him/her", "em", "h*", "them", "me", "us", "you", "hir", "zir"];
$pronoun{"posessive-subjective"} = ["its", "his", "her", "his/her", "eir", "h*", "their", "my", "our", "your", "hirs", "har", "zir"];
$pronoun{"posessive-objective"} = ["its", "his", "hers", "his/hers", "eirs", "h*s", "theirs", "mine", "ours", "yours", "hars", "zirs"];
$pronoun{"reflexive"} = ["itself", "himself", "herself", "(him/herself", "emself", "h*self", "themselves", "myself", "ourselves", "yourself", "hirself", "zirself"];



sub pronoun {
   my $pro_type = shift;
   my $pro_gender = shift;

   return $pronoun{$pro_type};

}

sub genders {

   return join(" ", @genders);

}

#
# End.
#
1;
