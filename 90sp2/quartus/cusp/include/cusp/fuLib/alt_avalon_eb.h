/*******************************************************************
 *
 * Avalon Event Block function units.
 *
 * Avalon streaming channels are characterised as as either an input or an
 * output.
 *
 * Abbreviations :
 *  T          = A TYPE (e.g. short, char, sc_int<6>, etc)
 *
 *
 * ALT_AVALON_EB_INPUT
 *   - An event block input port
 *
 *   ->read()
 *      read an event from the channel, blocking if none is available
 *
 *
 * ALT_AVALON_EB_OUTPUT
 *   - An event block output port
 *
 *   ->write(int address, const alt_avalon_eb_event & data)
 *
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *
 *******************************************************************/


#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_AVALON_EB_H
#define __ALT_AVALON_EB_H

#include <set>

//-------------------------------------------------------------------------

struct alt_avalon_eb_event
{
	int address;
	int fake_data;
	// TODO: Add other stuff
	// [if you add pointers then make sure to overload
	// operator = (const alt_avalon_eb_event &) to deal with them].
};

//-------------------------------------------------------------------------

class alt_avalon_eb_output_iface : virtual public sc_interface
{
public:
    virtual ~alt_avalon_eb_output_iface() {}

	// Get the address this interface can deliver to.  A negative return
	// value means this interface can deliver to all addresses.
	virtual int get_address() = 0;

	// Send an event to the corresponding input interface
    virtual void write(const alt_avalon_eb_event &data) = 0;
};

//-------------------------------------------------------------------------

class alt_avalon_eb_input_iface : virtual public sc_interface
{
public:
    virtual ~alt_avalon_eb_input_iface() {}

	// Get the address this interface can deliver to.  A negative return
	// value means this interface can deliver to all addresses.
	virtual int get_address() = 0;

};

//-------------------------------------------------------------------------

class alt_avalon_eb_output_port : public sc_port<alt_avalon_eb_output_iface, 0>, public virtual ALT_CUSP_SYNTH::FU
{
public:
    alt_avalon_eb_output_port() {}
    ~alt_avalon_eb_output_port() {}

	// Overridden because this operator is synthesisable
    void operator () (alt_avalon_eb_output_iface & interface_)
	{
      sc_port<alt_avalon_eb_output_iface, 0>::operator()(interface_);
    }

	// Overridden because this operator is synthesisable
    void operator () ( alt_avalon_eb_output_port & parent_ )
	{
		sc_port<alt_avalon_eb_output_iface, 0>::bind( parent_ );
	}
} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_eb_output_port;bus:avalon_event");

//-------------------------------------------------------------------------

class alt_avalon_eb_input_port : public sc_port<alt_avalon_eb_input_iface, 0>, public virtual ALT_CUSP_SYNTH::FU
{
public:
    alt_avalon_eb_input_port() {}
    ~alt_avalon_eb_input_port() {}

	// Overridden because this operator is synthesisable
    void operator () (alt_avalon_eb_input_iface & interface_)
	{
      sc_port<alt_avalon_eb_input_iface, 0>::operator()(interface_);
    }

	// Overridden because this operator is synthesisable
    void operator () ( alt_avalon_eb_input_port & parent_ )
	{
		sc_port<alt_avalon_eb_input_iface, 0>::bind( parent_ );
	}

private:

    virtual void write(const alt_avalon_eb_event & data)
    {
    	// This function is not used as the channel will end up bound to
    	// the implementation of the port in the child
    }

	friend class alt_avalon_eb_channel;

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_eb_input_port;bus:avalon_event");

//-------------------------------------------------------------------------

class ALT_AVALON_EB_OUTPUT : public alt_avalon_eb_output_port
{
public:
    ALT_AVALON_EB_OUTPUT() {}
    virtual ~ALT_AVALON_EB_OUTPUT() {}

	// Send the event block to the appropriately numbered input interface
    void write(const alt_avalon_eb_event & data)
    {
    	int dest = data.address;

    	int n = alt_avalon_eb_output_port::size();
    	for (int i = 0 ; i < n ; i++)
    	{
    		alt_avalon_eb_output_iface * iface = alt_avalon_eb_output_port::get_interface(i);
    		int ca = iface->get_address();
    		if (ca == dest || ca == -1)
    		{
    			iface->write(data);
    			return;
    		}
    	}
		printf("ALT_AVALON_EB_OUTPUT::write(), oops, data.address=%d, n=%d\n", dest, n);
    }

protected:

	// Check that this port has been correctly bound.  The port may be
	// bound to one channel with address -1, or to multiple channels each
	// with a non-negative address
    virtual void end_of_elaboration()
    {
    	std::set<int, std::less<int> > used, repeated;

    	int n = alt_avalon_eb_output_port::size();
    	for (int i = 0 ; i < n ; i++)
    	{
    		int addr = alt_avalon_eb_output_port::get_interface(i)->get_address();

   			if (used.find(addr) == used.end())
   				used.insert(addr);
   			else
   				repeated.insert(addr);
    	}

    	if (used.find(-1) != used.end() && used.size() != 1)
    	{
    		SC_REPORT_ERROR("/altera/avalon_event", "Event output is connected to channel address -1 and another address");
    	}

    	if (repeated.size() != 0)
    	{
    		SC_REPORT_ERROR("/altera/avalon_event", "Event output is connected to multiple channels with the same address");
    	}

    }

} /*ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_eb_output;bus:avalon_event")*/;

//-------------------------------------------------------------------------

class ALT_AVALON_EB_INPUT : public alt_avalon_eb_input_port
{
private:
	const char * name;
	
	alt_avalon_eb_event * data;
	alt_avalon_eb_event invalid_data;

	alt_avalon_eb_event * queue;
	unsigned int queue_size;
	unsigned int in;
	unsigned int out;
	unsigned int avail;
	bool reader_waiting;
	int writer_waiting;
	sc_event in_event, out_event;

public:
    ALT_AVALON_EB_INPUT(const char * newname = NULL) : name(newname), queue_size(1), data(NULL), queue(NULL) {
    }

    virtual ~ALT_AVALON_EB_INPUT() { delete queue; }

//	// wait for a change in the state of the channel
//	// this does nothing in the hardware, but it allows systemc threads
//	// running in host execution to yield while looping waiting for hasDataAvail
//   void waitForChange(void)
//    {
//		alt_avalon_eb_input_port::channel->waitForChange();
//	}

	// read data from the input, blocking in the channel if necessary
	// return the data read
    alt_avalon_eb_event & read()
    {
    	wait_for_event();
    	return get_data();
    }

    void wait_for_event()
	{
		read_next_event(true);
	}

	bool try_read()
	{
		read_next_event(false);
		return data != NULL;
	}

    bool is_data_valid(void)
    {
        return data != NULL;
    }

    alt_avalon_eb_event & get_data(void)
    {
        return data != NULL ? *data : invalid_data;
    }

	// Set the number of elements in the input queue, this must only
	// be called from the constructor
	void set_queue_size(int new_size)
	{
		queue_size = new_size;
	}

private:

	// Check that this port has been correctly bound.  The port may be
	// bound to multiple channels but all channels must have the same
	// address
    virtual void end_of_elaboration()
    {
    	bool mismatch = false;

    	int addr = alt_avalon_eb_input_port::get_interface(0)->get_address();
    	int n = alt_avalon_eb_input_port::size();
    	for (int i = 1 ; i < n ; i++)
    	{
    		int iaddr = alt_avalon_eb_input_port::get_interface(i)->get_address();

			if (iaddr != addr)
				mismatch = true;
    	}

		if (mismatch)
    	{
    		SC_REPORT_ERROR("/altera/avalon_event", "Event input is connected to channels with different addresses");
    	}

		// Need to allocate an extra element so that the value returned
		// from read() is not overwritten
		queue_size += 2;

		queue = new alt_avalon_eb_event[queue_size];
		in = 0;
		out = 0;
		avail = 0;
		reader_waiting = false;
		writer_waiting = 0;
	}

    virtual void write(const alt_avalon_eb_event & data)
	{
//		printf("ALT_AVALON_EB_INPUT(%s)::write addr=%d\n", name, data.address);

		// consider there to be one extra space in the fifo if
		// there is a reader thread waiting for data right now
		// which will pull the data out as soon as we put it in
		// this allows depth zero fifos to work
		writer_waiting++;
//		while (!has_space_avail())
		while (avail == queue_size-1)
		{
//			printf("ALT_AVALON_EB_INPUT(%p)::write(%s) waiting in=%d out=%d avail=%d\n", sc_core::sc_get_curr_process_handle(), name, in, out, avail);
			sc_core::wait(out_event);
//			printf("ALT_AVALON_EB_INPUT(%p)::write(%s) running in=%d out=%d avail=%d\n", sc_core::sc_get_curr_process_handle(), name, in, out, avail);
		}
		writer_waiting--;

		int next_in = (in + 1) % queue_size;

		queue[in] = data;
		in = next_in;
		avail++;
		notify(in_event);
//		printf("ALT_AVALON_EB_INPUT(%s)::write done\n", name);
	}

	// If an event is available then put the address of the event into
	// 'data', this data will remain valid until the next call to this
	// function.  If no event is available then block if block == true,
	// or set data to NULL and return if block == false.
    void read_next_event(bool block)
	{
//		printf("ALT_AVALON_EB_INPUT(%s)::read_next_event(block=%x), avail=%x, data=%x\n", name, block, avail, data);
		data = NULL;

		if (avail == 0)
		{
			if (!block) {
//				printf("block=%x\n", block);
				return;
			}

			reader_waiting = true;
			while (avail == 0)
			{
//				printf("ALT_AVALON_EB_INPUT(%p)::read(%s) waiting in=%d out=%d avail=%d\n", sc_core::sc_get_curr_process_handle(), name, in, out, avail);
				sc_core::wait(in_event);
//				printf("ALT_AVALON_EB_INPUT(%p)::read(%s) running in=%d out=%d avail=%d\n", sc_core::sc_get_curr_process_handle(), name, in, out, avail);
			}
			reader_waiting = false;
		}

		data = &queue[out];
		out = (out + 1) % queue_size;
		avail--;

		sc_core::notify(out_event);
//		printf("ALT_AVALON_EB_INPUT(%s)::read_next_event done addr=%d\n", name, data->address);
	}

#if 0
	bool hasDataAvail(void)
	{
		return ((avail != 0) || writer_waiting);
	}
#endif

	bool has_space_avail(void)
	{
		return avail != (queue_size - ((reader_waiting) ? 1 : 2));
	}

#if 0
	void waitForChange(void)
	{
		sc_core::wait(in_event | out_event);
	}
#endif

	friend class alt_avalon_eb_channel;

} /*ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_eb_input;bus:avalon_event")*/;

//-------------------------------------------------------------------------

#endif
