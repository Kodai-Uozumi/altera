/*******************************************************************
 * 
 * Floating Point Comparator function unit and its named static operators
 * 
 * 
 * 
 * Abbreviations:
 *  W = WIDTH
 *  L = LATENCY
 *  R = RESTART
 * 
 * 
 * Notes:
 *  (1) Do not include this file directly - use alt_cusp.h
 * 
 * 
 * Function Unit Models:
 * 
 * ALT_FP_CMP the following operations for simulation and synthesis :
 * (1)  Equality
 *       (a) Float
 *       (b) Double
 * (2)  Inequality
 *       (a) Float
 *       (b) Double
 * (3)  Greater than
 *       (a) Float
 *       (b) Double
 * (4)  Less than
 *       (a) Float
 *       (b) Double
 * (5)  Greater than or equals
 *       (a) Float
 *       (b) Double
 * (6)  Less than or equals
 *       (a) Float
 *       (b) Double
 * 
 *******************************************************************/


#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_FP_CMP_H
#define __ALT_FP_CMP_H

template <int W=32, int L=7, int R=1> 
class ALT_FP_CMP : public ALT_CUSP_SYNTH::FU
{

public:	

   //--------------------------------------------------------------------
   // Greater than methods
   //--------------------------------------------------------------------
	static bool gtSP(float a, float b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a > b ;
	}
   
    static bool gtDP(double a, double b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a > b ;
	}
   
   
   //--------------------------------------------------------------------
   // Less than methods
   //--------------------------------------------------------------------
	static bool ltSP(float a, float b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a < b;
	}
	
	static bool ltDP(double a, double b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a < b;
	}
	
	
   
   //--------------------------------------------------------------------
   // Greater than or equals methods
   //--------------------------------------------------------------------
	static bool gteSP(float a, float b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a >= b;
	}
	
	
	static bool gteDP(double a, double b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a >= b;
	}
	
	
   //--------------------------------------------------------------------
   // Less than or equals methods
   //--------------------------------------------------------------------
	static bool lteSP(float a, float b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a <= b;
	}
	
	static bool lteDP(double a, double b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a <= b;
	}
	
	
   
   
   //--------------------------------------------------------------------
   // Equals methods
   //--------------------------------------------------------------------
	static bool eSP(float a, float b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a == b;
	}
	
	static bool eDP(double a, double b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a == b;
	}
	
   
	
   //--------------------------------------------------------------------
   // Not-equals methods
   //--------------------------------------------------------------------
	static bool neSP(float a, float b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a != b;
	}
	
	
	static bool neDP(double a, double b) ALT_GNU_ATTRIBUTE(pure)
	{
		return a != b;
	}
	
} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_fp_cmp");

#endif
