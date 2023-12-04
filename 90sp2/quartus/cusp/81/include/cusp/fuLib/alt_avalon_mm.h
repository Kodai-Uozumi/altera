/********************************************************************
 *
 * Avalon Bus (Master/Slave) function units.
 *
 * The bus master/slave function units allow a processor to connect to a
 * simple bus such as basic Avalon.
 *
 *
 * Abbreviations :
 *  None.
 *
 *
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *  (2) The Avalon switch fabric is modelled as transfering data of type sc_uint<N>/sc_int<N>
 *      to cast an sc_uint of width N to a sc_fixed of width N with INT_BITS integer bits
 *
 *      i.e. if VALUE is an sc_uint<N>
 *
 *       (sc_fixed<N,INT_BITS>) ( ( (sc_fixed<N,N>) VALUE )  >> (N-INT_BITS) )
 *
 *       #define TOFP(x) (sc_fixed<N,INT_BITS>)(((sc_fixed<N,N>)(x))>>(18-INT_BITS))
 *
 * Function Unit Models:
 *  ALT_AVALON_MM_MEM_SLAVE <DATA_WIDTH, DEPTH>
 *     Description: An avalon slave implemented as a dual-port memory. One side is
 *     accessible to the avalon bus. The other provides a word addressed
 *     memory accessible by the processor.
 *
 *     Operations supported for simulation and synthesis:
 *        (1) Memory Read
 *           (a) Unsigned integer
 *           (b) Signed integer
 *
 *
 *  ALT_AVALON_MM_MASTER<DATA_WIDTH, ADDR_WIDTH>
 *     Operations supported for simulation and synthesis:
 *        (1) Bus Read
 *           (a) Unsigned integer
 *           (b) Signed integer
 *        (2) Bus Write
 *           (a) Unsigned integer
 *           (b) Signed integer
 *        (3) Bus Byte Write
 *           (a) Unsigned integer
 *           (b) Signed integer
 *
 * ALT_AVALON_MM_MASTER_FIFO<DATA_WIDTH, ADDR_WIDTH>
 *     Operations supported for simulation and synthesis:
 *        (1) Bus Read
 *           Description: To perform a bus read call busPostRead(address)
 *           followed by busCollectRead(). Any number of busPostReads can
 *           be issued before calling busCollectRead() provided the read
 *           FIFO depth is not exceeded. busCollectRead() will return data
 *           values in the order the busPostReads were issued.
 *           (a) Unsigned integer
 *           (b) Signed integer
 *        (2) Bus Write
 *           (a) Unsigned integer
 *           (b) Signed integer
 *        (3) Bus Byte Write
 *           (a) Unsigned integer
 *           (b) Signed integer
 *
 * ALT_AVALON_MM_BURSTING_MASTER_FIFO<DATA_WIDTH, ADDR_WIDTH, MAX_BURST>
 *     Operations supported for simulation and synthesis:
 *        (1) All operations of ALT_AVALON_MM_MASTER_FIFO (see above).
 *          (2) Bus Burst Write
 *           (a) Unsigned integer
 *           (b) Signed integer
 *          (3) Bus Burst Read
 *           (a) Unsigned integer
 *           (b) Signed integer
 *
 *******************************************************************/


#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif


#ifndef __ALT_AVALON_MM_H
#define __ALT_AVALON_MM_H

#include <math.h>

// /////////////////////////////////////////////////////////////////
//
// ALT_AVALON_MM_MEM_SLAVE
//
template<int DATA_WIDTH = 2, int DEPTH = 2>
class ALT_AVALON_MM_MEM_SLAVE : public alt_avalon_mm_mem_slave_port, public ALT_CUSP_SYNTH::FU
{
public:

    typedef ALT_FAST_INT_TYPES<DATA_WIDTH> fast_int_types;
    typedef typename fast_int_types::sint DATA_TYPE_S;
    typedef typename fast_int_types::uint DATA_TYPE_U;

    typedef sc_lv<DATA_WIDTH> DATA_TYPE_LV;
    typedef sc_bv<DATA_WIDTH> DATA_TYPE_BV;

    typedef sc_uint<ALT_UTIL::LOG2CEIL<DEPTH>::value> ADDR_TYPE;

private:

    DATA_TYPE_S *_data;

    int _effectiveWidthBits;        // NB the avalon bus works with words of size 2^N bytes
    int _effectiveWidthBytes;        // we have to round up the word size to next boundary
    int _effectiveBytesOfMemory;
    int _effectiveAddrWidth;

    int _wordsOfMemory;
    int _dataWidth;
    int _wordAddrWidth;

    DATA_TYPE_S _invalid;

protected:
    // These methods are inherited from alt_avalon_mm_mem_slave_port and are
    // used to access the bus from the outside.

    virtual int getAddressWidth() { return _effectiveAddrWidth; }
    virtual int getDataWidth() { return _effectiveWidthBits; }

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
        return sc_bigint<DATA_WIDTH>(_acceptBusRead(address));
    }

    const DATA_TYPE_S _acceptBusRead(unsigned int address)
    {
        unsigned int wordAddress = address/_effectiveWidthBytes;
        if (wordAddress * _effectiveWidthBytes != address ) {
            fprintf(stderr,"Misaligned bus read to address 0x%x (align %d)\n", address, _effectiveWidthBytes);
        }
        if (wordAddress>_wordsOfMemory) {
            fprintf(stderr,"Read outside of slave's area (addr=0x%x,size=0x%x)\n",wordAddress,_wordsOfMemory);
            return _invalid;
        } else {
            return _data[wordAddress];
        }
    }

    void acceptBusWrite(unsigned int address, const sc_int_base& data)
    {
        _acceptBusWrite(address, (const DATA_TYPE_S)data);
    }

    void acceptBusWrite(unsigned int address, const sc_signed& data)
    {
        if (!fast_int_types::WIDE) {
            fprintf(stderr, "Trying to write wide integer into wide bus.\n");
            exit(1);
        }
        _acceptBusWrite(address, fast_int_types::from_wide_sint(data));
    }

    void _acceptBusWrite(unsigned int address, const DATA_TYPE_S& data)
    {
        unsigned int wordAddress = address/_effectiveWidthBytes;
        if (wordAddress * _effectiveWidthBytes != address ) {
            fprintf(stderr,"Misaligned bus write to address 0x%x (align %d)\n", address, _effectiveWidthBytes);
        }
        if (wordAddress>=_wordsOfMemory)
            fprintf(stderr,"Write outside of slave's area (addr=0x%x,size=0x%x)\n",wordAddress,_wordsOfMemory);
        else {
            //printf("Bus Write word[%d]=%d\n", (int)wordAddress, (int)data); fflush(stdout);
            _data[wordAddress] = data;
            notifyEvent();
        }
    }

    virtual void notifyEvent()
    {
        notify(_slaveEvent);
    }

