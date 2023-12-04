/*******************************************************************
 * 
 * Memory (MEM) function units.
 * 
 * 
 * 
 * Abbreviations :
 *  W          = WIDTH (-1 => size as needed )
 *  L          = LATENCY
 *  R          = RESTART
 *  DEPTH	   = NUMBER OF ENTRIES (-1 => size as needed (register file))
 *  R_PORTS	   = NUMBER OF READ-ONLY PORTS
 *  W_PORTS	   = NUMBER OF WRITE-ONLY PORTS
 *  RW_PORTS   = NUMBER OF READ-/WRITE PORTS
 *  MODE       = IMPLEMENTATION MODE
 *  QM         = QUANTIZATION MODE(FOR FIXED POINT)
 *  OFM        = OVERFLOW MODE (FOR FIXED POINT)
 *  NSB        = NUMBER OF SATURATED BITS (USED WITH OFM)
 * 
 * 
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *  (2) ALT_MEM should be used with extreme care. 
 * 
 * 
 * Function Unit Models:
 * 
 * ALT_REGISTER_FILE  - A memory used for storing multiple variables
 * 
 * ALT_MEM - A memory used for storing a single array.
 * 
 *
 *  
 *******************************************************************/
 
#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_MEM_H
#define __ALT_MEM_H
 
#define ALT_MEM_MODE_UNDEFINED  -1
#define ALT_MEM_MODE_AUTO  -1
#define ALT_MEM_MODE_LE    0
#define ALT_MEM_MODE_M512  1
#define ALT_MEM_MODE_M4K   2
#define ALT_MEM_MODE_MRAM  3

//--------------------------------------------------------------------
// A register file allocates space for any variables bound to it
//-------------------------------------------------------------------- 

template <int W=-1, int L=2, int R=1, int DEPTH=-1, int R_PORTS=0, int W_PORTS=0, int RW_PORTS=2, int MODE=-1> 
class ALT_REGISTER_FILE : public ALT_CUSP_SYNTH::FU
{
} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_register_file");


//--------------------------------------------------------------------
// A memory 
//-------------------------------------------------------------------- 

template <int W=18, int L=2, int R=1, int DEPTH=32, int R_PORTS=0, int W_PORTS=0, int RW_PORTS=2, int MODE=-1> 
class ALT_MEM
{
#ifdef _GNUC_
#warning "Consider using ALT_REGISTER_FILE instead of ALT_MEM"
#endif

};
#endif
