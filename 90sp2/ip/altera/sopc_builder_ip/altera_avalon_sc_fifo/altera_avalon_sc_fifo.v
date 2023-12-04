// -----------------------------------------------------------
// Legal Notice: (C)2007 Altera Corporation. All rights reserved.  Your
// use of Altera Corporation's design tools, logic functions and other
// software and tools, and its AMPP partner logic functions, and any
// output files any of the foregoing (including device programming or
// simulation files), and any associated documentation or information are
// expressly subject to the terms and conditions of the Altera Program
// License Subscription Agreement or other applicable license agreement,
// including, without limitation, that your use is for the sole purpose
// of programming logic devices manufactured by Altera and sold by Altera
// or its authorized distributors.  Please refer to the applicable
// agreement for further details.
//
// Description: Single clock Avalon-ST FIFO with status information.
// -----------------------------------------------------------

`timescale 1 ns / 100 ps

module altera_avalon_sc_fifo(
    
    clk,
    reset_n,

    // sink
    in_data,
    in_valid,
    in_ready,
    in_startofpacket,
    in_endofpacket,
    in_empty,
    in_error,
    in_channel,

    // source
    out_data,
    out_valid,
    out_ready,
    out_startofpacket,
    out_endofpacket,
    out_empty,
    out_error,
    out_channel,

    // csr
    csr_address,
    csr_write,
    csr_read,
    csr_writedata,
    csr_readdata,

    // almost full stream
    almost_full_valid,
    almost_full_data,

    // almost empty stream
    almost_empty_valid,
    almost_empty_data

);

    // --------------------------------------------------
    // Parameters
    // --------------------------------------------------
    parameter SYMBOLS_PER_BEAT  = 1;
    parameter BITS_PER_SYMBOL   = 8;
    parameter FIFO_DEPTH        = 16;
    parameter CHANNEL_WIDTH     = 0;
    parameter ERROR_WIDTH       = 0;
    parameter USE_PACKETS       = 0;

    parameter USE_FILL_LEVEL      = 0;
    parameter STREAM_ALMOST_FULL  = 0;
    parameter STREAM_ALMOST_EMPTY = 0;
    parameter INITIAL_ALMOST_FULL_THRESHOLD  = 0;
    parameter INITIAL_ALMOST_EMPTY_THRESHOLD = 0;

    localparam DATA_WIDTH   = SYMBOLS_PER_BEAT * BITS_PER_SYMBOL;
    localparam ADDR_WIDTH   = log2ceil(FIFO_DEPTH);
    localparam DEPTH        = 2 ** ADDR_WIDTH;
    localparam EMPTY_WIDTH  = log2ceil(SYMBOLS_PER_BEAT);
    localparam PACKET_SIGNALS_WIDTH = 2 + EMPTY_WIDTH;
    localparam PAYLOAD_WIDTH        = (USE_PACKETS == 1) ? 
                                          2 + EMPTY_WIDTH + DATA_WIDTH + ERROR_WIDTH + CHANNEL_WIDTH:
                                          DATA_WIDTH + ERROR_WIDTH + CHANNEL_WIDTH;

    // --------------------------------------------------
    // Ports
    // --------------------------------------------------
    input clk;
    input reset_n;

    input [DATA_WIDTH - 1: 0] in_data;
    input in_valid;
    input in_startofpacket;
    input in_endofpacket;
    input [EMPTY_WIDTH - 1 : 0] in_empty;
    input [ERROR_WIDTH - 1 : 0] in_error;
    input [CHANNEL_WIDTH - 1: 0] in_channel;
    output in_ready;

    output [DATA_WIDTH - 1 : 0] out_data;
    output reg out_valid;
    output out_startofpacket;
    output out_endofpacket;
    output [EMPTY_WIDTH - 1 : 0] out_empty;
    output [ERROR_WIDTH - 1 : 0] out_error;
    output [CHANNEL_WIDTH - 1: 0] out_channel;
    input out_ready;

    input [1 : 0] csr_address;
    input csr_write;
    input csr_read;
    input [31 : 0] csr_writedata;
    output reg [31 : 0] csr_readdata;

    output reg almost_full_valid;
    output reg almost_full_data;
    output reg almost_empty_valid;
    output reg almost_empty_data;

    // --------------------------------------------------
    // Internal Signals
    // --------------------------------------------------
    reg [PAYLOAD_WIDTH - 1 : 0] mem [DEPTH - 1 : 0];
    reg [ADDR_WIDTH - 1 : 0] wr_ptr;
    reg [ADDR_WIDTH - 1 : 0] rd_ptr;

    wire [ADDR_WIDTH - 1 : 0] next_wr_ptr;
    wire [ADDR_WIDTH - 1 : 0] next_rd_ptr;
    wire [ADDR_WIDTH - 1 : 0] incremented_wr_ptr;
    wire [ADDR_WIDTH - 1 : 0] incremented_rd_ptr;

    wire [ADDR_WIDTH - 1 : 0] mem_rd_ptr;

    wire read;
    wire write;

    reg empty;
    reg next_empty;
    reg full;
    reg next_full;

    wire [PACKET_SIGNALS_WIDTH - 1 : 0] in_packet_signals;
    wire [PACKET_SIGNALS_WIDTH - 1 : 0] out_packet_signals;
    wire [PAYLOAD_WIDTH - 1 : 0] in_payload;
    reg  [PAYLOAD_WIDTH - 1 : 0] internal_out_payload;
    reg  [PAYLOAD_WIDTH - 1 : 0] out_payload;

    reg  internal_out_valid;
    wire internal_out_ready;

    reg  [ADDR_WIDTH : 0] fifo_fill_level;
    wire [ADDR_WIDTH : 0] fill_level;

    reg [23 : 0] almost_full_threshold;
    reg [23 : 0] almost_empty_threshold;

    // --------------------------------------------------
    // Define Payload
    //
    // Icky part where we decide which signals form the
    // payload to the FIFO with generate blocks.
    // --------------------------------------------------
    generate
        if (EMPTY_WIDTH > 0) begin
            assign in_packet_signals = {in_startofpacket, in_endofpacket, in_empty};
            assign {out_startofpacket, out_endofpacket, out_empty} = out_packet_signals;
        end 
        else begin
            assign in_packet_signals = {in_startofpacket, in_endofpacket};
            assign {out_startofpacket, out_endofpacket} = out_packet_signals;
        end
    endgenerate

    generate
        if (USE_PACKETS) begin
            if (ERROR_WIDTH > 0) begin
                if (CHANNEL_WIDTH > 0) begin
                    assign in_payload = {in_packet_signals, in_data, in_error, in_channel};
                    assign {out_packet_signals, out_data, out_error, out_channel} = out_payload;
                end
                else begin
                    assign in_payload = {in_packet_signals, in_data, in_error};
                    assign {out_packet_signals, out_data, out_error} = out_payload;
                end
            end
            else begin
                if (CHANNEL_WIDTH > 0) begin
                    assign in_payload = {in_packet_signals, in_data, in_channel};
                    assign {out_packet_signals, out_data, out_channel} = out_payload;
                end
                else begin
                    assign in_payload = {in_packet_signals, in_data};
                    assign {out_packet_signals, out_data} = out_payload;
                end
            end
        end
        else begin 
            if (ERROR_WIDTH > 0) begin
                if (CHANNEL_WIDTH > 0) begin
                    assign in_payload = {in_data, in_error, in_channel};
                    assign {out_data, out_error, out_channel} = out_payload;
                end
                else begin
                    assign in_payload = {in_data, in_error};
                    assign {out_data, out_error} = out_payload;
                end
            end
            else begin
                if (CHANNEL_WIDTH > 0) begin
                    assign in_payload = {in_data, in_channel};
                    assign {out_data, out_channel} = out_payload;
                end
                else begin
                    assign in_payload = in_data;
                    assign out_data = out_payload;
                end
            end
        end
    endgenerate

    // --------------------------------------------------
    // Memory
    //
    // To allow a ready latency of 0, the read index is 
    // obtained from the next read pointer and memory 
    // outputs are unregistered.
    // --------------------------------------------------
    always @(posedge clk) begin
        if (in_valid && in_ready)
            mem[wr_ptr] <= in_payload;

        internal_out_payload <= mem[mem_rd_ptr];
    end

    assign mem_rd_ptr = next_rd_ptr;

    // --------------------------------------------------
    // Pointer Management
    // --------------------------------------------------
    assign read = internal_out_ready && internal_out_valid;
    assign write = in_ready && in_valid;
    assign incremented_wr_ptr = wr_ptr + 1'b1;
    assign incremented_rd_ptr = rd_ptr + 1'b1;
    assign next_wr_ptr = (write) ? incremented_wr_ptr : wr_ptr;
    assign next_rd_ptr = (read) ? incremented_rd_ptr : rd_ptr;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
        end
        else begin
            wr_ptr <= next_wr_ptr;
            rd_ptr <= next_rd_ptr;
        end
    end

    // --------------------------------------------------
    // Status Management
    //
    // Generates the full and empty signals from the
    // pointers. The FIFO is full when the next write 
    // pointer will be equal to the read pointer after
    // a write. Reading from a FIFO clears full.
    //
    // The FIFO is empty when the next read pointer will
    // be equal to the write pointer after a read. Writing
    // to a FIFO clears empty.
    //
    // A simultaneous read and write must not change any of 
    // the empty or full flags.
    // --------------------------------------------------
    always @* begin
        next_full = full;
        next_empty = empty;

        if (read && !write) begin
            next_full = 1'b0;

            if (incremented_rd_ptr == wr_ptr)
                next_empty = 1'b1;
        end
        
        if (write && !read) begin
            next_empty = 1'b0;

            if (incremented_wr_ptr == rd_ptr)
                next_full = 1'b1;
        end
    end

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            empty <= 1;
            full <= 0;
        end
        else begin 
            empty <= next_empty;
            full <= next_full;
        end
    end

    // --------------------------------------------------
    // Avalon-ST Signals
    //
    // The in_ready signal is straightforward, but memory 
    // latency between a write and data being available on
    // the read side means that the out_valid signal
    // must be a delayed version of the empty signal.
    //
    // However, out_valid deassertions must not be
    // delayed or the FIFO will underflow.
    // --------------------------------------------------
    assign in_ready = !full;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n)
            internal_out_valid <= 0;
        else begin
            internal_out_valid <= !empty;

            if (read) begin
                if (incremented_rd_ptr == wr_ptr)
                    internal_out_valid <= 1'b0;
            end
        end
    end

    // --------------------------------------------------
    // Single Output Pipeline Stage
    //
    // The memory outputs are unregistered, so we have
    // to pipeline the output or fmax will drop like a
    // rock if someone puts combinatorial logic on the datapath.
    // 
    // This adds an extra cycle of latency to the FIFO.
    //
    // Q: Yes, so the Avalon-ST spec says that I have to register
    //    my outputs. But isn't the memory counted as a register?
    // A: The path from the address lookup to the memory output is
    //    slow. So in this case registering the outputs is a really
    //    good idea. Expecting you, dear engineer, to register your
    //    data inputs when using this FIFO seems lame.
    //
    // The registers get packed into the memory by the fitter
    // which means minimal resources are consumed. This output
    // stage acts as an extra slot in the FIFO, and complicates 
    // the fill level.
    // --------------------------------------------------
    assign internal_out_ready = out_ready || !out_valid;

    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            out_valid <= 0;
            out_payload <= 0;
        end
        else begin
            if (internal_out_ready) begin
                out_valid <= internal_out_valid;
                out_payload <= internal_out_payload;
            end
        end
    end

    // --------------------------------------------------
    // Fill Level & Space Available
    //
    // The fill level is calculated from the next write
    // and read pointers to avoid unnecessary latency.
    //
    // The fill level must account for the output stage, or
    // we'll always be off by one. Some applications need
    // such accurate fill levels, such as a bursting DMA
    // that wants to know the current fill level of the
    // FIFO before it issues a burst. Other applications
    // such as Ethernet just want to use this information
    // for flow control purposes and do not require an
    // exact fill level.
    //
    // For now, we'll always calculate the exact fill level
    // at the cost of an extra adder.
    // --------------------------------------------------
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) 
            fifo_fill_level <= 0;
        else if (next_full)
            fifo_fill_level <= DEPTH;
        else begin
            fifo_fill_level[ADDR_WIDTH] <= 1'b0;
            fifo_fill_level[ADDR_WIDTH - 1 : 0] <= next_wr_ptr - next_rd_ptr;
        end
    end

    assign fill_level = fifo_fill_level + {{ADDR_WIDTH{1'b0}}, out_valid};

    // --------------------------------------------------
    // Avalon-MM Status & Control Connection Point
    //
    // Register map:
    //
    // | Addr   | RW |     31-24  |    23 - 0                |
    // |  0     | R  | Reserved   |  Fill level              |
    // |  1     | R  |            Reserved                   |
    // |  2     | RW | Reserved   |  Almost full threshold   |
    // |  3     | RW | Reserved   |  Almost empty threshold  |
    //
    // The registering of this connection point means
    // that there is a cycle of latency between 
    // reads/writes and the updating of the fill level.
    // --------------------------------------------------
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            csr_readdata <= 0;
            almost_full_threshold <= INITIAL_ALMOST_FULL_THRESHOLD;
            almost_empty_threshold <= INITIAL_ALMOST_EMPTY_THRESHOLD;
        end
        else if (csr_read) begin
            csr_readdata <= 0;

            if (csr_address == 0) 
                csr_readdata[23 : 0] <= fill_level;
            else if (csr_address == 2)
                csr_readdata[23 : 0] <= almost_full_threshold;
            else if (csr_address == 3)
                csr_readdata[23 : 0] <= almost_empty_threshold;
        end
        else if (csr_write) begin
             if (csr_address == 2) 
                 almost_full_threshold <= csr_writedata[23 : 0];
             else if (csr_address == 3)
                 almost_empty_threshold <= csr_writedata[23 : 0];
        end
    end

    // --------------------------------------------------
    // Avalon ST Status Connection Points
    //
    // These ports produce a stream of almost full and
    // almost empty information, and are conditionally
    // generated based on parameters.
    //
    // Streaming the status information is useful for
    // low-level components such as MACs and schedulers
    // because it allows them to make scheduling decisions 
    // based on the current FIFO status.
    // --------------------------------------------------
    generate 
        if (STREAM_ALMOST_FULL) begin
            always @(posedge clk or negedge reset_n) begin
                if (!reset_n) begin
                    almost_full_valid <= 0;
                    almost_full_data <= 0;
                end
                else begin
                    almost_full_valid <= 1'b1;
                    almost_full_data <= (fill_level >= almost_full_threshold);
                end
            end
        end

        if (STREAM_ALMOST_EMPTY) begin
            always @(posedge clk or negedge reset_n) begin
                if (!reset_n) begin
                    almost_empty_valid <= 0;
                    almost_empty_data <= 0;
                end
                else begin
                    almost_empty_valid <= 1'b1;
                    almost_empty_data <= (fill_level <= almost_empty_threshold);
                end
            end
        end
    endgenerate

    // --------------------------------------------------
    // Calculates the log2ceil of the input value
    // --------------------------------------------------
    function integer log2ceil;
        input integer val;
        integer i;

        begin
            i = 1;
            log2ceil = 0;

            while (i < val) begin
                log2ceil = log2ceil + 1;
                i = i << 1; 
            end
        end
    endfunction

endmodule