public:

    virtual void waitForChange()
    {
        sc_core::wait(_slaveEvent);
    }

    const DATA_TYPE_BV read(ADDR_TYPE wordAddress)
    {
        //printf("CUSP Read %d=word[%d]\n", (int)_data[wordAddress], (int)wordAddress); fflush(stdout);
        return (DATA_TYPE_BV)_data[wordAddress].range(DATA_WIDTH - 1, 0);
    }

    template<typename T>
    const T read(ADDR_TYPE wordAddress)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return (T)read(wordAddress);
    }

    const DATA_TYPE_S readSI(ADDR_TYPE wordAddress)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return read<DATA_TYPE_S>(wordAddress);
    }

    const DATA_TYPE_U readUI(ADDR_TYPE wordAddress)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return read<DATA_TYPE_U>(wordAddress);
    }

    const DATA_TYPE_LV readLV(ADDR_TYPE wordAddress)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return read<DATA_TYPE_LV>(wordAddress);
    }

    const DATA_TYPE_BV readBV(ADDR_TYPE wordAddress)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return read<DATA_TYPE_BV>(wordAddress);
    }

    void write(ADDR_TYPE wordAddress, const DATA_TYPE_S& data)
    {
        //printf("CUSP Write word[%d]=%d\n", (int)wordAddress, (int)data); fflush(stdout);
        _data[wordAddress] = data;
        notifyEvent();
    }

    template<typename T>
    void write(ADDR_TYPE wordAddress, const T& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        write(wordAddress, (const DATA_TYPE_S)data);
    }

    void writeSI(ADDR_TYPE wordAddress, const DATA_TYPE_S& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        write(wordAddress, data);
    }

    void writeSI(ADDR_TYPE wordAddress, const sc_int_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        write(wordAddress, (const DATA_TYPE_S)data);
    }

    void writeUI(ADDR_TYPE wordAddress, const DATA_TYPE_U& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        write(wordAddress, (const DATA_TYPE_S)data);
    }

    void writeUI(ADDR_TYPE wordAddress, const sc_uint_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        write(wordAddress, (const DATA_TYPE_S)data);
    }

    void writeBV(ADDR_TYPE wordAddress, const DATA_TYPE_BV& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        write(wordAddress, (const DATA_TYPE_S)data);
    }

    void writeLV(ADDR_TYPE wordAddress, const DATA_TYPE_LV& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        write(wordAddress, (const DATA_TYPE_S)data);
    }

    ALT_AVALON_MM_MEM_SLAVE()
    {
        _invalid = -1;
        _wordsOfMemory  = DEPTH;
        _dataWidth = DATA_WIDTH;

        // work out our word size as a 2^N value
        _effectiveWidthBits = 8;
        _effectiveAddrWidth = 0;
        while (_effectiveWidthBits < DATA_WIDTH) {
            _effectiveAddrWidth += 1;
            _effectiveWidthBits *= 2;
        }
        _effectiveWidthBytes = _effectiveWidthBits / 8;

        int wordAddressSize = 1;
        int wordsAddressed = 2;
        while (wordsAddressed < DEPTH) {
            wordAddressSize += 1;
            wordsAddressed *= 2;
        }
        _effectiveAddrWidth += wordAddressSize;

        _data = new DATA_TYPE_S[_wordsOfMemory];
    }

    void setInterrupt(bool active) {
    	channel->setInterrupt(active);
    }

    virtual ~ALT_AVALON_MM_MEM_SLAVE()  {}

    // Setup functions - these must only be called from the constructor

    // This function requests that the memory for the interface should be built
    // using LEs instead of memories.
    void setImplementInLEs(bool les) {}

    // This function selects whether the generated interface should be clocked
    // from a separate clock (true) or whether it should be clocked from the
    // same clock as the rest of the logic.
    void setUseOwnClock(bool ownclock) {}

    // This function provides the equivalent of setting the DATA_WIDTH template
    // parameter.
    void setDataWidth(int n) {}

    // This function provides the equivalent of setting the DEPTH template
    // parameter.
    void setDepth(int n) {}

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_mm_mem_slave;bus:avalon,interrupt");

// /////////////////////////////////////////////////////////////////
//
// ALT_AVALON_MM_RAW_SLAVE
//
template<int DATA_WIDTH = 2, int DEPTH = 2>
class ALT_AVALON_MM_RAW_SLAVE : public alt_avalon_mm_mem_slave_port, public ALT_CUSP_SYNTH::FU
{
public:

    typedef ALT_FAST_INT_TYPES<DATA_WIDTH> fast_int_types;
    typedef typename fast_int_types::sint DATA_TYPE_S;
    typedef typename fast_int_types::uint DATA_TYPE_U;

    typedef sc_uint<ALT_UTIL::LOG2CEIL<DEPTH>::value> ADDR_TYPE;

private:

    int _effectiveWidthBits;        // NB the avalon bus works with words of size 2^N bytes
    int _effectiveWidthBytes;        // we have to round up the word size to next boundary
    int _effectiveBytesOfMemory;
    int _effectiveAddrWidth;

    /*
     *  We stay in sync with a simple state machine which does the following:
     *
     *  IDLE (notify available) -> READ  (notify finished) -> DONE -> IDLE
     *
     *  IDLE (notify available) -> WRITE (notify finished) -> IDLE
     */
    enum STATE { IDLE, WRITE = 1, READ = 2, DONE = 3 };
    STATE _state;

    ADDR_TYPE   queued_address;
    DATA_TYPE_S queued_data;

