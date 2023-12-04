// c++io.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.
#ifndef _CPPIO_HEADER
#define _CPPIO_HEADER

namespace std 
{
 
  // for basic_file.h
  typedef FILE __c_file;

  struct __ios_flags
  {
    typedef short __int_type;

    static const __int_type _S_boolalpha =	0x0001;
    static const __int_type _S_dec =		0x0002;
    static const __int_type _S_fixed = 		0x0004;
    static const __int_type _S_hex =		0x0008;
    static const __int_type _S_internal = 	0x0010;
    static const __int_type _S_left =   	0x0020;
    static const __int_type _S_oct =		0x0040;
    static const __int_type _S_right =		0x0080;
    static const __int_type _S_scientific =	0x0100;
    static const __int_type _S_showbase =       0x0200;
    static const __int_type _S_showpoint =	0x0400;
    static const __int_type _S_showpos =	0x0800;
    static const __int_type _S_skipws =		0x1000;
    static const __int_type _S_unitbuf =	0x2000;
    static const __int_type _S_uppercase =	0x4000;
    static const __int_type _S_adjustfield =	0x0020 | 0x0080 | 0x0010;
    static const __int_type _S_basefield =	0x0002 | 0x0040 | 0x0008;
    static const __int_type _S_floatfield =	0x0100 | 0x0004;

    // 27.4.2.1.3  Type ios_base::iostate
    static const __int_type _S_badbit =		0x01;
    static const __int_type _S_eofbit =		0x02;
    static const __int_type _S_failbit =       	0x04;

    // 27.4.2.1.4  Type openmode
    static const __int_type _S_app =		0x01;
    static const __int_type _S_ate =		0x02;
    static const __int_type _S_bin =		0x04;
    static const __int_type _S_in =		0x08;
    static const __int_type _S_out =		0x10;
    static const __int_type _S_trunc =		0x20;
  };
}

#endif
