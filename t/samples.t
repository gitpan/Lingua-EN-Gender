# number.t

use strict;
use Test;

BEGIN { plan tests => 3 };

use IO::File;
use Lingua::EN::Gender;

sub readFile {
    my $fileName = shift;
    my $fileContent;

    my $fh = new IO::File $fileName;
    if (defined $fh) {
        local ($/);
        $fileContent = <$fh>;
        $fh->close;
        return $fileContent;
    }
    else {
        return;
    }
}

#########################
 
# sample1.txt

my $lingua = Lingua::EN::Gender->new(&readFile('t/sample1.txt'));
ok($lingua->numWords == 33);
ok($lingua->score == -7);
ok($lingua->gender eq 'female');
