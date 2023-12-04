/*******************************************************************
 *
 * Arithmetic unit (AU) function units.
 *
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *
 *******************************************************************/

#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_AU_H
#define __ALT_AU_H

//--------------------------------------------------------------------
// Arithmetic function unit and its named static operators
//--------------------------------------------------------------------

template <int WIDTH = 16, int LATENCY = 1, int RESTART = 1>
class ALT_AU : public ALT_CUSP_SYNTH::FU
{
public:

    typedef ALT_FAST_INT_TYPES<WIDTH> fast_int_types;
    typedef typename fast_int_types::sint fast_sint;
    typedef typename fast_int_types::uint fast_uint;

    template<bool use_fast_int, typename T>
    struct F1 {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION1_CHOOSER<use_fast_int, T>::VERSION>::TYPE TYPE;
    };

    template<bool use_fast_int, typename T1, typename T2>
    struct F2 {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION2_CHOOSER<use_fast_int, T1, T2>::VERSION>::TYPE TYPE;
    };

    //--------------------------------------------------------------------
    // Unsigned integer
    // conditional addition/subtraction/loading/synchronous-clear
    // Conditionals are enable, doSClr, doSLd and doSub in that order
    // of precedence.
    //--------------------------------------------------------------------
    static fast_uint cAddSubSLdSClr
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& nextVal,
         const fast_uint& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub)
        ALT_GNU_ATTRIBUTE(pure)
    {
        if (!enable)
            return currVal;
        if (doSClr)
            return 0;
        if (doSLd)
            return nextVal;
        return doSub ? a - b : a + b;
    }

    static fast_uint cAddSubSLdSClrUI
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& nextVal,
         const fast_uint& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSubSLdSClr(a, b, nextVal, currVal, enable, doSClr, doSLd, doSub);
    }

    //--------------------------------------------------------------------
    // Signed integer
    // conditional addition/subtraction/loading/synchronous-clear
    // Conditionals are enable, doSClr, doSLd and doSub in that order
    // of precedence.
    //--------------------------------------------------------------------
    static fast_sint cAddSubSLdSClr
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& nextVal,
         const fast_sint& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub)
        ALT_GNU_ATTRIBUTE(pure)
    {
        if (!enable)
            return currVal;
        if (doSClr)
            return 0;
        if (doSLd)
            return nextVal;
        return doSub ? a - b : a + b;
    }

    static fast_sint cAddSubSLdSClrSI
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& nextVal,
         const fast_sint& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSubSLdSClr(a, b, nextVal, currVal, enable, doSClr, doSLd, doSub);
    }

    //--------------------------------------------------------------------
    // Unsigned fix
    // Conditional addition/subtraction/loading/synchronous-clear
    // Conditionals are enable, doSClr, doSLd and doSub in that order
    // of precedence.
    //--------------------------------------------------------------------
    static sc_ufix cAddSubSLdSClr
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& nextVal,
         const sc_ufix& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, currVal, enable, doSClr, doSLd, doSub, 0);
    }

    static sc_ufix cAddSubSLdSClrUF
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& nextVal,
         const sc_ufix& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSubSLdSClr(a, b, nextVal, currVal, enable, doSClr, doSLd, doSub);
    }

    //--------------------------------------------------------------------
    // Signed fix
    // conditional addition/subtraction/loading/synchronous-clear
    // Conditionals are enable, doSClr, doSLd and doSub in that order of
    // of precedence.
    //--------------------------------------------------------------------
    static sc_fix cAddSubSLdSClr
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& nextVal,
         const sc_fix& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, currVal, enable, doSClr, doSLd, doSub, 0);
    }

    static sc_fix cAddSubSLdSClrSF
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& nextVal,
         const sc_fix& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSubSLdSClr(a, b, nextVal, currVal, enable, doSClr, doSLd, doSub);
    }

    template<typename TA, typename TB, typename TN, typename TC>
    static typename F2<false, TA, TB>::TYPE cAddSubSLdSClr
        (const TA& a,
         const TB& b,
         const TN& nextVal,
         const TC& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TA, TB>::TYPE(cAddSubSLdSClr
            (typename F2<true, TA, TB>::TYPE(a),
             typename F2<true, TA, TB>::TYPE(b),
             typename F2<true, TA, TB>::TYPE(nextVal),
             typename F2<true, TA, TB>::TYPE(currVal),
             enable, doSClr, doSLd, doSub));
    }

    //--------------------------------------------------------------------
    // Integer/Fixed conditional loading/synchronous-clear
    //--------------------------------------------------------------------
    static fast_uint cSLdSClr
        (const fast_uint& nextVal,
         const fast_uint& currVal,
         bool enable,
         bool doSClr,
         bool doSLd)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(0, 0, nextVal, currVal, enable && (doSClr || doSLd), doSClr, doSLd, false);
    }

    static fast_uint cSLdSClrUI
        (const fast_uint& nextVal,
         const fast_uint& currVal,
         bool enable,
         bool doSClr,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cSLdSClr(nextVal, currVal, enable, doSClr, doSLd);
    }

    static fast_sint cSLdSClr
        (const fast_sint& nextVal,
         const fast_sint& currVal,
         bool enable,
         bool doSClr,
         bool doSLd)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(0, 0, nextVal, currVal, enable && (doSClr || doSLd), doSClr, doSLd, false);
    }

    static fast_sint cSLdSClrSI
        (const fast_sint& nextVal,
         const fast_sint& currVal,
         bool enable,
         bool doSClr,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cSLdSClr(nextVal, currVal, enable, doSClr, doSLd);
    }

    static sc_ufix cSLdSClr
        (const sc_ufix& nextVal,
         const sc_ufix& currVal,
         bool enable,
         bool doSClr,
         bool doSLd)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(0, 0, nextVal, currVal, enable && (doSClr || doSLd), doSClr, doSLd, false);
    }

    static sc_ufix cSLdSClrUF
        (const sc_ufix& nextVal,
         const sc_ufix& currVal,
         bool enable,
         bool doSClr,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cSLdSClr(nextVal, currVal, enable, doSClr, doSLd);
    }

    static sc_fix cSLdSClr
        (const sc_fix& nextVal,
         const sc_fix& currVal,
         bool enable,
         bool doSClr,
         bool doSLd)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(0, 0, nextVal, currVal, enable && (doSClr || doSLd), doSClr, doSLd, false);
    }

    static sc_fix cSLdSClrSF
        (const sc_fix& nextVal,
         const sc_fix& currVal,
         bool enable,
         bool doSClr,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cSLdSClr(nextVal, currVal, enable, doSClr, doSLd);
    }

    static sc_bv<WIDTH> cSLdSClr
        (const sc_bv<WIDTH>& nextVal,
         const sc_bv<WIDTH>& currVal,
         bool enable,
         bool doSClr,
         bool doSLd)
         ALT_GNU_ATTRIBUTE(pure)
    {
        if (!enable)
            return currVal;
        if (doSClr)
            return 0;
        if (doSLd)
            return nextVal;
        return currVal;
    }

    static sc_bv<WIDTH> cSLdSClrBV
        (const sc_bv<WIDTH>& nextVal,
         const sc_bv<WIDTH>& currVal,
         bool enable,
         bool doSClr,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cSLdSClr(nextVal, currVal, enable, doSClr, doSLd);
    }

    //--------------------------------------------------------------------
    // add() functions
    //--------------------------------------------------------------------
    static fast_uint add
        (const fast_uint& a,
         const fast_uint& b)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return a + b;
    }

    static fast_uint addUI
        (const fast_uint& a,
         const fast_uint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return add(a, b);
    }

    static fast_sint add
        (const fast_sint& a,
         const fast_sint& b)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return a + b;
    }

    static fast_sint addSI
        (const fast_sint& a,
         const fast_sint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return add(a, b);
    }

    static sc_ufix add
        (const sc_ufix& a,
         const sc_ufix& b)
         ALT_GNU_ATTRIBUTE(pure)
    {
           int intWidthOfOut = (a.iwl() > b.iwl() ? a.iwl() : b.iwl());

        sc_ufix aAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        sc_ufix bAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsUF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsUF(b, bAligned);

        sc_ufix result(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        result = aAligned + bAligned;
        return result;
    }

    static sc_ufix addUF
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return add(a, b);
    }

    static sc_fix add
        (const sc_fix& a,
         const sc_fix& b)
         ALT_GNU_ATTRIBUTE(pure)
    {
           int intWidthOfOut = (a.iwl() > b.iwl() ? a.iwl() : b.iwl());

        sc_fix aAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsSF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsSF(b, bAligned);

        sc_fix result(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        result = aAligned + bAligned;
        return result;
    }

    static sc_fix addSF
        (const sc_fix& a,
         const sc_fix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return add(a, b);
    }

    template<typename TA, typename TB>
    static typename F2<false, TA, TB>::TYPE add
        (const TA& a,
         const TB& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TA, TB>::TYPE(add(typename F2<true, TA, TB>::TYPE(a), typename F2<true, TA, TB>::TYPE(b)));
    }

    //--------------------------------------------------------------------
    // sub() functions
    //--------------------------------------------------------------------
    static fast_uint sub
        (const fast_uint& a,
         const fast_uint& b)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return a - b;
    }

    static fast_uint subUI
        (const fast_uint& a,
         const fast_uint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return sub(a, b);
    }

    static fast_sint sub
        (const fast_sint& a,
         const fast_sint& b)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return a - b;
    }

    static fast_sint subSI
        (const fast_sint& a,
         const fast_sint& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return sub(a, b);
    }

    static sc_ufix sub
        (const sc_ufix& a,
         const sc_ufix& b)
         ALT_GNU_ATTRIBUTE(pure)
    {
           int intWidthOfOut = (a.iwl() > b.iwl() ? a.iwl() : b.iwl());

        sc_ufix aAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        sc_ufix bAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsUF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsUF(b, bAligned);

        sc_ufix result(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        result = aAligned - bAligned;
        return result;
    }

    static sc_ufix subUF
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return sub(a, b);
    }

    static sc_fix sub(const sc_fix& a,
                      const sc_fix& b)
                      ALT_GNU_ATTRIBUTE(pure)
    {
           int intWidthOfOut = (a.iwl() > b.iwl() ? a.iwl() : b.iwl());

        sc_fix aAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        sc_fix bAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        aAligned = a;
        bAligned = b;

        ALT_UTIL::warnIfNotEqualsSF(a, aAligned);
        ALT_UTIL::warnIfNotEqualsSF(b, bAligned);

        sc_fix result(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        result = aAligned - bAligned;
        return result;
    }

    static sc_fix subSF
        (const sc_fix& a,
         const sc_fix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return sub(a, b);
    }

    template<typename TA, typename TB>
    static typename F2<false, TA, TB>::TYPE sub
        (const TA& a,
         const TB& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TA, TB>::TYPE(sub(typename F2<true, TA, TB>::TYPE(a), typename F2<true, TA, TB>::TYPE(b)));
    }

    //--------------------------------------------------------------------
    // cAddSubSLd() functions
    //--------------------------------------------------------------------
    static fast_uint cAddSubSLd
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& nextVal,
         const fast_uint& currVal,
         bool enable,
         bool doSLd,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, currVal, enable, false, doSLd, doSub);
    }

    static fast_uint cAddSubSLdUI
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& nextVal,
         const fast_uint& currVal,
         bool enable,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSubSLd(a, b, nextVal, currVal, enable, doSLd, doSub);
    }

    static fast_sint cAddSubSLd
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& nextVal,
         const fast_sint& currVal,
         bool enable,
         bool doSLd,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, currVal, enable, false, doSLd, doSub);
    }

    static fast_sint cAddSubSLdSI
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& nextVal,
         const fast_sint& currVal,
         bool enable,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSubSLd(a, b, nextVal, currVal, enable, doSLd, doSub);
    }

    static sc_ufix cAddSubSLd
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& nextVal,
         const sc_ufix& currVal,
         bool enable,
         bool doSLd,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, currVal, enable, false, doSLd, doSub, 0);
    }

    static sc_ufix cAddSubSLdUF
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& nextVal,
         const sc_ufix& currVal,
         bool enable,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSubSLd(a, b, nextVal, currVal, enable, doSLd, doSub);
    }

    static sc_fix cAddSubSLd
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& nextVal,
         const sc_fix& currVal,
         bool enable,
         bool doSLd,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, currVal, enable, false, doSLd, doSub, 0);
    }

    static sc_fix cAddSubSLdSF
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& nextVal,
         const sc_fix& currVal,
         bool enable,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSubSLd(a, b, nextVal, currVal, enable, doSLd, doSub);
    }

    template<typename TA, typename TB, typename TN, typename TC>
    static typename F2<false, TA, TB>::TYPE cAddSubSLd
        (const TA& a,
         const TB& b,
         const TN& nextVal,
         const TC& currVal,
         bool enable,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TA, TB>::TYPE(cAddSubSLd
            (typename F2<true, TA, TB>::TYPE(a),
             typename F2<true, TA, TB>::TYPE(b),
             typename F2<true, TA, TB>::TYPE(nextVal),
             typename F2<true, TA, TB>::TYPE(currVal),
             enable, doSLd, doSub));
    }

    //--------------------------------------------------------------------
    // addSubSLd() functions
    //--------------------------------------------------------------------
    static fast_uint addSubSLd
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& nextVal,
         bool doSLd,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, nextVal, true, false, doSLd, doSub);
    }

    static fast_uint addSubSLdUI
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& nextVal,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSubSLd(a, b, nextVal, doSLd, doSub);
    }

    static fast_sint addSubSLd
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& nextVal,
         bool doSLd,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, nextVal, true, false, doSLd, doSub);
    }

    static fast_sint addSubSLdSI
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& nextVal,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSubSLd(a, b, nextVal, doSLd, doSub);
    }

    static sc_ufix addSubSLd
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& nextVal,
         bool doSLd,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, nextVal, true, false, doSLd, doSub, 0);
    }

    static sc_ufix addSubSLdUF
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& nextVal,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSubSLd(a, b, nextVal, doSLd, doSub);
    }

    static sc_fix addSubSLd
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& nextVal,
         bool doSLd,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, nextVal, true, false, doSLd, doSub, 0);
    }

    static sc_fix addSubSLdSF
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& nextVal,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSubSLd(a, b, nextVal, doSLd, doSub);
    }

    template<typename TA, typename TB, typename TN>
    static typename F2<false, TA, TB>::TYPE addSubSLd
        (const TA& a,
         const TB& b,
         const TN& nextVal,
         bool doSLd,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TA, TB>::TYPE(addSubSLd
            (typename F2<true, TA, TB>::TYPE(a),
             typename F2<true, TA, TB>::TYPE(b),
             typename F2<true, TA, TB>::TYPE(nextVal),
             doSLd, doSub));
    }

    //--------------------------------------------------------------------
    // addSubSLdSClr() functions
    //--------------------------------------------------------------------
    static fast_uint addSubSLdSClr
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& nextVal,
         bool doSLd,
         bool doSClr,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, nextVal, true, doSClr, doSLd, doSub);
    }

    static fast_uint addSubSLdSClrUI
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& nextVal,
         bool doSLd,
         bool doSClr,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSubSLdSClr(a, b, nextVal, doSLd, doSClr, doSub);
    }

    static fast_sint addSubSLdSClr
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& nextVal,
         bool doSLd,
         bool doSClr,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, nextVal, true, doSClr, doSLd, doSub);
    }

    static fast_sint addSubSLdSClrSI
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& nextVal,
         bool doSLd,
         bool doSClr,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSubSLdSClr(a, b, nextVal, doSLd, doSClr, doSub);
    }

    static sc_ufix addSubSLdSClr
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& nextVal,
         bool doSLd,
         bool doSClr,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, nextVal, true, doSClr, doSLd, doSub, 0);
    }

    static sc_ufix addSubSLdSClrUF
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& nextVal,
         bool doSLd,
         bool doSClr,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSubSLdSClr(a, b, nextVal, doSLd, doSClr, doSub);
    }

    static sc_fix addSubSLdSClr
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& nextVal,
         bool doSLd,
         bool doSClr,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, nextVal, nextVal, true, doSClr, doSLd, doSub, 0);
    }

    static sc_fix addSubSLdSClrSF
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& nextVal,
         bool doSLd,
         bool doSClr,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSubSLdSClr(a, b, nextVal, doSLd, doSClr, doSub);
    }

    template<typename TA, typename TB, typename TN>
    static typename F2<false, TA, TB>::TYPE addSubSLdSClr
        (const TA& a,
         const TB& b,
         const TN& nextVal,
         bool doSLd,
         bool doSClr,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TA, TB>::TYPE(addSubSLdSClr
            (typename F2<true, TA, TB>::TYPE(a),
             typename F2<true, TA, TB>::TYPE(b),
             typename F2<true, TA, TB>::TYPE(nextVal),
             doSLd, doSClr, doSub));
    }

    //--------------------------------------------------------------------
    // cAddSub() functions
    //--------------------------------------------------------------------
    static fast_uint cAddSub
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& currVal,
         bool enable,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, 0, currVal, enable, false, false, doSub);
    }

    static fast_uint cAddSubUI
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& currVal,
         bool enable,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSub(a, b, currVal, enable, doSub);
    }

    static fast_sint cAddSub
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& currVal,
         bool enable,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, 0, currVal, enable, false, false, doSub);
    }

    static fast_sint cAddSubSI
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& currVal,
         bool enable,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSub(a, b, currVal, enable, doSub);
    }

    static sc_ufix cAddSub
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& currVal,
         bool enable,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, 0, currVal, enable, false, false, doSub, 0);
    }

    static sc_ufix cAddSubUF
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& currVal,
         bool enable,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSub(a, b, currVal, enable, doSub);
    }

    static sc_fix cAddSub
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& currVal,
         bool enable,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(a, b, 0, currVal, enable, false, false, doSub, 0);
    }

    static sc_fix cAddSubSF
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& currVal,
         bool enable,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cAddSub(a, b, currVal, enable, doSub);
    }

    template<typename TA, typename TB, typename TC>
    static typename F2<false, TA, TB>::TYPE cAddSub
        (const TA& a,
         const TB& b,
         const TC& currVal,
         bool enable,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TA, TB>::TYPE(cAddSub
            (typename F2<true, TA, TB>::TYPE(a),
             typename F2<true, TA, TB>::TYPE(b),
             typename F2<true, TA, TB>::TYPE(currVal),
             enable, doSub));
    }

    //--------------------------------------------------------------------
    // addSub() functions
    //--------------------------------------------------------------------
    static fast_uint addSub
        (const fast_uint& a,
         const fast_uint& b,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return doSub ? sub(a, b) : add(a, b);
    }

    static fast_uint addSubUI
        (const fast_uint& a,
         const fast_uint& b,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSub(a, b, doSub);
    }

    static fast_sint addSub
        (const fast_sint& a,
         const fast_sint& b,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return doSub ? sub(a, b) : add(a, b);
    }

    static fast_sint addSubSI
        (const fast_sint& a,
         const fast_sint& b,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSub(a, b, doSub);
    }

    static sc_ufix addSub
        (const sc_ufix& a,
         const sc_ufix& b,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return doSub ? sub(a, b) : add(a, b);
    }

    static sc_ufix addSubUF
        (const sc_ufix& a,
         const sc_ufix& b,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSub(a, b, doSub);
    }

    static sc_fix addSub
        (const sc_fix& a,
         const sc_fix& b,
         bool doSub)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return doSub ? sub(a, b) : add(a, b);
    }

    static sc_fix addSubSF
        (const sc_fix& a,
         const sc_fix& b,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return addSub(a, b, doSub);
    }

    template<typename TA, typename TB>
    static typename F2<false, TA, TB>::TYPE addSub
        (const TA& a,
         const TB& b,
         bool doSub)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TA, TB>::TYPE(addSub(typename F2<true, TA, TB>::TYPE(a), typename F2<true, TA, TB>::TYPE(b), doSub));
    }

    //--------------------------------------------------------------------
    // cLd() functions (Conditional load)
    //--------------------------------------------------------------------
    static fast_uint cLd
        (const fast_uint& c,
         const fast_uint& currVal,
         bool doSLd)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(0u, 0u, c, currVal, doSLd, false, doSLd, false);
    }

    static fast_uint cLdUI
        (const fast_uint& c,
         const fast_uint& currVal,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cLd(c, currVal, doSLd);
    }

    static fast_sint cLd
        (const fast_sint& c,
         const fast_sint& currVal,
         bool doSLd)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(0, 0, c, currVal, doSLd, false, doSLd, false);
    }

    static fast_sint cLdSI
        (const fast_sint& c,
         const fast_sint& currVal,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cLd(c, currVal, doSLd);
    }

    static sc_ufix cLd
        (const sc_ufix& c,
         const sc_ufix& currVal,
         bool doSLd)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(0, 0, c, currVal, doSLd, false, doSLd, false, 0);
    }

    static sc_ufix cLdUF
        (const sc_ufix& c,
         const sc_ufix& currVal,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cLd(c, currVal, doSLd);
    }

    static sc_fix cLd
        (const sc_fix& c,
         const sc_fix& currVal,
         bool doSLd)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cAddSubSLdSClr(0, 0, c, currVal, doSLd, false, doSLd, false,  0);
    }

    static sc_fix cLdSF
        (const sc_fix& c,
         const sc_fix& currVal,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cLd(c, currVal, doSLd);
    }

    static sc_bv<WIDTH> cLd
        (const sc_bv<WIDTH>& c,
         const sc_bv<WIDTH>& currVal,
         bool doSLd)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return cSLdSClr(c, currVal, doSLd, false, doSLd);
    }

    static sc_bv<WIDTH> cLdBV
        (const sc_bv<WIDTH>& c,
         const sc_bv<WIDTH>& currVal,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cLd(c, currVal, doSLd);
    }

    template<typename TC, typename TCV>
    static typename F1<false, TC>::TYPE cLd
        (const TC& c,
         const TCV& currVal,
         bool doSLd)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F1<false, TC>::TYPE(cLd(typename F1<true, TC>::TYPE(c), typename F1<true, TC>::TYPE(currVal), doSLd));
    }

    //--------------------------------------------------------------------
    // sLd() functions (Synchronous load)
    //--------------------------------------------------------------------
    static const fast_uint& sLd
        (const fast_uint& c)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return c;
    }

    static const fast_uint& sLdUI
        (const fast_uint& c)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return sLd(c);
    }

    static const fast_sint& sLd
        (const fast_sint& c)
         ALT_GNU_ATTRIBUTE(pure)
         ALT_CUSP_ATTRIBUTE1(cusp_synth, call)
    {
        return c;
    }

    static const fast_sint& sLdSI
        (const fast_sint& c)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return sLd(c);
    }

    static sc_ufix sLd
        (const sc_ufix& c)
         ALT_GNU_ATTRIBUTE(pure)
         ALT_CUSP_ATTRIBUTE1(cusp_synth, call)
    {
        sc_ufix result(WIDTH, c.iwl(), SC_TRN, SC_WRAP, 0);
        result = c;
        ALT_UTIL::warnIfNotEqualsUF(c, result);
        return result;
    }

    static sc_ufix sLdUF
        (const sc_ufix& c)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return sLd(c);
    }

    static sc_fix sLd
        (const sc_fix& c)
         ALT_GNU_ATTRIBUTE(pure)
         ALT_CUSP_ATTRIBUTE1(cusp_synth, call)
    {
        sc_fix result(WIDTH, c.iwl(), SC_TRN, SC_WRAP, 0);
        result = c;
        ALT_UTIL::warnIfNotEqualsSF(c, result);
        return result;
    }

    static sc_fix sLdSF
        (const sc_fix& c)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return sLd(c);
    }

    static const sc_bv<WIDTH>& sLd
        (const sc_bv<WIDTH>& c)
         ALT_GNU_ATTRIBUTE(pure)
         ALT_CUSP_ATTRIBUTE1(cusp_synth, call)
    {
        return c;
    }

    static const sc_bv<WIDTH>& sLdBV
        (const sc_bv<WIDTH>& c)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return sLd(c);
    }

    template<typename TC>
    static typename F1<false, TC>::TYPE sLd
        (const TC& c)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F1<false, TC>::TYPE(sLd(typename F1<true, TC>::TYPE(c)));
    }

    //--------------------------------------------------------------------
    // muxLd() functions (Multiplexed load)
    //--------------------------------------------------------------------
    static const fast_uint& muxLd
        (const fast_uint& a,
         const fast_uint& b,
         bool loadSecond)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return !loadSecond ? a : b;
    }

    static const fast_uint& muxLdUI
        (const fast_uint& a,
         const fast_uint& b,
         bool loadSecond)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return muxLd(a, b, loadSecond);
    }

    static const fast_sint& muxLd
        (const fast_sint& a,
         const fast_sint& b,
         bool loadSecond)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return !loadSecond ? a : b;
    }

    static const fast_sint& muxLdSI
        (const fast_sint& a,
         const fast_sint& b,
         bool loadSecond)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return muxLd(a, b, loadSecond);
    }

    static sc_ufix muxLd
        (const sc_ufix& a,
         const sc_ufix& b,
         bool loadSecond)
         ALT_GNU_ATTRIBUTE(pure)
    {
        int iwl = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_ufix result(WIDTH, iwl, SC_TRN, SC_WRAP, 0);
        result = !loadSecond ? a : b;
        !loadSecond ? ALT_UTIL::warnIfNotEqualsUF(a, result) : ALT_UTIL::warnIfNotEqualsUF(b, result);
        return result;
    }

    static sc_ufix muxLdUF
        (const sc_ufix& a,
         const sc_ufix& b,
         bool loadSecond)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return muxLd(a, b, loadSecond);
    }

    static sc_fix muxLd
        (const sc_fix& a,
         const sc_fix& b,
         bool loadSecond)
         ALT_GNU_ATTRIBUTE(pure)
    {
        int iwl = a.iwl() > b.iwl() ? a.iwl() : b.iwl();
        sc_fix result(WIDTH, iwl, SC_TRN, SC_WRAP, 0);
        result = !loadSecond ? a : b;
        !loadSecond ? ALT_UTIL::warnIfNotEqualsSF(a, result) : ALT_UTIL::warnIfNotEqualsSF(b, result);
        return result;
    }

    static sc_fix muxLdSF
        (const sc_fix& a,
         const sc_fix& b,
         bool loadSecond)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return muxLd(a, b, loadSecond);
    }

    static const sc_bv<WIDTH> muxLd
        (const sc_bv<WIDTH>& a,
         const sc_bv<WIDTH>& b,
         bool loadSecond)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return !loadSecond ? a : b;
    }

    static const sc_bv<WIDTH> muxLdBV
        (const sc_bv<WIDTH>& a,
         const sc_bv<WIDTH>& b,
         bool loadSecond)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return muxLd(a, b, loadSecond);
    }

    template<typename TA, typename TB>
    static typename F2<false, TA, TB>::TYPE muxLd
        (const TA& a,
         const TB& b,
         bool loadSecond)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TA, TB>::TYPE(muxLd(typename F2<true, TA, TB>::TYPE(a), typename F2<true, TA, TB>::TYPE(b), loadSecond));
    }

    //--------------------------------------------------------------------
    // mCLd() functions (Multiple conditional load)
    //--------------------------------------------------------------------
    static const fast_uint& mCLd
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& currVal,
         bool loadA,
         bool loadB)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return loadA ? a : loadB ? b : currVal;
    }

    static const fast_uint& mCLdUI
        (const fast_uint& a,
         const fast_uint& b,
         const fast_uint& currVal,
         bool loadA,
         bool loadB)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mCLd(a, b, currVal, loadA, loadB);
    }

    static const fast_sint& mCLd
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& currVal,
         bool loadA,
         bool loadB)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return loadA ? a : loadB ? b : currVal;
    }

    static const fast_sint& mCLdSI
        (const fast_sint& a,
         const fast_sint& b,
         const fast_sint& currVal,
         bool loadA,
         bool loadB)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mCLd(a, b, currVal, loadA, loadB);
    }

    static sc_ufix mCLd
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& currVal,
         bool loadA,
         bool loadB)
         ALT_GNU_ATTRIBUTE(pure)
    {
        sc_ufix result(WIDTH, currVal.iwl(), SC_TRN, SC_WRAP, 0);
        if (loadA)
        {
            result = a;
            ALT_UTIL::warnIfNotEqualsUF(a, result);
            return result;
        }
        else if (loadB)
        {
            result = b;
            ALT_UTIL::warnIfNotEqualsUF(b, result);
            return result;
        }
        else
            return currVal;
    }

    static sc_ufix mCLdUF
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& currVal,
         bool loadA,
         bool loadB)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mCLd(a, b, currVal, loadA, loadB);
    }

    static sc_fix mCLd
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& currVal,
         bool loadA,
         bool loadB)
         ALT_GNU_ATTRIBUTE(pure)
    {
        sc_fix result(WIDTH, currVal.iwl(), SC_TRN, SC_WRAP, 0);
        if (loadA)
        {
            result = a;
            ALT_UTIL::warnIfNotEqualsSF(a, result);
            return result;
        }
        else if (loadB)
        {
            result = b;
            ALT_UTIL::warnIfNotEqualsSF(b, result);
            return result;
        }
        else
            return currVal;
    }

    static sc_fix mCLdSF
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& currVal,
         bool loadA,
         bool loadB)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mCLd(a, b, currVal, loadA, loadB);
    }

    static const sc_bv<WIDTH> mCLd
        (const sc_bv<WIDTH>& a,
         const sc_bv<WIDTH>& b,
         const sc_bv<WIDTH>& currVal,
         bool loadA,
         bool loadB)
         ALT_GNU_ATTRIBUTE(pure)
    {
        return loadA ? a : loadB ? b : currVal;
    }

    static const sc_bv<WIDTH> mCLdBV
        (const sc_bv<WIDTH>& a,
         const sc_bv<WIDTH>& b,
         const sc_bv<WIDTH>& currVal,
         bool loadA,
         bool loadB)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mCLd(a, b, currVal, loadA, loadB);
    }

    template<typename TA, typename TB, typename TC>
    static typename F2<false, TA, TB>::TYPE mCLd
        (const TA& a,
         const TB& b,
         const TC& currVal,
         bool loadA,
         bool loadB)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TA, TB>::TYPE(mCLd(typename F2<true, TA, TB>::TYPE(a), typename F2<true, TA, TB>::TYPE(b), typename F2<true, TA, TB>::TYPE(currVal), loadA, loadB));
    }

    //--------------------------------------------------------------------
    // sClr() functions (Synchronous clear)
    //--------------------------------------------------------------------

    static fast_uint sClr() ALT_GNU_ATTRIBUTE(pure)
    {
        fast_uint zero = 0;
        return cAddSubSLdSClr(zero, zero, zero, zero, true, true, false, false);
    }

    template<typename T>
    static const T sClr()
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return (T)sClr();
    }

    static fast_uint sClrUI() ALT_CUSP_SYNTH_MODE(inline)
    {
        return sClr<fast_uint>();
    }

    static fast_sint sClrSI() ALT_CUSP_SYNTH_MODE(inline)
    {
        return sClr<fast_sint>();
    }

    static sc_bv<WIDTH> sClrBV() ALT_CUSP_SYNTH_MODE(inline)
    {
        return sClr<sc_bv<WIDTH> >();
    }

