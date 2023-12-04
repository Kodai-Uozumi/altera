// alt_cusp.h

#ifndef __ALT_CUSP_H
#define __ALT_CUSP_H

#ifdef SYSTEMC_H
#ifndef SC_INCLUDE_FX
#error "SystemC must be built with SC_INCLUDE_FX defined for cusp"
#endif
#endif

#ifndef SC_INCLUDE_FX
#define SC_INCLUDE_FX
#endif

#include <systemc.h>

#ifdef __CUSP_SYNTHESIS__
#define ALT_CUSP_PRAGMA(X) _Pragma(#X)
#define ALT_CUSP_ATTRIBUTE1(K,V) __attribute__(( K ( V ) ))
#define ALT_GNU_ATTRIBUTE(K) __attribute__(( K ))
#define ALT_CUSP_ASSERT(check, message) static_assert((check), message)
#else
#define ALT_CUSP_PRAGMA(X)
#define ALT_CUSP_ATTRIBUTE1(K,V)
#define ALT_GNU_ATTRIBUTE(K)
#define ALT_CUSP_ASSERT(check, message) do { } while (0)
#endif

#define ALT_CUSP_FUNCTIONAL_UNIT(NAME) ALT_CUSP_ATTRIBUTE1(cusp_fu, NAME)
#define ALT_CUSP_SYNTH_MODE(MODE)      ALT_CUSP_ATTRIBUTE1(cusp_synth, MODE)
#define ALT_CUSP_SYNTHESISE(WHEN)      ALT_CUSP_PRAGMA(cusp_synthesise WHEN)

// Temporary (early 8.1) define to ease transition from 8.0
#define ALT_CUSP_DISABLE_NUMBER_SUFFIX

#include <cusp/alt_cdfg_types.h>
#include <cusp/alt_lib_types.h>
#include <cusp/alt_util.h>
#include <cusp/alt_cusp_synth.h>
#include <cusp/alt_exception.h>

#include <cusp/fuLib/alt_shift.h>
#include <cusp/fuLib/alt_mem.h>

#include <cusp/fuLib/alt_au.h>
#include <cusp/fuLib/alt_reg.h>
#include <cusp/fuLib/alt_mult.h>
#include <cusp/fuLib/alt_mac.h>
#include <cusp/fuLib/alt_immed.h>
#include <cusp/fuLib/alt_cmp.h>
#include <cusp/fuLib/alt_multadd.h>

#include <cusp/fuLib/alt_gpio.h>
#include <cusp/fuLib/alt_avalon_st.h>
#include <cusp/simlib/alt_avalon_st_channel.h>

#include <cusp/simlib/alt_avalon_bus.h>
#include <cusp/fuLib/alt_avalon_mm.h>

#include <cusp/fuLib/alt_avalon_eb.h>
#include <cusp/simlib/alt_avalon_eb_channel.h>

#include <cusp/fuLib/alt_fifo.h>
#include <cusp/fuLib/alt_fifo_paged.h>

#include <cusp/simlib/alt_pc.h>
#include <cusp/simlib/alt_exit.h>
#include <cusp/simlib/alt_debug.h>
#include <cusp/simlib/alt_overlay.h>

#include <cusp/fuLib/alt_fp_mult.h>
#include <cusp/fuLib/alt_fp_au.h>
#include <cusp/fuLib/alt_fp_cmp.h>

#include <cusp/fuLib/alt_tapped_delay.h>

#ifndef __CUSP_SYNTHESIS__

// ignore the synthesis directives if not needed
#define ALT_CUSP_SYNTHESIS_ON
#define ALT_CUSP_SYNTHESIS_OFF
#define BIND(ARG) // Deprecated, use ALT_BIND instead
#define ALT_BIND(ARG)
#define ALT_BIND_SEQ_SPACE(ARG)
#define ALT_BIND_SEPARATE_SEQ_SPACE(ARG)
#define ALT_BIND_SEQ_PER_RESOURCE
#define ALT_NO_INIT

#define ALT_CUSP_MAKE_INIT_STATE(ARRAYNAME, HEXFILENMAME)

#define ALT_BIND_FUNCTION_UNIT(fu)

#define ALT_ATTRIB(ATTRIB_CODE, ATTRIB_VALUE)

// hints to the scheduler

#define ALT_BARRIER0()
#define ALT_BARRIER1()

// memory port binding
#define ALT_PORTA(X) (X)
#define ALT_PORTB(X) (X)
// number evaluation
#define ALT_EVALUATE(X) (X)
#define ALT_DONT_EVALUATE(X) (X)
// add pipeline registers to the read from X of N stages, 0 for none/default
#define ALT_STAGE(X, N) (X)
//Add all IO and array access operations in statement X to sequencing space S
#define ALT_SEQ_SPACE(X, S) (X)
// Remove the sequencing edge before this statement
#define ALT_NOSEQUENCE(X) (X)
// delay the start of a statement X for N cycles, 0 for none/default
#define ALT_DELAY(X, N) (X)

