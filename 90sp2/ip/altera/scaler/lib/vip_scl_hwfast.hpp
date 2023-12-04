#define MIN_FRAME_SIZE 32 
//! \file vip_scl_hwfast.hpp
//!
//! \author aharding
//!
//! \brief Synthesisable Scaler core.
//! A Scaler core that
//! can be parameterised and then synthesised with CusP.
// Prevents CusP 7.1 from sequencing IO on separate ports i.e. behave as it used to
#pragma cusp_config createSeparateSeqSpaceForEachIOFU = yes
// Stop Cusp from wasting lots of time trying to analyse the contents of line buffers
#pragma cusp_config maximumRepeatForInitialisation = 100
// Stop Cusp from thinking that initialising a large coefficient array is going
// to require the insertion of registered muxes
#pragma cusp_config maxMuxSize = 64
#pragma cusp_config registerToExtendLifetime = no
#pragma cusp_config errorOnEnableThreadConflict = no

#ifndef __CUSP__
 #include <alt_cusp.h>
#endif // n__CUSP__

#include "vip_constants.h"
#include "vip_common.h"

#ifndef LEGACY_FLOW
 #undef SCL_NAME
 #define SCL_NAME alt_vip_scl
#endif

#define SOME_WIDTH 64

// Aliases to handle signed/unsigned coefficients
#if SCL_PRECISION_H_SIGNED
 #define H_COEFF_TYPE sc_int<SCL_COEFFICIENTS_H_BITS>
 #define H_COEFF_MUX_LD muxLdSI
 #define H_TREE_TYPE sc_int
 #define H_TREE_ADD addSI
 #define H_TREE_MUX_LD muxLdSI
 #define H_TREE_MUX_CLD mCLdSI
 #define H_TREE_CLD cLdSI
 #define H_TREE_MULT multSI
#else
 #define H_COEFF_TYPE sc_uint<SCL_COEFFICIENTS_H_BITS>
 #define H_COEFF_MUX_LD muxLdUI
 #define H_TREE_TYPE sc_uint
 #define H_TREE_ADD addUI
 #define H_TREE_MUX_LD muxLdUI
 #define H_TREE_MUX_CLD mCLdUI
 #define H_TREE_CLD cLdUI
 #define H_TREE_MULT multUI
#endif

#if SCL_PRECISION_V_SIGNED
 #define V_COEFF_TYPE sc_int<SCL_COEFFICIENTS_V_BITS>
 #define V_COEFF_MUX_LD muxLdSI
 #define V_TREE_TYPE sc_int
 #define V_TREE_ADD addSI
 #define V_TREE_MUX_LD muxLdSI
 #define V_TREE_MULT multSI
#else
 #define V_COEFF_TYPE sc_uint<SCL_COEFFICIENTS_V_BITS>
 #define V_COEFF_MUX_LD muxLdUI
 #define V_TREE_TYPE sc_uint
 #define V_TREE_ADD addUI
 #define V_TREE_MUX_LD muxLdUI
 #define V_TREE_MULT multUI
#endif

// Bit widths that are common across all modes
#define LARGER_I_BITS (MAX(LOG2G_OUT_WIDTH, LOG2G_IN_WIDTH)+1)
#define SMALLER_I_BITS (MIN(LOG2G_OUT_WIDTH, LOG2G_IN_WIDTH)+1)
#define LARGER_J_BITS (MAX(LOG2G_OUT_HEIGHT, LOG2G_IN_HEIGHT)+1)
#define SMALLER_J_BITS (MIN(LOG2G_OUT_HEIGHT, LOG2G_IN_HEIGHT)+1)
#define I_BITS LARGER_I_BITS
#define J_BITS LARGER_J_BITS
#define ERROR_I_BITS (MAX(LOG2G_GCD_OUT_WIDTH, LOG2G_GCD_IN_WIDTH)+1)
#define ERROR_J_BITS (MAX(LOG2G_GCD_OUT_HEIGHT, LOG2G_GCD_IN_HEIGHT)+1)
#define WRITE_POS_BITS LOG2G_IN_WIDTH
#define COEFF_I_BITS SCL_PRECISION_H_FRACTION_BITS
#define ERROR_COEFF_I_BITS ERROR_I_BITS
#define COEFF_J_BITS (SCL_PRECISION_V_FRACTION_BITS)
#define ERROR_COEFF_J_BITS ERROR_J_BITS
#define COEFF_I_J_BITS (COEFF_I_BITS + COEFF_J_BITS)
#define DIVISION_COUNTER_BITS MAX(LARGER_I_BITS, LARGER_J_BITS)
#define V_COEFF_POS_BITS SCL_ALGORITHM_LOG2_V_PHASES
#define V_COEFF_ACCESS_BITS (V_COEFF_POS_BITS+SCL_COEFFICIENTS_LOG2_V_BANKS_TAPS)

#define CHANNEL_WIDTH (SCL_BPS * SCL_CHANNELS_IN_PAR)
#define HAS_CONTROL_PORT (SCL_COEFFICIENTS_LOAD_AT_RUNTIME || SCL_RUNTIME_CONTROL)

#if SCL_COEFFICIENTS_H_COEFFS_ARE_SYMMETRIC == 1
 #define REAL_N_H_COEFFICIENT_SETS (SCL_ALGORITHM_H_PHASES/2+1)
 #define MULT_BY_N_H_COEFFS(X) (((X) << (SCL_ALGORITHM_LOG2_H_PHASES-1)) + (X))
 #else
 #define REAL_N_H_COEFFICIENT_SETS SCL_ALGORITHM_H_PHASES
 #define MULT_BY_N_H_COEFFS(X) ((X) << SCL_ALGORITHM_LOG2_H_PHASES)
 #endif
 #if SCL_COEFFICIENTS_V_COEFFS_ARE_SYMMETRIC || (SCL_COEFFICIENTS_COEFF_ARRAYS_IDENTICAL && SCL_COEFFICIENTS_H_COEFFS_ARE_SYMMETRIC)
 #define REAL_N_V_COEFFICIENT_SETS (SCL_ALGORITHM_V_PHASES/2+1)
 #define MULT_BY_N_V_COEFFS(X) (((X) << (SCL_ALGORITHM_LOG2_V_PHASES-1)) + (X))
 #else
 #define REAL_N_V_COEFFICIENT_SETS SCL_ALGORITHM_V_PHASES
 #define MULT_BY_N_V_COEFFS(X) ((X) << SCL_ALGORITHM_LOG2_V_PHASES)
 #endif

//! Perform Scaling on a complete frame.
//!
//! <b>Compile Time Configuration in IP Toolbench</b>
//!
//! These are the same as the IP user parameters defined by the
//! \link ::SCL_SW(sc_uint<SCL_BPS>*,sc_uint<SCL_BPS>*) software model \endlink.
//! \ingroup HWCores
SC_MODULE(SCL_NAME)
{
#ifndef LEGACY_FLOW
    static const char * get_entity_helper_class(void)
    {
        return "ip_toolbench/scaler.jar?com.altera.vip.entityinterfaces.helpers.SclEntityHelper";
    }

    static const char * get_display_name(void)
    {
        return "Scaler";
    }

    static const char * get_certifications(void)
    {
        return "SOPC_BUILDER_READY";
    }

    static const char * get_description(void)
    {
        return "The Scaler provides a means to resize video streams using nearest neighbor, bilinear, bicubic, or polyphase scaling algorithms.";
    }

    static const char * get_product_ids(void)
    {
        return "00B7";
    }

#include "vip_elementclass_info.h"
#else
    static const char * get_entity_helper_class(void)
    {
        return "default";
    }
#endif //LEGACY_FLOW

#ifndef SYNTH_MODE
#define CHANNEL_WIDTH 64 
#define CTRL_INTERFACE_WIDTH 32
#define CTRL_INTERFACE_DEPTH 1000    
#endif
    
    //! Input port
    ALT_AVALON_ST_INPUT< sc_uint<CHANNEL_WIDTH > >* din ALT_CUSP_DISABLE_NUMBER_SUFFIX;
    //! Output port
    ALT_AVALON_ST_OUTPUT< sc_uint<CHANNEL_WIDTH > >* dout ALT_CUSP_DISABLE_NUMBER_SUFFIX;
    
    ALT_AVALON_MM_RAW_SLAVE <CTRL_INTERFACE_WIDTH, CTRL_INTERFACE_DEPTH>* control ALT_CUSP_DISABLE_NUMBER_SUFFIX;
    
#ifdef SYNTH_MODE

#if HAS_CONTROL_PORT
    ALT_REG<1> go_REG ALT_BIND_SEQ_SPACE("avSlaveSequenceSpace0");
    ALT_REG<1> running_REG ALT_BIND_SEQ_SPACE("avSlaveSequenceSpace1");
    sc_int<1> go BIND(go_REG);
    sc_int<1> running BIND(running_REG);

    sc_event goChanged;

    void controlMonitor()
    {
        bool isRead;
        sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS> address;

#if SCL_COEFFICIENTS_LOAD_AT_RUNTIME

        ALT_REG < SCL_COEFFICIENTS_H_BITS> h_write_data_REG[SCL_ALGORITHM_H_TAPS];
        ALT_REG < SCL_COEFFICIENTS_V_BITS> v_write_data_REG[SCL_ALGORITHM_V_TAPS];
        sc_int < SCL_COEFFICIENTS_H_BITS> h_write_data[SCL_ALGORITHM_H_TAPS] BIND(h_write_data_REG);
        sc_int < SCL_COEFFICIENTS_V_BITS> v_write_data[SCL_ALGORITHM_V_TAPS] BIND(v_write_data_REG);
#endif

        // Initialise GO to 0
        go = 0;
        for (;;)
        {
            isRead = control->isReadAccess();
            address = control->getAddress();
            if (isRead)
            {
                // The only address we service for reads is address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_Status_ADDRESS)
                // so always return running
                control->returnReadData(running);
            }
            else
            {
                long thisRead = control->getWriteData();

                if (address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_GO_ADDRESS))
                {
                    go = thisRead;
                    notify(goChanged);
                }
#if SCL_RUNTIME_CONTROL
                if (address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_OUT_WIDTH_ADDRESS))
                {
                    raw_out_width = thisRead;
                }
                if (address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_OUT_HEIGHT_ADDRESS))
                {
                    raw_out_height = thisRead;
                }
#endif // SCL_RUNTIME_CONTROL
#if SCL_COEFFICIENTS_LOAD_AT_RUNTIME
                if (address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_H_READ_BANK_ADDRESS))
                {
                    raw_h_read_bank_offset = MULT_BY_N_H_COEFFS(thisRead);
                }
                if (address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_H_WRITE_BANK_ADDRESS))
                {
                    h_write_bank_offset = MULT_BY_N_H_COEFFS(thisRead);
                }
#if !SCL_COEFFICIENTS_COEFF_ARRAYS_IDENTICAL                
                if (address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_V_READ_BANK_ADDRESS))
                {
                    raw_v_read_bank_offset = MULT_BY_N_V_COEFFS(thisRead);
                }
                if (address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_V_WRITE_BANK_ADDRESS))
                {
                    v_write_bank_offset = MULT_BY_N_V_COEFFS(thisRead);
                }
                bool isVPhase = address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_V_PHASE_ADDRESS);
#endif //!SCL_COEFFICIENTS_COEFF_ARRAYS_IDENTICAL
                bool isHPhase = address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_H_PHASE_ADDRESS);

                if (isHPhase && (!SCL_COEFFICIENTS_H_COEFFS_ARE_SYMMETRIC || thisRead < (SCL_ALGORITHM_H_PHASES/2 + 1)))
                {
                    sc_bigint < SCL_COEFFICIENTS_H_BITS*SCL_ALGORITHM_H_TAPS > write_data BIND(ALT_WIRE);

                    for (int i = 0; i < SCL_ALGORITHM_H_TAPS; i++)
                    {
                        ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                        write_data = (H_COEFF_TYPE(h_write_data[i]), write_data.range((SCL_COEFFICIENTS_H_BITS * SCL_ALGORITHM_H_TAPS) - 1, SCL_COEFFICIENTS_H_BITS));
                    }
                    assert((int)h_write_bank_offset + thisRead < REAL_N_H_COEFFICIENT_SETS*SCL_COEFFICIENTS_H_BANKS);
                    h_coeffs[h_write_bank_offset + sc_int<CTRL_INTERFACE_WIDTH>(thisRead)] = write_data;
                }
#if !SCL_COEFFICIENTS_COEFF_ARRAYS_IDENTICAL                
                if (isVPhase && (!SCL_COEFFICIENTS_V_COEFFS_ARE_SYMMETRIC || thisRead < (SCL_ALGORITHM_V_PHASES/2 + 1)))
                {
                    long address = v_write_bank_offset + sc_int<CTRL_INTERFACE_WIDTH>(thisRead);
                    for (int i = 0; i < SCL_ALGORITHM_V_TAPS; i++)
                    {
                        ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                        assert((int)address < REAL_N_V_COEFFICIENT_SETS*SCL_ALGORITHM_V_TAPS*SCL_COEFFICIENTS_V_BANKS);
                        v_coeffs[address] = v_write_data[i];
                        address += MULT_BY_N_V_COEFFS(SCL_COEFFICIENTS_V_BANKS);
                    }
                }

                for (int i = 0; i < SCL_ALGORITHM_V_TAPS; i++)
                {
                    ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                    v_write_data[i] = v_write_data_REG[i].cLdSI(thisRead, v_write_data[i], address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_V_TAPS_ADDRESS + i));
                }
#endif //!SCL_COEFFICIENTS_COEFF_ARRAYS_IDENTICAL
                for (int i = 0; i < SCL_ALGORITHM_H_TAPS; i++)
                {
                    ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                    h_write_data[i] = h_write_data_REG[i].cLdSI(thisRead, h_write_data[i], address == sc_uint<SCL_COEFFICIENTS_RUNTIME_ADDRESS_BITS>(CTRL_H_TAPS_ADDRESS + i));
                }

#endif // SCL_COEFFICIENTS_LOAD_AT_RUNTIME

            }
        }
    }

#endif
#if SCL_COEFFICIENTS_LOAD_AT_RUNTIME

    // Register files are made to have 1 read, 1 write port instead of 2 w/r ports. Everything else is as default
    ALT_REGISTER_FILE < -1, 2, 1, -1, 1, 1, 0, ALT_MEM_MODE_AUTO > h_coeffs_REG_FILE;

    ALT_REGISTER_FILE < -1, 2, 1, -1, 1, 1, 0, ALT_MEM_MODE_AUTO > v_coeffs_REG_FILE;

    sc_bigint<SCL_COEFFICIENTS_H_BITS*SCL_ALGORITHM_H_TAPS> h_coeffs[REAL_N_H_COEFFICIENT_SETS*SCL_COEFFICIENTS_H_BANKS] BIND(h_coeffs_REG_FILE);

    V_COEFF_TYPE v_coeffs[REAL_N_V_COEFFICIENT_SETS*SCL_ALGORITHM_V_TAPS*SCL_COEFFICIENTS_V_BANKS] BIND(v_coeffs_REG_FILE);
    sc_uint<SCL_COEFFICIENTS_V_BANK_OFFSET_BITS> v_write_bank_offset;
    sc_uint<SCL_COEFFICIENTS_H_BANK_OFFSET_BITS> h_write_bank_offset;
    sc_uint<SCL_COEFFICIENTS_V_BANK_OFFSET_BITS> raw_v_read_bank_offset;
    sc_uint<SCL_COEFFICIENTS_H_BANK_OFFSET_BITS> raw_h_read_bank_offset;
#endif

    sc_uint<SCL_COEFFICIENTS_H_BANK_OFFSET_BITS> h_read_bank_offset;
    sc_uint<SCL_COEFFICIENTS_V_BANK_OFFSET_BITS> v_read_bank_offset;

#if SCL_RUNTIME_CONTROL
    // As well as the interface itself, create a bunch of registers to hold the control data
    // and calculate derived values
    sc_uint<LOG2G_IN_WIDTH> in_width;
    sc_uint<LOG2G_IN_HEIGHT> in_height;
    sc_uint<LOG2G_OUT_WIDTH> out_width;
    sc_uint<LOG2G_OUT_HEIGHT> out_height;

    // These are the values direct from the raw slave/control packet. They are read once per frame.
    sc_uint<LOG2G_OUT_WIDTH> raw_out_width;
    sc_uint<LOG2G_OUT_HEIGHT> raw_out_height;

    // And some derived values that will be used by all modes
    bool is_scaling_up_h;
    bool is_scaling_up_v;

    // The number of iterations, and the initial values for the loop counters
    // (the counters count down and sometimes get divided by 2 for mod scheduling
    // reasons)
    sc_int<I_BITS> i_iterations;
    sc_int<I_BITS> i_iterations_init;
    sc_int<J_BITS> j_iterations;
    sc_int<J_BITS> j_iterations_init;

    // For tracking cumulative error which decides when to move the kernel
    // over the image and when to read/write
    sc_int<ERROR_I_BITS> error_i_increment;
    DECLARE_VAR_WITH_AU(sc_int<ERROR_I_BITS>, ERROR_I_BITS, error_i_init);
    sc_int<ERROR_I_BITS> corrected_error_i_increment;

    sc_int<ERROR_J_BITS> error_j_increment;
    DECLARE_VAR_WITH_AU(sc_int<ERROR_J_BITS>, ERROR_J_BITS, error_j_init);
    sc_int<ERROR_J_BITS> corrected_error_j_increment;

    // For tracking cumulative error which decides how the coefficients
    // change with kernel movement
    sc_int<ERROR_I_BITS> error_coeff_i_increment;
    sc_int<ERROR_I_BITS> corrected_error_coeff_i_increment;
    sc_int<ERROR_J_BITS> error_coeff_j_increment;
    sc_int<ERROR_J_BITS> corrected_error_coeff_j_increment;
    // For actually updating the coefficients
    sc_uint<COEFF_I_BITS> coeff_i_increment;
    sc_uint<COEFF_I_BITS> coeff_i_increment_plus_1;
    sc_uint<COEFF_I_BITS> coeff_i_nearly_overflow_val;
    bool coeff_i_increment_non_zero;
    sc_uint<COEFF_J_BITS> coeff_j_increment;
    sc_uint<COEFF_J_BITS> coeff_j_increment_plus_1;

    sc_uint<LOG2G_IN_WIDTH> in_width_minus_1;

#define INTERNAL_IN_WIDTH in_width
#define INTERNAL_IN_HEIGHT in_height
#define INTERNAL_OUT_WIDTH out_width
#define INTERNAL_OUT_HEIGHT out_height

#define IS_SCALING_UP_H is_scaling_up_h
#define IS_SCALING_UP_V is_scaling_up_v

#define I_ITERATIONS i_iterations
#define I_ITERATIONS_INIT i_iterations_init
#define J_ITERATIONS j_iterations
#define J_ITERATIONS_INIT j_iterations_init

#define ERROR_I_INCREMENT error_i_increment
#define ERROR_I_INIT error_i_init
#define CORRECTED_ERROR_I_INCREMENT corrected_error_i_increment

#define ERROR_J_INCREMENT error_j_increment
#define ERROR_J_INIT error_j_init
#define CORRECTED_ERROR_J_INCREMENT corrected_error_j_increment

    // Only apply to linear and cubic modes
#define ERROR_COEFF_I_THRESHOLD ERROR_I_THRESHOLD
 #define ERROR_COEFF_I_INCREMENT error_coeff_i_increment
 #define CORRECTED_ERROR_COEFF_I_INCREMENT corrected_error_coeff_i_increment
 #define COEFF_I_INCREMENT coeff_i_increment
