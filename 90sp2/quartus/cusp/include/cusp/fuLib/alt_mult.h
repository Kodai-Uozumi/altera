/*******************************************************************
 *
 * Multiplier function units.
 *
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *  (2) If the width of the multiplier is more than 32 bits then the output
 *      of integer multiplies will be truncated to 64 bits
 *
 * Function Unit Models:
 *
 * ALT_MULT the following operations for simulation and synthesis :
 * (1)  Multiplication
 *       (a) Unsigned integer
 *       (b) Signed integer
 *       (c) Unsigned fixed point
 *       (d) Signed fixed point
 *       (e) Unsigned X Signed integer
 *       (f) Signed X Unsigned integer
 *       (g) Unsigned X Signed fixed point
 *       (h) Signed X Unsigned fixed point
 *
 *******************************************************************/
#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif


#ifndef __ALT_MULT_H
#define __ALT_MULT_H
//--------------------------------------------------------------------
// Multiplier function unit and its named static operators
//--------------------------------------------------------------------

template<typename T1, typename T2>
struct ALT_MULT_PROTOTYPE {
    enum { EXISTS = 0 };
};

template <int WIDTH=16, int LATENCY=3, int RESTART=1>
class ALT_MULT : public ALT_CUSP_SYNTH::FU
{
public:

    typedef sc_int<2 * WIDTH < SC_INTWIDTH ? 2 * WIDTH : SC_INTWIDTH> output_narrow_sint;
    typedef sc_uint<2 * WIDTH < SC_INTWIDTH ? 2 * WIDTH : SC_INTWIDTH> output_narrow_uint;

    typedef ALT_FAST_INT_TYPES<2 * WIDTH> fast_output_types;
    typedef typename fast_output_types::sint fast_output_sint;
    typedef typename fast_output_types::uint fast_output_uint;

    template<typename T>
    struct FP {
        typedef typename __ALT_TYPE_CHOOSER<WIDTH, __ALT_FUNCTION1_CHOOSER<false, T>::VERSION>::TYPE TYPE;
    };

    template<typename T1, typename T2>
    struct FR {
        typedef typename __ALT_TYPE_CHOOSER<2 * WIDTH, __ALT_FUNCTION2_CHOOSER<false, T1, T2>::VERSION>::TYPE TYPE;
    };

    //--------------------------------------------------------------------
    // mult() functions
    //--------------------------------------------------------------------
    static output_narrow_uint mult
        (const sc_uint<WIDTH>& a,
         const sc_uint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cMultUI(sc_biguint<2 * WIDTH>(a), sc_biguint<2 * WIDTH>(b));
    }

