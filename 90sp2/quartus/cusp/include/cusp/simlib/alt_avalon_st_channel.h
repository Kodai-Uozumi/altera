/*******************************************************************
 * 
 * Avalon Streaming Channel  
 * 
 * SIMULATION
 * 
 * Avalon streaming channels are characterised as as either a input or an 
 * output. Data passes across Avalon streaming channels in
 * a series of packets. Packets may range in size from 1 word to N words.
 * 
 * Avalon streaming channels are point-to-point communication channels with 
 * handshaking.
 * 
 * To assist simulation we provide three simulation models:
 * 
 * 	   alt_avalon_st_point_to_point_channel
 * 	   alt_avalon_st_file_to_point_channel
 *     alt_avalon_st_point_to_file_channel
 * 
 * The _point_to_point_ simulation model is the simplest and may be used to
 * connect two modules that have alt_avalon_st_input_channel/_SOURCE ports.
 * 
 * The _file_to_point_ model takes in its constructor a file name and uses this
 * to generate data for the channel. It may be connected to an AVALON_ST_INPUT.
 * 
 * The _point_to_file_ model takes in its constructor a file name and uses this
 * as the destination for any data placed in the channel. It may be connected
 * to an AVALON_ST_OUTPUT
 * 
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
#include <alt_cusp.h>
#endif


#ifndef __ALT_AVALON_ST_CHANNEL_H
#define __ALT_AVALON_ST_CHANNEL_H

#define ALT_AVALON_ST_CHANNEL_DEFAULT_TYPE sc_biguint<512>

template <class T = ALT_AVALON_ST_CHANNEL_DEFAULT_TYPE > 
class alt_avalon_st_channel : public sc_prim_channel 
{
	public:
		virtual alt_avalon_st_output_channel<T> &getInput() ALT_CUSP_SYNTH_MODE(native) = 0;
		virtual alt_avalon_st_input_channel<T> &getOutput() ALT_CUSP_SYNTH_MODE(native) = 0;

		alt_avalon_st_channel() : sc_prim_channel(sc_gen_unique_name("atlantic")) {}
		alt_avalon_st_channel(const char * channelName) : sc_prim_channel(channelName) {}

		virtual ~alt_avalon_st_channel() {}
} ALT_CUSP_FUNCTIONAL_UNIT("mode:channel;bus:avalon_streaming");




// ==============================================================================================================================
// ==============================================================================================================================
// ==============================================================================================================================
// ==============================================================================================================================
// ==============================================================================================================================
//
//              POINT-TO-FILE CHANNEL MODEL
//
// ==============================================================================================================================
// ==============================================================================================================================

template <class T = ALT_AVALON_ST_CHANNEL_DEFAULT_TYPE > class alt_avalon_st_point_to_file_channel : public alt_avalon_st_channel<T>
{
private:
	class alt_avalon_st_channel_source : public alt_avalon_st_output_channel<T>
	{
	private:
		ofstream _sinkFile;
		const char *_destinationFileName;
		bool _oneEntryPerLine;
    bool _noFile;

	public:
		virtual void write(const T & data, unsigned int sideband)
		{
			_sinkFile << data;
			if (_oneEntryPerLine)
				_sinkFile << endl;
			_sinkFile.flush();                
		}

		virtual void waitForChange(void) { sc_core::wait(1,SC_MS); }

		virtual bool hasSpaceAvail(void)
		{
      if (_noFile == true)
      {
        return false;
      }
      else
      {
			  return true;
      }
		}

		alt_avalon_st_channel_source(const char *channelName, const char *destinationFileName) 
		{
			_destinationFileName = destinationFileName;
			_oneEntryPerLine = true;
      _noFile = true;
			_sinkFile.open(_destinationFileName, ios::out | ios::trunc );
			if (!_sinkFile.is_open())
			{ 
				cout << "Failed to open file : "<< _destinationFileName << endl;
			}
      else
      {
        _noFile = false;
      }
		}

	};

	alt_avalon_st_channel_source _source;

public:

	const char *_destinationFileName;
	const char *_channelName;

	alt_avalon_st_output_channel<T > &getInput() { return _source; };
	alt_avalon_st_input_channel<T > &getOutput() 
	{ 
		cout <<"ERROR: Trying to get sink end of a channel to file"<<endl; 
    fflush(stdout);
		throw new alt_exception_config(); 
	}

	alt_avalon_st_point_to_file_channel(const char * channelName, const char *destinationFileName) 
	  : alt_avalon_st_channel< T >(channelName), _source(channelName, destinationFileName),
	    _destinationFileName(destinationFileName), _channelName(channelName)
	{
	}

	virtual ~alt_avalon_st_point_to_file_channel() {};
	
};

// ==============================================================================================================================
// ==============================================================================================================================
// ==============================================================================================================================
// ==============================================================================================================================
// ==============================================================================================================================
//
//              FILE-TO-POINT CHANNEL MODEL
//
// ==============================================================================================================================
// ==============================================================================================================================

template <class T = ALT_AVALON_ST_CHANNEL_DEFAULT_TYPE > class alt_avalon_st_file_to_point_channel : public alt_avalon_st_channel< T >
{
private:	
	class alt_avalon_st_channel_sink : public alt_avalon_st_input_channel<T>
	{
	private:

		ifstream _sourceFile;
		const char *_sourceFileName;
    bool  _noFile;

	public:
		virtual T read(unsigned int & sideband)
		{ 
			if ( EOF == _sourceFile.peek() )
			{
        while(1)
        {
          sc_core::wait(1,SC_MS);
        }
			}
			T data;
			_sourceFile >> data;
			sideband = 0;
			return data;
		}
		
		virtual void waitForChange(void) { sc_core::wait(1,SC_MS); }

		virtual bool hasDataAvail(void)
		{
      if (_noFile == true){
        return false;
      }
			else if (_sourceFile.peek() == EOF){
				return false;
			}
			else{
				return true;
			}
		}
			
		alt_avalon_st_channel_sink(const char *channelName, const char *sourceFileName) 
		{
      _noFile = true;
			_sourceFileName = sourceFileName;
			_sourceFile.open(_sourceFileName, ios::in );
			if (!_sourceFile.is_open())
			{
				cout << "Failed to open file : "<< _sourceFileName << endl;
			}
      else
      {
        _noFile = false;
      }
		}
	};

	alt_avalon_st_channel_sink _sink;

public:

	const char *_sourceFileName;
	const char *_channelName;

	alt_avalon_st_output_channel<T > &getInput() 
	{ 
		cout <<"ERROR: Trying to get source end of a channel to file"<<endl; 
    fflush(stdout);
		throw new alt_exception_config(); 
	}

	alt_avalon_st_input_channel<T > &getOutput() { return _sink; };

	alt_avalon_st_file_to_point_channel(const char * channelName, const char *sourceFileName) 
	  : alt_avalon_st_channel<T>(channelName), _sink(channelName, sourceFileName),
	    _sourceFileName(sourceFileName), _channelName(channelName)
	{
	}

};



// ==============================================================================================================================
// ==============================================================================================================================
// ==============================================================================================================================
// ==============================================================================================================================
// ==============================================================================================================================
//
//              POINT-TO-POINT CHANNEL MODEL
//
// ==============================================================================================================================
// ==============================================================================================================================

template <class T = ALT_AVALON_ST_CHANNEL_DEFAULT_TYPE > class alt_avalon_st_point_to_point_channel : public alt_avalon_st_channel<T>
{
	private:	
		class alt_avalon_st_channel_sink : public alt_avalon_st_input_channel<T >
		{
		private:
			alt_avalon_st_point_to_point_channel<T > &_channel;

		public:
			virtual T read(unsigned int & sideband) { return _channel.read(sideband); }
			virtual bool hasDataAvail(void) { return _channel.hasDataAvail(); }
			virtual void waitForChange(void) { _channel.waitForChange(); }
			alt_avalon_st_channel_sink(alt_avalon_st_point_to_point_channel<T> &channel) : _channel(channel) {}
		};
	
		class alt_avalon_st_channel_source : public alt_avalon_st_output_channel<T >
		{
		private:
			alt_avalon_st_point_to_point_channel<T > &_channel;

		public:
			virtual void write(const T & data, unsigned int sideband) { _channel.write(data, sideband); }
			virtual bool hasSpaceAvail(void) { return _channel.hasSpaceAvail(); }
			virtual void waitForChange(void) { _channel.waitForChange(); }
			alt_avalon_st_channel_source(alt_avalon_st_point_to_point_channel<T > &channel) : _channel(channel) {}
		};

	T * _fifo;
	unsigned int * _sideFifo;
	unsigned int _fifoDepth;
	unsigned int _inptr;
	unsigned int _outptr;
	unsigned int _used;
	bool _readerWaiting;
	bool _writerWaiting;
	const char *_channelName;
	sc_event _inEvent, _outEvent;

	alt_avalon_st_channel_sink _sink;
	alt_avalon_st_channel_source _source;

public:
	alt_avalon_st_output_channel<T> &getInput() { return _source; };
	alt_avalon_st_input_channel<T> &getOutput() { return _sink; };

	alt_avalon_st_point_to_point_channel(unsigned int depth = 128) 
	  : alt_avalon_st_channel<T>(sc_gen_unique_name("atlantic_channel")), _sink(*this), _source(*this)
	{
		_fifoDepth = depth + 1;
		_fifo = new T[_fifoDepth];
		_sideFifo = new unsigned int[_fifoDepth];
		_inptr = 0;
		_outptr = 0;
		_used = 0;
		_readerWaiting = false;
        _writerWaiting = false;
		_channelName = alt_avalon_st_channel<T>::name();
	}

	alt_avalon_st_point_to_point_channel(const char * channelName, unsigned int depth = 128) 
	  : alt_avalon_st_channel<T>(channelName), _sink(*this), _source(*this)
	{
		_fifoDepth = depth + 1;
		_fifo = new T[_fifoDepth];
		_sideFifo = new unsigned int[_fifoDepth];
		_inptr = 0;
		_outptr = 0;
		_used = 0;
		_readerWaiting = false;
        _writerWaiting = false;
		_channelName = channelName;
	}

	T read(unsigned int & sideband)
	{
		// wait for data to be in the fifo
		_readerWaiting = true;
		notify(_outEvent);
		while (_used == 0)
		{
			sc_core::wait(_inEvent);
		}
		_readerWaiting = false;

		T data = _fifo[_outptr];
		sideband = _sideFifo[_outptr];
		_outptr = (_outptr + 1) % _fifoDepth;
		_used--;

		return data;
	}

	void write(const T & data, unsigned int sideband)
	{
		int next_inptr = (_inptr + 1) % _fifoDepth;

		// consider there to be one extra space in the fifo if
		// there is a reader thread waiting for data right now
		// which will pull the data out as soon as we put it in
		// this allows depth zero fifos to work
		_writerWaiting = true;
		while (_used == (_fifoDepth - ((_readerWaiting) ? 0 : 1)))
		{
			sc_core::wait(_outEvent);
		}
		_writerWaiting = false;

		_fifo[_inptr] = data;
		_sideFifo[_inptr] = sideband;
		_inptr = next_inptr;

		_used++;
		notify(_inEvent);
	}

	bool hasDataAvail(void)
	{
		return ((_used != 0) || _writerWaiting);
	}

	bool hasSpaceAvail(void)
	{
		return (_used != (_fifoDepth - ((_readerWaiting) ? 0 : 1)));
	}

	void waitForChange(void)
	{
		sc_core::wait(_inEvent | _outEvent);
	}
	
} ALT_CUSP_FUNCTIONAL_UNIT("mode:channel;bus:avalon_streaming");

#endif //__ALT_AVALON_ST_CHANNEL_H
