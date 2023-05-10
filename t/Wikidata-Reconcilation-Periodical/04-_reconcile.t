use strict;
use warnings;

use Test::More 'tests' => 4;
use Test::NoWarnings;
use Wikidata::Reconcilation::Periodical;

# Test.
my $obj = Wikidata::Reconcilation::Periodical->new;
my @ret = $obj->_reconcile;
is_deeply(
	\@ret,
	[],
	'No results.',
);

# Test.
$obj = Wikidata::Reconcilation::Periodical->new;
@ret = $obj->_reconcile({
	'external_identifiers' => {
		# ISSN
		'P236' => '1212-026X',
	},
});
my $right_ret =<<'END';
SELECT ?item WHERE {
  ?item wdt:P31/wdt:P279 wd:Q1002697.
  ?item wdt:P236 '1212-026X'.
}
END
is($ret[0], $right_ret, 'SPARQL query for ISSN.');
is(scalar @ret, 1, 'One SPARQL query.');
