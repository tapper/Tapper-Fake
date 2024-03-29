package Tapper::Fake;
# ABSTRACT: Tapper - Fake modules for testing the automation layer

use strict;
use warnings;

use Tapper::Config;
use Moose;

extends 'Tapper::Base';

=head2 cfg

Returns the Tapper config.

=cut

sub cfg
{
        my ($self) = @_;
        return Tapper::Config->subconfig();
}

1;
