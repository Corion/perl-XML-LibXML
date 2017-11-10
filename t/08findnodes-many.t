use strict;
use warnings;

# Should be 45.
use Test::More tests => 1;
use Time::HiRes 'time';

use XML::LibXML;

# to test if findnodes works.
# i added findnodes to the node class, so a query can be started
# everywhere.

# Construct a laaarge XML with 400k+ records
my $xml    = join "\n", <<'XML',(map {;"<row><value>$_</value><some_other>value</some_other><third/></row>"} 1..400_000),<<'XML';
<?xml version="1.0"?>
<report010>
<header>
</header>
XML
</report010>
XML

# init the file parser
my $parser = XML::LibXML->new();
my $dom    = $parser->load_xml( string => $xml );

if ( defined $dom ) {
    # get the root document
    my $elem   = $dom->getDocumentElement();

    my $start = time();
    # first very simple path starting at root
    my @list   = $elem->findnodes( "//row[some_other]" );
    my $taken = time() - $start;
    is @list, 400_000, "We can retrieve 5mm nodes in good time";
    diag $taken;
}

