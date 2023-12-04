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





=head1 NAME

e_ptf - description of the module goes here ...

=head1 SYNOPSIS

The e_ptf class implements ... detailed description of functionality

=head1 METHODS

=over 4

=cut

package e_ptf;
use e_object;
@ISA = ("e_object");
use strict;
use format_conversion_utils;
use europa_utils;








my %fields = (
              _array   => [],
              ptf_file => undef,
              );

my %pointers = (
                ptf_hash => {},
                spaceless_ptf_hash => {},
               );



=item I<new()>

Object constructor

=cut

sub new 
{
   my $this = shift;
   my $self = bless e_object->new(), "e_ptf";

   $self->_common_member_setup (\%fields, \%pointers);

   $self->set(@_);
   return $self;
}



=item I<ptf_file()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ptf_file
{
   my $this = shift;
   my $file = $this->SUPER::ptf_file(@_);
   if (@_)
   {
      my $infile = shift;
      return $file if $infile eq "";

      $this->ptf_hash($infile);
      $this->make_spaceless_ptf_hash($infile);
   }
   return ($file);
}



=item I<_exclusive_number()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _exclusive_number
{
   my $this = shift;
   my $hash_ref = shift;
   my $last_number = shift || 0;

   while ($hash_ref->{$last_number})
   {
      $last_number++;
   }
   $hash_ref->{$last_number}++;

   
   return ($last_number);
}



=item I<_transform_to_eval_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _transform_to_eval_string
{
   my $this = shift;
   my ($ptf_string, $doit_spaceless) = (@_);

   $ptf_string = $this->_doctor_incoming_ptf_file_string ($ptf_string);


   my $quote_string = $ptf_string;
   my $quote_number = 0;

   while ($quote_string =~ s/^(.*?[^\\]\")/a/s)
   {
      $quote_number++;
   }
   (($quote_number % 2) == 0) or &ribbit 
       ($this->ptf_file(),
        " uneven number of \"s ($quote_number) in ptf_string\n");

   my $exclusive_name;
   my %replacement_name;
   map {$exclusive_name->{$_}++} ($ptf_string =~ /\"(\d+)\"/g);

   my $number = $this->_exclusive_number($exclusive_name);
   while ($ptf_string =~ s/(\".*?[^\\]?\")/ $number /s)
   {
      $replacement_name{$number} = $1;
      $number = $this->_exclusive_number($exclusive_name);
   }









   $ptf_string =~ s/\s*([^\;\{\}]+\s*\=\s*\".*?\"\s*)\;/q\($1\),/sg;
   $ptf_string =~ s/\s*([^\;\{\}]+\s*\=\s*[^\"]*?\s*)\;/q\($1\),/sg;


   $ptf_string =~ s/\bREM\b//sg;

   if ($doit_spaceless) {


      $ptf_string =~ s/\b([^\=\s\;\{\}\"]+)\s+([^\=\s\;\{\}\"]+)\s*\{/q\($1\), q\($2\) \{/sg;
   } else {


      $ptf_string =~ s/\b([^\=\s\;\{\}\"]+)\s+([^\=\s\;\{\}\"]+)\s*\{/q\($1 $2\) \{/sg;
   }


   $ptf_string =~ s/\{/\,\[/g;
   $ptf_string =~ s/\}/\],/g;


   foreach my $replace_this (keys (%replacement_name))
   {
      my $value = $replacement_name{$replace_this};
      $ptf_string =~ s/\s$replace_this\s/$value/;
   }
   return $ptf_string;
}



=item I<ptf_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ptf_hash
{
   my $this  = shift;





   if (scalar (@_)  && (ref ($_[0]) eq ""))  
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

         if ($@)
         {
            map {s/\(eval \d+\)/\($ptf_file\)/sg} $@;
            my $death_string = $@;
            my $error_file = $ptf_file;
            if ($error_file =~ s/\.ptf$/.error_log/)
            {
               if (open (ERRORFILE,">$error_file"))
               {
                  print ERRORFILE $ptf_string;
                  print ERRORFILE "#$death_string";
                  close (ERRORFILE);
               }
            }
            die ($death_string);
         }
      }
      $this->_array($ptf);

      my %root;
      my $ptf_hash = \%root;
      $this->SUPER::ptf_hash($ptf_hash);
      $this->_put_array_in_ptf_hash($ptf,
                                    $ptf_hash);

      return ($this->SUPER::ptf_hash());
    } else {

      return ($this->SUPER::ptf_hash(@_));
    }
}






















=item I<make_spaceless_ptf_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

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

      return ($this->SUPER::spaceless_ptf_hash());
    } else {

      return ($this->SUPER::ptf_hash(@_));
    }
}



















=item I<_doctor_written_ptf_values()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _doctor_written_ptf_values
{
    my $this = shift;
    my $assignment_name = shift;
    my $original_value  = shift;

    &ribbit ("Two arguments required") 
        if $assignment_name eq "" && $original_value eq "";

    return $original_value;
}















=item I<_doctor_incoming_ptf_file_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub _doctor_incoming_ptf_file_string
{
   my $this = shift;
   my $raw_file_string = shift;
   return $raw_file_string;
}



=item I<_skip_down_ptf_path()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

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



=item I<_put_array_in_ptf_hash()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

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
	   if ($thing =~ /^\s*(\w+)\s*\=\s*\"(.*?)\"/s)
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



=item I<ptf_to_string()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

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



=item I<ptf_to_file()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub ptf_to_file
{
   my $this = shift;
   my $ptf_hash = shift || $this->ptf_hash();
   my $file = shift || $this->ptf_file();

   return if (!$file);
   open (FILE, "> $file") or die
       ("Could not open file, or write-protected file ($file)($!)\n");


   binmode (FILE);

   print FILE $this->ptf_to_string($ptf_hash);
   close (FILE);
}




























   








=item I<ptf_type_children()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

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









=item I<spaceless_system_ptf()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

sub spaceless_system_ptf
{
   my $this = shift;

   my @systems = keys (%{$this->spaceless_ptf_hash()->{SYSTEM}});
   (@systems == 1) or &ribbit ("too many systems (@systems)\n");

   my $ptf_section = $this->spaceless_ptf_hash()->{SYSTEM}
   {$systems[0]} or &ribbit ("no system");
   return ($ptf_section);
}













=item I<Create_Dat_Files()>

method description goes here...
...remember: there must be a newline around each POD tag (e.g. =item, =cut etc)!

=cut

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



    if (@slaves != 1)
    {
      dwarn(
        "Module '$mod_name' has multiple slaves.  " .
        "Simulation dat files may be incorrect.\n"
      );
    }

    my $num_lanes;
    my $num_banks;
    my $width;
    my $address_base;
    my $address_width;
    
    for (@slaves)
    {
      my $slave_hash = $module_spaceless_hash->{SLAVE}->{$_};
      next if (!$slave_hash);

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
      dwarn(
        "Can't find contents file '$contents_file' for module '$mod_name'; " .
        "Not creating simulation .dat file.\n");
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


1; # One, I say.

=back

=cut

=head1 EXAMPLE

Here is a usage example ...

=head1 AUTHOR

Santa Cruz Technology Center

=head1 BUGS AND LIMITATIONS

list them here ...

=head1 SEE ALSO

The inherited class e_object

=begin html

<A HREF="e_object.html">e_object</A> webpage

=end html

=head1 COPYRIGHT

Copyright (C)2001-2005 Altera Corporation, All rights reserved.

=cut

1;
