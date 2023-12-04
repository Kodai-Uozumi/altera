/*******************************************************************
 * 
 * Barrel Shifter function units.
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
 * ALT_SHIFT the following operations for simulation and synthesis :
 * (1)  Barrel Shifting
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 *       (e) Bit vector.
 *       (a) Unsigned biginteger
 *       (b) Signed biginteger
 * 
 *******************************************************************/
 
#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif


#ifndef __ALT_SHIFT_H
#define __ALT_SHIFT_H


#define ALT_SHIFT_MODE_LOGICAL  0
#define ALT_SHIFT_MODE_ARITH    1
#define ALT_SHIFT_MODE_ROTATE   2

#define ALT_SHIFT_DIREC_LEFT   0
#define ALT_SHIFT_DIREC_RIGHT  1
#define ALT_SHIFT_DIREC_BOTH   2

template <int W=16, int L=0, int R=1, int SHIFT_W=4, int MODE=ALT_SHIFT_MODE_ARITH, int DIRECTION=ALT_SHIFT_DIREC_RIGHT>
class ALT_SHIFT : public ALT_CUSP_SYNTH::FU
{
public:
    static sc_uint<W> leftUI(const sc_uint<W> &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_RIGHT)
    	{
    		printf("WARNING: Left shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_RIGHT.\n");
			printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_LEFT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_uint<W> result;
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    		sc_bv<W> result_bv;
			sc_bv<W> data_bv;
			data_bv = (sc_bv<W>) data;
			result_bv = data_bv.lrotate(shift);
			result = (sc_uint<W>) result_bv;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		result = data << shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
		    result = data << shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);
    	}
    	
    	return result;
    }

	static sc_int<W> leftSI(const sc_int<W> &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_RIGHT)
    	{
    		printf("WARNING: Left shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_RIGHT.\n");
			printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_LEFT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_int<W> result;
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    		sc_bv<W> result_bv;
			sc_bv<W> data_bv;
			data_bv = (sc_bv<W>) data;
			result_bv = data_bv.lrotate(shift);
			result = (sc_int<W>) result_bv;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		result = data << shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		result = data << shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }

	static sc_bv<W> leftBV(const sc_bv<W> &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_RIGHT)
    	{
    		printf("WARNING: Left shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_RIGHT.\n");
			printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_LEFT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_bv<W> result;
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
			result = data;
			result = result.lrotate(shift);
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		result = data << shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		result = data << shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);
    	}
    	
    	return result;
    }


    static sc_ufix leftUF(const sc_ufix &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_RIGHT)
    	{
    		printf("WARNING: Left shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_RIGHT.\n");
			printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_LEFT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_ufix result(W, data.iwl(), SC_TRN, SC_WRAP, 0);

    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    		
			printf("WARNING: Fixed Rotation not supported on ALT_SHIFT,\n"); 
			result = data;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		result = data << shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
		    result = data << shift;
			
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }

	static sc_fix leftSF(const sc_fix &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_RIGHT)
    	{
    		printf("WARNING: Left shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_RIGHT.\n");
			printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_LEFT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_fix result(W, data.iwl(), SC_TRN, SC_WRAP, 0);
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
   		   printf("WARNING: Fixed Rotation not supported on ALT_SHIFT,\n"); 
		   result = data;

    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		result = data << shift;
			
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		result = data << shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }

    static sc_biguint<W> leftUI(const sc_unsigned &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_RIGHT)
    	{
    		printf("WARNING: Left shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_RIGHT.\n");
			printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_LEFT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_biguint<W> result;
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    		sc_bv<W> result_bv;
			sc_bv<W> data_bv;
			data_bv = (sc_bv<W>) data;
			result_bv = data_bv.lrotate(shift);
			result = (sc_biguint<W>) result_bv;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		result = data << shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
		    result = data << shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);
    	}
    	
    	return result;
    }

	static sc_bigint<W> leftSI(const sc_signed &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_RIGHT)
    	{
    		printf("WARNING: Left shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_RIGHT.\n");
			printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_LEFT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_bigint<W> result;
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    		sc_bv<W> result_bv;
			sc_bv<W> data_bv;
			data_bv = (sc_bv<W>) data;
			result_bv = data_bv.lrotate(shift);
			result = (sc_bigint<W>) result_bv;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		result = data << shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		result = data << shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }

	// Right shift operators
    static sc_uint<W> rightUI(const sc_uint<W> &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_LEFT)
    	{
    		printf("WARNING: Right shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_LEFT.\n");
			printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_RIGHT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_uint<W> result;
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    		sc_bv<W> result_bv;
			sc_bv<W> data_bv;
			data_bv = (sc_bv<W>) data;
			result_bv = data_bv.rrotate(shift);
			result = (sc_uint<W>) result_bv;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
			result = data >> shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		printf("WARNING: Unsigned integer arithmetic right shift is not supported on ALT_SHIFT.\n");
			printf("         Consider using logical shift instead.\n");
		    result = data;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }


	static sc_int<W> rightSI(const sc_int<W> &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_LEFT)
    	{
    		printf("WARNING: Right shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_LEFT.\n");
    		printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_RIGHT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
			return data;
    	}
		
    	
    	sc_int<W> result;
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    		sc_bv<W> result_bv;
			sc_bv<W> data_bv;
			data_bv = (sc_bv<W>) data;
			result_bv = data_bv.rrotate(shift);
			result = (sc_int<W>) result_bv;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		sc_uint<W> data_int;
			data_int = (sc_uint<W>) data;
			result = data_int >> shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		result = data >> shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }


	static sc_bv<W> rightBV(const sc_bv<W> &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_LEFT)
    	{
    		printf("WARNING: Right shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_LEFT.\n");
            printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_RIGHT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_bv<W> result;
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
			result = data;
			result = result.rrotate(shift);
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		result = data >> shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		result = data >> shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }



	static sc_ufix rightUF(const sc_ufix &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_LEFT)
    	{
    		printf("WARNING: Right shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_LEFT.\n");
			printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_RIGHT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_ufix result(W, data.iwl(), SC_TRN, SC_WRAP, 0);
    	    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    		printf("WARNING: Fixed Rotation not supported on ALT_SHIFT,\n"); 
			result = data;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		result = data >> shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		result = data >> shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }


	static sc_fix rightSF(const sc_fix &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_LEFT)
    	{
    		printf("WARNING: Right shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_LEFT.\n");
    		printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_RIGHT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
			return data;
    	}
		
    	
    	sc_fix result(W, data.iwl(), SC_TRN, SC_WRAP, 0);
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    	    printf("WARNING: Fixed Rotation not supported on ALT_SHIFT,\n"); 
			result = data;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		sc_ufix data_int(W, data.iwl(), SC_TRN, SC_WRAP, 0);
			data_int = data;
			result = data_int >> shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		result = data >> shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }

    static sc_biguint<W> rightUI(const sc_unsigned &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_LEFT)
    	{
    		printf("WARNING: Right shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_LEFT.\n");
			printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_RIGHT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
    		return data;
    	}
		
    	
    	sc_biguint<W> result;
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    		sc_bv<W> result_bv;
			sc_bv<W> data_bv;
			data_bv = (sc_bv<W>) data;
			result_bv = data_bv.rrotate(shift);
			result = (sc_biguint<W>) result_bv;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
			result = data >> shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		printf("WARNING: Unsigned integer arithmetic right shift is not supported on ALT_SHIFT.\n");
			printf("         Consider using logical shift instead.\n");
		    result = data;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }


	static sc_bigint<W> rightSI(const sc_signed &data, const sc_uint<SHIFT_W> &shift) ALT_GNU_ATTRIBUTE(pure)
    {
    	if(DIRECTION == ALT_SHIFT_DIREC_LEFT)
    	{
    		printf("WARNING: Right shift is not supported on ALT_SHIT with DIRECTION = ALT_SHIFT_DIREC_LEFT.\n");
    		printf("         Consider using DIRECTION = ALT_SHIFT_DIREC_RIGHT or  DIRECTION = ALT_SHIFT_DIREC_BOTH.\n");
			return data;
    	}
		
    	
    	sc_bigint<W> result;
    	
    	if(MODE == ALT_SHIFT_MODE_ROTATE)
    	{
    		sc_bv<W> result_bv;
			sc_bv<W> data_bv;
			data_bv = (sc_bv<W>) data;
			result_bv = data_bv.rrotate(shift);
			result = (sc_bigint<W>) result_bv;
			
    	}
    	else if(MODE == ALT_SHIFT_MODE_LOGICAL)
    	{
    		sc_biguint<W> data_int;
			data_int = (sc_biguint<W>) data;
			result = data_int >> shift;
    	} 
    	else if(MODE == ALT_SHIFT_MODE_ARITH)
    	{
    		result = data >> shift;
    	} 
    	else
    	{
            printf("WARNING: Shift Mode %d is not supported\n", MODE);    		
    	}
    	
    	return result;
    }


} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_shift");

#endif
