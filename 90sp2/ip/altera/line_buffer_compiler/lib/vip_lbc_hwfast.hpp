//! \file vip_lbc_hwfast.hpp
//!
//! \author pbrookes
//!
//! \brief Synthesisable Line Buffer Compiler core.

#include <alt_cusp.h>
#include "vip_constants.h"
#include "vip_common.h"

#ifdef DOXYGEN
  #define LBC_NAME LBC_HW
#endif

#ifndef LEGACY_FLOW
	#undef LBC_NAME
	#define LBC_NAME alt_vip_lbc
#endif

//! Map line buffers to Altera on-chip memories using CUSP FU.
//!
//! <b>Compile Time Configuration in IP Toolbench</b>

//! \ingroup HWCores

#define LBC_IN_TYPE sc_uint<LBC_BIT_WIDTH>
#define LBC_OUT_TYPE sc_biguint<LBC_BIT_WIDTH * LBC_NUM_LINE_BUFFERS>

#ifdef __CUSP__
  #define wait(X)
#endif

#pragma cusp_synthesise on
SC_MODULE(LBC_NAME)
{

#ifndef LEGACY_FLOW
	static const char * get_entity_helper_class(void) { 
		return "ip_toolbench/line_buffer_compiler.jar?com.altera.vip.entityinterfaces.helpers.LBCEntityHelper"; 
	}
	
	static const char * get_display_name(void) { 
		return "Line Buffer Compiler"; 
	}
	
	static const char * get_description(void) {
		return "The Line Buffer Compiler efficiently maps video line buffers to Altera on-chip memories.";
	}
	
	static const char * get_product_ids(void) { 
		return "00B8"; 
	}	
	
	#include "vip_elementclass_info.h"
#else
	static const char * get_entity_helper_class(void) { 
		return "default"; 
	}
#endif //LEGACY_FLOW
	
#ifdef SYNTH_MODE
  // Input port wires
  //sc_in<bool> clock;
  //sc_in<bool> reset;

  sc_in<bool> enable;
  sc_in< ALT_TAPPED_DELAY<LBC_BIT_WIDTH, LBC_LINE_LENGTH, LBC_NUM_LINE_BUFFERS>::in_t > din;
  sc_out< ALT_TAPPED_DELAY<LBC_BIT_WIDTH, LBC_LINE_LENGTH, LBC_NUM_LINE_BUFFERS>::out_t > dout;

  ALT_TAPPED_DELAY<LBC_BIT_WIDTH, LBC_LINE_LENGTH, LBC_NUM_LINE_BUFFERS> delay1;

  void behaviour()
  {
    for (;;)
    {
      ALT_ATTRIB(ALT_MOD_SCHED, ALT_MOD_SCHED_ON);
      ALT_ATTRIB(ALT_MIN_ITER, ALT_INFINITY);
      ALT_ATTRIB(ALT_MOD_TARGET, 1);

	  ALT_NOSEQUENCE(if (enable.read()) delay1.write(din.read()));
      dout.write(delay1.read());
    }
  }

#endif //SYNTH_MODE

	SC_HAS_PROCESS(LBC_NAME);

	LBC_NAME(sc_module_name name_, const char* PARAMETERISATION="<lbcParams><LBC_NAME>my_lbc</LBC_NAME><LBC_LINE_LENGTH>64</LBC_LINE_LENGTH><LBC_NUM_LINE_BUFFERS>3</LBC_NUM_LINE_BUFFERS><LBC_BIT_WIDTH>8</LBC_BIT_WIDTH></lbcParams>") : sc_module(name_), param(PARAMETERISATION)
    {
#ifdef SYNTH_MODE     
        SC_THREAD(behaviour);
#endif //SYNTH_MODE
    }
    
    const char* param;

};
