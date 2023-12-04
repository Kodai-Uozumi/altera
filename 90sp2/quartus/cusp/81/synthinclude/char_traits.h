// char_traits.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

// TODO: Implement those parts of this file which are necessary
// TODO: Move classes etc to the correct files...

#ifndef _CHAR_TRAITS_HEADER
#define _CHAR_TRAITS_HEADER

#define _Locale_S      0x00000008      /* Spacing character */
#define _Locale_A      0x00004000      /* Alphabetical characters only */
#define _Locale_B      0x00000040      /* Obsolete: was space char only */
#define _Locale_PR     0x00008000      /* Printable characters only */
#define _Locale_G      0x40000000      /* Graphic characters only */
#define _Locale_BL     0x80000000      /* The blank character class */


#define _Locale_CNTRL  0x00000020      /* Control character */
#define _Locale_UPPER  0x00000001      /* Upper case */
#define _Locale_LOWER  0x00000002      /* Lower case */
#define _Locale_DIGIT  0x00000004      /* Numeral (digit) */
#define _Locale_XDIGIT 0x00000080      /* heXadecimal digit */
#define _Locale_PUNCT  0x00000010      /* Punctuation */
#define _Locale_SPACE  (_Locale_S | _Locale_BL)
#define _Locale_PRINT  (_Locale_PUNCT | _Locale_UPPER | _Locale_LOWER | \
                        _Locale_DIGIT | _Locale_A | _Locale_XDIGIT | \
                       _Locale_PR)
#define _Locale_ALPHA  _Locale_A

typedef char                        char_type;
 
namespace std
{
  template<class _CharT>
    struct char_traits
    {
      static void assign(char_type& __c1, const char_type& __c2);
      static size_t length(const char_type* __c1);
      static int compare(const char_type* __s1, const char_type* __s2, std::size_t __n);
      

    
    };
    
}

#endif
