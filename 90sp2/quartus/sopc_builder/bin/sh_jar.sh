#!/bin/sh
CMD=`cygpath -m "$0"`
PERL5LIB=`cygpath -u "$SOPC_KIT_NIOS2/bin"` perl - "$CMD" "$@" <<\ENDOFPERL
#!perl
use sh_launch;
my $tool = shift @ARGV;
exit system($nios2sh_JRE, "-Xmx512m", "-jar", "$tool.jar", @ARGV)>>8;
