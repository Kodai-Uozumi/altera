/*******************************************************************
 *
 * Multiplier-accumulator function unit.
 *
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *
 *******************************************************************/

#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_MAC_H
#define __ALT_MAC_H

//--------------------------------------------------------------------
// Multiplier-accumulator function unit and its named static operators
//--------------------------------------------------------------------

//TODO: Support for 36x36 bit multiply and mac operations with output size of 72

template<int WIDTH=16, int WIDTHOUT=32, int LATENCY=3>
class ALT_MAC : public ALT_CUSP_SYNTH::FU
{
public:

    enum { NARROW_WIDTHOUT = WIDTHOUT < SC_INTWIDTH ? WIDTHOUT : SC_INTWIDTH };
    typedef sc_int<NARROW_WIDTHOUT> output_narrow_sint;
    typedef sc_uint<NARROW_WIDTHOUT> output_narrow_uint;

    template<typename T>
    struct F1P {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION1_CHOOSER<false, T>::VERSION>::TYPE TYPE;
    };

    template<typename T>
    struct F1R {
        typedef typename __ALT_TYPE_CHOOSER<WIDTHOUT, __ALT_FUNCTION1_CHOOSER<true, T>::VERSION>::TYPE TYPE;
    };

    template<typename T1, typename T2>
    struct F2R {
        typedef typename __ALT_TYPE_CHOOSER<WIDTHOUT, __ALT_FUNCTION2_CHOOSER<true, T1, T2>::VERSION>::TYPE TYPE;
    };

    //--------------------------------------------------------------------
    // mult() functions
    //--------------------------------------------------------------------

    static output_narrow_uint mult
        (const sc_uint<WIDTH>& a,
         const sc_uint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a * b;
    }

    static sc_biguint<WIDTHOUT> mult
        (const sc_biguint<WIDTH>& a,
         const sc_biguint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a * b;
    }

    static output_narrow_sint mult
        (const sc_int<WIDTH>& a,
         const sc_uint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a * b;
    }

    static sc_bigint<WIDTHOUT> mult
        (const sc_bigint<WIDTH>& a,
         const sc_biguint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a * b;
    }

    static output_narrow_sint mult
        (const sc_uint<WIDTH>& a,
         const sc_int<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a * b;
    }

    static sc_bigint<WIDTHOUT> mult
        (const sc_biguint<WIDTH>& a,
         const sc_bigint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a * b;
    }

    static output_narrow_sint mult
        (const sc_int<WIDTH>& a,
         const sc_int<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a * b;
    }

    static sc_bigint<WIDTHOUT> mult
        (const sc_bigint<WIDTH>& a,
         const sc_bigint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a * b;
    }

    template<typename TA, typename TB>
    static typename F2R<TA, TB>::TYPE mult
        (const TA& a,
         const TB& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult
            (typename F1P<TA>::TYPE(a),
             typename F1P<TB>::TYPE(b));
    }

    static output_narrow_uint mac
        (const sc_uint<WIDTH>& a,
         const sc_uint<WIDTH>& b,
         const output_narrow_uint& c)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return c + output_narrow_uint(a * b);
    }

    static sc_biguint<WIDTHOUT> mac
        (const sc_biguint<WIDTH>& a,
         const sc_biguint<WIDTH>& b,
         const sc_biguint<WIDTHOUT>& c)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return c + a * b;
    }

    static output_narrow_sint mac
        (const sc_int<WIDTH>& a,
         const sc_uint<WIDTH>& b,
         const output_narrow_sint& c)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return c + output_narrow_sint(a * b);
    }

    static sc_bigint<WIDTHOUT> mac
        (const sc_bigint<WIDTH>& a,
         const sc_biguint<WIDTH>& b,
         const sc_bigint<WIDTHOUT>& c)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return c + a * b;
    }

    static output_narrow_sint mac
        (const sc_uint<WIDTH>& a,
         const sc_int<WIDTH>& b,
         const output_narrow_sint& c)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return c + output_narrow_sint(a * b);
    }

    static sc_bigint<WIDTHOUT> mac
        (const sc_biguint<WIDTH>& a,
         const sc_bigint<WIDTH>& b,
         const sc_bigint<WIDTHOUT>& c)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return c + a * b;
    }

    static output_narrow_sint mac
        (const sc_int<WIDTH>& a,
         const sc_int<WIDTH>& b,
         const output_narrow_sint& c)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return c + output_narrow_sint(a * b);
    }

    static sc_bigint<WIDTHOUT> mac
        (const sc_bigint<WIDTH>& a,
         const sc_bigint<WIDTH>& b,
         const sc_bigint<WIDTHOUT>& c)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return c + a * b;
    }

    template<typename TA, typename TB, typename TC>
    static typename F1R<TC>::TYPE mac
        (const TA& a,
         const TB& b,
         const TC& c)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mac
            (typename F1P<TC>::TYPE(a),
             typename F1P<TC>::TYPE(b),
             typename F1R<TC>::TYPE(c));
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_mac");

#endif
