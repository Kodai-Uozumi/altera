/*******************************************************************
 * 
 * Avalon Streaming function units.
 * 
 * Avalon streaming channels are characterised as as either an input or an 
 * output.
 * 
 * Abbreviations :
 *  T          = A TYPE (e.g. short, char, sc_int<6>, etc)
 * 
 * 
 * ALT_AVALON_ST_INPUT<T>  
 *   - An input that handles data of type T.
 * 
 *   ->read() 
 *              read an item of data from the channel
 * 
 * 
 * ALT_AVALON_ST_OUTPUT<T >  
 *   - An output that handles data of type T.
 * 
 *   ->write(T data) 
 *              send one item of data through the channel
 *
 * 
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 * 
 *******************************************************************/


#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_AVALON_ST_H
#define __ALT_AVALON_ST_H

/* 
 * Moving all avalon streaming ports to be not bounded by the type
 * setDataWidth should be used to refine width.
 */
 
#define ALT_AVALON_ST_DEFAULT_TYPE sc_biguint<512>
template <class T = ALT_AVALON_ST_DEFAULT_TYPE > class alt_avalon_st_output_port;
template <class T = ALT_AVALON_ST_DEFAULT_TYPE > class alt_avalon_st_input_port;

namespace alt_avalon_st_sideband
{
  const int ENDPACKET = 1;
};

template <class T = ALT_AVALON_ST_DEFAULT_TYPE > class alt_avalon_st_input_channel : virtual public sc_interface 
{
  public:
    alt_avalon_st_input_channel(){};
    virtual ~alt_avalon_st_input_channel() {};

    virtual void register_port( sc_port_base& new_port, const char* ) 
    {
      alt_avalon_st_input_port<T> *port;
      port = dynamic_cast<alt_avalon_st_input_port<T> *>(&new_port);
      assert(port != 0);
      port->channel = this; 
    }

    virtual T read(unsigned int & sideband) = 0;
    virtual bool hasDataAvail(void) = 0;
    virtual void waitForChange(void) = 0;
};

template <class T > class alt_avalon_st_input_port : public sc_port<alt_avalon_st_input_channel<T> >, public virtual ALT_CUSP_SYNTH::FU 
{
  public:
    alt_avalon_st_input_port(){};
    ~alt_avalon_st_input_port(){};

    void operator () (alt_avalon_st_input_channel<T>& interface_) {
      sc_port<alt_avalon_st_input_channel<T> >::operator()(interface_);
    };
    
    void operator () ( alt_avalon_st_input_port<T> & parent_ )
	{
		sc_port<alt_avalon_st_input_channel<T> >::bind( parent_ ); 
	}
	
  public:
    alt_avalon_st_input_channel<T> * channel; 
} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_st_input_port;bus:avalon_streaming");

template <class T = ALT_AVALON_ST_DEFAULT_TYPE > class ALT_AVALON_ST_INPUT
: public alt_avalon_st_input_port <T>, public virtual ALT_CUSP_SYNTH::FU
{
private:
	bool datavalid;
    unsigned int sideband;
    bool keep;
    int m_width;
    T data;

public:
    ALT_AVALON_ST_INPUT() : sideband(0), datavalid(false), keep(false),m_width(512) {}

    virtual ~ALT_AVALON_ST_INPUT() {}

    // returns true if a subsequent call to read will return before time has advanced
    // (note that the call to read might block, it is just  guaranteed to unblock again
    // before time has advanced)
    bool hasDataAvail(void)
    {
        return keep || alt_avalon_st_input_port<T>::channel->hasDataAvail();
    }

	// wait for a change in the state of the channel
	// this does nothing in the hardware, but it allows systemc threads
	// running in host execution to yield while looping waiting for hasDataAvail
    void waitForChange(void)
    {
		alt_avalon_st_input_port<T>::channel->waitForChange();
	}

	// read data from the input, blocking in the channel if necessary
	// return the data read
    T read() ALT_CUSP_SYNTH_MODE(inline)
    {
    	waitForData(true);
    	return getData();
    }

    // read data from the input, blocking in the channel if necessary
    // if this is an unexpected end of packet then leave the data
    // in the FIFO
    // return the data either way
    T readWithinPacket(bool expectEndPacket) ALT_CUSP_SYNTH_MODE(inline)
	{
    	waitForData(expectEndPacket);
    	return getData();
    }

    // read if there is data available, enter the "data is invalid" state otherwise
    // return true if the read was successful, false if now in a "data is invalid" state
    // this method may block to allow a thread which is blocked in the channel trying to write
    // to finish its write, but if it does it will unblock again before time has advanced, so
    // the caller is guaranteed to get control back before time has advanced
	bool tryRead() ALT_CUSP_SYNTH_MODE(inline) ALT_CUSP_SYNTH_MODE(inline)
	{
		tryGetData(true);
		return isDataValid();
	}

    // read if there is data available, enter the "data is invalid" state otherwise
    // if the data which is read is an unexpected end of packet then leave it in the FIFO
    // return true if the read was successful, false if now in a "data is invalid" state
    // this method may block to allow a thread which is blocked in the channel trying to write
    // to finish its write, but if it does it will unblock again before time has advanced, so
    // the caller is guaranteed to get control back before time has advanced
	bool tryReadWithinPacket(bool expectEndPacket) ALT_CUSP_SYNTH_MODE(inline)
	{
		tryGetData(expectEndPacket);
		return isDataValid();
	}

	// exactly as readWithinPacket() but does not return anything
    void waitForData(bool expectEndPacket)
	{
		// if we are holding data which was read earlier but not consumed because
		// it was an unexpected end of packet then don't read
		if (keep)
			keep = false;
		else
		{
			datavalid = true;
			data = alt_avalon_st_input_port<T>::channel->read(sideband);
		}

		// keep should be high for the next read if end of packet was not expected
		// by this read and the current data (which may be kept data from an even
		// earlier read) is an end of packet
		if (!expectEndPacket && getEndPacket())
		{
			keep = true;
		}
    }

    // exactly as tryReadWithinPacket() but does not return anything
	void tryGetData(bool expectEndPacket)
	{
		if (hasDataAvail())
			waitForData(expectEndPacket);
		else
			datavalid = false;
	}

	// return true if the last read successfully got data
	// if the last read was not a tryRead then this will definitely return true
	// if it was a tryRead then it will return true if the try was successful
	bool isDataValid() ALT_GNU_ATTRIBUTE(pure)
	{
		return datavalid;
	}

	// return the last data that was read
	// if !isDataValid() then the return value is undefined
	T getData() ALT_GNU_ATTRIBUTE(pure)
	{
		return data;
	}

	// return true if the last data that was read is an end of packet
	// if !isDataValid() then the return value is undefined
    bool getEndPacket(void) ALT_GNU_ATTRIBUTE(pure)
    {
        return (sideband & alt_avalon_st_sideband::ENDPACKET) != 0;
    }

	// if cond is true then behave exactly as read, otherwise do nothing
	// and return undefined
    T cRead(bool cond) {
        static T undefined;
        if (cond) return read();
        return undefined;
    }

    // Setup functions - these must only be called from the constructor
    void enableEopSignals() ALT_GNU_ATTRIBUTE(pure) {} // No effect on behavioural code
    void setSymbolsPerBeat(unsigned int spb) {} // No effect on behavioural code
    
    void setDataWidth(unsigned int width) {
    	m_width = width;     
    } 
    
} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_st_input;bus:avalon_streaming");


