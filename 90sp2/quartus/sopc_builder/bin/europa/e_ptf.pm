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

























package e_ptf;
use e_object;
@ISA = ("e_object");
use strict;
use format_conversion_utils;
use europa_utils;








my %fields = (
              _array   => [],
              );

my %pointers = (
                spaceless_ptf_hash => {},
               );

&package_setup_fields_and_pointers
    (__PACKAGE__,
     \%fields, 
     \%pointers,
     );

sub ptf_file
{
   my $this = shift;
   if (@_)
   {
      my $infile = shift;
      $this->{ptf_file} = $infile;
      return $infile if $infile eq "";

      $this->ptf_hash($infile);
      $this->make_spaceless_ptf_hash($infile);
   }
   
   return $this->{ptf_file};
}

sub _transform_to_eval_string
{
   my $this = shift;
   my ($ptf_string, $doit_spaceless) = (@_);









   $ptf_string = $this->_doctor_incoming_ptf_file_string ($ptf_string);


   $ptf_string =~ s/\\\"/__PTF_EVAL_DOUBLE_QUOTE__/sg;
   $ptf_string =~ s/(\=\s*\"[^\"]*)\'([^\"]*\"\s*;)/$1\__PTF_EVAL_SINGLE_QUOTE__$2/sg;
   $ptf_string =~ s/(\=\s*\"[^\"]*);([^\"]*\"\s*;)/$1\__PTF_EVAL_SEMICOLON__$2/sg;
   $ptf_string =~ s/(\=\s*\"[^\"]*)\{([^\"]*\"\s*;)/$1\__PTF_EVAL_OPEN_BRACE__$2/sg;
   $ptf_string =~ s/(\=\s*\"[^\"]*)\}([^\"]*\"\s*;)/$1\__PTF_EVAL_CLOSE_BRACE__$2/sg;




   $ptf_string =~ s/(\w+\s*\=\s*\".*?\"\s*)\;/\'$1\',/sg;

   if ($doit_spaceless) {


      $ptf_string =~ s/\b([\w\/\.]+)\s+([\w\/\.]+)\s*\{/\'$1\', \'$2\' \{/sg;
   } else {


      $ptf_string =~ s/\b([\w\/\.]+)\s+([\w\/\.]+)\s*\{/\'$1 $2\' \{/sg;
   }


   $ptf_string =~ s/\{/\,\[/g;
   $ptf_string =~ s/\}/\],/g;


   $ptf_string =~ s/__PTF_EVAL_DOUBLE_QUOTE__/\\\"/sg;
   $ptf_string =~ s/__PTF_EVAL_SINGLE_QUOTE__/\\\'/sg;
   $ptf_string =~ s/__PTF_EVAL_SEMICOLON__/;/sg;
   $ptf_string =~ s/__PTF_EVAL_OPEN_BRACE__/{/sg;
   $ptf_string =~ s/__PTF_EVAL_CLOSE_BRACE__/}/sg;
   return $ptf_string;
}

sub ptf_hash
{
   my $this  = shift;





   if (scalar (@_))
   {
      my $ptf_hash;
      if (ref ($_[0]) eq "")
      {
         my $ptf_file = shift;
         open (FILE, "< $ptf_file")
             or &ribbit ("cannot open $ptf_file");

         my $ptf_string;
         binmode (FILE);
         while (<FILE>)
         {
            s/\#.*$//mg;  #goodbye, Mr. comment.
            $ptf_string .= $_;
         }
         close (FILE);

         $ptf_string = $this->_transform_to_eval_string ($ptf_string);
         
         $ptf_string = "\$ptf = [$ptf_string];";
         my $ptf;
         {
            no strict;
            eval ($ptf_string);
            die "eval failed on this ptf-string:\n      $ptf_string \n($@)"
                if ($@);
         }
         $this->_array($ptf);

         my %root;
         $ptf_hash = \%root;
         $this->{ptf_hash} = $ptf_hash;
         $this->_put_array_in_ptf_hash($ptf,
                                       $ptf_hash);

      }
      else
      {
         $ptf_hash = shift;
      }
      $this->{ptf_hash} = $ptf_hash;
   }
   else 
   {

      if (!defined ($this->{ptf_hash}))
      {
         $this->{ptf_hash} = {};
      }
   }
   return $this->{ptf_hash};
}




















sub make_spaceless_ptf_hash
{
   my $this  = shift;
   my $was_called_statically = ref ($this) eq ""; 
   
   if (scalar (@_)  && (ref ($_[0]) eq ""))  
   {
      my $ptf_file = shift;
      open (FILE, "< $ptf_file")
          or &ribbit ("cannot open $ptf_file");

      my $ptf_string;
      while (<FILE>)
      {


         s/\#.*$//mg;
         $ptf_string .= $_;
      }
      close (FILE);





        


        




      $ptf_string = 
          $this->_transform_to_eval_string ($ptf_string, "spaceless, please");
      $ptf_string = "\$ptf = [$ptf_string];";

      my $ptf;

      {
         no strict;
         eval ($ptf_string);
         die "eval failed ($@)"
             if ($@);
      }
      my %root;
      my $spaceless_ptf_hash = \%root;
      $this->spaceless_ptf_hash($spaceless_ptf_hash);
      $this->_put_array_in_ptf_hash($ptf,
                                    $spaceless_ptf_hash);

      return ($this->spaceless_ptf_hash());
    } else {

      return ($this->spaceless_ptf_hash(@_));
    }
}

















sub _doctor_written_ptf_values
{
    my $this = shift;
    my $assignment_name = shift;
    my $original_value  = shift;

    &ribbit ("Two arguments required") 
        if $assignment_name eq "" && $original_value eq "";

    return $original_value;
}













sub _doctor_incoming_ptf_file_string
{
   my $this = shift;
   my $raw_file_string = shift;
   return $raw_file_string;
}

sub _skip_down_ptf_path
{
    my $this = shift;
    my $ptf_hash = shift or &ribbit ("no ptf_hash");
    my $ptf_path = shift or &ribbit ("no ptf path");

    while (my $stone = shift (@$ptf_path))
    {



	if (!exists $ptf_hash->{$stone})
	{
           $ptf_hash->{$stone} = {};
	}
	$ptf_hash = $ptf_hash->{$stone};
    }
    return ($ptf_hash);
}

sub _put_array_in_ptf_hash
{
   my $this = shift;

   my $ptf_array = shift or &ribbit ("no ptf_array");

   my %hash;
   my $ptf_hash = shift || \%hash;

   my @ptf_path = ();

   foreach my $thing (@$ptf_array)
   {
       if (ref ($thing) eq "")
       {
	   if ($thing =~ /^\s*(\w+)\s*\=\s*\"(.*?)\"$/s)
	   {
	       my $tmp_ptf_hash = $this->_skip_down_ptf_path
		   (
		    $ptf_hash,
		    [@ptf_path]
		    );
	       $tmp_ptf_hash->{$1} = $2;
	   }
	   else
	   {
	       push (@ptf_path, $thing);
	   }
       }
       else
       {
	   if (ref ($thing) eq "ARRAY")
	   {
	       my $tmp_ptf_hash =
                   $this->_skip_down_ptf_path($ptf_hash,[@ptf_path]);
	       $this->_put_array_in_ptf_hash($thing,$tmp_ptf_hash);
	       @ptf_path = ();
	   }
	   else
	   {
	       &ribbit ("pretty confused here, ",ref($thing),"\n");
	   }
       }
   }
   return ($ptf_hash);
}

sub ptf_to_string
{
    my $this = shift;

    my $ptf_hash = shift; 
    my $indent = shift || "";
    my $order    = shift;

    defined ($ptf_hash) or $ptf_hash = $this->ptf_hash();
    defined ($order) or $order = $this->_array();

    my @new_order = @$order;
    my %new_hash = %$ptf_hash;

    my $next_indent = "$indent   ";

    my $string;

    if (1)#ref($new_hash) eq "HASH")
    {
       my $key;
       while ($key = shift (@new_order))#(sort (keys (%$new_hash)))
       {
          next if (ref ($key));
          my $old_key = $key;
          $key =~ s/^\s*(.*?)\s*\=.*/$1/s;
          my $value = $new_hash{$key};

          if (ref($value) eq "HASH")
          {
             my $child_order = shift(@new_order);
             if (ref ($child_order) ne "ARRAY")
	       {
		 my @new_child_order = sort (keys (%$value));

		 unshift (@new_order,$child_order);
		
		 $child_order = \@new_child_order;
	       }
             $string .= "$indent$key";
             $string .= "\n$indent\{\n";
             $string .= $this->ptf_to_string
                 ($value,$next_indent,$child_order);
             $string .= "$indent\}\n";
             delete $new_hash{$key};
          }
          elsif (exists $new_hash{$key})
          {
             $string .= "$indent$key";
             my $doctored_value = 
                 $this->_doctor_written_ptf_values ($key, $value);
             $string .= " = \"$doctored_value\"\;\n";
             delete $new_hash{$key};
          }
	  else
	    {
	      delete $new_hash{$key};
	    }
       }




       my @remaining = sort (keys (%new_hash));
	if (@remaining)
	{
       	  $string .= $this->ptf_to_string
          (\%new_hash,$indent,\@remaining);
        }
               
    }
    else
    {

    }
    return ($string);
}

sub ptf_to_file
{
   my $this = shift;
   my $ptf_hash = shift || $this->ptf_hash();
   my $file = shift || $this->ptf_file();

   return if (!$file);
   open (FILE, "> $file") or &ribbit 
       ("Could not open file, or write-protected file ($file)($!)\n");


   binmode (FILE);

   print FILE $this->ptf_to_string($ptf_hash);
   close (FILE);
}




























   






sub ptf_type_children
{
    my $this = shift;
    my $type = shift or &ribbit ("no type");
    my $ptf_hash = shift; 

    defined ($ptf_hash) or $ptf_hash = $this->ptf_hash();

    my $hash;
    foreach my $key (keys (%$ptf_hash))
    {
       next unless ($ptf_hash->{$key} =~ /^$type\s+(\w+)/i);
       $hash->{$1} = $ptf_hash->{$key};
    }
    return ($hash);
}







sub spaceless_system_ptf
{
   my $this = shift;

   my @systems = keys (%{$this->spaceless_ptf_hash()->{SYSTEM}});
   (@systems == 1) or &ribbit ("expected exactly 1 system; got @{[0 + @systems]}\n");

   my $ptf_section = $this->spaceless_ptf_hash()->{SYSTEM}
   {$systems[0]} or &ribbit ("no system");
   return ($ptf_section);
}











sub Create_Dat_Files
{
  my $this   = shift;
  my $sysdir = shift or &ribbit ("No sysdir");
  my $simdir = shift or &ribbit ("No simdir.");
  &ribbit ("Too many arguments") if @_;



  my $sys_hash = $this->spaceless_system_ptf();

  foreach my $mod_name (keys(%{$sys_hash->{MODULE}}))
  {

    my $module_spaceless_hash = $sys_hash->{MODULE}{$mod_name};


    next if (!$module_spaceless_hash->{SYSTEM_BUILDER_INFO}->{Is_Enabled});


    next if (!$module_spaceless_hash->{WIZARD_SCRIPT_ARGUMENTS}->{CONTENTS});
    



    my @slaves = keys %{$module_spaceless_hash->{SLAVE}};
    next unless (scalar(@slaves) > 0); 

    my $num_lanes;
    my $num_banks;
    my $width;
    my $address_base;
    my $address_width;
    
    for (@slaves)
    {
      my $slave_hash = $module_spaceless_hash->{SLAVE}->{$_};
      next if (!$slave_hash);
      next if ($slave_hash->{SYSTEM_BUILDER_INFO}{Is_Enabled} eq '0');

      $width = $slave_hash->{SYSTEM_BUILDER_INFO}->{Data_Width};
      $address_base =
        eval($slave_hash->{SYSTEM_BUILDER_INFO}->{Base_Address});
      $address_width = $slave_hash->{SYSTEM_BUILDER_INFO}->{Address_Width};


      $num_lanes = $slave_hash->{SYSTEM_BUILDER_INFO}->{Simulation_Num_Lanes};
      $num_banks = $slave_hash->{SYSTEM_BUILDER_INFO}->{Simulation_Num_Banks};
      
      my $slave_hash_ports = $slave_hash->{PORT_WIRING}->{PORT};
      next if (!$slave_hash_ports);

      if (!$num_lanes)
      {

        for (keys %$slave_hash_ports)
        {
          my $last_hash = $slave_hash_ports->{$_};
          if ($slave_hash_ports->{$_}->{type} =~ /byteenable/)
          {
            $num_lanes = $slave_hash_ports->{$_}->{width};
          }
        }
      }
      

      if (!$num_banks)
      {
        $num_banks = 1;
      }
    }
    
    my $byte_address_width = $address_width + log2(ceil($width / 8));
    my $mem_size_in_bytes = 2**$byte_address_width;



    my $contents_file = $mod_name . "_contents.srec";
    my $full_contents_file_path =
      $sysdir . "/" . $contents_file;
      
    if (!-e $full_contents_file_path)
    {




      next;
    }


    






    
    my @mif_files = ();
    if ($module_spaceless_hash->{class} eq "altera_avalon_onchip_memory")
    {


      my $file_pat = $mod_name . ".*\.mif";
      


      if (!opendir DIR, $sysdir)
      {
        dwarn("Unexpected: can't open directory '$sysdir'");
        next;
      }
      
      my @files = readdir DIR;
      push @mif_files, (grep /^$file_pat$/, @files);
      
      closedir DIR;
    }
    else
    {





      






      


      
      if ($num_lanes == 1 and $num_banks == 1)
      {
        my $mif_file = $mod_name . ".mif";


        fcu_convert({
          "0"      => $full_contents_file_path,
          "1"      => $mif_file,
          oformat  => "mif",
          width    => $width,
        });

        push @mif_files, $mif_file;
      }
      elsif ($num_banks == 1)
      {

        for (0 .. $num_lanes - 1)
        {
          my $mif_file = $mod_name . "_lane$_.mif";


          fcu_convert({
            "0"      => $full_contents_file_path,
            "1"      => $mif_file,
            lane     => $_,
            lanes    => $num_lanes,
            width    => 8,
            oformat  => "mif",
          });

          push @mif_files, $mif_file;
        }
      }
      elsif ($num_lanes == 1)
      {

        my $cur_base = $address_base;
        my $bank_size = $mem_size_in_bytes / $num_banks;
        for my $bank (0 .. $num_banks - 1)
        {
          my $mif_file = $mod_name . "_bank$bank.mif";
        

          fcu_convert({
            "0"      => $full_contents_file_path,
            "1"      => $mif_file,
            width    => $width,
            oformat  => "mif",
            address_low  => $cur_base,
            address_high => $cur_base + $bank_size - 1,
          });
          $cur_base += $bank_size;

          push @mif_files, $mif_file;
        }
      }
      else
      {

        dwarn("Unimplemented: multiple banks, multiple lanes.\n");
      }
    }
    

    for my $mif_file (@mif_files)
    {
      my $dat_file;
      ($dat_file = $mif_file) =~ s/\.mif$/.dat/;




      my $dat_width;
      if (open MIF, $mif_file)
      {
        while (<MIF>)
        {
          if (/WIDTH\s*=\s*(\d+);$/)
          {
            $dat_width = $1;
            last;
          }
        }
        close MIF;
      }
      else
      {
        dwarn("Warning: can't open mif file '$mif_file'\n");
      }

      $dat_width = 16 unless $dat_width;

      $dat_file = $simdir . "/" . $dat_file;

      fcu_convert({
        "0"      => $mif_file,
        "1"      => $dat_file,
        oformat  => "dat",
        width    => $dat_width,
      });
    }

  }
}






sub get_module_slave_hash 
{
   my $this = shift;
   my $slash_delimited_path = shift;

   my @paths;

   if (ref($slash_delimited_path) eq "ARRAY") 
   {
        @paths = @$slash_delimited_path;
   } 
   else 
   {
        @paths = split (/\//s,$slash_delimited_path);
   }

   my $spaceless_system = $this->spaceless_system_ptf();

   my $return_hash;
   my $modules = $spaceless_system->{MODULE};


   foreach my $module_name (keys %$modules)
   {
      my $module_ptf = $modules->{$module_name};
      next if ($module_ptf->{SYSTEM_BUILDER_INFO}{Is_Enabled} eq '0');


      my $slaves = $module_ptf->{SLAVE};
      foreach my $slave_name (keys %{$slaves})
      {
         my $slave_ptf = $slaves->{$slave_name};
         next if ($slave_ptf->{SYSTEM_BUILDER_INFO}{Is_Enabled} eq '0');         

         my $return_hash_value = $slave_ptf;
         foreach my $path (@paths)
         {
            $return_hash_value = $return_hash_value->{$path};
         }

         $return_hash->{$module_name.'/'.$slave_name} = $return_hash_value;
      }
   }
   return $return_hash;
}






sub get_module_hash 
{
   my $this = shift;
   my $slash_delimited_path = shift;

   my @paths = split (/\//s,$slash_delimited_path);

   my $spaceless_system = $this->spaceless_system_ptf();

   my $return_hash;
   my $modules = $spaceless_system->{MODULE};


   foreach my $module_name (keys %$modules)
   {
      my $module_ptf = $modules->{$module_name};
      next if ($module_ptf->{SYSTEM_BUILDER_INFO}{Is_Enabled} eq '0');

      my $return_hash_value = $module_ptf;
      foreach my $path (@paths)
      {
         $return_hash_value = $return_hash_value->{$path};
      }

      $return_hash->{$module_name} = $return_hash_value;
   }
   return $return_hash;
}


sub system_ptf{
    my $this = shift;
    my $hash = $this->ptf_hash();
    my ($system_name) = keys(%{$this->spaceless_ptf_hash()->{SYSTEM}});
    my $system_ptf = $hash->{"SYSTEM $system_name"};
    return $system_ptf;
}


sub get_paths_which_contain_name
{
   my $this = shift;
   my ($name_to_find, $ptf_hash, $array_path) = @_;

   $ptf_hash = $ptf_hash || $this->ptf_hash();
   $array_path = $array_path || [];
   my @return_array;

   foreach my $key (sort keys (%$ptf_hash))
   {
      my $value = $ptf_hash->{$key};
      my @current_path = (@$array_path, $key);
      if (ref ($value) eq 'HASH')
      {
         my @paths = $this->get_paths_which_contain_name
               ($name_to_find, $value, \@current_path);
         
         if (@paths){push (@return_array, @paths)}
      }
      else{
          if ($key eq $name_to_find){
            push (@return_array ,[@current_path]);
          }
      }
   }
   return @return_array;
}

sub set_value_by_path
{
   my $this = shift;
   my $path  = shift;
   my $value = shift;
   my $ptf_hash = shift;

   if (ref ($path) eq 'HASH')
   {
      my $tmp_hash = $path;
      $path        = $tmp_hash->{path};
      $value       = $tmp_hash->{value};
      $ptf_hash    = $tmp_hash->{ptf_hash};
   }

   my $hash = $ptf_hash || $this->ptf_hash();
   
   my $last_stone = pop (@$path);
   foreach my $stone (@$path)
   {
      $hash = $hash->{$stone};
   }

   $hash->{$last_stone} = $value;
}

sub get_value_by_path
{
   my $this = shift;
   my $path  = shift;
   my $value = shift;
   my $ptf_hash = shift;

   if (ref ($path) eq 'HASH')
   {
      my $tmp_hash = $path;
      $path        = $tmp_hash->{path};
      $value       = $tmp_hash->{value};
      $ptf_hash    = $tmp_hash->{ptf_hash};
   }

   my $hash = $ptf_hash || $this->ptf_hash();
   
   foreach my $stone (@$path)
   {
      $hash = $hash->{$stone};
   }


   return $hash;
}


1; # One, I say.
