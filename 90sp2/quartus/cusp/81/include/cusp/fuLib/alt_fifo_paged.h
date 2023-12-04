#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_FIFO_PAGED_H
#define __ALT_FIFO_PAGED_H
//--------------------------------------------------------------------
// Register function unit and its named static operators
//--------------------------------------------------------------------
 
template <class T, int FIFO_PAGE_SIZE=8, int BUFFERS=8, int SOURCE_ACTIVE_PAGES=1, int SINK_ACTIVE_PAGES=1> 
class ALT_FIFO_PAGED_NO_BIDIR : public ALT_CUSP_SYNTH::FU
{
protected:
    T queue[FIFO_PAGE_SIZE*BUFFERS];
    short qhead, qtail, page_cnt;
    short qhead1, qtail1;
    short qhead2, qtail2;
    short qhead3, qtail3;
    sc_event push_event, pop_event;
    bool sourceValid, sinkValid;
   
   //--------------------------------------------------------------------
   // Read from a page
   //--------------------------------------------------------------------
   virtual T _readPage(unsigned int page, unsigned int addr) {    
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      page = mask(page, ALT_UTIL::LOG2CEIL<BUFFERS>::value);
      return queue[((page*FIFO_PAGE_SIZE)+addr)%(FIFO_PAGE_SIZE*BUFFERS)];      
   }
   //--------------------------------------------------------------------
   // Write to a page
   //--------------------------------------------------------------------
   virtual void _writePage(unsigned int page, unsigned int addr, T data) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      page = mask(page, ALT_UTIL::LOG2CEIL<BUFFERS>::value);
      queue[((page*FIFO_PAGE_SIZE)+addr)%(FIFO_PAGE_SIZE*BUFFERS)] = data;      
   }   
    
