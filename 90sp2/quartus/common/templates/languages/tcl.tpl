begin_group Tcl
begin_group Commands
begin_template Append Command
append __var __arg;
end_template

begin_template Binary Format Command
binary format __template __value;
end_template

begin_template Binary Scan Command
binary scan __value __template __var;
end_template

begin_template Catch Command
catch __command __resultVar;
end_template

begin_template Concat Command
concat __list1 __list2;
end_template

begin_template Error Command
error __message __info __code;
end_template

begin_template For Statement
for __initial { __test } __final {
	__statement;
	__statement;
}
end_template

begin_template Foreach Statement
foreach __loopVar __valueList {
	__statement;
	__statement;
}
end_template

begin_template Format Command
format __spec __value1 __value2;
end_template

begin_template Global Command
global __varName1 __varName2;
end_template

begin_template If Elseif Statement
if { __booleanExpr } {
	__statement;
	__statement;

} elseif { __booleanExpr } {
	__statement;
	__statement;

} else {
	__statement;
	__statement;
}
end_template

begin_template If Statement
if { __booleanExpr } {
	__statement;
	__statement;

} else {
	__statement;
	__statement;
}
end_template

begin_template Join Command
joint __list __joinString;
end_template

begin_template Lappend Command
lappend __listVar __arg;
end_template

begin_template Lindex Command
lindex __list __i;
end_template

begin_template Linsert Command
linsert __list __index __arg;
end_template

begin_template List Command
list __arg1 __arg2;
end_template

begin_template Llength Command
llength __list;
end_template

begin_template Lrange Command
lrange __list __i __j;
end_template

begin_template Lreplace Command
lreplace __list __i __j __arg;
end_template

begin_template Lsearch Command
lsearch __mode __list __value;
end_template

begin_template Lsort Command
lsort __switches __list;
end_template

begin_template Procedure Statement
proc __name __params {
	__statement;
	__statement;
	return __value;
}
end_template

begin_template Scan Command
scan __string __format __var;
end_template

begin_template Set Command
set __var __value;
end_template

begin_template Split Command
split __string __splitChars;
end_template

begin_template String Command
string __option __str;
end_template

begin_template Switch Statement
switch __flags __value {
	__case1 {
		__statement;
		__statement;
	}

	__case2 {
		__statement;
		__statement;
	}

	default {
		__statement;
		__statement;
	}
}
end_template

begin_template Unset Command
unset __varName;
end_template

begin_template Upvar Command
upvar __level __varName __localVar;
end_template

begin_template While Statement
while { __booleanExpr } {
	__statement;
	__statement;
}
end_template

end_group
end_group