#!/bin/sh
PERL5LIB=`cygpath -u "$SOPC_KIT_NIOS2/bin"` perl "${SH_PL:-$0.pl}" $@
