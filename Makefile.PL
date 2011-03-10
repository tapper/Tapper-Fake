use strict;
use warnings;

use inc::Module::Install;

name     'Tapper-Fake';
all_from 'lib/Tapper/Fake.pm';
author   'AMD OSRC Tapper Team <tapper@amd64.org>';
license  'freebsd';

build_requires 'Test::More';
build_requires 'Test::Perl::Critic';

author_requires 'Module::Install::WriteAll';

requires 'Tapper::Model';

auto_install;

repository 'git://github.com/amd/Tapper-Fake.git';
bugtracker 'http://rt.cpan.org/NoAuth/ReportBug.html?Queue=Tapper-Fake';

WriteAll;