#define COEFF_I_INCREMENT_PLUS_1 coeff_i_increment_plus_1
#define COEFF_I_NEARLY_OVERFLOW_VAL coeff_i_nearly_overflow_val
#define COEFF_I_INCREMENT_NON_ZERO coeff_i_increment_non_zero

#define ERROR_COEFF_J_THRESHOLD ERROR_J_THRESHOLD
#define ERROR_COEFF_J_INCREMENT error_coeff_j_increment
#define CORRECTED_ERROR_COEFF_J_INCREMENT corrected_error_coeff_j_increment
#define COEFF_J_INCREMENT coeff_j_increment
#define COEFF_J_INCREMENT_PLUS_1 coeff_j_increment_plus_1
#define IN_WIDTH_MINUS_1 in_width_minus_1

#else // SCL_RUNTIME_CONTROL

#define INTERNAL_IN_WIDTH SCL_IN_WIDTH
#define INTERNAL_IN_HEIGHT SCL_IN_HEIGHT
#define INTERNAL_OUT_WIDTH SCL_OUT_WIDTH
#define INTERNAL_OUT_HEIGHT SCL_OUT_HEIGHT

#define IS_SCALING_UP_H (SCL_IN_WIDTH < SCL_OUT_WIDTH)
#define IS_SCALING_UP_V (SCL_IN_HEIGHT < SCL_OUT_HEIGHT)

#define I_ITERATIONS MAX(SCL_OUT_WIDTH, SCL_IN_WIDTH)
#define I_ITERATIONS_INIT (I_ITERATIONS/STEP_ITER - 1)
#define J_ITERATIONS MAX(SCL_IN_HEIGHT, SCL_OUT_HEIGHT)

#if SCL_ALGORITHM_NAME == POLYPHASE || SCL_ALGORITHM_NAME == BICUBIC
#define J_ITERATIONS_INIT (J_ITERATIONS -1 + (SCL_ALGORITHM_V_TAPS - 1 - SCL_ALGORITHM_KERNEL_Y))
#else
#define J_ITERATIONS_INIT (J_ITERATIONS-1)
#endif

#define ERROR_I_THRESHOLD MAX(GCD_OUT_WIDTH, GCD_IN_WIDTH)
 #define ERROR_I_INCREMENT MIN(GCD_OUT_WIDTH, GCD_IN_WIDTH)
 #define CORRECTED_ERROR_I_INCREMENT (ERROR_I_INCREMENT - ERROR_I_THRESHOLD)

#define ERROR_J_THRESHOLD MAX(GCD_OUT_HEIGHT, GCD_IN_HEIGHT)
 #define ERROR_J_INCREMENT MIN(GCD_OUT_HEIGHT, GCD_IN_HEIGHT)
 #define CORRECTED_ERROR_J_INCREMENT (ERROR_J_INCREMENT - ERROR_J_THRESHOLD)

#if IS_SCALING_UP_H
#if SCL_ALGORITHM_NAME == NEAREST_NEIGHBOUR
#define ERROR_I_INIT ((-1 - ERROR_I_INCREMENT)>>1)
#else
#define ERROR_I_INIT -1
#endif // Interpolation modes
#else // IS_SCALING_UP_H
#if SCL_ALGORITHM_NAME == NEAREST_NEIGHBOUR
#define ERROR_I_INIT ((ERROR_I_THRESHOLD/2) - ERROR_I_INCREMENT)
#else
#define ERROR_I_INIT -ERROR_I_INCREMENT
#endif // Interpolation modes
#endif

#if IS_SCALING_UP_V
#if SCL_ALGORITHM_NAME == NEAREST_NEIGHBOUR
#define ERROR_J_INIT ((-1 - ERROR_J_INCREMENT)>>1)
#else
#define ERROR_J_INIT -1
#endif // Interpolation modes
#else // IS_SCALING_UP_H
#if SCL_ALGORITHM_NAME == NEAREST_NEIGHBOUR
#define ERROR_J_INIT ((ERROR_J_THRESHOLD/2) - ERROR_J_INCREMENT)
#else
#define ERROR_J_INIT -ERROR_J_INCREMENT
#endif // Interpolation modes
#endif

    // Only apply to linear and cubic modes
#define ERROR_COEFF_I_THRESHOLD ERROR_I_THRESHOLD
#define ERROR_COEFF_J_THRESHOLD ERROR_J_THRESHOLD
#if IS_SCALING_UP_H
#define ERROR_COEFF_I_INCREMENT ((GCD_IN_WIDTH << SCL_ALGORITHM_LOG2_H_PHASES) % ERROR_COEFF_I_THRESHOLD)
#define COEFF_I_INCREMENT ((GCD_IN_WIDTH << SCL_ALGORITHM_LOG2_H_PHASES) / ERROR_COEFF_I_THRESHOLD)
#else

#define ERROR_COEFF_I_INCREMENT (((GCD_IN_WIDTH - GCD_OUT_WIDTH) << SCL_ALGORITHM_LOG2_H_PHASES) % ERROR_COEFF_I_THRESHOLD)
#define COEFF_I_INCREMENT (((GCD_IN_WIDTH - GCD_OUT_WIDTH) << SCL_ALGORITHM_LOG2_H_PHASES) / ERROR_COEFF_I_THRESHOLD)
#endif

#if IS_SCALING_UP_V
#define ERROR_COEFF_J_INCREMENT ((GCD_IN_HEIGHT << SCL_ALGORITHM_LOG2_V_PHASES) % ERROR_COEFF_J_THRESHOLD)
#define COEFF_J_INCREMENT ((GCD_IN_HEIGHT << SCL_ALGORITHM_LOG2_V_PHASES) / ERROR_COEFF_J_THRESHOLD)
#else

#define ERROR_COEFF_J_INCREMENT (((GCD_IN_HEIGHT - GCD_OUT_HEIGHT) << SCL_ALGORITHM_LOG2_V_PHASES) % ERROR_COEFF_J_THRESHOLD)
#define COEFF_J_INCREMENT (((GCD_IN_HEIGHT - GCD_OUT_HEIGHT) << SCL_ALGORITHM_LOG2_V_PHASES) / ERROR_COEFF_J_THRESHOLD)
#endif


#define CORRECTED_ERROR_COEFF_I_INCREMENT (ERROR_COEFF_I_INCREMENT - ERROR_COEFF_I_THRESHOLD)
#define COEFF_I_INCREMENT_PLUS_1 (COEFF_I_INCREMENT + 1)
#define COEFF_I_NEARLY_OVERFLOW_VAL (SCL_ALGORITHM_MAX_I_COEFF - COEFF_I_INCREMENT - 1)
#define COEFF_I_INCREMENT_NON_ZERO (COEFF_I_INCREMENT != 0)

#define CORRECTED_ERROR_COEFF_J_INCREMENT (ERROR_COEFF_J_INCREMENT - ERROR_COEFF_J_THRESHOLD)
#define COEFF_J_INCREMENT_PLUS_1 (COEFF_J_INCREMENT + 1)
#define IN_WIDTH_MINUS_1 (SCL_IN_WIDTH - 1)
#endif

    // A counter that we use everywhere for unrolled loops
    unsigned int cpy_counter;

#define PACKET_BPS SCL_BPS
#define PACKET_CHANNELS_IN_PAR SCL_CHANNELS_IN_PAR
#define PACKET_HEADER_TYPE_VAR headerType
#define PACKET_JUST_READ_VAR justRead
#define PACKET_WIDTH_VAR raw_in_width
#define PACKET_HEIGHT_VAR raw_in_height
#define PACKET_INTERLACING_VAR interlacingFlag
#include "vip_packet_reader.hpp"

    void write_corrected_control_packet()
    {
        // Store the outputs in a shift register to abstract away
        // the fact that they could be written out in parallel or
        // sequence
        ALT_REG < HEADER_WORD_BITS > output_REG[9];
        sc_uint < HEADER_WORD_BITS > output[9] BIND(output_REG);
        sc_uint < HEADER_WORD_BITS * 4 > widthOrHeight;
        static const int N_HEADER_WORDS_TO_SEND = 9;
        HW_DEBUG_MSG("Sending corrected control packet" << std::endl);

        // The type
        dout->write(CONTROL_HEADER);

        // The width
        widthOrHeight = INTERNAL_OUT_WIDTH;
        for (int i = 0; i < 4; i++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            output[i] = widthOrHeight.range(HEADER_WORD_BITS * (4 - i) - 1, HEADER_WORD_BITS * (3 - i));
        }

        // The height
        widthOrHeight = INTERNAL_OUT_HEIGHT;
        for (int i = 0; i < 4; i++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            output[4 + i] = widthOrHeight.range(HEADER_WORD_BITS * (4 - i) - 1, HEADER_WORD_BITS * (3 - i));
        }

        // Interlacing
        output[8] = interlacingFlag;

        // Write out the control packet, packing into wide words for symbols in parallel. If the two
        // do not divide exactly, round up and send an extra word with whatever happens to be in the
        // right place.
        for (int i = 0; i < (N_HEADER_WORDS_TO_SEND + SCL_CHANNELS_IN_PAR - 1) / SCL_CHANNELS_IN_PAR; i++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);

            sc_uint< SCL_BPS*SCL_CHANNELS_IN_PAR> thisOutput BIND(ALT_WIRE);
            thisOutput = 0;
            // Pack a word to write out. If the last word doesn't full fill the word, wrap
            // around and write again from the front
            for (int j = SCL_CHANNELS_IN_PAR - 1; j >= 0; j--)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                thisOutput <<= SCL_BPS;
                thisOutput = thisOutput | output[j];
            }

            // Shift the words to write along
            for (int j = 0; j < N_HEADER_WORDS_TO_SEND - SCL_CHANNELS_IN_PAR; j++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                output[j] = output[j + SCL_CHANNELS_IN_PAR];
            }

            dout->writeDataAndEop(thisOutput, i == (N_HEADER_WORDS_TO_SEND + SCL_CHANNELS_IN_PAR - 1) / SCL_CHANNELS_IN_PAR - 1);
        }

        dout->setEndPacket(false);

    }

    void behaviour()
    {
        // Main loop
        for (;;)
        {
            handleNonImagePackets();

            // Between each frame read the run-time parameters
#if HAS_CONTROL_PORT
            // Write the running bit
            running = 0;
            control->notifyEvent();
#ifndef __CUSP__

            wait(0, SC_NS);
#endif // __CUSP__
            // Check the go bit before starting to read
            while (!go)
                wait(goChanged);
#endif

#if SCL_RUNTIME_CONTROL

            read_control_data();
#endif
#if SCL_COEFFICIENTS_LOAD_AT_RUNTIME

            h_read_bank_offset = raw_h_read_bank_offset;
            v_read_bank_offset = raw_v_read_bank_offset;
#endif

#if HAS_CONTROL_PORT
            // Write the running bit
            running = 1;
            control->notifyEvent();
#ifndef __CUSP__

            wait(0, SC_NS);
#endif // __CUSP__
#endif

            write_corrected_control_packet();

            // The type for the image data that follows
            dout->write(IMAGE_DATA);

#if SCL_ALGORITHM_NAME == BILINEAR

            scale_frame_linear_i();
#elif SCL_ALGORITHM_NAME == NEAREST_NEIGHBOUR

            scale_frame_no_i();
#else

            scale_multitap();
#endif

            if (!din->getEndPacket())
            {
                HW_DEBUG_MSG("did not get the expected eop, discarding extra data" << std::endl);
            }
            // Discard the data from the final read because it will be left on the input
            din->read();
            // Discard any extra data after we had expected EOP
            while (!din->getEndPacket())
            {
                din->read();
            }

            // Finally, switch off endPacket, ready for the next packet out
            dout->setEndPacket(false);
        }
    }
    void read_control_data()
    {
#if SCL_RUNTIME_CONTROL
        const unsigned int ERROR_INIT_AU_BITS = MAX(ERROR_I_BITS, ERROR_J_BITS);
        ALT_AU<ERROR_INIT_AU_BITS> error_init1_AU, error_init2_AU;
        DECLARE_VAR_WITH_AU(sc_int<LARGER_I_BITS>, LARGER_I_BITS, larger_i);
        DECLARE_VAR_WITH_AU(sc_int<SMALLER_I_BITS>, SMALLER_I_BITS, smaller_i);
        DECLARE_VAR_WITH_AU(sc_int<LARGER_J_BITS>, LARGER_J_BITS, larger_j);
        DECLARE_VAR_WITH_AU(sc_int<SMALLER_J_BITS>, SMALLER_J_BITS, smaller_j);
        bool is_scaling_up_h_0_latency BIND(ALT_WIRE);
        bool is_scaling_up_v_0_latency BIND(ALT_WIRE);

        // Copy data direct from raw slave to registers to use during the next frame
        in_width = raw_in_width;
        in_height = raw_in_height;
        out_width = raw_out_width;
        out_height = raw_out_height;

        // Figure out which way we're scaling and only mux once per measure
        is_scaling_up_h_0_latency = in_width < out_width;
        is_scaling_up_v_0_latency = in_height < out_height;
        is_scaling_up_h = is_scaling_up_h_0_latency;
        is_scaling_up_v = is_scaling_up_v_0_latency;

        larger_i = larger_i_AU.muxLdUI(in_width, out_width, is_scaling_up_h_0_latency);
        smaller_i = smaller_i_AU.muxLdUI(in_width, out_width, !is_scaling_up_h_0_latency);
        larger_j = larger_j_AU.muxLdUI(in_height, out_height, is_scaling_up_v_0_latency);
        smaller_j = smaller_j_AU.muxLdUI(in_height, out_height, !is_scaling_up_v_0_latency);

        // Derive some parameters
        i_iterations = larger_i;
        i_iterations_init = (larger_i >> (STEP_ITER / 2)) - 1;
        j_iterations = larger_j;
#if (SCL_ALGORITHM_NAME == POLYPHASE || SCL_ALGORITHM_NAME == BICUBIC)

        {
            j_iterations_init = larger_j + sc_int<J_BITS>((SCL_ALGORITHM_V_TAPS - 1 - SCL_ALGORITHM_KERNEL_Y) - 1);
        }
#else
        {
            j_iterations_init = larger_j - sc_int<J_BITS>(1);
        }
#endif

        error_i_increment = smaller_i;
        corrected_error_i_increment = smaller_i - larger_i;
        error_j_increment = smaller_j;
        corrected_error_j_increment = smaller_j - larger_j;

#if (SCL_ALGORITHM_NAME == NEAREST_NEIGHBOUR)

        {
            error_i_init = error_i_init_AU.muxLdSI(error_init1_AU.subSI(sc_int<ERROR_I_BITS>(in_width >> 1), sc_int<ERROR_I_BITS>(out_width)),
                                                   error_init2_AU.subSI(sc_int<ERROR_I_BITS>( -1), sc_int<ERROR_I_BITS>(in_width)) >> 1,
                                                   is_scaling_up_h);
            error_j_init = error_j_init_AU.muxLdSI(error_init1_AU.subSI(sc_int<ERROR_J_BITS>(in_height >> 1), sc_int<ERROR_J_BITS>(out_height)),
                                                   error_init2_AU.subSI(sc_int<ERROR_J_BITS>( -1), sc_int<ERROR_J_BITS>(in_height)) >> 1,
                                                   is_scaling_up_v);
        }
#else
        {
            DECLARE_VAR_WITH_AU(sc_uint < SCL_ALGORITHM_LOG2_H_PHASES + LOG2G_IN_WIDTH > , (SCL_ALGORITHM_LOG2_H_PHASES + LOG2G_IN_WIDTH), coeff_i_dividend);
            DECLARE_VAR_WITH_AU(sc_uint < SCL_ALGORITHM_LOG2_V_PHASES + LOG2G_IN_HEIGHT > , (SCL_ALGORITHM_LOG2_V_PHASES + LOG2G_IN_HEIGHT), coeff_j_dividend);
            sc_int<DIVISION_COUNTER_BITS> division_counter;
            sc_uint < LARGER_I_BITS + LARGER_I_BITS > coeff_i_divisor;
            sc_uint < LARGER_I_BITS > coeff_i_quotient;
#ifndef __CUSP__

            unsigned long long coeff_i_dividend_debug;
            unsigned long long coeff_i_divisor_debug;
#endif

            sc_uint < LARGER_J_BITS + LARGER_J_BITS > coeff_j_divisor;
            sc_uint < LARGER_J_BITS > coeff_j_quotient;
            unsigned long long coeff_j_dividend_debug;
            unsigned long long coeff_j_divisor_debug;
            sc_uint<1> divides_this_iteration BIND(ALT_WIRE);

            in_width_minus_1 = in_width - sc_uint<LOG2G_IN_WIDTH>(1);

            error_i_init = error_i_init_AU.muxLdSI( -sc_int<ERROR_I_BITS>(out_width),
                                                    -1,
                                                    is_scaling_up_h);
            error_j_init = error_j_init_AU.muxLdSI( -sc_int<ERROR_J_BITS>(out_height),
                                                    -1,
                                                    is_scaling_up_v);

            coeff_i_dividend = coeff_i_dividend_AU.muxLdUI((in_width - out_width) << SCL_ALGORITHM_LOG2_H_PHASES,
                               in_width << SCL_ALGORITHM_LOG2_H_PHASES,
                               is_scaling_up_h);
            coeff_i_divisor = larger_i << (LARGER_I_BITS - 2);
            coeff_i_quotient = 0;
#ifndef __CUSP__

            coeff_i_dividend_debug = coeff_i_dividend;
            coeff_i_divisor_debug = larger_i;
#endif

            for (division_counter = LARGER_I_BITS - 2; division_counter >= sc_int<DIVISION_COUNTER_BITS>(0); division_counter--)
            {
                divides_this_iteration = coeff_i_dividend >= coeff_i_divisor;
                coeff_i_quotient = (coeff_i_quotient.range(LARGER_I_BITS - 2, 0), divides_this_iteration);
                coeff_i_dividend = coeff_i_dividend_AU.cAddSubUI(coeff_i_dividend, coeff_i_divisor, coeff_i_dividend, divides_this_iteration, 1);
                coeff_i_divisor = coeff_i_divisor >> 1;
            }
#ifndef __CUSP__
            assert((unsigned long long)coeff_i_quotient == coeff_i_dividend_debug / coeff_i_divisor_debug);
            assert((unsigned long long)coeff_i_dividend == coeff_i_dividend_debug % coeff_i_divisor_debug);
#endif

            error_coeff_i_increment = coeff_i_dividend;

            corrected_error_coeff_i_increment = sc_int<ERROR_I_BITS>(coeff_i_dividend) - sc_int<ERROR_I_BITS>(larger_i);

            coeff_i_increment = coeff_i_quotient;

            coeff_i_increment_plus_1 = coeff_i_increment + sc_uint<COEFF_I_BITS>(1);
            coeff_i_increment_non_zero = coeff_i_increment != sc_uint<COEFF_I_BITS>(0);

            coeff_i_nearly_overflow_val = sc_uint<COEFF_I_BITS>(SCL_ALGORITHM_MAX_I_COEFF - 1) - coeff_i_increment;


            coeff_j_dividend = coeff_j_dividend_AU.muxLdUI((in_height - out_height) << SCL_ALGORITHM_LOG2_V_PHASES,
                               in_height << SCL_ALGORITHM_LOG2_V_PHASES,
                               is_scaling_up_v);

            coeff_j_divisor = larger_j << (LARGER_J_BITS - 2);
            coeff_j_quotient = 0;
#ifndef __CUSP__

            coeff_j_dividend_debug = coeff_j_dividend;
            coeff_j_divisor_debug = larger_j;
#endif

            for (division_counter = LARGER_J_BITS - 2; division_counter >= sc_int<DIVISION_COUNTER_BITS>(0); division_counter--)
            {
                divides_this_iteration = coeff_j_dividend >= coeff_j_divisor;
                coeff_j_quotient = (coeff_j_quotient.range(LARGER_J_BITS - 2, 0), divides_this_iteration);
                coeff_j_dividend = coeff_j_dividend_AU.cAddSubUI(coeff_j_dividend, coeff_j_divisor, coeff_j_dividend, divides_this_iteration, 1);
                coeff_j_divisor = coeff_j_divisor >> 1;
            }
#ifndef __CUSP__
            assert((unsigned long long)coeff_j_quotient == coeff_j_dividend_debug / coeff_j_divisor_debug);
            assert((unsigned long long)coeff_j_dividend == coeff_j_dividend_debug % coeff_j_divisor_debug);
#endif

            error_coeff_j_increment = coeff_j_dividend;

            corrected_error_coeff_j_increment = sc_int<ERROR_J_BITS>(coeff_j_dividend) - sc_int<ERROR_J_BITS>(larger_j);

            coeff_j_increment = coeff_j_quotient;

            coeff_j_increment_plus_1 = coeff_j_increment + sc_uint<COEFF_J_BITS>(1);
        }
#endif


#endif

    }
