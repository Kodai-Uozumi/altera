------------------------------------------------------------------------------------
-- ALT_CAM_ENCODER.INC
--
-- Header for ALT_CAM_ENCODER function
--
-- (c) Altera Corporation, 2001
------------------------------------------------------------------------------------
FUNCTION alt_cam_encoder	(
								data[WIDTH - 1..0],
								mstart_load,
								clk,
								ena,
								aclr
							)
							WITH
							(
								WIDTH
							)
							RETURNS
							(
								result[WIDTH - 1..0]
							);
