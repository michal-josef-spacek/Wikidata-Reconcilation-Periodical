use strict;
use warnings;

use Test::More 'tests' => 2;
use Test::NoWarnings;
use Wikidata::Reconcilation::Periodical;

# Test.
is($Wikidata::Reconcilation::Periodical::VERSION, 0.01, 'Version.');
