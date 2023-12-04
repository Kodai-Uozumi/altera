------------------------------------------------------------------
-- altasmi_parallel parameterized megafunction include file
-- Generated with 'clearbox' loader - do not edit
------------------------------------------------------------------
FUNCTION altasmi_parallel (
	addr[23..0],
	bulk_erase,
	clkin,
	datain[7..0],
	fast_read,
	rden,
	read,
	read_rdid,
	read_sid,
	read_status,
	sector_erase,
	sector_protect,
	shift_bytes,
	wren,
	write
)
WITH (
	EPCS_TYPE,
	PAGE_SIZE,
	PORT_BULK_ERASE,
	PORT_FAST_READ,
	PORT_ILLEGAL_ERASE,
	PORT_ILLEGAL_WRITE,
	PORT_RDID_OUT,
	PORT_READ_ADDRESS,
	PORT_READ_RDID,
	PORT_READ_SID,
	PORT_READ_STATUS,
	PORT_SECTOR_ERASE,
	PORT_SECTOR_PROTECT,
	PORT_SHIFT_BYTES,
	PORT_WREN,
	PORT_WRITE,
	USE_EAB
)
RETURNS (
	busy,
	data_valid,
	dataout[7..0],
	epcs_id[7..0],
	illegal_erase,
	illegal_write,
	rdid_out[7..0],
	read_address[23..0],
	status_out[7..0]
);
