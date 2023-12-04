#!/usr/bin/perl


# +----------------------------------------------
# | This Perl script is a launch wrapper for the
# | Java program, sopceditor. In general it
# | constructs an appropriate classpath and passes
# | the command-line arguments through.
# |
# | This script will be launched by the main
# | sopc_builder script, which can also launch the
# | legacy sopc_builder application. If we put command
# | line help into the script, it should come from the
# | other "sopc_builder" script.
# |
# | It also discerns a few environment variables.
# |
# | ex:set expandtab:
# | ex:set tabstop=4:




# +--------------
# | windows is different than all the others
# | determine if we're windows.
# |
sub isWin()
{
    return 1 if($^O =~ /win/i);
    return 0;
}

sub isSolaris()
{
    return 1 if($^O =~ /solaris/i);
    return 0;
}

sub getClasspathSeparator()
{
    my $sep = isWin() ? ";" : ":";
    return $sep;
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
        if($arg =~ /^--classpath=(.*)$/)
        {
            my @parts = split("/[,$sep]/",$1);
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

# +------------------------
# | return an appended list of all the
# | jar files found in some directory
# |
sub appendJars($)
{
    my $path = shift;
    opendir(DIR,$path);
    my @files = readdir(DIR);
    closedir(DIR);

    my $result = "";
    my $sep = getClasspathSeparator();

    foreach my $jar (@files)
    {
        if($jar =~ /.*\.jar$/i)
        {
            $result .= "$path/$jar" . $sep;
        }
    }
    return $result;
}

sub getJavaExecutable()
{
    my $result;
    my $qrd = $ENV{QUARTUS_ROOTDIR};

    if(isWin())
    {
        $result = $qrd . "/bin/jre/bin/javaw.exe";
    }
    else
    {
       if (isSolaris())
       {
          $result = $qrd . "/solaris/jre/bin/java";
       }
       else
       {
          $result = $qrd . "/linux/jre/bin/java";
       }
    }
    return $result;
}

sub updateJavaNativeInterfaceLibraryPath()
{
    # Note: we manage the library path via environment variables,
    # and not via the java -Djava.library.path setting, though the
    # two ought to be compatible. For some discussion, see
    # http://www.jguru.com/faq/view.jsp?EID=970296
    #
    # Summary: set an environment variable to manage the library search path

    my $pathVar;    
    my $quartusLibDir;

    if(isWin())
    {
        $pathVar = 'PATH';
        $quartusLibDir = $ENV{'QUARTUS_ROOTDIR'} . "\\bin";
    }
    else
    {

       $pathVar = 'LD_LIBRARY_PATH';
       if (isSolaris())
       {
          $quartusLibDir = $ENV{'QUARTUS_ROOTDIR'} . "/solaris";
       }
       else
       {
          $quartusLibDir = $ENV{'QUARTUS_ROOTDIR'} . "/linux";
       }
    }
    
    my $jniPath = $ENV{$pathVar};
    
    # add the quartus library directory if not specified in the library path
    my $sep = getClasspathSeparator();
    my @path = split(/$sep/, $jniPath);
    my $hasQuartusLibDir = 0;
    for my $element (@path)
    {
        if ("$element" eq "$quartusLibDir")
        {
            $hasQuartusLibDir = 1;
            last;
        }
    }
    if (!$hasQuartusLibDir)
    {
        push @path, $quartusLibDir;    
    }
    $jniPath = join("$sep", @path);
    
    # update the LD_LIBRARY_PATH if we're running on unix
    # to match the value of the -Djava.library.path property.
    $ENV{$pathVar} = $jniPath;
}

sub buildCommandLine()
{
    my $sopcDir = $ENV{"QUARTUS_ROOTDIR"} . "/sopc_builder/model";
    my $sopcLibDir = "$sopcDir/lib";
    my $classpath = "";
    $classpath .= appendClasspathArgs();

    my $java = getJavaExecutable();

    my $splash = "-splash:$ENV{'QUARTUS_ROOTDIR'}/sopc_builder/model/lib/splash_screen.png";
    
    my @jvmargs = getJvmArgs(@ARGV);
    
    my @result;
    push(@result, $java);
    if (@jvmargs) {
        push(@result, @jvmargs);
    } else {
        push(@result, "-Xmx512M");
    }
    if (!isCommandLineOnly()) {
        push(@result, $splash);
    }
    if ("$classpath") {
        push(@result, "-cp");
        push(@result, $classpath);
    }
    push(@result, "-jar");
    push(@result, "$ENV{'QUARTUS_ROOTDIR'}/sopc_builder/model/lib/com.altera.sopceditor.jar");

    push(@result, @ARGV);
    return @result;
}

# extract command line arguments we should pass to the JVM from @ARGV
sub getJvmArgs()
{
    my @args = ();
    my @argv = ();
    for my $arg ( @ARGV )
    {
        if ($arg =~ /^-X/) {
            push(@args, $arg);
        }
        else
        {
            push(@argv, $arg);
        }
    }
    @ARGV = @argv;
    return @args;
}

sub onlyPrintCommandLine()
{
    for my $arg ( @ARGV )
    {
        return 1 if($arg =~ /-o/);
    }
    return 0;
}

sub isCommandLineOnly()
{
    for my $arg ( @ARGV )
    {
        return 1 if($arg =~ /-+generate/);
        return 1 if($arg =~ /-+script/);
        return 1 if($arg =~ /-+cmd/);
        return 1 if($arg =~ /-+update_classes_and_exit/);
    }
    return 0;
}

sub main()
{
    updateJavaNativeInterfaceLibraryPath();
    
    my @command = buildCommandLine();

    if (onlyPrintCommandLine())
    {
        print "\n-----------------------------\n";
        print "Executing:\n";
        for my $arg (@command)
        {
            print "\"$arg\" ";
        }
        print "\n";
        print "\n-----------------------------\n";
        exit 0;
    }

    my $result = system(@command);
    # our exit code is in bits 8-15, discard bits 0-7, and sign-correct it.
    $result >>= 8;
    $result = -(256-$result) if ($result > 127);
    exit $result;
}

main();

# The end
