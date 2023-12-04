/**
* \file vip_vfb_hwfast.hpp
*
* \author vshankar
*
* \brief Synthesisable frame buffer core.
* A frame buffer core that can be parameterised and then synthesised with CusP.
* It allows for double buffering (frames are neither dropped nor repeated) and triple buffering (frames can be dropped and/or repeated)
*/

// Prevents CusP 7.1 from sequencing IO on separate ports i.e. behave as it used to
#pragma cusp_config createSeparateSeqSpaceForEachIOFU = yes

#ifndef __CUSP__
    #include <alt_cusp.h>
#endif // n__CUSP__

#include "vip_constants.h"
#include "vip_common.h"

#ifndef LEGACY_FLOW
    #undef VFB_NAME
    #define VFB_NAME alt_vip_vfb
#endif

// Compute useful memory sizes (in bytes) for a frame of image data
#define VFB_MAX_FIELD_SIZE          (VFB_MAX_WORDS_IN_FIELD * VFB_WORD_BYTES) 
// Compute useful memory sizes (in bytes) to store the control and user packets
#define VFB_MAX_PACKETS_SIZE        (VFB_MAX_NUMBER_PACKETS * VFB_MAX_WORDS_IN_PACKET * VFB_WORD_BYTES)

// Intitialise the different addresses
#define VFB_FRAMEBUFFER_SIZE        (VFB_MAX_FIELD_SIZE + VFB_MAX_PACKETS_SIZE)
#define VFB_FRAMEBUFFER0_ADDR       VFB_FRAMEBUFFERS_BASE_ADDR
#define VFB_FRAMEBUFFER1_ADDR       (VFB_FRAMEBUFFERS_BASE_ADDR + VFB_FRAMEBUFFER_SIZE)
#define VFB_FRAMEBUFFER2_ADDR       (VFB_FRAMEBUFFERS_BASE_ADDR + (VFB_FRAMEBUFFER_SIZE * 2))
#define VFB_FIELD0_ADDR             (VFB_FRAMEBUFFER0_ADDR + VFB_MAX_PACKETS_SIZE)
#define VFB_FIELD1_ADDR             (VFB_FRAMEBUFFER1_ADDR + VFB_MAX_PACKETS_SIZE)
#define VFB_FIELD2_ADDR             (VFB_FRAMEBUFFER2_ADDR + VFB_MAX_PACKETS_SIZE)

// Initialisation, the token passed between threads to designate buffer ids
#define INITIAL_WRITE            0        // Write the first frame in frame buffer 0
#define INITIAL_STORAGE          1        // Then the next one in frame buffer 1
#define INITIAL_UNUSED           2        // If the frame buffer is a triple buffer, this is the third buffer initially unused

// Write to read FIFO to send buffer token of the frames stored and their size (in samples and in words)
#define WRITE_TO_READ_FIFO_WIDTH   VFB_LOG2G_MAX_SAMPLES_IN_FIELD
#define WRITE_TO_READ_FIFO_SIZE    8

// Read to write FIFO to pass back the buffer tokens
#define READ_TO_WRITE_FIFO_WIDTH   VFB_LOG2G_NUMBER_BUFFERS
#define READ_TO_WRITE_FIFO_SIZE    2                      // Bug with SystemC model of a FIFO, extra space needed

// Write to read FIFO to send packet tokens that go with the frame in buffers_read_to_write
// The user packets FIFO contains at most VFB_MAX_NUMBER_PACKETS*2+ 2 elements per frame,
// 1 extra space is added at the start to indicate which packet has to be sent first (base_packet_id)
// 1 extra space is added at the end for a 0 marker to delimit frame boundaries
// the *2 comes from the fact that we send both the length in samples and the length in words for each packet
#define PACKETS_FIFO_WIDTH         VFB_LOG2G_MAX_SAMPLES_IN_PACKET
#define PACKETS_FIFO_SIZE          ((VFB_MAX_NUMBER_PACKETS*2) + 2) * VFB_NUMBER_BUFFERS

// Size of the address port
#define VFB_MEM_ADDR_WIDTH 32

// Static parameters for the optional runtime controllers
#define VFB_WRITER_CTRL_INTERFACE_WIDTH 16
#define VFB_WRITER_CTRL_INTERFACE_DEPTH 4
#define VFB_READER_CTRL_INTERFACE_WIDTH 16
#define VFB_READER_CTRL_INTERFACE_DEPTH 4

// Set up the max burst to be in agreement with both the XDATA_BURST_TARGETs parameters and the actual burst that are posted by the core
// If VFB_?DATA_BURST_TARGET is bigger than the parameter it is compared too then the hardware is probably not very efficient
#define VFB_MAX_WORDS_READ_BURST    ((VFB_MAX_WORDS_IN_FIELD > VFB_MAX_WORDS_IN_PACKET) ? VFB_MAX_WORDS_IN_FIELD : VFB_MAX_WORDS_IN_PACKET)
#define VFB_READ_MASTER_MAX_BURST   ((VFB_MAX_WORDS_READ_BURST > VFB_RDATA_BURST_TARGET) ? VFB_MAX_WORDS_READ_BURST : VFB_RDATA_BURST_TARGET)
#define VFB_WRITE_MASTER_MAX_BURST  VFB_WDATA_BURST_TARGET
// Reserve enough space in the command FIFO so that we can issue enough write command to fill the FIFO, + 1 to avoid lock during pipelining
#define VFB_WDATA_CMD_FIFO_DEPTH    ((VFB_WDATA_FIFO_DEPTH / VFB_WDATA_BURST_TARGET) + 1)