#if SCL_ALGORITHM_NAME == NEAREST_NEIGHBOUR

    // Line buffers, one per channel in sequence
    ALT_REGISTER_FILE<CHANNEL_WIDTH, 2, 1, SCL_IN_WIDTH> line_buf_REG_FILE[SCL_CHANNELS_IN_SEQ];
    sc_uint<CHANNEL_WIDTH> line_buf[SCL_CHANNELS_IN_SEQ][SCL_IN_WIDTH] BIND(line_buf_REG_FILE);


    DECLARE_VAR_WITH_AU(sc_uint<1>, 1, write_enable_j);
    DECLARE_VAR_WITH_AU(sc_uint<1>, 1, read_enable_j);

    // Combinatorially decides how much to add to error_i
    ALT_AU<ERROR_I_BITS, 0> pre_error_i_AU;
    // Tracks the cumulative error in the horizontal direction
    DECLARE_VAR_WITH_AU(sc_int<ERROR_I_BITS>, ERROR_I_BITS, error_i);

    // Position to write to in the line buffer
    DECLARE_VAR_WITH_AU(sc_uint<WRITE_POS_BITS>, WRITE_POS_BITS, read_pos);
    DECLARE_VAR_WITH_AU(sc_uint<WRITE_POS_BITS>, WRITE_POS_BITS, write_pos);

    // For horizontal scaling up, store the last thing read in case it needs
    // repeating
    ALT_REG<CHANNEL_WIDTH> just_read_REG[SCL_CHANNELS_IN_SEQ];
    sc_uint<CHANNEL_WIDTH> just_read[SCL_CHANNELS_IN_SEQ] BIND(just_read_REG);

    // The body of the tight loop across each row. This is a function so that we
    // can tile loop bodies and acheive mod 4, 6 instead of 2, 3 which Cusp cannot do
    void process_pixel()
    {
        unsigned int sequence_cnt, copy_cnt;
        DECLARE_VAR_WITH_AU(sc_uint<1>, 1, read_enable_i);
        DECLARE_VAR_WITH_AU(sc_uint<1>, 1, write_enable_i);
        bool error_i_wrapped_0_latency BIND(ALT_WIRE);
        bool error_i_wrapped;
        DECLARE_N_COPIES(bool, error_i_wrapped, 1, 2);

        // Mux to control what is written back to the line buffer
        ALT_AU<CHANNEL_WIDTH> new_buf_val_AU[SCL_CHANNELS_IN_SEQ];
        sc_uint<CHANNEL_WIDTH> new_buf_val[SCL_CHANNELS_IN_SEQ] BIND(new_buf_val_AU);

        error_i_wrapped_0_latency = error_i < sc_int<ERROR_I_BITS>(0);
        error_i_wrapped = error_i_wrapped_0_latency;
        UPDATE_N_COPIES(error_i_wrapped, copy_cnt, 2);

        if (SCL_RUNTIME_CONTROL)
        {
            read_enable_i = read_enable_i_AU.muxLdUI(1, error_i_wrapped_0_latency, IS_SCALING_UP_H);
#if SCL_CHANNELS_IN_SEQ == 2

            write_enable_i = write_enable_i_AU.muxLdUI(READ_COPY(error_i_wrapped, 1), 1, IS_SCALING_UP_H);
#else

            write_enable_i = write_enable_i_AU.muxLdUI(error_i_wrapped, 1, IS_SCALING_UP_H);
#endif

        }
        else
        {
            if (IS_SCALING_UP_H)
            {
                read_enable_i = error_i_wrapped_0_latency;
                write_enable_i = 1;
            }
            else
            {
                read_enable_i = 1;
                write_enable_i = ALT_STAGE(error_i_wrapped, 3);
            }
        }
        
        cols_written = cols_written_AU.cAddSubSI(cols_written, 1, cols_written, write_enable_i, 0);

        // If scaling up vertically, then deal with line-buffer variables
        read_pos = read_pos_AU.cAddSubUI(
                       read_pos,                                                                      // a
                       1,                                                                        // b
                       read_pos,                                                                         // currVal
                       ALT_DONT_EVALUATE(!IS_SCALING_UP_H || error_i_wrapped_0_latency),                                                          // enable
                       0);               // doSub

        write_pos = write_pos_AU.cAddSubUI(
                        write_pos,                                                                   // a
                        1,                                                                        // b
                        write_pos,                                                                  // currVal
                        ALT_DONT_EVALUATE(!IS_SCALING_UP_H || READ_COPY(error_i_wrapped, 1)),                                                        // enable
                        0);               // doSub

        // Update the error by the increment or, if it is about to reach the threshold,
        // by increment-threshold. As noted before, we count towards 0 so this is a subtraction
        error_i = error_i_AU.addSubSI(
                      error_i,                                                                                                                                                                                                  // a
                      pre_error_i_AU.muxLdSI(                   // b
                          ERROR_I_INCREMENT,                                                                                                                                                                                    // (a)
                          CORRECTED_ERROR_I_INCREMENT,                                                                                                                                                                          // (b)
                          error_i_wrapped_0_latency),                                                                                                                                                                                     // (loadB)
                      1);                                       // doSub

        for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ; sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ);

            if (read_enable_i && read_enable_j)
            {
                just_read[sequence_cnt] = din->readWithinPacket(false);
            }


            if (SCL_RUNTIME_CONTROL || SCL_IN_HEIGHT < SCL_OUT_HEIGHT)
            {
                // If scaling up vertically, we may need to read from the line buffer

                assert(!IS_SCALING_UP_V || read_pos < sc_uint<WRITE_POS_BITS>(INTERNAL_IN_WIDTH));
                if (sequence_cnt > 0)
                {
                    ALT_NOSEQUENCE(new_buf_val[sequence_cnt] = new_buf_val_AU[sequence_cnt].muxLdUI(
                                       line_buf[sequence_cnt][read_pos],
                                       just_read[sequence_cnt],
                                       read_enable_j && ALT_DONT_EVALUATE(new_buf_val[sequence_cnt - 1].bit(0) || !new_buf_val[sequence_cnt - 1].bit(0))));
                }
                else
                {
                    ALT_NOSEQUENCE(new_buf_val[sequence_cnt] = new_buf_val_AU[sequence_cnt].muxLdUI(
                                       line_buf[sequence_cnt][read_pos],
                                       just_read[sequence_cnt],
                                       read_enable_j));
                }

                // In hardware, we don't care aboute array writes out of range during downscaling because
                // the line buffer is being bypassed. In software it would corrupt some memory and could
                // cause problem, so wrap the pointer.
#if !defined __CUSP_SYNTHESIS__

                if (!IS_SCALING_UP_V && SCL_RUNTIME_CONTROL)
                {
                    write_pos = write_pos % INTERNAL_IN_WIDTH;
                    // Make sure that new_buf value isn't from memory
                    assert(read_enable_j && just_read[sequence_cnt] == new_buf_val[sequence_cnt]);
                }
#endif
                assert(!IS_SCALING_UP_V || write_pos < sc_uint<WRITE_POS_BITS>(INTERNAL_IN_WIDTH));
                line_buf[sequence_cnt][write_pos] = new_buf_val[sequence_cnt];

                if (write_enable_i && write_enable_j)
                {
                    bool eop = (sequence_cnt == SCL_CHANNELS_IN_SEQ - 1) && cols_written == sc_int<I_BITS>(INTERNAL_OUT_WIDTH) && is_last_row;
                    dout->writeDataAndEop(new_buf_val[sequence_cnt], eop);
                }
            }
            else
            {

                if (write_enable_i && write_enable_j)
                {
                    bool eop = (sequence_cnt == SCL_CHANNELS_IN_SEQ - 1) && cols_written == sc_int<I_BITS>(INTERNAL_OUT_WIDTH) && is_last_row;
                    dout->writeDataAndEop(just_read[sequence_cnt], eop);
                }
            }
        }
    }
    DECLARE_VAR_WITH_AU(sc_int<I_BITS>, I_BITS, cols_written);
    bool is_last_row;
    void scale_frame_no_i()
    {
        unsigned int step_iter_cnt;
        unsigned int sequence_cnt;
        sc_uint<1> error_j_wrapped BIND(ALT_WIRE);

        // Vertical versions of error_i. Since this is not in the tight loop, pre_error
        // can be registered
        ALT_AU<ERROR_J_BITS> pre_error_j_AU;
        DECLARE_VAR_WITH_AU(sc_int<ERROR_J_BITS>, ERROR_J_BITS, error_j);

        // Horizontal, vertical loop counters
        sc_int<I_BITS> i;
        sc_int<J_BITS> j, rows_written;

        // Set all these to 0 initially
        for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ; sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ);

            just_read[sequence_cnt] = just_read_REG[sequence_cnt].sClrUI();
        }

        error_j = ERROR_J_INIT;
        rows_written = 0;

        for (j = J_ITERATIONS_INIT; j >= sc_int<J_BITS>(0); j--)
        {
            error_j_wrapped = error_j < sc_int<ERROR_J_BITS>(0);
            if (SCL_RUNTIME_CONTROL)
            {
                read_enable_j = read_enable_j_AU.muxLdUI(1, error_j_wrapped, IS_SCALING_UP_V);
                write_enable_j = write_enable_j_AU.muxLdUI(error_j_wrapped, 1, IS_SCALING_UP_V);
            }
            else
            {
                if (IS_SCALING_UP_V)
                {
                    read_enable_j = error_j_wrapped;
                    write_enable_j = 1;
                }
                else
                {
                    read_enable_j = 1;
                    write_enable_j = error_j_wrapped;
                }
            }

            if (write_enable_j)
            {
                rows_written++;
            }
            is_last_row = rows_written == sc_int<J_BITS>(INTERNAL_OUT_HEIGHT);

            error_j = error_j_AU.addSubSI(
                          error_j,                                                                                                                                                                                                                                               // a
                          pre_error_j_AU.muxLdSI(                   // b
                              ERROR_J_INCREMENT,                                                                                                                                                                                                                                   // (a)
                              CORRECTED_ERROR_J_INCREMENT,                                                                                                                                                                                                                 // (b)
                              error_j_wrapped),                                                                                                                                                                                                                                    // (loadB)
                          1);                                       // doSub

            error_i = ERROR_I_INIT;

            read_pos = -1;
            write_pos = -1;
            cols_written = 0;

            // Note that we always do an even number of iterations and add the last one
            // afterwards, if necessary
            for (i = I_ITERATIONS_INIT; i >= sc_int<I_BITS>(0); i--)
            {
#if SCL_RUNTIME_CONTROL
                ALT_ATTRIB(ALT_MIN_ITER, 32);
#endif

                ALT_ATTRIB(ALT_MOD_SCHED, ALT_MOD_SCHED_ON);
                ALT_ATTRIB(ALT_MOD_TARGET, MOD_TARGET);

                for (step_iter_cnt = 0; step_iter_cnt < STEP_ITER; step_iter_cnt++)
                {
                    ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                    ALT_ATTRIB(ALT_MIN_ITER, STEP_ITER);
                    ALT_ATTRIB(ALT_MAX_ITER, STEP_ITER);

                    process_pixel();
                }
            }
            if (STEP_ITER == 2)
            {
                if (IS_ODD(I_ITERATIONS))
                {
                    process_pixel();
                }
            }
        }
    }
#elif SCL_ALGORITHM_NAME == BILINEAR

    ALT_AU<CHANNEL_WIDTH> in00_AU[SCL_CHANNELS_IN_SEQ];
    sc_uint<CHANNEL_WIDTH> in00[SCL_CHANNELS_IN_SEQ] BIND(in00_AU);
    ALT_AU<CHANNEL_WIDTH> in01_AU[SCL_CHANNELS_IN_SEQ];
    sc_uint<CHANNEL_WIDTH> in01[SCL_CHANNELS_IN_SEQ] BIND(in01_AU);
    ALT_AU<CHANNEL_WIDTH> in10_AU[SCL_CHANNELS_IN_SEQ];
    sc_uint<CHANNEL_WIDTH> in10[SCL_CHANNELS_IN_SEQ] BIND(in10_AU);
    ALT_AU<CHANNEL_WIDTH> in11_AU[SCL_CHANNELS_IN_SEQ];
    sc_uint<CHANNEL_WIDTH> in11[SCL_CHANNELS_IN_SEQ] BIND(in11_AU);

    // For tracking the cumulative error on moving the kernel
    DECLARE_VAR_WITH_AU(sc_int<ERROR_I_BITS>, ERROR_I_BITS, error_i);
    ALT_AU<ERROR_I_BITS, 0> pre_error_i_AU;

    // For tracking the interpolation coefficients and their cumulative error w.r.t the kernel
    // cumulative error
    DECLARE_VAR_WITH_AU(sc_uint<COEFF_I_BITS>, COEFF_I_BITS, coeff_i);
    DECLARE_VAR_WITH_AU(sc_uint<COEFF_I_BITS>, COEFF_I_BITS, pre_coeff_i);
    DECLARE_VAR_WITH_AU(sc_int<ERROR_COEFF_I_BITS>, ERROR_COEFF_I_BITS, error_coeff_i);
    ALT_AU<ERROR_COEFF_I_BITS, 0> pre_error_coeff_i_AU;
    DECLARE_VAR_WITH_AU(sc_uint<COEFF_J_BITS>, COEFF_J_BITS, coeff_j);
    ALT_AU<COEFF_J_BITS> pre_coeff_j_AU;
    DECLARE_VAR_WITH_AU(sc_int<ERROR_COEFF_J_BITS>, ERROR_COEFF_J_BITS, error_coeff_j);
    ALT_AU<ERROR_COEFF_J_BITS> pre_error_coeff_j_AU;

    // Don't multiply coeff_i*coeff_j. Keep track of it's value by adding in the same way as coeff_i
    DECLARE_VAR_WITH_AU(sc_uint<COEFF_I_J_BITS>, COEFF_I_J_BITS, coeff_i_j);
    sc_uint<COEFF_I_J_BITS> coeff_i_j_increment;
    sc_uint<COEFF_I_J_BITS> coeff_i_j_increment_large;
    sc_uint<COEFF_I_J_BITS> coeff_i_j_overflow_correction;

    DECLARE_VAR_WITH_AU(sc_uint<1>, 1, write_enable_j);
    DECLARE_VAR_WITH_AU(sc_uint<1>, 1, read_enable_j);
    static const unsigned int MULT_WIDTH = SCL_PRECISION_H_INTEGER_BITS + SCL_PRECISION_H_FRACTION_BITS + SCL_PRECISION_V_INTEGER_BITS + SCL_PRECISION_V_FRACTION_BITS;

    ALT_MULT<MULT_WIDTH> in00_factored_MULT[SCL_CHANNELS_IN_PAR];
    sc_uint<MULT_WIDTH*2> in00_factored[SCL_CHANNELS_IN_PAR] BIND(in00_factored_MULT);
    ALT_MULT<MULT_WIDTH> in01_factored_MULT[SCL_CHANNELS_IN_PAR];
    sc_uint<MULT_WIDTH*2> in01_factored[SCL_CHANNELS_IN_PAR] BIND(in01_factored_MULT);
    ALT_MULT<MULT_WIDTH> in10_factored_MULT[SCL_CHANNELS_IN_PAR];
    sc_uint<MULT_WIDTH*2> in10_factored[SCL_CHANNELS_IN_PAR] BIND(in10_factored_MULT);
    ALT_MULT<MULT_WIDTH> in11_factored_MULT[SCL_CHANNELS_IN_PAR];
    sc_uint<MULT_WIDTH*2> in11_factored[SCL_CHANNELS_IN_PAR] BIND(in11_factored_MULT);

    void write_lerp_pixel()
    {
        const unsigned int COEFF00_ADD_WIDTH = COEFF_I_J_BITS + 1;
        const unsigned int COEFF00_SUB_WIDTH = COEFF_I_J_BITS + 2;
        const unsigned int COEFF01_SUB_WIDTH = COEFF_I_J_BITS;
        const unsigned int COEFF10_SUB_WIDTH = COEFF_I_J_BITS;
        const unsigned int PARTIAL_SUM_WIDTH = MULT_WIDTH + SCL_BPS;
        const unsigned int SUM_WIDTH = PARTIAL_SUM_WIDTH + 1;
        const unsigned int ROUNDED_SUM_WIDTH = MAX(SUM_WIDTH, SCL_PRECISION_H_FRACTION_BITS + SCL_PRECISION_V_FRACTION_BITS);

        DECLARE_VAR_WITH_AU(sc_uint<COEFF00_ADD_WIDTH>, COEFF00_ADD_WIDTH, coeff00_add1);
        DECLARE_VAR_WITH_AU(sc_uint<COEFF00_ADD_WIDTH>, COEFF00_ADD_WIDTH, coeff00_add2);
        DECLARE_VAR_WITH_AU(sc_uint<COEFF00_SUB_WIDTH>, COEFF00_SUB_WIDTH, coeff00);
        DECLARE_VAR_WITH_AU(sc_uint<COEFF01_SUB_WIDTH>, COEFF01_SUB_WIDTH, coeff01);
        DECLARE_VAR_WITH_AU(sc_uint<COEFF10_SUB_WIDTH>, COEFF10_SUB_WIDTH, coeff10);
        sc_uint<COEFF_I_J_BITS> coeff11 BIND(ALT_WIRE);

        ALT_AU<PARTIAL_SUM_WIDTH> partial_sum_upper_AU[SCL_CHANNELS_IN_PAR];
        sc_uint<PARTIAL_SUM_WIDTH> partial_sum_upper[SCL_CHANNELS_IN_PAR] BIND(partial_sum_upper_AU);
        ALT_AU<PARTIAL_SUM_WIDTH> partial_sum_lower_AU[SCL_CHANNELS_IN_PAR];
        sc_uint<PARTIAL_SUM_WIDTH> partial_sum_lower[SCL_CHANNELS_IN_PAR] BIND(partial_sum_lower_AU);

        ALT_AU<SUM_WIDTH> sum_AU[SCL_CHANNELS_IN_PAR];
        sc_uint<SUM_WIDTH> sum[SCL_CHANNELS_IN_PAR] BIND(sum_AU);
        ALT_AU<SUM_WIDTH> rounded_sum_AU[SCL_CHANNELS_IN_PAR];
        sc_uint<ROUNDED_SUM_WIDTH> rounded_sum[SCL_CHANNELS_IN_PAR] BIND(rounded_sum_AU);
        sc_uint<SCL_BPS> result[SCL_CHANNELS_IN_PAR] BIND(ALT_WIRE);

        sc_uint<SCL_BPS> in00_pars[SCL_CHANNELS_IN_PAR] BIND(ALT_WIRE);
        sc_uint<SCL_BPS> in01_pars[SCL_CHANNELS_IN_PAR] BIND(ALT_WIRE);
        sc_uint<SCL_BPS> in10_pars[SCL_CHANNELS_IN_PAR] BIND(ALT_WIRE);
        sc_uint<SCL_BPS> in11_pars[SCL_CHANNELS_IN_PAR] BIND(ALT_WIRE);

        unsigned int sequence_cnt, copy_cnt, parallel_cnt;

        DECLARE_N_COPIES(bool, write_enable_i, 1, 9);
        DECLARE_N_COPIES(sc_uint<COEFF_I_BITS>, coeff_i, COEFF_I_BITS, 3);
        DECLARE_N_COPIES(sc_uint<COEFF_I_J_BITS>, coeff_i_j, COEFF_I_J_BITS, 3);

        UPDATE_N_COPIES(coeff_i, copy_cnt, 3);
        UPDATE_N_COPIES(coeff_i_j, copy_cnt, 3);
        UPDATE_N_COPIES(write_enable_i, copy_cnt, 9);

        coeff00_add1 = coeff00_add1_AU.addUI(SCL_ALGORITHM_MAX_I_COEFF * SCL_ALGORITHM_MAX_J_COEFF, coeff_i_j);
        coeff00_add2 = coeff00_add2_AU.addUI(READ_COPY(coeff_i, 1) << SCL_PRECISION_V_FRACTION_BITS, coeff_j << SCL_PRECISION_H_FRACTION_BITS);

        // Calculate the coefficients, evening out the extra time it takes to produce the more complex
        // ones by staging coeff_i and coeff_i_j
        coeff00 = coeff00_AU.subUI(coeff00_add1, coeff00_add2);
        coeff01 = coeff01_AU.subUI(READ_COPY(coeff_i, 2) << SCL_PRECISION_V_FRACTION_BITS, READ_COPY(coeff_i_j, 0));
        coeff10 = coeff10_AU.subUI(coeff_j << SCL_PRECISION_H_FRACTION_BITS, READ_COPY(coeff_i_j, 0));
        coeff11 = READ_COPY(coeff_i_j, 1);

        for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ; sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ);

            in00_pars[0] = in00[sequence_cnt].range(SCL_BPS - 1, 0);
            in01_pars[0] = in01[sequence_cnt].range(SCL_BPS - 1, 0);
            in10_pars[0] = in10[sequence_cnt].range(SCL_BPS - 1, 0);
            in11_pars[0] = in11[sequence_cnt].range(SCL_BPS - 1, 0);
