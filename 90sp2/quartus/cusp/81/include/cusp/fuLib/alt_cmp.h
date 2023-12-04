/*******************************************************************
 *
 * Comparator function unit and its named static operators
 *
 * Notes:
 *  (1) Do not include this file directly - use alt_cusp.h
 *
 * Function Unit Models:
 *
 * ALT_CMP the following operations for simulation and synthesis :
 * (1)  Equality
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 * (2)  Inequality
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 * (3)  Greater than
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 * (4)  Less than
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 * (5)  Greater than or equals
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 * (6)  Less than or equals
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 *
 *******************************************************************/

#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_CMP_H
#define __ALT_CMP_H

template <int WIDTH=16, int LATENCY=0, int RESTART=1>
class ALT_CMP : public ALT_CUSP_SYNTH::FU
{

public:

    typedef ALT_FAST_INT_TYPES<WIDTH> fast_sint_types;
    typedef typename fast_sint_types::sint fast_sint;
    typedef typename fast_sint_types::uint fast_uint;

    template<typename T>
    struct F1 {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION1_CHOOSER<true, T>::VERSION>::TYPE TYPE;
    };

    template<typename T1, typename T2>
    struct F2 {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION2_CHOOSER<true, T1, T2>::VERSION>::TYPE TYPE;
    };

   //--------------------------------------------------------------------
   // Greater than methods
   //--------------------------------------------------------------------
    static bool gt
        (const fast_uint& a,
         const fast_uint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a > b ;
    }

    static bool gtUI
        (const fast_uint& a,
         const fast_uint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return gt(a, b);
    }

    static bool gt
        (const fast_sint& a,
         const fast_sint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a > b;
    }

    static bool gtSI
        (const fast_sint& a,
         const fast_sint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return gt(a, b);
    }

    static bool gt
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsUF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsUF(b, bAligned);

