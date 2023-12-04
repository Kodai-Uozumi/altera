#Copyright (C)2001-2008 Altera Corporation
#Any megafunction design, and related net list (encrypted or decrypted),
#support information, device programming or simulation file, and any other
#associated documentation or information provided by Altera or a partner
#under Altera's Megafunction Partnership Program may be used only to
#program PLD devices (but not masked PLD devices) from Altera.  Any other
#use of such megafunction design, net list, support information, device
#programming or simulation file, or any other related documentation or
#information is prohibited for any other purpose, including, but not
#limited to modification, reverse engineering, de-compiling, or use with
#any other silicon devices, unless such use is explicitly licensed under
#a separate agreement with Altera or a megafunction partner.  Title to
#the intellectual property, including patents, copyrights, trademarks,
#trade secrets, or maskworks, embodied in any such megafunction design,
#net list, support information, device programming or simulation file, or
#any other related documentation or information provided by Altera or a
#megafunction partner, remains with Altera, the megafunction partner, or
#their respective licensors.  No other licenses, including any licenses
#needed under any third party's intellectual property, are provided herein.
#Copying or modifying any file, or portion thereof, to which this notice
#is attached violates this copyright.






















package cpu_exception;
use Exporter;
@ISA = Exporter;
@EXPORT = qw(
    &create_exception
    &validate_exception
    &get_exception_names
    &get_exception_by_name
    &get_exception_by_name_or_undef
    &get_exception_by_id
    &get_exception_by_id_or_undef
    &get_exception_name
    &get_exception_id
    &get_exception_priority
    &get_exception_sub_priority
    &get_exception_cause_code
    &get_exception_inst_fetch
    &get_exception_record_addr
    &is_exception_higher_priority
    &exception_compare_full_priority

    $RECORD_NOTHING $RECORD_TARGET_PCB $RECORD_DATA_ADDR
);

use cpu_utils;
use strict;













our $RECORD_NOTHING = 0;
our $RECORD_TARGET_PCB = 1;
our $RECORD_DATA_ADDR = 2;






























sub
create_exception
{
    my $props = shift;          # Hash reference with arguments

    validate_hash_keys("exception", $props, 
      ["name","id","priority","sub_priority","cause_code","inst_fetch",
       "record_addr"]) || return undef;

    my $name = not_empty_scalar($props, "name");
    if (!defined($name)) {
        return undef;
    }
    my $id = manditory_int($props, "id");
    if (!defined($id)) {
        return undef;
    }
    my $priority = manditory_int($props, "priority");
    if (!defined($priority)) {
        return undef;
    }
    if ($priority < 0) {
        return &$error("Attempt to create exception '$name'" .
          " with an illegal priority of $priority");
    }
    my $sub_priority = optional_int($props, "sub_priority");
    if ($sub_priority < 0) {
        return &$error("Attempt to create exception '$name'" .
          " with an illegal sub_priority of $sub_priority");
    }

    my $cause_code = $props->{cause_code};

    my $inst_fetch = $props->{inst_fetch};
    if (defined($inst_fetch)) {
        if (($inst_fetch != 0) && ($inst_fetch != 1)) {
            return &$error("Attempt to create exception '$name'" .
              " with an illegal inst_fetch of $inst_fetch");
        }
    } else {

        $inst_fetch = 0;
    }

    my $record_addr = $props->{record_addr};
    if (defined($record_addr)) {
        if (
          ($record_addr != $RECORD_NOTHING) &&
          ($record_addr != $RECORD_TARGET_PCB) &&
          ($record_addr != $RECORD_DATA_ADDR)) {
            return &$error("Attempt to create exception '$name'" .
              " with an illegal record_addr of $record_addr");
        }
    } else {

        $record_addr = $RECORD_NOTHING;
    }



    my $exception = {
        type            => "exception",
        name            => $name,
        id              => $id,
        priority        => $priority,
        sub_priority    => $sub_priority,
        cause_code      => $cause_code,
        inst_fetch      => $inst_fetch,
        record_addr     => $record_addr,
    };

    return $exception;
}




