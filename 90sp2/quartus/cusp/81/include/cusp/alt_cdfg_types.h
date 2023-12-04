/*******************************************************************
 * 
 * Internal types used to represent the CDFG in C++.
 * 
 *******************************************************************/

#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_CDFG_TYPES_H
#define __ALT_CDFG_TYPES_H

#define ALT_MAX(a, b) ((a) >= (b) ? (a) : (b))

// ------------------------------------------------------------------
// ALT_CDFG_SINT and ALT_CDFG_UINT are helper types to represent the
// internal CDFG SINT and UINT types in the CDFG to C++ dumps. 
// ------------------------------------------------------------------

template<int W>
class ALT_CDFG_SINT;

template<int W>
class ALT_CDFG_UINT : public sc_biguint<W>
{
public:

	ALT_CDFG_UINT() { }
	ALT_CDFG_UINT(const sc_int_base& v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(const sc_uint_base& v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(const sc_signed& v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(const sc_unsigned& v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(const sc_dt::sc_unsigned_subref& v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(const sc_dt::sc_unsigned_subref_r& v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(const char* v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(int64 v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(uint64 v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(long v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(unsigned long v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(int v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(unsigned int v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(double v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(const sc_bv_base& v) : sc_biguint<W>(v) { }
	ALT_CDFG_UINT(const sc_lv_base& v) : sc_biguint<W>(v) { }
	explicit ALT_CDFG_UINT(const sc_fxval& v) : sc_biguint<W>(v) { }
	explicit ALT_CDFG_UINT(const sc_fxval_fast& v) : sc_biguint<W>(v) { }
	explicit ALT_CDFG_UINT(const sc_fxnum& v) : sc_biguint<W>(v) { }
	explicit ALT_CDFG_UINT(const sc_fxnum_fast& v) : sc_biguint<W>(v) { }
	
	ALT_CDFG_UINT(const sc_dt::sc_concatref& v) : sc_biguint<W>(v) { }
	
	operator uint64() const { return sc_biguint<W>::to_uint64(); }

	template<int NW>
	ALT_CDFG_UINT<ALT_MAX(W, NW) + 1> operator+(const ALT_CDFG_UINT<NW>& n) const {
		return ALT_CDFG_UINT<ALT_MAX(W, NW) + 1>((const sc_unsigned&)*this + (const sc_unsigned&)(n));
	}
	
	template<int NW>
	ALT_CDFG_SINT<ALT_MAX(W, NW) + 1> operator+(const ALT_CDFG_SINT<NW>& n) const {
		return ALT_CDFG_SINT<ALT_MAX(W, NW) + 1>((const sc_unsigned&)*this + (const sc_signed&)(n));
	}
	
	template<int NW>
	ALT_CDFG_SINT<ALT_MAX(W, NW) + 1> operator-(const ALT_CDFG_UINT<NW>& n) const {
		return ALT_CDFG_SINT<ALT_MAX(W, NW) + 1>((const sc_unsigned&)*this - (const sc_unsigned&)(n));
	}
	
	template<int NW>
	ALT_CDFG_SINT<ALT_MAX(W, NW) + 1> operator-(const ALT_CDFG_SINT<NW>& n) const {
		return ALT_CDFG_SINT<ALT_MAX(W, NW) + 1>((const sc_unsigned&)*this - (const sc_signed&)(n));
	}
	
	template<int NW>
	ALT_CDFG_UINT<W + NW> operator,(const ALT_CDFG_UINT<NW>& n) const {
		return ALT_CDFG_UINT<W + NW>(concat((const sc_biguint<W>&)*this, n));
	}
};

template<int W>
ALT_CDFG_UINT<ALT_MAX(W, 64) + 1> operator+(const sc_uint_base& n, const ALT_CDFG_UINT<W>& nn) {
	return ALT_CDFG_UINT<64>(n) + nn;
}

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 64) + 1> operator-(const sc_uint_base& n, const ALT_CDFG_UINT<W>& nn) {
	return ALT_CDFG_SINT<64>(n) - nn;
}

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 64) + 1> operator+(const sc_int_base& n, const ALT_CDFG_UINT<W>& nn) {
	return ALT_CDFG_SINT<64>(n) + nn;
}

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 64) + 1> operator-(const sc_int_base& n, const ALT_CDFG_UINT<W>& nn) {
	return ALT_CDFG_SINT<64>(n) - nn;
}

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 32) + 1> operator+(int n, const ALT_CDFG_UINT<W>& nn) {
	return ALT_CDFG_SINT<32>(n) + nn;
}

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 32) + 1> operator-(int n, const ALT_CDFG_UINT<W>& nn) {
	return ALT_CDFG_SINT<32>(n) - nn;
}

template<int W>
class ALT_CDFG_SINT : public sc_bigint<W>
{
public:

	ALT_CDFG_SINT() { }
	ALT_CDFG_SINT(const sc_int_base& v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(const sc_uint_base& v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(const sc_signed& v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(const sc_unsigned& v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(const sc_dt::sc_signed_subref& v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(const sc_dt::sc_signed_subref_r& v) : sc_biguint<W>(v) { }
	ALT_CDFG_SINT(const char* v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(int64 v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(uint64 v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(long v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(unsigned long v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(int v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(unsigned int v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(double v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(const sc_bv_base& v) : sc_bigint<W>(v) { }
	ALT_CDFG_SINT(const sc_lv_base& v) : sc_bigint<W>(v) { }
	explicit ALT_CDFG_SINT(const sc_fxval& v) : sc_bigint<W>(v) { }
	explicit ALT_CDFG_SINT(const sc_fxval_fast& v) : sc_bigint<W>(v) { }
	explicit ALT_CDFG_SINT(const sc_fxnum& v) : sc_bigint<W>(v) { }
	explicit ALT_CDFG_SINT(const sc_fxnum_fast& v) : sc_bigint<W>(v) { }
	
	ALT_CDFG_SINT(const sc_dt::sc_concatref& v) : sc_bigint<W>(v) { }
	
	operator int64() const { return sc_bigint<W>::to_int64(); }

	template<int NW>
	ALT_CDFG_SINT<ALT_MAX(W, NW) + 1> operator+(const ALT_CDFG_UINT<NW>& n) const {
		return ALT_CDFG_SINT<ALT_MAX(W, NW) + 1>((const sc_signed&)*this + (const sc_unsigned&)(n));
	}
	
	template<int NW>
	ALT_CDFG_SINT<ALT_MAX(W, NW) + 1> operator+(const ALT_CDFG_SINT<NW>& n) const {
		return ALT_CDFG_SINT<ALT_MAX(W, NW) + 1>((const sc_signed&)*this + (const sc_signed&)(n));
	}
	
	template<int NW>
	ALT_CDFG_SINT<ALT_MAX(W, NW) + 1> operator-(const ALT_CDFG_UINT<NW>& n) const {
		return ALT_CDFG_SINT<ALT_MAX(W, NW) + 1>((const sc_signed&)*this - (const sc_unsigned&)(n));
	}
	
	template<int NW>
	ALT_CDFG_SINT<ALT_MAX(W, NW) + 1> operator-(const ALT_CDFG_SINT<NW>& n) const {
		return ALT_CDFG_SINT<ALT_MAX(W, NW) + 1>((const sc_signed&)*this - (const sc_signed&)(n));
	}

	template<int NW>
	ALT_CDFG_SINT<W + NW> operator,(const ALT_CDFG_SINT<NW>& n) const {
		return ALT_CDFG_UINT<W + NW>(concat((const sc_bigint<W>&)*this, n));
	}
};

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 64) + 1> operator+(const sc_uint_base& n, const ALT_CDFG_SINT<W>& nn) {
	return ALT_CDFG_SINT<64>(n) + nn;
}

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 64) + 1> operator-(const sc_uint_base& n, const ALT_CDFG_SINT<W>& nn) {
	return ALT_CDFG_SINT<64>(n) - nn;
}

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 64) + 1> operator+(const sc_int_base& n, const ALT_CDFG_SINT<W>& nn) {
	return ALT_CDFG_SINT<64>(n) + nn;
}

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 64) + 1> operator-(const sc_int_base& n, const ALT_CDFG_SINT<W>& nn) {
	return ALT_CDFG_SINT<64>(n) - nn;
}

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 32) + 1> operator+(int n, const ALT_CDFG_SINT<W>& nn) {
	return ALT_CDFG_SINT<32>(n) + nn;
}

template<int W>
ALT_CDFG_SINT<ALT_MAX(W, 32) + 1> operator-(int n, const ALT_CDFG_SINT<W>& nn) {
	return ALT_CDFG_SINT<32>(n) - nn;
}

#endif