    sc_event request_available; //geneated when the transaction is generated.
    sc_event request_finished; //geneated when the transaction is finished completely.
    sc_event read_completed; //generated when slave side completes READ transaction.

    DATA_TYPE_S _invalid;

protected:
    // These methods are inherited from alt_avalon_mm_mem_slave_port and are
    // used to access the bus from the outside.

    virtual int getAddressWidth() { return _effectiveAddrWidth; }
    virtual int getDataWidth() { return _effectiveWidthBits; }

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
        return sc_bigint<DATA_WIDTH>(_acceptBusRead(address));
    }

    const DATA_TYPE_S _acceptBusRead(unsigned int address)
    {
        unsigned int wordAddress = address/_effectiveWidthBytes;
        if (wordAddress * _effectiveWidthBytes != address ) {
            fprintf(stderr,"Misaligned bus read to address 0x%x (align %d)\n", address, _effectiveWidthBytes);
        }
        if (wordAddress>DEPTH) {
            fprintf(stderr,"Read outside of slave's area (addr=0x%x,size=0x%x)\n",wordAddress,DEPTH);
            return _invalid;
        } else {
            while (_state != IDLE)
            /*sc_core::*/wait(request_finished);

            queued_address = wordAddress;
            //queued_is_read = true;
            _state         = READ;

            notify(request_available);

            while (_state != DONE) {
                /*sc_core::*/wait(read_completed);

            }
            _state        = IDLE;
            notify(request_finished);
            return queued_data;
        }
    }

    void acceptBusWrite(unsigned int address, const sc_int_base& data)
    {
        _acceptBusWrite(address, (const DATA_TYPE_S)data);
    }

    void acceptBusWrite(unsigned int address, const sc_signed& data)
    {
        if (!fast_int_types::WIDE) {
            fprintf(stderr, "Trying to write wide integer into wide bus.\n");
            exit(1);
        }
        _acceptBusWrite(address, fast_int_types::from_wide_sint(data));
    }

    void _acceptBusWrite(unsigned int address, const DATA_TYPE_S& data)
    {
        unsigned int wordAddress = address/_effectiveWidthBytes;
        if (wordAddress * _effectiveWidthBytes != address) {
            fprintf(stderr,"Misaligned bus write to address 0x%x (align %d)\n", address, _effectiveWidthBytes);
        }
        if (wordAddress>=DEPTH)
            fprintf(stderr,"Write outside of slave's area (addr=0x%x,size=0x%x)\n",wordAddress,DEPTH);
        else {
            while (_state != IDLE)
            /*sc_core::*/wait(request_finished);

            queued_address = wordAddress;
            //queued_is_read = false;
            queued_data    = data;
            _state         = WRITE;

            notify(request_available);
        }
    }

    void wait_for_request(void)
    {
        while (_state == DONE)
            wait(request_finished);
        while (_state == IDLE)
            wait(request_available);
    }

    virtual void waitForChange()
    {
        sc_core::wait(_slaveEvent);
    }

public:

    virtual void notifyEvent()
    {
        notify(_slaveEvent);
    }

    // This function gets the type of the current access.
    // It will stall if there is no access in progress
    // Returns true for a read, false for a write
    bool isReadAccess()
    {
        wait_for_request();
        return (_state == READ);
    }

    // This function gets the address of the current access.
    // It will stall if there is no access in progress
    ADDR_TYPE getAddress()
    {
        wait_for_request();
        return queued_address;
    }

    // This function gets the write data and marks the write as finished
    // so the port can move on to the next access.
    // It will stall if there is no access in progress
    DATA_TYPE_S getWriteData()
    {
        wait_for_request();
        if (_state != WRITE)
        {
            fprintf(stderr,"ALT_AVALON_MM_RAW_SLAVE: Asking for write data when access is not a write, current state: %d\n",_state);
            return _invalid;
        }

        DATA_TYPE_S data = queued_data;
        _state = IDLE;
        notify(request_finished);
        return data;
    }

    // This function returns the read data to the appropriate master and
    // marks the read as finished so the port can present the next access
     void returnReadData(DATA_TYPE_S data)
    {
            wait_for_request();
        if (_state != READ)
        {
            fprintf(stderr, "Read data lost because no read was waiting\n");
            return;
        }

        queued_data = data;
        _state = DONE;
        notify(read_completed);
    }

    ALT_AVALON_MM_RAW_SLAVE()
    {
        _invalid = -1;

        // work out our word size as a 2^N value
        _effectiveWidthBits = 8;
        _effectiveAddrWidth = 0;
        while (_effectiveWidthBits < DATA_WIDTH) {
            _effectiveAddrWidth += 1;
            _effectiveWidthBits *= 2;
        }
        _effectiveWidthBytes = _effectiveWidthBits / 8;

        int wordAddressSize = 1;
        int wordsAddressed = 2;
        while (wordsAddressed < DEPTH) {
            wordAddressSize += 1;
            wordsAddressed *= 2;
        }
        _effectiveAddrWidth += wordAddressSize;

        _state = IDLE;
    }

    void setInterrupt(bool active)
    {
    	channel->setInterrupt(active);
    }

    virtual ~ALT_AVALON_MM_RAW_SLAVE()  {}

    // Setup functions - these must only be called from the constructor

    // This function selects whether the generated interface should be clocked
    // from a separate clock (true) or whether it should be clocked from the
    // same clock as the rest of the logic.
    void setUseOwnClock(bool ownclock) {}

    // This function provides the equivalent of setting the DATA_WIDTH template
    // parameter.
    void setDataWidth(int n) {}

    // This function provides the equivalent of setting the DEPTH template
    // parameter.
    void setDepth(int n) {}

    // This function requests that the read ports be enabled.
    void enableReadPorts() ALT_GNU_ATTRIBUTE(pure) {}

    // This function requests that the write ports be enabled.
    void enableWritePorts() ALT_GNU_ATTRIBUTE(pure) {}

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_mm_raw_slave;bus:avalon,interrupt");

// /////////////////////////////////////////////////////////////////
//
// ALT_AVALON_MM_MASTER
//
template<int DATA_WIDTH = 32, int ADDR_WIDTH = 16>
class ALT_AVALON_MM_MASTER : public alt_avalon_mm_master, public ALT_CUSP_SYNTH::FU
{
    int _effectiveWidthBits;
    typedef ALT_FAST_INT_TYPES<DATA_WIDTH> fast_int_types;

private:
	// The values of any received interrupts
	sc_uint<32> interruptFlags;
	// The number of active bits used by the irq port
	unsigned int interruptWidth;

protected:

