use inc::Module::Install;

name     'Tapper-Fake';
all_from 'lib/Tapper/Fake.pm';
author   'AMD OSRC Tapper Team <tapper@amd64.org>';
license  'freebsd';

build_requires 'Test::More';
build_requires 'Test::Perl::Critic';

author_requires 'Module::Install::WriteAll';

requires 'Artemis::Model';

auto_install;

WriteAll;

