begin_group TimeQuest

begin_group SDC Commands

begin_group Collections

begin_template Registers
set __name [get_registers __listOfWildcards]
end_template

begin_template Ports
set __name [get_ports __listOfWildcards]
end_template

begin_template Keeper (Register + Ports)
set __name [get_keepers __listOfWildcards]
end_template

begin_template Pins (Does not match through |)
set __name [get_pins __listOfWildcards]
end_template

begin_template Pins (Matches leafs, e.g., mycell|q of myhier|mycell|q)
set __name [get_pins -hier __listOfWildcards]
end_template

begin_template Pins (Matches through |)
set __name [get_pins -compat __listOfWildcards]
end_template


begin_template Foreach In Collection
set __collection [__collectionCommand]
foreach_in_collection __object $__collection {
    __statement
}
end_template

begin_template Collection Size
set __collectionSize [get_collection_size __collectionCommand]
end_template

end_group


begin_group Clocks

begin_template Auto-Generated PLL Clocks
derive_pll_clocks
end_template

begin_template Simple 50/50 Clock
create_clock -name __name -period __period [get_ports __port]
end_template

begin_template Simple Virtual Clock
create_clock -name __name -period __period
end_template

begin_template Full Clock
create_clock -name __name -period __period -waveform { __riseEdge __fallEdge } [get_ports __port]
end_template

begin_template Divide-By-2 Clock
create_generated_clock -name __name -divide_by 2 -source __source [get_pins __target]
or
create_generated_clock -name __name -edges {1 3 5} -source __source [get_pins __target]
end_template

begin_template Generated Clock
create_generated_clock -name __name -divide_by|-multiply_by __factor -source __source __targets
or
create_generated_clock -name __name -edges { __firstRise __nextFall __nextRise } -edge_shift { __firstRiseShift __nextFallShift __nextRiseShift } -source __source __targets
end_template

end_group

begin_group Clock Attributes

begin_template Clock Groups
set_clock_groups -exclusive -group __listOfWildcards -group __listOfWildcards
end_template

begin_template Clock Uncertainty
set_clock_uncertainty -setup -from [get_clocks __listOfWildcards] -to [get_clocks __listOfWildcards]
set_clock_uncertainty -hold -from [get_clocks __listOfWildcards] -to [get_clocks __listOfWildcards]
end_template

begin_template Auto-Calculate Uncertainty
derive_clock_uncertainty
end_template

begin_template Clock Latency
set_clock_latency -source -late __value [get_ports __listOfWildcards]
set_clock_latency -source -early __value [get_ports __listOfWildcards]
end_template

end_group


begin_group I/O Delays

begin_template Basic Input Delays
set_input_delay -clock __clock -max __maxValue [get_ports __listOfWildcards]
set_input_delay -clock __clock -min __minValue [get_ports __listOfWildcards]
end_template

begin_template Basic Output Delays
set_output_delay -clock __clock -max __maxValue [get_ports __listOfWildcards]
set_output_delay -clock __clock -min __minValue [get_ports __listOfWildcards]
end_template

end_group


begin_group Exceptions

begin_template False Paths
set_false_path -from [__collectionCommand __listOfWildcards] -to [__collectionCommand __listOfWildcards]
end_template

begin_template Multicycle Paths
# Use -start instead of -end to apply the multicycleFactor to the source clock
set_multicycle_path -setup -end -from [__collectionCommand __listOfWildcards] -to [__collectionCommand __listOfWildcards] __multicycleFactor
set_multicycle_path -hold -end -from [__collectionCommand __listOfWildcards] -to [__collectionCommand __listOfWildcards] __holdMulticycleFactor
end_template

begin_template Minimum/Maximum Delay Paths
set_max_delay -from [__collectionCommand __listOfWildcards] -to [__collectionCommand __listOfWildcards] __value
set_min_delay -from [__collectionCommand __listOfWildcards] -to [__collectionCommand __listOfWildcards] __value
end_template

end_group


end_group


begin_group Scripting

begin_template Basic Multi-Corner Signoff
project_open __project
create_timing_netlist
read_sdc

