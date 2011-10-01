use strict;
use warnings;
use utf8;
use Test::More;
use File::Temp qw/tempdir/;
use App::Prove;
use File::Basename;
use Cwd;
use Amon2::Setup;

my $dir = tempdir(CLEANUP => 1);
my $cwd = Cwd::getcwd();
chdir($dir);

my $setup = Amon2::Setup->new(module => 'My::App');
$setup->run(['Basic'], ['DBI']);

ok(-f 'lib/My/App.pm', 'lib/My/App.pm exists');
ok((do 'lib/My/App.pm'), 'lib/My/App.pm is valid') or do {
    diag $@;
    diag do {
        open my $fh, '<', 'lib/My/App.pm' or die;
        local $/; <$fh>;
    };
};
like(slurp('Makefile.PL'), qr{Amon2::DBI});
like(slurp('lib/My/App.pm'), qr{DBI});
my $config = do 'config/development.pl';
is(ref $config->{DBI}, 'ARRAY');

my $libpath = File::Spec->rel2abs(File::Spec->catfile(dirname(__FILE__), '..', '..', 'lib'));
my $app = App::Prove->new();
$app->process_args('-Ilib', "-I$libpath", <t/*.t>);
ok($app->run);
chdir($cwd);

done_testing;

sub slurp {
    my $fname = shift;
    open my $fh, '<:utf8', $fname or die "Cannot open $fname: $!";
    do { local $/; <$fh> };
}

