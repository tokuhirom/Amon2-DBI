use strict;
use warnings;
use utf8;

package Amon2::Setup::Flavor::DBI;
use parent qw/Amon2::Setup::Flavor/;
use Cwd;

sub run {
    my $self = shift;
    my $fname ="lib/$self->{module}/Web.pm";
    if (-f $fname) {
        print "modifying $fname\n";

        open my $ifh, '<', $fname or die "Cannot open file $fname: $!";
        my $src = do { local $/; <$ifh> };
        $src =~ s/^1;$/__PACKAGE__->load_plugin('DBI');\n\n1;/sm;
        close $ifh;

        open my $ofh, '>', $fname or die "Cannot open file $fname: $!";
        print {$ofh} $src;
        close $ofh;
    }
}

1;

