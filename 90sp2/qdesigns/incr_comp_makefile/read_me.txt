****************************************************************
*  Incremental Compilation Bottom-Up Design With Makefiles
*
*  This help file contains the following sections:
*
*  1.  Executive Summary
*  2.  Using the Incremental Compilation Bottom-Up Makefile 
*      Example
*  3.  How the Incremental Compilation Bottom-Up Makefile Example 
*      Works
*  4.  Customizing the Incremental Compilation Bottom-Up Makefile
*      Example
*  5.  Parallel processing support
****************************************************************

****************************************************************
*  1.  Executive Summary
****************************************************************

This example shows how to use makfiles and Incremental 
Compilation to efficiently preserve compilation results for some 
parts of a design and recompile others whose source files have 
changed.  It is especially useful for teams requiring parallel 
development within their design flow.

The example breaks a top-level project into several
low-level projects, compiles all low-level projects whose source
files have changed since the last make, and merges the results 
back into the top-level design.  Unchanged parts of the design 
have their previous results preserved and are not re-compiled.

This example includes separate makefiles for each 
low-level project, the top-level project and there is one master
makefile that calls all the others.  Simply running the
master makefile ensures the top-level project reflects the 
latest low-level results.

The example makes use of new Quartus Incremental Compilation
features.  Previous examples have used older LogicLock region 
importing and exporting, which is still supported for existing
users.

Section 3 details how the example works and provides more 
information on the example design, 'chiptrip'.

Section 4 details how to customize the makefile for designs 
other than the example.

Section 5 details how to use parallel processing to speed up
build time.

****************************************************************
*  2.  Using the Incremental Compilation Bottom-Up Makefile 
*      Example
****************************************************************

To start, ensure the following:

-->  All files provided with this example should be in a 
     directory of your choice.  We will call this directory 
     <example_dir>.

-->  quartus/bin appears in your PATH variable
    
Now run the following from a command prompt: 
          
(1) cd <example_dir>

(2) quartus_cdb -t setup_example.tcl

(3) make -f master_makefile

Command (2) runs a script that creates directories for each 
low-level project, and the top-level project.  It will move 
the provided source files and makefiles to their appropriate 
directories.  The only files left in <example_dir> should be
this document, setup_example.tcl, the master makefile called
master_makefile and another makefile called parallel_makefile.
The parallel makefile is detailed in Section 5.

Command (3) invokes the master makefile. This will call make 
for each of the low-level projects, which compiles each of them, 
and exports their results.  Then, the top-level project, 
chiptrip, has its makefile called, which uses the low-level 
results to compile chiptrip.

Any changes to design files or sub-project compilation 
results will cause the appropriate projects to be 
recompiled, and the new results will be imported by the 
top-level project.

To ensure the project is up to date at any point in time, use
command (3) again.

Note that if you type 'make -f master_makefile view_commands' 
you will see what commands the low-level makefiles would have 
run, without actually having them run.

   
****************************************************************
*  3.  How the Incremental Compilation Bottom-Up Makefile Example 
*      Works
****************************************************************

To understand how one can use Altera's Incremental Compilation
functionality and standard makefiles to implement a bottom-up 
incremental design flow, we will examine how this particular 
makefile and its associated projects work. 

The example circuit is called chiptrip and it has been broken
down into 4 subsections:  auto_max, speed_ch, time_cnt, and
tick_cnt.  The design hierarchy is as follows:

                chiptrip  <-- Top level project
                   |
     -----------------------------
     |        |         |        |
 auto_max  speed_ch   time_cnt  tick_cnt  <-- Low-level projects

 
As a first step, the projects (there are five of them) have to 
be created with appropriate settings.  This is done by the 
"setup_example.tcl" script which performs the following tasks:

- Create individual projects for each of the sub-sections and
  the top-level design.  Each project has its own directory
  and all directories are at the same level.

- Create Incremental Compilation design partitions for each of the
  sub-sections in the top-level design.
	     
- Set the netlist source for each partition to 'Import'.
  
      
At this point, no actual processing of the design has taken 
place.  The actual logic will be synthesized, placed and 
routed on the initial 'make' of the project.