#if SCL_CHANNELS_IN_PAR > 1

            in00_pars[1] = in00[sequence_cnt].range(SCL_BPS * 2 - 1, SCL_BPS);
            in01_pars[1] = in01[sequence_cnt].range(SCL_BPS * 2 - 1, SCL_BPS);
            in10_pars[1] = in10[sequence_cnt].range(SCL_BPS * 2 - 1, SCL_BPS);
            in11_pars[1] = in11[sequence_cnt].range(SCL_BPS * 2 - 1, SCL_BPS);
#endif
 #if SCL_CHANNELS_IN_PAR > 2

            in00_pars[2] = in00[sequence_cnt].range(SCL_BPS * 3 - 1, SCL_BPS * 2);
            in01_pars[2] = in01[sequence_cnt].range(SCL_BPS * 3 - 1, SCL_BPS * 2);
            in10_pars[2] = in10[sequence_cnt].range(SCL_BPS * 3 - 1, SCL_BPS * 2);
            in11_pars[2] = in11[sequence_cnt].range(SCL_BPS * 3 - 1, SCL_BPS * 2);
#endif

            for (parallel_cnt = 0; parallel_cnt < SCL_CHANNELS_IN_PAR; parallel_cnt++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_PAR);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_PAR);

                in00_factored[parallel_cnt] = in00_pars[parallel_cnt] * sc_uint<MULT_WIDTH>(coeff00);

                in01_factored[parallel_cnt] = in01_pars[parallel_cnt] * sc_uint<MULT_WIDTH>(coeff01);

                in10_factored[parallel_cnt] = in10_pars[parallel_cnt] * sc_uint<MULT_WIDTH>(coeff10);

                in11_factored[parallel_cnt] = in11_pars[parallel_cnt] * sc_uint<MULT_WIDTH>(coeff11);

                partial_sum_upper[parallel_cnt] = in00_factored[parallel_cnt] + in01_factored[parallel_cnt];
                partial_sum_lower[parallel_cnt] = in10_factored[parallel_cnt] + in11_factored[parallel_cnt];

                sum[parallel_cnt] = partial_sum_upper[parallel_cnt] + partial_sum_lower[parallel_cnt];

                rounded_sum[parallel_cnt] = sum[parallel_cnt] + sc_uint<ROUNDED_SUM_WIDTH>(1 << (SCL_PRECISION_H_FRACTION_BITS + SCL_PRECISION_V_FRACTION_BITS - 1));
                result[parallel_cnt] = rounded_sum[parallel_cnt] >> (SCL_PRECISION_H_FRACTION_BITS + SCL_PRECISION_V_FRACTION_BITS);
            }
            if (READ_COPY(write_enable_i, 7) && write_enable_j)
            {
                if (sequence_cnt == SCL_CHANNELS_IN_SEQ - 1)
                {
                    cols_written++;
                }
                
                bool eop =  cols_written == sc_int<I_BITS>(INTERNAL_OUT_WIDTH) && is_last_row;

#if SCL_CHANNELS_IN_PAR == 1

                dout->writeDataAndEop(result[0], eop);
#elif SCL_CHANNELS_IN_PAR == 2

                dout->writeDataAndEop((result[1], result[0]), eop);
#else

                dout->writeDataAndEop((result[2], result[1], result[0]), eop);
#endif
            }
        }
    }
    sc_int<J_BITS> j;
    sc_int<I_BITS> i;

    // We need to stop reading before the kernel goes off the bottom edge of the image, but this is not the
    // same as just stopping it from advancing vertically. To perform mirror edge mode, we do not read to
    // the bottom 2 pixels, but we DO copy their values to the top two
    bool run_out_of_pixel_rows;

    ALT_REGISTER_FILE<CHANNEL_WIDTH, 2, 1, SCL_IN_WIDTH> line_buf_REG_FILE[SCL_CHANNELS_IN_SEQ];
    sc_uint<CHANNEL_WIDTH> line_buf[SCL_CHANNELS_IN_SEQ][SCL_IN_WIDTH] BIND(line_buf_REG_FILE);

    ALT_REGISTER_FILE<CHANNEL_WIDTH, 2, 1, SCL_IN_WIDTH> line_buf_future_REG_FILE[SCL_CHANNELS_IN_SEQ];
    sc_uint<CHANNEL_WIDTH> line_buf_future[SCL_CHANNELS_IN_SEQ][SCL_IN_WIDTH] BIND(line_buf_future_REG_FILE);

    DECLARE_VAR_WITH_AU(sc_uint<WRITE_POS_BITS>, WRITE_POS_BITS, write_pos);
    DECLARE_VAR_WITH_AU(sc_uint<WRITE_POS_BITS>, WRITE_POS_BITS, write_pos_late);

    DECLARE_VAR_WITH_AU(sc_uint<1>, 1, write_enable_i);
    ALT_AU<1, 0> read_enable_i_AU;
    sc_uint<1> read_enable_i;

    ALT_REG<CHANNEL_WIDTH> just_read_REG;
    sc_uint<CHANNEL_WIDTH> just_read BIND(just_read_REG);

    void write_body_pixel()
    {
        unsigned int sequence_cnt, cpy_counter;
        bool error_i_wrapped_0_latency BIND(ALT_WIRE);
        bool run_out_of_pixels_this_row_0_latency BIND(ALT_WIRE);
        bool run_out_of_pixels_this_row;
        bool error_coeff_i_wrapped_0_latency BIND(ALT_WIRE);
        bool error_coeff_i_wrapped;
        bool coeff_i_overflowed_0_latency BIND(ALT_WIRE);
        bool coeff_i_overflowed;
        bool coeff_i_overflowed_d;
        bool just_read_tautology BIND(ALT_WIRE);
        bool coeff_i_tautology BIND(ALT_WIRE);
        bool read_enable_i_0_latency BIND(ALT_WIRE);

        DECLARE_VAR_WITH_AU(sc_uint<COEFF_I_J_BITS>, COEFF_I_J_BITS, pre_coeff_i_j);
        DECLARE_VAR_WITH_AU(sc_uint<COEFF_I_J_BITS>, COEFF_I_J_BITS, corrected_coeff_i_j_increment);
        DECLARE_VAR_WITH_AU(sc_uint<COEFF_I_J_BITS>, COEFF_I_J_BITS, corrected_coeff_i_j_increment_large);


        DECLARE_N_COPIES(bool, run_out_of_pixels_this_row, 1, 2)
        DECLARE_N_COPIES(bool, read_enable_i, 1, 6)

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // Sort out the interpolation coefficients first

        error_coeff_i_wrapped_0_latency = error_coeff_i < sc_int<ERROR_COEFF_I_BITS>(0);
        error_coeff_i_wrapped = error_coeff_i_wrapped_0_latency;


        pre_coeff_i = pre_coeff_i_AU.muxLdUI(COEFF_I_INCREMENT,
                                             COEFF_I_INCREMENT_PLUS_1,
                                             error_coeff_i_wrapped_0_latency);

        coeff_i_overflowed_0_latency = (COEFF_I_INCREMENT_NON_ZERO && coeff_i > sc_uint<COEFF_I_BITS>(COEFF_I_NEARLY_OVERFLOW_VAL))
                                       || (error_coeff_i_wrapped
                                           && coeff_i >= sc_uint<COEFF_I_BITS>(COEFF_I_NEARLY_OVERFLOW_VAL));

        coeff_i_overflowed_d = coeff_i_overflowed = coeff_i_overflowed_0_latency;

        coeff_i = coeff_i + pre_coeff_i;

        error_coeff_i = error_coeff_i -
                        pre_error_coeff_i_AU.muxLdSI(
                            ERROR_COEFF_I_INCREMENT,
                            CORRECTED_ERROR_COEFF_I_INCREMENT,
                            error_coeff_i_wrapped_0_latency);


        // If this assertion were ever false, we would have to do the following with signed integers
        assert(!(write_enable_i && write_enable_j) || coeff_i_j_overflow_correction >= coeff_i_j_increment);

        corrected_coeff_i_j_increment = corrected_coeff_i_j_increment_AU.addSubSLdUI(
                                            coeff_i_j_overflow_correction,
                                            coeff_i_j_increment,
                                            coeff_i_j_increment,
                                            !coeff_i_overflowed_0_latency,
                                            1);

        // If this assertion were ever false, we would have to do the following with signed integers
        assert(!(write_enable_i && write_enable_j) || coeff_i_j_overflow_correction >= corrected_coeff_i_j_increment_large);
        corrected_coeff_i_j_increment_large = corrected_coeff_i_j_increment_large_AU.addSubSLdUI(
                                                  coeff_i_j_overflow_correction,
                                                  coeff_i_j_increment_large,
                                                  coeff_i_j_increment_large,
                                                  !coeff_i_overflowed_0_latency,
                                                  1);

        pre_coeff_i_j = pre_coeff_i_j_AU.muxLdUI(corrected_coeff_i_j_increment,
                        corrected_coeff_i_j_increment_large,
                        error_coeff_i_wrapped);

        coeff_i_j = coeff_i_j_AU.addSubUI(coeff_i_j,
                                          pre_coeff_i_j,
                                          coeff_i_overflowed_d);

        assert(!(write_enable_i && write_enable_j) || (unsigned)coeff_i_j == ((unsigned)coeff_i) * ((unsigned)coeff_j));

        ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        // Then the kernel movements
        // We don't need the kernel to be ready until the coefficients are worked out, so this tautology
        // forces the earliest kernl ops to start after coeff_i is found (just in time to be ready for the multiply)
        coeff_i_tautology = ALT_DONT_EVALUATE(coeff_i.bit(0) | !coeff_i.bit(0));

        error_i_wrapped_0_latency = ALT_DONT_EVALUATE(error_i < sc_int<ERROR_I_BITS>(0) && coeff_i_tautology);

        if (SCL_RUNTIME_CONTROL)
        {
            write_enable_i = write_enable_i_AU.muxLdUI(error_i_wrapped_0_latency, ALT_DONT_EVALUATE(coeff_i_tautology), IS_SCALING_UP_H);
            read_enable_i_0_latency = read_enable_i_AU.muxLdUI(ALT_DONT_EVALUATE(coeff_i_tautology), error_i_wrapped_0_latency, IS_SCALING_UP_H);
        }
        else
        {
            if (IS_SCALING_UP_H)
            {
                write_enable_i = ALT_DONT_EVALUATE(coeff_i_tautology);
                read_enable_i_0_latency = error_i_wrapped_0_latency;
            }
            else
            {
                write_enable_i = error_i_wrapped_0_latency;
                read_enable_i_0_latency = ALT_DONT_EVALUATE(coeff_i_tautology);
            }
        }
        read_enable_i = read_enable_i_0_latency;
        UPDATE_N_COPIES(read_enable_i, cpy_counter, 6);

        run_out_of_pixels_this_row_0_latency = ALT_DONT_EVALUATE(!(write_pos < sc_uint<WRITE_POS_BITS>(IN_WIDTH_MINUS_1)) && coeff_i_tautology);
        run_out_of_pixels_this_row = run_out_of_pixels_this_row_0_latency;
        UPDATE_N_COPIES(run_out_of_pixels_this_row, cpy_counter, 2);

        write_pos = write_pos_AU.cAddSubUI(
                        write_pos,
                        1,
                        write_pos,
                        read_enable_i_0_latency && !run_out_of_pixels_this_row_0_latency,
                        0);
        write_pos_late = write_pos_late_AU.cAddSubUI(
                             write_pos_late,
                             1,
                             write_pos_late,
                             READ_COPY(read_enable_i, 0) && !READ_COPY(run_out_of_pixels_this_row, 1),
                             0);


        for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ; sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ);

            if (read_enable_i && read_enable_j && !run_out_of_pixels_this_row
                    && !run_out_of_pixel_rows)
            {
                just_read = din->readWithinPacket(false);
            }

            // Use this to synchronise the loads into the inXX AUs to data coming in from memory
            // This makes all inXX for a channel in sequence happen at the same time as the slowest (in11)
            // Consequently, each channel in sequence happen one after the other
            just_read_tautology = ALT_DONT_EVALUATE(just_read.bit(0) | !(just_read.bit(0)));

            ALT_NOSEQUENCE(in00[sequence_cnt] = in00_AU[sequence_cnt].cLdUI(
                                                    in01[sequence_cnt],
                                                    in00[sequence_cnt],
                                                    ALT_DONT_EVALUATE(READ_COPY(read_enable_i, sequence_cnt) && just_read_tautology)));

            ALT_NOSEQUENCE(in10[sequence_cnt] = in10_AU[sequence_cnt].cLdUI(
                                                    in11[sequence_cnt],
                                                    in10[sequence_cnt],
                                                    ALT_DONT_EVALUATE(READ_COPY(read_enable_i, sequence_cnt) && just_read_tautology)));

            ALT_NOSEQUENCE(in01[sequence_cnt] = in01_AU[sequence_cnt].mCLdUI(
                                                    ALT_PORTA(line_buf[sequence_cnt][write_pos]),
                                                    ALT_PORTA(line_buf_future[sequence_cnt][write_pos]),
                                                    in01[sequence_cnt],
                                                    READ_COPY(read_enable_i, sequence_cnt) && !(read_enable_j) && !READ_COPY(run_out_of_pixels_this_row, 1),
                                                    ALT_DONT_EVALUATE(READ_COPY(read_enable_i, sequence_cnt) && read_enable_j && !READ_COPY(run_out_of_pixels_this_row, 1) && just_read_tautology)));


            ALT_NOSEQUENCE(in11[sequence_cnt] = in11_AU[sequence_cnt].mCLdUI(
                                                    ALT_PORTA(line_buf_future[sequence_cnt][write_pos]),
                                                    just_read,
                                                    in11[sequence_cnt],
                                                    READ_COPY(read_enable_i, sequence_cnt) && !(read_enable_j
                                                            && !run_out_of_pixel_rows) && !READ_COPY(run_out_of_pixels_this_row, 1),
                                                    READ_COPY(read_enable_i, sequence_cnt) && read_enable_j
                                                    && !run_out_of_pixel_rows && !READ_COPY(run_out_of_pixels_this_row, 1)
                                                ));
            assert((unsigned)write_pos_late < SCL_IN_WIDTH);
            ALT_PORTB(line_buf[sequence_cnt][write_pos_late] = in01[sequence_cnt]);
            ALT_PORTB(line_buf_future[sequence_cnt][write_pos_late] = in11[sequence_cnt]);
        }

        error_i = error_i - pre_error_i_AU.muxLdSI(
                      ERROR_I_INCREMENT,
                      CORRECTED_ERROR_I_INCREMENT,
                      error_i_wrapped_0_latency);

        write_lerp_pixel();

    }