    virtual int getAddressWidth() { return ADDR_WIDTH; };
    virtual int getDataWidth() { return _effectiveWidthBits; }

    // Accept that an interrupt has been set
    void acceptInterrupt(unsigned int irqNumber, bool active) {
        assert(irqNumber < interruptWidth);
        interruptFlags.bit(irqNumber) = active;
    }

public:

    typedef typename fast_int_types::sint DATA_TYPE_S;
    typedef typename fast_int_types::uint DATA_TYPE_U;

    typedef sc_bv<DATA_WIDTH> DATA_TYPE_BV;

    typedef sc_uint<ADDR_WIDTH> ADDR_TYPE;

    const DATA_TYPE_BV busRead(ADDR_TYPE address)
    {
        if (fast_int_types::WIDE)
            return (DATA_TYPE_BV)fast_int_types::from_wide_sint(channel->bus->readWide(*channel, address));
        else
            return (DATA_TYPE_BV)channel->bus->read(*channel, address);
    }

    template<typename T>
    const T busRead(ADDR_TYPE address)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return (T)busRead(address);
    }

    const DATA_TYPE_S busReadSI(ADDR_TYPE address)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return busRead<DATA_TYPE_S>(address);
    }

    const DATA_TYPE_U busReadUI(ADDR_TYPE address)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return busRead<DATA_TYPE_U>(address);
    }

    void busWrite(unsigned int address, const DATA_TYPE_BV& data)
    {
        channel->bus->write(*channel, address, (const DATA_TYPE_S)data);
    }

    template<typename T>
    void busWrite(unsigned int address, const T& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWrite(address, (const DATA_TYPE_BV)data);
    }

    void busWriteSI(unsigned int address, const DATA_TYPE_S& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWrite(address, (const DATA_TYPE_BV)data);
    }

    void busWriteSI(unsigned int address, const sc_int_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWrite(address, (const DATA_TYPE_BV)data);
    }

    void busWriteUI(unsigned int address, const DATA_TYPE_U& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWrite(address, (const DATA_TYPE_BV)data);
    }

    void busWriteUI(unsigned int address, const sc_uint_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWrite(address, (const DATA_TYPE_BV)data);
    }

    void busByteWrite(unsigned int address, sc_uint<(DATA_WIDTH+7)/8> byteEnable, const DATA_TYPE_BV& data)
    {
        DATA_TYPE_BV rdata = busRead(address);
        for (int n = 0; n < byteEnable.length(); n++)
        {
            int start = n * 8;
            int end = start + 7;
            if (byteEnable.bit(n))
                rdata.range(end, start) = data.range(end, start);
        }
        busWrite(address, rdata);
    }

    template<typename T>
    void busByteWrite(unsigned int address, sc_uint<(DATA_WIDTH+7)/8> byteEnable, const T& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busByteWrite(address, byteEnable, (const DATA_TYPE_BV)data);
    }

    void busByteWriteSI(unsigned int address, sc_uint<(DATA_WIDTH+7)/8> byteEnable, const DATA_TYPE_S& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busByteWrite(address, byteEnable, (const DATA_TYPE_BV)data);
    }

    void busByteWriteSI(unsigned int address, sc_uint<(DATA_WIDTH+7)/8> byteEnable, const sc_int_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busByteWrite(address, byteEnable, (const DATA_TYPE_BV)data);
    }

    void busByteWriteUI(unsigned int address, sc_uint<(DATA_WIDTH+7)/8> byteEnable, const DATA_TYPE_U& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busByteWrite(address, byteEnable, (const DATA_TYPE_BV)data);
    }

    void busByteWriteUI(unsigned int address, sc_uint<(DATA_WIDTH+7)/8> byteEnable, const sc_uint_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busByteWrite(address, byteEnable, (const DATA_TYPE_BV)data);
    }

    void busWaitForChange(unsigned int address)
    {
        channel->bus->waitForChange(*this->channel, address);
    }

    // Returns a 32-bit integer indicating which interrupt signals are currently active.
    // If setInterruptWidth(n) has been called with n < 32, bits higher than n will
    // always be 0. Any other bit, m, will be set according to what value a slave mapped
    // at IRQ m has caled setInterrupt() with.
	sc_uint<32> getInterrupts(void)
	{
		return interruptFlags;
	}

    ALT_AVALON_MM_MASTER()
    :interruptWidth(32)
    {
        _effectiveWidthBits = 8;
        while (_effectiveWidthBits < DATA_WIDTH) _effectiveWidthBits *= 2;
    }

    virtual ~ALT_AVALON_MM_MASTER() { }

    // Setup functions - these must only be called from the constructor

    // This function selects whether the generated interface should be clocked
    // from a separate clock (true) or whether it should be clocked from the
    // same clock as the rest of the logic.
    void setUseOwnClock(bool ownclock) {}

    // Set the number of interrupt inputs which should be provided.  If you
    // don't call getInterrupts then no interrupt logic will be provided so
    // there is no need to call this function.
	void setInterruptWidth(unsigned int width)
	{
		interruptWidth = width;
	}

    // This function selects the address group presented to the avalon
    // memory mapped fabric.  All masters in the same address group must
    // see the same slaves at the same addresses.  The default address
    // group is 0
    void setAddressGroup(unsigned int group) {}

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_mm_master;bus:avalon,interrupt");

// /////////////////////////////////////////////////////////////////
//
// ALT_AVALON_MM_MASTER_FIFO
//

// type for commands in the command fifo
// need only be defined locally to the ALT_AVALON_MM_MASTER_FIFO class really, but some older compilers
// have trouble with nested classes within templated classes, so it is pulled out here
template <class ADDR_TYPE, class BE_TYPE, int DATA_WIDTH>
class ALT_AVALON_MM_MASTER_FIFO_COMMAND
{
public:

    // enumeration of possible command operations
    enum OP
    {
        WRITE,
        WRITE_BURST,
        WRITE_BYTE_ENABLED,
        READ,
        READ_BURST
    };

private:

