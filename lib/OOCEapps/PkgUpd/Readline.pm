package OOCEapps::PkgUpd::Readline;
use Mojo::Base 'OOCEapps::PkgUpd::base';

# public methods
sub canParse {
    my $self = shift;
    my $name = shift;
    my $url  = shift;

    return $name =~ /library\/readline/;
}

sub getVersions {
    my $self = shift;
    my $name = shift;
    my $res  = shift;

    $name =~ s/-patchlvl$//;
    $name = $self->extractName($name);
    return [
        map { /$name\d*-([\d.]+)\.(?!\d*-?(?:alph|beta|rc\d+))/ }
            $res->dom->find('a')->each
    ];
}

1;

__END__

=head1 COPYRIGHT

Copyright 2019 OmniOS Community Edition (OmniOSce) Association.

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

S<Andy Fiddaman E<lt>andy@omnios.orgE<gt>>

=head1 HISTORY

2018-09-20 had Initial Version

=cut

