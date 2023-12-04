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


# +--------------
# | needed to set the path to the JRE
# | determine if we're solaris.
# |
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
        if(($jar =~ /.*\.jar/i) &&
           ($jar !~ /^jwizman.jar/i) &&
           ($jar !~ /^jmwizc.jar/i))
        {
            $result .= "$path/$jar" . $sep;
        }
    }
    return $result;
}

sub getJavaExecutable($)
{
    my $result;
    my $qrd = $ENV{QUARTUS_ROOTDIR};
    $is_silent_mode = $_[0];

    if(isWin())
    {
        if($is_silent_mode==1)
        {
            $result = $qrd . "/bin/jre/bin/java.exe";
        }
        else
        {
        $result = $qrd . "/bin/jre/bin/javaw.exe";
    }
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


my $check_exit_code = 0;
my $is_silent_mode = 0;
my $is_old_flow = 0;
sub buildCommandLine()
{
    my $sopcDir = $ENV{"QUARTUS_ROOTDIR"} . "/sopc_builder/model";
    my $sopcLibDir = "$sopcDir/lib";
    
    my $commonLibDir = getCommonLibDir();
    my $classpath = appendJars($commonLibDir);
    $classpath .= appendClasspathArgs();


    my @moduleLibraries =
        (
            "com.altera.legacy.emulation.LegacyLibraryInitializer",
            "com.altera.sopcmodel.components.avalon.AvalonComponentLibraryInitializer",
            "com.altera.nios2.Nios2LibraryInitializer",
            "com.altera.sopcmodel.components.custominstruction.CustomInstructionLibraryInitializer",
            "com.altera.sopcmodel.components.atlantic.AtlanticComponentLibraryInitializer"
        );

    my $libraries = "--librarian=false --library=" . join(":",@moduleLibraries);

    my $mainClass = "com.altera.sopceditor.app.megawizard.MegaWizardLauncher";

    #my $options = "-laf";

    my $argv = ""; 
    
    for(my $i = 0; $i <= $#ARGV; $i++)
    {
        my $arg = $ARGV[$i];
        if($arg =~ /^-projectpath(.+)$/)
        {
        	$arg = "-projectpath=$1";	
        }
        elsif($arg =~ /^([-]+[^:]+):(.*)$/)
        {
           $arg = "$1=$2";
           if($1 eq "--librarian-path")
           {
           	$libraries="";	
           }
           
           if($arg =~ /^-silent/ || $arg =~ /^--silent/ || $arg =~ /^-script/ || $arg =~ /^--script/ )
	   {
		$is_silent_mode = 1;
		print MYFILE "is_silent_mode is = $is_silent_mode\n";
	   }
        }
        elsif($arg =~ /^-devicefamily([^:]+)$/)
        {
        	$arg = "-devicefamily=$1";	
        }
        elsif($arg =~ /^-projectname([^:]+)$/)
        {
        	$arg = "-projectname=$1";	
        }
        elsif($arg =~ /^--check_exit_code$/)
        {
        	$check_exit_code = 1;	
        }
        elsif($arg =~ /^-silent/ || $arg =~ /^--silent/ || $arg =~ /^-script/ || $arg =~ /^--script/ )
	{
	         $is_silent_mode = 1;
	}
	
            
        
        $argv .= " \"$arg\""; 
    }
    
    my $java = getJavaExecutable($is_silent_mode);
    
    my $result = "";
    
    if($is_old_flow == 1)
    {
    	$result = "\"$java\" -cp \"$classpath\" $mainClass $libraries $options $argv";
    }
    else
    {
        $result = "\"$java\" -jar \"$sopcLibDir/com.altera.iplauncher.jar\" $argv";	
    }

    return $result;
}

sub getCommonLibDir()
{
	my $sep = getClasspathSeparator();
	foreach my $arg (@ARGV)
        {
           if($arg =~ /^--classpath:(.*)$/)
           {
           	    $is_old_flow = 1;
	            my @parts = split(/[,$sep]/,$1);
	            foreach my $part (@parts)
	            {
	                if($part =~ /(.+)\/?\\?librarian\.jar/)
	                {
	                	return $1;	
	                }
	                
	            }
           }
        }	
        return;
	
}

sub main()
{
    my $command = buildCommandLine();
    my $result = system($command);
    # our exit code is in bits 8-15, discard bits 0-7, and sign-correct it.
    $result >>= 8;
    $result = -(256-$result) if ($result > 127);
    if($check_exit_code eq 1)
    {
    	if($result eq -1)
    	{
    		$result = 1;	
    	}	
    	else{ $result = 0; }
    	
    }
    exit $result;
}

main();

# The end
