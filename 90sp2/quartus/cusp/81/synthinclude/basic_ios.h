// basic_ios.h
//
// This header file is used when the Altera CusP compiler is compiling
// your source code to hardware.

// TODO: Implement those parts of this file which are necessary
// TODO: Move classes etc to the correct files...
#ifndef _BASIC_IOS_H_HEADER
#define _BASIC_IOS_H_HEADER

namespace std
{

  template<typename _CharT, typename _Traits>
    class basic_ios : public ios_base
    {
    public:
      //@{
      /**
       *  These are standard types.  They permit a standardized way of
       *  referring to names of (or names dependant on) the template
       *  parameters, which are specific to the implementation.
      */
      typedef _CharT                                 char;
      typedef typename _Traits::int_type             int;
      typedef typename _Traits::pos_type             pos_type;
      typedef typename _Traits::off_type             off_type;
      typedef _Traits                                traits_type;
      //@}

      //@{
      /**
       *  @if maint
       *  These are non-standard types.
       *  @endif
      */
      typedef ctype<_CharT>                          __ctype_type;
      typedef num_put<_CharT, ostreambuf_iterator<_CharT, _Traits> >
						     __num_put_type;
      typedef num_get<_CharT, istreambuf_iterator<_CharT, _Traits> >
						     __num_get_type;
      //@}

      // Data members:
    protected:

      // Cached use_facet<ctype>, which is based on the current locale info.
      const __ctype_type*                            _M_ctype;
      // For ostream.
      const __num_put_type*                          _M_num_put;
      // For istream.
      const __num_get_type*                          _M_num_get;

    public:
      //@{
      /**
       *  @brief  The quick-and-easy status check.
       *
       *  This allows you to write constructs such as
       *  "if (!a_stream) ..." and "while (a_stream) ..."
      */
      operator void*() const;

      bool operator!() const; 
      //@}

      /**
       *  @brief  Returns the error state of the stream buffer.
       *  @return  A bit pattern (well, isn't everything?)
       *
       *  See std::ios_base::iostate for the possible bit values.  Most
       *  users will call one of the interpreting wrappers, e.g., good().
      */
      iostate
      rdstate() const;

      /**
       *  @brief  [Re]sets the error state.
       *  @param  state  The new state flag(s) to set.
       *
       *  See std::ios_base::iostate for the possible bit values.  Most
       *  users will not need to pass an argument.
      */
      void
      clear();

      /**
       *  @brief  Sets additional flags in the error state.
       *  @param  state  The additional state flag(s) to set.
       *
       *  See std::ios_base::iostate for the possible bit values.
      */
      void
      setstate(iostate __state);

      // Flip the internal state on for the proper state bits, then re
      // throws the propagated exception if bit also set in
      // exceptions().
      void
      _M_setstate(iostate __state);

      /**
       *  @brief  Fast error checking.
       *  @return  True if no error flags are set.
       *
       *  A wrapper around rdstate.
      */
      bool
      good() const;

      /**
       *  @brief  Fast error checking.
       *  @return  True if the eofbit is set.
       *
       *  Note that other iostate flags may also be set.
      */
      bool
      eof() const;

      /**
       *  @brief  Fast error checking.
       *  @return  True if either the badbit or the failbit is set.
       *
       *  Checking the badbit in fail() is historical practice.
       *  Note that other iostate flags may also be set.
      */
      bool
      fail() const;

      /**
       *  @brief  Fast error checking.
       *  @return  True if the badbit is set.
       *
       *  Note that other iostate flags may also be set.
      */
      bool
      bad() const;

      /**
       *  @brief  Throwing exceptions on errors.
       *  @return  The current exceptions mask.
       *
       *  This changes nothing in the stream.  See the one-argument version
       *  of exceptions(iostate) for the meaning of the return value.
      */
      iostate
      exceptions() const;

      /**
       *  @brief  Throwing exceptions on errors.
       *  @param  except  The new exceptions mask.
       *
       *  By default, error flags are set silently.  You can set an
       *  exceptions mask for each stream; if a bit in the mask becomes set
       *  in the error flags, then an exception of type
       *  std::ios_base::failure is thrown.
       *
       *  If the error flage is already set when the exceptions mask is
       *  added, the exception is immediately thrown.  Try running the
       *  following under GCC 3.1 or later:
       *  @code
       *  #include <iostream>
       *  #include <fstream>
       *  #include <exception>
       *
       *  int main()
       *  {
       *      std::set_terminate (__gnu_cxx::__verbose_terminate_handler);
       *
       *      std::ifstream f ("/etc/motd");
       *
       *      std::cerr << "Setting badbit\n";
       *      f.setstate (std::ios_base::badbit);
       *
       *      std::cerr << "Setting exception mask\n";
       *      f.exceptions (std::ios_base::badbit);
       *  }
       *  @endcode
      */
      void
      exceptions(iostate __except);

      // Constructor/destructor:
      /**
       *  @brief  Constructor performs initialization.
       *
       *  The parameter is passed by derived streams.
      */
      explicit
      basic_ios(basic_streambuf<_CharT, _Traits>* __sb)
      : ios_base();

      /**
       *  @brief  Empty.
       *
       *  The destructor does nothing.  More specifically, it does not
       *  destroy the streambuf held by rdbuf().
      */
      virtual
      ~basic_ios() { }

      // Members:
      /**
       *  @brief  Fetches the current @e tied stream.
       *  @return  A pointer to the tied stream, or NULL if the stream is
       *           not tied.
       *
       *  A stream may be @e tied (or synchronized) to a second output
       *  stream.  When this stream performs any I/O, the tied stream is
       *  first flushed.  For example, @c std::cin is tied to @c std::cout.
      */
      basic_ostream<_CharT, _Traits>*
      tie() const
      { return _M_tie; }

