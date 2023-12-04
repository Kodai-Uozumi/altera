/*******************************************************************
 *
 * Immediate function units.
 *
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *
 * Function Unit Models:
 *
 * ALT_IMMED the following operations for simulation and synthesis :
 * (1)  Value setting
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 *       (e) Bit vector
 *
 *
 *******************************************************************/

#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_IMMED_H
#define __ALT_IMMED_H

/*******************************************************************
 * Immediate function unit and its named static operators
 *******************************************************************/

template <int WIDTH=32>
class ALT_IMMED : public ALT_CUSP_SYNTH::FU
{
public:

    typedef ALT_FAST_INT_TYPES<WIDTH> fast_int_types;
    typedef typename fast_int_types::sint fast_sint;
    typedef typename fast_int_types::uint fast_uint;

    template<bool use_fast_int, typename T>
    struct F1 {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION1_CHOOSER<use_fast_int, T>::VERSION>::TYPE TYPE;
    };

    static fast_sint set(const fast_sint& a) ALT_GNU_ATTRIBUTE(pure)
    {
        return a;
    }

    static fast_sint setSI(const fast_sint& a) ALT_CUSP_SYNTH_MODE(inline)
    {
        return set(a);
    }

    static fast_uint set(const fast_uint& a) ALT_GNU_ATTRIBUTE(pure)
    {
        return a;
    }

    static fast_uint setUI(const fast_uint& a) ALT_CUSP_SYNTH_MODE(inline)
    {
        return set(a);
    }

    static sc_bv<WIDTH> set(const sc_bv<WIDTH>& a) ALT_GNU_ATTRIBUTE(pure)
    {
        return a;
    }

    static sc_bv<WIDTH> setBV(const sc_bv<WIDTH>& a) ALT_CUSP_SYNTH_MODE(inline)
    {
        return set(a);
    }

    static sc_fix set(const sc_fix& a) ALT_GNU_ATTRIBUTE(pure)
    {
        sc_fix aTrn = ALT_UTIL::truncateSF(a, WIDTH);
        ALT_UTIL::warnIfNotEqualsSF(a, aTrn);
        return aTrn;
    }

    static sc_fix setSF(const sc_fix& a) ALT_CUSP_SYNTH_MODE(inline)
    {
        return set(a);
    }

    static sc_ufix set(const sc_ufix& a) ALT_GNU_ATTRIBUTE(pure)
    {
        sc_ufix aTrn = ALT_UTIL::truncateUF(a, WIDTH);
        ALT_UTIL::warnIfNotEqualsUF(a, aTrn);
        return aTrn;
    }

    static sc_ufix setUF(const sc_ufix& a) ALT_CUSP_SYNTH_MODE(inline)
    {
        return set(a);
    }

    static float setSP(float a) ALT_GNU_ATTRIBUTE(pure)
    {
        return a;
    }

    static double setDP(double a) ALT_GNU_ATTRIBUTE(pure)
    {
        return a;
    }

    template<typename TA>
    static typename F1<false, TA>::TYPE set(const TA& a) ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F1<false, TA>::TYPE(set(typename F1<true, TA>::TYPE(a)));
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_immed");

#endif
