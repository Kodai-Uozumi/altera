/*******************************************************************
 * 
 * Floating Point Arithemetic Unit (AU) Function Unit.
 * 
 * 
 * 
 * Abbreviations :
 *  W          = WIDTH
 *  L          = LATENCY
 *  R          = RESTART
 * 
 * 
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 * 
 * 
 * Function Unit Models:
 * 
 * ALT_FP_AU the following operations for simulation and synthesis :
 * (1)  Addition
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 * (2)  Subtraction
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 *******************************************************************/


#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif


#ifndef __ALT_FP_AU_H
#define __ALT_FP_AU_H
//--------------------------------------------------------------------
// Arithemetic function unit and its named static operators
//--------------------------------------------------------------------

template <int W = 32, int L = 7, int R = 1> 
class ALT_FP_AU : public ALT_CUSP_SYNTH::FU
{

public:
   
    //--------------------------------------------------------------------
    // add() functions
    //--------------------------------------------------------------------
    static float addSP(
                                const float &a, 
                                const float &b
                                ) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(W != 32)
    	{
    		cout << "WARNING: Double precision floating point arithmetic unit can not perform single precision operations.\n";
			cout << "         Consider using W = 32.\n";
    		return float(0.0);
    	}

        return a+b;
    }

    static double addDP(
                               const double &a, 
                               const double &b
                               ) ALT_GNU_ATTRIBUTE(pure)
    {
    	
    	if(W != 64)
    	{
    		cout << "WARNING: Single precision floating point arithmetic unit can not perform double precision operations.\n";
			cout << "         Consider using W = 64.\n";
    		return float(0.0);
    	}

        return a+b;
    }
   
    
   
    //--------------------------------------------------------------------
    // sub() functions
    //--------------------------------------------------------------------
    static float subSP(
                                const float &a, 
                                const float &b
                                ) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(W != 32)
    	{
    		cout << "WARNING: Double precision floating point arithmetic unit can not perform single precision operations.\n";
			cout << "         Consider using W = 32.\n";
    		return float(0.0);
    	}
    	
        return a-b;
    }

    static double subDP(
                               const double &a, 
                               const double &b
                               ) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(W != 64)
    	{
    		cout << "WARNING: Single precision floating point arithmetic unit can not perform double precision operations.\n";
			cout << "         Consider using W = 64.\n";
    		return float(0.0);
    	}
    	
        return a-b;
    }
    
   
    //--------------------------------------------------------------------
    // cAddSub() functions
    //--------------------------------------------------------------------
    static float cAddSubSP(
                                const float &a, 
                                const float &b,
                                const float &currVal,
                                bool enable,
                                bool doSub
                                ) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(W != 32)
    	{
    		cout << "WARNING: Double precision floating point arithmetic unit can not perform single precision operations.\n";
			cout << "         Consider using W = 32.\n";
    		return float(0.0);
    	}
    	
        if(enable)
        {
            if (doSub) return subSP(a,b);
            else return addSP(a,b);
        }
        else
        {
        	return currVal;
        }
    }

    static double cAddSubDP(
                               const double &a, 
                               const double &b,
                               const double &currVal,
                               bool enable,
                               bool doSub
                               ) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(W != 64)
    	{
    		cout << "WARNING: Single precision floating point arithmetic unit can not perform double precision operations.\n";
			cout << "         Consider using W = 64.\n";
    		return float(0.0);
    	}
    	
        if(enable)
        {
            if (doSub) return subDP(a,b);
            else return addDP(a,b);
        }
        else
        {
        	return currVal;
        }
    }
   
    
    
   //--------------------------------------------------------------------
    // addSub() functions
    //--------------------------------------------------------------------
    static float addSubSP(
                                const float &a, 
                                const float &b,
                                bool doSub
                                ) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(W != 32)
    	{
    		cout << "WARNING: Double precision floating point arithmetic unit can not perform single precision operations.\n";
			cout << "         Consider using W = 32.\n";
    		return float(0.0);
    	}
    	
        if (doSub) return subSP(a,b);
        else return addSP(a,b);
    }
    
    static double addSubDP(
                                const double &a, 
                                const double &b,
                                bool doSub
                                ) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(W != 64)
    	{
    		cout << "WARNING: Single precision floating point arithmetic unit can not perform double precision operations.\n";
			cout << "         Consider using W = 64.\n";
    		return float(0.0);
    	}
    	
        if (doSub) return subDP(a,b);
        else return addDP(a,b);
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_fp_au");

#endif




