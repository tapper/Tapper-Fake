use MooseX::Declare;




class Artemis::Fake::Master extends Artemis::Fake
{
        use Devel::Backtrace;
        use POSIX ":sys_wait_h";
        use UNIVERSAL;


        use Artemis::Fake::Child;
        use Artemis::MCP::Scheduler::Controller;
        use Artemis::Model 'model';


=head1 NAME

Artemis::Fake::Master - Fake Artemis::MCP::Master for testing purpose

=head1 SYNOPSIS

 use Artemis::Fake::Master;
 my $mcp = Artemis::Fake::Master->new();
 $mcp->run();

=head1 Attributes


=head2 hosts

List of hosts this MCP may use.

=cut

        has hosts   => (is => 'rw', isa => 'ArrayRef', default => sub {[]});


=head2 dead_child

Number of pending dead child processes.

=cut

        has dead_child   => (is => 'rw', default => 0);

=head2 child

Contains all information about all child processes.

=cut

        has child        => (is => 'rw', isa => 'HashRef', default => sub {{}});

=head2

Associated Scheduler object.

=cut

        has scheduler    => (is => 'rw', isa => 'Artemis::MCP::Scheduler::Controller');

=head1 FUNCTIONS

=cut 

sub BUILD
{
        my $self = shift;
        $self->scheduler(Artemis::MCP::Scheduler::Controller->new());
}


=head2 set_interrupt_handlers

Set interrupt handlers for important signals. No parameters, no return values.

@return success - 0

=cut

        sub set_interrupt_handlers
        {
                my ($self) = @_;
                $SIG{CHLD} = sub {
                        $self->dead_child($self->dead_child + 1);
                };

                # give me a stack trace when ^C
                $SIG{INT} = sub {
                        $SIG{INT}='ignore'; # not reentrant, don't handle signal twice
                        my $backtrace = Devel::Backtrace->new(-start=>2, -format => '%I. %s');

                        print $backtrace;

                        exit -1;
                };
                return 0;
        }


=head2 handle_dead_children

Each test run is handled by a child process. All information needed for
communication with this child process is kept in $self->child. Reset all these
information when the test run is finished and the child process ends.

=cut

        sub handle_dead_children
        {
                my ($self) = @_;
        CHILD: while ($self->dead_child) {
                        $self->log->debug("Number of dead children is ".$self->dead_child);
                        my $dead_pid = waitpid(-1, WNOHANG);  # don't use wait(); qx() sends a SIGCHLD and increases $self->deadchild, but wait() for the return value and thus our wait would block
                        if ($dead_pid <= 0) { # got here because of qx()
                                $self->dead_child($self->dead_child - 1);
                                next CHILD;
                        }
                CHILDREN_CHECK: foreach my $this_child (keys %{$self->child})
                        {
                                if ($self->child->{$this_child}->{pid} == $dead_pid) {
                                        $self->log->debug("$this_child finished");
                                        $self->scheduler->mark_job_as_finished( $self->child->{$this_child}->{job} );
                                        delete $self->child->{$this_child};
                                        $self->dead_child($self->dead_child - 1);
                                        last CHILDREN_CHECK;
                                }
                        }
                }
        }



=head2 run_due_tests

Run the tests that are due.

@param hash - containing test run ids accessible through host names

@retval success - 0
@retval error   - error string

=cut

        sub run_due_tests
        {
                my ($self, $job) = @_;

                my $system = $job->host->name;
                my $id     = $job->testrun->id;
                my $queue  = $job->queue->name;
                my $msg    = "start testrun $id, queue $queue on $system";
                $msg      .= "; testrun name: ".$job->testrun->shortname if $job->testrun->shortname;

                $self->log->error($msg);
                # check if this system is already active, just for error handling
                $self->handle_dead_children() if $self->child->{$system};

                $self->scheduler->mark_job_as_running($job);

                my $pid = fork();
                die "fork failed: $!" if (not defined $pid);
                
                # hello child
                if ($pid == 0) {

                        my $child = Artemis::Fake::Child->new( $id );
                        my $retval = $child->runtest_handling( $system );
                        if ($retval) {
                                $self->log->error("An error occured while trying to run testrun $id on $system: $retval");
                        } else {
                                $self->log->info("Runtest $id finished successfully");
                        }
                        exit 0;
                } else {
                        $self->child->{$system}->{pid}      = $pid;
                        $self->child->{$system}->{test_run} = $id;
                        $self->child->{$system}->{job}      = $job;
                }
                return 0;

        }


=head2 runloop

Main loop of this module. Checks for new tests and runs them. The looping
itself is put outside of function to allow testing.

=cut

        sub runloop
        {
                my ($self, $lastrun) = @_;
                my $timeout          = $lastrun + $self->cfg->{times}{poll_intervall} - time();

                sleep $timeout;
                $self->handle_dead_children() if $self->dead_child;

                while ( my @jobs = $self->scheduler->get_next_job() ) {
                        foreach my $job (@jobs) {
                                $self->run_due_tests($job);
                        }
                }
        }


=head2 prepare_server

Create communication data structures used in MCP.

@return

=cut

        sub prepare_server
        {
                my ($self) = @_;
                # these sets are used by select()

                my $allhosts = model('HardwareDB')->resultset('Systems')->search({active => 1, current_owner => {like => '%artemis%'}});
                while (my $thishost = $allhosts->next) {
                        push(@{$self->hosts}, $thishost->systemname);
                }

                return 0;
        }


=head2 run

Set up all needed data structures then wait for new tests.

=cut

        sub run
        {
                my ($self) = @_;
                $self->set_interrupt_handlers();
                $self->prepare_server();
                $self->log->debug('starting run');
                while (1) {
                        my $lastrun = time();
                        $self->runloop($lastrun);
                }

        }
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

