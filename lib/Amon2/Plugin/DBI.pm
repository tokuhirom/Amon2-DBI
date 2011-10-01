use strict;
use warnings;
use utf8;

package Amon2::Plugin::DBI;
use Amon2::DBI;

sub init {
    my ($class, $context_class, $config) = @_;

    no strict 'refs';
    *{"$context_class\::dbh"} = \&_dbh;
}

sub _dbh {
    my ($self) = @_;

    if ( !defined $self->{dbh} ) {
        my $conf = $self->config->{'DBI'}
            or die "missing configuration for 'DBI'";
        $self->{dbh} = Amon2::DBI->connect(@$conf);
    }
    return $self->{dbh};
}

1;
__DATA__

@@ prereq_pm
        'Amon2::DBI'                      => '0',
@@ context
__PACKAGE__->load_plugin('DBI');

@@ config_development
    'DBI' => [
        "dbi:SQLite:dbname=@{[ <: $module :>->base_dir ]}/development.db",
        '',
        '',
        +{ sqlite_unicode => 1 },
    ],

@@ config_deployment
    'DBI' => [
        "dbi:SQLite:dbname=@{[ <: $module :>->base_dir ]}/deployment.db",
        '',
        '',
        +{ sqlite_unicode => 1 },
    ],

@@ config_test
    'DBI' => [
        "dbi:SQLite:dbname=@{[ <: $module :>->base_dir ]}/test.db",
        '',
        '',
        +{ sqlite_unicode => 1 },
    ],