template <class T> class alt_avalon_st_output_channel : virtual public sc_interface 
{
  public:
    alt_avalon_st_output_channel(){};
    virtual ~alt_avalon_st_output_channel() {};

    virtual void register_port( sc_port_base& new_port, const char* ) 
    {
      alt_avalon_st_output_port<T> *port;
      port = dynamic_cast<alt_avalon_st_output_port<T> *>(&new_port);
      assert(port != 0);
      port->channel = this; 
    }

    virtual void write(const T &data, unsigned int sideband) = 0;
    virtual bool hasSpaceAvail(void) = 0;
    virtual void waitForChange(void) = 0;
};

template <class T > class alt_avalon_st_output_port : public sc_port<alt_avalon_st_output_channel<T> >, public virtual ALT_CUSP_SYNTH::FU 
{
  public:
    alt_avalon_st_output_port(){};
    ~alt_avalon_st_output_port(){};

    void operator () (alt_avalon_st_output_channel<T>& interface_) {
      sc_port<alt_avalon_st_output_channel<T> >::operator()(interface_);
    };

    void operator () ( alt_avalon_st_output_port<T> & parent_ )
	{
		sc_port<alt_avalon_st_output_channel<T> >::bind( parent_ ); 
	}

  public:
    alt_avalon_st_output_channel<T> * channel; 
} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_st_output_port;bus:avalon_streaming");

template <class T = ALT_AVALON_ST_DEFAULT_TYPE >  class ALT_AVALON_ST_OUTPUT 
: public alt_avalon_st_output_port <T>, public virtual ALT_CUSP_SYNTH::FU
{
private:
    unsigned int sideband;

public:
    ALT_AVALON_ST_OUTPUT() : sideband(0) {};

    virtual ~ALT_AVALON_ST_OUTPUT() {};

    bool hasSpaceAvail(void)
    {
        return alt_avalon_st_output_port<T>::channel->hasSpaceAvail();
    }

    void write(const T &data)
    {
        alt_avalon_st_output_port<T>::channel->write(data, sideband);
    }

    void waitForChange(void)
    {
		alt_avalon_st_output_port<T>::channel->waitForChange();
	}

    virtual void cWrite(const T &data, bool cond) {
        if (cond) write(data);
    }

    void setEndPacket(bool endpacket)
    {
        if (endpacket)
            sideband |= alt_avalon_st_sideband::ENDPACKET;
        else
            sideband &= ~alt_avalon_st_sideband::ENDPACKET;
    }

    void writeDataAndEop(const T &data, bool eop)
    {
        setEndPacket(eop);
        write(data);
    }

    // Setup functions - these must only be called from the constructor
    void enableEopSignals() ALT_GNU_ATTRIBUTE(pure) {} // No effect on behavioural code
    void setSymbolsPerBeat(unsigned int spb) {} // No effect on behavioural code
    void setUseReady(bool use_ready) {} // No effect on behavioural code    
    void setDataWidth(unsigned int width) { } // TODO: Fill in and make behavioural code look at this
} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_st_output;bus:avalon_streaming");

#endif
