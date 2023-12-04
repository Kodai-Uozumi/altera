/*******************************************************************
 * 
 * Avalon Bus Model
 * 
 * SIMULATION
 * 
 * A simple bus functional model capable of simulating single word
 * reads/writes across a bytes addressed bus is provided.
 * 
 * Features:
 *    all addresses are BYTE addresses
 *    an address map is maintained for each master
 *    a default address map is maintained for the bus
 *    transactions are made using sc_int's of undefined width
 *      (i.e. transactions may be of any size between 1 and 63 bits)
 * 
 * The following classes are provided
 *    alt_avalon_bfm
 *      ALT_AVALON_MM_MEM_SLAVE (in alt_avalon_mm.h)
 * 
 * To use the model the bus functional model (bfm) must be instantiated.
 * Masters and slave should be instantiated and added to the bfm.
 * Slaves must be assigned an address using the mapSlave() function.
 * 
 * See the examples directory for an example of use.
 *  
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 * 
 * 
 * 
 *******************************************************************/
 

#ifndef __ALT_CUSP_H
#include "alt_cusp.h"
#endif


#ifndef __ALT_AVALON_BUS_H
#define __ALT_AVALON_BUS_H

class alt_avalon_mm_master_channel;
class alt_avalon_mm_mem_slave_channel;
class alt_avalon_mm_master_channel;

ALT_CUSP_SYNTHESISE(never)
class alt_avalon_bus_matrix : public sc_channel  {
  private:
    friend class alt_avalon_mm_mem_slave_channel;
    friend class alt_avalon_mm_master_channel;
    virtual void addSlave(alt_avalon_mm_mem_slave_channel &slave) = 0;
    virtual void addMaster(alt_avalon_mm_master_channel &master) = 0;

  public:
    virtual void waitForChange(alt_avalon_mm_master_channel& master, unsigned int address) = 0;

        // NB all addresses are BYTE ADDRESSES
        // ------------------------------------
    virtual void mapSlave(alt_avalon_mm_mem_slave_channel &slave, unsigned int firstAddress, unsigned int lastAddress) = 0;
    virtual void mapSlave(alt_avalon_mm_mem_slave_channel &slave, alt_avalon_mm_master_channel &master, unsigned int firstAddress, unsigned int lastAddress, int irqNumber=-1) = 0;
    
    virtual void write(alt_avalon_mm_master_channel &master, unsigned int address, const sc_int_base& data) = 0;
    virtual void write(alt_avalon_mm_master_channel &master, unsigned int address, const sc_signed& data) = 0;
    virtual const sc_int_base read(alt_avalon_mm_master_channel &master, unsigned int address) = 0;
    virtual const sc_signed readWide(alt_avalon_mm_master_channel &master, unsigned int address) = 0;
    
    virtual void setInterrupt(alt_avalon_mm_mem_slave_channel &slave, bool active) = 0;

    alt_avalon_bus_matrix(sc_module_name busName):sc_channel(busName){};
    
    virtual ~alt_avalon_bus_matrix() {};
    
};

class alt_avalon_mm_master : public sc_port<alt_avalon_mm_master_channel> {
  public:
    alt_avalon_mm_master(){};
    virtual ~alt_avalon_mm_master() {};

    virtual void acceptInterrupt(unsigned int irqNumber, bool active) = 0;

    alt_avalon_mm_master_channel * channel; 
};

class alt_avalon_mm_master_channel : virtual public sc_interface {
  public:
    alt_avalon_mm_master_channel(alt_avalon_bus_matrix &bus) : bus(&bus), port(NULL) {
      bus.addMaster(*this);
    }
    virtual ~alt_avalon_mm_master_channel() {};

    virtual void register_port( sc_port_base& new_port, const char* ) {
      port = dynamic_cast<alt_avalon_mm_master *>(&new_port);
      assert(port != 0);
      port->channel = this; 
    }

    virtual void acceptInterrupt(unsigned int irqNumber, bool active) {
    	assert(port);
    	port->acceptInterrupt(irqNumber, active);
    }

	alt_avalon_mm_master *port;
    alt_avalon_bus_matrix* bus;
};

class alt_avalon_mm_mem_slave_port : public sc_port<alt_avalon_mm_mem_slave_channel> {
  public:
    virtual int getAddressWidth() = 0;
    virtual int getDataWidth() = 0;
    