public:
   ALT_FIFO_PAGED_NO_BIDIR() {
      qhead = qtail = page_cnt = 0;
      qhead1 = qtail1 = -1;
      qhead2 = qtail2 = -1;
      qhead3 = qtail3 = -1;
      sourceValid = false;
      sinkValid = false;
   }

   //--------------------------------------------------------------------
   // Read from a sink page
   //--------------------------------------------------------------------
   virtual T readSinkPage(unsigned int addr) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      if (!sinkValid)     
         fprintf(stderr,"call to readSinkPage() before a full page was acquired with getFullPage()\n");
      return _readPage(qtail, addr);      
   }
   
   //--------------------------------------------------------------------
   // Write to a source page
   //--------------------------------------------------------------------
   virtual void writeSourcePage(unsigned int addr, T data) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      if (!sourceValid)     
         fprintf(stderr,"call to writeSourcePage() before a full page was acquired with getEmptyPage()\n");
      _writePage(qhead,addr,data);
   }
   
   //--------------------------------------------------------------------
   // Read from a certain sink page
   //--------------------------------------------------------------------
   virtual T readSinkPageNo(unsigned int page, unsigned int addr) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      page = mask(page, ALT_UTIL::LOG2CEIL<BUFFERS>::value);
      if (page>=SINK_ACTIVE_PAGES) 
        fprintf(stderr,"Cannot read from more pages in the FIFO than were specified with SINK_ACTIVE_PAGES\n");
      if (page==3) return _readPage(qtail3, addr);      
      else if (page==2) return _readPage(qtail2, addr);      
      else if (page==1) return _readPage(qtail1, addr);      
      else return _readPage(qtail, addr);      
   }
   
  
   //--------------------------------------------------------------------
   // Write to a certain source page
   //--------------------------------------------------------------------
   virtual void writeSourcePageNo(unsigned int page, unsigned int addr, T data) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      page = mask(page, ALT_UTIL::LOG2CEIL<BUFFERS>::value);
      if (page>=SOURCE_ACTIVE_PAGES) 
        fprintf(stderr,"ACannot write to more pages in the FIFO than were specified with SOURCE_ACTIVE_PAGES\n");    
      else {
          if (page==3) _writePage(qhead3,addr,data);
          if (page==2) _writePage(qhead2,addr,data);
          if (page==1) _writePage(qhead1,addr,data);
          if (page==0) _writePage(qhead,addr,data);
      }
   }   

   //--------------------------------------------------------------------
   // Get an empty page to write to
   //--------------------------------------------------------------------
   virtual void getEmptyPage() {
      
      if (sourceValid) 
         fprintf(stderr,"call to getEmptyPage() before last page was freed with sendPage()\n");
      
      if(page_cnt > BUFFERS-SINK_ACTIVE_PAGES)
         sc_core::wait(pop_event);
               
      sourceValid = true;
   }
   
   //--------------------------------------------------------------------
   // Write a full page onto the queue
   //--------------------------------------------------------------------
   virtual void sendPage() {
            
      if (!sourceValid) 
         fprintf(stderr,"call to sendPage() before a page was aquired with getEmptyPage()\n");

      qhead3 = qhead2;
      qhead2 = qhead1;
      qhead1 = qhead;      
      qhead = (qhead+1) % BUFFERS;
      page_cnt++;
      
      if(page_cnt > BUFFERS)
         fprintf(stderr,"Page count greater than BUFFERS\n");
      push_event.notify();
      sourceValid = false;
	  
   }
   
   
   //--------------------------------------------------------------------
   // Read next full page from the Queue
   //--------------------------------------------------------------------
   virtual void getFullPage() {
      
      if (sinkValid) 
         fprintf(stderr,"call to getFullPage() before last page was freed with releasePage()\n");
    
      while (page_cnt < SOURCE_ACTIVE_PAGES)
         sc_core::wait(push_event);
      
      sinkValid = true;  
	  
   }
   
   //--------------------------------------------------------------------
   // Release last full page from the Queue
   //--------------------------------------------------------------------
   virtual void releasePage() {
      
      if (!sinkValid) 
         fprintf(stderr,"call to releasePage() before a page was aquired with getFullPage()\n");
      
      page_cnt--;
      if(page_cnt < 0)
         fprintf(stderr,"Negative page count\n");
      
      qtail3 = qtail2;
      qtail2 = qtail1;
      qtail1 = qtail;      
      qtail = (qtail+1) % BUFFERS;
      pop_event.notify();
      
      sinkValid = false;
	  
   }   

   //--------------------------------------------------------------------
   // Conditional Write to a source page
   //--------------------------------------------------------------------
   virtual void cWriteSourcePage(unsigned int addr, T data, bool cond) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      if (cond) writeSourcePage(addr, data); 
   }

   //--------------------------------------------------------------------
   // Conditional Get an empty page to write to
   //--------------------------------------------------------------------
   virtual void cGetEmptyPage(bool cond) {
      if (cond) getEmptyPage();
   }
   
   //--------------------------------------------------------------------
   // Conditional Release last full page from the Queue
   //--------------------------------------------------------------------
   virtual void cReleasePage(bool cond) {
      if (cond) releasePage();
   }   

   //--------------------------------------------------------------------
   // Conditional Read next full page from the Queue
   //--------------------------------------------------------------------
   virtual void cGetFullPage(bool cond) {
      if (cond) getFullPage();
   }    
    
   //--------------------------------------------------------------------
   // Conditional Write a full page onto the queue
   //--------------------------------------------------------------------
   virtual void cSendPage(bool cond) {
      if (cond) sendPage();
   }

private:
   inline unsigned int mask(unsigned int value, unsigned int bits)
   {
       	return value & ((1u << bits) - 1);
   }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_fifo_paged_no_bidir");


template <class T, int FIFO_PAGE_SIZE=8, int BUFFERS=8, int SOURCE_ACTIVE_PAGES=1, int SINK_ACTIVE_PAGES=1> 
class ALT_FIFO_PAGED : public ALT_CUSP_SYNTH::FU
{
protected:
    T queue[FIFO_PAGE_SIZE*BUFFERS];
    short qhead, qtail, page_cnt;
    short qhead1, qtail1;
    short qhead2, qtail2;
    short qhead3, qtail3;
    sc_event push_event, pop_event;
    bool sourceValid, sinkValid;
   
   //--------------------------------------------------------------------
   // Read from a page
   //--------------------------------------------------------------------
   virtual T _readPage(unsigned int page, unsigned int addr) {    
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      page = mask(page, ALT_UTIL::LOG2CEIL<BUFFERS>::value);
      return queue[((page*FIFO_PAGE_SIZE)+addr)%(FIFO_PAGE_SIZE*BUFFERS)];      
   }
   //--------------------------------------------------------------------
   // Write to a page
   //--------------------------------------------------------------------
   virtual void _writePage(unsigned int page, unsigned int addr, T data) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      page = mask(page, ALT_UTIL::LOG2CEIL<BUFFERS>::value);
      queue[((page*FIFO_PAGE_SIZE)+addr)%(FIFO_PAGE_SIZE*BUFFERS)] = data;      
   }   
    
