/*******************************************************************
 *
 * Exit function unit and its named static operators
 *
 * Notes:
 *  (1) Do not include this file directly - use alt_cusp.h
 *
 * ALT_EXIT the following operations for simulation and synthesis :
 * (1)  Exit
 *
 *******************************************************************/

#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_EXIT_H
#define __ALT_EXIT_H

#define exitSI exit
#define exitUI exit

//--------------------------------------------------------------------
// Exit function unit and its named static operators
//--------------------------------------------------------------------

template<int WIDTH=16>
class ALT_EXIT : public ALT_CUSP_SYNTH::FU
{
public:

    typedef ALT_FAST_INT_TYPES<WIDTH> fast_sint_types;
    typedef typename fast_sint_types::sint fast_sint;
    typedef typename fast_sint_types::uint fast_uint;

    template<typename T>
    struct F1 {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION1_CHOOSER<true, T>::VERSION>::TYPE TYPE;
    };

    static void exit(const fast_sint& val) ALT_GNU_ATTRIBUTE(noreturn)
    {
        printf("ALT_EXIT invoked to end simulation: return code '%d'\n", (int)val);
        fflush(stdout);
        ::exit(val);
    }

    static void exit(const fast_uint& val) ALT_GNU_ATTRIBUTE(noreturn)
    {
        printf("ALT_EXIT invoked to end simulation: return code '%d'\n", (int)val);
        fflush(stdout);
        ::exit(val);
    }

    template<typename TV>
    static void exit(const TV& val) ALT_CUSP_SYNTH_MODE(inline)
    {
        exit(typename F1<TV>::TYPE(val));
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_exit");

#endif
