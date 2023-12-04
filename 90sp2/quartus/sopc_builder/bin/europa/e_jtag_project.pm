#Copyright (C)2001-2008 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.



































package e_jtag_project;
@ISA = ("e_project");
use strict;
use e_project;
use europa_utils;
use europa_vhdl_library;
use ptf_parse; # good old fashioned ptf parser that works.

my $copyright_string = <<END_OF_COPYRIGHT_STRING;
Copyright (C) 1991-2003 Altera Corporation
Any megafunction design, and related net list (encrypted or decrypted),
support information, device programming or simulation file, and any other
associated documentation or information provided by Altera or a partner
under Altera's Megafunction Partnership Program may be used only to
program PLD devices (but not masked PLD devices) from Altera.  Any other
use of such megafunction design, net list, support information, device
programming or simulation file, or any other related documentation or
information is prohibited for any other purpose, including, but not
limited to modification, reverse engineering, de-compiling, or use with
any other silicon devices, unless such use is explicitly licensed under
a separate agreement with Altera or a megafunction partner.  Title to
the intellectual property, including patents, copyrights, trademarks,
trade secrets, or maskworks, embodied in any such megafunction design,
net list, support information, device programming or simulation file, or
any other related documentation or information provided by Altera or a
megafunction partner, remains with Altera, the megafunction partner, or
their respective licensors.  No other licenses, including any licenses
needed under any third party's intellectual property, are provided herein.
Copying or modifying any file, or portion thereof, to which this notice
is attached violates this copyright.
END_OF_COPYRIGHT_STRING


























