/*******************************************************************
 * 
 * General Purpose IO (GPI/GPO) function units.
 * 
 * GPIO are an unsychronised communication mechanism - literally wires.
 * The wires may or may not be registered.
 * 
 * Abbreviations :
 *  T          = A TYPE (e.g. short, char, sc_int<6>, etc)
 * 
 * 
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 * 
 * 
 * Function Unit Models:
 * 
 * ALT_GPI<T>  
 *    - A general purpose input that has type T.
 *   
 * 
 *  Calls to read() are guaranteed to fall in different 
 *  clock cycles and be scheduled in order of writing.
 *  
 * 
 * 
 * ALT_GPO< T > 
 *    - A general purpose output that has type T.
 *  Calls to write() are guaranteed to fall in different 
 *  clock cycles and be scheduled in order of writing.
 *  
 * 
 *******************************************************************/


#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_GPIO_H
#define __ALT_GPIO_H

/*******************************************************************
 *  Model for general purpose input interface
 ******************************************************************/

template <class T>  class ALT_GPI : public sc_in<T>, public ALT_CUSP_SYNTH::FU
{
	public:
    void waitForChange() {sc_core::wait(this->value_changed_event());}
		const T& read() {return sc_in<T>::read();}
   virtual ~ALT_GPI() {}
   ALT_GPI() {}

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_gpi");


/*******************************************************************
 *  Model for general purpose output interface
 ******************************************************************/

template <class T>  class ALT_GPO : public sc_out<T>, public ALT_CUSP_SYNTH::FU
{
	public:
		void write(const T& val){sc_out<T>::write(val);}
        virtual ~ALT_GPO() {}
        ALT_GPO() {}

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_gpo");

#endif
