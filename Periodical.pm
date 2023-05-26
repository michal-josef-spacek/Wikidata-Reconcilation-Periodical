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
			'P31/P279*' => 'Q1002697',
			$external_property_key => $reconcilation_rules_hr->{'external_identifiers'}->{$external_property_key},
		});
	}

	# Name, start time and end time of periodical.
	if (exists $reconcilation_rules_hr->{'identifiers'}->{'name'}
		&& exists $reconcilation_rules_hr->{'identifiers'}->{'start_time'}
		&& exists $reconcilation_rules_hr->{'identifiers'}->{'end_time'}) {

		my $start_time = $reconcilation_rules_hr->{'identifiers'}->{'start_time'};
		my $end_time = $reconcilation_rules_hr->{'identifiers'}->{'end_time'};
		push @sparql, WQS::SPARQL::Query::Select->new->select_value({
			'P31/P279*' => 'Q1002697',
			'P1476' => $reconcilation_rules_hr->{'identifiers'}->{'name'}.'@'.$self->{'language'},
			'P580' => '?start_time',
			'P582' => '?end_time',
		}, [
			['?start_time', '=', '"'.$start_time.'-00-00T00:00:00"^^xsd:dateTime'],
			['?end_time', '=', '"'.$end_time.'-00-00T00:00:00"^^xsd:dateTime'],
		]);
	}

	# Name and year of publication.
	if (exists $reconcilation_rules_hr->{'identifiers'}->{'name'}
		&& exists $reconcilation_rules_hr->{'identifiers'}->{'year'}) {

		my $year = $reconcilation_rules_hr->{'identifiers'}->{'year'};
		push @sparql, WQS::SPARQL::Query::Select->new->select_value({
			'P31/P279*' => 'Q1002697',
			'P1476' => $reconcilation_rules_hr->{'identifiers'}->{'name'}.'@'.$self->{'language'},
			'P580' => '?start_time',
			'P582' => '?end_time',
		}, [
			['?start_time', '<=', '"'.$year.'-31-12T00:00:00"^^xsd:dateTime'],
			['?end_time', '>=', '"'.$year.'-01-01T00:00:00"^^xsd:dateTime'],
		]);
	}

	# Name.
	if (exists $reconcilation_rules_hr->{'identifiers'}->{'name'}) {
		push @sparql, WQS::SPARQL::Query::Select->new->select_value({
			'P31/P279' => 'Q1002697',
			'P1476' => $reconcilation_rules_hr->{'identifiers'}->{'name'}.'@'.$self->{'language'},
		});
	}

	# Start and end time.
	if (exists $reconcilation_rules_hr->{'identifiers'}->{'start_time'}
		&& exists $reconcilation_rules_hr->{'identifiers'}->{'end_time'}) {

		push @sparql, WQS::SPARQL::Query::Select->new->select_value({
			'P31/P279*' => 'Q1002697',
			'P580' => '?start_time',
			'P582' => '?end_time',
		}, [
			['YEAR(?start_time)', '=', $reconcilation_rules_hr->{'identifiers'}->{'start_time'}],
			['YEAR(?end_time)', '=', $reconcilation_rules_hr->{'identifiers'}->{'end_time'}],
		]);
	} elsif (exists $reconcilation_rules_hr->{'identifiers'}->{'start_time'}) {
		push @sparql, WQS::SPARQL::Query::Select->new->select_value({
			'P31/P279*' => 'Q1002697',
			'P580' => '?start_time',
		}, [
			['YEAR(?start_time)', '=', $reconcilation_rules_hr->{'identifiers'}->{'start_time'}],
		]);
	} elsif (exists $reconcilation_rules_hr->{'identifiers'}->{'end_time'}) {
		push @sparql, WQS::SPARQL::Query::Select->new->select_value({
			'P31/P279*' => 'Q1002697',
			'P582' => '?end_time',
		}, [
			['YEAR(?end_time)', '=', $reconcilation_rules_hr->{'identifiers'}->{'end_time'}],
		]);
	}

	return @sparql;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

Wikidata::Reconcilation::Periodical - Abstract class for Wikidata reconcilations.

=head1 SYNOPSIS

 use Wikidata::Reconcilation::Periodical;

 my $obj = Wikidata::Reconcilation::Periodical->new;
 my @qids = $obj->reconcile($reconcilation_rules_hr);

=head1 DESCRIPTION

Class for Wikidata periodical reconcilation.

=head1 METHODS

=head2 C<new>

 my $obj = Wikidata::Reconcilation::Periodical->new;

Constructor.

Returns instance of object.

=head2 C<reconcile>

 my @qids = $obj->reconcile($reconcilation_rules_hr);

Reconcile information defined in input structure and returns list of QIDs.

TODO Structure

Returns list of strings.

=head1 ERRORS

 new():
         From Class::Utils::set_params():
                 Unknown parameter '%s'.
         Parameter 'lwp_user_agent' must be a 'LWP::UserAgent' instance.

 reconcile():
         This is abstract class. You need to implement _reconcile() method.


=head1 EXAMPLE1

=for comment filename=reconcile_periodical.pl

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

=head1 EXAMPLE2

=for comment filename=reconcile_periodical_verbose.pl

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

=head1 DEPENDENCIES

L<Wikidata::Reconcilation>.
L<WQS::SPARQL::Query::Select>.

=head1 SEE ALSO

=over

=item L<Wikidata::Reconcilation>

Abstract class for Wikidata reconcilations.

=back

=head1 REPOSITORY

L<https://github.com/michal-josef-spacek/Wikibase-Reconcilation-Periodical>

=head1 AUTHOR

Michal Josef Špaček L<mailto:skim@cpan.org>

L<http://skim.cz>

=head1 LICENSE AND COPYRIGHT

© 2023 Michal Josef Špaček

BSD 2-Clause License

=head1 VERSION

0.01

=cut
