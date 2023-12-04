FUNCTION stratix_io
						(
							datain,
							ddiodatain,
							oe,
							outclk,
							outclkena,
							inclk,
							inclkena,
							areset,
							sreset,
							delayctrlin
						)
						WITH
						(
						-- PARAMETERS
						OPERATION_MODE,
						DDIO_MODE,
						OPEN_DRAIN_OUTPUT,
						BUS_HOLD,
						OUTPUT_REGISTER_MODE,
						OUTPUT_ASYNC_RESET,
						OUTPUT_POWER_UP,
						OUTPUT_SYNC_RESET,
						TIE_OFF_OUTPUT_CLOCK_ENBLE,
						OE_REGISTER_MODE,
						OE_ASYNC_RESET,
						OE_POWER_UP,
						OE_SYNC_RESET,
						TIE_OFF_OE_CLOCK_ENBLE,
						INPUT_ASYNC_RESET,
						INPUT_POWER_UP,
						INPUT_SYNC_RESET,
						EXTEND_OE_DISABLE,
						SIM_DQS_INPUT_FREQUENCY,
						SIM_DLL_PHASE_SHIFT
						)
						RETURNS
						(
						-- OUTPUTS
						combout,
						regout,
						ddioregout,
						padio,
						dqsundelayedout

						);
