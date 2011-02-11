use inc::Module::Install;

name     'Artemis-Fake';
all_from 'lib/Artemis/Fake.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';
license  'freebsd';

build_requires 'Test::More';
build_requires 'Test::Perl::Critic';

requires 'Artemis::Model';

auto_install;

WriteAll;

