/*******************************************************************
 * 
 * Floating Point Multiplier Function Unit.
 * 
 * 
 * Abbreviations :
 *  W          = WIDTH
 *  L          = LATENCY
 *  R          = RESTART
 * 
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 * 
 * 
 * Function Unit Models:
 * 
 * ALT_MULT the following operations for simulation and synthesis :
 * (1)  Multiplication
 *       (a) Single precision
 *       (b) Double precision
 * 
 *******************************************************************/
#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif


#ifndef __ALT_FP_MULT_H
#define __ALT_FP_MULT_H
//--------------------------------------------------------------------
// Multiplier function unit and its named static operators
//--------------------------------------------------------------------

template <int W=32, int L=5, int R=1> 
class ALT_FP_MULT : public ALT_CUSP_SYNTH::FU
{
public:
   //--------------------------------------------------------------------
   // mult() functions
   //--------------------------------------------------------------------
	
	//-------------------------------------------------------------------
	// Single precision multiplication
	//-------------------------------------------------------------------
	static float multSP(const float &a, const float &b) ALT_GNU_ATTRIBUTE(pure)
	{
		if(W != 32)
    	{
    		cout << "WARNING: Double precision floating point multiplier can not perform single precision multiplication.\n";
			cout << "         Consider using W = 32.\n";
    		return float(0.0);
    	}
		return a*b; 	 
	}
	
	//-------------------------------------------------------------------
	// Double precision multiplication
	//-------------------------------------------------------------------
	static double multDP(const double &a, const double &b) ALT_GNU_ATTRIBUTE(pure)
	{
		if(W != 64)
    	{
    		cout << "WARNING: Single precision floating point multiplier can not perform double precision multiplication.\n";
			cout << "         Consider using W = 64.\n";
    		return double(0.0);
    	}
		return a*b; 	 
	}
} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_fp_mult");

#endif
