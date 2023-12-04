/*******************************************************************
 *
 * Helper types used in fuLib and simLib (e.g. to avoid problems
 * with ambiguous overloads).
 *
 *******************************************************************/

#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_LIB_TYPES_H
#define __ALT_LIB_TYPES_H

namespace ALT_CUSP_SC_DT
{
    // These are needed so we can use the same operator for both
    // sc_int/sc_uint and sc_bigint/sc_biguint
    inline bool operator!=(const sc_uint_base& v, int n) { return v.to_int() != n; }
    inline bool operator!=(const sc_int_base& v, int n) { return v.to_int() != n; }
};

using namespace ALT_CUSP_SC_DT;

// -----------------------------------------------------------------
// ALT_FAST_INT_TYPES (see below) is a helper to select the fastest
// SystemC integer types for a given width.
// Beware!  If sc_int/sc_uint are selected, arithmetic will be
// performed with 64 bit precision.  If more than 64 bit precision
// may be needed, use sc_bigint/sc_biguint directly instead of
// ALT_FAST_INT_TYPES.
// -----------------------------------------------------------------

struct __ALT_COMMON_INT_TYPES
{
    static void error_narrowing_conversion() {
        fprintf(stderr, "Internal conversion from wide to narrow integer; this shouldn't happen.");
    }
};

template<int W>
struct __ALT_NARROW_INT_TYPES : __ALT_COMMON_INT_TYPES
{
    enum { WIDE = 0 };

    typedef sc_int<W> sint;
    typedef sc_uint<W> uint;

    typedef sc_int_base base_sint;
    typedef sc_uint_base base_uint;

    typedef sc_signed opposite_base_sint;
    typedef sc_unsigned opposite_base_uint;

    static const base_sint& to_narrow_sint(const base_sint& n) { return n; }
    static const base_uint& to_narrow_uint(const base_uint& n) { return n; }

    static const base_sint& from_wide_sint(const opposite_base_sint& n) {
        error_narrowing_conversion();
        exit(1);
    }

    static const base_uint& from_wide_uint(const opposite_base_uint& n) {
        error_narrowing_conversion();
        exit(1);
    }

    static const base_sint& to_base_sint(const base_sint& n) { return n; }
    static const base_sint& to_base_sint(const opposite_base_sint& n) { return from_wide_sint(n); }

    static const base_uint& to_base_uint(const base_uint& n) { return n; }
    static const base_uint& to_base_uint(const opposite_base_uint& n) { return from_wide_uint(n); }
};

template<int W>
struct __ALT_WIDE_INT_TYPES : __ALT_COMMON_INT_TYPES
{
    enum { WIDE = 1 };

    typedef sc_bigint<W> sint;
    typedef sc_biguint<W> uint;

    typedef sc_signed base_sint;
    typedef sc_unsigned base_uint;

    typedef sc_int_base opposite_base_sint;
    typedef sc_uint_base opposite_base_uint;

    static const opposite_base_sint& to_narrow_sint(const base_uint& n) {
        error_narrowing_conversion();
        exit(1);
    }

    static const opposite_base_uint& to_narrow_uint(const base_uint& n) {
        error_narrowing_conversion();
        exit(1);
    }

    static const base_sint& from_wide_sint(const base_sint& n) { return n; }
    static const base_uint& from_wide_uint(const base_uint& n) { return n; }

    template<typename T>
    static const base_sint& to_base_sint(const T& n) { return n; }

    template<typename T>
    static const base_uint& to_base_uint(const T& n) { return n; }
};

#ifdef __GNUC__

template<int WIDE, int W>
struct __ALT_FAST_INT_TYPES_SELECTOR
{
};

template<int W>
struct __ALT_FAST_INT_TYPES_SELECTOR<0, W> : public __ALT_NARROW_INT_TYPES<W> { };

template<int W>
struct __ALT_FAST_INT_TYPES_SELECTOR<1, W> : public __ALT_WIDE_INT_TYPES<W> { };

template<int W>
struct ALT_FAST_INT_TYPES : public __ALT_FAST_INT_TYPES_SELECTOR<(W > 64), W>
{
};

#else

