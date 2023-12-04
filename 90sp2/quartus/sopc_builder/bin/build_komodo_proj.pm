use wiz_utils;
use strict;

my $system_dir;
my $sopc_dir;
my $aspa = {
    ScriptArgs => "",
    StartupScriptExtern => "",
    IncludeDirectories => "",
    files => "",
};

$aspa = {
   PERL_EXECUTABLE    => "",
   PERL_PARAMETERS => "",
   SOPC_BUILDER_FILENAME  => "",
   SOPC_BUILDER_PARAMETERS  => "",
};

my $perl_default_location = "C:/Perl/bin/perl.exe";
my $debugger_default_location = "C:/Perl/Komodo_3.0";
my $rel_debugger_path = "komodo.exe";


if( -x "/bin/uname" && `/bin/uname` =~ m/Linux/)
{   
    $perl_default_location = "/tools/komodo/3.1/active-perl/bin/perl";
    $debugger_default_location = "/tools/komodo/3.1/komodo";
    $rel_debugger_path = "komodo";
}

### Note: not a lot of these subroutines are actually used yet... but they
# remain for possible future enhancements.

sub create_komodo_debug_project{
    my ($ca) = (@_);
    # there's really nothing to do here... 
}

sub find_debugger_perl_location {
   my ($arg) = (@_);
   my $sopc_directory = $$arg{sopc_directory};
   my $config_file = &ptf_parse::new_ptf_from_file($sopc_directory . "/.sopc_builder");
   my $perl_location = "";
   if($config_file)
   {
      $perl_location = &ptf_parse::get_data_by_path($config_file,"sopc_asp");
   }
   if($perl_location eq "")
   {
      my $temp_dn = $perl_default_location ;
      if(-e $temp_dn) {
        $perl_location = $perl_default_location;
      } else {
        # perl_location will remain "".
        print "Perl install path specified by \"sopc_asp\" setting in ".
            ".sopc_builder file is not correct.  The specified ".
            "setting was $perl_location.\n"
      }
   }
   return $perl_location;
}

# find_debugger_location -- returns string path of where it thinks the
# debugger is located .
sub find_debugger_location {
   my ($arg) = (@_);
   my $sopc_directory = $$arg{sopc_directory};
   my $config_file = &ptf_parse::new_ptf_from_file($sopc_directory . "/.sopc_builder");
   my $komodo_location = "";
   if($config_file)
   {
      $komodo_location =
          &ptf_parse::get_data_by_path($config_file,"sopc_komodo");    
   }
   if($komodo_location eq "")
   {
      my $temp_dn = $debugger_default_location."/".$rel_debugger_path;
      if(-f $temp_dn) {
        $komodo_location = $temp_dn;
      } else {
        # komodo_location will remain "".
        print "Komodo install path specified by \"sopc_komodo\" setting in ".
            ".sopc_builder file is not correct.  The specified ".
            "setting was $komodo_location.\n"
      }
   }
   return $komodo_location;
}

sub check_debugger_install{
   my ($arg) = (@_);

   my $komodo_location = &find_debugger_location($arg); 
   if ($komodo_location eq "")
   {
      print "No komodo install found. You must debug the project manually.\n";
      return 0;
   } else {
      return 1;
   }
}

sub launch_komodo_debug_project{
   my ($arg) = (@_);
   my @gc;

   my $komodo_location = &find_debugger_location($arg);
   push(@gc,"\"".$komodo_location."\"");

   my $error_code = system(@gc);
   if ($error_code != 0){
      print("Error: Unable to start Komodo for debug for module $$arg{module_name}\n");
   }
   return 1;
}


1;