#define N_ROWS_READ_BITS LOG2G_IN_HEIGHT
    sc_int<I_BITS> cols_written;
    bool is_last_row;
    void scale_frame_linear_i()
    {
        DECLARE_VAR_WITH_AU(sc_int<ERROR_J_BITS>, ERROR_J_BITS, error_j);
        DECLARE_VAR_WITH_AU(sc_uint<N_ROWS_READ_BITS>, N_ROWS_READ_BITS, n_rows_read);
        ALT_AU<ERROR_J_BITS> pre_error_j_AU;
        unsigned int sequence_cnt;
        unsigned int step_iter_cnt;
        bool error_j_wrapped;
        bool error_coeff_j_wrapped BIND(ALT_WIRE);
        bool is_first_iteration;
        sc_int<J_BITS> rows_written = 0;

        coeff_j = -(COEFF_J_INCREMENT_PLUS_1);
        error_coeff_j = -1;
        error_j = ERROR_J_INIT;
        n_rows_read = 0;

        read_enable_j = 1;
        write_enable_j = 0;

        // Initialise these vars for cusp, even though we don't care about their values
        for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ; sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ);

            in00[sequence_cnt] = in00_AU[sequence_cnt].sClrUI();
            in01[sequence_cnt] = in01_AU[sequence_cnt].sClrUI();
            in10[sequence_cnt] = in10_AU[sequence_cnt].sClrUI();
            in11[sequence_cnt] = in11_AU[sequence_cnt].sClrUI();
        }

        // Note that the first iteration is just filling the line-buffer. It produces no output.
        is_first_iteration = true;
        for (j = J_ITERATIONS; j >= sc_int<J_BITS>(0); j--)
        {
            run_out_of_pixel_rows = !(n_rows_read < sc_uint<N_ROWS_READ_BITS>(INTERNAL_IN_HEIGHT));
            error_j_wrapped = error_j < sc_int<ERROR_J_BITS>(0);
            if (SCL_RUNTIME_CONTROL)
            {
                write_enable_j = write_enable_j_AU.muxLdUI(!is_first_iteration && error_j_wrapped, !is_first_iteration, IS_SCALING_UP_V);
                read_enable_j = read_enable_j_AU.muxLdUI(1, error_j_wrapped, IS_SCALING_UP_V);
            }
            else
            {
                if (IS_SCALING_UP_V)
                {
                    write_enable_j = !is_first_iteration;
                    read_enable_j = error_j_wrapped;
                }
                else
                {
                    write_enable_j = !is_first_iteration && error_j_wrapped;
                    read_enable_j = 1;
                }
            }
            if (write_enable_j)
            {
                rows_written++;
            }
            is_last_row = rows_written == sc_int<J_BITS>(INTERNAL_OUT_HEIGHT);
            cols_written = 0;
            if (read_enable_j && !run_out_of_pixel_rows)
            {
                n_rows_read = n_rows_read + sc_uint<N_ROWS_READ_BITS>(1);
            }

            error_j = error_j_AU.cAddSubSI(
                          error_j,
                          pre_error_j_AU.muxLdSI(
                              ERROR_J_INCREMENT,
                              CORRECTED_ERROR_J_INCREMENT,
                              error_j_wrapped
                          ),
                          error_j,
                          !is_first_iteration,
                          1);
            error_coeff_j_wrapped = error_coeff_j < sc_int<ERROR_COEFF_J_BITS>(0);

            coeff_j = coeff_j_AU.cAddSubUI(coeff_j,
                                           pre_coeff_j_AU.muxLdUI(COEFF_J_INCREMENT,
                                                                  COEFF_J_INCREMENT_PLUS_1,
                                                                  error_coeff_j_wrapped),
                                           coeff_j,
                                           !is_first_iteration,
                                           0);
            error_coeff_j = error_coeff_j_AU.cAddSubSI(
                                error_coeff_j,
                                pre_error_coeff_j_AU.muxLdSI(
                                    ERROR_COEFF_J_INCREMENT,
                                    CORRECTED_ERROR_COEFF_J_INCREMENT,
                                    error_coeff_j_wrapped
                                ),
                                error_coeff_j,
                                !is_first_iteration,
                                1);

            coeff_i_j_increment = in00_factored_MULT[0].multUI(sc_uint<COEFF_I_BITS>(COEFF_I_INCREMENT), coeff_j);
            coeff_i_j_increment_large = coeff_i_j_increment + coeff_j;
            coeff_i_j_overflow_correction = coeff_j << COEFF_I_BITS;

            error_i = ERROR_I_INIT;
            coeff_i = -(COEFF_I_INCREMENT_PLUS_1);
            error_coeff_i = -1;
            coeff_i_j = sc_uint<COEFF_I_J_BITS>(coeff_i_j_overflow_correction - coeff_i_j_increment_large);

            write_pos = write_pos_AU.sClrUI();
            write_pos_late = write_pos_late_AU.sClrUI();

            for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ; sequence_cnt++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ);

                in01[sequence_cnt] = in01_AU[sequence_cnt].muxLdUI(
                                         ALT_PORTA(line_buf[sequence_cnt][write_pos]),
                                         ALT_PORTA(line_buf_future[sequence_cnt][write_pos]),
                                         read_enable_j);

                if (read_enable_j && !run_out_of_pixel_rows)
                {
                    just_read = din->readWithinPacket(false);
                }

                in11[sequence_cnt] = in11_AU[sequence_cnt].muxLdUI(
                                         ALT_PORTA(line_buf_future[sequence_cnt][write_pos]),
                                         just_read,
                                         read_enable_j && !run_out_of_pixel_rows);

                ALT_PORTB(line_buf[sequence_cnt][write_pos_late] = in01[sequence_cnt]);
                ALT_PORTB(line_buf_future[sequence_cnt][write_pos_late] = in11[sequence_cnt]);
            }

            for (i = I_ITERATIONS_INIT; i >= sc_int<I_BITS>(0); i--)
            {
#if SCL_RUNTIME_CONTROL
                ALT_ATTRIB(ALT_MIN_ITER, 32);
#endif

                ALT_ATTRIB(ALT_MOD_SCHED, ALT_MOD_SCHED_ON);
                ALT_ATTRIB(ALT_MOD_TARGET, MOD_TARGET);

                for (step_iter_cnt = 0; step_iter_cnt < STEP_ITER; step_iter_cnt++)
                {
                    ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                    ALT_ATTRIB(ALT_MIN_ITER, STEP_ITER);
                    ALT_ATTRIB(ALT_MAX_ITER, STEP_ITER);
                    write_body_pixel();
                }
            }
            // With 3 channels in sequence, we assume that the above loop has a even
            // number of iterations, here we make up the extra on if it were odd
            if (STEP_ITER == 2 && IS_ODD(I_ITERATIONS))
            {
                write_body_pixel();
            }
            is_first_iteration = false;
        }
    }
#elif SCL_ALGORITHM_NAME == POLYPHASE || SCL_ALGORITHM_NAME == BICUBIC

#define TIME_TO_READY_V_KERNEL 3
#define TIME_TO_MULTIPLY 3
#define TIME_FOR_SCL_ALGORITHM_V_TREE (SCL_ALGORITHM_LOG2_V_TAPS)
#define TIME_FOR_SCL_ALGORITHM_V_TREE_ROUNDING 3
#define TIME_FOR_SCL_ALGORITHM_H_TREE (SCL_ALGORITHM_LOG2_H_TAPS)
#define TIME_TO_CREATE_V_VALUE (TIME_TO_READY_V_KERNEL+TIME_TO_MULTIPLY+TIME_FOR_SCL_ALGORITHM_V_TREE+TIME_FOR_SCL_ALGORITHM_V_TREE_ROUNDING)
#define TIME_TO_FIRST_OUTPUT (TIME_TO_CREATE_V_VALUE + 5 + TIME_FOR_SCL_ALGORITHM_H_TREE)

    sc_int<I_BITS> i;
    sc_int<J_BITS> j;

    ALT_AU<1, 0> read_enable_i_AU;
    bool read_enable_i;
    DECLARE_VAR_WITH_AU(bool, 1, write_enable_j);
    DECLARE_VAR_WITH_AU(bool, 1, read_enable_j);

    bool read_enable_i_0_latency BIND(ALT_WIRE);

#define N_read_enable_i (TIME_TO_CREATE_V_VALUE+SCL_CHANNELS_IN_SEQ)

    DECLARE_N_COPIES(sc_uint<1>, read_enable_i, 1, N_read_enable_i);

    DECLARE_VAR_WITH_AU(sc_uint<WRITE_POS_BITS>, WRITE_POS_BITS, write_pos);

    DECLARE_VAR_WITH_REG(bool, 1, run_out_of_pixels_this_row);
#define N_run_out_of_pixels_this_row (TIME_TO_CREATE_V_VALUE+SCL_CHANNELS_IN_SEQ)

    DECLARE_N_COPIES(sc_uint<1>, run_out_of_pixels_this_row, 1, N_run_out_of_pixels_this_row);

#define N_ROWS_READ_WIDTH LOG2G_IN_HEIGHT

    DECLARE_VAR_WITH_AU(sc_uint<N_ROWS_READ_WIDTH>, N_ROWS_READ_WIDTH, n_rows_read);
    DECLARE_VAR_WITH_REG(bool, 1, run_out_of_pixel_rows);

    ALT_REGISTER_FILE<CHANNEL_WIDTH, 2, 1, SCL_IN_WIDTH> line_buf_REG_FILE[SCL_CHANNELS_IN_SEQ*SCL_ALGORITHM_V_TAPS];
    sc_uint<CHANNEL_WIDTH> line_buf[SCL_CHANNELS_IN_SEQ*SCL_ALGORITHM_V_TAPS][SCL_IN_WIDTH] BIND(line_buf_REG_FILE);

#define V_VALUE_BITS (SCL_PRECISION_H_KERNEL_BITS+OVERFLOW_BIT)

    ALT_AU<V_VALUE_BITS> v_value_AU[SCL_CHANNELS_IN_PAR];
    V_TREE_TYPE<V_VALUE_BITS> v_value[SCL_CHANNELS_IN_PAR] BIND(v_value_AU);

    // The "kernel" is really just a horizontal line and a vertical line of taps
    ALT_AU<SCL_PRECISION_H_KERNEL_BITS> h_kernel_AU[SCL_ALGORITHM_H_TAPS*SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR];
    H_TREE_TYPE<SCL_PRECISION_H_KERNEL_BITS> h_kernel[SCL_ALGORITHM_H_TAPS*SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR] BIND(h_kernel_AU);
    ALT_AU<CHANNEL_WIDTH> v_kernel_AU[SCL_ALGORITHM_V_TAPS*SCL_CHANNELS_IN_SEQ];
    sc_uint<CHANNEL_WIDTH> v_kernel[SCL_ALGORITHM_V_TAPS*SCL_CHANNELS_IN_SEQ] BIND(v_kernel_AU);

    // For horizontal mirroring
#define H_MIRROR_BUF_SIZE (SCL_ALGORITHM_H_TAPS-1-SCL_ALGORITHM_KERNEL_X)

    ALT_AU<SCL_PRECISION_H_KERNEL_BITS> h_mirror_buf_AU[H_MIRROR_BUF_SIZE*SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR];
    H_TREE_TYPE<SCL_PRECISION_H_KERNEL_BITS> h_mirror_buf[H_MIRROR_BUF_SIZE*SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR] BIND(h_mirror_buf_AU);


#define V_OFF_EDGE_WIDTH (SCL_ALGORITHM_LOG2_V_TAPS+SIGN_BIT+1)

    DECLARE_VAR_WITH_AU(sc_int<V_OFF_EDGE_WIDTH>, V_OFF_EDGE_WIDTH, v_off_edge);

    ALT_AU<SCL_COEFFICIENTS_H_BITS> these_h_coeffs_AU[SCL_ALGORITHM_H_TAPS];
    H_COEFF_TYPE these_h_coeffs[SCL_ALGORITHM_H_TAPS] BIND(these_h_coeffs_AU);

    ALT_AU<SCL_COEFFICIENTS_V_BITS> these_v_coeffs_AU[SCL_ALGORITHM_V_TAPS];
    V_COEFF_TYPE these_v_coeffs[SCL_ALGORITHM_V_TAPS] BIND(these_v_coeffs_AU);

#define H_COEFF_POS_BITS SCL_ALGORITHM_LOG2_H_PHASES
 #define H_COEFF_ACCESS_BITS H_COEFF_POS_BITS

    DECLARE_VAR_WITH_AU(sc_uint<H_COEFF_POS_BITS>, H_COEFF_POS_BITS, h_coeff_pos);
#if SCL_COEFFICIENTS_H_COEFFS_ARE_SYMMETRIC

    bool h_coeffs_are_being_reflected;
#define TIME_TO_READ_H_COEFF 7

    DECLARE_VAR_WITH_AU(sc_uint<H_COEFF_ACCESS_BITS>, H_COEFF_ACCESS_BITS, h_coeff_access);
#else
 #define h_coeffs_are_being_reflected 0
#define TIME_TO_READ_H_COEFF 4

    sc_uint<H_COEFF_ACCESS_BITS> h_coeff_access BIND(ALT_WIRE);
#endif
#define N_h_coeffs_are_being_reflected 3

    DECLARE_N_COPIES(bool, h_coeffs_are_being_reflected, 1, N_h_coeffs_are_being_reflected);

    DECLARE_VAR_WITH_AU(sc_uint<V_COEFF_POS_BITS>, V_COEFF_POS_BITS, v_coeff_pos);
#if SCL_COEFFICIENTS_V_COEFFS_ARE_SYMMETRIC || (SCL_COEFFICIENTS_COEFF_ARRAYS_IDENTICAL && SCL_COEFFICIENTS_H_COEFFS_ARE_SYMMETRIC)

    DECLARE_VAR_WITH_AU(sc_uint<V_COEFF_ACCESS_BITS>, V_COEFF_ACCESS_BITS, v_coeff_access);
    bool v_coeffs_are_being_reflected;
#else
 #define v_coeffs_are_being_reflected 0

    sc_uint<V_COEFF_ACCESS_BITS> v_coeff_access BIND(ALT_WIRE);
#endif

    // For tracking the indices into the coefficient arrays their cumulative error w.r.t the kernel
    // cumulative error
    DECLARE_VAR_WITH_AU(sc_uint<H_COEFF_POS_BITS>, H_COEFF_POS_BITS, pre_h_coeff_pos);
    DECLARE_VAR_WITH_AU(sc_int<ERROR_COEFF_I_BITS>, ERROR_COEFF_I_BITS, error_h_coeff_pos);
    ALT_AU<ERROR_COEFF_I_BITS, 0> pre_error_h_coeff_pos_AU;
    ALT_AU<V_COEFF_POS_BITS> pre_v_coeff_pos_AU;
    DECLARE_VAR_WITH_AU(sc_int<ERROR_COEFF_J_BITS>, ERROR_COEFF_J_BITS, error_v_coeff_pos);
    ALT_AU<ERROR_COEFF_J_BITS> pre_error_v_coeff_pos_AU;

    // Short-hand to find indices in arrays that should be [X][SCL_CHANNELS_IN_SEQ]
    // but are actually [X*SCL_CHANNELS_IN_SEQ]
#define FLAT_CHANNELS_IN_SEQ_IDX(X) ((X)*SCL_CHANNELS_IN_SEQ+sequence_cnt)
#define FLAT_CHANNELS_IN_PAR_IDX(X) ((X)*SCL_CHANNELS_IN_PAR+parallel_cnt)
#define FLAT_CHANNELS_IN_SEQ_PAR_IDX(X) (((X)*SCL_CHANNELS_IN_SEQ+sequence_cnt)*SCL_CHANNELS_IN_PAR+parallel_cnt)
 #define FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_IDX(X) ((X)*SCL_CHANNELS_IN_SEQ+calculate_v_value_sequence_cnt)
 #define FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(X) (((X)*SCL_CHANNELS_IN_SEQ+calculate_v_value_sequence_cnt)*SCL_CHANNELS_IN_PAR+parallel_cnt)

    // Should be local to pre_fill_h_kernel, but Cusp needs it to be initialised elsewhere
    DECLARE_VAR_WITH_REG(sc_uint<CHANNEL_WIDTH>, CHANNEL_WIDTH, just_read)