foreach_in_collection oc [get_available_operating_conditions] {
    set_operating_conditions $oc
    update_timing_netlist

    report_timing -setup -npaths 1
    report_timing -hold -npaths 1
    report_timing -recovery -npaths 1
    report_timing -removal -npaths 1
    report_min_pulse_width -nworst 1
}

delete_timing_netlist
project_close
end_template

end_group


begin_group SDC Cookbook

begin_template Create Base Clocks and PLL Output Clocks Automatically
derive_pll_clocks -create_base_clocks
end_template

begin_template Create Base Clocks Manually and PLL Output Clocks Automatically
# Create a base clock for the PLL input clock
create_clock -name __name -period __period [get_ports __port]
# Create the PLL Output clocks automatically
derive_pll_clocks
end_template

begin_template Create Base Clocks Manually and PLL Output Clocks Manually
# Create a base clock for the PLL input clock
create_clock -name __name -period __period [get_ports __port]
# Create a generated clock for each PLL output clock
create_generated_clock -name __name -divide_by __factor -multiply_by __factor -source __source [get_pins __target] 
# Create additional generated clocks for each PLL output clock
create_generated_clock -name __name -divide_by __factor -multiply_by __factor -source __source [get_pins __target] 
end_template

begin_template 2:1 Clock Muxing
# Create the first input clock to the mux
create_clock -period __period -name __nameOfFirstClock [get_ports __target]
# Create the second input clock to the mux
create_clock -period __period -name __nameOfSecondClock [get_ports __target]
#Cut transfers between __nameOfFirstClock and __nameOfSecondClock
set_clock_groups -exclusive -group {__nameOfFirstClock} -group {__nameOfSecondClock}
end_template

begin_template Externally Switched Clock Constraints
# Create the first input clock on the clock port
create_clock -period __period -name __nameOfFirstClock [get_ports __clockPort]
# Create the second input clock on the same clock port
create_clock -period __period -name __nameOfSecondClock [get_ports __clockPort] -add
# Cut transfers between __nameOfFirstClock and __nameOfSecondClock
set_clock_groups -exclusive -group {__nameOfFirstClock} -group {__nameOfSecondClock}
end_template

begin_template PLL Clock Switchover
# Create the first input clock to the PLL
create_clock -period __period -name __nameOfFirstClock [get_ports __firstClockPort]
# Create the second input clock to the PLL
create_clock -period __period -name __nameOfSecondClock [get_ports __secondClockPort]
# Automatically create clocks for the PLL output 
# The derive_pll_clocks command makes the proper clock constraints for clock-switchover
derive_pll_clocks
end_template

begin_template System Synchronous Input Constraints
# Specify the maximum external clock delay from the external device
set CLKs_max __CLKsMaxValue
# Specify the minimum external clock delay from the external device
set CLKs_min __CLKsMinValue
# Specify the maximum external clock delay to the FPGA
set CLKd_max __CLKdMaxValue
# Specify the minimum external clock delay to the FPGA
set CLKd_min __CLKdMinValue
# Specify the maximum clock-to-out of the external device
set tCO_max __tCOMax
# Specify the minimum clock-to-out of the external device
set tCO_min __tCOMin
# Specify the maximum board delay
set BD_max __BDMax
# Specify the minimum board delay
set BD_min __BDMin
# Create a clock 
create_clock -period __period -name __name [get_ports __port]
# Create the associated virtual input clock
create_clock -period __period -name __virtualClockName
# Create the input maximum delay for the data input to the FPGA that accounts for all delays specified
set_input_delay -clock __virtualClockName -max [expr $CLKs_max + $tCO_max + $BD_max - $CLKd_min] [get_ports __dataPorts]
# Create the input minimum delay for the data input to the FPGA that accounts for all delays specified
set_input_delay -clock __virtualClockName -min [expr $CLKs_min + $tCO_min + $BD_min - $CLKd_max] [get_ports __dataPorts]
end_template 

