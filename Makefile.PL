use inc::Module::Install;

name     'Tapper-Fake';
all_from 'lib/Tapper/Fake.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';
license  'freebsd';

build_requires 'Test::More';
build_requires 'Test::Perl::Critic';

auto_install;

WriteAll;