private:

    //--------------------------------------------------------------------
    // Unsigned fix
    // conditional addition/subtraction/loading/synchronous-clear
    // Conditionals are enable, doSClr, doSLd and doSub in that order of
    // of precedence.
    // If the integer word length of "a" and "b" don't match, they will be
    // aligned by deleting the LSBs if necessary.
    // If the word length of either "a" or "b" is greater than the input
    // bit width of the fuction unit "WIDTH", the LSBs will be deleted.
    //--------------------------------------------------------------------
    static sc_ufix cAddSubSLdSClr
        (const sc_ufix& a,
         const sc_ufix& b,
         const sc_ufix& nextVal,
         const sc_ufix& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub,
         short iwlMode)
    {
        int intWidthOfOut;

        switch(iwlMode)
        {
            case 0:
                intWidthOfOut = currVal.iwl();
                break;
            case 1:
                intWidthOfOut = nextVal.iwl();
                break;
            default : intWidthOfOut = (a.iwl() > b.iwl() ? a.iwl() : b.iwl());
        }

        sc_ufix result(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);

        if (enable)
        {
            if (doSClr)
                result = 0;
            else if (doSLd)
            {
                result = nextVal;
                ALT_UTIL::warnIfNotEqualsUF(nextVal, result);
            }
            else
            {
                sc_ufix aAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
                sc_ufix bAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
                aAligned = a;
                bAligned = b;

                ALT_UTIL::warnIfNotEqualsUF(a, aAligned);
                ALT_UTIL::warnIfNotEqualsUF(b, bAligned);

                result = doSub ? aAligned - bAligned : aAligned + bAligned;
            }
        }
        else
        {
            result = currVal;
            ALT_UTIL::warnIfNotEqualsUF(currVal, result);
        }

        return result;
    }


    //--------------------------------------------------------------------
    // Signed fix
    // conditional addition/subtraction/loading/synchronous-clear
    // Conditionals are enable, doSClr, doSLd and doSub in that order of
    // of precedence.
    // If the integer word length of "a" and "b" don't match, they will be
    // aligned by deleting the LSBs if necessary.
    // If the word length of either "a" or "b" is greater than the input
    // bit width of the fuction unit "WIDTH", the LSBs will be deleted.
    //--------------------------------------------------------------------
    static sc_fix cAddSubSLdSClr
        (const sc_fix& a,
         const sc_fix& b,
         const sc_fix& nextVal,
         const sc_fix& currVal,
         bool enable,
         bool doSClr,
         bool doSLd,
         bool doSub,
         short iwlMode)
    {
        int intWidthOfOut;

        switch(iwlMode)
        {
            case 0:
                intWidthOfOut = currVal.iwl();
                break;
            case 1:
                intWidthOfOut = nextVal.iwl();
                break;
            default : intWidthOfOut = (a.iwl() > b.iwl() ? a.iwl() : b.iwl());
        }

        sc_fix result(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);

        if (enable)
        {
            if (doSClr)
                result = 0;
            else if (doSLd)
            {
                result = nextVal;
                ALT_UTIL::warnIfNotEqualsSF(nextVal, result);
            }
            else
            {
                sc_fix aAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
                sc_fix bAligned(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
                aAligned = a;
                bAligned = b;

                ALT_UTIL::warnIfNotEqualsSF(a, aAligned);
                ALT_UTIL::warnIfNotEqualsSF(b, bAligned);

                result = doSub ? aAligned - bAligned : aAligned + bAligned;
            }
        }
        else
        {
            result = currVal;
            ALT_UTIL::warnIfNotEqualsUF(currVal, result);
        }

        return result;
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_au");

#endif
