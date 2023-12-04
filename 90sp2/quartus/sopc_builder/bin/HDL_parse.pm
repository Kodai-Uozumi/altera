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

package HDL_parse;
require Exporter;
@ISA = Exporter;
@EXPORT = qw(HDL_Get_Module_Info_From_File
             HDL_Get_Module_Info_From_Files);

use europa_utils;
sub HDL_Match_Keyword
{
    my @KeyWords = ("abs", "access", "after", "alias", "all", "always", "and", "architecture",
         "array", "assert", "assign", "attribute", "attribute", "begin", "block", "body",
         "buf", "buffer", "bufif0", "bufif1", "bus", "case", "casex", "casez",
         "cmos", "configuration", "conponent", "constant", "deassign", "default", "defparam",
	 "disable", "disconnect", "downto", "edge", "else", "elsif", "end", "endattribute",
	 "endcase", "endfunction", "endmodule", "endprimitive", "endspecify", "endtable",
	 "endtask", "entity", "event", "exit", "file", "for", "force", "forever", "fork",
	 "function", "generate", "generic", "group", "guarded", "highz0", "highz1", "if",
	 "impure", "in", "inertial", "initial", "inout", "input", "integer", "is", "join", "label",
         "large", "library", "linkage", "literal", "loop", "macromodule", "map", "medium",
         "mod", "module", "nand", "negedge", "new", "next", "nmos", "nor",
         "not", "notif0", "notif1", "null", "of", "on", "open", "or",
         "others", "out", "output", "package", "parameter", "pmos", "port", "posedge",
         "postponed", "primitive", "procedure", "process", "pull0", "pull1", "pulldown", "pullup",
         "pure", "range", "record", "reg", "register", "reject", "release", "rem",
         "repeat", "report", "return", "rnmos", "rol", "ror", "rpmos", "rtran",
         "rtranif0", "rtranif1", "scalared", "select", "severity", "shared", "signal", "signed",
         "sla", "sll", "small", "specify", "specparam", "sra", "srl", "strength",
         "strong0", "strong1", "subtype", "supply0", "supply1", "table", "task", "then",
         "time", "to", "tran", "tranif0", "tranif1", "transport", "tri", "tri0",
         "tri1", "triand", "trior", "trireg", "type", "unaffected", "units", "unsigned",
         "until", "use", "variable", "vectored", "wait", "wand", "weak0", "weak1",
         "when", "while", "wire", "with", "wor", "xnor", "xor");

    my $name = shift;

    foreach $word (@KeyWords)
    {
        return (1) if ($word eq $name);
    }
    return (0);
}

######################################################################
# these files should really be in some util module
sub HDL_Display_Hash
{
   my (%h) = @_;

   goldfish "displaying hash";
   foreach $a (keys (%h))
   {
      warn "$a -> $h{$a}\n";
   }
}

sub HDL_Read_File
{
   my $file = shift or ribbit "no file specified\n";
   open (FILE,"<$file") or ribbit "cannot open file ($file) ($!)\n";
   my $return_string;
   while (<FILE>)
   {
      $return_string .= $_;
   }
   close (FILE);
   return($return_string);
}

sub HDL_Write_File
{
   my $file = shift or ribbit "no file specified\n";
   my $string = shift or ribbit "no string specified\n";

   open (FILE,">$file") or ribbit "cannot open file ($file) ($!)\n";
   print FILE $string;
   close (FILE);
}
# these files should really be in some util module
######################################################################

######################################################################
# HDL_Remove_Comments
#
# removes comments from an entire string depending on language
# specified
######################################################################
sub HDL_Remove_Comments
{
   my $string = shift or ribbit "no string specified\n";
   my $language = shift or "verilog";

   if (($language =~ /verilog/i) || ($language =~ /bdf|bsf/i))
   {
      $string =~ s|\/\*.*?\*\/||gs;
      $string =~ s|\/\/.*$||gm;
      # also remove verilog `include statements
      if ($language =~ /verilog/i)
      {
         $string =~ s|\`.*$||gm;        # `
      }
      return ($string);
   }
   if ($language =~ /vhdl/i)
   {
      $string =~ s|\-\-.*$||gm;
      return ($string);
   }
   if ($language =~ /edif/i)
   {
      return ($string);
   }
   ribbit "language ($language) not understood\n";
}
################################################################################
# HDL_Count_Parentheses
#
# so i have a string always @(blow(me)(leonardo|synplicity)) blerg (boof)
# I want to perform computations on the string surrounded by the
# beginning and last parentheses.  I call HDL_Count_Parentheses and it
# returns 3 values, the beginning string: "always @", the parenthesized string
# "blow(me)(leonardo|synplicity)" and the last string "blerg (boof)".
#
# If I want to search on something other than parentheses, say begin,end, I can
# place their values in $begin_match and $end_match.
################################################################################
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
	#else
	$paren_string .= $match;
    }

    ribbit "mismatched $begin_match,$end_match in string
    $begin_string$paren_string$end_string" if ($paren_count != 0);

    return ($begin_string,$paren_string,$end_string);
}

