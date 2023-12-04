#ifndef __ALT_IRQ_H__
#define __ALT_IRQ_H__

/******************************************************************************
*                                                                             *
* License Agreement                                                           *
*                                                                             *
* Copyright (c) 2003 Altera Corporation, San Jose, California, USA.           *
* All rights reserved.                                                        *
*                                                                             *
* Permission is hereby granted, free of charge, to any person obtaining a     *
* copy of this software and associated documentation files (the "Software"),  *
* to deal in the Software without restriction, including without limitation   *
* the rights to use, copy, modify, merge, publish, distribute, sublicense,    *
* and/or sell copies of the Software, and to permit persons to whom the       *
* Software is furnished to do so, subject to the following conditions:        *
*                                                                             *
* The above copyright notice and this permission notice shall be included in  *
* all copies or substantial portions of the Software.                         *
*                                                                             *
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  *
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,    *
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE *
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER      *
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING     *
* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER         *
* DEALINGS IN THE SOFTWARE.                                                   *
*                                                                             *
* This agreement shall be governed in all respects by the laws of the State   *
* of California and by the laws of the United States of America.              *
*                                                                             *
******************************************************************************/

/*
 * alt_irq.h is the nios2 specific implementation of the interrupt controller 
 * interface.
 */

#include <errno.h>

#include "nios2.h"
#include "alt_types.h"

#ifdef __cplusplus
extern "C"
{
#endif /* __cplusplus */

/*
 * Macros used by alt_irq_enabled
 */

#define ALT_IRQ_ENABLED  1
#define ALT_IRQ_DISABLED 0  

/* 
 * number of available interrupts
 */

#define ALT_NIRQ NIOS2_NIRQ

/*
 * Used by alt_irq_disable_all() and alt_irq_enable_all().
 */

typedef int alt_irq_context;

/*
 * alt_irq_enabled can be called to determine if interrupts are enabled. The
 * return value is zero if interrupts are disabled, and non-zero otherwise.
 */

static ALT_INLINE int ALT_ALWAYS_INLINE alt_irq_enabled (void)
{
  int status;

  NIOS2_READ_STATUS (status);

  return status & NIOS2_STATUS_PIE_MSK; 
}

/*
 * alt_irq_init() is the device initialisation function. This is called at 
 * config time, before any other driver is initialised.
 */

static ALT_INLINE void ALT_ALWAYS_INLINE 
       alt_irq_init (const void* base)
{
  NIOS2_WRITE_IENABLE (0);
  NIOS2_WRITE_STATUS (NIOS2_STATUS_PIE_MSK);
}

/*
 * alt_irq_register() can be used to register an interrupt handler. If the 
 * function is succesful, then the requested interrupt will be enabled upon 
 * return.
 */
 
extern int alt_irq_register (alt_u32 id, 
                             void*   context, 
                             void (*irq_handler)(void*, alt_u32));

/*
 * alt_irq_disable_all() inhibits all interrupts.
 */

static ALT_INLINE alt_irq_context ALT_ALWAYS_INLINE 
       alt_irq_disable_all (void)
{
  alt_irq_context context;

  NIOS2_READ_STATUS (context);
  NIOS2_WRITE_STATUS (0);
  
  return context;
}

/*
 * alt_irq_enable_all() re-enable all interrupts that currently have registered
 * interrupt handlers (and which have not been masked by a call to 
 * alt_irq_disable()).
 */

static ALT_INLINE void ALT_ALWAYS_INLINE 
       alt_irq_enable_all (alt_irq_context context)
{
  NIOS2_WRITE_STATUS (context);
}

/*
 * alt_irq_disable() disables the individual interrupt indicated by "id".
 */

static ALT_INLINE int ALT_ALWAYS_INLINE alt_irq_disable (alt_u32 id)
{
  alt_irq_context  status;
  extern volatile alt_u32 alt_irq_active;

  status = alt_irq_disable_all ();

  alt_irq_active &= ~(1 << id);
  NIOS2_WRITE_IENABLE (alt_irq_active);

  alt_irq_enable_all(status);

  return 0;
}

/*
 * alt_irq_enable() enables the individual interrupt indicated by "id".
 *  
 */

static ALT_INLINE int ALT_ALWAYS_INLINE alt_irq_enable (alt_u32 id)
{
  alt_irq_context  status;
  extern volatile alt_u32 alt_irq_active;

  status = alt_irq_disable_all ();

  alt_irq_active |= (1 << id);
  NIOS2_WRITE_IENABLE (alt_irq_active);

  alt_irq_enable_all(status);

  return 0;
}

#ifndef ALT_EXCEPTION_STACK

/*
 * alt_irq_initerruptable() should only be called from within an ISR. It is used
 * to allow higer priority interrupts to interrupt the current ISR. The input
 * argument, "priority", is the priority, i.e. interrupt number of the current
 * interrupt.
 *
 * If this function is called, then the ISR is required to make a call to
 * alt_irq_non_interruptible() before returning. The input argument to
 * alt_irq_non_interruptible() is the return value from alt_irq_interruptible().
 *
 * Care should be taken when using this pair of functions, since they increasing
 * the system overhead associated with interrupt handling.
 *
 * If you are using an exception stack then nested interrupts won't work, so
 * these functions are not available in that case.
 */

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE alt_irq_interruptible (alt_u32 priority)
{
  extern volatile alt_u32 alt_priority_mask;
  extern volatile alt_u32 alt_irq_active;

  alt_u32 old_priority;

  old_priority      = alt_priority_mask;
  alt_priority_mask = (1 << priority) - 1;

  NIOS2_WRITE_IENABLE (alt_irq_active & alt_priority_mask);

  NIOS2_WRITE_STATUS (1);

  return old_priority; 
}

/*
 * See Comments above for alt_irq_interruptible() for an explanation of the use of this
 * function.
 */

static ALT_INLINE void ALT_ALWAYS_INLINE alt_irq_non_interruptible (alt_u32 mask)
{
  extern volatile alt_u32 alt_priority_mask;
  extern volatile alt_u32 alt_irq_active;

  NIOS2_WRITE_STATUS (0);  

  alt_priority_mask = mask;

  NIOS2_WRITE_IENABLE (mask & alt_irq_active);  
}

#endif

/*
 * alt_irq_pending() returns a bit list of the current pending interrupts.
 * This is used by alt_irq_handler() to determine which registered interrupt
 * handlers should be called.
 */

static ALT_INLINE alt_u32 ALT_ALWAYS_INLINE alt_irq_pending (void)
{
  alt_u32 active;

  NIOS2_READ_IPENDING (active);

  return active;
}

#ifdef __cplusplus
}
#endif /* __cplusplus */

#endif /* __ALT_IRQ_H__ */
