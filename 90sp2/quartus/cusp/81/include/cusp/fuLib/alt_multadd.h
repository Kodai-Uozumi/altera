/*******************************************************************
 *
 * Multiplier-Add function unit.
 * 
 * Function unit computes multadd(a,b,c,d) = a*b + c*d
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *  (2) If the width of the multiplier is more than 32 bits then the output
 *      of integer multiplies will be truncated to 64 bits
 *
 * Function Unit Models:
 *
 * ALT_MULTADD the following operations for simulation and synthesis :
 * (1)  Multiply-Add
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned X Signed integer
 *       (d) Signed X Unsigned integer
 *
 *******************************************************************/
#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif


#ifndef __ALT_MULTADD_H
#define __ALT_MULTADD_H
//--------------------------------------------------------------------
// Multiplier-Add function unit and its named static operators
//--------------------------------------------------------------------
#define WIDTHOUT WIDTH*2+1

template<typename T1, typename T2, typename T3, typename T4>
struct ALT_MULTADD_PROTOTYPE {
    enum { EXISTS = 0 };
};

template <int WIDTH=16, int LATENCY=3, int RESTART=1>
class ALT_MULTADD : public ALT_CUSP_SYNTH::FU
{
public:

    typedef sc_int<WIDTHOUT < SC_INTWIDTH ? WIDTHOUT : SC_INTWIDTH> output_narrow_sint;
    typedef sc_uint<WIDTHOUT < SC_INTWIDTH ? WIDTHOUT : SC_INTWIDTH> output_narrow_uint;

    template<typename T>
    struct FP {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION1_CHOOSER<false, T>::VERSION>::TYPE TYPE;
    };

    template<typename T1, typename T2>
    struct FR {
        typedef typename __ALT_TYPE_CHOOSER<WIDTHOUT, __ALT_FUNCTION2_CHOOSER<false, T1, T2>::VERSION>::TYPE TYPE;
    };
    //--------------------------------------------------------------------
    // multadd() functions
    //--------------------------------------------------------------------
    static output_narrow_uint multAdd
        (const sc_uint<WIDTH>& a,
         const sc_uint<WIDTH>& b,
         const sc_uint<WIDTH>& c,
         const sc_uint<WIDTH>& d)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return (a*b)+(c*d);
    }

    static output_narrow_sint multAdd
        (const sc_uint<WIDTH>& a,
         const sc_int<WIDTH>& b,
         const sc_uint<WIDTH>& c,
         const sc_int<WIDTH>& d)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return (a*b)+(c*d);
    }

    static output_narrow_sint multAdd
        (const sc_int<WIDTH>& a,
         const sc_uint<WIDTH>& b,
         const sc_int<WIDTH>& c,
         const sc_uint<WIDTH>& d)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return (a*b)+(c*d);
    }

    static output_narrow_sint multAdd
        (const sc_int<WIDTH>& a,
         const sc_int<WIDTH>& b,
         const sc_int<WIDTH>& c,
         const sc_int<WIDTH>& d)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return (a*b)+(c*d);
    }

    static sc_biguint<WIDTHOUT> multAdd
        (const sc_biguint<WIDTH>& a,
         const sc_biguint<WIDTH>& b,
         const sc_biguint<WIDTH>& c,
         const sc_biguint<WIDTH>& d)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return (a*b)+(c*d);
    }

    static sc_bigint<WIDTHOUT> multAdd
        (const sc_biguint<WIDTH>& a,
         const sc_bigint<WIDTH>& b,
         const sc_biguint<WIDTH>& c,
         const sc_bigint<WIDTH>& d)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return (a*b)+(c*d);
    }

    static sc_bigint<WIDTHOUT> multAdd
        (const sc_bigint<WIDTH>& a,
         const sc_biguint<WIDTH>& b,
         const sc_bigint<WIDTH>& c,
         const sc_biguint<WIDTH>& d)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return (a*b)+(c*d);
    }

    static sc_bigint<WIDTHOUT> multAdd
        (const sc_bigint<WIDTH>& a,
         const sc_bigint<WIDTH>& b,
         const sc_bigint<WIDTH>& c,
         const sc_bigint<WIDTH>& d)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return (a*b)+(c*d);
    }

    template<typename TA, typename TB>
    static typename FR<TA, TB>::TYPE multAdd
        (const TA& a,
         const TB& b,
         const TA& c,
         const TB& d)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        typedef typename FP<TA>::TYPE FTA;
        typedef typename FP<TB>::TYPE FTB;
        ALT_CUSP_ASSERT
            ((ALT_MULTADD_PROTOTYPE<FTA, FTB, FTA, FTB>::EXISTS),
             "\n"
             "\nERROR:"
             "\n"
             "\nArgument type combination not supported."
             "\nYou might need to cast one or more arguments."
             "\n\n");
        return multAdd(FTA(a), FTB(b), FTA(c), FTB(d));
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_multadd");

#define ALT_MULTADD_PROTOTYPE_EXISTS(T1, T2, T3, T4) struct ALT_MULTADD_PROTOTYPE<T1, T2, T3, T4 > { enum { EXISTS = 1 }; }

template<int WIDTH> ALT_MULTADD_PROTOTYPE_EXISTS(sc_uint<WIDTH>, sc_uint<WIDTH>, sc_uint<WIDTH>, sc_uint<WIDTH>);
template<int WIDTH> ALT_MULTADD_PROTOTYPE_EXISTS(sc_biguint<WIDTH>, sc_biguint<WIDTH>, sc_biguint<WIDTH>, sc_biguint<WIDTH>);
template<int WIDTH> ALT_MULTADD_PROTOTYPE_EXISTS(sc_int<WIDTH>, sc_int<WIDTH>, sc_int<WIDTH>, sc_int<WIDTH>);
template<int WIDTH> ALT_MULTADD_PROTOTYPE_EXISTS(sc_bigint<WIDTH>, sc_bigint<WIDTH>, sc_bigint<WIDTH>, sc_bigint<WIDTH>);
template<int WIDTH> ALT_MULTADD_PROTOTYPE_EXISTS(sc_int<WIDTH>, sc_uint<WIDTH>, sc_int<WIDTH>, sc_uint<WIDTH>);
template<int WIDTH> ALT_MULTADD_PROTOTYPE_EXISTS(sc_bigint<WIDTH>, sc_biguint<WIDTH>, sc_bigint<WIDTH>, sc_biguint<WIDTH>);
template<int WIDTH> ALT_MULTADD_PROTOTYPE_EXISTS(sc_uint<WIDTH>, sc_int<WIDTH>, sc_uint<WIDTH>, sc_int<WIDTH>);
template<int WIDTH> ALT_MULTADD_PROTOTYPE_EXISTS(sc_biguint<WIDTH>, sc_bigint<WIDTH>, sc_biguint<WIDTH>, sc_bigint<WIDTH>);

#endif //__ALT_MULTADD_H
