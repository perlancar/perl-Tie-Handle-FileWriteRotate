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


=head1 SEE ALSO

L<File::Write::Rotate>

=cut