SC_MODULE(VFB_NAME)
{
#ifndef LEGACY_FLOW
    static const char * get_entity_helper_class(void)
    {
        return "ip_toolbench/frame_buffer.jar?com.altera.vip.entityinterfaces.helpers.VFBEntityHelper";
    }
    static const char * get_display_name(void)
    {
        return "Frame Buffer";
    }
    static const char * get_certifications(void)
    {
        return "SOPC_BUILDER_READY";
    }
    static const char * get_description(void)
    {
        return "The Frame Buffer provides a means to double or triple buffer video frames.";
    }
    static const char * get_product_ids(void)
    {
        return "00C3";
    }
#include "vip_elementclass_info.h"
#else
    static const char * get_entity_helper_class(void)
    {
        return "default";
    }
#endif //LEGACY_FLOW

#ifndef SYNTH_MODE
#define VFB_BPS 20
#define VFB_CHANNELS_IN_PAR 3
#define VFB_MEM_PORT_WIDTH 256
#define VFB_WRITE_MASTER_MAX_BURST 32
#define VFB_READ_MASTER_MAX_BURST 32
#define VFB_MEM_MASTERS_USE_SEPARATE_CLOCK false
#endif
    
    //! Data input stream and output stream
    ALT_AVALON_ST_INPUT< sc_uint<VFB_BPS*VFB_CHANNELS_IN_PAR> > *din;
    ALT_AVALON_ST_OUTPUT< sc_uint<VFB_BPS*VFB_CHANNELS_IN_PAR> > *dout;

    //! A couple of master ports, one for reading and one for writing
    ALT_AVALON_MM_MASTER_FIFO<VFB_MEM_PORT_WIDTH, VFB_MEM_ADDR_WIDTH, VFB_READ_MASTER_MAX_BURST, VFB_BPS * VFB_CHANNELS_IN_PAR> *read_master ALT_BIND_SEQ_PER_RESOURCE;
    ALT_AVALON_MM_MASTER_FIFO<VFB_MEM_PORT_WIDTH, VFB_MEM_ADDR_WIDTH, VFB_WRITE_MASTER_MAX_BURST, VFB_BPS * VFB_CHANNELS_IN_PAR> *write_master ALT_BIND_SEQ_PER_RESOURCE;

    // Runtime control ports
    ALT_AVALON_MM_MEM_SLAVE <VFB_WRITER_CTRL_INTERFACE_WIDTH, VFB_WRITER_CTRL_INTERFACE_DEPTH> *writer_control;
    ALT_AVALON_MM_MEM_SLAVE <VFB_READER_CTRL_INTERFACE_WIDTH, VFB_READER_CTRL_INTERFACE_DEPTH> *reader_control;


#ifdef SYNTH_MODE
    //! To communicate between the two threads when triple buffering, the size of the write_to_read fifo depends on whether
    //! width and height can change dynamically and have to be transmitted to the read_from_memory_to_dout thread
    ALT_FIFO< sc_uint<READ_TO_WRITE_FIFO_WIDTH>, READ_TO_WRITE_FIFO_SIZE > buffers_read_to_write;
    ALT_FIFO< sc_uint<WRITE_TO_READ_FIFO_WIDTH>, WRITE_TO_READ_FIFO_SIZE > buffers_write_to_read;
    ALT_FIFO< sc_uint<PACKETS_FIFO_WIDTH>, PACKETS_FIFO_SIZE > packets_write_to_read;

    void write_input_to_memory()
    {
        // length_counter, to track the length of incoming packets (image data or other packets)
        ALT_AU<VFB_LENGTH_COUNTER_WIDTH> LENGTH_COUNTER_AU;
        sc_uint<VFB_LENGTH_COUNTER_WIDTH> length_counter BIND(LENGTH_COUNTER_AU);

        // word_counter, to track the length (in words) of incoming packets (image data or other packets)
        ALT_AU<VFB_WORD_COUNTER_WIDTH> WORD_COUNTER_AU;
        sc_uint<VFB_WORD_COUNTER_WIDTH> word_counter BIND(WORD_COUNTER_AU);
        
        // Triggers each time the SAMPLES_IN_WORDS elements have gone into a word
        ALT_AU<VFB_TRIGGER_COUNTER_WIDTH> WORD_COUNTER_TRIGGER_AU;
        sc_int<VFB_TRIGGER_COUNTER_WIDTH> word_counter_trigger BIND(WORD_COUNTER_TRIGGER_AU);

        // Current buffer, initialised to buffer INITIAL_WRITE
        sc_uint<VFB_LOG2G_NUMBER_BUFFERS> write_buffer = sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(INITIAL_WRITE);

        // write_address and WRITE_ADDRESS_AU, to track the address to write to in memory
        ALT_AU<VFB_MEM_ADDR_WIDTH> WRITE_ADDRESS_AU;
        sc_uint<VFB_MEM_ADDR_WIDTH> write_address BIND(WRITE_ADDRESS_AU);

        // Length of the packets in samples
        ALT_AU<VFB_LOG2G_MAX_SAMPLES_IN_PACKET> PACKETS_SAMPLE_LENGTH_AU[VFB_MAX_NUMBER_PACKETS];
        sc_uint<VFB_LOG2G_MAX_SAMPLES_IN_PACKET> packets_sample_length[VFB_MAX_NUMBER_PACKETS] BIND(PACKETS_SAMPLE_LENGTH_AU);
        // Length of the packets in words
        ALT_AU<VFB_LOG2G_MAX_WORDS_IN_PACKET> PACKETS_WORD_LENGTH_AU[VFB_MAX_NUMBER_PACKETS];
        sc_uint<VFB_LOG2G_MAX_WORDS_IN_PACKET> packets_word_length[VFB_MAX_NUMBER_PACKETS] BIND(PACKETS_WORD_LENGTH_AU);
        // Base address for each packet
        ALT_AU<VFB_MEM_ADDR_WIDTH> PACKET_WRITE_ADDRESS_AU;
        sc_uint<VFB_MEM_ADDR_WIDTH> packet_write_address BIND(PACKET_WRITE_ADDRESS_AU);

        // The first packet to send (corresponds to an address), this counter wraps around in case of overflow
        ALT_AU<VFB_LOG2_MAX_NUMBER_PACKETS> FIRST_PACKET_ID_AU;
        sc_uint<VFB_LOG2_MAX_NUMBER_PACKETS> first_packet_id BIND(FIRST_PACKET_ID_AU); // Stays at 0 until overflowing
        // The last packet written, stays to MAX_NUMBER_PACKETS when overflowing
        ALT_AU<VFB_LOG2G_MAX_NUMBER_PACKETS> NEXT_TO_LAST_PACKET_ID_AU;
        sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS> next_to_last_packet_id BIND(NEXT_TO_LAST_PACKET_ID_AU);

        #if VFB_WRITER_RUNTIME_CONTROL
            ALT_AU<VFB_WRITER_CTRL_INTERFACE_WIDTH> WRITER_CONTROL_COUNTER_AU; // To increment counter in memory
            sc_uint<VFB_WRITER_CTRL_INTERFACE_WIDTH> writer_control_counter BIND(WRITER_CONTROL_COUNTER_AU);
            // set Go bit to zero, because start up state of memory mapped slaves is undefined
            writer_control->writeUI(VFB_WRITER_CTRL_Go_ADDRESS, 0);
            writer_control->writeUI(VFB_WRITER_CTRL_Status_ADDRESS, 0);
            writer_control->writeUI(VFB_WRITER_CTRL_Count_ADDRESS, 0);
            writer_control->writeUI(VFB_WRITER_CTRL_Drop_ADDRESS, 0);
        #endif

        for (;;)
        {
            // Resetting packet_write_address to correct address for the new frame
            sc_uint<VFB_MEM_ADDR_WIDTH> packet_base_address;
#if VFB_IS_TRIPLE_BUFFER
            packet_base_address = (write_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(0)) ? VFB_FRAMEBUFFER0_ADDR :
                                  ((write_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(1)) ? VFB_FRAMEBUFFER1_ADDR : VFB_FRAMEBUFFER2_ADDR);
#else
            packet_base_address = (write_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(0)) ? VFB_FRAMEBUFFER0_ADDR : VFB_FRAMEBUFFER1_ADDR;
#endif

            packet_write_address = packet_base_address;
            next_to_last_packet_id = 0;
            first_packet_id = 0;

            for (sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS> k = 0; k < sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS>(VFB_MAX_NUMBER_PACKETS); ++k)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                packets_sample_length[k] = 0;
                packets_word_length[k] = 0;
            }
            // write_address itself is always re-initialised when starting a new frame, no need to do it here

#if VFB_DROP_FRAMES        // This is a do while loop until the frame is not dropped,
            bool drop;     // This gets set to true at the end of the loop if the reader did not return a new buffer to write onto yet
            do
            {
#endif
                /**************************************** Process the packets that precede the image data ***************************************/
                sc_uint<HEADER_WORD_BITS> header_type;
                sc_uint<VFB_BPS*VFB_CHANNELS_IN_PAR> just_read;
                do
                {
                    just_read = din->read();
                    header_type = just_read;
                    if (sc_uint<HEADER_WORD_BITS>(just_read) != sc_uint<HEADER_WORD_BITS>(IMAGE_DATA))
                    {
                        // Store the packet at appropriate address and compute its length simultaneously
                        HW_DEBUG_MSG("write_input_to_memory, parsing & storing packet" << std::endl);
                        write_address = packet_write_address;

                        // Init the counters and send the header
                        length_counter = 1;
                        word_counter = 0;
                        word_counter_trigger = VFB_SAMPLES_IN_WORD - 2;

                        write_master->writePartialDataUI(just_read);

                        while (!din->getEndPacket())
                        {
                            ALT_ATTRIB(ALT_MOD_SCHED, ALT_MOD_SCHED_ON);
                            ALT_ATTRIB(ALT_MOD_TARGET, 1);
                            ALT_ATTRIB(ALT_MIN_ITER, 3);
                            ALT_ATTRIB(ALT_SKIDDING, true);

                            // Did we write the last sample of a word?
                            bool word_counter_trigger_flag BIND(ALT_WIRE) = word_counter_trigger.bit(VFB_TRIGGER_COUNTER_WIDTH-1);

                            // Did we write the last sample before overflow last loop iteration?
                            bool overflow_flag BIND(ALT_WIRE) = ((word_counter == sc_uint<VFB_WORD_COUNTER_WIDTH>(VFB_MAX_WORDS_IN_PACKET-1)) &&
                                                                  word_counter_trigger_flag);

                            // Are we writting data this iteration?
                            bool active_write_flag BIND(ALT_WIRE) = !overflow_flag && !din->getEndPacket();

                            // Increment word_counter by 1 each time the trigger reaches -1 (unless this is not an active write cycle)
                            // Even if the last sample was written previous iteration, word_counter may be increased once more.
                            // This is because the overflow condition can only be detected one cycle too late to avoid a data dependency
                            // loop (overflow_flag depends on word_counter so word_counter cannot depend on overflow_flag computed this iteration)
                            word_counter = WORD_COUNTER_AU.cAddSubUI(word_counter,
                                                                     sc_uint<1>(1), word_counter,
                                                                     active_write_flag && word_counter_trigger_flag,
                                                                     false);
                            // Cycle word_counter_trigger and increase number of words if necessary
                            word_counter_trigger = WORD_COUNTER_TRIGGER_AU.cAddSubSLdSI(
                                                   word_counter_trigger, sc_int<1>(-1),                       // General case, --word_counter_trigger
                                                   VFB_SAMPLES_IN_WORD - 2,                                   // -1 reached previous iteration? reinitialise and count the write
                                                   word_counter_trigger,                                      // Stay at current value if !enable
                                                   active_write_flag,                                         // Enable line
                                                   word_counter_trigger_flag,                                 // sLd line, reinit if word_counter_trigger == -1 (unless enable is false)
                                                   false);                                                    // Always add -1


                            just_read = din->cRead(!din->getEndPacket());

                            // Increment length_counter if !eop (and if new sample can be written)
                            length_counter = LENGTH_COUNTER_AU.cAddSubUI(length_counter, sc_uint<1>(1), length_counter, active_write_flag, false);
                            
                            if (active_write_flag)            // Do the write if not eop and not past the last sample of the last word
                            {
                                write_master->writePartialDataUI(just_read);
                            }                            

                            // Is it time to post a full burst?
                            #if (VFB_MAX_WORDS_IN_PACKET >= VFB_WDATA_BURST_TARGET)
                                bool burst_trigger BIND(ALT_WIRE);
                                burst_trigger = sc_uint<LOG2(VFB_WDATA_BURST_TARGET)>(word_counter) == sc_uint<LOG2(VFB_WDATA_BURST_TARGET)>(VFB_WDATA_BURST_TARGET-1) && word_counter_trigger_flag; 
    
                                // New burst ?
                                if (active_write_flag && burst_trigger)
                                {
                                    HW_DEBUG_MSG("write_input_to_memory, posting burst " << VFB_WDATA_BURST_TARGET << " at addr " << write_address << std::endl);
                                    write_master->busPostWriteBurst(write_address, VFB_WDATA_BURST_TARGET);
                                    write_address += (VFB_WDATA_BURST_TARGET << VFB_LOG2_WORD_BYTES);
                                }
                            #endif
                        }
                        
                        // Finish and count the last word
                        write_master->flush();
                        ++word_counter;

                        // Post the last burst (probably the first in most cases), truncate word_counter to get the size
                        if (sc_uint<LOG2(VFB_WDATA_BURST_TARGET)>(word_counter))
                        {
                            HW_DEBUG_MSG("write_input_to_memory, posting burst " << sc_uint<LOG2(VFB_WDATA_BURST_TARGET)>(word_counter) << " at addr " << write_address << std::endl);
                            write_master->busPostWriteBurst(write_address, sc_uint<LOG2(VFB_WDATA_BURST_TARGET)>(word_counter));
                        }
                        
                        // Purge input until eop in case of overflow
                        HW_DEBUG_MSG_COND(!din->getEndPacket(), "write_input_to_memory, memory overflow, discarding extra packet data" << std::endl);
                        while (!din->getEndPacket())
                        {
                            ALT_ATTRIB(ALT_MOD_SCHED, ALT_MOD_SCHED_ON);
                            ALT_ATTRIB(ALT_MOD_TARGET, 1);
                            ALT_ATTRIB(ALT_MIN_ITER, 3);
                            ALT_ATTRIB(ALT_SKIDDING, true);
                            din->cRead(!din->getEndPacket());
                        }

                        HW_DEBUG_MSG("write_input_to_memory, stored " << length_counter << " * "
                                     << VFB_CHANNELS_IN_PAR << " samples (including header), " << word_counter << " words, at adress " << packet_write_address << std::endl);
                        
                        // Build a wire to indicate overflow condition
                        bool packet_overflow_wire BIND(ALT_WIRE);
                        packet_overflow_wire = (next_to_last_packet_id == sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS>(VFB_MAX_NUMBER_PACKETS));
                        
                        // Store length of packet at appropriate location, and simultaneously switch all lengths if overflowing
                        for (sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS> k = 0;
                                k < sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS>(VFB_MAX_NUMBER_PACKETS - 1); ++k)
                        {
                            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                            packets_sample_length[k] = PACKETS_SAMPLE_LENGTH_AU[k].mCLdUI(length_counter,
                                                       packets_sample_length[k + sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS>(1)],
                                                       packets_sample_length[k],
                                                       next_to_last_packet_id == k,
                                                       packet_overflow_wire);
                            packets_word_length[k] = PACKETS_WORD_LENGTH_AU[k].mCLdUI(word_counter,
                                                     packets_word_length[k + sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS>(1)],
                                                     packets_word_length[k],
                                                     next_to_last_packet_id == k,
                                                     packet_overflow_wire);
                        }
                        // Increment first_packet_id (if overflow), wrap around if necessary
                        first_packet_id = FIRST_PACKET_ID_AU.cAddSubSLdUI(
                                          first_packet_id, sc_uint<VFB_LOG2_MAX_NUMBER_PACKETS>(1),      // + 1
                                          sc_uint<VFB_LOG2_MAX_NUMBER_PACKETS>(0),                       // Wrapping around
                                          first_packet_id,                                               // Maintain current value
                                          packet_overflow_wire,                                          // Maintain to 0 if !overflow
                                          first_packet_id == sc_uint<VFB_LOG2_MAX_NUMBER_PACKETS>(VFB_MAX_NUMBER_PACKETS - 1),      // -> Wrap around
                                          false);                                                        // Always an addition of +1
                        // Increment next_to_last_packet_id for next packet or maintain if overflowing
                        next_to_last_packet_id = NEXT_TO_LAST_PACKET_ID_AU.cAddSubUI(next_to_last_packet_id,
                                                 sc_uint<1>(1),
                                                 next_to_last_packet_id, !packet_overflow_wire, false);

                        // Update packet_overflow_wire now that next_to_last_packet_id has been incremented
                        packet_overflow_wire = (next_to_last_packet_id == sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS>(VFB_MAX_NUMBER_PACKETS));
                        // Write length on the last register if relevant (it was not done in the loop above)
                        packets_sample_length[VFB_MAX_NUMBER_PACKETS - 1] =
                            PACKETS_SAMPLE_LENGTH_AU[VFB_MAX_NUMBER_PACKETS - 1].cLdUI(length_counter,
                                    packets_sample_length[VFB_MAX_NUMBER_PACKETS - 1],
                                    packet_overflow_wire);
                        packets_word_length[VFB_MAX_NUMBER_PACKETS - 1] =
                            PACKETS_WORD_LENGTH_AU[VFB_MAX_NUMBER_PACKETS - 1].cLdUI(word_counter,
                                    packets_word_length[VFB_MAX_NUMBER_PACKETS - 1],
                                    packet_overflow_wire);
                        // Increment packet_write_address for next packet, wrap around if necessary
                        packet_write_address = PACKET_WRITE_ADDRESS_AU.addSubSLdUI(packet_write_address,
                                               sc_uint<VFB_MEM_ADDR_WIDTH>(VFB_MAX_WORDS_IN_PACKET * VFB_WORD_BYTES),
                                               packet_base_address,
                                               (first_packet_id == sc_uint<VFB_LOG2_MAX_NUMBER_PACKETS>(0))
                                               && packet_overflow_wire,
                                               false);
                    }
                }
                while (header_type != IMAGE_DATA);


                /**************************************** Process the video data ************************************************************/
                #if VFB_WRITER_RUNTIME_CONTROL
                    // Wait for the GO bit to be 1
                    while (sc_uint<1>(writer_control->readUI(VFB_WRITER_CTRL_Go_ADDRESS)) != sc_uint<1>(1))
                        writer_control->waitForChange();
                    // Set Status bit back to 1 while processing video data
                    writer_control->writeUI(VFB_WRITER_CTRL_Status_ADDRESS, 1);
                #endif

                // (re)Set write address to start of chosen write frame
#if VFB_IS_TRIPLE_BUFFER
                write_address = (write_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(0)) ? VFB_FIELD0_ADDR :
                                ((write_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(1)) ? VFB_FIELD1_ADDR : VFB_FIELD2_ADDR);
#else

                write_address = (write_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(0)) ? VFB_FIELD0_ADDR : VFB_FIELD1_ADDR;
#endif

                HW_DEBUG_MSG("write_input_to_memory, receiving image data in buffer " << write_buffer << " addr " << write_address << std::endl);

                // Write image data to the buffer
                length_counter = 0;
                word_counter = 0;
                word_counter_trigger = VFB_SAMPLES_IN_WORD - 1;
                bool empty_image = din->getEndPacket();
                while (!din->getEndPacket())
                {
                    ALT_ATTRIB(ALT_MOD_SCHED, ALT_MOD_SCHED_ON);
                    ALT_ATTRIB(ALT_MOD_TARGET, 1);
                    ALT_ATTRIB(ALT_MIN_ITER, 3);
                    ALT_ATTRIB(ALT_SKIDDING, true);

                    // Did we write the last sample of a word?
                    bool word_counter_trigger_flag BIND(ALT_WIRE) = word_counter_trigger.bit(VFB_TRIGGER_COUNTER_WIDTH-1);

                    // Did we write the last sample before overflow?
                    bool overflow_flag BIND(ALT_WIRE) = ((word_counter == sc_uint<VFB_WORD_COUNTER_WIDTH>(VFB_MAX_WORDS_IN_FIELD-1)) &&
                                                            word_counter_trigger_flag);

                    // Are we writting data this iteration?
                    bool active_write_flag BIND(ALT_WIRE) = !overflow_flag && !din->getEndPacket();

                    // Increment word_counter by 1 each time the trigger reaches -1 (unless this is not an active write cycle)
                    word_counter = WORD_COUNTER_AU.cAddSubUI(word_counter,
                                                             sc_uint<1>(1), word_counter,
                                                             active_write_flag && word_counter_trigger_flag,
                                                             false);
                    // Cycle word_counter_trigger and increase number of words if necessary
                    word_counter_trigger = WORD_COUNTER_TRIGGER_AU.cAddSubSLdSI(
                                           word_counter_trigger, sc_int<1>(-1),                       // General case, --word_counter_trigger
                                           VFB_SAMPLES_IN_WORD - 2,                                   // -1 reached previous iteration? reinitialise and count the write
                                           word_counter_trigger,                                      // Stay at current value if !enable
                                           active_write_flag,                                         // Enable line
                                           word_counter_trigger_flag,                                 // sLd line, reinit if word_counter_trigger == -1 (unless enable is false)
                                           false);                                                    // Always add -1

                    just_read = din->cRead(!din->getEndPacket());

                    // Increment length_counter if !eop (and if new sample can be written)
                    length_counter = LENGTH_COUNTER_AU.cAddSubUI(length_counter, sc_uint<1>(1), length_counter, active_write_flag, false);

                    if (active_write_flag)
                    {
                        write_master->writePartialDataUI(just_read);
                    }

                    // Is it time to post a full burst?
                    bool burst_trigger BIND(ALT_WIRE);
                    burst_trigger = sc_uint<LOG2(VFB_WDATA_BURST_TARGET)>(word_counter) == sc_uint<LOG2(VFB_WDATA_BURST_TARGET)>(VFB_WDATA_BURST_TARGET-1) && word_counter_trigger_flag; 

                    // New burst ?
                    if (active_write_flag && burst_trigger)
                    {
                        HW_DEBUG_MSG("write_input_to_memory, posting burst " << VFB_WDATA_BURST_TARGET << " at addr " << write_address << std::endl);
                        write_master->busPostWriteBurst(write_address, VFB_WDATA_BURST_TARGET);
                        write_address += (VFB_WDATA_BURST_TARGET << VFB_LOG2_WORD_BYTES);
                    }
                }

                // Finish and count the last word
                write_master->flush();
                if (!empty_image)
                {
                    ++word_counter;
                }

                // Post the last burst (probably the first in most cases), truncate word_counter to get the size
                if (sc_uint<LOG2(VFB_WDATA_BURST_TARGET)>(word_counter))
                {
                    HW_DEBUG_MSG("write_input_to_memory, posting burst " << sc_uint<LOG2(VFB_WDATA_BURST_TARGET)>(word_counter) << " at addr " << write_address << std::endl);
                    write_master->busPostWriteBurst(write_address, sc_uint<LOG2(VFB_WDATA_BURST_TARGET)>(word_counter));
                }
                
                // Purge input until eop in case of overflow
                HW_DEBUG_MSG_COND(!din->getEndPacket(), "write_input_to_memory, memory overflow, discarding extra image data" << std::endl);
                while (!din->getEndPacket())
                {
                    ALT_ATTRIB(ALT_MOD_SCHED, ALT_MOD_SCHED_ON);
                    ALT_ATTRIB(ALT_MOD_TARGET, 1);
                    ALT_ATTRIB(ALT_MIN_ITER, 3);
                    ALT_ATTRIB(ALT_SKIDDING, true);
                    din->cRead(!din->getEndPacket());
                }
                HW_DEBUG_MSG("write_input_to_memory, image data of length " << length_counter << ", " << word_counter << " words, received (excluding discard)" << std::endl);

#if VFB_DROP_FRAMES
                drop = !buffers_read_to_write.hasDataAvail();
                NO_CUSP(if (drop) HW_DEBUG_MSG("write_input_to_memory, new frame dropped" << std::endl);)
                #if VFB_WRITER_RUNTIME_CONTROL
                    writer_control_counter = writer_control->readUI(drop ? VFB_WRITER_CTRL_Drop_ADDRESS : VFB_WRITER_CTRL_Count_ADDRESS);
                    writer_control_counter = WRITER_CONTROL_COUNTER_AU.addUI(writer_control_counter, 1);
                    writer_control->writeUI(drop ? VFB_WRITER_CTRL_Drop_ADDRESS : VFB_WRITER_CTRL_Count_ADDRESS, writer_control_counter);
                    // Set Status bit back to zero while processing control packets of the next frame
                    writer_control->writeUI(VFB_WRITER_CTRL_Status_ADDRESS, 0);
                #endif          
            } while (drop);
#else       // Fields/frames cannot be dropped
            #if VFB_WRITER_RUNTIME_CONTROL
                writer_control_counter = writer_control->readUI(VFB_WRITER_CTRL_Count_ADDRESS);
                writer_control_counter = WRITER_CONTROL_COUNTER_AU.addUI(writer_control_counter, 1);
                writer_control->writeUI(VFB_WRITER_CTRL_Count_ADDRESS, writer_control_counter);
                // Set Status bit back to zero while exchanging buffers with the reader and processing control packets of the next frame
                writer_control->writeUI(VFB_WRITER_CTRL_Status_ADDRESS, 0);
            #endif
#endif

            HW_DEBUG_MSG("write_input_to_memory, new frame is kept and buffer is given to read_output_from_memory" << std::endl);
            HW_DEBUG_MSG("write_input_to_memory, along with " << next_to_last_packet_id << " AvST packets, "
                         << "starting at " << first_packet_id << std::endl);

            /* Send the frame to the "read_output_from_memory" thread, starts with the packets */
            // Start with the address of the first packet (the reader thread will match packet_id to address)
            packets_write_to_read.write(first_packet_id);
            // With or without overflow, write the packets from 0 to current_packet_id (excluded)
            for (sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS> k = 0; k < sc_uint<VFB_LOG2G_MAX_NUMBER_PACKETS>(VFB_MAX_NUMBER_PACKETS); ++k)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                if (k < next_to_last_packet_id)
                {
                    packets_write_to_read.write(packets_sample_length[k]);
                    packets_write_to_read.write(packets_word_length[k]);
                }
            }
            // Add a 0 to the packets_write_to_read queue to mark the end of the list of packets
            packets_write_to_read.write(0);

            // Send a message to the reader to say that the spare frame has fresh data in it and give the buffer token
            // Write down the length too
            buffers_write_to_read.write(write_buffer);
            buffers_write_to_read.write(length_counter);
            buffers_write_to_read.write(word_counter);

            // Receive a new buffer token from the reader and write on it at the next loop iteration,
            // this call might block with double buffering
            // ALT_DELAY to prevent CUSP from scheduling read and write on the same cycle which would cause a deadlock
            ALT_DELAY(write_buffer = buffers_read_to_write.read(), 1); 
        }
    }
    
    void read_output_from_memory()
    {
        // Keep track of the frame to read from
        sc_uint<VFB_LOG2G_NUMBER_BUFFERS> read_buffer = INITIAL_STORAGE;

        // read_address and READ_ADDRESS_AU operation on address in memory
        ALT_AU<VFB_MEM_ADDR_WIDTH> READ_ADDRESS_AU;
        sc_uint<VFB_MEM_ADDR_WIDTH> read_address BIND(READ_ADDRESS_AU);

        ALT_AU<VFB_MEM_ADDR_WIDTH> PACKET_READ_ADDRESS_AU;
        sc_uint<VFB_MEM_ADDR_WIDTH> packet_read_address BIND(PACKET_READ_ADDRESS_AU);
        // Keep a record of the base address so that we know where to wrap around
        sc_uint<VFB_MEM_ADDR_WIDTH> packet_base_address;
        // What is the first packet to send (usually 0 but this can be different if there was packet overflow)
        sc_uint<VFB_LOG2_MAX_NUMBER_PACKETS> current_packet_id;

        sc_uint<VFB_WORD_COUNTER_WIDTH> word_counter;
        sc_uint<VFB_LENGTH_COUNTER_WIDTH> length_counter;
        
        sc_int<VFB_LENGTH_COUNTER_WIDTH+1> length_cnt; // Counters for the loop

        // Add the third buffer token in the list of available buffer if triple-buffering
#if VFB_IS_TRIPLE_BUFFER
        buffers_read_to_write.write(sc_uint<READ_TO_WRITE_FIFO_WIDTH>(INITIAL_UNUSED));
#endif

        #if VFB_READER_RUNTIME_CONTROL
            ALT_AU<VFB_READER_CTRL_INTERFACE_WIDTH> READER_CONTROL_COUNTER_AU; // To increment counter in memory
            sc_uint<VFB_READER_CTRL_INTERFACE_WIDTH> reader_control_counter BIND(READER_CONTROL_COUNTER_AU);
            // set Go bit to zero, because start up state of memory mapped slaves is undefined
            reader_control->writeUI(VFB_READER_CTRL_Go_ADDRESS, 0);
            reader_control->writeUI(VFB_READER_CTRL_Status_ADDRESS, 0);
            reader_control->writeUI(VFB_READER_CTRL_Count_ADDRESS, 0);
            reader_control->writeUI(VFB_READER_CTRL_Repeat_ADDRESS, 0);
        #endif

        for (;;)
        {
            // Send a message to the writer to say that there is a new "dirty" buffer that can be used to write
            // a new frame (this works ok at initialization)
            buffers_read_to_write.write(read_buffer);

            // Receive a new buffer token from the writer and start outputting the new frame at the next loop iteration,
            // this call might block with double buffering (this works ok at initialization when we wait for the first frame)
            // ALT_DELAY to prevent CUSP from scheduling read and write on the same cycle which would cause a deadlock
            ALT_DELAY(read_buffer = buffers_write_to_read.read(), 1);

#if VFB_IS_TRIPLE_BUFFER
            packet_base_address = (read_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(0)) ? VFB_FRAMEBUFFER0_ADDR :
                                  ((read_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(1)) ? VFB_FRAMEBUFFER1_ADDR : VFB_FRAMEBUFFER2_ADDR);
#else

            packet_base_address = (read_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(0)) ? VFB_FRAMEBUFFER0_ADDR : VFB_FRAMEBUFFER1_ADDR;
#endif

            /* Propagate packets (until the 0 marker is found) */
            vip_assert(packets_write_to_read.hasDataAvail());
            packet_read_address = packet_base_address;
            current_packet_id = packets_write_to_read.read();
            HW_DEBUG_MSG("read_output_from_memory, start, from packet address id " << current_packet_id << std::endl);
            // Compute address of the first packet (a bit slow but this should do ok)
            for (sc_uint<VFB_LOG2_MAX_NUMBER_PACKETS> packet_id = 0; packet_id < current_packet_id; ++packet_id)
            {
                packet_read_address = PACKET_READ_ADDRESS_AU.addSubSLd(packet_read_address,
                                      sc_uint<VFB_MEM_ADDR_WIDTH>(VFB_MAX_WORDS_IN_PACKET * VFB_WORD_BYTES),
                                      packet_base_address /* don't care */,
                                      false,
                                      false);
            }

            // Get length of next packet and send until 0 is found
            length_counter = packets_write_to_read.read();
            while (length_counter != sc_uint<VFB_LENGTH_COUNTER_WIDTH>(0))
            {
                HW_DEBUG_MSG("read_output_from_memory, sending packet (size = " << length_counter << " * "
                             << VFB_CHANNELS_IN_PAR << "), from address " << packet_read_address << std::endl);
                // Get word_counter from the queue
                word_counter = packets_write_to_read.read();
                HW_DEBUG_MSG("read_output_from_memory, packet length in memory words = " << word_counter << std::endl);
                // Send the Avalon ST packet
                read_master->busPostReadBurst(packet_read_address, word_counter);
                length_cnt = length_counter - sc_uint<2>(2);
                while(!length_cnt.bit(VFB_LENGTH_COUNTER_WIDTH))
                {
                    ALT_ATTRIB(ALT_MOD_SCHED, ALT_MOD_SCHED_ON);
                    ALT_ATTRIB(ALT_MOD_TARGET, 1);
                    ALT_ATTRIB(ALT_MIN_ITER, 3);
                    ALT_ATTRIB(ALT_SKIDDING, true);
                    if (!length_cnt.bit(VFB_LENGTH_COUNTER_WIDTH)) // Because we may be violating MIN_ITER condition
                    {
                        dout->writeDataAndEop(read_master->collectPartialReadUI(), false);
                    }
                    --length_cnt;
                }
                dout->writeDataAndEop(read_master->collectPartialReadUI(), true);
                /* Discard unused data */
                read_master->discard();
                packet_read_address = PACKET_READ_ADDRESS_AU.addSubSLd(packet_read_address,
                                      sc_uint<VFB_MEM_ADDR_WIDTH>(VFB_MAX_WORDS_IN_PACKET * VFB_WORD_BYTES),
                                      packet_base_address,
                                      current_packet_id == sc_uint<VFB_LOG2_MAX_NUMBER_PACKETS>(VFB_MAX_NUMBER_PACKETS - 1),
                                      false);
                ++current_packet_id; // No need to reset this counter even if going over its limit
                length_counter = packets_write_to_read.read();
            }

            // Get the length of the new frame (it follows in the buffers_write_to_read FIFO just after the id of the buffer)
            length_counter = buffers_write_to_read.read();
            // Also get the length of the frame (in words) from the queue
            word_counter = buffers_write_to_read.read();
            HW_DEBUG_MSG("read_output_from_memory, length of the new frame in memory words = " << word_counter << std::endl);

#if VFB_REPEAT_FRAMES        // This is a do while loop until the frame stop being repeated,
            bool repeat;     // This gets set to true if the writer did not provide a new frame and decision was taken to repeat the current one 
            do
            {
#endif

                // Set read address to start of chosen read frame
#if VFB_IS_TRIPLE_BUFFER
                read_address = (read_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(0)) ? VFB_FIELD0_ADDR :
                               ((read_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(1)) ? VFB_FIELD1_ADDR : VFB_FIELD2_ADDR);
#else
                read_address = (read_buffer == sc_uint<VFB_LOG2G_NUMBER_BUFFERS>(0)) ? VFB_FIELD0_ADDR : VFB_FIELD1_ADDR;
#endif

                HW_DEBUG_MSG("read_output_from_memory, sending image data of length " << length_counter
                             << " from buffer " << read_buffer << " addr " << read_address << std::endl);

                #if VFB_READER_RUNTIME_CONTROL
                    // Wait for the GO bit to be 1
                    while (sc_uint<1>(reader_control->readUI(VFB_READER_CTRL_Go_ADDRESS)) != sc_uint<1>(1))
                        reader_control->waitForChange();
                    // Set Status bit back to 1 while processing video data
                    reader_control->writeUI(VFB_READER_CTRL_Status_ADDRESS, 1);
                #endif

                // Send the image data type
                bool empty_image BIND(ALT_WIRE);
                empty_image = (length_counter == sc_uint<VFB_LENGTH_COUNTER_WIDTH>(0));

                dout->writeDataAndEop(IMAGE_DATA, empty_image);
                // Send the image
                if (!empty_image)
                {
                    read_master->busPostReadBurst(read_address, word_counter);
                    length_cnt = length_counter - sc_uint<2>(2);
                    while (!length_cnt.bit(VFB_LENGTH_COUNTER_WIDTH))
                    {
                        ALT_ATTRIB(ALT_MOD_SCHED, ALT_MOD_SCHED_ON);
                        ALT_ATTRIB(ALT_MOD_TARGET, 1);
                        ALT_ATTRIB(ALT_MIN_ITER, 3);
                        ALT_ATTRIB(ALT_SKIDDING, true);
                        if (!length_cnt.bit(VFB_LENGTH_COUNTER_WIDTH)) // Because we may be violating MIN_ITER condition
                        {
                            dout->writeDataAndEop(read_master->collectPartialReadUI(), false);
                        }
                        --length_cnt;
                    }
                    dout->writeDataAndEop(read_master->collectPartialReadUI(), true);
                    /* Discard unused data */
                    read_master->discard();
                }
                HW_DEBUG_MSG("read_output_from_memory, frame sent" << std::endl);

#if VFB_REPEAT_FRAMES
                repeat = !buffers_write_to_read.hasDataAvail();
                NO_CUSP(if (repeat) HW_DEBUG_MSG("write_input_to_memory, new frame dropped" << std::endl);)
                #if VFB_READER_RUNTIME_CONTROL
                    reader_control_counter = reader_control->readUI(repeat ? VFB_READER_CTRL_Repeat_ADDRESS : VFB_READER_CTRL_Count_ADDRESS);
                    reader_control_counter = READER_CONTROL_COUNTER_AU.addUI(reader_control_counter, 1);
                    reader_control->writeUI(repeat ? VFB_READER_CTRL_Repeat_ADDRESS : VFB_READER_CTRL_Count_ADDRESS, reader_control_counter);
                    reader_control->writeUI(VFB_READER_CTRL_Status_ADDRESS, 0);
                #endif     
            } while (repeat);
#else       // Fields/frames cannot be repeated
            #if VFB_READER_RUNTIME_CONTROL
                reader_control_counter = reader_control->readUI(VFB_READER_CTRL_Count_ADDRESS);
                reader_control_counter = READER_CONTROL_COUNTER_AU.addUI(reader_control_counter, 1);
                reader_control->writeUI(VFB_READER_CTRL_Count_ADDRESS, reader_control_counter);
                reader_control->writeUI(VFB_READER_CTRL_Status_ADDRESS, 0);
            #endif
#endif
            HW_DEBUG_MSG("read_output_from_memory, switching to new frame, giving back a buffer token to write_input_to_memory" << std::endl);
        }
    }
