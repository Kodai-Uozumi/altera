/*******************************************************************
 *
 * Utility methods.
 *
 *******************************************************************/


#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_UTIL_H
#define __ALT_UTIL_H

template<int W>
class ALT_BV : public sc_bv<W>
{
public:

	ALT_BV() { }
	ALT_BV(const sc_int_base& v) : sc_bv<W>(v) { }
	ALT_BV(const sc_uint_base& v) : sc_bv<W>(v) { }
	ALT_BV(const sc_signed& v) : sc_bv<W>(v) { }
	ALT_BV(const sc_unsigned& v) : sc_bv<W>(v) { }
	//ALT_BV(const char* v) : sc_bv<W>(v) { }
	ALT_BV(int64 v) : sc_bv<W>(v) { }
	//ALT_BV(uint64 v) : sc_bv<W>(v) { }
	//ALT_BV(long v) : sc_bv<W>(v) { }
	//ALT_BV(unsigned long v) : sc_bv<W>(v) { }
	//ALT_BV(int v) : sc_bv<W>(v) { }
	//ALT_BV(unsigned int v) : sc_bv<W>(v) { }
	//ALT_BV(double v) : sc_bv<W>(v) { }
	ALT_BV(const sc_bv_base& v) : sc_bv<W>(v) { }
	ALT_BV(const sc_lv_base& v) : sc_bv<W>(v) { }
	//ALT_BV(const sc_fxval& v) : sc_bv<W>(v) { }
	//ALT_BV(const sc_fxval_fast& v) : sc_bv<W>(v) { }
	ALT_BV(const sc_fxnum& v) : sc_bv<W>((sc_bv_base)v.range()) { }
	//ALT_BV(const sc_fxnum_fast& v) : sc_bv<W>(v) { }

	template<int FW, int FI>
	sc_fixed<FW, FI> to_sfix() { return (sc_fixed<FW, FW>)(sc_bigint<FW>(*this)) >> (FW - FI); }

	template<int FW, int FI>
	sc_ufixed<FW, FI> to_ufix() { return (sc_ufixed<FW, FW>)(sc_bigint<FW>(*this)) >> (FW - FI); }

	operator unsigned int() { return sc_bv<W>::to_uint(); }

	ALT_CDFG_SINT<W> to_sint() { return ALT_CDFG_SINT<W>(*this); }
	ALT_CDFG_UINT<W> to_uint() { return ALT_CDFG_UINT<W>(*this); }
};

namespace ALT_UTIL
{
    static void warnIfNotEqualsSF(const sc_fix &originalVal, const sc_fix &transformedVal)
    {
    	if(originalVal != transformedVal)
    	{
    	    std::cout << "Value " << originalVal << " (" << originalVal.wl()
    	              << "," << originalVal.iwl() << ") truncated and/or wrapped to value "
    	              << transformedVal << " (" << transformedVal.wl() << ","
    	              << transformedVal.iwl() <<")\n";
    	}
    }

	static void warnIfNotEqualsUF(const sc_ufix &originalVal, const sc_ufix &transformedVal)
    {
    	if(originalVal != transformedVal)
    	{
    	    std::cout << "Value " << originalVal << " (" << originalVal.wl()
    	              << "," << originalVal.iwl() << ") truncated and/or wrapped to value "
    	              << transformedVal << " (" << transformedVal.wl() << ","
    	              << transformedVal.iwl() <<")\n";
    	}
    }
    static sc_fix truncateSF(const sc_fix &a, int bitWidth)
    {
       sc_fix result(bitWidth, a.iwl(), SC_TRN, SC_WRAP, 0);
       result = a;
       return result;
    }

    static sc_ufix truncateUF(const sc_ufix &a, int bitWidth)
    {
       sc_ufix result(bitWidth, a.iwl(), SC_TRN, SC_WRAP, 0);
       result = a;
       return result;
    }

	template<unsigned int A>
	struct LOG2CEIL
	{
		enum {value = LOG2CEIL<((A+1)>>1)>::value + 1};
	};

	template<>
	struct LOG2CEIL<1>
	{
		enum {value = 0};
	};

};

#ifdef ALT_CUSP_TRACE_ASSIGN
#include<fstream>
#define ALT_ASSIGN(t, v) alt_assign(#t, t, v)
#else
#define ALT_ASSIGN(t, v) t = v
#endif

#ifdef ALT_CUSP_TRACE_ASSIGN
std::ofstream alt_trace_assign_file;

template<typename Target, typename Value>
Target& alt_assign(const char* name, Target& target, const Value& value) {
    target = value;
    alt_trace_assign_file << name << "=" << target << endl;
    return target;
}
#endif

#endif
