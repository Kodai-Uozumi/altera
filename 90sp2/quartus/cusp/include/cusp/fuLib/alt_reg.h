/*******************************************************************
 *
 * Register function units.
 *
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *  (2) ALT_REG_FIXED, ALT_REG_UFIXED, and ATL_REG_BV are not
 *      currently supported.
 *
 * Function Unit Models:
 *
 * ALT_REG the following operations for simulation and synthesis :
 * (1)  Synchronous Loading
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 *       (e) Bit vector
 *       (f) Unsigned biginteger
 *       (g) Signed biginteger
 * (2)  Conditional loading
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 *       (a) Bit vector
 *       (f) Unsigned biginteger
 *       (g) Signed biginteger
 * (3)  Synchronous Clearing
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Bit vector
 *
 *******************************************************************/

#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_REG_H
#define __ALT_REG_H
//--------------------------------------------------------------------
// Register function unit and its named static operators
//--------------------------------------------------------------------

template <int WIDTH=16, int LATENCY=1, int RESTART=1>
class ALT_REG : public ALT_CUSP_SYNTH::FU
{
public:

    typedef ALT_FAST_INT_TYPES<WIDTH> fast_int_types;
    typedef typename fast_int_types::sint fast_sint;
    typedef typename fast_int_types::uint fast_uint;

    template<bool is_parameter, typename T>
    struct F1 {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION1_CHOOSER<is_parameter, T>::VERSION>::TYPE TYPE;
    };

    template<bool is_parameter, typename T1, typename T2>
    struct F2 {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION2_CHOOSER<is_parameter, T1, T2>::VERSION>::TYPE TYPE;
    };