begin_template System Synchronous Output Constraints
# Specify the maximum external clock delay to the FPGA
set CLKs_max __CLKsMaxValue
# Specify the minimum external clock delay to the FPGA
set CLKs_min __CLKsMinValue
# Specify the maximum external clock delay to the external device
set CLKd_max __CLKdMaxValue
# Specify the minimum external clock delay to the external device
set CLKd_min __CLKdMinValue
# Specify the maximum setup time of the external device
set tSU __tSU
# Specify the minimum setup time of the external device
set tH __tH
# Specify the maximum board delay
set BD_max __BDMax
# Specify the minimum board delay
set BD_min __BDMin
# Create a clock 
create_clock -period __period -name __name [get_ports __port]
# Create the associated virtual input clock
create_clock -period __period -name __virtualClockName
# Create the output maximum delay for the data output from the FPGA that accounts for all delays specified
set_output_delay -clock __virtualClockName -max [expr $CLKs_max + $BD_max - $tSU - $CLKd_min] [get_ports __dataPorts]
# Create the output minimum delay for the data output from the FPGA that accounts for all delays specified
set_output_delay -clock __virtualClockName -min [expr $CLKs_min + $BD_min - $tH - $CLKd_max] [get_ports __dataPorts]
end_template

begin_template tSU, tH, and tCO Constraints
# Specify the clock period
set period __period
# Specify the required tSU
set tSU __tSU
# Specify the required tH
set tH __tH
# Specify the required tCO
set tCO __tCO
# Create a clock
create_clock -period $period -name __name [get_ports __port]
# Create the associated virtual input clock
create_clock -period $period -name __virtualClockName
set_input_delay -clock __virtualClockName -max [expr $period - $tSU] [get_ports __port]
set_input_delay -clock __virtualClockName -min $tH [get_ports __port]
set_output_delay -clock __virtualClockName -max [expr $period - $tCO] [get_ports __port]
end_template 

begin_template Multicycle Clock-to-Clock
# Create the source clock
create_clock -period __period -name __sourceClock [get_ports __port]
# Create the destination clock
create_clock -period __period -name __destinationClock [get_ports __port]
# Set the multicycle from the source clock to the destination clock
set_multicycle_path -from [get_clocks __sourceClock] -to [get_clocks __destinationClock] -setup|hold -start|end __multicycleValue
end_template

begin_template Multicycle Clock-to-Register
# Create the source clock
create_clock -period __period -name __sourceClock [get_ports __port]
# Create the destination clock
create_clock -period __period -name __destinationClock [get_ports __port]
# Set a multicycle exception from a source register clocked by _sourceClock 
# to a destination register __destinationRegisterInputPin
set_multicycle_path -from [get_clocks __sourceClock] -to [get_pins __destinationRegisterInputPin] -setup|hold -start|end __multicycleValue
end_template

begin_template False Path Clock-to-Clock
# Create the source clock
create_clock -period __period -name __sourceClock [get_ports __port]
# Create the destination clock
create_clock -period __period -name __destinationClock [get_ports __port]
# Set a false path exception from source clock _sourceClock 
# to destination clock __destinationClock
set_false_path -from [get_clocks __sourceClock] -to [get_clocks __destinationClock]
end_template

begin_template False Path Clock-to-Register
# Create the source clock
create_clock -period __period -name __sourceClock [get_ports __port]
# Create the destination clock
create_clock -period __period -name __destinationClock [get_ports __port]
# Sets a false path exception from a source register clocked by _sourceClock 
# to a destination register __destinationRegisterInputPin
set_false_path -from [get_clocks __sourceClock] -to [get_pins __destinationRegisterInputPin]
end_template

begin_template JTAG Signal Constraints
# JTAG Signal Constraints constrain the TCK port
create_clock -name tck -period __period [get_ports altera_reserved_tck]
# Cut all paths to and from tck
set_clock_groups -group [get_clocks tck]
# Constrain the TDI port
set_input_delay -clock tck -clock_fall __tdiBoardDelayValue [get_ports altera_reserved_tdi]
# Constrain the TMS port
set_input_delay -clock tck -clock_fall __tmsBoardDelayValue [get_ports altera_reserved_tms]
# Constrain the TDO port
set_output_delay -clock tck -clock_fall __tdoBoardDelayValue [get_ports altera_reserved_tdo]
end_template

end_group

end_group
