// =============================================================================
// Exceptions throw by alt_ functions
//
// =============================================================================
// do not include this file directly - use alt_cusp.h
// =============================================================================

#ifndef __ALT_CUSP_H
#include "alt_cusp.h"
#endif


#ifndef __ALT_EXCEPTION_H
#define __ALT_EXCEPTION_H

class alt_exception {
    public:
        virtual const char *getMessage() = 0;
        virtual ~alt_exception() {};
};



class alt_exception_eof : virtual public alt_exception {
    public:
        virtual const char *getMessage() { return "End of file reached"; }
        alt_exception_eof() {};
};


class alt_exception_config {
    public:
        virtual const char *getMessage() { return "Configuration error"; } ;
        alt_exception_config() {};
};

class alt_exception_bus_read_error {
    public:
        virtual const char *getMessage() { return "Bus read error"; } ;
        alt_exception_bus_read_error() {};
};

class alt_exception_bus_write_error {
    public:
        virtual const char *getMessage() { return "Bus read error"; } ;
        alt_exception_bus_write_error() {};
};

#endif
