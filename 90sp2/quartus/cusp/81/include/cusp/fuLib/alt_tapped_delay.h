/*******************************************************************
 *
 * Tapped delay line function unit
 *
 *
 * Notes :
 *  (1) Do not include this file directly - include alt_cusp.h
 *
 *
 * Function Unit Models:
 *
 *
 *
 *******************************************************************/


#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif


#ifndef __ALT_TAPPED_DELAY_H
#define __ALT_TAPPED_DELAY_H

/*******************************************************************
 * Tapped delay function unit and its named static operators
 *******************************************************************/

template <int WIDTH = 16, int MAX_TAP_LENGTH = 128, int TAP_COUNT = 1>
class ALT_TAPPED_DELAY : public ALT_CUSP_SYNTH::FU
{
public:
	// Input type (one element of WIDTH bits)
	typedef typename ALT_FAST_INT_TYPES<WIDTH>::uint in_t;
	
	// Output type (TAP_COUNT elements of WIDTH bits, concatenated together)
	typedef typename ALT_FAST_INT_TYPES<WIDTH * TAP_COUNT>::uint out_t;
	
public:
	// Construct a new tapped delay
	ALT_TAPPED_DELAY()
		:	write_ptr(0),
			read_ptr(0)
	{
		int i;
		for (i = 0; i < WIDTH * TAP_COUNT; i += 32)
			if (i + 31 < WIDTH * TAP_COUNT)
				deadbeef.range(i + 31, i) = 0xDEADBEEF;
			else
				deadbeef.range(WIDTH * TAP_COUNT - 1, i) = 0xDEADBEEF;
		for (i = 0; i < MAX_TAP_LENGTH; ++i)
			databuf[i] = deadbeef;
	}

	// Write a new element into the delay line, changing the data seen by "read"
	void write(in_t data)
	{
		out_t read_data = databuf[read_ptr];
		if (TAP_COUNT > 1)
			databuf[write_ptr].range(WIDTH * TAP_COUNT - 1, WIDTH) =
					read_data.range(WIDTH * (TAP_COUNT-1) - 1, 0);
		databuf[write_ptr].range(WIDTH - 1, 0) = data;
		
		write_ptr = (write_ptr + 1) % MAX_TAP_LENGTH;
		read_ptr  = (read_ptr  + 1) % MAX_TAP_LENGTH;
	}
	
	// Move the write and read pointers along the delay line without replacing
	// old data.
	void shift()
	{
		databuf[write_ptr] = databuf[read_ptr];
		write_ptr = (write_ptr + 1) % MAX_TAP_LENGTH;
		read_ptr  = (read_ptr  + 1) % MAX_TAP_LENGTH;
	}
	
	// Shift the write and read pointers along the delay line, optionally
	// writing new data in
	void writeOrShift(in_t data, bool writenshift)
	{
		if (writenshift)
			write(data);
		else
			shift();
	}

	// Read TAP_COUNT elements from the buffer and concatenate them into a
	// single wide output word.
	// The zeroth element in the word is the oldest data, written tap_length * TAP_COUNT
	//  writes ago, the first is the data written tap_length writes more recently than
	// that and so on.
	// If insufficient writes have been performed for a read to be showing useful
	// data then its value is undefined.
    // (Note: in C simulation, "undefined" is represented by the hexadecimal string
    // 0xDEADBEEF; this is very unlikely to match hardware.)
	const out_t read()
	{
		return databuf[read_ptr];
	}
	
	// Change the tap length of the buffer. The buffer contents are reset to undefined
	// values.
	// If this method is not used, the resulting hardware will be more efficient.
	void setTapLength(unsigned int new_tap_length)
	{
		assert(new_tap_length > 2);
		assert(new_tap_length <= MAX_TAP_LENGTH);
		for (int i = 0; i < MAX_TAP_LENGTH; ++i)
			databuf[i] = deadbeef;
		write_ptr = new_tap_length % MAX_TAP_LENGTH;
		read_ptr  = 0;
	}

private:
	// a buffer containing all the stored data
	out_t databuf[MAX_TAP_LENGTH];
	
	// next location for a write
	int write_ptr;
	
	// next location for a read
	int read_ptr;

	// "undefined" value to fill buffer with
	out_t deadbeef;
} ALT_CUSP_FUNCTIONAL_UNIT("fu:alt_tapped_delay");

#endif