// Older versions of MSVC do not support partial template specialisation, so
// use full specialisation and macros
template<int W>
struct ALT_FAST_INT_TYPES : public __ALT_WIDE_INT_TYPES<W> { };
#define alt_cusp_nrw(W) \
template <> struct ALT_FAST_INT_TYPES<W> : public __ALT_NARROW_INT_TYPES<W> { };
#define alt_cusp_nrw4(W) \
alt_cusp_nrw(W) alt_cusp_nrw(W+1) alt_cusp_nrw(W+2) alt_cusp_nrw(W+3)
#define alt_cusp_nrw16(W) \
alt_cusp_nrw4(W) alt_cusp_nrw4(W+4) alt_cusp_nrw4(W+8) alt_cusp_nrw4(W+12)
alt_cusp_nrw16(1) alt_cusp_nrw16(17) alt_cusp_nrw16(33) alt_cusp_nrw16(49) 
#undef alt_cusp_nrw
#undef alt_cusp_nrw4
#undef alt_cusp_nrw16

#endif

template<typename T>
struct __ALT_TYPE_INFO;

struct __ALT_TYPE_KIND
{
    enum { NARROW_INTEGER, WIDE_INTEGER, DECIMAL, BV };
};

#define ALT_TYPE_INFO(T, K, S) \
    struct __ALT_TYPE_INFO< T > { \
        enum { KIND = __ALT_TYPE_KIND::K, IS_SIGNED = S }; \
    };

#define ALT_IS_TYPE_KIND(T, K) ((int)__ALT_TYPE_INFO< T >::KIND == (int)__ALT_TYPE_KIND::K)
#define ALT_IS_TYPE_SIGNED(T) (__ALT_TYPE_INFO< T >::IS_SIGNED)
#define ALT_IS_TYPE_INTEGER(T) (ALT_IS_TYPE_KIND(T, NARROW_INTEGER) || ALT_IS_TYPE_KIND(T, WIDE_INTEGER))

template<> ALT_TYPE_INFO(long, NARROW_INTEGER, true)
template<> ALT_TYPE_INFO(int, NARROW_INTEGER, true)
template<> ALT_TYPE_INFO(short, NARROW_INTEGER, true)
template<> ALT_TYPE_INFO(signed char, NARROW_INTEGER, true)
template<int W> ALT_TYPE_INFO(sc_int<W>, NARROW_INTEGER, true)
template<int W> ALT_TYPE_INFO(sc_bigint<W>, WIDE_INTEGER, true)
template<int W> ALT_TYPE_INFO(ALT_CDFG_SINT<W>, WIDE_INTEGER, true)
template<> ALT_TYPE_INFO(sc_dt::int_type, NARROW_INTEGER, true)
template<> ALT_TYPE_INFO(sc_dt::sc_int_subref, NARROW_INTEGER, true)

template<> ALT_TYPE_INFO(unsigned long, NARROW_INTEGER, false)
template<> ALT_TYPE_INFO(unsigned int, NARROW_INTEGER, false)
template<> ALT_TYPE_INFO(unsigned short, NARROW_INTEGER, false)
template<> ALT_TYPE_INFO(unsigned char, NARROW_INTEGER, false)
template<> ALT_TYPE_INFO(char, NARROW_INTEGER, false)
template<> ALT_TYPE_INFO(bool, NARROW_INTEGER, false)
template<int W> ALT_TYPE_INFO(sc_uint<W>, NARROW_INTEGER, false)
template<int W> ALT_TYPE_INFO(sc_biguint<W>, WIDE_INTEGER, false)
template<int W> ALT_TYPE_INFO(ALT_CDFG_UINT<W>, WIDE_INTEGER, false)
template<> ALT_TYPE_INFO(sc_dt::uint_type, NARROW_INTEGER, false)
template<> ALT_TYPE_INFO(sc_dt::sc_uint_subref, NARROW_INTEGER, false)
template<> ALT_TYPE_INFO(sc_dt::sc_concatref, NARROW_INTEGER, false)

template<> ALT_TYPE_INFO(sc_fix, DECIMAL, true)
template<> ALT_TYPE_INFO(sc_ufix, DECIMAL, false)
template<> ALT_TYPE_INFO(sc_fxval, DECIMAL, true)
template<> ALT_TYPE_INFO(sc_fxnum, DECIMAL, true)

template<int W> ALT_TYPE_INFO(sc_bv<W>, BV, false)
template<int W> ALT_TYPE_INFO(sc_lv<W>, BV, false)

// PARAMS is needed to work around a C++ preprocessor issue
#define PARAMS BW, IW
template<int BW, int IW> ALT_TYPE_INFO(sc_fixed<PARAMS>, DECIMAL, true)
template<int BW, int IW> ALT_TYPE_INFO(sc_ufixed<PARAMS>, DECIMAL, false)
#undef PARAMS

