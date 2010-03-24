package Artemis::Fake;

use warnings;
use strict;

our $VERSION = '2.000001';



use Artemis::Config;
use Artemis::Exception;
use Moose;

extends 'Artemis::Base';

sub cfg
{
        my ($self) = @_;
        return Artemis::Config->subconfig();
}

=head1 NAME

Artemis::Fake - Fake Artemis::MCP for testing

=head1 SYNOPSIS

 use Artemis::Fake;

=cut

1;

=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>

=head1 BUGS

None.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Artemis::Fake

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

=cut
 
1; # End of Artemis::Fake
