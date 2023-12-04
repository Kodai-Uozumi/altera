/*******************************************************************
 * 
 * Overlay emulation for the simulation environment
 * 
 * 
 * 
 * Abbreviations:
 *  None.
 * 
 * 
 * Notes:
 *  (1) Do not include this file directly - use alt_cusp.h
 * 
 * 
 * ALT_OVERLAY provides the following operations for simulation and synthesis :
 * (1) ALT_OVERLAY
 * 
 *******************************************************************/
 
 
#ifndef __ALT_CUSP_H
#include <alt_cusp.h>
#endif

#ifndef __ALT_OVERLAY_H
#define __ALT_OVERLAY_H

//--------------------------------------------------------------------
// ALT_OVERLAY
//--------------------------------------------------------------------

#ifndef _MSC_VER
//#define ALT_OVERLAY(default_overlay, ...) SC_THREAD(default_overlay)
#else
// overlays are not supported when using Microsoft visual studio
#endif

#endif
