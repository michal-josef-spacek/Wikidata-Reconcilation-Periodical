#!/usr/bin/env perl

use strict;
use warnings;

use Unicode::UTF8 qw(decode_utf8);
use Wikidata::Reconcilation::Periodical;

# Object.
my $obj = Wikidata::Reconcilation::Periodical->new(
        'language' => 'cs',
);

# Save cached value.
my @qids = $obj->reconcile({
        'identifiers' => {
                'name' => decode_utf8('Česká osvěta'),
                'start_time' => 1904,
                'end_time' => '1948',
        },
});

# Print out.
print join "\n", @qids;
print "\n";

# Output like:
# Q118719850