struct __ALT_FUNCTION_VERSION
{
    enum { FAST_SINT, FAST_UINT, NARROW_SINT, NARROW_UINT, WIDE_SINT, WIDE_UINT, SFIX, UFIX, BV };
};

template<bool use_fast_int, bool is_bv, bool is_integer, bool is_wide_integer, bool is_signed>
struct __ALT_FUNCTION_CHOOSER
{
    enum {
        VERSION =
            is_bv ? __ALT_FUNCTION_VERSION::BV :
            is_integer ?
                use_fast_int ? (is_signed ? __ALT_FUNCTION_VERSION::FAST_SINT : __ALT_FUNCTION_VERSION::FAST_UINT) :
                (is_wide_integer ?
                    (is_signed ? __ALT_FUNCTION_VERSION::WIDE_SINT : __ALT_FUNCTION_VERSION::WIDE_UINT) :
                    (is_signed ? __ALT_FUNCTION_VERSION::NARROW_SINT : __ALT_FUNCTION_VERSION::NARROW_UINT)) :
            is_signed ? __ALT_FUNCTION_VERSION::SFIX : __ALT_FUNCTION_VERSION::UFIX
    };
};

template<bool use_fast_int, typename T>
struct __ALT_FUNCTION1_CHOOSER
{
    enum {
        VERSION =
            __ALT_FUNCTION_CHOOSER
                <use_fast_int,
                 ALT_IS_TYPE_KIND(T, BV),
                 ALT_IS_TYPE_INTEGER(T),
                 ALT_IS_TYPE_KIND(T, WIDE_INTEGER),
                 ALT_IS_TYPE_SIGNED(T)>::VERSION
    };
};

template<bool use_fast_int, typename T1, typename T2>
struct __ALT_FUNCTION2_CHOOSER
{
    enum {
        VERSION =
            __ALT_FUNCTION_CHOOSER
                <use_fast_int,
                 ALT_IS_TYPE_KIND(T1, BV) || ALT_IS_TYPE_KIND(T2, BV),
                 ALT_IS_TYPE_INTEGER(T1) && ALT_IS_TYPE_INTEGER(T2),
                 ALT_IS_TYPE_KIND(T1, WIDE_INTEGER) || ALT_IS_TYPE_KIND(T2, WIDE_INTEGER),
                 ALT_IS_TYPE_SIGNED(T1) || ALT_IS_TYPE_SIGNED(T2)>::VERSION
    };
};

template<int W, int V> struct __ALT_TYPE_CHOOSER;

template<int W> struct __ALT_TYPE_CHOOSER<W, __ALT_FUNCTION_VERSION::FAST_SINT> { typedef typename ALT_FAST_INT_TYPES<W>::sint TYPE; };
template<int W> struct __ALT_TYPE_CHOOSER<W, __ALT_FUNCTION_VERSION::FAST_UINT> { typedef typename ALT_FAST_INT_TYPES<W>::uint TYPE; };
template<int W> struct __ALT_TYPE_CHOOSER<W, __ALT_FUNCTION_VERSION::NARROW_SINT> { typedef sc_int<W < SC_INTWIDTH ? W : SC_INTWIDTH> TYPE; };
template<int W> struct __ALT_TYPE_CHOOSER<W, __ALT_FUNCTION_VERSION::NARROW_UINT> { typedef sc_uint<W < SC_INTWIDTH ? W : SC_INTWIDTH> TYPE; };
template<int W> struct __ALT_TYPE_CHOOSER<W, __ALT_FUNCTION_VERSION::WIDE_SINT> { typedef sc_bigint<W> TYPE; };
template<int W> struct __ALT_TYPE_CHOOSER<W, __ALT_FUNCTION_VERSION::WIDE_UINT> { typedef sc_biguint<W> TYPE; };
template<int W> struct __ALT_TYPE_CHOOSER<W, __ALT_FUNCTION_VERSION::SFIX> { typedef sc_fix TYPE; };
template<int W> struct __ALT_TYPE_CHOOSER<W, __ALT_FUNCTION_VERSION::UFIX> { typedef sc_ufix TYPE; };
template<int W> struct __ALT_TYPE_CHOOSER<W, __ALT_FUNCTION_VERSION::BV>   { typedef sc_bv<W> TYPE; };

#endif