    static output_narrow_uint multUI
        (const sc_uint<WIDTH>& a,
         const sc_uint<WIDTH>& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    static sc_biguint<2 * WIDTH> mult
        (const sc_biguint<WIDTH>& a,
         const sc_biguint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return sc_biguint<2 * WIDTH>(cMultUI(a, b));
    }

    static sc_biguint<2 * WIDTH> multUI
        (const sc_biguint<WIDTH>& a,
         const sc_biguint<WIDTH>& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    static output_narrow_sint mult
        (const sc_int<WIDTH>& a,
         const sc_int<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cMultSI(fast_output_sint(a), fast_output_sint(b));
    }

    static output_narrow_sint multSI
        (const sc_int<WIDTH>& a,
         const sc_int<WIDTH>& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    static sc_bigint<2 * WIDTH> mult
        (const sc_bigint<WIDTH>& a,
         const sc_bigint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return sc_bigint<2 * WIDTH>(cMultSI(a, b));
    }

    static sc_bigint<2 * WIDTH> multSI
        (const sc_bigint<WIDTH>& a,
         const sc_bigint<WIDTH>& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    static sc_ufix mult
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cMultUF(a, b);
    }

    static sc_ufix multUF
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    static sc_fix mult
        (const sc_fix& a,
         const sc_fix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cMultSF(a, b);
    }

    static sc_fix multSF
        (const sc_fix& a,
         const sc_fix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    // mixed signed/unsigned modes
    static output_narrow_sint mult
        (const sc_int<WIDTH>& a,
         const sc_uint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cMultSUI(fast_output_sint(a), fast_output_uint(b));
    }

    static output_narrow_sint multSUI
        (const sc_int<WIDTH>& a,
         const sc_uint<WIDTH>& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    static sc_bigint<2 * WIDTH> mult
        (const sc_bigint<WIDTH>& a,
         const sc_biguint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return sc_bigint<2 * WIDTH>(cMultSUI(a, b));
    }

    static sc_bigint<2 * WIDTH> multSUI
        (const sc_bigint<WIDTH>& a,
         const sc_biguint<WIDTH>& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    static output_narrow_sint mult
        (const sc_uint<WIDTH>& a,
         const sc_int<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cMultSUI(fast_output_sint(b), fast_output_uint(a));
    }

    static output_narrow_sint multUSI
        (const sc_uint<WIDTH>& a,
         const sc_int<WIDTH>& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    static sc_bigint<2 * WIDTH> mult
        (const sc_biguint<WIDTH>& a,
         const sc_bigint<WIDTH>& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return sc_bigint<2 * WIDTH>(cMultSUI(b, a));
    }

    static sc_bigint<2 * WIDTH> multUSI
        (const sc_biguint<WIDTH>& a,
         const sc_bigint<WIDTH>& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    static sc_fix mult
        (const sc_fix& a,
         const sc_ufix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cMultSUF(a, b);
    }

    static sc_fix multSUF
        (const sc_fix& a,
         const sc_ufix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    static sc_fix mult
        (const sc_ufix& a,
         const sc_fix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return cMultSUF(b, a);
    }

    static sc_fix multUSF
        (const sc_ufix& a,
         const sc_fix& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        return mult(a, b);
    }

    template<typename TA, typename TB>
    static typename FR<TA, TB>::TYPE mult
        (const TA& a,
         const TB& b)
        ALT_CUSP_SYNTH_MODE(inline)
    {
        typedef typename FP<TA>::TYPE FTA;
        typedef typename FP<TB>::TYPE FTB;
        ALT_CUSP_ASSERT
            ((ALT_MULT_PROTOTYPE<FTA, FTB>::EXISTS),
             "\n"
             "\nERROR:"
             "\n"
             "\nArgument type combination not supported."
             "\nYou might need to cast one or more arguments."
             "\n\n");
        return mult(FTA(a), FTB(b));
    }

private:

    //--------------------------------------------------------------------
    // Unsigned integer conditional multiplication
    //--------------------------------------------------------------------
    static fast_output_uint cMultUI
        (const fast_output_uint& a,
         const fast_output_uint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a * b;
    }

    //--------------------------------------------------------------------
    // Signed integer conditional multiplication
    //--------------------------------------------------------------------
    static fast_output_sint cMultSI
        (const fast_output_sint& a,
         const fast_output_sint& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        return a * b;
    }

    //--------------------------------------------------------------------
    // Signed X Unsigned integer conditional multiplication
    //--------------------------------------------------------------------
    static fast_output_sint cMultSUI
        (const fast_output_sint& a,
         const fast_output_uint& b)
    {
        return a * b;
    }

    //--------------------------------------------------------------------
    // Unsigned fixed conditional multiplication
    // If the word length of either "a" or "b" is greater than the input
    // bit width of the fuction unit "WIDTH", the LSBs will be deleted.
    // If the integer word length is greater than the word length, integer
    // word length will be set to word length.
    // If the integer word length is negative program will terminate.
    //--------------------------------------------------------------------
    static sc_ufix cMultUF
        (const sc_ufix& a,
         const sc_ufix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        sc_ufix aTrn(WIDTH, a.iwl(), SC_TRN, SC_WRAP, 0);
        sc_ufix bTrn(WIDTH, b.iwl(), SC_TRN, SC_WRAP, 0);
        aTrn = a;
        bTrn = b;

        ALT_UTIL::warnIfNotEqualsUF(a, aTrn);
        ALT_UTIL::warnIfNotEqualsUF(b, bTrn);

        sc_ufix result(WIDTH * 2, aTrn.iwl() + bTrn.iwl(), SC_TRN, SC_WRAP, 0);

        result = aTrn * bTrn;
        return result;
    }

    //--------------------------------------------------------------------
    // Signed fixed conditional multiplication
    // If the word length of either "a" or "b" is greater than the input
    // bit width of the fuction unit "WIDTH", the LSBs will be deleted.
    // If the integer word length is greater than the word length, integer
    // word length will be set to word length.
    // If the integer word length is negative program will terminate.
    //--------------------------------------------------------------------
    static sc_fix cMultSF
        (const sc_fix& a,
         const sc_fix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        sc_fix aTrn(WIDTH, a.iwl(), SC_TRN, SC_WRAP, 0);
        sc_fix bTrn(WIDTH, b.iwl(), SC_TRN, SC_WRAP, 0);
        aTrn = a;
        bTrn = b;

        ALT_UTIL::warnIfNotEqualsSF(a, aTrn);
        ALT_UTIL::warnIfNotEqualsSF(b, bTrn);

        sc_fix result(WIDTH * 2, aTrn.iwl() + bTrn.iwl(), SC_TRN, SC_WRAP, 0);

        result = aTrn * bTrn;
        return result;
    }

    //--------------------------------------------------------------------
    // Signed x Unsigned fixed conditional multiplication
    // If the word length of either "a" or "b" is greater than the input
    // bit width of the fuction unit "WIDTH", the LSBs will be deleted.
    // If the integer word length is greater than the word length, integer
    // word length will be set to word length.
    // If the integer word length is negative program will terminate.
    //--------------------------------------------------------------------
    static sc_fix cMultSUF
        (const sc_fix& a,
         const sc_ufix& b)
        ALT_GNU_ATTRIBUTE(pure)
    {
        sc_fix aTrn(WIDTH, a.iwl(), SC_TRN, SC_WRAP, 0);
        sc_ufix bTrn(WIDTH, b.iwl(), SC_TRN, SC_WRAP, 0);
        aTrn = a;
        bTrn = b;

        ALT_UTIL::warnIfNotEqualsSF(a, aTrn);
        ALT_UTIL::warnIfNotEqualsSF(b, bTrn);

        sc_fix result(WIDTH * 2, aTrn.iwl() + bTrn.iwl(), SC_TRN, SC_WRAP, 0);

        result = aTrn * bTrn;
        return result;
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_mult");

#define ALT_MULT_PROTOTYPE_EXISTS(T1, T2) struct ALT_MULT_PROTOTYPE<T1, T2 > { enum { EXISTS = 1 }; }

template<int WIDTH> ALT_MULT_PROTOTYPE_EXISTS(sc_uint<WIDTH>, sc_uint<WIDTH>);
template<int WIDTH> ALT_MULT_PROTOTYPE_EXISTS(sc_biguint<WIDTH>, sc_biguint<WIDTH>);
template<int WIDTH> ALT_MULT_PROTOTYPE_EXISTS(sc_int<WIDTH>, sc_int<WIDTH>);
template<int WIDTH> ALT_MULT_PROTOTYPE_EXISTS(sc_bigint<WIDTH>, sc_bigint<WIDTH>);
template<> ALT_MULT_PROTOTYPE_EXISTS(sc_ufix, sc_ufix);
template<> ALT_MULT_PROTOTYPE_EXISTS(sc_fix, sc_fix);
template<int WIDTH> ALT_MULT_PROTOTYPE_EXISTS(sc_int<WIDTH>, sc_uint<WIDTH>);
template<int WIDTH> ALT_MULT_PROTOTYPE_EXISTS(sc_bigint<WIDTH>, sc_biguint<WIDTH>);
template<int WIDTH> ALT_MULT_PROTOTYPE_EXISTS(sc_uint<WIDTH>, sc_int<WIDTH>);
template<int WIDTH> ALT_MULT_PROTOTYPE_EXISTS(sc_biguint<WIDTH>, sc_bigint<WIDTH>);
template<> ALT_MULT_PROTOTYPE_EXISTS(sc_fix, sc_ufix);
template<> ALT_MULT_PROTOTYPE_EXISTS(sc_ufix, sc_fix);

#endif