        return aAligned > bAligned;
    }

    static bool gtUF
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return gt(a, b);
    }

    static bool gt
        (const sc_fix& a,
         const sc_fix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsSF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsSF(b, bAligned);

        return aAligned > bAligned;
    }

    static bool gtSF
        (const sc_fix& a,
         const sc_fix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return gt(a, b);
    }

    template<typename TA, typename TB>
    static bool gt
        (const TA& a,
         const TB& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return gt(typename F2<TA, TB>::TYPE(a), typename F2<TA, TB>::TYPE(b));
    }

    //--------------------------------------------------------------------
    // Less than methods
    //--------------------------------------------------------------------
    static bool lt
        (const fast_uint& a,
         const fast_uint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a < b;
    }

    static bool ltUI
        (const fast_uint& a,
         const fast_uint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return lt(a, b);
    }

    static bool lt
        (const fast_sint& a,
         const fast_sint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a < b;
    }

    static bool ltSI
        (const fast_sint& a,
         const fast_sint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return lt(a, b);
    }

    static bool lt
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsUF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsUF(b, bAligned);

        return aAligned < bAligned;
    }

    static bool ltUF
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return lt(a, b);
    }

    static bool lt
        (const sc_fix& a,
         const sc_fix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsSF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsSF(b, bAligned);

        return aAligned < bAligned;
    }

    static bool ltSF
        (const sc_fix& a,
         const sc_fix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return lt(a, b);
    }

    template<typename TA, typename TB>
    static bool lt
        (const TA& a,
         const TB& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return lt(typename F2<TA, TB>::TYPE(a), typename F2<TA, TB>::TYPE(b));
    }

    //--------------------------------------------------------------------
    // Greater than or equals methods
    //--------------------------------------------------------------------
    static bool gte
        (const fast_uint& a,
         const fast_uint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a >= b;
    }

    static bool gteUI
        (const fast_uint& a,
         const fast_uint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return gte(a, b);
    }

    static bool gte
        (const fast_sint& a,
         const fast_sint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a >= b;
    }

    static bool gteSI
        (const fast_sint& a,
         const fast_sint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return gte(a, b);
    }

    static bool gte
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsUF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsUF(b, bAligned);

        return aAligned >= bAligned;
    }

    static bool gteUF
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return gte(a, b);
    }

    static bool gte
        (const sc_fix& a,
         const sc_fix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsSF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsSF(b, bAligned);

        return aAligned >= bAligned;
    }

    static bool gteSF
        (const sc_fix& a,
         const sc_fix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return gte(a, b);
    }

    template<typename TA, typename TB>
    static bool gte
        (const TA& a,
         const TB& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return gte(typename F2<TA, TB>::TYPE(a), typename F2<TA, TB>::TYPE(b));
    }

    //--------------------------------------------------------------------
    // Less than or equals methods
    //--------------------------------------------------------------------
    static bool lte
        (const fast_uint& a,
         const fast_uint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a <= b;
    }

    static bool lteUI
        (const fast_uint& a,
         const fast_uint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return lte(a, b);
    }

    static bool lte
        (const fast_sint& a,
         const fast_sint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a <= b;
    }

    static bool lteSI
        (const fast_sint& a,
         const fast_sint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return lte(a, b);
    }

    static bool lte
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsUF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsUF(b, bAligned);

        return aAligned <= bAligned;
    }

    static bool lteUF
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return lte(a, b);
    }

    static bool lte
        (const sc_fix& a,
         const sc_fix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {

        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsSF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsSF(b, bAligned);

        return aAligned <= bAligned;
    }

    static bool lteSF
        (const sc_fix& a,
         const sc_fix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return lte(a, b);
    }

    template<typename TA, typename TB>
    static bool lte
        (const TA& a,
         const TB& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return lte(typename F2<TA, TB>::TYPE(a), typename F2<TA, TB>::TYPE(b));
    }

    //--------------------------------------------------------------------
    // Equals methods
    //--------------------------------------------------------------------
    static bool e
        (const fast_uint& a,
         const fast_uint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a == b;
    }

    static bool eUI
        (const fast_uint& a,
         const fast_uint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return e(a, b);
    }

    static bool e
        (const fast_sint& a,
         const fast_sint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a == b;
    }

    static bool eSI
        (const fast_sint& a,
         const fast_sint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return e(a, b);
    }

    static bool e
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {

        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsUF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsUF(b, bAligned);

        return aAligned == bAligned;
    }

    static bool eUF
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return e(a, b);
    }

    static bool e
        (const sc_fix &a,
         const sc_fix &b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsSF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsSF(b, bAligned);

        return aAligned == bAligned;
    }

    static bool eSF
        (const sc_fix &a,
         const sc_fix &b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return e(a, b);
    }

    static bool e
        (const sc_bv<WIDTH>& a,
         const sc_bv<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a == b;
    }

    static bool eBV
        (const sc_bv<WIDTH>& a,
         const sc_bv<WIDTH>& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return e(a, b);
    }

    template<typename TA, typename TB>
    static bool e
        (const TA& a,
         const TB& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return e(typename F2<TA, TB>::TYPE(a), typename F2<TA, TB>::TYPE(b));
    }

    //--------------------------------------------------------------------
    // Not-equals methods
    //--------------------------------------------------------------------
    static bool ne
        (const fast_uint& a,
         const fast_uint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a != b;
    }

    static bool neUI
        (const fast_uint& a,
         const fast_uint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ne(a, b);
    }

    static bool ne
        (const fast_sint& a,
         const fast_sint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a != b;
    }

    static bool neSI
        (const fast_sint& a,
         const fast_sint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ne(a, b);
    }

    static bool ne
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsUF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsUF(b, bAligned);

        return aAligned != bAligned;
    }

    static bool neUF
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ne(a, b);
    }

    static bool ne
        (const sc_fix& a,
         const sc_fix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        int intWidth = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix aAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidth, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsSF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsSF(b, bAligned);

        return aAligned != bAligned;
    }

    static bool neSF
        (const sc_fix& a,
         const sc_fix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ne(a, b);
    }

    static bool ne
        (const sc_bv<WIDTH>& a,
         const sc_bv<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a != b;
    }

    static bool neBV
        (const sc_bv<WIDTH>& a,
         const sc_bv<WIDTH>& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ne(a, b);
    }

    template<typename TA, typename TB>
    static bool ne
        (const TA& a,
         const TB& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ne(typename F2<TA, TB>::TYPE(a), typename F2<TA, TB>::TYPE(b));
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_cmp");

#endif
