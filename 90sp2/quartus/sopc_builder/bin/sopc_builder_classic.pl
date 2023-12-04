#!perl


#############################################
#
# sopc_builder: Run the SOPC Builder tool
# (handles user-irrelevant details about Java,
#  directory names, expected switches, etc.)
#
#
   my $i=0;
   my $cmd;
   my $sopc_builder=$ENV{"sopc_builder"};
   my $sopc_builder_bin="";
   my $quartus_dir="";
   my $system_dir=".";
   my $system_name="";
   my $system_ext="";
   my $jre_dir="";
   my $debug_switch="";
   my $dash_d_switch="";
   my $projectname="";
   my $projectpath="";
   my $shelled=0;
   my $verbose=1;
   my $nop=0;
   my $backend = 0;
   my $mk_systembus = "";
   my $generate_cmd = "";
   my $dash_i_switches="";

#debug_message("-- -- -- -- -- -- -- --");
   $quartus_dir=$ENV{"QUARTUS_ROOTDIR"};
   $quartus_dir =~ s/\\/\//g;

   # if we're run from the SDK shell, our first argument
   # will contain the path to our perl executable, which
   # is expected to be one level down from the main
   # installation directory ($sopc_builder)
   if ($ARGV[$i] =~ /^-this=(.*)/)
   {
      # if we don't know where the install is, use 
      # this directory's parent-directory
      if ($sopc_builder eq "")
      {
         $sopc_builder = $1;
         $sopc_builder =~ s/(.*)\/.*$/$1/;
         #$sopc_builder = native_path($sopc_builder);
      }
      # take "this" parameter out of list sweep
      $i = $i + 1;
      $sopc_builder = native_path($sopc_builder);
      $shelled = 1;
  } else {
  	$sopc_builder = native_path("$quartus_dir/sopc_builder");
  }

   # accept (-h --h -help --help) as help requests
   if ($ARGV[$i] =~ /^[-]+h$/ || $ARGV[$i] =~ /^[-]+help$/)
   {
      print_usage();
      exit 0;
   }

   # accept (-v --v -version --version) as version requests
   if ($ARGV[$i] =~ /^[-]+v$/ || $ARGV[$i] =~ /^[-]+version$/)
   {
      print get_version_info() . "\n";
      exit 0;
   }

   # decide whether to launch the new or old sopc_builder app (--classic for old)
   # default to classic
   my $has_legacy_flag = 0;
   # $SOPC_BUILDER_PREVIEW trumps defalt
   if (! ($ENV{SOPC_BUILDER_PREVIEW} eq ""))
   {
      $has_legacy_flag = !$ENV{SOPC_BUILDER_PREVIEW};
   }
   # $SOPC_BUILDER_CLASSIC trumps $SOPC_BUILDER_PREVIEW
   if (! ($ENV{SOPC_BUILDER_CLASSIC} eq ""))
   {
      $has_legacy_flag = $ENV{SOPC_BUILDER_CLASSIC};
   }
   # --preview/--classic trumps $SOPC_BUILDER_CLASSIC
   for (my $n = 0 ; $n <= $#ARGV; $n++)
   {
      if ($ARGV[$n] =~ /^[-]+preview/)
      {
         if ($ARGV[$n] =~ /^[-]+preview(=0|=false|=off|=no)$/i)
         {
            $has_legacy_flag = 1;
         }
         else
         {
            $has_legacy_flag = 0;
         }
         
         # we remove the --preview argument so that the legacy flow still
         # works with the -b option.
         splice(@ARGV,$n,1);
         last;
      }
      if ($ARGV[$n] =~ /^[-]+(legacy|classic)/)
      {
         if ($ARGV[$n] =~ /^[-]+(legacy|classic)(=0|=false|=off|=no)$/i)
         {
            $has_legacy_flag = 0;
         }
         else
         {
            $has_legacy_flag = 1;
         }
         
         # we remove the --classic argument so that the legacy flow still
         # works with the -b option.
         splice(@ARGV,$n,1);
         last;
      }
   }
   for (my $n = 0 ; $n <= $#ARGV; $n++)
   {
      if ($ARGV[$n] =~ /^[-]+refresh$/)
      {
         $has_legacy_flag = 1;
      }
      elsif ($ARGV[$n] =~ /^[-]+b$/)
      {
         $has_legacy_flag = 1;
      }
      elsif ($ARGV[$n] =~ /^[-]+b=/)
      {
         $has_legacy_flag = 1;
      }
   }
   if (! $has_legacy_flag)
   {
      my $perl_executable = get_quartus_perl($quartus_dir);
      $sopc_builder =~ s/\\/\//g; 
      $perl_executable .= "/bin/perl"; 
      my $command = "\"$perl_executable\" \"$sopc_builder/model/bin/sopc_builder.pl\"";
      foreach my $arg ( @ARGV )
      {
         $command .= " \"$arg\"";
      }
      my $status = system $command;
      # our exit code is in bits 8-15, discard bits 0-7, and sign-correct it.
      $status >>= 8;
      $status = -(256-$status) if ($status > 127);
      exit $status;
   }

	# SPR 125969: check for required runtime patches
	if ($ENV{SOPC_BUILDER_SKIP_PATCH_CHECK} ne 1)
	{ check_patches(); }

   # scan input command-line arguments
   for( ; $i < scalar(@ARGV); $i++)
   {
      my $arg = $ARGV[$i];	

      if (($arg =~ tr/\"/\"/) == 1)
      {
         $arg =~ s/\"//; 
         print "\n $arg \n";
      }

     # first check for args we DON'T pass on
      if ($arg =~ /^-s$/)
      {
         $verbose=0;
         next;
      }

      # SPR 152802: check for backend-only mode
      if ($arg =~ /^-b[=]?(.*)$/)
      {
         $backend=1;
         $mk_systembus=$1 if ($1 ne "");
         next;
      }

      # collect-up any include-paths for backend-only mode
      if ($arg =~ /^-I(.*)$/)
      {
      	$dash_i_switches .= " -I$1";
      	next;
      }
      
      if ($arg =~ /^-o$/)
      {
         $nop=1;
         next;
      }
      # this switch must be 1st for sopc builder wizard,
      # so we save it aside for re-ordering later
      if ($arg =~ /(^[-]+debug_log=.*)/)
      {
         $debug_switch = $1;
         next;
      }

	   # find SOPC directory from '-d' parameter
	   # ignore '-devicefamily' parameter
	   if ($arg !~ /^-devicefamily/ && $arg =~ /^-d(.*)/)
	   {
   		   $sopc_builder = $1;
         $dash_d_switch = "\"" . $arg . "\"";
         next;
	   }
      if ($arg =~ /^-+projectname[=]?(.*)/)
      {
         $projectname = $1;
         next;
      }
      if ($arg =~ /-+sopc_lib_path=(.*)/)
      {
         $command_line_sopc_lib_path= $1;
      }
	   if ($arg =~ /^-+projectpath[=]?(.*)/)
	   {
         $projectpath = $1;
         next;
	   }
      # now check for args we will pass on, possibly modified

      # -qlm<path-to-quartus/libraries/megafunctions>
	   # snag 'qlm' from arg list, get the 'q' part out
	   # and then pass it as "--sopc_quartus_dir"
      # (note: not currently used because Tools->SOPC Builder
      #  in Quartus doesn't expand %w so we can't use -qlm=%w)
	   if ($arg =~ /^-qlm(.*)\/libraries\/megafunctions/)
	   {
		   $quartus_dir = $1;
	   }
      elsif ($arg =~ /^[-]+jre_dir=(.*)/)
      {
         $jre_dir = $1;
         next;   # don't pass this on to java, it's just to launch it
      }
 

      elsif ($arg =~ /^[-]+quartus_dir=(.*)/)
      {
         $quartus_dir = $1;
      }
	   # capture generate command
	   elsif ($arg =~ /^[-]+generate=(.*)/)
	   {
	   	  $generate_cmd = $1;
	   	  next if ($backend)  # don't pass in backend mode
	   }

       # find system directory from first non-switch parameter
      elsif (($system_name eq "") && ($arg =~ /(^[^-].+)/))
      {
         $system_name = $1;
         # must have forward-slashes
         $system_name =~ s/\\/\//g;
         # split system-path from system-name
         if ($system_name =~ /(.*)\/(.*)/)
         {
            $system_dir = $1;
            $system_name = $2;
         }
         next;
	   }
	   
      # perform sufficient quoting for space-laden args
      # (we'll be passing them on another command-line)
      $cmd .= " " . safe_arg($arg);
   }

   # forward-slashes, always:
   $sopc_builder =~ s/\\/\//g;
   if (! -d "$sopc_builder")
   {
#debug_message("sopc_builder: \$sopc_builder not set or passed; cannot continue\n");
      die "sopc_builder: \$sopc_builder not set or passed; cannot continue\n";
   }

   #|#
   #|#   system (project) directory
   #|#
   if ($system_dir eq "." || $system_dir eq "")
   {
      $system_dir = $projectpath;
   }
   if ($system_dir eq "." || $system_dir eq "")
   {
      $system_dir = native_path(`pwd`);
   }
   $system_dir=~ s/\\/\//g;

   #|#
   #|#   system name
   #|#
   if ($system_dir =~ /^[a-zA-Z]:.*/ ||
       $system_dir =~ /^[\\\/].*/)
   {
      # ABS-path
   }
   else
   {
      my $name = $system_dir;
      if ($projectpath ne "")
      { $system_dir = $projectpath; }
      else 
      { $system_dir = native_path(`pwd`); }

      # resolve upwards relative paths
      if ($name =~ /^\.\.[\/]*(.*)?$/)
      {
         while ($name =~ /^\.\.[\/]*(.*)?$/)
         {
            $name = $1;
            $name =~ s/^\///;
            $system_dir =~ s/[\/]+[^\/]*$//;
         }
      }

      # resolve downwards relative paths
      if ($name =~ /[a-zA-Z]/)
      {
         $system_dir .= "/" . $name;
      }
   }

   # split system-name from system-extension
   if ($system_name =~ /(.*)(\.+.*)$/)
   {
      $system_name = $1;
      $system_ext = $2;
   }
   # split system-path from system-name
   if ($system_name =~ /(.*)\/(.*)/)
   {
      $system_dir = $1;
      $system_name = $2;
   }
   # if system-extension isn't HDL-type, look in PTF for HDL-type
   if ($system_name ne "" && (($system_ext eq "") || ($system_ext eq ".ptf")))
   {
      my $sysptf = $system_dir . "/" . $system_name . ".ptf";
      die "sopc_builder: cannot find \"$sysptf\"" if ( ! -f "$sysptf" );
      my $language = get_ptf_assignment($sysptf, "hdl_language");
      if ($language =~ /verilog/)
      {   $system_ext = ".v"; }
      elsif ($language =~ /vhdl/)
      {   $system_ext = ".vhd"; }
      else
      {
         die "sopc_builder: unable to determine HDL language for $system_name\n";
      }
   }

   #|#
   #|#   system extension: default to .v (Verilog)
   #|#
   if ($system_ext eq "")
   {
      $system_ext = ".v";
   }

   #|#
   #|#   -projectname
   #|#
   if ($projectname eq "" && $system_name ne "")
   {
      if ( -f "$system_name.qpf" )
      {
         $projectname = $system_name . ".qpf";
      }
      elsif ( -f "$system_name.quartus" )
      {
         $projectname = $system_name . ".quartus";
      }
   }
   if ($projectname eq "")
   {
      if (opendir DIR, $system_dir)
      {
         my @qfiles = (grep {/\.qpf$/} readdir DIR, grep {/\.quartus$/} readdir DIR);
         closedir DIR;
         if (scalar(@qfiles) > 0)
         {
            $projectname = $qfiles[0];
         }
      }
   }
   if ($projectname eq "" && $system_name ne "")
   {
      $projectname = $system_name . ".qpf";
   }

   #|#
   #|#   -projectpath
   #|#
   if ($projectpath eq "")
   {
      $projectpath = $system_dir;
   }

   #|#
   #|#   system name: if we have one, make it a full path and
   #|#      put the appropriate HDL file-extension at the end
   #|#
   if ($system_name ne "" && !$backend)
   {
      $cmd .= " " . safe_arg($system_dir . "/" . $system_name . $system_ext);
   }

   #|#
   #|#   -d (sopc_builder directory): if not passed in,
   #|#      make one out of $sopc_builder
   #|#
   if ($dash_d_switch eq "")
   {
      $dash_d_switch =  "-d\"" . $sopc_builder . "\"";
   }


   #|# 
   #|#  quartus directory
   #|#
   $quartus_dir =~ s/\\/\//g;
   if ($quartus_dir eq "" || !(-d "$quartus_dir"))
   {
      # NOTE: this should not be necessary for 3.0 -- keeping until should not->is not
      $quartus_dir = get_ptf_assignment($sopc_builder . "/.sopc_builder", "sopc_quartus_dir");
      if (!get_quartus_exe($quartus_dir))
      {
         $quartus_dir = "";
      }
   }
   if ($quartus_dir eq "")
   {
      $quartus_dir=$ENV{"QUARTUS_ROOTDIR"};
      $quartus_dir =~ s/\\/\//g;
   }
   $ENV{"QUARTUS_ROOTDIR"}=$quartus_dir;

   if ($quartus_dir)
   {
	   $cmd .= " --quartus_dir=\"$quartus_dir\"";
      my $perl = get_quartus_perl($quartus_dir);
      $cmd .= " --sopc_perl=\"$perl\"";
      $ENV{SOPC_PERL} = $perl;
   }

   #|# 
   #|#  sopc builder library search path
   #|#
   my $sopc_lib_path=join("+",
                ($ENV{"SOPC_BUILDER_PATH"},
                $command_line_sopc_lib_path)
   );
   if ($sopc_lib_path)
   {
	   	my $sopc_builtins="+$quartus_dir/../ip/altera/sopc_builder_ip" .
                  "+$quartus_dir/../ip/altera/nios2_ip";
	   	if ($backend) { $sopc_builtins="+$quartus_dir/sopc_builder/components"; }
	   $cmd .= " --sopc_lib_path=\"$sopc_lib_path$sopc_builtins\"";
   }
   
   # SPR 152802: run backend scripts only (no Java)
   if ($backend)
   {
      my $perl = $ENV{SOPC_PERL};
      $perl = $^X if ($perl eq "");
      if ($generate_cmd ne "")
      {
      	$cmd = $cmd . " " . $generate_cmd;
      }
      if ($mk_systembus eq "")
      {
      	$mk_systembus = "$sopc_builder/bin/mk_systembus.pl";
      }
      if ($dash_i_switches eq "")
      {
	      $dash_i_switches = "-I$sopc_builder/bin" . " "
            			   . "-I$sopc_builder/bin/europa" . " "
                           . "-I$sopc_builder/bin/perl_lib";
      }
      $projectname =~ s/(.*)(\.+.*)$/\1/;
      $cmd = "\"" . "$perl/bin/perl" . "\"" . " "
      		. $dash_i_switches . " "
            . "$mk_systembus" . " "
            . "--generate=1" . " "
            . "--sopc_directory=$sopc_builder" . " "
            . "--projectname=" . safe_arg($projectname) . " "
            . "--system_directory=" . safe_arg($system_dir) . " "
            . "--system_name=$system_name" . " "
            . "--target_module_name=$system_name" . " "
            . "--sopc_quartus_dir=" . safe_arg($quartus_dir) . " "
            . $cmd;
       
   } else {

   #|# 
   #|#  java
   #|#
   my $javax = "";
   if ($jre_dir eq "") { $jre_dir = get_quartus_jre($quartus_dir); }
   if ($jre_dir ne "") { $javax = get_java_exe($jre_dir,$shelled); }

   if (! -e $javax )
   {
     $javax = get_java_exe($sopc_builder . "/bin/jre1.4",$shelled);
   }

   if (! -e $javax )   
   { 
     die "sopc_builder: unable to locate Java runtime environment";
   }

   # redirect stdio if necessary (when not called from shell)
   if (($shelled == 0) && ($debug_switch eq ""))
   {
      $debug_switch = "--debug_log=\"" . $projectpath . "/" . "sopc_builder_debug_log.txt\"";
   }

   # form java command-line
   $cmd = "\"" . $javax . "\""
		   . " -Xmx512M"
		   . " -classpath \"$sopc_builder/bin/sopc_builder.jar" 
		   . get_path_sep() . "$sopc_builder/bin/PinAssigner.jar" 
		   . get_path_sep() . "$sopc_builder/bin/sopc_wizard.jar" 
		   . get_path_sep() . "$sopc_builder/bin/jptf.jar\" "
		   . "sopc_builder.sopc_builder " 
         . $debug_switch . " "
         . $dash_d_switch . " "
         . "-notalkback=1". " "
         . "-projectname" . safe_arg($projectname) . " "
         . "-projectpath" . safe_arg($projectpath) . " "
		   . $cmd;
   } # else $backend
   
   if ($verbose || $nop)
   {
      print $cmd . "\n";
   }

   # run SOPC Builder wizard
   my $result = 0;
   if ($nop == 0)
   {
      # set CWD to the system dir so relative paths, etc. work
      chdir $system_dir;
      $result = (0xffff & system($cmd)) >> 8;
   }

   exit $result;

#|#
#|# helper subroutines
#|#
sub safe_arg
{
   my $arg = shift;

	if ($arg =~ /.* .*/)
	{	return "\"" . $arg . "\" "; }   

   return $arg;
}

sub on_windows
{
   return ($^O =~ /nt|cygwin|mswin32/i);
}

sub get_path_sep
{
   return on_windows() ? ";" : ":";
}


# +-------------------------
# | get_java_exe(path: java directory,boolean: run from console?)
# |
# | return the right flavor of java[w][.exe] based on
# | if we're on windows, and if we've been run from
# | the command line
# |

sub get_java_exe # (path-to-jre)
{
    my ($java_directory,$b_from_cmd_line) = (@_);
    
    my $b_on_windows = on_windows();

    my $java_name = "java";

    # |
    # | It's javaw if on Windows but not command line,
    # | and .exe for all things Windows
    # |

    $java_name .= "w" if($b_on_windows and !$b_from_cmd_line);
    $java_name .= ".exe" if ($b_on_windows);

    my $java_full_path = "$java_directory/bin/$java_name";

    return $java_full_path if -e $java_full_path;

    return "";
}

sub get_quartus_platform_bin
{
   my $q = shift;
   my $bin = "bin";
   if ($^O =~ /solaris/i)
   {   $bin = "solaris";  }
   elsif ($^O =~ /hpux/i)
   {   $bin = "hp11";     }
   elsif ($^O =~ /linux/i)
   {   $bin = "linux";     }
   return $q . "/" . $bin;
}

# return directory containing perl (executable is under 'bin')
sub get_quartus_perl # (path-to-quartus)
{
   my $q = shift;
   my $perl = get_quartus_platform_bin($q) . "/perl";
   $perl .= "561" if (! -d "$perl");
   my $perlx = "$perl/bin/" . (on_windows() ? "perl.exe" : "perl");
   return ( -e $perlx) ? $perl : "";
}

sub get_quartus_exe # (path-to-quartus)
{
   my $q = shift;
   my $quartus = on_windows() ? "quartus.exe" : "quartus";
   my $quartusx = "$q/bin/$quartus";
   return ( -d "$q" && -e "$quartusx") ? $quartusx : "";
}

sub get_quartus_jre # (path-to-quartus)
{
   my $q = shift;
   my $bin = get_quartus_platform_bin($q);
   my $jre = "$bin/jre";
   $jre = "$bin/jre/1.4.0_01" if (! -d "$jre/bin"); # 4.0 JRE is right under JRE (check for bin)
   $jre = "$bin/jre/1.4.0" if (! -d $jre);
   return ( -d "$jre" ) ? $jre : "";
}

sub native_path # (any path, even /cygdrive/...)
{
   my $path = shift;
   chomp $path;
   $path =~ s/\/cygdrive\/([a-zA-Z])/$1\:/;
   return $path;
}

sub get_ptf_assignment # (filename, assignment)
{
   my $fname = shift;
   my $aname = shift;
   my $a = "";

   open(PTF_FILE, $fname) or return "";
   while (<PTF_FILE>)
   {
      if (/.*($aname).*=\s*"(.*)"/)
      {
         $a = $2;
         break;
      }
   }
   close PTF_FILE;
   return $a;
}

sub check_patches()
{
	my $platbin = get_quartus_platform_bin();
	if ($platbin =~ m/solaris/)
	{
		# temp files for patches we have and patches we require
		my $have = "/tmp/sopc_patch_have$$.txt";
		my $req = "/tmp/sopc_patch_req$$.txt";
		
		# fill out temp file with patch requirements (mimic sys_reqs.txt)
		if (open(TMP, ">$req"))
		{
			print TMP <<PATCHLIST;
SunOS 1 5.9 113096-03
SunOS 1 5.9 112785-29
SunOS 1 5.8 108652-76 
SunOS 1 5.8 108921-18 
SunOS 1 5.8 108940-57 
SunOS 1 5.8 112003-03 
SunOS 1 5.8 108773-18 
SunOS 1 5.8 111310-01 
SunOS 1 5.8 112472-01 
SunOS 1 5.8 109147-27 
SunOS 1 5.8 111308-04
SunOS 1 5.8 112438-02 
SunOS 1 5.8 108434-13 
SunOS 1 5.8 108435-13 
SunOS 1 5.8 111111-03 
SunOS 1 5.8 112396-02 
SunOS 1 5.8 116602-01 
SunOS 1 5.8 111317-05 
SunOS 1 5.8 110386-03 
SunOS 1 5.8 111023-03 
SunOS 1 5.8 115827-01 
SunOS 1 5.8 113648-03 
SunOS 1 5.8 108987-13 
SunOS 1 5.8 108528-27 
SunOS 1 5.8 108989-02 
SunOS 1 5.8 108993-31 
SunOS 1 5.8 109326-12 
SunOS 1 5.8 110615-10 
SunOS 1 5.7 106950-24 
SunOS 1 5.7 107544-03 
SunOS 1 5.7 106327-20 
SunOS 1 5.7 106300-21 
SunOS 1 5.7 108376-44 
SunOS 1 5.7 107656-11 
SunOS 1 5.7 107702-12 
SunOS 1 5.7 108374-07 
SunOS 1 5.7 107226-19 
SunOS 1 5.7 107081-54 
SunOS 1 5.7 107636-10 
SunOS 1 5.7 107153-01 
SunOS 1 5.7 107834-04 
SunOS 1 5.7 106541-29 
SunOS 1 5.7 106980-23 
SunOS 1 5.6 105181-35 
SunOS 1 5.6 105210-51 
SunOS 1 5.6 105568-26 
SunOS 1 5.6 107733-11 
SunOS 1 5.6 105591-19 
SunOS 1 5.6 105633-64 
SunOS 1 5.6 105669-11 
SunOS 1 5.6 105284-50 
SunOS 1 5.6 106123-05
SunOS 1 5.6 106040-18 
SunOS 1 5.6 106841-01 
SunOS 1 5.6 106409-01 
SunOS 1 5.6 108091-03 
SunOS 1 5.6 112542-01 
SunOS 1 5.6 106125-16 
SunOS 1 5.6 106842-09 
PATCHLIST
			close TMP; 
		}
		
		# get installed patch-list and run it through check_patches 
		system("showrev -a > $have");  # get patches
		$ENV{PATCH_CMD} = "cat $have"; # tell check_patches.awk how to get patches
		my $cmd = "nawk -f $ENV{QUARTUS_ROOTDIR}/adm/check_patches.awk $req";
		my $error = system($cmd);
		if ($error != 0)
		{
			print "\nNOTE: SOPC Builder may not function correctly unless the\n";
			print "recommended patch-cluster is installed.  Please refer to:\n\n";
			print "  http://sunsolve.sun.com/pub-cgi/show.pl?target=patches/J2SE\n\n";
			print "for more information.\n";
		}
		unlink $req; unlink $have; # remove temp files
	}
}

sub debug_message
{
   my $arg = shift;
   open DEBUG_FILE, ">> sopc_debug_message.txt";
   print DEBUG_FILE time . "-- $arg\n";
   close DEBUG_FILE;
}

sub print_usage
{
      print <<USAGE_TEXT;
Usage: sopc_builder [OPTIONS] [MODE] <system-name[.ptf|.v|.vhd]>
Run SOPC Builder(tm) for specified system.

   OPTION                    DESCRIPTION
   --generate                Equivalent to pressing 'Generate' button
   --generate=<switches>     Generate with additional command-line switches
   --debug_log=<filename>    Send debugging output to <filename>
   --no_splash               Suppress splash-screen display
   --refresh                 Refresh all system module settings using
                             component class.ptf UI scripts
   --update_classes_and_exit Update ~/.sopc_builder/install.ptf with component
                             class.ptf file locations and exit
   --script=<filename>       Run specified script-file
   --cmd=<commands>          Run semicolon-delimited commands
   
   MODE                     
   -h, --help               Display this usage information
   -v, --version            Display version information
   -s                       Silent mode; don't display command-line
   -o                       Display command-line without executing
   -b[=<generator-script>]  Backend mode; run generator directly (no Java)
                            (custom -I<dir> flags accepted in backend mode)
USAGE_TEXT
}

sub get_version_info()
{
  return "9.0";
}


