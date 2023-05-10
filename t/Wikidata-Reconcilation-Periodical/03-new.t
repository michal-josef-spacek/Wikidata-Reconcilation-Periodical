use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Reconcilation::Periodical;

# Test.
my $obj = Wikidata::Reconcilation::Periodical->new;
isa_ok($obj, 'Wikidata::Reconcilation::Periodical');
