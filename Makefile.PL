use inc::Module::Install;

name     'Artemis-Fake';
all_from 'lib/Artemis/Fake.pm';
author   'OSRC SysInt Team <osrc-sysint@elbe.amd.com>';
license  'perl';

build_requires 'Test::More';

auto_install;

WriteAll;

