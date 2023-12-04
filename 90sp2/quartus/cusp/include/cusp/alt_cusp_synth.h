/*******************************************************************
 * 
 * Functions to pass information to the CusP synthesiser
 * 
 *******************************************************************/


#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_CUSP_SYNTH_H
#define __ALT_CUSP_SYNTH_H

/*
 * This namespace contains functions which pass options to the CusP
 * synthesiser.  They should do nothing in compiled code.
 */
#ifdef ALT_CUSP_SYNTHESIS
#define ALT_CUSP_INLINE
#else
#define ALT_CUSP_INLINE inline
#endif

namespace ALT_CUSP_SYNTH
{
	// Functions used by ALT_ATTRIB to set loop attributes
	ALT_CUSP_INLINE void loop_min_iter(int value) {}
	ALT_CUSP_INLINE void loop_min_iter(const char * value) {} // for use with "infinity"
	ALT_CUSP_INLINE void loop_max_iter(int value) {}
	ALT_CUSP_INLINE void loop_max_iter(const char * value) {} // for use with "infinity"
	ALT_CUSP_INLINE void loop_step_iter(int value) {}
	ALT_CUSP_INLINE void loop_mod_sched(bool enable) {}
	ALT_CUSP_INLINE void loop_unroll(bool enable) {}
	ALT_CUSP_INLINE void loop_tile(int tile_size) {}
	ALT_CUSP_INLINE void loop_mod_target(int target) {}
	ALT_CUSP_INLINE void loop_schedule_algorithm(const char * algorithm) {}
	ALT_CUSP_INLINE void loop_reverse(bool enable) {}
    ALT_CUSP_INLINE void loop_skidding(bool enable) {}

	ALT_CUSP_INLINE void op(const char * kind);
	
	// Hints used on expressions, returns the value of the expression
	template <class T> ALT_CUSP_INLINE T hint_port    (T expr, const char * name) { return expr; }
	template <class T> ALT_CUSP_INLINE T hint_evaluate(T expr, bool enable)       { return expr; }
	template <class T> ALT_CUSP_INLINE T hint_stage   (T expr, int cycles)        { return expr; }

	// Hints used on statements, returns false so it can be used as the test
	// expression of a do..while loop.
	ALT_CUSP_INLINE bool hint_nosequence(bool param) { return false; }
	ALT_CUSP_INLINE bool hint_delay(int cycles)      { return false; }
	ALT_CUSP_INLINE bool hint_seq_space   (const char * name)    { return false; }

	// Deprecated constructor only method which gets numbers out of XML strings
	ALT_CUSP_INLINE int extract_from_xml(const char * xml, const char * pattern, int defvalue);

	// Binding a variable to an instance of this requests combinatorial logic
	class WIRE { } ALT_CUSP_FUNCTIONAL_UNIT("mode:wire");

	// All function units must be derived from this class so they can be bound
	// to soft threads
	class FU { };	
	ALT_CUSP_INLINE void bind_function_unit(FU & fu) {}
};

#undef ALT_CUSP_INLINE

#endif
