#!/usr/bin/perl


# +----------------------------------------------
# | This Perl script is a launch wrapper for the
# | Java-based (megafunction) megawizards . It
# | constructs a full classpath based on the entries
# | of the *.lst file it is invoked by and passes
# | the command-line arguments through to the wizard.
# |
# | This script will be launched by the .lst file 
# | of each Java-based megawizard


# +--------------
# | windows is different than all the others
# | determine if we're windows.
# |
sub isWin()
{
    return 1 if($^O =~ /win/i);
    return 0;
}


# +--------------
# | needed to set the path to the JRE
# | determine if we're solaris.
# |
sub isSolaris()
{
    return 1 if($^O =~ /solaris/i);
    return 0;
}

# +-----------------------
# | march through @ARGV and
# | look for --eclipse
sub isEclipseMode()
{
    my $result = 0;
    for(my $i = 0; $i <= $#ARGV; $i++)
    {
        my $arg = $ARGV[$i];
        if ($arg =~ /^--eclipse(.*)$/)
        {
  		$result = 1;
	  }
    }
    return $result;
}

sub getClasspathSeparator()
{
    my $sep = isWin() ? ";" : ":";
    return $sep;
}

sub getQuartusRootDir()
{
    # Use the fact that the wizard.lst file specifies the full absolute path
    # of the launcher script to find the quartus path
    my $path = $0;
    
    # Get Quartus root path by removing the relative path of the script path
    # and its name from the absolute path
    $path =~ s/common\/ip\/altera\/common\/lib\/jrmegawizard_launcher.pl//i;
    #Replace a trailing // with a single /
    $path =~ s/\/\//\//i;
    return $path;
}

sub getJavaExecutable()
{
    my $result;
    my $qrd = $ENV{QUARTUS_ROOTDIR};

    if(isWin())
    {
        $result = $qrd . "/bin/jre/bin/javaw.exe";
    }
    elsif (isSolaris())
    {
        $result = $qrd . "/solaris/jre/bin/java";
    }
    else
    {
        $result = $qrd . "/linux/jre/bin/java";
    }
    return $result;
}


sub set_LD_LIBRARY_PATH_var()
{
    my $result;
    my $qrootdir = $ENV{QUARTUS_ROOTDIR};
    my $ldpath = $ENV{LD_LIBRARY_PATH};
    my $sep = getClasspathSeparator();

    if(isWin())
    {
        $result = $ldpath;
    }
    elsif (isSolaris())
    {
        $result = $qrootdir . "/solaris" . $sep . $ldpath;
    }
    else
    {
        $result = $qrootdir . "/linux" . $sep . $ldpath;
    }

    $ENV{LD_LIBRARY_PATH} = $result;
}



# +-----------------------
# | march through @ARGV and
# | look for
# | --classpath=a,b,c entries.
# | return array of additional classpaths,
# | delete same from ARGV.
sub appendClasspathArgs()
{
    my $sep = getClasspathSeparator();
    my $result = "";
    for(my $i = 0; $i <= $#ARGV; $i++)
    {
        my $arg = $ARGV[$i];
        if($arg =~ /^--classpath:(.*)$/)
        {
            my @parts = split(/[,$sep]/,$1);
            foreach my $part (@parts)
            {
                $result .= $sep . $part;
            }
            splice(@ARGV,$i,1);
            $i--; # backbump
        }
    }
    return $result;
}


sub buildCommandLine()
{
    my $qrd = $ENV{QUARTUS_ROOTDIR};
    my @std_jars =
	(
	$qrd . "/common/ip/altera/common/lib/asm-3.1.jar",
	$qrd . "/common/ip/altera/common/lib/asm-commons-3.1.jar",
	$qrd . "/common/ip/altera/common/lib/l2fprod-common-sheet.jar",
	$qrd . "/common/ip/altera/common/lib/miglayout15-swing.jar",
	$qrd . "/common/ip/altera/common/lib/wraplf.jar",
	$qrd . "/sopc_builder/model/lib/explicitlayout.jar",
	$qrd . "/sopc_builder/model/lib/com.altera.entityinterfaces.jar",
	$qrd . "/sopc_builder/model/lib/com.altera.megawizard2.jar",
	$qrd . "/sopc_builder/model/lib/com.altera.sopcmodel.jar",
	$qrd . "/sopc_builder/model/lib/com.altera.librarian.jar",
	$qrd . "/sopc_builder/model/lib/basicmodel.jar"
 	);

    my @std_classpaths =
	(
	$qrd . "/common/ip/altera/common/lib/jmwizc.jar",
	$qrd . "/common/ip/altera/common/lib/jwizman.jar"
	);


    my @eclipse_std_classpaths =
	(
	$qrd . "/common/jmega/jmwizc/bin",
	$qrd . "/common/jmega/jwizman/bin"
	);


    my $classpath = "";
    my $sep = getClasspathSeparator();

    if (isEclipseMode() == 0)
    {
    	foreach my $cpath (@std_classpaths)
    	{
        $classpath .= "$cpath" . $sep;
    	}
    }
    else
    {
    	foreach my $cpath (@eclipse_std_classpaths)
    	{
        $classpath .= "$cpath" . $sep;
    	}
    }
    
    foreach my $jar (@std_jars)
    {
        if ($jar =~ /.*\.jar/i)
        {
            $classpath .= "$jar" . $sep;
        }
    }
	
    # Append any --classpath entries one may have
    # in the .lst file as additional classpaths
    $classpath .= appendClasspathArgs();

    my $argv = "";
    for(my $i = 0; $i <= $#ARGV; $i++)
    {
        my $arg = $ARGV[$i];
        $argv .= " \"$arg\""; 
    }
 
    my $java = getJavaExecutable();
    my $mainClass = "com.altera.megawizard2.jwizman.JRMWLauncher";
    my $options = "";
    my $result = "\"$java\" -cp \"$classpath\" $mainClass $options $argv";
    return $result;
}


sub main()
{
    $ENV{QUARTUS_ROOTDIR} = getQuartusRootDir();
    set_LD_LIBRARY_PATH_var();

    my $command = buildCommandLine();

#  ### For debugging, only ################
#  open (MYFILE, '>>data.txt');
#  print MYFILE "$command";
#  print MYFILE "\n";
#  print MYFILE "$ENV{LD_LIBRARY_PATH}";
#  print MYFILE "\n";
#  close (MYFILE);
#  ########################################

    my $result = system($command);

    # our exit code is in bits 8-15, discard bits 0-7, and sign-correct it.
    $result >>= 8;
    $result = -(256-$result) if ($result > 127);
    #  if($check_exit_code eq 1)
    #{
    #	if($result eq -1)
    #	{
    #		$result = 1;	
    #	}	
    #	else{ $result = 0; }
    #}
    exit $result;
}

main();

# The end