      /**
       *  @brief  Ties this stream to an output stream.
       *  @param  tiestr  The output stream.
       *  @return  The previously tied output stream, or NULL if the stream
       *           was not tied.
       *
       *  This sets up a new tie; see tie() for more.
      */
      basic_ostream<_CharT, _Traits>*
      tie(basic_ostream<_CharT, _Traits>* __tiestr)
      {
        basic_ostream<_CharT, _Traits>* __old = _M_tie;
        _M_tie = __tiestr;
        return __old;
      }

      /**
       *  @brief  Accessing the underlying buffer.
       *  @return  The current stream buffer.
       *
       *  This does not change the state of the stream.
      */
      basic_streambuf<_CharT, _Traits>*
      rdbuf() const
      { return _M_streambuf; }

      /**
       *  @brief  Changing the underlying buffer.
       *  @param  sb  The new stream buffer.
       *  @return  The previous stream buffer.
       *
       *  Associates a new buffer with the current stream, and clears the
       *  error state.
       *
       *  Due to historical accidents which the LWG refuses to correct, the
       *  I/O library suffers from a design error:  this function is hidden
       *  in derived classes by overrides of the zero-argument @c rdbuf(),
       *  which is non-virtual for hysterical raisins.  As a result, you
       *  must use explicit qualifications to access this function via any
       *  derived class.  For example:
       *
       *  @code
       *  std::fstream     foo;         // or some other derived type
       *  std::streambuf*  p = .....;
       *
       *  foo.ios::rdbuf(p);            // ios == basic_ios<char>
       *  @endcode
      */
      basic_streambuf<_CharT, _Traits>*
      rdbuf(basic_streambuf<_CharT, _Traits>* __sb);

      /**
       *  @brief  Copies fields of __rhs into this.
       *  @param  __rhs  The source values for the copies.
       *  @return  Reference to this object.
       *
       *  All fields of __rhs are copied into this object except that rdbuf()
       *  and rdstate() remain unchanged.  All values in the pword and iword
       *  arrays are copied.  Before copying, each callback is invoked with
       *  erase_event.  After copying, each (new) callback is invoked with
       *  copyfmt_event.  The final step is to copy exceptions().
      */
      basic_ios&
      copyfmt(const basic_ios& __rhs);

      /**
       *  @brief  Retreives the "empty" character.
       *  @return  The current fill character.
       *
       *  It defaults to a space (' ') in the current locale.
      */
      char_type
      fill() const
      {
	if (!_M_fill_init)
	  {
	    _M_fill = this->widen(' ');
	    _M_fill_init = true;
	  }
	return _M_fill;
      }

      /**
       *  @brief  Sets a new "empty" character.
       *  @param  ch  The new character.
       *  @return  The previous fill character.
       *
       *  The fill character is used to fill out space when P+ characters
       *  have been requested (e.g., via setw), Q characters are actually
       *  used, and Q<P.  It defaults to a space (' ') in the current locale.
      */
      char_type
      fill(char_type __ch)
      {
	char_type __old = this->fill();
	_M_fill = __ch;
	return __old;
      }

      // Locales:
      /**
       *  @brief  Moves to a new locale.
       *  @param  loc  The new locale.
       *  @return  The previous locale.
       *
       *  Calls @c ios_base::imbue(loc), and if a stream buffer is associated
       *  with this stream, calls that buffer's @c pubimbue(loc).
       *
       *  Additional l10n notes are at
       *  http://gcc.gnu.org/onlinedocs/libstdc++/22_locale/howto.html
      */
      locale
      imbue(const locale& __loc);

      /**
       *  @brief  Squeezes characters.
       *  @param  c  The character to narrow.
       *  @param  dfault  The character to narrow.
       *  @return  The narrowed character.
       *
       *  Maps a character of @c char_type to a character of @c char,
       *  if possible.
       *
       *  Returns the result of
       *  @code
       *    std::use_facet<ctype<char_type> >(getloc()).narrow(c,dfault)
       *  @endcode
       *
       *  Additional l10n notes are at
       *  http://gcc.gnu.org/onlinedocs/libstdc++/22_locale/howto.html
      */
      char
      narrow(char_type __c, char __dfault) const;

      /**
       *  @brief  Widens characters.
       *  @param  c  The character to widen.
       *  @return  The widened character.
       *
       *  Maps a character of @c char to a character of @c char_type.
       *
       *  Returns the result of
       *  @code
       *    std::use_facet<ctype<char_type> >(getloc()).widen(c)
       *  @endcode
       *
       *  Additional l10n notes are at
       *  http://gcc.gnu.org/onlinedocs/libstdc++/22_locale/howto.html
      */
      char_type
      widen(char __c) const;

    protected:
      // 27.4.5.1  basic_ios constructors
      /**
       *  @brief  Empty.
       *
       *  The default constructor does nothing and is not normally
       *  accessible to users.
      */
      basic_ios()
      : ios_base(), _M_tie(0), _M_fill(char_type()), _M_fill_init(false), 
      _M_streambuf(0), _M_ctype(0), _M_num_put(0), _M_num_get(0)
      { }

      /**
       *  @brief  All setup is performed here.
       *
       *  This is called from the public constructor.  It is not virtual and
       *  cannot be redefined.
      */
      void
      init(basic_streambuf<_CharT, _Traits>* __sb);

      void
      _M_cache_locale(const locale& __loc);
    };

}


#endif
