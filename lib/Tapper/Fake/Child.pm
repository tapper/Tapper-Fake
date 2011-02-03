package Tapper::Fake::Child;

use Moose;

use common::sense;
use Tapper::Model 'model';



=head1 NAME

Tapper::Fake::Child - Fake Tapper::MCP::Child for testing

=head1 SYNOPSIS

 use Tapper::Fake::Child;
 my $client = Tapper::Fake::Child->new($testrun_id);
 $child->runtest_handling($system);



=head1 FUNCTIONS

=cut 

has testrun  => (is => 'rw');


sub BUILDARGS {
        my $class = shift;
        
        if ( @_ >= 1 and not ref $_[0] ) {
                return { testrun => $_[0] };
  }
        else {
                return $class->SUPER::BUILDARGS(@_);
        }
}



=head2 runtest_handling

Start testrun and wait for completion.

@param string - system name

@return success - 0
@return error   - error string

=cut

sub runtest_handling
{

        my  ($self, $hostname) = @_;

        my $search = model('TestrunDB')->resultset('Testrun')->find($self->{testrun});
        foreach my $precondition ($search->ordered_preconditions) {
                if ($precondition->precondition_as_hash->{precondition_type} eq 'testprogram' ) {
                        sleep $precondition->precondition_as_hash->{timeout};
                }
        }
        return 0;

}

1;

=head1 AUTHOR

OSRC SysInt Team, C<< <osrc-sysint at elbe.amd.com> >>

=head1 BUGS

None.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

 perldoc Tapper


=head1 ACKNOWLEDGEMENTS


=head1 COPYRIGHT & LICENSE

Copyright 2008 OSRC SysInt Team, all rights reserved.

This program is released under the following license: restrictive