    // the operation to perform
    OP op;
    // address (or base address of burst)
    ADDR_TYPE address;
    // either length of burst or byte enables: mutually exclusive
    unsigned int len_be;

public:

    // create a command which does nothing
    ALT_AVALON_MM_MASTER_FIFO_COMMAND()
    : op(WRITE_BURST), address(0), len_be(0)
    {
    }

    // create a command to read or write a single address
    ALT_AVALON_MM_MASTER_FIFO_COMMAND(OP op, ADDR_TYPE address)
    : op(op), address(address)
    {
        assert((op == WRITE) || (op == READ));
    }

    // create a burst command
    ALT_AVALON_MM_MASTER_FIFO_COMMAND(OP op, ADDR_TYPE address, unsigned int length)
    : op(op), address(address), len_be(length)
    {
        assert((op == WRITE_BURST) || (op == READ_BURST));
    }

    // create a byte enabled write command
    ALT_AVALON_MM_MASTER_FIFO_COMMAND(OP op, ADDR_TYPE address, BE_TYPE byte_enables)
    : op(op), address(address), len_be(byte_enables)
    {
        assert(op == WRITE_BYTE_ENABLED);
    }

    // copy constructor
    ALT_AVALON_MM_MASTER_FIFO_COMMAND(const ALT_AVALON_MM_MASTER_FIFO_COMMAND& o)
    : op(o.op), address(o.address), len_be(o.len_be)
    {
    }

    // assignment operator
    ALT_AVALON_MM_MASTER_FIFO_COMMAND& operator=(const ALT_AVALON_MM_MASTER_FIFO_COMMAND& o)
    {
        if (this !=& o)
        {
            op = o.op;
            address = o.address;
            len_be = o.len_be;
        }
        return *this;
    }

    // virtual destructor
    virtual ~ALT_AVALON_MM_MASTER_FIFO_COMMAND()
    {
    }

    // access address
    ADDR_TYPE get_address() const
    {
        return address;
    }

    // access length
    unsigned int get_length() const
    {
        if ((op == WRITE_BURST) || (op == READ_BURST))
        {
            return len_be;
        }
        else
        {
            return 1;
        }
    }

    // access byte enables
    BE_TYPE get_byte_enables() const
    {
        if (op == WRITE_BYTE_ENABLED)
        {
            return BE_TYPE(len_be);
        }
        else
        {
            return BE_TYPE(-1);
        }
    }

    // access type
    OP get_op() const
    {
        return op;
    }

    // access read vs. write of type
    bool is_write() const
    {
        return ((op == WRITE) || (op == WRITE_BURST) || (op == WRITE_BYTE_ENABLED));
    }

    // modify this command to indicate that the first action it requires has been performed
    // returns true if there's life in this command yet, false if it is completed
    bool advance()
    {
        assert((op == WRITE_BURST) || (op == READ_BURST));
        address += DATA_WIDTH / 8;
        len_be -= 1;
        return (len_be != 0);
    }
};

template <class ADDR_TYPE, class BE_TYPE, int DATA_WIDTH>
ostream& operator<<(ostream& output, const ALT_AVALON_MM_MASTER_FIFO_COMMAND<ADDR_TYPE, BE_TYPE, DATA_WIDTH>& c)
{
    output << "(";
    switch (c.get_op())
    {
    case ALT_AVALON_MM_MASTER_FIFO_COMMAND<ADDR_TYPE, BE_TYPE, DATA_WIDTH>::WRITE:
        output << "WRITE addr = " << c.get_address();
        break;
    case ALT_AVALON_MM_MASTER_FIFO_COMMAND<ADDR_TYPE, BE_TYPE, DATA_WIDTH>::WRITE_BURST:
        output << "WRITE BURST addr = " << c.get_address() << ", length = " << c.get_length();
        break;
    case ALT_AVALON_MM_MASTER_FIFO_COMMAND<ADDR_TYPE, BE_TYPE, DATA_WIDTH>::WRITE_BYTE_ENABLED:
        output << "WRITE_BYTE_ENABLED addr = " << c.get_address() << ", byte enables = " << c.get_byte_enables();
        break;
    case ALT_AVALON_MM_MASTER_FIFO_COMMAND<ADDR_TYPE, BE_TYPE, DATA_WIDTH>::READ:
        output << "READ addr = " << c.get_address();
        break;
    case ALT_AVALON_MM_MASTER_FIFO_COMMAND<ADDR_TYPE, BE_TYPE, DATA_WIDTH>::READ_BURST:
        output << "READ BURST addr = " << c.get_address() << ", length = " << c.get_length();
        break;
    default:
        // TODO: die nicer than this
        //assert(false);
        output << "unrecognised command op";
    }
    output << ")";
    return output;
}

template<int DATA_WIDTH = 32, int ADDR_WIDTH = 16, int MAX_BURST = 8, int PARTIAL_DATA_WIDTH = 8>
class ALT_AVALON_MM_MASTER_FIFO : public alt_avalon_mm_master, public ALT_CUSP_SYNTH::FU
{
    typedef ALT_FAST_INT_TYPES<DATA_WIDTH> fast_int_types;
    typedef ALT_FAST_INT_TYPES<PARTIAL_DATA_WIDTH> fast_partial_int_types;

public:

    typedef typename fast_int_types::sint DATA_TYPE_S;
    typedef typename fast_int_types::uint DATA_TYPE_U;

    typedef typename fast_partial_int_types::sint PARTIAL_DATA_TYPE_S;
    typedef typename fast_partial_int_types::uint PARTIAL_DATA_TYPE_U;

    typedef sc_lv<DATA_WIDTH> DATA_TYPE_LV;
    typedef sc_bv<DATA_WIDTH> DATA_TYPE_BV;

    typedef sc_uint<ADDR_WIDTH> ADDR_TYPE;
    typedef sc_uint<(DATA_WIDTH + 7) / 8> BE_TYPE;

private:

	class MAX_BURST_CHECK
	{
	public:

		MAX_BURST_CHECK()
		{
			ALT_CUSP_ASSERT(MAX_BURST <= (1 << 29), "The maximum value for MAX_BURST is 1 << 29.");
		}
	};