    // NB all addresses are BYTE ADDRESSES
    // ------------------------------------
    virtual const sc_int_base acceptBusRead(unsigned int address) = 0;
    virtual const sc_signed acceptBusReadWide(unsigned int address) = 0;
    virtual void acceptBusWrite(unsigned int address, const sc_int_base &data) = 0;
    virtual void acceptBusWrite(unsigned int address, const sc_signed &data) = 0;
    virtual void notifyEvent() = 0;
    virtual void waitForChange() = 0;
    
  public:
    alt_avalon_mm_mem_slave_channel* channel;
    sc_event _slaveEvent;
    

};

class alt_avalon_mm_mem_slave_channel : virtual public sc_interface {
  public:
    virtual int getAddressWidth() { return port->getAddressWidth(); }
    virtual int getDataWidth() { return port->getDataWidth(); }
    
    // NB all addresses are BYTE ADDRESSES
    // ------------------------------------
    virtual const sc_int_base acceptBusRead(unsigned int address) { return port->acceptBusRead(address); }
    virtual const sc_signed acceptBusReadWide(unsigned int address) { return port->acceptBusReadWide(address); }
    virtual void acceptBusWrite(unsigned int address, const sc_int_base& data) { port->acceptBusWrite(address, data); }
    virtual void acceptBusWrite(unsigned int address, const sc_signed& data) { port->acceptBusWrite(address, data); }
    
    alt_avalon_mm_mem_slave_channel(alt_avalon_bus_matrix &bus) : bus(&bus){
      bus.addSlave(*this);
    }
    virtual ~alt_avalon_mm_mem_slave_channel() {};

    virtual void register_port( sc_port_base& new_port, const char* ) {
      port = dynamic_cast<alt_avalon_mm_mem_slave_port *>(&new_port);
      assert(port != 0);
      port->channel = this;
    }

	virtual void setInterrupt(bool active)
	{
		bus->setInterrupt(*(port->channel), active);	
	}

    virtual void waitForChange(unsigned int address)
    {
        port->waitForChange();
    }

    alt_avalon_bus_matrix* bus;

  private:
    alt_avalon_mm_mem_slave_port* port;
};

// This class is used to capture events on an Avalon slave and pass them in to
// the simulated logic
template <int WIDTH, int LOG2DWIDTH, int LOG2DEPTH>
class alt_avalon_mm_mem_slave_driver : public alt_avalon_mm_mem_slave_port 
{
	typedef ALT_FAST_INT_TYPES<8 << LOG2DWIDTH> fast_int_types;
	typedef typename fast_int_types::sint DATA_TYPE;
	
	enum { QUEUE_DEPTH = 8 };
	unsigned int queue_address[QUEUE_DEPTH];
	bool queue_is_write[QUEUE_DEPTH];
	unsigned int queue_wdata[QUEUE_DEPTH];
	unsigned int queue_in;
	unsigned int queue_out;

	DATA_TYPE readdata;

	sc_event waitrequest;
	sc_event readdatavalid;
		
public:
	alt_avalon_mm_mem_slave_driver()
	: queue_in(0), queue_out(0) {}

	virtual ~alt_avalon_mm_mem_slave_driver() {}
	
	virtual int getAddressWidth() { return LOG2DWIDTH + LOG2DEPTH; }
	virtual int getDataWidth() { return 8 << LOG2DWIDTH; }

    const sc_int_base acceptBusRead(unsigned int address)
    {
        if (fast_int_types::WIDE) {
            fprintf(stderr, "Trying to read narrow integer from wide bus.\n");
            exit(1);
        }
        return fast_int_types::to_narrow_sint(_acceptBusRead(address));
    }

    const sc_signed acceptBusReadWide(unsigned int address)
    {
        return sc_bigint<8 << LOG2DWIDTH>(_acceptBusRead(address));
    }

	const DATA_TYPE _acceptBusRead(unsigned int address) 
    {
		unsigned int queue_next = (queue_in + 1) % QUEUE_DEPTH;
		if (queue_next == queue_out)
		{
			sc_core::wait(waitrequest);
		}

		queue_address[queue_in] = address >> LOG2DWIDTH;
		queue_is_write[queue_in] = false;
		queue_in = queue_next;

		sc_core::wait(readdatavalid);

		return readdata;
    }

    void acceptBusWrite(unsigned int address, const sc_int_base& data)
    {
        _acceptBusWrite(address, (const DATA_TYPE)data);
    }