sub assign_available_SLD_Node_Instance_Id 
{
  my $this  = shift;
  my $slave_name = shift or &ribbit("Which slave did you want to assign?");

  $slave_name =~ s/\s+(\S+)$/$1/;      # takes only the part after the spaces
  my $module_name = $this->_target_module_name;


  my %instance_id_slaves_hash;
  my $base_id_slaves_hash_ref =
    $this->get_module_slave_hash("SYSTEM_BUILDER_INFO/JTAG_Hub_Base_Id");


  foreach my $slave_id (sort keys %$base_id_slaves_hash_ref) {
    $instance_id_slaves_hash{$slave_id} = 
      $this->cd_in_ptf_hash($slave_id)
        ->{SYSTEM_BUILDER_INFO}->{JTAG_Hub_Instance_Id};
  }



  my $pwd = $this->__system_directory();
  my $this_ptf = $this->_system_name();
  opendir (PROJECT_DIR, "$pwd") or  
    &ribbit("Unable to open current dir $pwd to search for other ptfs");
  my @all_files = readdir PROJECT_DIR;
  my @all_ptfs = grep { /\.ptf$/i } @all_files; 
  my @other_ptfs = grep { !/^$this_ptf\.ptf$/i }  @all_ptfs;

  foreach my $other_ptf_name (sort @other_ptfs) {




    my $other_ptf = e_jtag_project->new(); 
    my $other_ptf_name_w_path =  $pwd.'/'.$other_ptf_name;



    my $a_ptf = new_ptf_from_file($other_ptf_name_w_path);
    my $child_count = get_child_count($a_ptf,"SYSTEM");
    if($child_count != 1)
    {
      next;
    }






    eval {
      $other_ptf->ptf_file($other_ptf_name_w_path);
    };
    my $above_errors = $@;

    if ($above_errors) {
      print ("JTAG Instance auto-assignment: Abandoning effort to analyze".
        " $other_ptf_name_w_path.\n ".
        "  It will not be considered in automatic JTAG Instance assignment.\n");
      next;
    }  

    $other_ptf->ptf_file($other_ptf_name_w_path);
    my $other_ptf_base_id_slaves_hash_ref =
      $other_ptf->get_module_slave_hash("SYSTEM_BUILDER_INFO/JTAG_Hub_Base_Id");
    foreach my $other_ptf_slave (sort keys %$other_ptf_base_id_slaves_hash_ref)
    {
      my $slave_id = $other_ptf_name."/".$other_ptf_slave;
      $base_id_slaves_hash_ref->{$slave_id} = 
        $other_ptf_base_id_slaves_hash_ref->{$other_ptf_slave};
      $instance_id_slaves_hash{$slave_id} = 
        $other_ptf->cd_in_ptf_hash($other_ptf_slave)
          ->{SYSTEM_BUILDER_INFO}->{JTAG_Hub_Instance_Id};
    }
  }


  my $base_id = 
      $this->cd_in_ptf_hash("$module_name/$slave_name")
        ->{SYSTEM_BUILDER_INFO}->{JTAG_Hub_Base_Id};


  foreach my $slave_id (sort keys %$base_id_slaves_hash_ref) {
    if (not ($base_id_slaves_hash_ref->{$slave_id} == $base_id)) {
      delete ($base_id_slaves_hash_ref->{$slave_id});
      delete ($instance_id_slaves_hash{$slave_id});
    }
  }


  my $current_instance_id =
      $instance_id_slaves_hash{"$module_name/$slave_name"};
  defined ($current_instance_id) or 
    &ribbit("Something's wrong: unable to find current instance ID for
      $module_name/$slave_name");


  delete $instance_id_slaves_hash{"$module_name/$slave_name"};
  my %instance_ids_hash = reverse (%instance_id_slaves_hash);

  my $suggested_new_instance_id = $current_instance_id;

  if (not ($current_instance_id =~ /^\d+$/)) {
    $suggested_new_instance_id = 0;

  }
  if (($current_instance_id > 255) || ($current_instance_id < 0)) {
    &ribbit("Instance ID $suggested_new_instance_id in ".
            "$module_name/$slave_name ".
            "must be between 0 and 255, inclusive.");
  }

  if ($instance_ids_hash{$suggested_new_instance_id} ne '') {


    my $found = 0;
    for (my $i=0; $i < 256; $i++) {
      if ($instance_ids_hash{$i} eq '') {
        $suggested_new_instance_id = $i;
        $found = 1;
        last;
      }
    }
    if (! $found) {
      &ribbit("Unable to find untaken instance ID for".
              "$module_name/$slave_name");
    } else {

      print ("Warning: currently assigned JTAG instance ID ".
          "$current_instance_id for ".
          "$module_name/$slave_name is shared by ".
          $instance_ids_hash{$current_instance_id}.". ".
          "Reassigned to $suggested_new_instance_id.\n");
    }

    $this->module_ptf->{"SLAVE $slave_name"}
         ->{SYSTEM_BUILDER_INFO}->{JTAG_Hub_Instance_Id} 
        = $suggested_new_instance_id;
  } else {

  }

  return $suggested_new_instance_id ;
}












sub convert_hash_path_to_slash_path
{
  my $this = shift;
  my $path = shift;
  $path =~ s/->/\//g;
  $path =~ s/{//g;
  $path =~ s/}//g;
  return $path;
}









sub convert_slash_path_to_hash_path
{
  my $this = shift;
  my $path = shift;
  my @path_list =~ split /\//, $path;
  @path_list = map {"{$_}"} @path_list; 
  $path = join '->', @path_list;
  return $path;
}




sub compare_ptf_paths
{
  my $this = shift;
  my $path1 = shift;
  my $path2 = shift;

  my $hash1 = $this->spaceless_system_ptf(); 
  my $hash2 = $this->spaceless_system_ptf(); 

  $path1 = $this->convert_hash_path_to_slash_path ($path1);
  $path2 = $this->convert_hash_path_to_slash_path ($path2);

  my @path1_list = split /\//, $path1; 
  my @path2_list = split /\//, $path2; 

  my $element1;
  my $element2;
  
  do {
    $element1 = shift @path1_list  || last;
    $element2 = shift @path2_list  || last;
    $hash1 = $this->cd_in_ptf_hash($element1, $hash1, 1);  # undef in DNE
    $hash2 = $this->cd_in_ptf_hash($element2, $hash2, 1);
  } while ((ref($hash1) eq 'HASH') && (ref($hash2) eq 'HASH'));






  if ($element1 eq $element2) { return 1; } 
  return 0;

}
















sub cd_in_ptf_hash
{
  my $this = shift;
  my $slash_delimited_path = shift || &ribbit("cd to where?");
  my $pwd = shift ;
  defined ($pwd) or $pwd = $this->spaceless_system_ptf(); # default. 
  my $return_undef_on_error = shift || 0;


  my @constant_list = ('MODULE', 'MASTER', 'SLAVE'); 

  my $return_hash = $pwd;


  foreach my $const (@constant_list) {
    $slash_delimited_path =~ s/$const\s+/$const\//g;
  }
  my @path_chain = split (/\//,$slash_delimited_path);


  while (my $path = shift (@path_chain))    # an ordered foreach
  {


    if (ref ($return_hash) eq 'HASH') {
      if (defined($return_hash->{$path}) ) {

        $return_hash = $return_hash->{$path};
      } else {

        my $found = 0;
        foreach my $const (@constant_list) {
          my $new_subpath = $return_hash->{$const}->{$path};
          if (defined ($new_subpath) && (ref ($new_subpath) eq 'HASH')) {
              $return_hash = $new_subpath;
              $found = 1;
              last;
          }
          $new_subpath = $return_hash->{"$const $path"};
          if (defined ($new_subpath) && (ref ($new_subpath) eq 'HASH')) {
              $return_hash = $new_subpath;
              $found = 1;
              last;
          }
        }
        if (!$found) {
          if ($return_undef_on_error)  {
            return undef;
          } else {
            &ribbit("You asked me to CD in the PTF to $pwd,".
                    " but that doesn't exist in hash ($pwd)");
          }
        }
      }
    } else {   # not a hash
      if ($return_undef_on_error)  {
        return undef;
      } else {
        &ribbit("You asked me to CD in the PTF to $pwd,".
                 " but ($path) doesn't exist in hash ($pwd)");
      }
    }
  }
  return $return_hash;
}














sub is_assignment_unique 
{
  my $this  = shift;
  my $key_path = shift or &ribbit("Which key did you want to search for?");
  my $assignment = shift; 
  &ribbit("Which assignment did you want to verify?")
    if (!defined ($assignment));


  my $modules_list = shift || keys (%{$this->spaceless_system_ptf()->{MODULE}});



  $key_path = $this->convert_hash_path_to_slash_path($key_path);

  $key_path =~ m/(.*)\/(\S+?)$/;
  my $path_without_key = $1;
  my $key = $2;

  foreach my $path (@$modules_list) {
    my $path_in_slash_form = $this->convert_hash_path_to_slash_path($path);
    next if $this->compare_ptf_paths($path_without_key, $path_in_slash_form);




    my $one_level_hash = $this->cd_in_ptf_hash ($path_in_slash_form) ;
    my $this_module_assignment = $one_level_hash->{$key};

    return 0 if ($this_module_assignment eq $assignment);
  }
  return 1;
}

1;