	MAX_BURST_CHECK max_burst_check;

    typedef ALT_AVALON_MM_MASTER_FIFO_COMMAND<ADDR_TYPE, BE_TYPE, DATA_WIDTH> COMMAND;

    // command fifo carries commands from cusp to avalon-mm interface
    sc_fifo<COMMAND> *m_cmd_fifo;

    // wdata fifo carries write data from cusp to avalon-mm interface
    sc_fifo<DATA_TYPE_U> *m_wdata_fifo;

    // rdata fifo carries read data back from avalon-mm interface to cusp
    sc_fifo<DATA_TYPE_U> *m_rdata_fifo;

    int _effectiveWidthBits;

    virtual int getAddressWidth() { return ADDR_WIDTH; }
    virtual int getDataWidth() { return _effectiveWidthBits; }

    void acceptInterrupt(unsigned int irqNumber, bool active) {
        fprintf(stderr, "ALT_AVALON_MM_MASTER_FIFO does not currently support interrupts\n");
    }

    COMMAND m_current_command;
    bool m_have_command;

    // internal storage of partial words waiting to be written or read
    DATA_TYPE_U partial_writes;
    unsigned int partial_writes_waiting;
    DATA_TYPE_U partial_reads;
    unsigned int partial_reads_waiting;

public:

    void busPostRead(const ADDR_TYPE& address)
    {
        m_cmd_fifo->write(COMMAND(COMMAND::READ, address));
        wait(m_cmd_fifo->data_written_event());
        update();
    }

