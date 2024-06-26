package Fenix::Model::Handler::Issue;
use Mojo::Base 'Fenix::Model::Handler::base', -signatures;

use Mojo::Promise;

# constants
my $MODPREFIX = __PACKAGE__;

# attributes
has priority => 10;
has generic  => 0;
has handler  => sub($self) {
    return $self->utils->loadModules(
        $MODPREFIX,
        config  => $self->config,
        datadir => $self->datadir,
        chans   => $self->chans,
        utils   => $self->utils,
        mutemap => $self->mutemap,
    );
};
has handlers => sub($self) {
    return [
        sort {
            $self->handler->{$a}->priority <=> $self->handler->{$b}->priority
            || $a cmp $b
        } keys %{$self->handler}
    ]
};


sub process_p($self, $chan, $from, $msg, $mentioned = 0) {
    for my $hd (@{$self->handlers}) {
        my ($issues, $opts) = $self->handler->{$hd}->issues($msg);
        $opts //= {};

        next if !(@$issues && ($mentioned || $opts->{url}));

        my $hdn = $self->handler->{$hd}->name;

        my @issues;
        for my $issue (@$issues) {
            next if $self->utils->muted(\$self->mutemap->{"issue_$hdn"}->{$chan}, $issue);

            push @issues, $issue;
        }

        return Mojo::Promise->resolve([]) if !@issues;

        # limit the maximum number of issues fenix handles for one request
        @issues = splice @issues, 0, $self->config->{maxissue}
            if $self->config->{maxissue};

        return $self->handler->{$hd}->process_p(\@issues, $opts);
    }

    return undef;
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

2021-01-08 had Initial Version

=cut