    void acceptBusWrite(unsigned int address, const sc_signed& data)
    {
        if (!fast_int_types::WIDE) {
            fprintf(stderr, "Trying to write wide integer into wide bus.\n");
            exit(1);
        }
        _acceptBusWrite(address, fast_int_types::from_wide_sint(data));
    }

    void _acceptBusWrite(unsigned int address, const DATA_TYPE& data)
    {
		unsigned int queue_next = (queue_in + 1) % QUEUE_DEPTH;
		if (queue_next == queue_out)
		{
			sc_core::wait(waitrequest);
		}
	
		queue_address[queue_in] = address >> LOG2DWIDTH;
		queue_is_write[queue_in] = true;
		queue_wdata[queue_in] = data;
		queue_in = queue_next;
		notify(_slaveEvent);
    }

	virtual void notifyEvent()
	{
        notify(_slaveEvent);
	}

	virtual void waitForChange()
	{
        sc_core::wait(_slaveEvent);
	}

	bool getTransaction(sc_signal<bool> & av_chipselect, sc_signal<bool> & av_write, sc_signal<sc_uint<LOG2DEPTH> > & av_address, sc_signal<sc_uint<WIDTH> > & av_writedata)
	{
		if (queue_out == queue_in)
		{
			av_chipselect = false;
			return false;
		}
		
		av_chipselect = true;
		av_write = queue_is_write[queue_out];
		av_address = queue_address[queue_out];
		av_writedata = queue_wdata[queue_out];
		queue_out = (queue_out + 1) % QUEUE_DEPTH;
		notify(waitrequest);
		
		return true;
	}
	
	void returnResult(const sc_uint< WIDTH > result)
	{
		readdata = (sc_uint<8 << LOG2DWIDTH>)result;
		notify(readdatavalid);
	}

	virtual void setInterrupt(bool active)
	{
		channel->setInterrupt(active);	
	}
};		

// ===============================================================================
// ===============================================================================
// ===============================================================================
// ===============================================================================

ALT_CUSP_SYNTHESISE(never)
class alt_avalon_bfm : public alt_avalon_bus_matrix {
  
  private:
  
    struct _AddressMapEntry {
      alt_avalon_mm_mem_slave_channel *slave;
      unsigned int firstAddress;
      unsigned int lastAddress;
      int irqNumber;
    };
    
    struct _AddressMap {
      alt_avalon_mm_master_channel *master; // may be null -> default
      sc_pvector<_AddressMapEntry*> entries;
    };
    
    sc_pvector< _AddressMap* > _decodeTable;
  
    alt_avalon_mm_mem_slave_channel *_slave;
    alt_avalon_mm_master_channel *_master;
  
    virtual void addSlave(alt_avalon_mm_mem_slave_channel &slave) 
    {};
    
    virtual void addMaster(alt_avalon_mm_master_channel &master) 
    {
      _AddressMap *masterMap = new _AddressMap();
      masterMap->master = &master;
      _decodeTable.push_back(masterMap);
    };


    void _addMapEntry ( _AddressMap *map, alt_avalon_mm_mem_slave_channel *slave, unsigned int firstAddress, unsigned int lastAddress, int irqNumber=-1)
    {
      _AddressMapEntry *mapEntry = new _AddressMapEntry();
      mapEntry->slave = slave;
      mapEntry->firstAddress = firstAddress;
      mapEntry->lastAddress = lastAddress;
      mapEntry->irqNumber = irqNumber;

      // fixme - check for overlap

      map->entries.push_back(mapEntry);
    };

    _AddressMap *_findAddressMap(alt_avalon_mm_master_channel *master)
    {
        for (int i=0;i<_decodeTable.size();++i) {
          _AddressMap *map = _decodeTable[i];
          if (map->master == master) return map;
        }

        return NULL;
    };

    _AddressMapEntry *_findMapEntry(_AddressMap *map, unsigned int address)
    {
      for (int i=0;i<map->entries.size();i++) {
        _AddressMapEntry *entry = map->entries[i];
        if (entry->firstAddress<=address && entry->lastAddress>=address) return entry;
      }
      return NULL;
    }