public:
   ALT_FIFO_PAGED() {
      qhead = qtail = page_cnt = 0;
      qhead1 = qtail1 = -1;
      qhead2 = qtail2 = -1;
      qhead3 = qtail3 = -1;
      sourceValid = false;
      sinkValid = false;
   }

   //--------------------------------------------------------------------
   // Read from a sink page
   //--------------------------------------------------------------------
   virtual T readSinkPage(unsigned int addr) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      if (!sinkValid)     
         fprintf(stderr,"call to readSinkPage() before a full page was acquired with getFullPage()\n");
      return _readPage(qtail, addr);      
   }
   
   //--------------------------------------------------------------------
   // Write to a source page
   //--------------------------------------------------------------------
   virtual void writeSourcePage(unsigned int addr, T data) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      if (!sourceValid)     
         fprintf(stderr,"call to writeSourcePage() before a full page was acquired with getEmptyPage()\n");
      _writePage(qhead,addr,data);
   }
   
   //--------------------------------------------------------------------
   // Read from a certain sink page
   //--------------------------------------------------------------------
   virtual T readSinkPageNo(unsigned int page, unsigned int addr) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      page = mask(page, ALT_UTIL::LOG2CEIL<BUFFERS>::value);
      if (page>=SINK_ACTIVE_PAGES) 
        fprintf(stderr,"Cannot read from more pages in the FIFO than were specified with SINK_ACTIVE_PAGES\n");
      if (page==3) return _readPage(qtail3, addr);      
      else if (page==2) return _readPage(qtail2, addr);      
      else if (page==1) return _readPage(qtail1, addr);      
      else return _readPage(qtail, addr);      
   }
   
  
   //--------------------------------------------------------------------
   // Write to a certain source page
   //--------------------------------------------------------------------
   virtual void writeSourcePageNo(unsigned int page, unsigned int addr, T data) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      page = mask(page, ALT_UTIL::LOG2CEIL<BUFFERS>::value);
      if (page>=SOURCE_ACTIVE_PAGES) 
        fprintf(stderr,"Cannot write to more pages in the FIFO than were specified with SOURCE_ACTIVE_PAGES\n");    
      else {
          if (page==3) _writePage(qhead3,addr,data);
          if (page==2) _writePage(qhead2,addr,data);
          if (page==1) _writePage(qhead1,addr,data);
          if (page==0) _writePage(qhead,addr,data);
      }
   }   

   //--------------------------------------------------------------------
   // Get an empty page to write to
   //--------------------------------------------------------------------
   virtual void getEmptyPage() {
      
      if (sourceValid) 
         fprintf(stderr,"call to getEmptyPage() before last page was freed with sendPage()\n");
      
      if(page_cnt > BUFFERS-SINK_ACTIVE_PAGES)
         sc_core::wait(pop_event);
               
      sourceValid = true;
   }
   
   //--------------------------------------------------------------------
   // Write a full page onto the queue
   //--------------------------------------------------------------------
   virtual void sendPage() {
            
      if (!sourceValid) 
         fprintf(stderr,"call to sendPage() before a page was aquired with getEmptyPage()\n");

      qhead3 = qhead2;
      qhead2 = qhead1;
      qhead1 = qhead;      
      qhead = (qhead+1) % BUFFERS;
      page_cnt++;
      
      if(page_cnt > BUFFERS)
         fprintf(stderr,"Page count greater than BUFFERS\n");
      push_event.notify();
      sourceValid = false;
      
   }
   
   
   //--------------------------------------------------------------------
   // Read next full page from the Queue
   //--------------------------------------------------------------------
   virtual void getFullPage() {
      
      if (sinkValid) 
         fprintf(stderr,"call to getFullPage() before last page was freed with releasePage()\n");
    
      if(page_cnt < SOURCE_ACTIVE_PAGES)
         sc_core::wait(push_event);
      
      sinkValid = true;  
      
   }
   
   //--------------------------------------------------------------------
   // Release last full page from the Queue
   //--------------------------------------------------------------------
   virtual void releasePage() {
      
      if (!sinkValid) 
         fprintf(stderr,"call to releasePage() before a page was aquired with getFullPage()\n");
      
      page_cnt--;
      if(page_cnt < 0)
         fprintf(stderr,"Negative page count\n");
      
      qtail3 = qtail2;
      qtail2 = qtail1;
      qtail1 = qtail;      
      qtail = (qtail+1) % BUFFERS;
      pop_event.notify();
      
      sinkValid = false;
      
   }   

   //--------------------------------------------------------------------
   // Conditional Write to a source page
   //--------------------------------------------------------------------
   virtual void cWriteSourcePage(unsigned int addr, T data, bool cond) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      if (cond) writeSourcePage(addr, data); 
   }

   //--------------------------------------------------------------------
   // Conditional Get an empty page to write to
   //--------------------------------------------------------------------
   virtual void cGetEmptyPage(bool cond) {
      if (cond) getEmptyPage();
   }
   
   //--------------------------------------------------------------------
   // Conditional Release last full page from the Queue
   //--------------------------------------------------------------------
   virtual void cReleasePage(bool cond) {
      if (cond) releasePage();
   }   

   //--------------------------------------------------------------------
   // Conditional Read next full page from the Queue
   //--------------------------------------------------------------------
   virtual void cGetFullPage(bool cond) {
      if (cond) getFullPage();
   }    
    
   //--------------------------------------------------------------------
   // Conditional Write a full page onto the queue
   //--------------------------------------------------------------------
   virtual void cSendPage(bool cond) {
      if (cond) sendPage();
   }  

   //--------------------------------------------------------------------
   // Read from a source page
   //--------------------------------------------------------------------
   virtual T readSourcePage(unsigned int addr) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      if (!sourceValid)     
         fprintf(stderr,"call to readSourcePage() before a full page was acquired with getEmptyPage()\n");
      return _readPage(qhead,addr);
   }

   //--------------------------------------------------------------------
   // Write to a sink page
   //--------------------------------------------------------------------
   virtual void writeSinkPage(unsigned int addr, T data) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      if (!sinkValid)     
         fprintf(stderr,"call to writeSinkPage() before a full page was acquired with getFullPage()\n");
      _writePage(qtail,addr,data);
   }

   //--------------------------------------------------------------------
   // Read from a certain source page
   //--------------------------------------------------------------------
   virtual T readSourcePageNo(unsigned int page, unsigned int addr) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      page = mask(page, ALT_UTIL::LOG2CEIL<BUFFERS>::value);
      if (page>=SOURCE_ACTIVE_PAGES) 
        fprintf(stderr,"Cannot read from more pages in the FIFO than were specified with SOURCE_ACTIVE_PAGES\n");    
      if (page==3) return _readPage(qhead3, addr);      
      else if (page==2) return _readPage(qhead2, addr);      
      else if (page==1) return _readPage(qhead1, addr);      
      else return _readPage(qhead, addr);      
   }
   
   //--------------------------------------------------------------------
   // Write to a certain sink page
   //--------------------------------------------------------------------
   virtual void writeSinkPageNo(unsigned int page, unsigned int addr, T data) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      page = mask(page, ALT_UTIL::LOG2CEIL<BUFFERS>::value);
      if (page>=SINK_ACTIVE_PAGES) 
        fprintf(stderr,"Cannot write to more pages in the FIFO than were specified with SINK_ACTIVE_PAGES\n");    
      else {
          if (page==3) _writePage(qtail3,addr,data);
          if (page==2) _writePage(qtail2,addr,data);
          if (page==1) _writePage(qtail1,addr,data);
          if (page==0) _writePage(qtail,addr,data);
      }
   }


   //--------------------------------------------------------------------
   // Conditional Write to a sink page
   //--------------------------------------------------------------------
   virtual void cWriteSinkPage(unsigned int addr, T data, bool cond) {
      addr = mask(addr, ALT_UTIL::LOG2CEIL<FIFO_PAGE_SIZE>::value);
      if (cond) writeSinkPage(addr, data);    
   }
   
private:
   inline unsigned int mask(unsigned int value, unsigned int bits)
   {
       return value & ((1u << bits) - 1);
   }


} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_fifo_paged");
   
#endif