#endif //SYNTH_MODE

    const char* param;
    SC_HAS_PROCESS(VFB_NAME);
    VFB_NAME(sc_module_name name_, 
             const char* PARAMETERISATION = "<frameBufferParams><VFB_NAME>MyFrameBuffer</VFB_NAME><VFB_MAX_WIDTH>640</VFB_MAX_WIDTH><VFB_MAX_HEIGHT>480</VFB_MAX_HEIGHT><VFB_BPS>8</VFB_BPS><VFB_CHANNELS_IN_SEQ>3</VFB_CHANNELS_IN_SEQ><VFB_CHANNELS_IN_PAR>1</VFB_CHANNELS_IN_PAR><VFB_WRITER_RUNTIME_CONTROL>0</VFB_WRITER_RUNTIME_CONTROL><VFB_DROP_FRAMES>1</VFB_DROP_FRAMES><VFB_READER_RUNTIME_CONTROL>0</VFB_READER_RUNTIME_CONTROL><VFB_REPEAT_FRAMES>1</VFB_REPEAT_FRAMES><VFB_FRAMEBUFFERS_ADDR>00000000</VFB_FRAMEBUFFERS_ADDR><VFB_MEM_PORT_WIDTH>64</VFB_MEM_PORT_WIDTH><VFB_MEM_MASTERS_USE_SEPARATE_CLOCK>0</VFB_MEM_MASTERS_USE_SEPARATE_CLOCK><VFB_RDATA_FIFO_DEPTH>64</VFB_RDATA_FIFO_DEPTH><VFB_RDATA_BURST_TARGET>32</VFB_RDATA_BURST_TARGET><VFB_WDATA_FIFO_DEPTH>64</VFB_WDATA_FIFO_DEPTH><VFB_WDATA_BURST_TARGET>32</VFB_WDATA_BURST_TARGET><VFB_MAX_NUMBER_PACKETS>1</VFB_MAX_NUMBER_PACKETS><VFB_MAX_SYMBOLS_IN_PACKET>10</VFB_MAX_SYMBOLS_IN_PACKET></frameBufferParams>") : sc_module(name_), param(PARAMETERISATION)
    {
        //! Data input stream and output stream
        din = new ALT_AVALON_ST_INPUT< sc_uint<VFB_BPS*VFB_CHANNELS_IN_PAR> >();
        dout = new ALT_AVALON_ST_OUTPUT< sc_uint<VFB_BPS*VFB_CHANNELS_IN_PAR> >();

        //! A couple of master ports, one for reading and one for writing
        read_master = new ALT_AVALON_MM_MASTER_FIFO<VFB_MEM_PORT_WIDTH, VFB_MEM_ADDR_WIDTH, VFB_READ_MASTER_MAX_BURST, VFB_BPS * VFB_CHANNELS_IN_PAR>();
        read_master->setWdataBurstSize(0);
        write_master = new ALT_AVALON_MM_MASTER_FIFO<VFB_MEM_PORT_WIDTH, VFB_MEM_ADDR_WIDTH, VFB_WRITE_MASTER_MAX_BURST, VFB_BPS * VFB_CHANNELS_IN_PAR>();
        write_master->setRdataBurstSize(0);

        //optional ports
        // Runtime control ports
        writer_control = NULL;
        reader_control = NULL;
       
#ifdef LEGACY_FLOW              
#if VFB_WRITER_RUNTIME_CONTROL
        writer_control = new ALT_AVALON_MM_MEM_SLAVE <VFB_WRITER_CTRL_INTERFACE_WIDTH, VFB_WRITER_CTRL_INTERFACE_DEPTH>();
        writer_control->setUseOwnClock(false);
#endif
#if VFB_READER_RUNTIME_CONTROL
        reader_control = new ALT_AVALON_MM_MEM_SLAVE <VFB_READER_CTRL_INTERFACE_WIDTH, VFB_READER_CTRL_INTERFACE_DEPTH>();
        reader_control->setUseOwnClock(false);
#endif
        read_master->setRdataBurstSize(VFB_RDATA_BURST_TARGET);
        write_master->setWdataBurstSize(VFB_WDATA_BURST_TARGET);
        read_master->setUseOwnClock(VFB_MEM_MASTERS_USE_SEPARATE_CLOCK);
        write_master->setUseOwnClock(VFB_MEM_MASTERS_USE_SEPARATE_CLOCK);
#else
        int bps=ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "frameBufferParams;VFB_BPS", 8);
        int par=ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "frameBufferParams;VFB_CHANNELS_IN_PAR",3);      
        din->setDataWidth(bps*par);
        dout->setDataWidth(bps*par);
        din->setSymbolsPerBeat(par);
        dout->setSymbolsPerBeat(par);
        din->enableEopSignals();
        dout->enableEopSignals();
        
        int mem_port_width = ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "frameBufferParams;VFB_MEM_PORT_WIDTH", 64);
        bool mastersUseSeparateClock = ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "frameBufferParams;VFB_MEM_MASTERS_USE_SEPARATE_CLOCK", 0);
        int read_burst_target = ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "frameBufferParams;VFB_RDATA_BURST_TARGET", 32);
        read_master->setDataWidth(mem_port_width);
        read_master->setUseOwnClock(mastersUseSeparateClock);
        read_master->setAddressWidth(VFB_MEM_ADDR_WIDTH);
        read_master->setRdataBurstSize(read_burst_target);
        read_master->enableReadPorts();  
        
        int write_burst_target = ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "frameBufferParams;VFB_WDATA_BURST_TARGET", 32);
        write_master->setDataWidth(mem_port_width);
        write_master->setUseOwnClock(mastersUseSeparateClock);
        write_master->setAddressWidth(VFB_MEM_ADDR_WIDTH);
        write_master->setWdataBurstSize(write_burst_target);
        write_master->enableWritePorts();
        
        bool writer_control_enabled = ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "frameBufferParams;VFB_WRITER_RUNTIME_CONTROL", false);
        bool reader_control_enabled = ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "frameBufferParams;VFB_READER_RUNTIME_CONTROL", false);
        if(writer_control_enabled){
            // Width and depth parameters are static
            writer_control = new ALT_AVALON_MM_MEM_SLAVE <VFB_WRITER_CTRL_INTERFACE_WIDTH, VFB_WRITER_CTRL_INTERFACE_DEPTH>();
            writer_control->setUseOwnClock(false);
        }
        if(reader_control_enabled){
            // Width and depth parameters are static
            reader_control = new ALT_AVALON_MM_MEM_SLAVE <VFB_READER_CTRL_INTERFACE_WIDTH, VFB_READER_CTRL_INTERFACE_DEPTH>();
            reader_control->setUseOwnClock(false);
        }
#endif
        
#ifdef SYNTH_MODE
        // These parameters do not need to be set until cusp generates 
        read_master->setRdataFifoDepth(VFB_RDATA_FIFO_DEPTH);
        read_master->setCmdFifoDepth(1);
        write_master->setWdataFifoDepth(VFB_WDATA_FIFO_DEPTH);
        write_master->setCmdFifoDepth(VFB_WDATA_CMD_FIFO_DEPTH);
        SC_THREAD(write_input_to_memory);
        SC_THREAD(read_output_from_memory);
#endif //SYNTH_MODE
    }
};
