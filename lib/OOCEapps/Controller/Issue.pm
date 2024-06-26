package OOCEapps::Controller::Issue;
use Mojo::Base 'OOCEapps::Controller::base';

use Scalar::Util qw(blessed);

use OOCEapps::Mattermost;

sub process {
    my $c = shift;
    my $p = $c->param('text');

    return if !$c->checkToken;

    # default to illumos if just numbers and whitespaces are provided
    $p = "illumos $p" if $p =~ /^[\d\s]+$/;

    my $_p = $c->model->issue->process_p(qw(ooceapps ooceapps), $p, 1);

    return $c->render(json => OOCEapps::Mattermost->text("no issues found using search string '$p'"))
        if !blessed $_p;

    $c->render_later;

    $_p->then(sub {
        my $issue = shift;

        $c->render(json => OOCEapps::Mattermost->text(@$issue ? join ("\n", @$issue)
            : "no issue found using search string '$p'"));
    });
}

1;

__END__

=head1 COPYRIGHT

Copyright 2024 OmniOS Community Edition (OmniOSce) Association.

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

2018-05-04 had Initial Version

=cut