#else

// Version for synthesis.

#define ALT_CUSP_SYNTHESIS_ON _Pragma("cusp_synthesise on")
#define ALT_CUSP_SYNTHESIS_OFF
#define BIND(ARG)  __attribute__((cusp_bind(ARG))) // Deprecated, use ALT_BIND instead
#define ALT_BIND(ARG)  __attribute__((cusp_bind(ARG)))
#define ALT_BIND_SEQ_SPACE(ARG) __attribute__((cusp_seqspace(ARG, "single")))
#define ALT_BIND_SEPARATE_SEQ_SPACE(ARG) __attribute__((cusp_seqspace(ARG, "separate")))
#define ALT_BIND_SEQ_PER_RESOURCE __attribute__((cusp_seqspace("", "per-resource")))
#define ALT_NO_INIT __attribute__((cusp_no_init))

// Bind to AlT_WIRE to request combinatorial logic
extern ALT_CUSP_SYNTH::WIRE ALT_WIRE;

#define ALT_BIND_FUNCTION_UNIT(fu) ALT_CUSP_SYNTH::bind_function_unit(fu)

// First Parameter for the ALT_ATTRIB(x,y) attribute
#define ALT_MIN_ITER   min_iter   // Minimum iterations of loop
#define ALT_MAX_ITER   max_iter   // Maximum iterations of loop
#define ALT_TILE_SIZE  step_iter  // Step of the loop - eg. if the loop stops at either 0,3,6,9,etc iterations. its step is 3
#define ALT_MOD_SCHED  mod_sched  // Whether to modulo schedule or not
#define ALT_UNROLL     unroll     // Whether to unroll or not
#define ALT_TILE       tile       // whether to tile or not
#define ALT_MOD_TARGET mod_target // Target number of clock cycles for modulo'd loop
#define ALT_SCHEDULER  schedule_algorithm // Set this to ALT_ILP if ILP scheduler should be used to schedule a loop.
#define ALT_REVERSE    reverse    // Whether to reverse the loop index variable
#define ALT_SKIDDING   skidding   // Whether to enable loop skidding for this loop

// Second parameter for the ALT_ATTRIB attribute
#define ALT_INFINITY "loop_infinity"
#define ALT_MOD_SCHED_ON_NOPROLOG "mod_sched_on_noprolog" // Modulo schedule on, but with no prolog (may make first few cycles behave unexpectedly)
#define ALT_ASAP "asap"
#define ALT_ILP "ilp"

// More second parameters for ALT_ATTRIB.  These are for backwards
// compatibility, please use the boolean values instead.
#define ALT_MOD_SCHED_ON  true  // Deprecated, use true directly
#define ALT_MOD_SCHED_OFF false // Deprecated, use false directly
#define ALT_UNROLL_ON     true  // Deprecated, use true directly
#define ALT_UNROLL_OFF    false // Deprecated, use false directly
#define ALT_TILE_ON       true  // Deprecated, use true directly
#define ALT_TILE_OFF      false // Deprecated, use false directly

#define ALT_ATTRIB_(ATTRIB_CODE, ATTRIB_VALUE) ALT_CUSP_SYNTH::loop_ ## ATTRIB_CODE (ATTRIB_VALUE)
#define ALT_ATTRIB(ATTRIB_CODE, ATTRIB_VALUE) ALT_ATTRIB_(ATTRIB_CODE, ATTRIB_VALUE)

#define ALT_BARRIER0()    ALT_CUSP_SYNTH::op("barrier0")
#define ALT_BARRIER1()    ALT_CUSP_SYNTH::op("barrier1")

#define ALT_PORTA(X)         ALT_CUSP_SYNTH::hint_port(X, "A")
#define ALT_PORTB(X)         ALT_CUSP_SYNTH::hint_port(X, "B")
#define ALT_EVALUATE(X)      ALT_CUSP_SYNTH::hint_evaluate(X, true)
#define ALT_DONT_EVALUATE(X) ALT_CUSP_SYNTH::hint_evaluate(X, false)
#define ALT_STAGE(X, N)      ALT_CUSP_SYNTH::hint_stage(X, N)

#define ALT_NOSEQUENCE(X) do { X; } while (ALT_CUSP_SYNTH::hint_nosequence(true))
#define ALT_DELAY(X, N)   do { X; } while (ALT_CUSP_SYNTH::hint_delay(N))
#define ALT_SEQ_SPACE(X, S)  do{ X; } while (ALT_CUSP_SYNTH::hint_seq_space(S))

#endif


#define ALT_SYNTH	1
#define ALT_ANAL 	2
#define ALT_CYCLE 	3

#ifdef MTI_SYSTEMC
#define ALT_CUSP_USE_WRAPPER
#endif

// ModelSim uses this macro to control visibility of modules.  If not running
// in modelsim then just ignore it.
#ifndef SC_MODULE_EXPORT
#define SC_MODULE_EXPORT(name)
#endif

#endif