#define N_write_pos 5
    DECLARE_N_COPIES(sc_uint<WRITE_POS_BITS>, write_pos, WRITE_POS_BITS, N_write_pos);
    void v_advance_kernel()
    {
        unsigned int sequence_cnt;
        unsigned int v_tap_counter;
        unsigned int cpy_counter;

        bool about_to_run_out_of_pixels_this_row BIND(ALT_WIRE);
        bool just_read_tautology BIND(ALT_WIRE);


        about_to_run_out_of_pixels_this_row = write_pos == sc_uint<WRITE_POS_BITS>(0);

        write_pos = write_pos_AU.cAddSubUI(write_pos,
                                           1,
                                           write_pos,
                                           read_enable_i_0_latency && !(run_out_of_pixels_this_row || about_to_run_out_of_pixels_this_row),
                                           1);
        UPDATE_N_COPIES(write_pos, cpy_counter, N_write_pos);

        if (read_enable_i_0_latency && about_to_run_out_of_pixels_this_row)
        {
            run_out_of_pixels_this_row = 1;
        }

        UPDATE_N_COPIES(run_out_of_pixels_this_row, cpy_counter, N_run_out_of_pixels_this_row);

        // All of the data operations apply to all of the channels in sequence
        for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ; sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ);
            if (sequence_cnt > 0)
            {
                if (read_enable_j && READ_COPY(read_enable_i, sequence_cnt - 1) && !READ_COPY(run_out_of_pixels_this_row, sequence_cnt - 1))
                {
                    just_read = din->readWithinPacket(false);
                }
            }
            else
            {
                if (read_enable_j && read_enable_i && !run_out_of_pixels_this_row)
                {
                    just_read = din->readWithinPacket(false);
                }
            }
            just_read_tautology = ALT_DONT_EVALUATE(just_read.bit(0) || !just_read.bit(0));
            for (v_tap_counter = 0; v_tap_counter < SCL_ALGORITHM_V_TAPS - 1; v_tap_counter++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TAPS - 1);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TAPS - 1);

                if (sequence_cnt > 0)
                {
                    v_kernel[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter)] = v_kernel_AU[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter)].mCLdUI(
                                ALT_PORTA(line_buf[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter)][READ_COPY(write_pos, sequence_cnt - 1)]),
                                ALT_PORTA(line_buf[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter + 1)][READ_COPY(write_pos, sequence_cnt - 1)]),
                                v_kernel[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter)],
                                ALT_DONT_EVALUATE(just_read_tautology && READ_COPY(read_enable_i, 1 + sequence_cnt) && !READ_COPY(run_out_of_pixels_this_row, 1 + sequence_cnt) && !read_enable_j),
                                READ_COPY(read_enable_i, 1 + sequence_cnt) && !READ_COPY(run_out_of_pixels_this_row, 1 + sequence_cnt) && read_enable_j);
                }
                else
                {
                    v_kernel[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter)] = v_kernel_AU[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter)].mCLdUI(
                                ALT_PORTA(line_buf[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter)][write_pos]),
                                ALT_PORTA(line_buf[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter + 1)][write_pos]),
                                v_kernel[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter)],
                                ALT_DONT_EVALUATE(just_read_tautology && READ_COPY(read_enable_i, 1) && !READ_COPY(run_out_of_pixels_this_row, 1 + sequence_cnt) && !read_enable_j),
                                READ_COPY(read_enable_i, 1) && !READ_COPY(run_out_of_pixels_this_row, 1 + sequence_cnt) && read_enable_j);
                }
                assert((unsigned int)write_pos < (unsigned int)INTERNAL_IN_WIDTH);
                ALT_NOSEQUENCE(ALT_PORTB(line_buf[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter)][READ_COPY(write_pos, 2 + sequence_cnt)] = v_kernel[FLAT_CHANNELS_IN_SEQ_IDX(v_tap_counter)]));
            }
            if (sequence_cnt > 0)
            {
                v_kernel[FLAT_CHANNELS_IN_SEQ_IDX((SCL_ALGORITHM_V_TAPS - 1))] = v_kernel_AU[FLAT_CHANNELS_IN_SEQ_IDX((SCL_ALGORITHM_V_TAPS - 1))].mCLdUI(
                            ALT_PORTA(line_buf[FLAT_CHANNELS_IN_SEQ_IDX((SCL_ALGORITHM_V_TAPS - 1))][READ_COPY(write_pos, sequence_cnt - 1)]),
                            just_read,
                            v_kernel[FLAT_CHANNELS_IN_SEQ_IDX((SCL_ALGORITHM_V_TAPS - 1))],
                            READ_COPY(read_enable_i, 1 + sequence_cnt) && !READ_COPY(run_out_of_pixels_this_row, 1 + sequence_cnt) && !read_enable_j,
                            READ_COPY(read_enable_i, 1 + sequence_cnt) && !READ_COPY(run_out_of_pixels_this_row, 1 + sequence_cnt) && read_enable_j);
            }
            else
            {
                v_kernel[FLAT_CHANNELS_IN_SEQ_IDX((SCL_ALGORITHM_V_TAPS - 1))] = v_kernel_AU[FLAT_CHANNELS_IN_SEQ_IDX((SCL_ALGORITHM_V_TAPS - 1))].mCLdUI(
                            ALT_PORTA(line_buf[FLAT_CHANNELS_IN_SEQ_IDX((SCL_ALGORITHM_V_TAPS - 1))][write_pos]),
                            just_read,
                            v_kernel[FLAT_CHANNELS_IN_SEQ_IDX((SCL_ALGORITHM_V_TAPS - 1))],
                            READ_COPY(read_enable_i, 1) && !READ_COPY(run_out_of_pixels_this_row, 1 + sequence_cnt) && !read_enable_j,
                            READ_COPY(read_enable_i, 1) && !READ_COPY(run_out_of_pixels_this_row, 1 + sequence_cnt) && read_enable_j);
            }
            assert((unsigned int)write_pos < (unsigned int)INTERNAL_IN_WIDTH);
            ALT_NOSEQUENCE(ALT_PORTB(line_buf[FLAT_CHANNELS_IN_SEQ_IDX((SCL_ALGORITHM_V_TAPS - 1))][READ_COPY(write_pos, 2 + sequence_cnt)] = v_kernel[FLAT_CHANNELS_IN_SEQ_IDX((SCL_ALGORITHM_V_TAPS - 1))]));

        }
    }
    void pre_fill_h_kernel()
    {
        unsigned int h_tap_counter, parallel_cnt;

        // Fill up a horizontal kernel from SCL_ALGORITHM_KERNEL_X onwards, at the same time mirroring
        // back before SCL_ALGORITHM_KERNEL_X
        for (i = 1; sc_uint<SCL_ALGORITHM_LOG2_H_TAPS>(i) < sc_uint<SCL_ALGORITHM_LOG2_H_TAPS>(SCL_ALGORITHM_H_TAPS - SCL_ALGORITHM_KERNEL_X); i++)
        {
            read_enable_i_0_latency = 1;
            v_advance_kernel()
            ;

            for (h_tap_counter = 1; h_tap_counter < SCL_ALGORITHM_H_TAPS - SCL_ALGORITHM_KERNEL_X; h_tap_counter++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_H_TAPS - SCL_ALGORITHM_KERNEL_X - 1);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_H_TAPS - SCL_ALGORITHM_KERNEL_X - 1);
                for (calculate_v_value_sequence_cnt = 0; calculate_v_value_sequence_cnt < SCL_CHANNELS_IN_SEQ; calculate_v_value_sequence_cnt++)
                {
                    ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                    ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ);
                    ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ);

                    calculate_v_value();

                    for (parallel_cnt = 0; parallel_cnt < SCL_CHANNELS_IN_PAR; parallel_cnt++)
                    {
                        ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                        ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_PAR);
                        ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_PAR);
                        h_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_KERNEL_X + h_tap_counter)] = h_kernel_AU[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_KERNEL_X + h_tap_counter)].H_TREE_CLD(
                        		    H_TREE_TYPE<SCL_PRECISION_H_KERNEL_BITS>(v_value[parallel_cnt]),
                                    h_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_KERNEL_X + h_tap_counter)],
                                    sc_uint<SCL_ALGORITHM_LOG2_H_TAPS>(i) == ALT_EVALUATE(sc_uint<SCL_ALGORITHM_LOG2_H_TAPS>(h_tap_counter)));
                        if (h_tap_counter - 1 < SCL_ALGORITHM_KERNEL_X)
                        {
                            h_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_KERNEL_X - (h_tap_counter - 1))] = h_kernel_AU[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_KERNEL_X - (h_tap_counter - 1))].H_TREE_CLD(
                            		    H_TREE_TYPE<SCL_PRECISION_H_KERNEL_BITS>(v_value[parallel_cnt]),
                                        h_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_KERNEL_X - (h_tap_counter - 1))],
                                        sc_uint<SCL_ALGORITHM_LOG2_H_TAPS>(i) == ALT_EVALUATE(sc_uint<SCL_ALGORITHM_LOG2_H_TAPS>(h_tap_counter)));
                        }
                    }
                }
            }
        }
    }

    void h_advance_kernel_body()
    {
        unsigned int h_tap_counter, parallel_cnt;

        H_TREE_TYPE<SCL_PRECISION_H_KERNEL_BITS> h_kernel_srcs[SCL_ALGORITHM_H_TAPS*SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR] BIND(ALT_WIRE);
        bool v_value_tautology BIND(ALT_WIRE);

        for (calculate_v_value_sequence_cnt = 0; calculate_v_value_sequence_cnt < SCL_CHANNELS_IN_SEQ; calculate_v_value_sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ);

            calculate_v_value();

            v_value_tautology = ALT_DONT_EVALUATE(v_value[0].bit(0) | !v_value[0].bit(0));

            for (parallel_cnt = 0; parallel_cnt < SCL_CHANNELS_IN_PAR; parallel_cnt++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_PAR);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_PAR);

                // Advance the kernel or don't
                for (h_tap_counter = 0; h_tap_counter < SCL_ALGORITHM_H_TAPS - 1; h_tap_counter++)
                {
                    ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                    ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_H_TAPS - 1);
                    ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_H_TAPS - 1);

                    h_kernel_srcs[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(h_tap_counter)] = h_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(h_tap_counter + 1)];

                    h_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(h_tap_counter)] = h_kernel_AU[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(h_tap_counter)].H_TREE_CLD(
                                h_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(h_tap_counter + 1)],
                                h_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(h_tap_counter)],
                                ALT_DONT_EVALUATE(v_value_tautology && READ_COPY(read_enable_i, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt)));
                }
                h_kernel_srcs[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_H_TAPS - 1)] = v_value[parallel_cnt];
                h_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_H_TAPS - 1)] = h_kernel_AU[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_H_TAPS - 1)].H_TREE_MUX_CLD(
                            h_mirror_buf[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(0)],
                            H_TREE_TYPE<SCL_PRECISION_H_KERNEL_BITS>(v_value[parallel_cnt]),
                            h_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_H_TAPS - 1)],
                            READ_COPY(read_enable_i, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt) && READ_COPY(run_out_of_pixels_this_row, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt),
                            READ_COPY(read_enable_i, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt) && !READ_COPY(run_out_of_pixels_this_row, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt));

                for (h_tap_counter = 0; h_tap_counter < H_MIRROR_BUF_SIZE - 1; h_tap_counter++)
                {
                    ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                    ALT_ATTRIB(ALT_MIN_ITER, H_MIRROR_BUF_SIZE - 1);
                    ALT_ATTRIB(ALT_MAX_ITER, H_MIRROR_BUF_SIZE - 1);

                    h_mirror_buf[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(h_tap_counter)] = h_mirror_buf_AU[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(h_tap_counter)].H_TREE_MUX_CLD(
                                h_kernel_srcs[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_H_TAPS - 1 - h_tap_counter)],
                                h_mirror_buf[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(h_tap_counter + 1)],
                                h_mirror_buf[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(h_tap_counter)],
                                ALT_DONT_EVALUATE(v_value_tautology && READ_COPY(read_enable_i, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt) && !READ_COPY(run_out_of_pixels_this_row, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt)),
                                READ_COPY(read_enable_i, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt) && READ_COPY(run_out_of_pixels_this_row, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt));
                }
                h_mirror_buf[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX((H_MIRROR_BUF_SIZE - 1))] = h_mirror_buf_AU[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX((H_MIRROR_BUF_SIZE - 1))].H_TREE_CLD(
                            h_kernel_srcs[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX(SCL_ALGORITHM_H_TAPS - 1 - (H_MIRROR_BUF_SIZE - 1))],
                            h_mirror_buf[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_PAR_IDX((H_MIRROR_BUF_SIZE - 1))],
                            ALT_DONT_EVALUATE(v_value_tautology && READ_COPY(read_enable_i, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt) && !READ_COPY(run_out_of_pixels_this_row, TIME_TO_CREATE_V_VALUE + calculate_v_value_sequence_cnt)));

            }
        }
    }
#define H_MULT_WIDTH MAX(SCL_COEFFICIENTS_H_BITS, SCL_PRECISION_H_KERNEL_BITS)
 #define H_ADD_WIDTH (SCL_COEFFICIENTS_H_BITS+SCL_PRECISION_H_KERNEL_BITS+SCL_ALGORITHM_LOG2_H_TAPS)
 #define H_ROUND_WIDTH (H_ADD_WIDTH+1)
 #define H_VALUE_WIDTH SCL_BPS
    DECLARE_VAR_WITH_AU(sc_int<ERROR_I_BITS>, ERROR_I_BITS, write_enable_i_error);
    void calculate_h_value_and_output()
    {
        unsigned int sequence_cnt, parallel_cnt;
        unsigned int tree_cnt;
        sc_int<SOME_WIDTH> h_tree_wires[SCL_ALGORITHM_H_TREE_SIZE*SCL_CHANNELS_IN_PAR] BIND(ALT_WIRE);
        ALT_AU<H_ADD_WIDTH> h_tree_AU[SCL_ALGORITHM_H_TREE_SIZE*SCL_CHANNELS_IN_PAR];
        ALT_MULT<H_MULT_WIDTH> h_value_MULT[SCL_ALGORITHM_H_TREE_NUM_MULTS*SCL_CHANNELS_IN_PAR];
        H_TREE_TYPE<H_ADD_WIDTH> h_tree[SCL_ALGORITHM_H_TREE_SIZE*SCL_CHANNELS_IN_PAR] BIND(h_tree_AU);

        ALT_AU<H_ROUND_WIDTH> h_rounded_AU[SCL_CHANNELS_IN_PAR];
        H_TREE_TYPE<H_ROUND_WIDTH> h_rounded[SCL_CHANNELS_IN_PAR] BIND(h_rounded_AU);
        H_TREE_TYPE<H_ROUND_WIDTH> h_divided[SCL_CHANNELS_IN_PAR] BIND(ALT_WIRE);
        ALT_AU<H_VALUE_WIDTH> h_value_AU[SCL_CHANNELS_IN_PAR];
        sc_uint<H_VALUE_WIDTH> h_value[SCL_CHANNELS_IN_PAR] BIND(h_value_AU);

        DECLARE_VAR_WITH_AU(bool, 1, write_enable_i);
        ALT_AU<ERROR_I_BITS, 0> pre_write_enable_i_error_AU;
        bool write_enable_i_error_wrapped BIND(ALT_WIRE);

        // this array of constants holds the description of the addition tree
        // to use, as specified by the defines
        const int h_tree_desc[SCL_ALGORITHM_H_TREE_DESCRIPTION_SIZE * 4] = SCL_ALGORITHM_H_TREE;

        write_enable_i = false;

        for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ; sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ);

            for (parallel_cnt = 0; parallel_cnt < SCL_CHANNELS_IN_PAR; parallel_cnt++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_PAR);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_PAR);

                // multiply and add as specified by SCL_ALGORITHM_H_TREE
                for (tree_cnt = 0; tree_cnt < SCL_ALGORITHM_H_TREE_DESCRIPTION_SIZE; tree_cnt++)
                {
                    ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                    ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_H_TREE_DESCRIPTION_SIZE);
                    ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_H_TREE_DESCRIPTION_SIZE);

                    if (ALT_EVALUATE(TREE_OP_TYPE(h_tree_desc, tree_cnt) == TREE_DEL))
                    {
                        // create a simple delay element
                        h_tree[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_DEL_TO(h_tree_desc, tree_cnt)))] = h_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_DEL_FROM(h_tree_desc, tree_cnt)))];
                        h_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_DEL_TO(h_tree_desc, tree_cnt)))] = h_tree[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_DEL_TO(h_tree_desc, tree_cnt)))];
                    }
                    else if (ALT_EVALUATE(TREE_OP_TYPE(h_tree_desc, tree_cnt) == TREE_ADD))
                    {
                        // add two elements as specified by the addition tree description
                        h_tree[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_ADD_DEST(h_tree_desc, tree_cnt)))] = h_tree_wires[FLAT_CHANNELS_IN_PAR_IDX(ALT_EVALUATE(TREE_ADD_SRC_1(h_tree_desc, tree_cnt)))] + h_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_ADD_SRC_2(h_tree_desc, tree_cnt)))];
                        h_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_ADD_DEST(h_tree_desc, tree_cnt)))] = h_tree[FLAT_CHANNELS_IN_PAR_IDX(ALT_EVALUATE(TREE_ADD_DEST(h_tree_desc, tree_cnt)))];
                    }
                    else
                    {
                        assert(TREE_OP_TYPE(h_tree_desc, tree_cnt) == TREE_MUL);

                        // multiply an element by a coefficient
                        h_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_MUL_DEST(h_tree_desc, tree_cnt)))] = h_value_MULT[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_MUL_SRC(h_tree_desc, tree_cnt)))].H_TREE_MULT(
                                    H_TREE_TYPE<H_MULT_WIDTH>(h_kernel[ALT_EVALUATE(FLAT_CHANNELS_IN_SEQ_PAR_IDX(TREE_MUL_SRC(h_tree_desc, tree_cnt)))]),
                                    H_TREE_TYPE<H_MULT_WIDTH>(these_h_coeffs[ALT_EVALUATE(TREE_MUL_COEFF(h_tree_desc, tree_cnt))]));
                    }
                }

                h_rounded[parallel_cnt] = h_rounded_AU[parallel_cnt].H_TREE_ADD(h_tree[FLAT_CHANNELS_IN_PAR_IDX(SCL_ALGORITHM_H_TREE_RESULT)], H_TREE_TYPE<H_ADD_WIDTH>(1 << (SCL_PRECISION_H_FRACTION_BITS + SCL_PRECISION_V_DIVISION_REMAINDER - 1)));
                h_divided[parallel_cnt] = h_rounded[parallel_cnt] >> (SCL_PRECISION_H_FRACTION_BITS + SCL_PRECISION_V_DIVISION_REMAINDER);

#if SCL_PRECISION_H_SIGNED

                h_value[parallel_cnt] = h_value_AU[parallel_cnt].addSubSLdSClrSI(
                                            h_divided[parallel_cnt],
                                            0,
                                            (1 << SCL_BPS) - 1,
                                            sc_int < MAX(H_ROUND_WIDTH - SCL_BPS, 1) > (h_divided[parallel_cnt] >> SCL_BPS) > sc_int < MAX(H_ROUND_WIDTH - SCL_BPS, 1) > (0),
                                            h_divided[parallel_cnt] < sc_int<H_ROUND_WIDTH>(0),
                                            0);
#else

                h_value[parallel_cnt] = h_value_AU[parallel_cnt].muxLdUI(
                                            h_divided[parallel_cnt],
                                            (1 << SCL_BPS) - 1,
                                            sc_int < H_ROUND_WIDTH - SCL_BPS > (h_divided[parallel_cnt] >> SCL_BPS) > sc_int < H_ROUND_WIDTH - SCL_BPS > (0));
#endif

                if (sequence_cnt == 0 && parallel_cnt == 0)
                {
                	write_enable_i_error_wrapped = write_enable_i_error < sc_int<ERROR_I_BITS>(0) && ALT_DONT_EVALUATE(h_rounded[parallel_cnt].bit(0) || !h_rounded[parallel_cnt].bit(0));

                    write_enable_i_error = write_enable_i_error - pre_write_enable_i_error_AU.muxLdSI(
                                               ERROR_I_INCREMENT,
                                               CORRECTED_ERROR_I_INCREMENT,
                                               write_enable_i_error_wrapped);

#if (SCL_RUNTIME_CONTROL)

                    {
                        write_enable_i = write_enable_i_AU.muxLdUI(ALT_DONT_EVALUATE(write_enable_i_error_wrapped), 1, IS_SCALING_UP_H);
                    }
#else
                    {
#if (IS_SCALING_UP_H)

                        {
                            write_enable_i = ALT_DONT_EVALUATE(h_rounded[parallel_cnt].bit(0) || !h_rounded[parallel_cnt].bit(0));
                        }
#else
                        {
                            write_enable_i = ALT_DONT_EVALUATE(write_enable_i_error_wrapped);
                        }
#endif
                    }
#endif

                }
            }
            if (sequence_cnt == SCL_CHANNELS_IN_SEQ - 1)
            {
                cols_written = cols_written_AU.cAddSubSI(cols_written, 1, cols_written, write_enable_i && write_enable_j, 0);
            }
            if (write_enable_i && write_enable_j)
            {
            if(sequence_cnt == SCL_CHANNELS_IN_SEQ - 1)
            {
#if SCL_CHANNELS_IN_PAR == 1

                dout->writeDataAndEop(h_value[0], cols_written == sc_int<I_BITS>(INTERNAL_OUT_WIDTH) && is_last_row);
#elif SCL_CHANNELS_IN_PAR == 2

                dout->writeDataAndEop((h_value[1], h_value[0]), cols_written == sc_int<I_BITS>(INTERNAL_OUT_WIDTH) && is_last_row);
#else

                dout->writeDataAndEop((h_value[2], h_value[1], h_value[0]), cols_written == sc_int<I_BITS>(INTERNAL_OUT_WIDTH) && is_last_row);
#endif
            }
            else
            {
#if SCL_CHANNELS_IN_PAR == 1

                dout->writeDataAndEop(h_value[0], false);
#elif SCL_CHANNELS_IN_PAR == 2

                dout->writeDataAndEop((h_value[1], h_value[0]), false);
#else

                dout->writeDataAndEop((h_value[2], h_value[1], h_value[0]), false);
#endif            	
            }
            }
        }

    }
#define V_MULT_WIDTH MAX(SCL_COEFFICIENTS_V_BITS, SCL_BPS+SIGN_BIT)
 #define V_ADD_WIDTH (SCL_COEFFICIENTS_V_BITS+SCL_BPS+SCL_ALGORITHM_LOG2_V_TAPS)
 #define V_ROUND_WIDTH (V_ADD_WIDTH+1)
    unsigned int calculate_v_value_sequence_cnt;
    void calculate_v_value()
    {
        unsigned int tree_cnt, parallel_cnt, v_tap_counter;
        sc_int<SOME_WIDTH> v_tree_wires[SCL_ALGORITHM_V_TREE_SIZE*SCL_CHANNELS_IN_PAR] BIND(ALT_WIRE);
        ALT_AU<V_ADD_WIDTH> v_tree_AU[SCL_ALGORITHM_V_TREE_SIZE*SCL_CHANNELS_IN_PAR];
        V_TREE_TYPE<V_ADD_WIDTH> v_tree[SCL_ALGORITHM_V_TREE_SIZE*SCL_CHANNELS_IN_PAR] BIND(v_tree_AU);
        ALT_MULT<V_MULT_WIDTH> v_value_MULT[SCL_ALGORITHM_V_TREE_NUM_MULTS*SCL_CHANNELS_IN_PAR];

        V_TREE_TYPE<V_ROUND_WIDTH> v_divided[SCL_CHANNELS_IN_PAR] BIND(ALT_WIRE);
        ALT_AU < V_VALUE_BITS > v_over_AU[SCL_CHANNELS_IN_PAR];
        V_TREE_TYPE < V_VALUE_BITS > v_over[SCL_CHANNELS_IN_PAR] BIND(v_over_AU);
        ALT_AU<V_ROUND_WIDTH> v_rounded_AU[SCL_CHANNELS_IN_PAR];
        V_TREE_TYPE<V_ROUND_WIDTH> v_rounded[SCL_CHANNELS_IN_PAR] BIND(v_rounded_AU);
        sc_uint<SCL_BPS> v_data[SCL_CHANNELS_IN_PAR*SCL_ALGORITHM_V_TAPS] BIND(ALT_WIRE);

        // this array of constants holds the description of the addition tree
        // to use, as specified by the defines
        const int v_tree_desc[SCL_ALGORITHM_V_TREE_DESCRIPTION_SIZE*4] = SCL_ALGORITHM_V_TREE;

        for (v_tap_counter = 0; v_tap_counter < SCL_ALGORITHM_V_TAPS; v_tap_counter++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TAPS);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TAPS);

            v_data[v_tap_counter] = v_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_IDX(v_tap_counter)].range(SCL_BPS - 1, 0);
#if SCL_CHANNELS_IN_PAR > 1

            v_data[SCL_ALGORITHM_V_TAPS + v_tap_counter] = v_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_IDX( v_tap_counter)].range(SCL_BPS * 2 - 1, SCL_BPS);
#endif
#if SCL_CHANNELS_IN_PAR > 2

            v_data[(SCL_ALGORITHM_V_TAPS*2) + v_tap_counter] = v_kernel[FLAT_CALC_V_VAL_CHANNELS_IN_SEQ_IDX(v_tap_counter)].range(SCL_BPS * 3 - 1, SCL_BPS * 2);
