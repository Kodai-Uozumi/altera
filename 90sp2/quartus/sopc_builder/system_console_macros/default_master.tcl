
# The following procedures assume that there's only one master available
# in the device. They just take the first master that is returned by
# get_service_paths. In systems with only one controllable master, the
# first master will be that. In systems with more than one controllable
# master, the outcome is undetermined. Feel free to use these procedures
# with systems that contain only one controllable master 

# Returns the first master in the system.
proc get_default_master {} {
	return [ lindex [ get_service_paths master ] 0 ]
}

# Write the list of byte values starting at address using the default
# master
proc write_memory { address values } {
  set p0 [ get_default_master ]
  master_write_memory $p0 $address $values
}

proc write_8 { address values } {
  set p0 [ get_default_master ]
  master_write_8 $p0 $address $values
}

proc write_16 { address values } {
  set p0 [ get_default_master ]
  master_write_16 $p0 $address $values
}

proc write_32 { address values } {
  set p0 [ get_default_master ]
  master_write_32 $p0 $address $values
}

# Read size number of bytes starting at address using the default
# master
proc read_memory { address size } {
  set p0 [ get_default_master ]
  return [ master_read_memory $p0 $address $size ]
}

proc read_8 { address size } {
  set p0 [ get_default_master ]
  return [ master_read_8 $p0 $address $size ]
}

proc read_16 { address size } {
  set p0 [ get_default_master ]
  return [ master_read_16 $p0 $address $size ]
}

proc read_32 { address size } {
  set p0 [ get_default_master ]
  return [ master_read_32 $p0 $address $size ]
}
