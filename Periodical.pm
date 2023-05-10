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

	# Name and year of publication.
	if (exists $reconcilation_rules_hr->{'identifiers'}->{'name'}
		&& exists $reconcilation_rules_hr->{'identifiers'}->{'year'}) {

		my $year = $reconcilation_rules_hr->{'identifiers'}->{'year'};
		push @sparql, WQS::SPARQL::Query::Select->new->select_value({
			'P31/P279' => 'Q1002697',
			'P1476' => $reconcilation_rules_hr->{'identifiers'}->{'name'},
			'P580' => '?start_time',
			'P582' => '?end_time',
		}, [
			['?start_time', '<=', '"'.$year.'-31-12T00:00:00"^^xsd:dateTime'],
			['?end_time', '>=', '"'.$year.'-01-01T00:00:00"^^xsd:dateTime'],
		]);

	# Name.
	} elsif (exists $reconcilation_rules_hr->{'identifiers'}->{'name'}) {
		push @sparql, WQS::SPARQL::Query::Select->new->select_value({
			'P31/P279' => 'Q1002697',
			'P1476' => $reconcilation_rules_hr->{'identifiers'}->{'name'},
		});
	}

	return @sparql;
}

1;

__END__
