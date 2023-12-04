****************************************************************
*  LogicLock Based Makefile - Bottom-Up Incremental Design
*
*  This help file explains:
*
*  1.  Motivation for the logiclock_makefile example
*  2.  How the logiclock_makefile example works
*  3.  Using the logiclock_makefile example
*  4.  How you can alter the logiclock_makefile example to work 
*      with your project
****************************************************************

****************************************************************
*  1.  Motivation for the logiclock_makefile example
****************************************************************

Most large designs can be broken down into separate smaller 
modules, or subsections, instantiated by some top-level logic.  
It is often the case that synthesizing, placing and routing the 
smaller modules on their own and then merging the results to 
get a final top-level design does not significantly degrade 
performance.  However, in standard CAD flows, the design is 
still treated as one large module and changes to one subsection
require a potentially lengthy full recompilation that will 
likely change placement and routing in the other subsections.

To prevent this from happening, an incremental design flow 
can be used.  In this flow, each subsection is given a unique 
portion of the chip's resources to implement some logic.  
Once the subsections have been fully compiled, the results 
are merged to yield the final design.

After the initial compilation, changes to one subsection should 
not alter the synthesis, placement or routing of the others.  
Using the example flow ensures this happens.  Changes to a 
given module's source files cause a recompilation of that 
module only, leaving the other placement and routing untouched.
The module's new implementation is then re-merged into the 
top-level design while the other subsections remain untouched.

This flow allows for easy division of labour amongst designers,
optimizations that target a particularly critical subsection, 
preservation of performance in unchanged portions of a 
design and considerable compile-time savings.

It should be noted that all of this functionality is provided
by using Altera's LogicLock design methodology.  The makefile
and associated scripts simply provide an example of how one 
can use LogicLock as part of an incremental design flow.

****************************************************************
*  2.  How the logiclock_makefile example works
****************************************************************

To understand how one can use Altera's LogicLock functionality
to implement an incremental design flow, we will examine how 
this particular makefile and its associated project work. Later 
in this document, it will be made clear how this example can be
altered to accomodate any other design.

The example circuit is called chiptrip and it has been broken
down into 4 subsections:  auto_max, speed_ch, time_cnt, and
tick_cnt.  

As a first step, the initial compilation must be performed.
This is done by the "setup_project.tcl" script which performs
the following tasks:

- Create individual projects for each of the sub-sections

