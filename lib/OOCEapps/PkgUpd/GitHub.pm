package OOCEapps::PkgUpd::GitHub;
use Mojo::Base 'OOCEapps::PkgUpd::base';

my %TRANSFORM = (
    'openvpn-auth-ldap' => 'auth-ldap',
    'azure-agent'       => 'WALinuxAgent',
    'libgd'             => 'gd',
    'libmagic'          => 'FILE',
    'fuse'              => 'Version',
    'intel'             => 'microcode',
    'minio'             => 'RELEASE',
    'minio-mc'          => 'RELEASE',
    'nagios-nrpe'       => 'nrpe',
    'nagios-nsca'       => 'nsca',
    'libsasl2'          => 'cyrus-sasl',
    'clang'             => 'llvmorg',
    'compiler-rt'       => 'llvmorg',
    'llvm'              => 'llvmorg',
    'libcxx'            => 'llvmorg',
);

# Projects that use a bare trailing letter as a point-release suffix
# (e.g. tmux 3.7c). For anything else a trailing 'a' or 'b' is treated
# as an alpha/beta marker and other letters are not part of the version.
my %LETTERVER = map { $_ => undef } qw(
    tmux
);

# public methods
sub canParse {
    my $self = shift;
    my $name = shift;
    my $url  = shift;

    return $url =~ /github\.com/ && $name !~ m|^runtime/java/openjdk|;
}

sub getVersions {
    my $self = shift;
    my $name = shift;
    my $res  = shift;
    my $url  = shift;

    $name = $self->extractName($name);

    # jsonrpclib, meson and orjson are Python packages - remove the version suffix
    $name =~ s/-\d+$// if $name =~ /^(?:jsonrpclib|meson|orjson)/;

    ($name, my $ver) = $self->extractNameMajVer($name);
    $name = $TRANSFORM{$name} if exists $TRANSFORM{$name};

    $ver *= 10.0 if $name eq 'llvmorg' && $ver =~ /^\d+\.\d+$/;

    my @versions = $res->dom->find('a')->each;
    s/_/./g for @versions;
    # ICU uses hyphens instead of dots for tags
    if ($name eq 'icu4c') {
        s/(\d+)-/$1./g for @versions;
    }

    my $prog = $url->path->[1];

    my $lsuf = exists $LETTERVER{$name} ? qr/[a-z]?/i : qr//;

    return [
        grep { /^$ver/ }
        map { m#/\Q$prog\E/releases/tag/(?:v(?:er\.)?|rel(?:ease)?[-.]|stable-|R\.|$name-?\.?)?
            (\d{4}(?:-\d{2}){2}T(?:\d{2}-){2}\d{2}Z|[\d.]+(?:op)?\d+$lsuf)
            (?!-?(?:\.\d+|\.?(?:rc\d*|dev|a(?:lpha)?|b(?:eta)?|pre|test)))#ix
        } @versions
    ];
}

1;

__END__

=head1 COPYRIGHT

Copyright 2022 OmniOS Community Edition (OmniOSce) Association.

=head1 LICENSE

This program is free software: you can redistribute it and/or modify it
under the terms of the GNU General Public License as published by the Free
Software Foundation, either version 3 of the License, or (at your option)
any later version.
This program is distributed in the hope that it will be useful, but WITHOUT
ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
more details.
You should have received a copy of the GNU General Public License along with
this program. If not, see L<http://www.gnu.org/licenses/>.

=head1 AUTHOR

S<Dominik Hassler E<lt>hadfl@omnios.orgE<gt>>

=head1 HISTORY

2017-09-06 had Initial Version

=cut