    // posting ordinary single read
    void busPostReadUI(const ADDR_TYPE& address)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busPostRead(address);
    }

    // posting ordinary single read
    void busPostReadSI(const ADDR_TYPE& address)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busPostRead(address);
    }

    // posting a burst read
    void busPostReadBurst(const ADDR_TYPE& address, unsigned int length)
    {
        if (length > MAX_BURST)
        {
            cout << "ERROR: burst length longer than configured maximum: " << length << ">" << MAX_BURST << endl;
            fflush(stdout);
            throw new alt_exception_config();
        }
        m_cmd_fifo->write(COMMAND(COMMAND::READ_BURST, address, length));
        wait(m_cmd_fifo->data_written_event());
        update();
    }

    // posting a burst read
    void busPostReadBurstUI(const ADDR_TYPE& address, unsigned int length)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busPostReadBurst(address, length);
    }

    // posting a burst read
    void busPostReadBurstSI(const ADDR_TYPE& address, unsigned int length)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busPostReadBurst(address, length);
    }

    // posting a burst write
    void busPostWriteBurst(const ADDR_TYPE& address, unsigned int length)
    {
        if (length > MAX_BURST)
        {
            cout << "ERROR: burst length longer than configured maximum: " << length << " > " << MAX_BURST << endl;
            fflush(stdout);
            throw new alt_exception_config();
        }
        m_cmd_fifo->write(COMMAND(COMMAND::WRITE_BURST, address, length));
        wait(m_cmd_fifo->data_written_event());
        update();
    }

    // collecting whole reads
    const DATA_TYPE_BV busCollectRead()
    {
        DATA_TYPE_BV rdata = m_rdata_fifo->read();
        wait(m_rdata_fifo->data_read_event());
        update();
        return rdata;
    }

    template<typename T>
    const T busCollectRead()
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return (T)busCollectRead();
    }

    // collecting whole reads (unsigned version)
    const DATA_TYPE_U busCollectReadUI()
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return busCollectRead<DATA_TYPE_U>();
    }

    // collecting whole reads (signed version)
    const DATA_TYPE_S busCollectReadSI()
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return busCollectRead<DATA_TYPE_S>();
    }

    // ordinary writes - address and data are presented at the same time
    void busWrite(const ADDR_TYPE& address, const DATA_TYPE_BV& data)
    {
        // a warning might be a good idea here, if the cmd and wdata fifos don't line up
        // it is very unlikely that what will happen in that case is what the user wants
        m_cmd_fifo->write(COMMAND(COMMAND::WRITE, address));
        wait(m_cmd_fifo->data_written_event());
        m_wdata_fifo->write(data);
        wait(m_wdata_fifo->data_written_event());
        update();
    }

    template<typename T>
    void busWrite(const ADDR_TYPE& address, const T& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWrite(address, (const DATA_TYPE_BV)data);
    }

    // ordinary writes - address and data are presented at the same time
    void busWriteUI(const ADDR_TYPE& address, const DATA_TYPE_U& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWrite(address, (const DATA_TYPE_BV)data);
    }

    // ordinary writes - address and data are presented at the same time
    void busWriteUI(const ADDR_TYPE& address, const sc_uint_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWrite(address, (const DATA_TYPE_BV)data);
    }

    // ordinary writes - address and data are presented at the same time
    void busWriteSI(const ADDR_TYPE& address, const DATA_TYPE_S& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWrite(address, (const DATA_TYPE_BV)data);
    }

    // ordinary writes - address and data are presented at the same time
    void busWriteSI(const ADDR_TYPE& address, const sc_int_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWrite(address, (const DATA_TYPE_BV)data);
    }

    // wait for change
    void busWaitForChange(unsigned int address)
    {
        channel->bus->waitForChange(*this->channel, address);
    }

    // ordinary byte-enabled write with address and data presented at the same time
    void busByteWrite(const ADDR_TYPE& address, sc_uint<(DATA_WIDTH+7)/8> byte_enables, const DATA_TYPE_U& data)
    {
        // a warning might be a good idea here, if the cmd and wdata fifos don't line up
        // it is very unlikely that what will happen in that case is what the user wants
          m_cmd_fifo->write(COMMAND(COMMAND::WRITE_BYTE_ENABLED, address, byte_enables));
          wait(m_cmd_fifo->data_written_event());
          m_wdata_fifo->write(data);
          wait(m_wdata_fifo->data_written_event());
          update();
    }

    // ordinary byte-enabled write with address and data presented at the same time
    template<typename T>
    void busByteWrite(const ADDR_TYPE& address, sc_uint<(DATA_WIDTH+7)/8> byte_enables, const T& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busByteWrite(address, byte_enables, (const DATA_TYPE_U)data);
    }

    // ordinary byte-enabled write with address and data presented at the same time
    void busByteWriteUI(const ADDR_TYPE& address, sc_uint<(DATA_WIDTH+7)/8> byte_enables, const DATA_TYPE_U& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busByteWrite(address, byte_enables, data);
    }

    // ordinary byte-enabled write with address and data presented at the same time
    void busByteWriteUI(const ADDR_TYPE& address, sc_uint<(DATA_WIDTH+7)/8> byte_enables, const sc_uint_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busByteWrite(address, byte_enables, (const DATA_TYPE_U)data);
    }

    // ordinary byte-enabled write with address and data presented at the same time
    void busByteWriteSI(const ADDR_TYPE& address, sc_uint<(DATA_WIDTH+7)/8> byte_enables, const DATA_TYPE_S& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busByteWrite(address, byte_enables, (const DATA_TYPE_U)data);
    }

    // ordinary byte-enabled write with address and data presented at the same time
    void busByteWriteSI(const ADDR_TYPE& address, sc_uint<(DATA_WIDTH+7)/8> byte_enables, const sc_int_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busByteWrite(address, byte_enables, (const DATA_TYPE_U)data);
    }

    // write data that is part of a burst (no address)
    void busWriteData(const DATA_TYPE_U& data)
    {
        m_wdata_fifo->write(data);
        wait(m_wdata_fifo->data_written_event());
        update();
    }

    // write data that is part of a burst (no address)
    template<typename T>
    void busWriteData(const T& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWriteData((const DATA_TYPE_U)data);
    }

    // write data that is part of a burst (no address)
    void busWriteDataUI(const DATA_TYPE_U& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWriteData(data);
    }

    // write data that is part of a burst (no address)
    void busWriteDataUI(const sc_uint_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWriteData((const DATA_TYPE_U)data);
    }

    // write data that is part of a burst (no address)
    void busWriteDataSI(const DATA_TYPE_S& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWriteData((const DATA_TYPE_U)data);
    }

    // write data that is part of a burst (no address)
    void busWriteDataSI(const sc_int_base& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        busWriteData((const DATA_TYPE_U)data);
    }

    // write a partial data word
    void writePartialData(const PARTIAL_DATA_TYPE_U& data)
    {
        // slot the new partial data write into the waiting full size data word
        DATA_TYPE_U shifted_data = DATA_TYPE_U(data);
        shifted_data <<= PARTIAL_DATA_WIDTH * partial_writes_waiting;
        partial_writes |= shifted_data;
        partial_writes_waiting++;

        // perform actual write if word ready
        if (partial_writes_waiting == (DATA_WIDTH / PARTIAL_DATA_WIDTH))
        {
            flush();
        }
    }

    // write a partial data word
    template<typename T>
    void writePartialData(const T& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        writePartialData((const PARTIAL_DATA_TYPE_U)data);
    }

    // write a partial data word
    void writePartialDataUI(const PARTIAL_DATA_TYPE_U& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        writePartialData(data);
    }

    // write a partial data word
    void writePartialDataSI(const PARTIAL_DATA_TYPE_S& data)
    ALT_CUSP_SYNTH_MODE(inline)
    {
        writePartialData((const PARTIAL_DATA_TYPE_U)data);
    }

    // perform a write with whatever we have waiting
    // if that's nothing waiting then don't do anything
    void flush()
    {
        if (partial_writes_waiting != 0)
        {
            busWriteDataUI(partial_writes);
            partial_writes = PARTIAL_DATA_TYPE_U(0);
            partial_writes_waiting = 0;
        }
    }

    // collect a partial data word
    PARTIAL_DATA_TYPE_U collectPartialRead()
    {
        // if there are no words waiting then perform a full read
        if (partial_reads_waiting == 0)
        {
            partial_reads = busCollectReadUI();
            partial_reads_waiting = DATA_WIDTH / PARTIAL_DATA_WIDTH;
        }

        // return a partial word
        PARTIAL_DATA_TYPE_U result = static_cast<PARTIAL_DATA_TYPE_U>(partial_reads); // grabs bottom bits
        partial_reads >>= PARTIAL_DATA_WIDTH;
        partial_reads_waiting--;
        return result;
    }

    // write a partial data word
    template<typename T>
    const T collectPartialRead()
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return (T)collectPartialRead();
    }

    // collect a partial data word
    PARTIAL_DATA_TYPE_U collectPartialReadUI()
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return collectPartialRead<PARTIAL_DATA_TYPE_U>();
    }

    // collect a partial data word
    PARTIAL_DATA_TYPE_S collectPartialReadSI()
    ALT_CUSP_SYNTH_MODE(inline)
    {
        return collectPartialRead<PARTIAL_DATA_TYPE_S>();
    }

    // discard any partial data words not yet read from the last whole word read
    // calling this when there's nothing to discard discards nothing
    void discard()
    {
        // discard any reads that may be waiting
        partial_reads = DATA_TYPE_U(0);
        partial_reads_waiting = 0;
    }

    unsigned int getInterrupts(void)
    {
        fprintf(stderr, "ALT_AVALON_MM_MASTER_FIFO does not currently support interrupts\n");
        return 0;
    }

    // SETUP FUNCTIONS - THESE MUST ONLY BE CALLED FROM THE CONSTRUCTOR

    // change the command fifo depth from the default
    void setCmdFifoDepth(unsigned int depth)
    {
        delete(m_cmd_fifo);
        m_cmd_fifo = new sc_fifo<COMMAND>(depth);
    }

    // change the rdata fifo depth from the default
    void setRdataFifoDepth(unsigned int depth)
    {
        delete(m_rdata_fifo);
        m_rdata_fifo = new sc_fifo<DATA_TYPE_U>(depth);
    }

    // change the wdata fifo depth from the default
    void setWdataFifoDepth(unsigned int depth)
    {
        delete(m_wdata_fifo);
        m_wdata_fifo = new sc_fifo<DATA_TYPE_U>(depth);
    }

    // set the read burst target - currently has no effect in host execution
    void setRdataBurstSize(unsigned int burstSize) {}

    // set the write burst target - currently has no effect in host execution
    void setWdataBurstSize(unsigned int burstSize) {}

    // detects whether the generated interface should be clocked
    // from a separate clock (true) or whether it should be clocked from the
    // same clock as the rest of the logic.
    void setUseOwnClock(bool ownclock) {}

    // Set the number of interrupt inputs which should be provided.  If you
    // don't call getInterrupts then no interrupt logic will be provided so
    // there is no need to call this function.
    void setInterruptWidth(unsigned int width) {}

    // This function selects the address group presented to the avalon
    // memory mapped fabric.  All masters in the same address group must
    // see the same slaves at the same addresses.  The default address
    // group is 0
    void setAddressGroup(unsigned int group) {}

    // This function provides the equivalent of setting the DATA_WIDTH template
    // parameter.
    void setDataWidth(int n) {}

    // This function provides the equivalent of setting the ADDRESS_WIDTH
    // template parameter.
    void setAddressWidth(int n) {}

    // This function provides the equivalent of setting the MAX_BURST
    // template parameter.
    void setMaxBurst(int n) {}

    // This function provides the equivalent of setting the PARTIAL_DATA_WIDTH
    // template parameter.
    void setPartialDataWidth(int n) {}

    // This function requests that the read ports be enabled.
    void enableReadPorts() ALT_GNU_ATTRIBUTE(pure) {}

    // This function requests that the write ports be enabled.
    void enableWritePorts() ALT_GNU_ATTRIBUTE(pure) {}

    // ONLY FOR THE WRAPPER -- NOT SYNTHESISABLE
    bool isCmdFifoFull() ALT_GNU_ATTRIBUTE(pure) { return m_cmd_fifo->num_free() == 0; }

    // default (and only) constructor
    ALT_AVALON_MM_MASTER_FIFO()
    {
        // figure out the effective width
        _effectiveWidthBits = 8;
        while (_effectiveWidthBits < DATA_WIDTH){
            _effectiveWidthBits *= 2;
        }

        // initialise the avalon-mm side of the model
          m_have_command = false;

          // create fifos of default sizes
          m_cmd_fifo = new sc_fifo<COMMAND>(8);
          m_wdata_fifo = new sc_fifo<DATA_TYPE_U>(8);
          m_rdata_fifo = new sc_fifo<DATA_TYPE_U>(8);

          // start off with no partial reads or writes stored
          partial_writes_waiting = 0;
          partial_reads_waiting = 0;
          partial_writes = DATA_TYPE_U(0);
          partial_reads = DATA_TYPE_U(0);
    }

    // destructor deletes fifos
    virtual ~ALT_AVALON_MM_MASTER_FIFO()
    {
        delete(m_wdata_fifo);
        delete(m_rdata_fifo);
        delete(m_cmd_fifo);
    }

