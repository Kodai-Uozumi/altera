#Copyright (C)2001-2003 Altera Corporation
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







sub Build_Hash_From_Table
{
   my $table = shift or die "ERROR Build_Hash_From_Table: no table
specified\n";

   my %Hash;

   $table =~ s/\#.*$//mg;   #crush comments
   $table =~ s/^\s*\n//mg;  #crush extra new lines
   #$table =~ s/^\s*(.*?)\s*$/$1/mg;  #crush end and begin spaces

   my @line_array = split (/\n/,$table);

   #first line is keys for rest of array
   my $old_first_line = shift (@line_array);
   my $first_line = $old_first_line;

   #convert spaces between words to underscores
   $first_line =~ s/(\w)\s+(\w)/$1\_$2/g;

   my @key_array = split (/\|/,$first_line);

   #second_line is dividing line, check to see no words live there
   my $second_line = shift (@line_array);
   die "Build_Hash_From_Table, second line should be dividing line and
   is not allowed to have words in it"
       if ($second_line =~ /\w/);

   foreach $line (@line_array)
   {
      $line .= " "; # add space so splitting \|\n gives us the right
                    # size of array.
       
      my @tmp_key_array = @key_array;
      my @value_array = split (/\|/,$line);

      my $value_size = scalar(@value_array);
      my $key_size   = scalar(@key_array);

      die ("ERROR Build_Hash_From_Table, line\n($line)($value_size)\n".
           "splits to a different size than first line\n".
           "($old_first_line)($key_size)\n")
          if ($value_size != $key_size);


      #First column is hash index.
      my $first_hash_index = shift (@value_array);
      $first_hash_index =~ s/^\s*(.*?)\s*$/$1/;
      shift (@tmp_key_array);
      #All other columns are added under hash index
      foreach $value (@value_array)
      {
         my $name = shift (@tmp_key_array);
         $value =~ s/^\s*(.*?)\s*$/$1/;
         $name =~ s/^\s*(.*?)\s*$/$1/;
         $Hash{$first_hash_index}{$name} = $value;
      }
   }      
   return (\%Hash);
}

sub Get_Table_Row_Names
{
   my $hash = shift or die "ERROR Get_Table_Row_Names, no hash specified\n";
   
   die "TYPE MISMATCH ERROR Get_Table_Row_Names, ref hash is (".ref($hash).")\n".
       "Not (HASH)\n"
           if (ref($hash) ne "HASH");
   return (keys %$hash);
}

sub Get_Table_Column_Names
{
   my $hash = shift or die "ERROR Get_Table_Column_Names, no hash specified\n";
   
   die "TYPE MISMATCH ERROR Get_Table_Column_Names, ref hash is (".ref($hash).")\n".
       "Not (HASH)\n"
           if (ref($hash) ne "HASH");

   my @array = &Get_Table_Row_Names($hash);
   print "debug @array\n";
   my $row = shift (@array);
   print "debug $row\n";
   my @return_array = keys %{$hash->{$row}};
   print ("DEBUG @return_array DEBUG\n");
   return (@return_array);
}   
sub Get_Table_Row_Column
{
   my $hash = shift or die "ERROR Get_Table_Row_Column, no hash specified\n";
   my $row = shift or die "ERROR Get_Table_Row_Column, no Row specified\n";
   my $column = shift or die "ERROR Get_Table_Row_Column, no Column specified\n";

   return ($hash->{$row}{$column});
}

sub Get_Table_XY
{
   my ($x,$y) = @_;
   return (&Get_Table_Row_Column($y,$x));
}

sub Table_Row_Column_Is_Defined
{
   my $hash = shift or die "ERROR Table_Row_Column_Is_Defined, no hash specified\n";
   my $row = shift or die "ERROR Table_Row_Column_Is_Defined, no Row specified\n";
   my $column = shift or die "ERROR Table_Row_Column_Is_Defined, no
Column specified\n";

   return (defined($hash->{$row}{$column}));
}

sub Table_XY_Is_Defined
{
   my ($x,$y) = @_;
   return (&Table_Row_Column_Is_Defined($y,$x));
}

1;
