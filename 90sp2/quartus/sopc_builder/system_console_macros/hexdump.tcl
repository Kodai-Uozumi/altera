
# Provides a hexdump procedure for a list of byte values

proc element { l i } {
  return [ lrange $l $i $i ]
}

proc hexdump { values } {
  set address 0
  while { 1 } {
    set bytes_per_line 16
    set current [ lrange $values $address [ expr $address + $bytes_per_line ] ]
    if { [ llength $current ] == 0 } {
      break
    }
    set hex_line ""
    set ascii_line ""
    for { set cur_byte 0 } { $cur_byte < $bytes_per_line } { incr cur_byte } {
      set byte [ element $current $cur_byte ]
      if { [ string length $byte ] == 0 } {
        break
      }
      if { 0 == [ expr $cur_byte % 8 ] } {
        append hex_line "" " "
        append ascii_line "" " "
      }
      append hex_line " " [ format {%02x} $byte ]
      if { $byte >= 0x20 && $byte < 0x7f } {
        set char [ binary format H2 [ format %02x $byte ] ]
        append ascii_line "" $char
      } else {
        append ascii_line "" "."
      }
    }
    puts stdout [format {%08x%-52s%-16s} $address $hex_line $ascii_line ]
    set address [ expr $address + $bytes_per_line ]

  }
}
