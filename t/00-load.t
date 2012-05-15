#! /usr/bin/env perl

use strict;
use warnings;


# get rid of warnings
use Class::C3;
use MRO::Compat;

use Test::More;

my @modules = ('Tapper::Fake', 
               'Tapper::Fake::Child',
               'Tapper::Fake::Master',
              );

plan tests => $#modules+1;

foreach my $module(@modules) {
        require_ok($module);
}