    _AddressMapEntry *_findMapEntry(alt_avalon_mm_master_channel *master, unsigned int address)
    {
      _AddressMapEntry *slaveEntry = NULL;

      _AddressMap *masterMap = _findAddressMap(master);
      if (masterMap != NULL) slaveEntry = _findMapEntry(masterMap, address);

      if (slaveEntry == NULL)  {
        _AddressMap *commonMap  = _findAddressMap(NULL);
        slaveEntry = _findMapEntry(commonMap, address);
      }

      if (slaveEntry == NULL) {
        fprintf(stderr, "Master tries to access unmapped address 0x%x\n", address);
        exit(1);
      }

      return slaveEntry;
    }

  public:

    virtual void waitForChange(alt_avalon_mm_master_channel& master, unsigned int address)
    {
        _AddressMapEntry *slaveEntry = _findMapEntry(&master, address);
        slaveEntry->slave->waitForChange(address);
    }; 

// ======================================================   
    virtual void mapSlave(alt_avalon_mm_mem_slave_channel &slave, 
            unsigned int firstAddress, unsigned int lastAddress) 
    {
      if (lastAddress<firstAddress)
          fprintf(stderr, "mapSlave called with last Address lower than first Address!\n");
      
      _AddressMap *commonMap = _findAddressMap(NULL);
      _addMapEntry (commonMap, &slave, firstAddress, lastAddress);
    };
    
    virtual void mapSlave(alt_avalon_mm_mem_slave_channel &slave, alt_avalon_mm_master_channel &master, 
        unsigned int firstAddress, unsigned int lastAddress, int irqNumber=-1)
    {
      if (lastAddress<firstAddress)
          fprintf(stderr, "mapSlave called with last Address lower than first Address!\n");
          
      _AddressMap *masterMap = _findAddressMap(&master);
      _addMapEntry (masterMap, &slave, firstAddress, lastAddress, irqNumber);
    };

// ======================================================   
    virtual void write(alt_avalon_mm_master_channel &master, 
              unsigned int address, const sc_int_base& data) 
    {
      _AddressMapEntry *slaveEntry = _findMapEntry(&master, address);
      unsigned long effectiveAddress = address - slaveEntry->firstAddress;
      slaveEntry->slave->acceptBusWrite(effectiveAddress,data);
    }
    
    virtual void write(alt_avalon_mm_master_channel &master, 
              unsigned int address, const sc_signed& data) 
    {
      _AddressMapEntry *slaveEntry = _findMapEntry(&master, address);
      unsigned long effectiveAddress = address - slaveEntry->firstAddress;
      slaveEntry->slave->acceptBusWrite(effectiveAddress, data);
    }
    
    virtual const sc_int_base read(alt_avalon_mm_master_channel &master, unsigned int address)
    {
		_AddressMapEntry *slaveEntry = _findMapEntry(&master, address);
		unsigned long effectiveAddress = address - slaveEntry->firstAddress;
		return slaveEntry->slave->acceptBusRead(effectiveAddress);
    }

    virtual const sc_signed readWide(alt_avalon_mm_master_channel &master, unsigned int address)
    {
		_AddressMapEntry *slaveEntry = _findMapEntry(&master, address);
		unsigned long effectiveAddress = address - slaveEntry->firstAddress;
		return slaveEntry->slave->acceptBusReadWide(effectiveAddress);
    }

// ======================================================   

	virtual void setInterrupt(alt_avalon_mm_mem_slave_channel &slave, bool active)
	{
        for (int i=0;i<_decodeTable.size();++i) {
        	_AddressMap *map = _decodeTable[i];
	        for (int j=0;j<map->entries.size();++j) {
	        	_AddressMapEntry* thisEntry = map->entries[j];
	        	if(thisEntry->slave == &slave && thisEntry->irqNumber >= 0)
	        	{
	        		map->master->acceptInterrupt(thisEntry->irqNumber, active);
	        	}
	        }
        	
        }		
	}

// ======================================================
    alt_avalon_bfm(sc_module_name busName) 
            : alt_avalon_bus_matrix(busName),  _slave(NULL), _master(NULL)
    {
      _AddressMap *commonMap = new _AddressMap();
      commonMap->master = NULL;
      _decodeTable.push_back ( commonMap ); 
    }

    alt_avalon_bfm() 
        : alt_avalon_bus_matrix(sc_gen_unique_name( "av_bus" )), _slave(NULL), _master(NULL)
    {
      _AddressMap *commonMap = new _AddressMap();
      commonMap->master = NULL;
      _decodeTable.push_back ( commonMap ); 
    }
    
    
    virtual ~alt_avalon_bfm() {};
    
};

#endif // __ALT_AVALON_BUS_H


