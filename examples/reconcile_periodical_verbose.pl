#!/usr/bin/env perl

use strict;
use warnings;

use Unicode::UTF8 qw(decode_utf8);
use Wikidata::Reconcilation::Periodical;

# Object.
my $obj = Wikidata::Reconcilation::Periodical->new(
        'language' => 'cs',
        'verbose' => 1,
);

# Save cached value.
my @qids = $obj->reconcile({
        'identifiers' => {
                'name' => decode_utf8('Česká osvěta'),
                'start_time' => 1904,
                'end_time' => '1948',
        },
});

# Output like:
# SPARQL queries:
# SELECT ?item WHERE {
#   ?item wdt:P31/wdt:P279* wd:Q1002697.
#   ?item wdt:P580 ?start_time.
#   ?item wdt:P582 ?end_time.
#   ?item wdt:P1476 'Česká osvěta'@cs.
#   FILTER(?start_time = "1904-00-00T00:00:00"^^xsd:dateTime)
#   FILTER(?end_time = "1948-00-00T00:00:00"^^xsd:dateTime)
# }
# 
# SELECT ?item WHERE {
#   ?item wdt:P31/wdt:P279 wd:Q1002697.
#   ?item wdt:P1476 'Česká osvěta'@cs.
# }
# 
# SELECT ?item WHERE {
#   ?item wdt:P31/wdt:P279* wd:Q1002697.
#   ?item wdt:P580 ?start_time.
#   ?item wdt:P582 ?end_time.
#   FILTER(YEAR(?start_time) = 1904)
#   FILTER(YEAR(?end_time) = 1948)
# }
# 
# Results:
# - Q118719850: 2