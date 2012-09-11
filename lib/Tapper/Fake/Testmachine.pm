package Tapper::Fake::Testmachine;

use warnings;
use strict;
use 5.010;
use autodie;

use Moose;
use YAML::Syck;

use Tapper::Config;
use Tapper::Model 'model';

extends 'Tapper::Base';

=head2 cfg

Returns the Tapper config.

=cut

sub cfg
{
        my ($self) = @_;
        return Tapper::Config->subconfig();
}

=head1 NAME

Tapper::Fake::Testmachine - Fake a testmachine to test Tapper MCP.


use Tapper::Fake::Testmachine;
my $fake = Tapper::Fake::Testmachine->new();
$fake->run({hostname => $hostname});


=head1 SYNOPSIS

 use Tapper::Fake::Testmachine;

=cut

=head2 run

Run the fake testmachine.

=cut

sub run
{
        my ($self, $options) = @_;
        my $pid = fork();
        die "Can not fork" unless defined $pid;
        if ($pid != 0) {
                return;
        }
        close (STDOUT);
        close (STDERR);
        sleep 1; # give MCP time to settle

        my $hostname = $options->{hostname};
        my $config_file = $self->cfg->{paths}{localdata_path}."$hostname-install";
        my $config;
        if (-e $config_file) {
                $config = YAML::Syck::LoadFile($config_file);
        } else {
                die "$config_file does not exist.";
        }
        my $testrun_id = $config->{test_run};
        my $message = model('TestrunDB')->resultset('Message')->new({testrun_id => $testrun_id,
                                                                     message    => {state => 'start-install'}})->insert;
        $message = model('TestrunDB')->resultset('Message')->new({testrun_id => $testrun_id,
                                                                  message    => {state => 'end-install'}})->insert;
        $message = model('TestrunDB')->resultset('Message')->new({testrun_id => $testrun_id,
                                                                  message    => {state => 'start-testing',
                                                                                 prc_number => 0,
                                                                                }})->insert;
        $message = model('TestrunDB')->resultset('Message')->new({testrun_id => $testrun_id,
                                                                  message    => {state => 'end-testprogram',
                                                                                 prc_number => 0,
                                                                                 testprogram => 0,
                                                                                }})->insert;
        $message = model('TestrunDB')->resultset('Message')->new({testrun_id => $testrun_id,
                                                                  message    => {state => 'start-testing',
                                                                                 prc_number => 0,
                                                                                }})->insert;
        exit;
}

=head1 AUTHOR

AMD OSRC Tapper Team, C<< <tapper at amd64.org> >>

=head1 BUGS

None.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Tapper::Fake::Testmachine

=head1 ACKNOWLEDGEMENTS

=head1 COPYRIGHT & LICENSE

Copyright 2008-2011 AMD OSRC Tapper Team, all rights reserved.

This program is released under the following license: freebsd

=cut

1; # End of Tapper::Fake
