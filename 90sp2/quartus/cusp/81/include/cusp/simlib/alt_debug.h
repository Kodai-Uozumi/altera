/*******************************************************************
 * 
 * Debug function unit and its named static operators
 * 
 * 
 * 
 * Abbreviations:
 *  None.
 * 
 * 
 * Notes:
 *  (1) Do not include this file directly - use alt_cusp.h
 * 
 * 
 *******************************************************************/
 
 
#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_DEBUG_H
#define __ALT_DEBUG_H
//--------------------------------------------------------------------
// Debug function unit and its named static operators
//--------------------------------------------------------------------
 
template <int W=16> 
class ALT_DEBUG : public ALT_CUSP_SYNTH::FU
{
public:
    static void debugSI(sc_int<W> a, sc_int<W> b)
    {
        printf("DEBUG[%d]=%d\n",(int)a,(int)b);
    }

    static void debugUI(sc_uint<W> a, sc_uint<W> b)
    {
        printf("DEBUG[%d]=%d\n",(int)a,(int)b);
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_debug");

#endif
