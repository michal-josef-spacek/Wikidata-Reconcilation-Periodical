package Wikidata::Reconcilation::Periodical;

use base qw(Wikidata::Reconcilation);
use strict;
use warnings;

use WQS::SPARQL::Query::Select;

our $VERSION = 0.01;

sub _reconcile {
	my ($self, $reconcilation_rules_hr) = @_;

	my @sparql = ();

	# Reconcilation over external references.
	foreach my $external_property_key (keys %{$reconcilation_rules_hr->{'external_identifiers'}}) {
		push @sparql, WQS::SPARQL::Query::Select->new->select_value({
			'P31/P279' => 'Q1002697',
			$external_property_key => $reconcilation_rules_hr->{'external_identifiers'}->{$external_property_key},
		});
	}

	# TODO Other reconncilations like author and name and year if exist

	return @sparql;
}

1;

__END__
