package Artemis::Fake::Child;

use Moose;

use common::sense;



=head1 NAME

Artemis::Fake::Child - Fake Artemis::MCP::Child for testing

=head1 SYNOPSIS

 use Artemis::Fake::Child;
 my $client = Artemis::Fake::Child->new($testrun_id);
 $child->runtest_handling($system);


=head1 FUNCTIONS


=head2 runtest_handling

Start testrun and wait for completion.

@param string - system name

@return success - 0
@return error   - error string

=cut

sub runtest_handling
{

        my  ($self, $hostname) = @_;
        my $retval;
        sleep 1;
        return $retval if $retval;
        return 0;

}

1;

=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>

=head1 BUGS

None.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Artemis


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