Once the initial build is performed, Quartus will sythesize,
place and route each of the sub-projects and generate a .QXP
file that stores the compilation results.  Next, the top-level 
design will be analyzed then synthesized, placed and routed 
using the results from the sub-project compilations (results 
are imported via QXP files in each sub-directory).  

Note that any 'Cut Timing Path' assignments from the low-level
projects are imported into the top-level as well.  We see an 
example of this with auto_max.  In the low-level, all paths are
to be ignored by TAN (done with wildcard assignments).  You can
verify this by running TAN on auto_max in the GUI and locating
the 'Cut Timing Path' in the 'Settings' panel of the Timing
Analyzer report from '*' to '*'.  If you look at the same 
section of the top-level tan report, you will see that an 
equivalent setting instructs TAN to ignore paths from 
"auto_max:auto_max|*" to "auto_max:auto_max|*".  Consequently,
the same paths are ignored for auto_max at both levels.

Any changes to source files will cause the appropriate
sub-projects to be re-synthesized, re-placed and re-routed 
when the master makefile is made. These new results are then 
used to generate a new .QXP file which triggers a recompilation 
of the top-level design, which will import the new results.

Note that the top-level compilation is extremely fast since 
it does not need to actually synthesize, place or route the 
logic because the partitions are set to 'Import' results from 
the .QXP files.

Also note that you can optionally turn on Quartus's Smart 
Recompilation feature in each of the projects.  This can help
reduce compilation times further in some cases.

So we see that by using makefiles and Altera's Incremental
Compilation features with partition netlist importing, 
a bottom-up incremental design flow has been implemented for 
the chiptrip circuit.

****************************************************************
*  4.  Customizing the Incremental Compilation Bottom-Up Makefile
*      Example
****************************************************************

Although this example is geared towards the chiptrip circuit, it
can easily be extended to work with any design.  To do this,
follow these steps:

-  Create your own makefiles for each of your sub-projects.  
   Follow the template used in this example but simply
   use your own MODULE_NAME, SOURCE_FILES and QXP_FILE names.
   Note that the QXP file is where the results of the sub-project
   compilations are stored.
      
-  In your top-level design's makefile (chiptrip's in this case),
   fill in sub-directories appropriate to your design and use
   your own TOP_LEVEL_MODULE_NAME and SOURCE_FILES_TOP_LEVEL.
   Also create a list of the QXP files used in your design.
   
-  In the master makefile, replace the calls to sub-makefiles 
   with your own sub-project directories.

****************************************************************
*  5.  Parallel Processing Support
****************************************************************

Quartus II 5.1's bottom-up flow supports parallel processing of
all sub-projects.  By using a 'make' tool that supports 
parallel processing and altering the master makefile so that 
there are separate targets for each sub-directory, parallel 
execution of the sub-project makefiles is possible..

To see an example of this, from the <example_dir> use GNU make 
and type:

(1) make -f parallel_makefile -j5

This performs the sub-project compilations in parallel, 
followed by the top-level project compilation.  Some notes on
making this flow work with your own design:

- The '-j5' specifies that 5 concurrent jobs can execute (4 
  sub-projects and the master makefile).  Change the integer 
  after 'j' to a number appropriate for your design.

- The '.PHONY' rule in the parallel_makefile is used to
  ensure that each sub-directory is compiled every time.  See
  GNU documentation on the use of .PHONY for more information.

- Care must be taken to ensure that there are no implicit 
  dependencies in your parallel makefile.  
  
  For example:

  Consider a design with 2 lower-level projects and one top.
  The following is a valid rule ONLY for SERIAL makefiles:

  all: lower_1 lower_2 top

  This is because the rules will be evaluated from left to
  right and lower_1 and lower_2 will complete before top.
 
  However, in a PARALLEL makefile, it is possible that 'top'
  begins execution before lower_1 and lower_2 finish, which
  would lead to errors.  So you should have the following:

  all: top

  top:  lower_1 lower_2

  This ensures proper execution order.
  