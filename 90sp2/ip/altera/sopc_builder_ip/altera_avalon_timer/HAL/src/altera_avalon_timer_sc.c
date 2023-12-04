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
* Altera does not recommend, suggest or require that this reference design    *
* file be used in conjunction or combination with any other product.          *
******************************************************************************/

#include <string.h>

#include "sys/alt_alarm.h"
#include "sys/alt_irq.h"

#include "altera_avalon_timer.h"
#include "altera_avalon_timer_regs.h"

#include "alt_types.h"
#include "sys/alt_log_printf.h"

/* 
 * alt_avalon_timer_sc_irq() is the interrupt handler used for the system 
 * clock. This is called periodically when a timer interrupt occurs. The 
 * function first clears the interrupt condition, and then calls the 
 * alt_tick() function to notify the system that a timer tick has occurred.
 *
 * alt_tick() increments the system tick count, and updates any registered 
 * alarms, see alt_tick.c for further details.
 */

static void alt_avalon_timer_sc_irq (void* base, alt_u32 id)
{
  /* clear the interrupt */

  IOWR_ALTERA_AVALON_TIMER_STATUS (base, 0);

  /* ALT_LOG - see altera_hal/HAL/inc/sys/alt_log_printf.h */
  ALT_LOG_SYS_CLK_HEARTBEAT();

  /* notify the system of a clock tick */
  alt_tick ();
}

/*
 * alt_avalon_timer_sc_init() is called to initialise the timer that will be 
 * used to provide the periodic system clock. This is called from the 
 * auto-generated alt_sys_init() function.
 */

void alt_avalon_timer_sc_init (void* base, alt_u32 irq, alt_u32 freq)
{
  /* set the system clock frequency */
  
  alt_sysclk_init (freq);
  
  /* set to free running mode */
  
  IOWR_ALTERA_AVALON_TIMER_CONTROL (base, 
            ALTERA_AVALON_TIMER_CONTROL_ITO_MSK  |
            ALTERA_AVALON_TIMER_CONTROL_CONT_MSK |
            ALTERA_AVALON_TIMER_CONTROL_START_MSK);

  /* register the interrupt handler, and enable the interrupt */
    
  alt_irq_register (irq, base, alt_avalon_timer_sc_irq);    
}
