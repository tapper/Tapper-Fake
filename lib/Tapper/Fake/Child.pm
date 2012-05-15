package Tapper::Fake::Child;
# ABSTRACT: Fake Tapper::MCP::Child for testing

use Moose;
use common::sense;
use Tapper::Model 'model';

has testrun  => (is => 'rw');

=head1 SYNOPSIS

 use Tapper::Fake::Child;
 my $client = Tapper::Fake::Child->new($testrun_id);
 $child->runtest_handling($system);

sub BUILDARGS {
        my $class = shift;
        
        if ( @_ >= 1 and not ref $_[0] ) {
                return { testrun => $_[0] };
        }
        else {
                return $class->SUPER::BUILDARGS(@_);
        }
}

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

        my $search = model('TestrunDB')->resultset('Testrun')->find($self->{testrun});
        foreach my $precondition ($search->ordered_preconditions) {
                if ($precondition->precondition_as_hash->{precondition_type} eq 'testprogram' ) {
                        sleep $precondition->precondition_as_hash->{timeout};
                }
        }
        return 0;

}

1;
