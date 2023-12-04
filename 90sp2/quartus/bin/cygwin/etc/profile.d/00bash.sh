# Bash profile.d script.

# Copyright (C) 2005, 2006 Eric Blake
# This file is free software; I give unlimited permission to copy and/or
# distribute it, with or without modifications, as long as this notice is
# preserved.

# This is sourced by the default /etc/profile to ensure that /bin/sh
# exists and is runnable, updating older copies of ash or bash as
# appropriate, while leaving other shells (ksh or zsh) alone.  Because
# it is sourced by any bourne shell, including ash, it must be
# portable and not pollute the environment.

# Short circuit: if sh is not older than bash, stop now.  '/bin/test a -ot b'
# has the semantics we desire where missing 'a' is older than existing 'b'.
# Not all test implementations have these semantics, and POSIX does not
# require support for -ot, so we cannot use a builtin.
/bin/test /bin/sh.exe -ot /bin/bash.exe || return 0

# Short circuit: if this is /bin/sh, we know that /bin/sh is not missing; and
# we also know that even if it is out-of-date, we cannot upgrade it since
# windows refuses to replace in-use executables.  Again, -ef is not required
# by POSIX.  Rely on /proc semantics to find out who we are, since $0 can
# be faked.
/bin/test /bin/sh.exe -ef "`cat /proc/$$/exename`" && return 0

# Is /bin/sh missing, or does it have bad dependencies making it unrunnable?
test -f /bin/sh.exe && case `(cygcheck /bin/sh.exe) 2>&1` in
  *Error:\ could\ not\ find* | *Cannot\ open*) # broken, needs update
    ;;
  *) # We can run it.  Is the version from ash or bash?
    case `(/bin/sh.exe --version) 2>&1` in
      '' | Illegal\ option\ --* | GNU\ bash*) # ash or older bash
	;;
      *) # anything else - quit now
	return 0 ;;
    esac ;;
esac

# Get here if missing, broken, ash, or old bash, so an update is needed.
# Use copy, not hard or symlink, since symlinks won't work from Windows cmd
# and a hardlink to a running shell can't be broken.  Try in-place copy
# first, but fall back to --remove-destination in case /bin/sh has different
# ACLs than /bin/bash.  Drop into a subshell so that we can do redirections;
# the postinstall script already collects stdout to /var/log/setup.log.full,
# and passes a parameter (see /etc/postinstall/01bash.bat) so that we will
# know this; whereas a normal login must do the redirections itself.
(
  if test x"$1" != xpostinstall ; then
    exec >> /var/log/setup.log.full
  fi
  exec 2>&1
  echo "`date '+%Y/%m/%d %T'` /etc/profile.d/00bash.sh:" \
    "Attempting to update /bin/sh.exe"
  /bin/cp -fpuv /bin/bash.exe /bin/sh.exe ||
    /bin/cp -puv --remove-destination /bin/bash.exe /bin/sh.exe
)

# Local Variables:
# fill-column: 72
# mode: sh
# sh-indentation: 2
# End:
