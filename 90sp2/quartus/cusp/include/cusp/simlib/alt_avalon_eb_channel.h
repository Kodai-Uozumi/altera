/*******************************************************************
 *
 * Avalon Event Channel
 *
 * SIMULATION
 *
 * An Avalon Event channel represents a connection between one output and
 * one input.  Events are sent across the channel by the output and are
 * immediately delivered to the input, which may queue them or block
 * depending on its state.
 *
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *
 *******************************************************************/

#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif


#ifndef __ALT_AVALON_EB_CHANNEL_H
#define __ALT_AVALON_EB_CHANNEL_H

// ==============================================================================================================================

class alt_avalon_eb_channel : public sc_prim_channel, alt_avalon_eb_input_iface, alt_avalon_eb_output_iface
{
public:
	static void connect(alt_avalon_eb_output_port & out, alt_avalon_eb_input_port & in, int addr = -1)
	{
		alt_avalon_eb_channel * ch = new alt_avalon_eb_channel(addr);

    	out.bind(*ch);
    	in.bind(*ch);
	}

	static void connect(const char * name, alt_avalon_eb_output_port & out, alt_avalon_eb_input_port & in, int addr = -1)
	{
		alt_avalon_eb_channel * ch = new alt_avalon_eb_channel(name, addr);

    	out.bind(*ch);
    	in.bind(*ch);
	}

private:
	int m_addr;

	alt_avalon_eb_input_port * m_receiver;

	void register_port( sc_port_base & port, const char* ifname)
	{
		if (ifname == typeid(alt_avalon_eb_input_iface).name())
			m_receiver = dynamic_cast<alt_avalon_eb_input_port *>(&port);
	}

public:
	alt_avalon_eb_channel(int addr = -1)
	  : sc_prim_channel(sc_gen_unique_name("avalon_event")), m_addr(addr) {}

	alt_avalon_eb_channel(const char * channelName, int addr = -1)
	  : sc_prim_channel(channelName), m_addr(addr) {}

	virtual int get_address()
	{
		return m_addr;
	}

    virtual void write(const alt_avalon_eb_event & data)
	{
		m_receiver->write(data);
	}

} ALT_CUSP_FUNCTIONAL_UNIT("mode:channel;bus:avalon_event");
#endif //__ALT_AVALON_ST_CHANNEL_H
