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

my @asp_filelist = ("debug.sln", "debug.suo", "debug.perlproj");
my $rel_dot_net_path = "Common7/IDE/devenv.exe";

my $msvs_default_location = "c:/Program Files/Microsoft Visual Studio .NET";

sub create_debug_project{
    my ($ca) = (@_);

    &parse_command_line($ca);

    #print("sd: $sopc_dir, syd: $system_dir\n");

    #copy over all of the files to the project directory
    foreach my $file(@asp_filelist){

       if(0){#-f $file){
          print "ASP Setup: Not creating file $file because it ".
          "already exists in directory $system_dir.  Please delete this ".
          "file to have it recreated\n";
       }else{
          unlink ($system_dir."/".$file);
          Perlcopy($sopc_dir."/bin/visual_perl_template/$file",
                   $system_dir."/");
       }
    }
    #doctor up the Visual Studio project...
    &doctor_project_file();
}

sub check_dot_net_install{
   my ($arg) = (@_);
   my $sopc_directory = $$arg{sopc_directory};
   my $config_file = &ptf_parse::new_ptf_from_file($sopc_directory . "/.sopc_builder");
   my $dot_net = "";
   if($config_file)
   {
      $dot_net =
          &ptf_parse::get_data_by_path($config_file,"sopc_dot_net");    
      
      if (!$dot_net)
      {
         $dot_net = $msvs_default_location
             if (-e $msvs_default_location);
      }
   }
   
   if($dot_net eq "")
   {
      print "No .NET Visual Studio location found... You must debug the project manually by double clicking on the debug.sln file created in your project directory\n";
      return 0;
   }else{
      my $temp_dn = $dot_net."/".$rel_dot_net_path;
      print ".NET path specified by \"sopc_dot_net\" setting in ".
          ".sopc_builder file is not correct.  The specified ".
          "setting was $dot_net.\n"
          if(!-f $temp_dn);
      return 1;
   }
}

sub launch_debug_project{
   my ($arg) = (@_);
   my @gc;

   my $config_file = &ptf_parse::new_ptf_from_file($$arg{sopc_directory} . "/.sopc_builder");
   my $dot_net = "";
   if($config_file)
   {
      $dot_net =
          &ptf_parse::get_data_by_path($config_file,"sopc_dot_net");    
   }

   if (!$dot_net)
   {
      $dot_net = $msvs_default_location
          if (-e $msvs_default_location);
   }

   $dot_net .= "/";
   $dot_net .= $rel_dot_net_path;
   push(@gc,"\"".$dot_net."\"");
   push(@gc, $$arg{system_directory}."/debug.sln");
   #print "dn: $dot_net\n";

   my $error_code = system(@gc);
   if ($error_code != 0){
      print("Error: Unable to start .NET for debug for module $$arg{module_name}\n");
   }
   return 1;
}

sub parse_command_line{
    my ($cl) = (@_);
    my @includes;
    my @gen_command;
    my @args;

    # first arg is the perl
    $cl =~ s/^\s*(.*?)\s+(.*?)$/$2/;
    #print "perl: $1\n";

    # second arg(s) are the includes
    while($cl =~ s/\s*-I(.*?)\s+(.*?)$/$2/){
       push(@includes, $1);
       #print("include: $1\n");
       $aspa->{IncludeDirectories} = join(";", @includes);
    }
    
    # third arg is the generator command
    $cl =~ s/^\s*(.*?)\s+//;
    $aspa->{StartupScriptExtern} = $1;
    
    # clean up the arg holder...
    while($cl =~ s/(\-\-\w+\=\S*)(\s*)/$2/){
       push(@args, $1);
       #print "arg: $1\n";
       $aspa->{ScriptArgs} = join(" ", @args);
       
       if($cl =~ /\-\-system_directory\=(\S+)/){
          $system_dir = $1;
       }

       if($cl =~ /\-\-sopc_directory\=(\S+)/){
          $sopc_dir = $1;
       }
    }


}

sub doctor_project_file{
    my $file = shift(@_);
    my $file_pp = $system_dir."/debug.perlproj";
    
    open FILE, "< $file_pp" || die("Could not open $file_pp");
    my @lines = <FILE>;
    
    foreach my $key(keys %{$aspa}){
       foreach my $line(@lines){
          if($line =~ /^(\s*)$key/){
             $line = $1.$key."=\"$aspa->{$key}\"\n";
          }
       }
    }
    close FILE;
    
    open FILE, "> $file_pp";
    print FILE @lines;
    close FILE;
};

1;



