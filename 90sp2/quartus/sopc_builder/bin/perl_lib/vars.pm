#Copyright (C)2001-2003 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.








package vars;

require 5.002;

# The following require can't be removed during maintenance
# releases, sadly, because of the risk of buggy code that does
# require Carp; Carp::croak "..."; without brackets dying
# if Carp hasn't been loaded in earlier compile time. :-(
# We'll let those bugs get found on the development track.
require Carp if $] < 5.00450;

sub import {
    my $callpack = caller;
    my ($pack, @imports, $sym, $ch) = @_;
    foreach $sym (@imports) {
        ($ch, $sym) = unpack('a1a*', $sym);
	if ($sym =~ tr/A-Za-z_0-9//c) {
	    # time for a more-detailed check-up
	    if ($sym =~ /::/) {
		require Carp;
		Carp::croak("Can't declare another package's variables");
	    } elsif ($sym =~ /^\w+[[{].*[]}]$/) {
		require Carp;
		Carp::croak("Can't declare individual elements of hash or array");
	    } elsif ($^W and length($sym) == 1 and $sym !~ tr/a-zA-Z//) {
		require Carp;
		Carp::carp("No need to declare built-in vars");
	    }
	}
        *{"${callpack}::$sym"} =
          (  $ch eq "\$" ? \$   {"${callpack}::$sym"}
           : $ch eq "\@" ? \@   {"${callpack}::$sym"}
           : $ch eq "\%" ? \%   {"${callpack}::$sym"}
           : $ch eq "\*" ? \*   {"${callpack}::$sym"}
           : $ch eq "\&" ? \&   {"${callpack}::$sym"}
           : do {
		require Carp;
		Carp::croak("'$ch$sym' is not a valid variable name");
	     });
    }
};

1;
__END__

=head1 NAME

vars - Perl pragma to predeclare global variable names

=head1 SYNOPSIS

    use vars qw($frob @mung %seen);

=head1 DESCRIPTION

This will predeclare all the variables whose names are 
in the list, allowing you to use them under "use strict", and
disabling any typo warnings.

Unlike pragmas that affect the C<$^H> hints variable, the C<use vars> and
C<use subs> declarations are not BLOCK-scoped.  They are thus effective
for the entire file in which they appear.  You may not rescind such
declarations with C<no vars> or C<no subs>.

Packages such as the B<AutoLoader> and B<SelfLoader> that delay
loading of subroutines within packages can create problems with
package lexicals defined using C<my()>. While the B<vars> pragma
cannot duplicate the effect of package lexicals (total transparency
outside of the package), it can act as an acceptable substitute by
pre-declaring global symbols, ensuring their availability to the
later-loaded routines.

See L<perlmodlib/Pragmatic Modules>.

=cut