sub
validate_exception
{
    my $exception = shift;

    if (!defined($exception)) {
        return &$error("Exception reference is undefined");
    }

    if ($exception == 0) {
        return &$error("Exception reference is 0");
    }

    my $ref_type = ref($exception);
    if ($ref_type ne "HASH") {
        return &$error("Exception reference is to a $ref_type" .
          " but must be to a HASH");
    }

    my $type = $exception->{type};

    if (!defined($type)) {
        return &$error("Exception hash reference has no" .
            " \"type\" member");
    }

    if ($type ne "exception") {
        return 
          &$error("Exception hash reference has incorrect type"
                  . " of \"$type\"");
    }

    return $exception;
}



sub
get_exception_names
{
    my $exceptions = shift;

    my @names;

    foreach my $exception (@$exceptions) {
        push(@names, get_exception_name($exception));
    }

    my @sorted_names = sort(@names);

    return \@sorted_names;
}



sub
get_exception_by_name
{
    my $exceptions = shift;

    my $name = shift;   # lower-case name (e.g. "arithmetic")

    my $exception = get_exception_by_name_or_undef($exceptions, $name);

    if (defined($exception)) {
        return $exception;
    }
    
    return &$error("Instruction field name $name not found.");
}



sub
get_exception_by_name_or_undef
{
    my $exceptions = shift;

    my $name = shift;   # lower-case name (e.g. "arithmetic")

    foreach my $exception (@$exceptions) {
        if ($name eq get_exception_name($exception)) {
            return $exception;
        }
    }

    return undef;
}



sub
get_exception_by_id
{
    my $exceptions = shift;

    my $id = shift;   # integer id

    my $exception = get_exception_by_id_or_undef($exceptions, $id);

    if (defined($exception)) {
        return $exception;
    }
    
    return &$error("Instruction field ID $id not found.");
}



sub
get_exception_by_id_or_undef
{
    my $exceptions = shift;

    my $id = shift;   # integer id

    foreach my $exception (@$exceptions) {
        if ($id == get_exception_id($exception)) {
            return $exception;
        }
    }

    return undef;
}


sub
get_exception_name
{
    my $exception = shift;

    if (!defined(validate_exception($exception))) {
        return undef;
    }

    return $exception->{name};
}


sub
get_exception_id
{
    my $exception = shift;

    if (!defined(validate_exception($exception))) {
        return undef;
    }

    return $exception->{id};
}


sub
get_exception_priority
{
    my $exception = shift;

    if (!defined(validate_exception($exception))) {
        return undef;
    }

    return $exception->{priority};
}


sub
get_exception_sub_priority
{
    my $exception = shift;

    if (!defined(validate_exception($exception))) {
        return undef;
    }

    return $exception->{sub_priority};
}


sub
get_exception_cause_code
{
    my $exception = shift;

    if (!defined(validate_exception($exception))) {
        return undef;
    }

    return $exception->{cause_code};
}


sub
get_exception_inst_fetch
{
    my $exception = shift;

    if (!defined(validate_exception($exception))) {
        return undef;
    }

    return $exception->{inst_fetch};
}


sub
get_exception_record_addr
{
    my $exception = shift;

    if (!defined(validate_exception($exception))) {
        return undef;
    }

    return $exception->{record_addr};
}





sub
is_exception_higher_priority
{
    my $exception0 = shift;
    my $exception1 = shift;


    return (get_exception_priority($exception0) < 
      get_exception_priority($exception1));
}







sub
exception_compare_full_priority
{
    my $exception0 = shift;
    my $exception1 = shift;


    my $main_pri = 
      get_exception_priority($exception0) <=> 
      get_exception_priority($exception1);
    my $sub_pri =
      get_exception_sub_priority($exception0) <=> 
      get_exception_sub_priority($exception1);

    return ($main_pri == 0) ? $sub_pri : $main_pri;
}

1;
