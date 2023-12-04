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






















package europa_translato;
require Exporter;
@ISA = Exporter;
@EXPORT = qw(Translate_Verilog_Files_To_Europa
             Translate_Verilog_String_To_Europa);

use europa_all;
use strict;

my $e_mod;
sub Translate_Verilog_Files_To_Europa
{
   my $e_proj = shift;
   my $string;

   foreach my $file (@_)
   {
      open (FILE, "< $file") or &ribbit 
          ("cannot open file $file ($!)\n");
      $string .= join ("\n",<FILE>);
   }
   return &Translate_Verilog_String_To_Europa($string);
}

sub Translate_Verilog_String_To_Europa
{
   my $e_proj = shift;
   my $string = shift;


   $string =~ s|\/\*.*?\*\/||sg;
   $string =~ s|\/\/.*?$||mg;
   $string = &handle_definitions($string);

   my @modules = ($string =~ /(\bmodule\b\s*.*?\s*\bendmodule)/sg);
   foreach my $module (@modules)
   {
      &handle_module($module,$e_proj);
   }
}

sub HDL_Count_Parentheses
{
    my ($string,$begin_match,$end_match) = @_;
    my $begin_string;
    my $paren_string;
    my $end_string;
    my $begin_match_default = '\s*\(\s*';
    my $end_match_default   = '\s*\)\s*';
    $begin_match = $begin_match_default unless ($begin_match);
    $end_match   = $end_match_default unless ($end_match);

    return("","","$string")
	unless ($string =~ /^(.*?)$begin_match(.*)$/s);

    $begin_string = $1;

    my $paren_count = 1;
    $end_string = $2;

    while ($end_string =~ s/^(.*?)($begin_match|$end_match)(.*)$/$3/s)
    {
	my $match;
	$match = $2;
	$paren_string .= $1;

	if ($match =~ /$begin_match/)
	{
	    $paren_count++;
	}
	else
	{
	    $paren_count = $paren_count - 1;
	}

	last if ($paren_count == 0);

	$paren_string .= $match;
    }

    &ribbit ("mismatched $begin_match,$end_match in string
    $begin_string$paren_string$end_string")
        if ($paren_count != 0);

    return ($begin_string,$paren_string,$end_string);
}

sub handle_module
{
   my $module = shift or &ribbit ("no module");
   my $e_proj = shift or &ribbit ("no project");


   $module =~ s/(\W)\s*(\w)/$1$2/sg;
   $module =~ s/(\w)\s*(\W)/$1$2/sg;
   $module =~ s/(\w)\s+(\w)/$1 $2/sg;

   $module =~ s/^\s*module\s+(\w+).*?\;(.*?)\s*endmodule/$2/s;
   $e_mod = e_module->new({name => $1});
   $e_proj->add_module($e_mod);


   $module = &handle_parameters($module);
   my $i = 1;
   while ($module)
   {
      $module = &handle_ports       ($module);
      $module = &handle_signals     ($module);
      $module = &handle_assignments ($module);
      $module = &handle_always      ($module);

      $i++;
   }
}

sub handle_parameters
{
   my $module = shift or &ribbit ("no module");
   my $begin_command = '\sbegin\s|\send\s|;';
   while (($module =~ s/($begin_command)parameter\s(.*?)\;/$1/s) ||
          ($module =~ s/^\s*parameter\s(.*?)\;//s))
   {
      foreach my $parameter (split (/,/,$2))
      {
         my ($lhs,$rhs) = ($parameter =~ /(\w+)\s*\=\s*(\S+)/s);
         $module =~ s/\b$lhs\b/$rhs/g;
      }
   }
   return ($module);
}

sub handle_definitions
{
   my $string = shift or &ribbit ("no string");
   while ($string =~ s/^\s*\`define\s*(\w+)\s+(\S*)\s*$//m)
   {
      my ($lhs,$rhs) = ($1,$2);
      $string =~ s/\`$lhs\b/$rhs/sg;
   }
   return $string;
}

sub handle_ports
{
   my $module = shift or return;
   if ($module =~
       s/^(input|output|inout)(\[(.*?)\])?(.*?)\;//s)
   {
      my ($direction,$bracket,$index,$names) = ($1,$2,$3,$4);

      my $width = $index;
      if ($index)
      {
         my ($left,$right) = map {eval($_)} split(/:/,$index);
         ($right ne "") || ($right == 0) or &ribbit ("illegal value $right");
         $left > $right or &ribbit ("illegal value ($left:$right)");
         $width = ($left - $right) + 1;
      }
      else
      {
         $width = 1;
      }
      map
      {e_port->new([$_,$width,$direction])->within($e_mod)}
      split (/\,/,$names);
   }
   return ($module);
}

sub handle_signals
{
   my $module = shift or return;
   if ($module =~
       s/^(reg|wire)(\[(.*?)\])?\s*(.*?)\;//sx)
   {
      my ($direction,$bracket,$index,$names) = ($1,$2,$3,$4);

      my $width = $index;
      if ($index)
      {
         my ($left,$right) = map {eval($_)} split(/:/,$index);
         ($right ne "") || ($right == 0) or &ribbit ("illegal value $right");
         $left > $right or &ribbit ("illegal value ($left:$right)");
         $width = ($left - $right) + 1;
      }
      else
      {
         $width = 1;
      }

      map
      {
         e_signal->new([$_,$width])->within($e_mod);
      } split (/\,/,$names);
   }
   return $module;
}

sub handle_assignments
{
   my $module = shift or return;
   if ($module =~ s/^assign\s?(.*?)\=(.*?)\;//s)
   {
      e_assign->new([$1,$2])->within($e_mod);
   }
   return $module;
}

sub handle_always
{
   my $module = shift or return;
   if ($module =~ /^\s*always\@(.*?;)(.*)/s)
   {
      my $process = e_process->new();
      $process->within($e_mod);

      my $guts; my $rest; my $junk; my $always_at;
      ($guts,$rest) = ($1,$2);
      ($junk,$always_at,$guts) = &HDL_Count_Parentheses($guts);
      ($junk,$guts,$rest)      = &HDL_Count_Parentheses
          ("$guts$rest","begin","end");
      $module = $rest;

      if ($guts =~ s/^\s*if//)
      {
         my $if;
         my $condition;
         ($if,$condition,$rest) = &HDL_Count_Parentheses($guts);
         ($if eq "") or &ribbit ("I'm confused ($if)");
         my $asynchronous_stuff;
         my ($junk,$asynchronous_stuff,$synchronous_stuff) = 
             &HDL_Count_Parentheses ($guts,"begin","end");
         
         $process->asynchronous_contents([&handle_always_guts
                                          ($asynchronous_stuff)]);

         if ($synchronous_stuff =~ s/^\s*else\s*//s)
         {
            my $foo;
            my $else;
            ($foo,$else,$guts) = &HDL_Count_Parentheses
             ($synchronous_stuff,"begin","end");
            ($foo eq "") or &ribbit ("I'm confused ($foo)\n");
            $process->contents([&handle_always_guts
                                ($else)]);
         }
      }
      else
      {
         &ribbit("sorry, you must have an if statement within an ",
                 "always block");
      }
   }

   return $module;
}

sub handle_always_guts
{
   my ($guts) = @_;

   my @stuff;
   my $foo;
   while ($guts !~ /^\s*$/s)
   {
      if ($guts =~ s/^\s*if//s)
      {
         my $if = e_if->new({});
         my $condition;
         ($foo,$condition,$guts) = 
             &HDL_Count_Parentheses($guts);
         $if->condition($condition);

         my $then;
         ($foo,$then,$guts) = &HDL_Count_Parentheses
             ($guts,"begin","end");
         $if->then([&handle_always_guts($then)]);

         if ($guts =~ s/^\s*else//s)
         {
            my $else;
            ($foo,$else,$guts) = &HDL_Count_Parentheses
             ($guts,"begin","end");
            $if->else([&handle_always_guts($else)]);
         }
         push (@stuff, $if);
      }
      elsif ($guts =~ s/^\s*([^;]+)\<\=\s*(.*?)\s*;\s*//s)
      {
         push (@stuff , e_assign->new([$1,$2]));
      }
   }
   return (@stuff);
}

1;
