use inc::Module::Install;
use Module::Install::AuthorTests;

name 'Amon2-DBI';
all_from 'lib/Amon2/DBI.pm';

requires(
    'DBI'                      => 0,
    'DBD::SQLite'              => 0,
    'SQL::Interp'              => 0,
    'DBIx::TransactionManager' => 0,
	'parent'                   => 0,
	'Carp::Clan'               => 0,
);

tests 't/*.t t/*/*.t t/*/*/*.t t/*/*/*/*.t';
test_requires 'Test::More' => 0.96; # done_testing, subtest
test_requires 'Test::Requires';
author_tests('xt');
WriteAll;
