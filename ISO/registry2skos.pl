#!/usr/bin/perl

=head1 NAME

registry2skos.pl - Convert IANA Language Subtag Registry to SKOS

=head1 SYNOPSIS

1. download the registry
  wget http://www.iana.org/assignments/language-subtag-registry

2. clean lines
  awk 'NR<3{next} /^[^ ]/{print L; L=$0} /^ /{L=L$0} END {print L}' language-subtag-registry > registry

3. convert by running this script.
To output in a file : perl registry2skos > output.xml

=head1 AUTHOR

Jakob Voss 

=head1 VERSION

0.1a - first draft and proof of concept

=cut

# General settings
my $VERSION = "0.1";

# Print header
print <<END;
<?xml version='1.0' encoding='ISO-8859-1'?>
<rdf:RDF xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:skos="http://www.w3.org/2004/02/skos/core#"
         xmlns:dc="http://purl.org/dc/elements/1.1/">
END

# Parse registry
my %fields = ();

open REG, "registry" or die("no registry found!");
while (<REG>) {
  chomp;
  if ($_ =~ /^([A-Za-z-]+): (.*)$/) {
    if (defined $fields{$1}) { # multiple values
       if (ref $fields{$1} eq "ARRAY") {
           push (@{ $fields{$1}, $2 });
       } else {
          $fields{$1} = [$fields{$1}, $2];
       }
    } else { # single value
      $fields{$1} = $2;
    }
  } else {
    transform_code();
    %fields = ();
  }
}

# Print footer
print "</rdf:RDF>\n";



# actual transforming
sub transform_code {
  my $xml = "";

  my $description = $fields{"Description"};
  if (ref($description) eq "ARRAY") {
    foreach my $d (@{$description}) {
      $xml .= "  <skos:altLabel>$d</skos:altLabel>\n";
    }
  } else {
      $xml .= "  <skos:altLabel>$description</skos:altLabel>\n";
  }
  if ($fields{"Comment"}) {
    $xml .= "  <skos:publicNote>" . $fields{"Comment"} . "</skos:publicNote>\n";
  }
  if ($fields{"Added"}) {
    $xml .= "  <dc:date>" . $fields{"Added"} . "</dc:date>\n";
  }

  if ($fields{Type} eq "language") {
    if ($field{"Preferred-Value"} or $field{"Deprecated"} ) {
      # TODO: deprecated codes not implemented yet
    } else {
      my $subtag = $fields{"Subtag"};
      $xml = "<skos:Concept rdf:about='#$subtag'>\n" .
             "  <skos:prefLabel>$subtag</skos:prefLabel>\n" . # TODO: skos:notation
             $xml;

      if ($fields{"Suppress-Script"}) {
        # TODO: add an additional code and create an skos:exactMatch
      }
      $xml .= "</skos:Concept>\n";
      print $xml;
    }
  } elsif ($fields{Type} eq "redundant") {
    my $tag = $fields{"Tag"};
    $xml = "<skos:Concept rdf:about='#$tag'>\n" .
           "  <skos:prefLabel>$tag</skos:prefLabel>\n" . # TODO: skos:notation
           $xml;
    my $lang = $tag; 
    $lang =~ s/-.*$//;
    $xml .= "  <skos:broader rdf:resource='#$lang'/>\n"; # TODO: link to script if region specified
    $xml .= "</skos:Concept>\n";
    print $xml;
  } else {
    # TODO: Type grandfathered,region,script,variant
    foreach $k (keys %fields) {
      #print "$k: " . $fields{$k} . "\n";
    }
  }
}

__END__