######################################################################
# HDL_Get_Module_Info
#
# HDL_Get_Module_Info goes through a string, finds all the modules it
# can and gets as much information as it can about each module.  It
# stores all of the information in a gigantic hash pointed to by $mp.
# Here is the structure of $mp.  If something in the table below has
# <> around it i.e <foo_name>.  That means the name is a variable.  The
# perl type cast operators are used to specify what type the value is
#
# %mp
#   %<module name>                 the name of each module found
#     @port_order                  the order of ports declared by <module name>
#     %signal                      list of ports and signals
#        %<port or signal name>    name of port/signal
#           $left                  port/signal left index
#           $right                 port/signal right index
#           $width                 port/signal width i.e (abs ($left - $right) + 1)
#           $direction             port only (input/output/inout)
#           $type                  wire or register (verilog) (type for vhdl e.g. std_logic_vector)
#           $assignment            the value assigned to signal, or the entire always block
#                                    for registers
#     %instance                    list of all instances in module
#        %<instance_name>          name of instance
#           $module                module that is being instantiated
#           $library               vhdl only (name of library)
#           %hash                  points to $mp{$module} gets assigned in HDL_Munge_Data
#           %connection            list of connections
#             %<module_port>       name of signal that points to $module.<module_port>
#     @always_order                array of each always blocks from "begin" to "end"
#
######################################################################

