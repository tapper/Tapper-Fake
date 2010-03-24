#! /usr/bin/env perl

use strict;
use warnings;

# get rid of warnings
use Class::C3;
use MRO::Compat;

use Test::More;

my @modules = ('Artemis::Fake', 
               'Artemis::Fake::Child',
               'Artemis::Fake::Master',
              );



plan tests => $#modules+1;

=pod

Using eval makes a bareword out of the $module string which is expected for
module handling. Some modules don't expect any parameter for new. They simply
ignore the 'testrun => 4'. Thus we don't need to separate both kinds of
modules.

=cut

foreach my $module(@modules) {
        my $obj;
        eval "require $module";
        $obj = eval "$module->new()";
        isa_ok($obj, $module);
        print $@ if $@;
}

diag( "Testing Artemis $Artemis::Fake::VERSION,Perl $], $^X" );
