# Bash profile.d script.  This is sourced by the default /etc/csh.cshrc to
# ensure that /bin/sh exists and is runnable, updating older copies of ash
# or bash as appropriate, while leaving other shells (ksh or zsh) alone.
# Because it is sourced by any C-shell, including csh, it must be
# portable and not pollute the environment.

# Short circuit: if sh is not older than bash, stop now.  '/bin/test a -ot b'
# has the semantics we desire where missing 'a' is older than existing 'b'.
/bin/test \! /bin/sh.exe -ot /bin/bash.exe
if ( $status ) then
  # Scripting in csh is painful and non-intuitive.  Cheat, and let bash do the
  # work.  After all, this script belongs to the bash package, and we are not
  # changing the csh environment, so much as ensuring /bin/sh is up-to-date.
  /bin/bash.exe -c '. /etc/profile.d/00bash.sh'
endif