- Create a LogicLock region for each subsection with:
	-->  A script-defined origin (the origin is the location
	     of the region's bottom-left corner).  This position
	     is marked as "locked" so that it cannot be moved by
	     Quartus during compilation (done with the -floating 
	     false flag).
	-->  A width of 4 LABs and a height of 1 LAB (A LAB is
	     a group of logic elements).  This size is marked
	     as "fixed" so that it cannot be changed by Quartus
	     during compilation (done with the -auto_size false
	     flag).
	     
- Run an optional asgn_<subsection_name>.tcl script to make
  special section assignments if the script exists.
  
- Run the subsection through synthesis, placement and routing

- Back annotate the placement and routing of the design so it
  can be imported later
    -->  A new "modular" revision of the subsection project is
         created before this is done.  This ensures that the 
         original revision has no back annotation, which is
         convenient because it means no assignments need to
         be deleted from the original revision if changes are
         made to the original revision.
    -->  Placement is stored as assignments in the new 
         modular revision's QSF file.
    -->  Routing is stored in the new modular revision's
         Routing Constraints File (RCF)
    -->  A VQM netlist is written out to save the synthesis
    
- Synthesize a top-level project and use the results from the
  individual compilations
    -->  Assignments are made to add the QSF/RCF/VQM files
         from each subsection to the top-level project.  
    -->  The design is then mapped, using the VQM files as
         source.  This effectively preserves synthesis.
    -->  "merge.tcl" is run to import the placement and 
         routing of each subsection from the appropriate 
         QSF/RCF files.

- Place and route the top-level design
    -->  Since the location assignments and routing constraints
         were imported already, the placer will simply use
         those previous results, thus preserving placment
         and routing.
         
Now that the project has been properly built from the bottom-up,
the makefile can be used to keep the results up to date in an
efficient manner.  First, dependencies are made between the VQMs 
and the HDL source used to create them.  Then, the top-level 
design is set to be dependent on all of the VQMs.

If any of the HDL files change, the sub-revision responsible 
for producing the corresponding VQM is recompiled and the 
back annotated placement and routing is updated.  Next, the 
VQM changing triggers the top-level design to re-merge existing 
LogicLock regions and associated placement by importing 
the individual settings again.  The imported placements for 
subsections that were not recompiled don't change, so their 
placment, routing and performance have been preserved.  Also, 
time was not wasted recompiling the unchanged subsections.

So we see that by using Altera LogicLock regions and a simple
makefile, a bottom-up incremental design flow has been 
implemented for the chiptrip circuit.


****************************************************************
*  3.  Using the logiclock_makefile example
****************************************************************

To create the example project, simply enter the following 
command from the command prompt (assuming quartus/bin is in your
path):

quartus_cdb -t setup_project.tcl

This will create the project from scratch and perform the
initial compilation.  At this point you may use the provided
makefile, "logiclock_makefile.txt", to rebuild the project.  
After the initial make, only subsections of the design that 
have had source files change will be recompiled.  This then 
causes the top-level design to re-merge the individual 
subsections and the design is sent through the placer and router 
again, with unchanged subsections having their previous 
placement and routing preserved.

The logiclock_makefile.txt has been tested with GNU make, which 
is available as a win32 executable at:

http://unxutils.sourceforge.net/

Source files for GNU make can be found at:

ftp://ftp.gnu.org/pub/gnu/make/

****************************************************************
*  4.  Customizing the logiclock_makefile example
****************************************************************

Although this example is geared towards the chiptrip circuit, it
can easily be extended to work with any design.  Below is a list
of the sections of the scripts that would change if the same
flow was to be carried out on an arbitrary design.

In setup_project.tcl:

(i)   - The "project" and "top_revision" variables defined at the 
        top of the file should be set to the appropriate values.
      
(ii)  - The "sub_revisions" list variable at the top of 
        the file should be set to a list of subsections in your 
        design (separated by spaces).
     
(iii) - The location of the LogicLock region assigned to each of
        your subsections should be specified by changing the
        arguments to the "set origin" command.  For each of
        the subsections in your subsection list you should 
        have a command of the form:
        
        set origin(<subsection_name>) LAB_X<x_val>_Y<y_val>
        
        Where (<x_val>, <y_val) is the bottom left corner of
        the region.

(iv)  - The name of each instance corresponding to a subsection
        should be set by changing the "set instance_name"
        commands located just below the "set origin" commands.
        Simply have one line per subsection of the form:

        set instance_name(<subsection_name>) <instance_name>

        Here we have assumed that each subsection corresponds
        to a particular entity, and this is the name of the
        instance of that entity in your design.
        
(v)   - The height and width of the LogicLock region should be
        set by changing the arguments to the "set height" and
        "set width" commands located at the top of the file.
        For each subsection you should have a command with the 
        following form:

        set height(<subsection_name>) <height>
        set width (<subsection_name>) <width>

	    Where <height> and <width> are integers representing 
        the height and width of the LogicLock region that
        corresponds to <subsection_name>.

(vi)  - To pick the chip and family you wish to target, alter the
        corresponding values in the "create_project" procedure.
        
In logiclock_makefile.txt:

(i)   - Fill in appropriate values for the variables under the
        "Top Level Module" and "Low Level Modules" comment lines.
      
(ii)  - Change the rules under the "Compile Sub-modules when 
        needed" heading to correspond to your own source files
        and pre-defined variables.