private:

    const DATA_TYPE_U busRead(ADDR_TYPE address)
    {
        if (fast_int_types::WIDE)
            return fast_int_types::from_wide_uint(channel->bus->readWide(*channel, address));
        else
            return (DATA_TYPE_U)channel->bus->read(*channel, address);
    }

    // this should be called whenever anything happens at the cusp end of the fifos
    // causes the avalon-mm model to do as much as is possible without more action
    // at the cusp end
    void update()
    {
        // process as many commands as possible
        bool stuck = false;
        while (!stuck)
        {
            // get a fresh command if the last one has run out
            // stuck if there are no more commands
            if (!m_have_command)
            {
                if (m_cmd_fifo->num_available() > 0)
                {
                    m_current_command = m_cmd_fifo->read();
                    m_have_command = true;
                }
                else
                {
                    stuck = true;
                }
            }

            // if we now have a command (are not stuck) then try to
            // process one operation from it
            if (m_have_command)
            {
                // check read or write
                if (m_current_command.is_write())
                {
                    // writing: get write data if possible, otherwise stuck
                    if (m_wdata_fifo->num_available() > 0)
                    {
                        DATA_TYPE_U wdata = m_wdata_fifo->read();
                        switch (m_current_command.get_op())
                        {
                        case COMMAND::WRITE:
                            channel->bus->write(*channel, m_current_command.get_address(), (DATA_TYPE_S)wdata);
                            m_have_command = false;
                            break;
                        case COMMAND::WRITE_BYTE_ENABLED:
                        {
                            DATA_TYPE_U rdata = busRead(m_current_command.get_address());
                            for (unsigned int n = 0; n < ((DATA_WIDTH + 7) / 8); n++)
                            {
                                if (m_current_command.get_byte_enables() & (1 << n))
                                {
                                    unsigned int start = n * 8;
                                    unsigned int end = start + 7;
                                    rdata.range(end, start) = wdata.range(end, start);
                                }
                            }
                            channel->bus->write(*channel, m_current_command.get_address(), (DATA_TYPE_S)rdata);
                            m_have_command = false;
                            break;
                        }
                        case COMMAND::WRITE_BURST:
                            if (m_current_command.get_length() == 0)
                            {
                                m_have_command = false;
                            }
                            else
                            {
                                channel->bus->write(*channel, m_current_command.get_address(), (DATA_TYPE_S)wdata);
                                m_have_command = m_current_command.advance();
                            }
                            break;
                        default:
                            // TODO: replace this with a better error
                            assert(false);
                        }
                    }
                    else
                    {
                        stuck = true;
                    }
                }
                else
                {
                    // reading: stuck right away if nowhere to put data
                    if (m_rdata_fifo->num_free() > 0)
                    {
                        DATA_TYPE_U rdata;
                        switch (m_current_command.get_op())
                        {
                        case COMMAND::READ:
                            rdata = busRead(m_current_command.get_address());
                            m_have_command = false;
                            break;
                        case COMMAND::READ_BURST:
                            if (m_current_command.get_length() == 0)
                            {
                                m_have_command = false;
                            }
                            else
                            {
                                rdata = busRead(m_current_command.get_address());
                                m_have_command = m_current_command.advance();
                            }
                            break;
                        default:
                            // TODO: replace this with a better error
                            assert(false);
                        }
                        m_rdata_fifo->write(rdata);
                        wait(m_rdata_fifo->data_written_event());
                    }
                    else
                    {
                        stuck = true;
                    }
                }
            }
        }
    }

} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_avalon_mm_master_fifo;bus:avalon,interrupt");

#endif // __ALT_AVALON_MM_H
