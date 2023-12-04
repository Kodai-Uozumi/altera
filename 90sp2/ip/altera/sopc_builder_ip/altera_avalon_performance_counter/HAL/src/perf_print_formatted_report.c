
#include "altera_avalon_performance_counter.h"
#include <stdarg.h>
#include <stdio.h>

/****************************************************************

   Print a formatted report summarizing performance-counter activity.  
   
   The report is printed to STDOUT.  At-present, there is no way
   to choose another stream or print to a string.

   You should do this after you call PERF_STOP_MEASURING--but you'll
   be glad to know this routine calls PERF_STOP_MEASURING inside,
   defensively

****************************************************************/
  

 
int perf_print_formatted_report (void* perf_base, 
                                 alt_u32 clock_freq_hertz,
                                 int num_sections, ...)
{
  va_list name_args;
  double total_sec;
  alt_u64 total_clocks;
  alt_u64 section_clocks;
  char* section_name;
  int section_num = 1;

  const char* separator = 
    "+---------------+-----+-----------+---------------+-----------+\n";
  const char* column_header = 
    "| Section       |  %  | Time (sec)|  Time (clocks)|Occurrences|\n";

  PERF_STOP_MEASURING (perf_base);

  va_start (name_args, num_sections);

  total_clocks = perf_get_total_time (perf_base);
  total_sec    = ((double)total_clocks) / clock_freq_hertz;

  // Print the total at the top:
  printf ("--Performance Counter Report--\nTotal Time: %3G seconds  (%lld clock-cycles)\n%s%s%s",
          total_sec, total_clocks, separator, column_header, separator);

  section_name = va_arg(name_args, char*);

  for (section_num = 1; section_num <= num_sections; section_num++)
    {
      section_clocks = perf_get_section_time (perf_base, section_num);

      printf ("|%-15s|%5.3g|%11.5f|%15lld|%11u|\n%s",
              section_name,
              ((((double) section_clocks)) * 100) / total_clocks,
              (((double) section_clocks)) / clock_freq_hertz,
              section_clocks,
              (unsigned int) perf_get_num_starts (perf_base, section_num),
              separator
              );

      section_name = va_arg(name_args, char*);
    }

  va_end (name_args);

  return 0;
}