sub HDL_Get_Module_Info
{
   my $string = shift or ribbit "no string ($string) specified\n";
   my $language = shift or "verilog";

   my %module;
   my $mp = shift;
   $mp = \%module unless $mp;

   $string = &HDL_Remove_Comments ($string,$language);
   if ($language =~ /verilog/i)
   {
      # crush definitions for now.  Later we can use v2vhd's reader
      # that handles defines

      $string =~ s/^\s*\`define\s+.*$//mg;
      #suck up an entire module declaration.
      while ($string =~ s/\bmodule\s+(\w+)\s*   #module <name>
                          \((.*?)\)             #(<port_list>);
                           (.*?)                #<module_innards>
                          \bendmodule\b//sx)    #endmodule
      {
         my ($name,$port_list,$module_innards) = ($1,$2,$3);

         ###############
         #put cleaned up port list into hash
         $port_list =~ s/^\s*(.*?)\s*$/$1/s;
         @{$mp->{$name}{port_order}} = split (/\s*\,\s*/s,$port_list);

         ###############
         # now go through each command in module innards and extract data
         my $port_types = "input\|output\|inout";
         #foreach $command (split (/\s*\;\s*/s,$module_innards))
         while ($module_innards =~ s/^\s*(.*?)\s*\;//s)
         {
            #$command =~ s/^\s*(.*?)\s*$/$1/s;
            my $command = $1;
            #ports and signal declarations
            if ($command =~ /^\s*($port_types|reg|wire|integer)([\s\[].*)/os)

            {
               my ($type,$ports) = ($1,$2);
               my $width;

               if ($ports =~ s/^\s*\[(.*?)\:(.*?)\](.*)/$3/)
               {
                  # if port [left:right] store vector fields
                  # appropriately

                  my ($left_index,$right_index) = ($1,$2);
                  if (($left_index =~ /[^\s0-9]/) || ($right_right =~ /[^\s0-9]/))
		          {
		            $width = "";
		          }
		          else
		          {
                    $width = abs ($left_index - $right_index) + 1;
		          }
                  $mp->{$name}{signal}{$port}{left} = $left_index;
                  $mp->{$name}{signal}{$port}{right} = $right_index;
               }
               else
               {
                  # else its just a bit of width 1.
                  $width = 1;
               }

               # ports/signals can be comma separated, so loop through
               # all comma separated ports
               $ports =~ s/^\s*(.*?)\s*$/$1/s;
               foreach $port (split(/\s*\,\s*/s,$ports))
               {
                   if ($type =~ /$port_types/o)
                   {
                      #if this was a port declaration...
                      #check that $port was defined in port list above.
                      if ($port_list =~ s/\s*\b$port\b\s*\,?\s*//s)
                      {
                          #store additional data. type may get overwritten
                          #later if the same signal is declared as a reg
                          $mp->{$name}{signal}{$port}{direction} =
                              $type;
                          $mp->{$name}{signal}{$port}{type} = "wire";
                      }
                      else
                      {
                          print "Warning: Port $port is not in the port-list, ignored!\n";
                          next;
                      }

                   }
                   else
                   {
                      #not a port declaration
                      $mp->{$name}{signal}{$port}{type} = $type;

                      #only wire statements can have =s in them.
                      if ($ports =~ s/^.*?\=\s*(.*?)\s*$//s)
                      {
                         $mp->{$name}{signal}{$port}{assignment} = $1;
                      }
                   }
                   $mp->{$name}{signal}{$port}{width} = $width;
               }
               next;
            }

            #now parse instantiations.
            #if ($command =~ /^\s*(\w+)            #<module_name>
            #                  \s+(\w+)            #<instantiation_name>
            #                  \s*\(\s*(.*?)\s*\)  #((.a) b, (.c) d)
            #                  \s*$/sx)
            #{
            #   my $instance_name = $2;
            #   $mp->{$name}{instance}{$instance_name}{module} = $1;
            #   my $connection_list = $3;
            #
            #   #make a ref for easier coding later ref comes into
            #   #existence after we declare {module} = <module_name>
            #
            #   my $ref = $mp->{$name}{instance}{$instance_name};
            #   #store away connection info
            #   foreach $connection (split
            #                        (/\s*\,\s*/s,$connection_list)
            #                        )
            #   {
            #      ($connection =~ /^\s*\.(\w+)\s*\(\s*(.*?)\s*\)/) or ribbit
            #          "connection ($connection) not understood\n";
            #      my ($module_port,$external_port) = ($1,$2);
            #      $ref->{connection}{$module_port} = $external_port;
            #   }
            #}

            #assign statements
            while ($command =~
            s/^\s*(assign\s+[^\=]*?)([a-zA-Z]\w*)([^\=]*?\=\s*(.*?)\s*)$
                   /$1\ $3/sx)
            {
               $mp->{$name}{signal}{$2}{assignment} = $4;
            }

            ###############
            # handle always statements
            # there is currently a screw case here. if you do
            # something like always if adsfsdf; else case asdfsadffa;,
            # it won't work.  if you do always () a <= c; or always ()
            # begin .... end it will work.
            #if ($command =~ /\b(always.*?(\bbegin)?)/s)
            #{
            #   my $pre_begin = $1;
            #   my ($pre_begin,$always_guts,$after_guts) =
            #       &HDL_Count_Parentheses("$command\;$module_innards","begin","end");
            #
            #   #print "command ($command) pb ($pre_begin) ag ($always_guts) afg ($after_guts)\n";
            #   if ($always_guts)
            #   {
            #
            #      $module_innards = $after_guts;
            #      $always_guts = "$pre_begin begin $always_guts end";
            #   }
            #   else
            #   {
            #      $always_guts = $command;
            #   }
            #   push (@{$mp->{$name}{always_order}},$always_guts);
            #
            #   ###############
            #   # search through a always statement.  Whenever an
            #   # assignment is made to <signal> set <signal>{assignment} =
            #   # the whole always statement.
            #   my $tmp_always_guts = $always_guts;
            #   while ($tmp_always_guts =~ s/(\sbegin\s|\;)\s*(\w+)\s*\<?\={1}.*?\;/$1/is)
            #   {
            #      $mp->{$name}{signal}{$2}{assignment} = $always_guts;
            #   }
            #}
         }

         # now we are done with module innards, make sure all ports
         # were defined.
         if ($port_list =~ /(\w+)/)
         {
            ribbit "module $name has ports ($port_list) specified in port list,
                   but not declared inside module declaration\n";
         }
      }
      return ($mp);
   }
   if ($language =~ /vhdl/i)
   {

      $string =~ tr/A-Z/a-z/;

      #now everything is lower case.
      while ($string =~ s/\s*\bentity\s+(\w+)\s+is\s+(.*?)\s+end\s+.*?;\s*//si)
      {
         my ($name) = $1;
	 my $port_str = $2;
	 $port_str =~ s/generic\s*\(.*?\)\s*\;\s*//si;
         my ($port,$port_list,$sc) = &HDL_Count_Parentheses($port_str);
         ribbit "Entity $name declaration, port list not understood ($port)($sc)"
             unless (($port =~ /^port\s*$/is) &&
                     ($sc =~ /^\s*\;/is));

#        eliminate leading and trailing whitespace
         $port_list =~ s/^\s*(.*?)\s*$/$1/s;
         foreach $port_declaration (split (/\s*\;\s*/s,$port_list))
         {
            ($port_declaration =~ s/^\s*(SIGNAL\s)?\s*(.*?)  #port_name
             \s*\:\s*(\w+)                  #direction or type
             (\s+\w+)?                      #type or nothing
             (\s*.*)                        #any range information
             //six) or ribbit
                 "entity $name, port declaration misunderstood: $port_declaration";
            my ($port,
                $direction,
                $type,
                $range) = ($2,$3,$4,$5);
            die "port is bogus ($port,$direction,$range)\n" if ($port eq "");

            $direction = "in" if ($type eq "");

#			calculate the width for this identifier list
    		my $width;
			if ($range =~ s/\s*\((.*)\)//si)
			{
               my $vector = $1;
			   if ($vector =~ /^\s*(\d*?)\s*(down)?to\s*(\d*)\s*$/si)
               {
			       my $left_index = $1;
			       my $right_index = $3;

			       $width = abs ($left_index - $right_index) + 1;
               }
			   else
               {
                   $width = "0";
               }
			}
			else
			{
			   $width = 1;
			}
#			create the direction sting
            $direction = "in" if ($direction eq "");
            $direction = "out" if ($direction eq "buffer");
			$direction .= "put"
				unless ($direction eq "inout");

#           loop through each port in this identifier list and add its data to the structure
            foreach $id (split (/\s*\,\s*/s,$port))
			{
			   push (@{$mp->{$name}{port_order}}, $id);
			   $mp->{$name}{signal}{$id}{direction} =	$direction;
			   $mp->{$name}{signal}{$id}{type}      =	$type     ;
			   $mp->{$name}{signal}{$id}{left} = $left_index;
			   $mp->{$name}{signal}{$id}{right} = $right_index;
               if ($width > 0)
               {
                    $mp->{$name}{signal}{$id}{width} = $width;
               }
               else
               {
                    $mp->{$name}{signal}{$id}{width} = "";
               }
			}
         }
      }

#      #now get architecture
#      while ($string =~ s/\b
#             architecture\s+           # architecture
#             (\w+)\s+                  # <behavior>
#             of\s+(\w+)\s+             # of <entity>
#             is\s+(.*?)\b              # is <signal_list>
#             begin\b                   # begin
#             (.*?)\b                   # (behavior description)
#             end\s+\1\s*\;\s*//six)    # end <behavior> ;
#      {
#         my ($name,$signal_list,$behavior) = ($2,$3,$4);
#
#         $signal_list =~ s/^\s*(.*?)\s*$/$1/s;
#
#         foreach $signal_declaration (split (/\s*\;\s*/s,$signal_list))
#         {
#            ($signal_declaration =~
#             s/^\s*(SIGNAL|SHARED\s+VARIABLE)\s+(\w+)  # SIGNAL <signal_name>
#             \s*\:\s*(\w+)                             # : <type>
#             //six) or next;                           # (forget about vhdl TYPE
#                                                       # declarations for now.)
#
#            my ($signal, $type) = ($2,$3);
#
#            # type e.g. is std_logic or std_logic_vector
#            $mp->{$name}{signal}{$signal}{type} = $type;
#
#            my $width;
#            ###############
#            #signal_declaration now has only vector information left
#            #(if anything).
#            if ($signal_declaration =~ s/\((.*)\)//s)
#            {
#               #assign vector info if it is a vector.
#               my $vector = $1;
#               my ($left_index,$foo,$right_index) =
#                   ($vector =~ s/^(.*?)\s*(down)?to\s*(.*)$//si)
#                       or ribbit "port $port, vector $vector not understood";
#
#               $width = abs ($left_index - $right_index) + 1;
#               $mp->{$name}{signal}{$signal}{left} = $left_index;
#               $mp->{$name}{signal}{$signal}{right} = $right_index;
#            }
#            else
#            {
#               $width = 1;
#            }
#            $mp->{$name}{signal}{$signal}{width} = $width;
#         }
#
#         $behavior =~ s/^\s*(.*?)\s*$/$1/s;
#
#         ###############
#         # handle process statements
#         while ($behavior =~ s/\bprocess\b\s*    #process
#                (.*?)                            #stuff
#                \s*\bend\s+process\s*\;\s*//six) #end process
#         {
#            my $process_guts = $1;
#            push (@{$mp->{$name}{always_order}},$process_guts);
#
#            ###############
#            # search through a process statement.  Whenever an
#            # assignment is made to <signal> set <signal>{assignment} =
#            # the whole process statement.
#            my $tmp_process_guts = $process_guts;
#            while ($tmp_process_guts =~ s/(\bTHEN\s|\;)\s*(\w+)\s*(\<|\:)\=.*?\;/$1/is)
#            {
#               $mp->{$name}{signal}{$2}{assignment} = $process_guts;
#            }
#         }
#
#         ###############
#         #now all that is left is signal assignments and instantiation
#         foreach $command (split (/\s*\;\s*/,$behavior))
#         {
#            # just handle simple wire assignments, no lhs concatenation
#            # craziness for now.
#            if ($command =~ /^\s*(\w+)\s*  #<lhs>
#                              \<\=\s*      #<= (assignment operator)
#                              (.*?)\s*$    #<rhs>
#                            /six)
#            {
#               my ($lhs,$rhs) = ($1,$2);
#               ribbit "lhs is null in c ($command)"
#                   if ($lhs eq "");
#               ribbit "rhs is null in c ($command)"
#                   if ($rhs eq "");
#
#               $mp->{$name}{signal}{$lhs}{assignment} = $rhs;
#               next;
#            }
#
#            #handle instantiation
#            if ($command =~
#                /^(\w+)\s*\:\s*(entity\s+)?   #<instantiation> : entity
#                (\w+)\.?(\w*)\s*              #<lib>.<module>
#                (.*)/six)                     #<port map (clk...)
#            {
#               my ($instance_name,
#                   $entity,
#                   $library_or_module,
#                   $module,
#                   $rest)
#                   = ($1,$2,$3,$4,$5);
#
#               ###############
#               # if "entity" is declared, then module has a library,
#               # otherwise its a component with no library.
#               my $library = "";
#               if ($entity)
#               {
#                  $library = $library_or_module;
#               }
#               else
#               {
#                  $module = $library_or_module;
#               }
#
#               #assign stuff to hash
#               $mp->{$name}{instance}{$instance_name}{module} =
#                   $module;
#               $mp->{$name}{instance}{$instance_name}{library} =
#                   $library;
#
#               my $ref = $mp->{$name}{instance}{$instance_name};
#
#               ###############
#               # split up port map and assign connections
#               my $port_map = $rest;
#               $port_map =~ s/^.*?\bport\s+map\s*(\(.*)/$1/is or
#                   &ribbit
#                       ("no port map for instantiation $instance_name ($command)");
#
#               my ($pre,$pm,$end) = &HDL_Count_Parentheses
#                   ($port_map);
#               $pm =~ s/\s+//sg;
#
#               my @connections = split (/\,/,$pm);
#               foreach $c (@connections)
#               {
#                  my ($module_port,
#                      $external_port) =
#                          split (/\=\>/,$c);
#
#                  ###############
#                  # a big hack for now,
#                  # crush all those (0) cases which convert
#                  # std_logic_vector (0 downto 0) to std_logic
#                  $external_port =~ s/\(0\)$//s;
#
#                  $ref->{connection}{$module_port} = $external_port;
#               }
#            }
#         }
#      }
      return ($mp);
   }
   if ($language =~ /edif/i)
   {
#      find the "library work" section
       $string =~ /\((library\s+\w+\s+.*)/si;
       $string = $1;
#      find each cell section
       while ($string =~ /\(cell\s+(\w+)\s+(.*)/si)
       {
            $string = $2;
            my $cell_name = $1;
#           for now assume there is only 1 interface section
            if ($string =~ /\(view .*?(\(interface\s+.*)/si)
            {
#               get the interface section, and set string to everything left over
                my $begin, $interface;
                $interface = $1;
                ($begin, $interface, $string) = &HDL_Count_Parentheses($interface);
                do
                {
                    my $direction, $width, $left, $right;
                    my ($temp_begin, $guts, $temp_end) =
                        &HDL_Count_Parentheses ($interface);
                    my ($port, $info1, $info2) =
                        &HDL_Count_Parentheses ($guts);

#                   if this is a 1 bit port
                    if ($port =~ /\s*port\s+(\w+)\s*/si)
                    {
                        $port = $1;
                        if (&HDL_Match_Keyword($port))
                        {
                            print "Warning: Port names cannot match VHDL or Verilog keywords ($port)!\n";
                            $interface = $temp_end;
                            next;
                        }
                        $info1 =~ /\s*direction\s+(\w+)/si;
                        $direction = $1;
                        $direction =~ tr/A-Z/a-z/;	#direction must be lower case for PTF
                        push (@{$mp->{$cell_name}{port_order}}, $port);
                        $mp->{$cell_name}{signal}{$port}{direction} = $direction;
                        $mp->{$cell_name}{signal}{$port}{width} = 1;
                    }

#                   must be an multi-bit port
                    else
                    {
                        $info2 =~ /\s*direction\s+(\w+)/si;
                        $direction = $1;
			            $direction =~ tr/A-Z/a-z/;	#direction must be lower case for PTF
                        ($temp_begin, $info1, $info2) =
                            &HDL_Count_Parentheses ($info1);
                        # this ones nasty 
                        $info1 =~ /\s*rename            # the rename keyword and leading whitespace
                                    \s+(\w+)            # this signal name to rename
                                    \s+"\1              # the renamed signal
                                    [\[\(]              # either a [ or a ( can open bus bound
                                    (\d+)\:(\d+)        # the bus bounds
                                    [\]\)]              # either a ] or a ) can cose the bus bounds
                                    "/six;              # ending quote
                        $port = $1;
                        if (&HDL_Match_Keyword($port))
                        {
                            print "Warning: Port names cannot match VHDL or Verilog keywords ($port)!\n";
                            $interface = $temp_end;
                            next;
                        }
                        $left = $2;
                        $right = $3;
                        $info2 =~ /\s*(\d+)/si;
                        $width = $1;
                        push (@{$mp->{$cell_name}{port_order}}, $port);
                        $mp->{$cell_name}{signal}{$port}{direction} = $direction;
                        $mp->{$cell_name}{signal}{$port}{left} = $left;
                        $mp->{$cell_name}{signal}{$port}{right} = $right;
                        if ($width > 0)
                        {
                            $mp->{$cell_name}{signal}{$port}{width} = $width;
                        }
                        else
                        {
                            $mp->{$cell_name}{signal}{$port}{width} = "";
                        }
                    }

                    $interface = $temp_end;
                } until ($interface eq "");

            }
            else
            {
                ribbit ("Error: Cell ($cell_name) has no interface section");
            }
        }
        return ($mp);
   }
   if ($language =~ /bsf/i)
   {
      ($string =~ /\bsymbol/) || &ribbit ("couldn't find symbol");

       my ($begin, $guts, $the_rest);

      $guts = $string;
      while ($guts !~ /^\s*symbol/)
      {
         ($begin, $guts, $the_rest) =
             &HDL_Count_Parentheses ($guts.$the_rest);
      }

      while ($guts.$the_rest)
       {
          ($begin, $guts, $the_rest) =
              &HDL_Count_Parentheses ($guts.$the_rest);

          if ($guts =~ s/^\s*port\s+(.*)//s)
          {
             my $port_hash;
             my $port_guts = $1;
             my %hash = ();
             my $direction = "";
             my $name = "";
             while ($port_guts)
             {
                my ($a,$key,$c) = &HDL_Count_Parentheses ($port_guts);
                if ($key =~ /^(output|input)$/)
                {
                   $direction = $key;
                   $hash{direction} = $direction;
                }
                elsif ($key =~ /^bidir$/)
                {
                   $direction = "inout";
                   $hash{direction} = $direction;
                }
                elsif ($key =~ s/text\s+\"(\w+)(.*?)\s*\".*/$1/)
                {
                   $name = $1;
                   my $left_right = $2;
                   my $left;
                   my $right;

                   if ($left_right)
                   {
                      if ($left_right =~ /\[(\d+)\.\.(\d+)\]/)
                      {
                         $left  = $1;
                         $right = $2;
                      }
                      elsif ($left_right =~ /\[(\d+)\]/)
                      {
                         $left = $1;
                         $right = $left;
                      }
                   }
                   else
                   {
                      $left = 0;
                      $right = 0;
                   }
                   $hash{left} = $left;
                   $hash{right} = $right;
                   $hash{width} = (abs($left - $right)+1);
                }
                if ($name && $direction)
                {
                   $mp->{$name} = \%hash;
                   $name = $direction = "";
                   last;
                }
                $port_guts = $c;
             }
          }
          $guts = "";
       }
      return $mp;
   }
   if ($language =~ /bdf/i)
   {
        do
        {
            my $port,$direction, $left, $right;
            my ($temp_begin, $guts, $the_rest) = &HDL_Count_Parentheses ($string);
#           now $guts has a thing for us to parse
            if ($guts =~ /\s*pin\s+(.*)/s)
            {
#               we found a pin, now we need to extract info from it
                $guts = $1;

#               first get the direction
                ($temp_begin, $direction, $guts) = &HDL_Count_Parentheses ($guts);
                $direction =~ tr/A-Z/a-z/;
                $direction = "inout" if ($direction eq "bidir");

#               ignore rect decsription and direction text
                my $temp;
                ($temp_begin, $temp, $guts) = &HDL_Count_Parentheses ($guts);

                ($temp_begin, $temp, $guts) = &HDL_Count_Parentheses ($guts);

#               extract pin name from this text field
                ($temp_begin, $port, $guts) = &HDL_Count_Parentheses ($guts);
                ribbit ("Error: Couldn't extract port name ($port)!")
                    unless ($port =~ /"(.+?)"/);

                $port = $1;
                if ($port =~ /[^\w\[\]\.]/)
                {
                    print "Warning: Port name contains illegal characters ($port)!\n";
                }
                elsif ($port =~ /(\w+)\s*\[(\d+)\.\.(\d+)\]/)
                {
                    $port = $1;
                    if (&HDL_Match_Keyword($port))
                    {
                        print "Warning: Port names cannot match VHDL or Verilog keywords ($port)!\n";
                    }
                    else
                    {
#                       its possible to have a vector spread out over several pin
#                       sections, take care of that here
                        my $width;
                        if ($mp->{bdf}{signal}{$port})
                        {
                            $mp->{bdf}{signal}{$port}{width} += abs($2-$3)+1;
                            if ($2 < $3)
                            {
                                $mp->{bdf}{signal}{$port}{left} = $2
                                    if ($2 < $mp->{bdf}{signal}{$port}{left});

                                $mp->{bdf}{signal}{$port}{right} = $3
                                    if ($3 > $mp->{bdf}{signal}{$port}{$right});
                            }
                            else
                            {
                                $mp->{bdf}{signal}{$port}{left} = $2
                                    if ($2 > $mp->{bdf}{signal}{$port}{left});

                                $mp->{bdf}{signal}{$port}{right} = $3
                                    if ($3 < $mp->{bdf}{signal}{$port}{$right});
                            }
                        }
                        else
                        {
                            push (@{$mp->{bdf}{port_order}}, $port);
                            $mp->{bdf}{signal}{$port}{direction} = $direction;
                            $mp->{bdf}{signal}{$port}{left} = $2;
                            $mp->{bdf}{signal}{$port}{right} = $3;
                            my $width = abs($2 - $3)+1;
                            $mp->{bdf}{signal}{$port}{width} = abs($2-$3)+1;
                        }
                    }
               }
               else
               {
                    $port = $1;
                    if (&HDL_Match_Keyword($port))
                    {
                        print "Warning: Port names cannot match VHDL or Verilog keywords ($port)!\n";
                    }
                    else
                    {
                        push (@{$mp->{bdf}{port_order}}, $port);
                        $mp->{bdf}{signal}{$port}{direction} = $direction;
                        $mp->{bdf}{signal}{$port}{width} = 1;
                    }
               }
            }
#           now process what's left
            $string = $the_rest;
        } until ($string eq "");

        return ($mp);
   }
   ribbit "language ($language) not understood\n";
}

sub HDL_List_Ports_For_Module
{
   my $module_hash = shift or ribbit "no hash";
   my $module = shift or ribbit "no module";

   my $tmp = &HDL_Get_By_Path ($module_hash,".$module.port_order");
   my @module_port_array = @$tmp;

   my $list_ports_for_string;
   foreach $port (@module_port_array)
   {
      $list_ports_for_string .=
          "$port |
           $module_hash->{$module}{signal}{$port}{width}     |
           $module_hash->{$module}{signal}{$port}{direction},
          ";
   }

   &List_Ports_For ($module,$list_ports_for_string);
}

######################################################################
# HDL_Munge_Data
#
# For assigning items in which you don't know the declaration order,
# e.g for stuff that happens across module boundaries, you have to wait
# until all data is known before you can start processing it.  Its
# also good to do as much work here as possible because you only have
# to do it once here rather than once for each of the supported
# languages.
######################################################################

sub HDL_Munge_Data
{
   my $hash = shift or ribbit "no hash";

   foreach $module (&HDL_Get_Keys_By_Path($hash,"","",0))
   {
      my $boo = $hash->{$module}{instance};
      my @asdf = keys (%$boo);
      foreach $instance (&HDL_Get_Keys_By_Path($hash,"$module.instance",1))
      {
         my @tmp = keys (%{$hash->{$module}{instance}});
         my $instantiated_module = &HDL_Get_By_Path
             ($hash,
              "$module.instance.$instance.module","");

         ###############
         #assign instance parent name and hash
         $hash->{$module}{instance}{$instance}{hash} =
             $hash->{$instantiated_module} or warn
                 "module ($module) instantiates unknown module ($instantiated_module)\n";

         $hash->{$module}{instance}{$instance}{parent} =
             $hash->{$module};


         ###############
         # if you have a module declaration "<module> <instance> ((.a)
         # b)" and module.a is an output, then what you're really
         # saying is (assign b = <instance>.a).  We do that assignment
         # now for all output ports of the $instance here.

         my $mod_sig = &HDL_Get_By_Path
             ($hash,
              "$module.instance.$instance.connection");

         foreach $port (keys (%$mod_sig))
         {
            if (&HDL_Get_By_Path
                ($hash,"$instantiated_module.signal.$port.direction",1)
                 =~ /^out/i)
            {
               $hash->{$module}{signal}{$$mod_sig{$port}}{assignment}
               = "$instance.$port";
            }
         }
      }
   }
}
######################################################################
# HDL_Get_Module_Info_From_File
#
# wrapper around get_module_info.  Does language determination based
# upon file extension.
######################################################################

sub HDL_Get_Module_Info_From_File
{
   my %h = @_;
   $h{file} or ribbit "no file specified\n";

   if (!$h{language}) # if language not specified, determine from file
                      # suffix. Default is verilog
   {
      $h{language} = "verilog";
      $h{language} = "vhdl"
          if ($h{file} =~ /\.vhdl?/i);
      $h{language} = "edif"
	      if ($h{file} =~ /\.edi?f/i);
      $h{language} = "bdf"
          if ($h{file} =~ /\.bdf/i);
      $h{language} = "bsf"
          if ($h{file} =~ /\.bsf/i);
   }

   my $module_string = &HDL_Read_File($h{file});
   my $module_hash = &HDL_Get_Module_Info ($module_string,
                                           $h{language},
                                           $h{hash});
   return ($module_hash);
}

######################################################################
# HDL_Get_Module_Info_From_Files
#
# wrapper around get_module_info_from_file. Munges data after all
# modules are known.
######################################################################

sub HDL_Get_Module_Info_From_Files
{
   my %h = @_;
   $h{file_array} or ribbit "no file array";

   my %hash;
   foreach $file (@{$h{file_array}})
   {
      my $hash = &HDL_Get_Module_Info_From_File(file => $file,
                                                hash => \%hash,
                                                language => $h{language});
   }

   #now we have all the data given to us from the file list.
   #play with it a bit
   &HDL_Munge_Data(\%hash);

   return (\%hash);
}
######################################################################
# HDL_Get_Keys_By_Path
#
# Sugar around Get_By_Path, it just assumes value gotten is a hash and
# returns its keys.  Could do error checking with ref operator

sub HDL_Get_Keys_By_Path
{
   my $pHash = shift or ribbit "no hash";
   my $rel_path = shift;
   my $quiet = shift;
   my $debug = shift;

   warn "\n\nHDL_Get_Keys_By_Path:"
       if $debug;
   my $ref_hash = &HDL_Get_By_Path($pHash,$rel_path,$quiet,$debug);

   my @return_array = keys (%$ref_hash);
   warn "done with HDL_Get_Keys_By_Path returning (@return_array)\n"
       if $debug;
   return (@return_array);
}
######################################################################
# HDL_Set_By_Path (NOT FINISHED)
#
# An experiment in setting by path.  currently we use the all powerful
# arrow operator
sub HDL_Set_By_Path
{
   my $pHash = shift or ribbit "no hash";
   my $rel_path = shift;
   my $value = shift or ribbit "no value";
   my $make_new_path = shift;

   $rel_path =~ s/\s+//g;
   $rel_path =~ s/^\s*\.?(.*?)\.?\s*$/$1/; #take off initial and final .s

   $rel_path =~ s|\.|\}\{|g; #change a.b to a}{b
   #to be continued

   #$rel_path =~ ;
}

######################################################################
# HDL_Get_By_Path
#
# You pass in hash and a "." separated path.  It progresses down the
# hash tree and gives you your result.  If it cannot go down the tree
# and $quiet is FALSE.  It ribbits where it failed and displays the
# leaves available at that point. if ($quiet) it just returns ""
######################################################################
sub HDL_Get_By_Path
{
   my $pHash = shift or ribbit "no hash";
   my $rel_path = shift;
   my $quiet = shift;
   my $debug = shift;

   $rel_path =~ s/^\s*\.?(.*?)\s*$/$1/s;
   warn "\n\nHDL_Get_By_Path: rel path is $rel_path\n"
       if ($debug);
   my @path = split (/\s*\.\s*/,$rel_path);
   my $indent;
   while ($child = shift (@path))
   {
      my $child_options = join (" or\n",(sort (keys %$pHash)));

      if ($debug)
      {
         warn "$indent$pHash ->($child)\n";
         $indent .= "   ";
      }

      $pHash = $pHash->{$child};

      if (!$pHash)
      {
         return ("") if $quiet;
         &ribbit ("($child) unknown in $rel_path\n\n"
                  ."known options are:\n($child_options)\n");
      }
   }

   if ($debug)
   {
      warn "$indent returning $pHash\n";
   }
   return ($pHash);
}

######################################################################
# HDL_Get_Module_By_Instance_Path
#
#You pass in hash and a "." separated path.  It progresses down the
# instantiation list and returns the module name at the end of the tree
######################################################################
sub HDL_Get_Module_By_Instance_Path
{
   my (%h) = @_;

   $h{path} or ribbit "no path specified";
   $h{hash} or ribbit "no hash specified";

   $h{path} =~ s/\s+//g;

   my @path = split (/\./,$h{path});

   my $top = shift @path;
   $top = shift @path
       if ($top =~ /^\s*$/);

   my $hash = $h{hash};

   while (@path)
   {
      my $leaf = shift @path;
      $top = &HDL_Get_By_Path
          ($hash,"$top.instance.$leaf.module");
   }
   return ($top);
}

######################################################################
# HDL_Get_Parent_Connection
#
# returns the full path of the signal that connects to an instance
######################################################################

sub HDL_Get_Parent_Connection
{
   my (%h) = @_;

   $h{path_and_signal} or ribbit "no path and signal specified";
   $h{hash} or ribbit "no hash specified";

   my @path_a = split (/\s*\.\s*/s,$h{path_and_signal});
   my $signal = pop (@path_a) or ribbit "we get no signal";
   my $instance = pop (@path_a) or ribbit "we get no instance";

   my $path = join("\.",@path_a);
   my $module =
       &HDL_Get_Module_By_Instance_Path (path=> $path,
                                         hash=> $h{hash}
                                         );
   my $parent_connection =
       &HDL_Get_By_Path ($h{hash},
                         "$module.instance.$instance.connection.$signal");

   return "$path\.$parent_connection";
}
1;