#endif

        }
        // multiply and add as specified by SCL_ALGORITHM_V_TREE
        for (parallel_cnt = 0; parallel_cnt < SCL_CHANNELS_IN_PAR; parallel_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_PAR);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_PAR);

            // multiply and add as specified by SCL_ALGORITHM_V_TREE
            for (tree_cnt = 0; tree_cnt < SCL_ALGORITHM_V_TREE_DESCRIPTION_SIZE; tree_cnt++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TREE_DESCRIPTION_SIZE);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TREE_DESCRIPTION_SIZE);

                if (ALT_EVALUATE(TREE_OP_TYPE(v_tree_desc, tree_cnt) == TREE_DEL))
                {
                    // create a simple delay element
                    assert(ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_DEL_TO(v_tree_desc, tree_cnt))) < SCL_ALGORITHM_V_TREE_SIZE*SCL_CHANNELS_IN_PAR);
                    v_tree[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_DEL_TO(v_tree_desc, tree_cnt)))] = v_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_DEL_FROM(v_tree_desc, tree_cnt)))];
                    v_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_DEL_TO(v_tree_desc, tree_cnt)))] = v_tree[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_DEL_TO(v_tree_desc, tree_cnt)))];
                }
                else if (ALT_EVALUATE(TREE_OP_TYPE(v_tree_desc, tree_cnt) == TREE_ADD))
                {
                    // add two elements as specified by the addition tree description
                    assert(ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_ADD_DEST(v_tree_desc, tree_cnt))) < SCL_ALGORITHM_V_TREE_SIZE*SCL_CHANNELS_IN_PAR);
                    v_tree[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_ADD_DEST(v_tree_desc, tree_cnt)))] = v_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_ADD_SRC_1(v_tree_desc, tree_cnt)))] + v_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_ADD_SRC_2(v_tree_desc, tree_cnt)))];
                    v_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_ADD_DEST(v_tree_desc, tree_cnt)))] = v_tree[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_ADD_DEST(v_tree_desc, tree_cnt)))];
                }
                else
                {
                    assert(TREE_OP_TYPE(v_tree_desc, tree_cnt) == TREE_MUL);

                    // multiply an element by a coefficient
                    assert(ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_MUL_DEST(v_tree_desc, tree_cnt))) < SCL_ALGORITHM_V_TREE_SIZE*SCL_CHANNELS_IN_PAR);
                    v_tree_wires[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_MUL_DEST(v_tree_desc, tree_cnt)))] = v_value_MULT[ALT_EVALUATE(FLAT_CHANNELS_IN_PAR_IDX(TREE_MUL_SRC(v_tree_desc, tree_cnt)))].V_TREE_MULT(
                                V_TREE_TYPE<V_MULT_WIDTH>(v_data[(SCL_ALGORITHM_V_TAPS * parallel_cnt) + ALT_EVALUATE(TREE_MUL_SRC(v_tree_desc, tree_cnt))]),
                                V_TREE_TYPE<V_MULT_WIDTH>(these_v_coeffs[ALT_EVALUATE(TREE_MUL_COEFF(v_tree_desc, tree_cnt))]));
                }
            }

#if SCL_PRECISION_V_DIVISION_BITS > 0
            v_rounded[parallel_cnt] = v_rounded_AU[parallel_cnt].V_TREE_ADD(v_tree[FLAT_CHANNELS_IN_PAR_IDX(SCL_ALGORITHM_V_TREE_RESULT)], V_TREE_TYPE<V_ROUND_WIDTH>(1 << SCL_PRECISION_V_DIVISION_BITS - 1 ));
#else
            v_rounded[parallel_cnt] = v_tree[FLAT_CHANNELS_IN_PAR_IDX(SCL_ALGORITHM_V_TREE_RESULT)];
#endif
            v_divided[parallel_cnt] = v_rounded[parallel_cnt] >> (SCL_PRECISION_V_DIVISION_BITS);
            v_over[parallel_cnt] = v_over_AU[parallel_cnt].V_TREE_MUX_LD(
                                       v_divided[parallel_cnt],
                                       (1 << (SCL_PRECISION_H_KERNEL_BITS - SCL_PRECISION_V_SIGNED)) - 1,
                                       sc_int<2>(v_divided[parallel_cnt] >> (SCL_PRECISION_H_KERNEL_BITS - SCL_PRECISION_V_SIGNED)) > sc_int<2>(0));

#if SCL_PRECISION_V_SIGNED
            v_value[parallel_cnt] = v_value_AU[parallel_cnt].V_TREE_MUX_LD(
                                        v_over[parallel_cnt],
                                        -(1 << (SCL_PRECISION_H_KERNEL_BITS - 1)),
                                        sc_int<2>(v_over[parallel_cnt] >> (SCL_PRECISION_H_KERNEL_BITS - 1)) < sc_int<2>( -1));
#else
            v_value[parallel_cnt] = v_over[parallel_cnt];
#endif

        }
    }
    void check_v_coeffs()
    {
        unsigned int v_tap_counter;
        ALT_AU<SCL_COEFFICIENTS_V_BITS> these_v_coeffs_mirrored_AU[SCL_ALGORITHM_V_TAPS];
        V_COEFF_TYPE these_v_coeffs_mirrored[SCL_ALGORITHM_V_TAPS] BIND(these_v_coeffs_mirrored_AU);
        DECLARE_VAR_WITH_AU(sc_uint < V_OFF_EDGE_WIDTH - 1 > , V_OFF_EDGE_WIDTH, shift_iterations);
        V_COEFF_TYPE these_v_coeffs_old[SCL_ALGORITHM_V_TAPS] BIND(ALT_WIRE);
        V_COEFF_TYPE these_v_coeffs_mirrored_old[SCL_ALGORITHM_V_TAPS] BIND(ALT_WIRE);
        ALT_CMP<V_OFF_EDGE_WIDTH> v_off_edge_CMP;

        bool off_top_edge BIND(ALT_WIRE);

        // Set the mirror coefficients to 0
        for (v_tap_counter = 0; v_tap_counter < SCL_ALGORITHM_V_TAPS; v_tap_counter++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TAPS);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TAPS);
            these_v_coeffs_mirrored[v_tap_counter] = 0;
        }

        v_off_edge = v_off_edge_AU.cAddSubSI(
                         v_off_edge,
                         1,
                         v_off_edge,
                         read_enable_j
                         && (v_off_edge_CMP.ltSI(v_off_edge, 0)
                             ||
                             (run_out_of_pixel_rows)),
                         0);

        read_enable_j = read_enable_j_AU.cLdUI(0, read_enable_j, run_out_of_pixel_rows);

        off_top_edge = v_off_edge_CMP.ltSI(v_off_edge, 0);

        shift_iterations = shift_iterations_AU.muxLdUI(
                               sc_uint < V_OFF_EDGE_WIDTH - 1 > (v_off_edge),
                               sc_uint < V_OFF_EDGE_WIDTH - 1 > ( -v_off_edge),
                               off_top_edge);
        // Shift the actual coefficients
        for (i = 0; sc_uint < V_OFF_EDGE_WIDTH - 1 > (i) < sc_uint < V_OFF_EDGE_WIDTH - 1 > (shift_iterations); i++)
        {
            off_top_edge = v_off_edge_CMP.ltSI(v_off_edge, 0);
            for (v_tap_counter = 0; v_tap_counter < SCL_ALGORITHM_V_TAPS; v_tap_counter++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TAPS);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TAPS);
                these_v_coeffs_mirrored_old[v_tap_counter] = these_v_coeffs_mirrored[v_tap_counter];
                these_v_coeffs_old[v_tap_counter] = these_v_coeffs[v_tap_counter];
            }

            these_v_coeffs_mirrored[0] = these_v_coeffs_mirrored_AU[0].V_COEFF_MUX_LD(
                                             these_v_coeffs_mirrored_old[1],
                                             these_v_coeffs_old[0],
                                             off_top_edge);
            these_v_coeffs[0] = these_v_coeffs_AU[0].V_COEFF_MUX_LD(
                                    these_v_coeffs_old[1],
                                    0,
                                    !off_top_edge);
            for (v_tap_counter = 1; v_tap_counter < SCL_ALGORITHM_V_TAPS - 1; v_tap_counter++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TAPS - 2);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TAPS - 2);

                these_v_coeffs_mirrored[v_tap_counter] = these_v_coeffs_mirrored_AU[v_tap_counter].V_COEFF_MUX_LD(
                            these_v_coeffs_mirrored_old[v_tap_counter + 1],
                            these_v_coeffs_mirrored_old[v_tap_counter - 1],
                            off_top_edge);
                these_v_coeffs[v_tap_counter] = these_v_coeffs_AU[v_tap_counter].V_COEFF_MUX_LD(
                                                    these_v_coeffs_old[v_tap_counter - 1],
                                                    these_v_coeffs_old[v_tap_counter + 1],
                                                    off_top_edge);
            }
            these_v_coeffs_mirrored[SCL_ALGORITHM_V_TAPS - 1] = these_v_coeffs_mirrored_AU[SCL_ALGORITHM_V_TAPS - 1].V_COEFF_MUX_LD(
                        these_v_coeffs_old[SCL_ALGORITHM_V_TAPS - 1],
                        these_v_coeffs_mirrored_old[SCL_ALGORITHM_V_TAPS - 2],
                        off_top_edge);
            these_v_coeffs[SCL_ALGORITHM_V_TAPS - 1] = these_v_coeffs_AU[SCL_ALGORITHM_V_TAPS - 1].V_COEFF_MUX_LD(
                        these_v_coeffs_old[SCL_ALGORITHM_V_TAPS - 2],
                        0,
                        off_top_edge);

        }
        // At the top of a frame, the location of the first line buffer will be moving upwards
        // through the line-buffers. Move the coefficients down to compensate for this.
        if (!v_off_edge_CMP.ltSI(v_off_edge, 0))
        {
            shift_iterations = 0;
        }
        for (i = 0; sc_uint < V_OFF_EDGE_WIDTH - 1 > (i) < sc_uint < V_OFF_EDGE_WIDTH - 1 > (shift_iterations); i++)
        {
            for (v_tap_counter = SCL_ALGORITHM_V_TAPS - 1; v_tap_counter > 0; v_tap_counter--)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TAPS - 1);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TAPS - 1);

                these_v_coeffs_mirrored[v_tap_counter] = these_v_coeffs_mirrored[v_tap_counter - 1];
                these_v_coeffs[v_tap_counter] = these_v_coeffs[v_tap_counter - 1];
            }
            these_v_coeffs_mirrored[0] = 0;
            these_v_coeffs[0] = 0;
        }
        // Use the sum of the two banks of shift regs
        for (v_tap_counter = 0; v_tap_counter < SCL_ALGORITHM_V_TAPS; v_tap_counter++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON)
            ;
            ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TAPS);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TAPS);
            these_v_coeffs[v_tap_counter] = these_v_coeffs[v_tap_counter] + these_v_coeffs_mirrored[v_tap_counter];
        }
    }
    void pointless_initialisation()
    {
        unsigned int v_tap_counter;
        unsigned int h_tap_counter;
        unsigned int sequence_cnt;

        just_read = 0;

        for (h_tap_counter = 0; h_tap_counter < SCL_ALGORITHM_H_TAPS; h_tap_counter++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_H_TAPS);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_H_TAPS);
            these_h_coeffs[h_tap_counter] = these_h_coeffs_AU[h_tap_counter].sClrSI();
        }

        for (v_tap_counter = 0; v_tap_counter < SCL_ALGORITHM_V_TAPS; v_tap_counter++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TAPS);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TAPS);
            these_v_coeffs[v_tap_counter] = these_v_coeffs_AU[v_tap_counter].sClrUI();
        }

        for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR*SCL_ALGORITHM_H_TAPS; sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR*SCL_ALGORITHM_H_TAPS);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR*SCL_ALGORITHM_H_TAPS);

            h_kernel[sequence_cnt] = h_kernel_AU[sequence_cnt].sClrSI();
        }
        for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ*SCL_ALGORITHM_V_TAPS; sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ*SCL_ALGORITHM_V_TAPS);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ*SCL_ALGORITHM_V_TAPS);
            v_kernel[sequence_cnt] = v_kernel_AU[sequence_cnt].sClrUI();
        }
        for (sequence_cnt = 0; sequence_cnt < SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR*H_MIRROR_BUF_SIZE; sequence_cnt++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR*H_MIRROR_BUF_SIZE);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_CHANNELS_IN_SEQ*SCL_CHANNELS_IN_PAR*H_MIRROR_BUF_SIZE);
            h_mirror_buf[sequence_cnt] = h_mirror_buf_AU[sequence_cnt].sClrSI();
        }
    }

    bool error_i_wrapped;
    bool error_i_wrapped_0_latency BIND(ALT_WIRE);
    ALT_AU<ERROR_I_BITS, 0> pre_error_i_AU;
    DECLARE_VAR_WITH_AU(sc_int<ERROR_I_BITS>, ERROR_I_BITS, error_i);
    H_COEFF_TYPE h_coeff_wires[SCL_ALGORITHM_H_TAPS] BIND(ALT_WIRE);

    // We need to call the body processing code twice for scheduling reasons, so
    // a function would be used. But the coefficient array needs to be read and
    // we don't have function arguments and the array cannot be moved outside scale_multitap
    // as C++ does not allow initialised member variables. So split body processing into 2
    // functions for before and after processing the coefficients, call them twice and live
    // with duplicating the coefficient updates.
    void process_body_pre_coeffs()
    {
        unsigned int cpy_counter;
        ALT_CMP<ERROR_I_BITS> error_i_CMP;
        bool error_h_coeff_pos_wrapped_0_latency BIND(ALT_WIRE);
        bool read_enable_tautology BIND(ALT_WIRE);
        sc_uint < H_COEFF_POS_BITS + 1 > h_coeff_reflected;
        sc_uint<H_COEFF_POS_BITS> h_coeff_unreflected;
        error_i_wrapped_0_latency = error_i_CMP.ltSI(error_i, 0);
        error_i_wrapped = error_i_wrapped_0_latency;

        error_i = error_i - pre_error_i_AU.muxLdSI(
                      ERROR_I_INCREMENT,
                      CORRECTED_ERROR_I_INCREMENT,
                      error_i_wrapped_0_latency);

#if (SCL_RUNTIME_CONTROL)

        {
            read_enable_i_0_latency = read_enable_i_AU.muxLdUI(1, error_i_wrapped_0_latency, IS_SCALING_UP_H);
        }
#else
        {
#if (IS_SCALING_UP_H)

            {
                read_enable_i_0_latency = error_i_wrapped_0_latency;
            }
#else
            {
                read_enable_i_0_latency = ALT_DONT_EVALUATE(error_i_wrapped_0_latency || !error_i_wrapped_0_latency);
            }
#endif
        }
#endif

        read_enable_i = read_enable_i_0_latency;

        UPDATE_N_COPIES(read_enable_i, cpy_counter, N_read_enable_i);

        v_advance_kernel();

        read_enable_tautology = ALT_DONT_EVALUATE(READ_COPY(read_enable_i, TIME_TO_CREATE_V_VALUE - TIME_TO_READ_H_COEFF) | !READ_COPY(read_enable_i, TIME_TO_CREATE_V_VALUE - TIME_TO_READ_H_COEFF));
        error_h_coeff_pos_wrapped_0_latency = error_h_coeff_pos < sc_int<ERROR_COEFF_I_BITS>(0) && ALT_DONT_EVALUATE(read_enable_tautology);

        h_coeff_pos = h_coeff_pos + pre_h_coeff_pos_AU.muxLdUI(COEFF_I_INCREMENT,
                      COEFF_I_INCREMENT_PLUS_1,
                      error_h_coeff_pos_wrapped_0_latency);

#if SCL_COEFFICIENTS_H_COEFFS_ARE_SYMMETRIC == 1

        h_coeffs_are_being_reflected = h_coeff_pos > sc_uint<H_COEFF_POS_BITS>(SCL_ALGORITHM_H_PHASES / 2);
        UPDATE_N_COPIES(h_coeffs_are_being_reflected, cpy_counter, N_h_coeffs_are_being_reflected);
        h_coeff_reflected = sc_uint < H_COEFF_POS_BITS + 1 > (1 << H_COEFF_POS_BITS) - h_coeff_pos;
        h_coeff_unreflected = h_coeff_pos;
        h_coeff_access = h_coeff_access_AU.muxLdUI(h_coeff_pos,
                         sc_uint <H_COEFF_POS_BITS>(h_coeff_reflected),
                         h_coeffs_are_being_reflected);
#else

        h_coeff_access = h_coeff_pos;
#endif

        error_h_coeff_pos = error_h_coeff_pos -
                            pre_error_h_coeff_pos_AU.muxLdSI(
                                ERROR_COEFF_I_INCREMENT,
                                CORRECTED_ERROR_COEFF_I_INCREMENT,
                                error_h_coeff_pos_wrapped_0_latency);
    }

    void process_body_post_coeffs()
    {
        unsigned int h_tap_counter;

        for (h_tap_counter = 0; h_tap_counter < SCL_ALGORITHM_H_TAPS; h_tap_counter++)
        {
            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
            ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_H_TAPS);
            ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_H_TAPS);
#if (SCL_COEFFICIENTS_H_COEFFS_ARE_SYMMETRIC)

            {
                these_h_coeffs[h_tap_counter] = these_h_coeffs_AU[h_tap_counter].H_COEFF_MUX_LD(h_coeff_wires[h_tap_counter],
                                                h_coeff_wires[SCL_ALGORITHM_H_TAPS - 1 - h_tap_counter],
                                                READ_COPY(h_coeffs_are_being_reflected, 2));
            }
#else
            {
                these_h_coeffs[h_tap_counter] = h_coeff_wires[h_tap_counter];
            }
#endif

        }
        // Verify that the operations for SCL_COEFFICIENTS_H_COEFFS_ARE_SYMMETRIC haven't messed anything up
#if !defined(__CUSP__) && !SCL_COEFFICIENTS_LOAD_AT_RUNTIME
        long input_h_coeffs[SCL_ALGORITHM_H_PHASES][SCL_ALGORITHM_H_TAPS] = SCL_COEFFICIENTS_H_DATA;
        for (h_tap_counter = 0; h_tap_counter < SCL_ALGORITHM_H_TAPS; h_tap_counter++)
        {
            assert((long)these_h_coeffs[h_tap_counter] == input_h_coeffs[h_coeff_pos][h_tap_counter]);
        }
