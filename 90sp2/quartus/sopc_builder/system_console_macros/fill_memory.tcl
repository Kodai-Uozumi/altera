
# The following procedures provide different ways of filling a memory
# with a data pattern.

# Fills the memory starting at address with size times the value
proc fill_memory { master address size value } {
  set values [ list ]
  for { set i 0 } { $i < $size } { incr i } {
    lappend values $value 
  }
  master_write_memory $master $address $values
}

# Zeroes the memory of given size
proc zero_memory { master address size } {
  set values [ list ]
  for { set i 0 } { $i < $size } { incr i } {
    lappend values 0
  }
  master_write_memory $master $address $values
}

# Fills the memory starting at address with a sequential pattern
proc seq_fill_memory { master address size } {
  set values [ list ]
  for { set i 0 } { $i < $size } { incr i } {
    lappend values [ expr $i % 0x100 ] 
  }
  master_write_memory $master $address $values
}


