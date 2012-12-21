package Tie::Handle::FileRotate;

use 5.010;
use strict;
use warnings;

use File::Write::Rotate;

# VERSION

sub TIEHANDLE {
    my ($class, %args) = @_;

    bless {
        fwr => File::Write::Rotate->new(%args),
    }, $class;
}

sub PRINT {
    my $self = shift;
    $self->{fwr}->write(@_);
}

1;
# ABSTRACT: Filehandle tie to write to autorotated file with File::Write::Rotate

=head1 SYNOPSIS

 use Tie::Handle::FileRotate;
 tie *FH, 'Tie::Handle::FileRotate',
     dir=>'/some/dir', prefix=>'myapp', size=>25*1024*1024, histories=>5;
 print FH "Logging a line\n";
 print FH "Logging another line\n";


=head1 DESCRIPTION

This module ties a filehandle to L<File::Writer::Rotate> object.

I first wrote this module to tie STDERR, so that warnings/errors are logged to
file instead of terminal (with autorotation, for good behavior).


=head1 METHODS

=head2 TIEHANDLE classname, LIST

Tie this package to file handle. C<LIST> will be passed to
L<File::Writer::Rotate>'s constructor.


=head1 TIPS

To log warnings/errors to terminal I<as well as> autorotated file, you can do
something like this instead:

 my $fwr = File::Write::Rotate->new(...);
 $SIG{__WARN__} = sub {
     $fwr->write(~~localtime, " ", $_[0], "\n");
     warn $_[0];
 };
 $SIG{__DIE__} = sub {
     $fwr->write(~~localtime, " ", $_[0], "\n");
     die $_[0];
 };


=head1 SEE ALSO

L<File::Write::Rotate>

=cut