#endif

        h_advance_kernel_body();

        calculate_h_value_and_output();

    }
    bool kernel_y_is_active;
    V_COEFF_TYPE v_coeff_wires[SCL_ALGORITHM_V_TAPS] BIND(ALT_WIRE);
    DECLARE_VAR_WITH_AU(sc_uint < V_COEFF_ACCESS_BITS > , V_COEFF_ACCESS_BITS, direct_v_coeff_access);
    void register_these_v_coeffs()
    {
        int v_tap_counter;

        if (SCL_COEFFICIENTS_COEFF_ARRAYS_IDENTICAL)
        {
            sc_biguint<SCL_ALGORITHM_V_TAPS * SCL_COEFFICIENTS_V_BITS> v_coeff_repacking_wire BIND(ALT_WIRE);
            direct_v_coeff_access = h_read_bank_offset + v_coeff_access;
            v_coeff_repacking_wire = h_coeffs[direct_v_coeff_access];
            for (v_tap_counter = 0; v_tap_counter < SCL_ALGORITHM_V_TAPS; v_tap_counter++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);

                v_coeff_wires[v_tap_counter] = V_COEFF_TYPE(v_coeff_repacking_wire);
                v_coeff_repacking_wire >>= SCL_COEFFICIENTS_V_BITS;
            }
            for (v_tap_counter = 0; v_tap_counter < SCL_ALGORITHM_V_TAPS; v_tap_counter++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TAPS);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TAPS);
                if (SCL_COEFFICIENTS_V_COEFFS_ARE_SYMMETRIC || SCL_COEFFICIENTS_H_COEFFS_ARE_SYMMETRIC)
                {
                    these_v_coeffs[v_tap_counter] = these_v_coeffs_AU[v_tap_counter].V_COEFF_MUX_LD(v_coeff_wires[v_tap_counter],
                                                    v_coeff_wires[SCL_ALGORITHM_V_TAPS - 1 - v_tap_counter],
                                                    v_coeffs_are_being_reflected);
                }
                else

                {
                    these_v_coeffs[v_tap_counter] = v_coeff_wires[v_tap_counter];
                }
            }
        }
        else
        {
            if (SCL_COEFFICIENTS_V_COEFFS_ARE_SYMMETRIC)
            {
                // If the coefficients are being reflected, then v_coeff_access is already in the right place, we
                // just need to read the taps in reverse order.
                // See constructor for storage order of v_coeffs
                direct_v_coeff_access = direct_v_coeff_access_AU.addSubSLdUI(REAL_N_V_COEFFICIENT_SETS * (SCL_ALGORITHM_V_TAPS - 1) * SCL_COEFFICIENTS_V_BANKS,
                                        v_coeff_access,
                                        v_coeff_access,
                                        !v_coeffs_are_being_reflected,
                                        0);
            }
            else
            {
                direct_v_coeff_access = v_coeff_access;
            }

            for (v_tap_counter = 0; v_tap_counter < SCL_ALGORITHM_V_TAPS; v_tap_counter++)
            {
                ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                ALT_ATTRIB(ALT_MIN_ITER, SCL_ALGORITHM_V_TAPS);
                ALT_ATTRIB(ALT_MAX_ITER, SCL_ALGORITHM_V_TAPS);

                these_v_coeffs[v_tap_counter] = v_coeffs[v_read_bank_offset + direct_v_coeff_access];

                if (SCL_COEFFICIENTS_V_COEFFS_ARE_SYMMETRIC)
                {
                    direct_v_coeff_access = direct_v_coeff_access_AU.addSubUI(direct_v_coeff_access,
                                            REAL_N_V_COEFFICIENT_SETS*SCL_COEFFICIENTS_V_BANKS,
                                            v_coeffs_are_being_reflected);
                }
                else
                {
                    direct_v_coeff_access = direct_v_coeff_access + sc_uint < V_COEFF_ACCESS_BITS >(MULT_BY_N_V_COEFFS(SCL_COEFFICIENTS_V_BANKS));
                }

            }
        }

        // Verify that the operations for SCL_COEFFICIENTS_V_COEFFS_ARE_SYMMETRIC haven't messed anything up
#if !defined(__CUSP__) && !SCL_COEFFICIENTS_LOAD_AT_RUNTIME
        long input_v_coeffs[SCL_ALGORITHM_V_PHASES][SCL_ALGORITHM_V_TAPS] = SCL_COEFFICIENTS_V_DATA;
        for (v_tap_counter = 0; v_tap_counter < SCL_ALGORITHM_V_TAPS; v_tap_counter++)
        {
        	assert((long)these_v_coeffs[v_tap_counter] == input_v_coeffs[v_coeff_pos][v_tap_counter]);
        }
#endif

    }
#if !SCL_COEFFICIENTS_LOAD_AT_RUNTIME
    // Register files are made to have 2 read ports instead of 2 w/r ports. Everything else is as default
    ALT_REGISTER_FILE < -1, 2, 1, -1, 2, 0, 0, ALT_MEM_MODE_AUTO > h_coeffs_REG_FILE;

    ALT_REGISTER_FILE < -1, 2, 1, -1, 2, 0, 0, ALT_MEM_MODE_AUTO > v_coeffs_REG_FILE;

    sc_bigint<SCL_COEFFICIENTS_H_BITS*SCL_ALGORITHM_H_TAPS> h_coeffs[REAL_N_H_COEFFICIENT_SETS] BIND(h_coeffs_REG_FILE);

    V_COEFF_TYPE v_coeffs[REAL_N_V_COEFFICIENT_SETS*SCL_ALGORITHM_V_TAPS] BIND(v_coeffs_REG_FILE);
#endif

    bool is_last_row;
    DECLARE_VAR_WITH_AU(sc_int<I_BITS>, I_BITS, cols_written);
    void scale_multitap()
    {
        unsigned int sequence_cnt;
        unsigned int cpy_counter;

        bool error_j_wrapped BIND(ALT_WIRE);
        bool error_v_coeff_pos_wrapped BIND(ALT_WIRE);
        sc_int<J_BITS> rows_written = 0;
        ALT_AU<ERROR_J_BITS> pre_error_j_AU;
        DECLARE_VAR_WITH_AU(sc_int<ERROR_J_BITS>, ERROR_J_BITS, error_j);

        sc_biguint<SCL_ALGORITHM_H_TAPS * SCL_COEFFICIENTS_H_BITS> h_coeff_repacking_wire BIND(ALT_WIRE);
        sc_biguint<SCL_ALGORITHM_V_TAPS * SCL_COEFFICIENTS_V_BITS> v_coeff_repacking_wire BIND(ALT_WIRE);

        sc_uint<SCL_COEFFICIENTS_H_BANK_OFFSET_BITS> offset_h_coeff_access;

        // This actually runs one ahead of the number of rows read, so that we don't have to calculate CLIP_HEIGHT-1 when
        // bounds checking in runtime mode.
        n_rows_read = 1;
        run_out_of_pixel_rows = 0;
        // v_off_edge measures how far the v_kernel is off the edge of the image. Negative numbers
        // are off the top of the image, positive below.
        v_off_edge = -SCL_ALGORITHM_V_TAPS;

        is_last_row = false;

        pointless_initialisation();

        // This counts where we are in the coefficients array for vertical coeffs.
        // It is incremented before first use so set it to offset -1
        v_coeff_pos = -(COEFF_J_INCREMENT_PLUS_1);
        error_v_coeff_pos = -1;
        
        error_j = ERROR_J_INIT;
        for (j = J_ITERATIONS_INIT; j >= sc_int<J_BITS>(0); j--)
        {
            // Equivalent of i operations above
            error_j_wrapped = error_j < sc_int<ERROR_J_BITS>(0);

            // Don't start calculating the error or writing output until the "centre" of the
            // kernel is on the first row of the image. +1 because we are reading it before
            // incrementing in check_v_coeffs()

            kernel_y_is_active = v_off_edge >= sc_int<V_OFF_EDGE_WIDTH>( -(SCL_ALGORITHM_KERNEL_Y + 1));

            error_j = error_j_AU.cAddSubSI(
                          error_j,
                          pre_error_j_AU.muxLdSI(
                              ERROR_J_INCREMENT,
                              CORRECTED_ERROR_J_INCREMENT,
                              error_j_wrapped
                          ),
                          error_j,
                          kernel_y_is_active,
                          1);

#if (SCL_RUNTIME_CONTROL)

            {
                write_enable_j = write_enable_j_AU.muxLdUI(kernel_y_is_active && error_j_wrapped, kernel_y_is_active, IS_SCALING_UP_V);
                read_enable_j = read_enable_j_AU.muxLdUI(1, error_j_wrapped, IS_SCALING_UP_V);
            }
#else
            {
#if (IS_SCALING_UP_V)

                {
                    write_enable_j = kernel_y_is_active;
                    read_enable_j = error_j_wrapped;
                }
#else
                {
                    write_enable_j = kernel_y_is_active && error_j_wrapped;
                    read_enable_j = ALT_DONT_EVALUATE(kernel_y_is_active || !kernel_y_is_active);
                }
#endif
            }
#endif
            if (write_enable_j)
            {
                rows_written++;
            }
            is_last_row = rows_written == sc_int<J_BITS>(INTERNAL_OUT_HEIGHT);

            error_v_coeff_pos_wrapped = error_v_coeff_pos < sc_int<ERROR_COEFF_J_BITS>(0);
            v_coeff_pos = v_coeff_pos_AU.cAddSubUI(v_coeff_pos,
                                                   pre_v_coeff_pos_AU.muxLdUI(COEFF_J_INCREMENT,
                                                                              COEFF_J_INCREMENT_PLUS_1,
                                                                              error_v_coeff_pos_wrapped),
                                                   v_coeff_pos,
                                                   kernel_y_is_active,
                                                   0);
#if SCL_COEFFICIENTS_V_COEFFS_ARE_SYMMETRIC || (SCL_COEFFICIENTS_COEFF_ARRAYS_IDENTICAL && SCL_COEFFICIENTS_H_COEFFS_ARE_SYMMETRIC)

            v_coeffs_are_being_reflected = v_coeff_pos > sc_uint<V_COEFF_POS_BITS>(SCL_ALGORITHM_V_PHASES / 2);
            v_coeff_access = v_coeff_access_AU.muxLdUI(v_coeff_pos,
                             sc_uint < V_COEFF_POS_BITS + 1 > (1 << V_COEFF_POS_BITS) - v_coeff_pos,
                             v_coeffs_are_being_reflected);
#else

            v_coeff_access = v_coeff_pos;
#endif

            error_v_coeff_pos = error_v_coeff_pos_AU.cAddSubSI(
                                    error_v_coeff_pos,
                                    pre_error_v_coeff_pos_AU.muxLdSI(
                                        ERROR_COEFF_J_INCREMENT,
                                        CORRECTED_ERROR_COEFF_J_INCREMENT,
                                        error_v_coeff_pos_wrapped
                                    ),
                                    error_v_coeff_pos,
                                    kernel_y_is_active,
                                    1);

            register_these_v_coeffs();

            // If the kernel is off the top or bottom of the image, move coefficients around to simulate
            // mirroring in the kernel
            check_v_coeffs();

            write_pos = INTERNAL_IN_WIDTH;
            run_out_of_pixels_this_row = 0;
            read_enable_i = 1;
            INITIALISE_N_COPIES(read_enable_i, 1, cpy_counter, N_read_enable_i);
            pre_fill_h_kernel();
            h_coeff_pos = -(COEFF_I_INCREMENT_PLUS_1);
            error_h_coeff_pos = -1;
            error_i = ERROR_I_INIT;
            write_enable_i_error = ERROR_I_INIT;
            cols_written = 0;
            // Since the linebuffers get fully loaded for mirroring, scaling down
            // can cause there to be no reads (because moving the kernel is being done
            // by coefficient manipulation) and no writes (because error_j says so)
            // If this happens, skip the processing for this line and cut straight
            // to the next iteration.
            if ((write_enable_j || read_enable_j))
            {
                // Process the main body of a line
                for (i = I_ITERATIONS_INIT; i >= sc_int<I_BITS>(0); i--)
                {
#if SCL_RUNTIME_CONTROL
                    ALT_ATTRIB(ALT_MIN_ITER, 32);
#endif

                    ALT_ATTRIB(ALT_MOD_SCHED, ALT_MOD_SCHED_ON);
                    ALT_ATTRIB(ALT_MOD_TARGET, MOD_TARGET);

                    for (sequence_cnt = 0; sequence_cnt < STEP_ITER; sequence_cnt++)
                    {
                        ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);
                        ALT_ATTRIB(ALT_MIN_ITER, STEP_ITER);
                        ALT_ATTRIB(ALT_MAX_ITER, STEP_ITER);

                        process_body_pre_coeffs();

                        offset_h_coeff_access = h_read_bank_offset + h_coeff_access;

                        // Load up the horizontal coefficients
                        h_coeff_repacking_wire = h_coeffs[offset_h_coeff_access];
                        for (unsigned int t = 0; t < SCL_ALGORITHM_H_TAPS; t++)
                        {
                            ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);

                            h_coeff_wires[t] = H_COEFF_TYPE(h_coeff_repacking_wire);
                            h_coeff_repacking_wire >>= SCL_COEFFICIENTS_H_BITS;
                        }

                        process_body_post_coeffs();

                    }
                }
                if (STEP_ITER == 2 && IS_ODD(I_ITERATIONS))
                {
                    process_body_pre_coeffs();

                    offset_h_coeff_access = h_read_bank_offset + h_coeff_access;

                    // Load up the horizontal coefficients
                    h_coeff_repacking_wire = h_coeffs[offset_h_coeff_access];
                    for (unsigned int t = 0; t < SCL_ALGORITHM_H_TAPS; t++)
                    {
                        ALT_ATTRIB(ALT_UNROLL, ALT_UNROLL_ON);

                        h_coeff_wires[t] = H_COEFF_TYPE(h_coeff_repacking_wire);
                        h_coeff_repacking_wire >>= SCL_COEFFICIENTS_H_BITS;
                    }

                    process_body_post_coeffs();
                }

                run_out_of_pixel_rows = run_out_of_pixel_rows_REG.cLdUI(1, run_out_of_pixel_rows, read_enable_j && !(n_rows_read < sc_uint<N_ROWS_READ_WIDTH>(INTERNAL_IN_HEIGHT)));
                n_rows_read = n_rows_read_AU.cAddSubUI(n_rows_read,
                                                       1,
                                                       n_rows_read,
                                                       !run_out_of_pixel_rows && read_enable_j,
                                                       0);
            }
        }
    }
#endif // SCL_ALGORITHM_NAME == POLYPHASE || SCL_ALGORITHM_NAME == BICUBIC

#endif // SYNTH_MODE

    SC_HAS_PROCESS(SCL_NAME);

    SCL_NAME(sc_module_name name_, int control_depth = 0, const char* PARAMETERISATION = "<scalerParams><SCL_NAME>scaler</SCL_NAME><SCL_RUNTIME_CONTROL>0</SCL_RUNTIME_CONTROL><SCL_IN_WIDTH>1024</SCL_IN_WIDTH><SCL_IN_HEIGHT>768</SCL_IN_HEIGHT><SCL_OUT_WIDTH>640</SCL_OUT_WIDTH><SCL_OUT_HEIGHT>480</SCL_OUT_HEIGHT><SCL_BPS>8</SCL_BPS><SCL_CHANNELS_IN_SEQ>3</SCL_CHANNELS_IN_SEQ><SCL_CHANNELS_IN_PAR>1</SCL_CHANNELS_IN_PAR><SCL_ALGORITHM><NAME>POLYPHASE</NAME><V><TAPS>4</TAPS><PHASES>16</PHASES></V><H><TAPS>4</TAPS><PHASES>16</PHASES></H></SCL_ALGORITHM><SCL_PRECISION><V><SIGNED>true</SIGNED><INTEGER_BITS>1</INTEGER_BITS><FRACTION_BITS>7</FRACTION_BITS></V><H><SIGNED>true</SIGNED><INTEGER_BITS>1</INTEGER_BITS><FRACTION_BITS>7</FRACTION_BITS><KERNEL_BITS>9</KERNEL_BITS></H></SCL_PRECISION><SCL_COEFFICIENTS><LOAD_AT_RUNTIME>false</LOAD_AT_RUNTIME><ARE_IDENTICAL>0</ARE_IDENTICAL><V><BANKS>2</BANKS><FUNCTION>LANCZOS_2</FUNCTION><SYMMETRIC>0</SYMMETRIC></V><H><BANKS>2</BANKS><FUNCTION>LANCZOS_2</FUNCTION><SYMMETRIC>0</SYMMETRIC></H></SCL_COEFFICIENTS></scalerParams>") : sc_module(name_), param(PARAMETERISATION)
    {
        din = new ALT_AVALON_ST_INPUT< sc_uint<CHANNEL_WIDTH > >();
        //! Output port
        dout = new ALT_AVALON_ST_OUTPUT< sc_uint<CHANNEL_WIDTH > >();
        
        control = NULL;
        
#ifdef LEGACY_FLOW
#if HAS_CONTROL_PORT        
        control = new ALT_AVALON_MM_RAW_SLAVE <CTRL_INTERFACE_WIDTH, CTRL_INTERFACE_DEPTH>();
        control->setUseOwnClock(false);
#endif
#else
        int bps = ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "scalerParams;SCL_BPS", 8);
        int par = ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "scalerParams;SCL_CHANNELS_IN_PAR", 3);
        din->setDataWidth(bps*par);
        dout->setDataWidth(bps*par);
        din->setSymbolsPerBeat(par);
        dout->setSymbolsPerBeat(par);
        din->enableEopSignals();
        dout->enableEopSignals();
        bool use_control = ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "scalerParams;SCL_RUNTIME_CONTROL", 0);  
        use_control = use_control || ALT_CUSP_SYNTH::extract_from_xml(PARAMETERISATION, "scalerParams;SCL_COEFFICIENTS;LOAD_AT_RUNTIME", 0);  
        if(use_control){
            control = new ALT_AVALON_MM_RAW_SLAVE <CTRL_INTERFACE_WIDTH, CTRL_INTERFACE_DEPTH>();
            control->setUseOwnClock(false);
            control->enableWritePorts();
            control->enableReadPorts();
            control->setDepth(control_depth);
        }
#endif
    	
    	
#ifdef SYNTH_MODE
       
        h_read_bank_offset = 0;
        v_read_bank_offset = 0;

#if !SCL_COEFFICIENTS_LOAD_AT_RUNTIME
#if SCL_ALGORITHM_NAME == POLYPHASE || SCL_ALGORITHM_NAME == BICUBIC

        long input_h_coeffs[SCL_ALGORITHM_H_PHASES * SCL_ALGORITHM_H_TAPS] = SCL_COEFFICIENTS_H_FLATTENED_DATA;
        long input_v_coeffs[SCL_ALGORITHM_V_PHASES * SCL_ALGORITHM_V_TAPS] = SCL_COEFFICIENTS_V_FLATTENED_DATA;

        for (int i = 0; i < REAL_N_H_COEFFICIENT_SETS; i++)
        {
            h_coeffs[i] = input_h_coeffs[i * SCL_ALGORITHM_H_TAPS];
            for (int j = 1; j < SCL_ALGORITHM_H_TAPS; j++)
            {
                sc_bigint<SCL_COEFFICIENTS_H_BITS> this_val = input_h_coeffs[i * SCL_ALGORITHM_H_TAPS + j];
                h_coeffs[i] =
                    (sc_bigint<SCL_COEFFICIENTS_H_BITS*SCL_ALGORITHM_H_TAPS>(this_val) << (j * SCL_COEFFICIENTS_H_BITS)) |
                    h_coeffs[i].range(j * SCL_COEFFICIENTS_H_BITS-1, 0);
            }
        }
#if (!SCL_COEFFICIENTS_COEFF_ARRAYS_IDENTICAL)
        // These don't need parallel access, but they do need to be readable in a reflected way for
        // symmetric coefficients e.g. with 16 phases and symmetry 9 are stored and index 10 (the 11th
        // phase) is really stored at index 6. So you need to be able to move through phases without
        // multiplying by the number of taps. For this reason, vertical coeffs are stores as:
        // {<phase0, tap0>, <phase1, tap0>, ..., <phaseN, tap0>, <phase0, tap1>, <phase1, tap1>, ... }
        for (int i = 0; i < REAL_N_V_COEFFICIENT_SETS; i++)
        {
            for (int j = 0; j < SCL_ALGORITHM_V_TAPS; j++)
            {
                v_coeffs[i + j*REAL_N_V_COEFFICIENT_SETS] = input_v_coeffs[i * SCL_ALGORITHM_V_TAPS + j];
            }
        }
#endif // (!SCL_COEFFICIENTS_COEFF_ARRAYS_IDENTICAL)
#endif // SCL_ALGORITHM_NAME == POLYPHASE || SCL_ALGORITHM_NAME == BICUBIC
#endif //!SCL_COEFFICIENTS_LOAD_AT_RUNTIME
#if HAS_CONTROL_PORT
        SC_THREAD(controlMonitor);
#endif

        SC_THREAD(behaviour);
#endif //SYNTH_MODE

    }

    const char* param;
};
// undefine local macros
#undef SOME_WIDTH
