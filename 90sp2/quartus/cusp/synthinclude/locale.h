// locale.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

#ifndef _LOCALE_H_HEADER
#define _LOCALE_H_HEADER

#ifdef __cplusplus
extern "C" {
#endif

typedef struct lconv
{
	char *decimal_point; // "."
	char *thousands_sep; // ""
	char *grouping; // ""
	char *mon_decimal_point; // ""
	char *mon_thousands_sep; // ""
	char *mon_grouping; // ""
	char *positive_sign; // ""
	char *negative_sign; // ""
	char *currency_symbol; // ""
	char frac_digits; // CHAR_MAX
	char p_cs_precedes; // CHAR_MAX
	char n_cs_precedes; // CHAR_MAX
	char p_sep_by_space; // CHAR_MAX
	char n_sep_by_space; // CHAR_MAX
	char p_sign_posn; // CHAR_MAX
	char n_sign_posn; // CHAR_MAX
	char *int_curr_symbol; // ""
	char int_frac_digits; // CHAR_MAX
	char int_p_cs_precedes; // CHAR_MAX
	char int_n_cs_precedes; // CHAR_MAX
	char int_p_sep_by_space; // CHAR_MAX
	char int_n_sep_by_space; // CHAR_MAX
	char int_p_sign_posn; // CHAR_MAX
	char int_n_sign_posn; // CHAR_MAX
} lconv;

#ifndef NULL
#ifdef __cplusplus
#define NULL __null
#else
#define NULL 0
#endif
#endif

#define LC_ALL      0
#define LC_COLLATE  1
#define LC_CTYPE    2
#define LC_MONETARY 3
#define LC_NUMERIC  4
#define LC_TIME     5

char *setlocale(int category, const char *locale);
struct lconv *localeconv(void);

#ifdef __cplusplus
}
#endif

#endif