    //--------------------------------------------------------------------
    // Unsigned integer conditional loading
    //--------------------------------------------------------------------
    static const fast_uint& cLd
        (const fast_uint& nextVal,
         const fast_uint& currVal,
         bool enable)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return enable ? nextVal : currVal;
    }

    static const fast_uint& cLdUI
        (const fast_uint& nextVal,
         const fast_uint& currVal,
         bool enable)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cLd(nextVal, currVal, enable);
    }

    //--------------------------------------------------------------------
    // Signed integer conditional loading
    //--------------------------------------------------------------------
    static const fast_sint& cLd
        (const fast_sint& nextVal,
         const fast_sint& currVal,
         bool enable)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return enable ? nextVal : currVal;
    }

    static const fast_sint& cLdSI
        (const fast_sint& nextVal,
         const fast_sint& currVal,
         bool enable)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cLd(nextVal, currVal, enable);
    }

    //--------------------------------------------------------------------
    // Unsigned fixed point conditional loading
    //--------------------------------------------------------------------
    static sc_ufix cLd
        (const sc_ufix& nextVal,
         const sc_ufix& currVal,
         bool enable)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cLd(nextVal, currVal, enable, 0);
    }

    static sc_ufix cLdUF
        (const sc_ufix& nextVal,
         const sc_ufix& currVal,
         bool enable)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cLd(nextVal, currVal, enable);
    }

    //--------------------------------------------------------------------
    // Signed fixed point conditional loading
    //--------------------------------------------------------------------
    static sc_fix cLd
        (const sc_fix& nextVal,
         const sc_fix& currVal,
         bool enable)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cLd(nextVal, currVal, enable, 0);
    }

    static sc_fix cLdSF
        (const sc_fix& nextVal,
         const sc_fix& currVal,
         bool enable)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cLd(nextVal, currVal, enable);
    }

    //--------------------------------------------------------------------
    // Bit vector conditional loading
    //--------------------------------------------------------------------
    static const sc_bv<WIDTH>& cLd
        (const sc_bv<WIDTH>& nextVal,
         const sc_bv<WIDTH>& currVal,
         bool enable)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return enable ? nextVal : currVal;
    }

    static const sc_bv<WIDTH>& cLdBV
        (const sc_bv<WIDTH>& nextVal,
         const sc_bv<WIDTH>& currVal,
         bool enable)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return cLd(nextVal, currVal, enable);
    }

    //--------------------------------------------------------------------
    // Single precision conditional loading
    //--------------------------------------------------------------------
    static float cLdSP
        (float nextVal,
         float currVal,
         bool enable)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return enable ? nextVal : currVal;
    }

    //--------------------------------------------------------------------
    // Double precision conditional loading
    //--------------------------------------------------------------------
    static double cLdDP
        (double nextVal,
         double currVal,
         bool enable)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return enable ? nextVal : currVal;
    }

    template<typename TN, typename TC>
    static typename F2<false, TN, TC>::TYPE cLd
        (const TN& nextVal,
         const TC& currVal,
         bool enable)
         ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F2<false, TN, TC>::TYPE(cLd
            (typename F2<true, TN, TC>::TYPE(nextVal),
             typename F2<true, TN, TC>::TYPE(currVal),
             enable));
    }

    //--------------------------------------------------------------------
    // ld() functions (Synchronous load)
    //--------------------------------------------------------------------
    static fast_uint ld
        (const fast_uint& a)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cLd(a, 0u, true);
    }

    static fast_uint ldUI
        (const fast_uint& a)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ld(a);
    }

    static fast_sint ld
        (const fast_sint& a)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cLd(a, 0, true);
    }

    static fast_sint ldSI
        (const fast_sint& a)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ld(a);
    }

    static sc_ufix ld
        (const sc_ufix& a)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cLd(a, 0u, true, 1);
    }

    static sc_ufix ldUF
        (const sc_ufix& a)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ld(a);
    }

    static sc_fix ld
        (const sc_fix& a)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cLd(a, 0, true, 1);
    }

    static sc_fix ldSF
        (const sc_fix& a)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ld(a);
    }

    static sc_bv<WIDTH> ld
        (const sc_bv<WIDTH>& a)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cLd(a, 0, true);
    }

    static sc_bv<WIDTH> ldBV
        (const sc_bv<WIDTH>& a)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return ld(a);
    }

    static float ldSP
        (float a)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cLdSP(a, 0, true);
    }

    static double ldDP
        (double a)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cLdDP(a, 0, true);
    }

    template<typename TA>
    static typename F1<false, TA>::TYPE ld
        (const TA& a)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return typename F1<false, TA>::TYPE(ld(typename F1<true, TA>::TYPE(a)));
    }

    //--------------------------------------------------------------------
    // sClr() functions (Synchronous clear)
    //--------------------------------------------------------------------

    static fast_uint sClr() ALT_GNU_ATTRIBUTE(pure)
    {
        fast_uint zero = 0;
        return cLd(zero, zero, true);
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

    static sc_ufix cLd
        (const sc_ufix& nextVal,
         const sc_ufix& currVal,
         bool enable,
         bool iwlMode)
        ALT_GNU_ATTRIBUTE(pure)
    {
        if (!enable)
            return currVal;

        int intWidthOfOut = (iwlMode ? nextVal : currVal).iwl();
        sc_ufix result(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        result = nextVal;
        ALT_UTIL::warnIfNotEqualsUF(nextVal, result);
        return result;
    }

   //--------------------------------------------------------------------
   // Signed fixed point conditional loading
   //--------------------------------------------------------------------
   static sc_fix cLd
       (const sc_fix& nextVal,
        const sc_fix& currVal,
        bool enable,
        bool iwlMode)
       ALT_GNU_ATTRIBUTE(pure)
   {
        if (!enable)
            return currVal;

        int intWidthOfOut = (iwlMode ? nextVal : currVal).iwl();
        sc_fix result(WIDTH, intWidthOfOut, SC_TRN, SC_WRAP, 0);
        result = nextVal;
        ALT_UTIL::warnIfNotEqualsSF(nextVal, result);
        return result;
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_reg");

#endif
