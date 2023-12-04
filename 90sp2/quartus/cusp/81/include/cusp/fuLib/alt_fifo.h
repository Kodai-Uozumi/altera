#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_FIFO_H
#define __ALT_FIFO_H
//--------------------------------------------------------------------
// Register function unit and its named static operators
//--------------------------------------------------------------------

template <class T, int D=16>
class ALT_FIFO : public ALT_CUSP_SYNTH::FU
{
    T queue[D];
    short qhead,qtail;
    sc_event qempty,qfull;

public:
   ALT_FIFO() {
      qhead = qtail = 0;
   }

   //--------------------------------------------------------------------
   // Read next item from the Queue
   //--------------------------------------------------------------------
   virtual T read() {
       while (qhead == qtail) sc_core::wait(qempty);
       T data = queue[qtail];
       qtail++;
       if (qtail>=D) qtail-=D;
       qfull.notify();
       return data;
   }

   //--------------------------------------------------------------------
   // Read next item from the Queue (conditional)
   //--------------------------------------------------------------------
   virtual T cRead(bool cond) {
	   return cond ? read() : T();
   }

   //--------------------------------------------------------------------
   // Is there data in the FIFO? (read not blocked)
   //--------------------------------------------------------------------
   virtual bool hasDataAvail() {

       // If there is no data in the fifo then wait for a delta in case
       // some is provided by another thread
       if (qhead == qtail)
           sc_core::wait(sc_time(0, SC_US));

       return (qhead != qtail);
   }

   //--------------------------------------------------------------------
   // Write another item onto the queue
   //--------------------------------------------------------------------
   virtual void write(T data) {
       short next_head = qhead+1;
       if (next_head>=D) next_head-=D;

       while (next_head == qtail) sc_core::wait(qfull);

       queue[qhead] = data;
       qhead = next_head;

       qempty.notify();
   }

   //--------------------------------------------------------------------
   // Write another item onto the queue (conditional)
   //--------------------------------------------------------------------
   virtual void cWrite(T data, bool cond) {
	   if (cond)
		   write(data);
   }

   //--------------------------------------------------------------------
   // Is the fifo full (write blocked)
   //--------------------------------------------------------------------
   virtual bool hasSpaceAvail() {
       short next_head = qhead+1;
       if (next_head>=D) next_head-=D;

       // If there is no space in the fifo then wait for a delta in case
       // another thread makes some
       if (next_head == qtail)
           sc_core::wait(sc_time(0, SC_US));

       return (next_head != qtail);
   }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_fifo");

#endif
