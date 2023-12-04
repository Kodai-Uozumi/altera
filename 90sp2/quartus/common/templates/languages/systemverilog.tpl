begin_group SystemVerilog
begin_group Constructs
begin_group Design Units
begin_template Package Declaration
package <name>;

	// Parameter Declaration(s)
	// Function Declaration(s)
	// Task Declarations(s)
	// Type Declaration(s)

endpackage	

// You can refer to specific objects in a package by name
<package_name>::<object_name>

// You can also import objects from a package into the current scope
// using an import declaration
import <package_name>::<object_name>;
import <package_name>::*;         
end_template
begin_group Interfaces
begin_template Interface Declaration
interface <interface_name>(<port_list>);

	// Variable Declaration(s)
	// Modport Declaration(s)
	// Function/Task Declaration(s)
	// Always Construct(s)
	// Generate(s)

	// An interface cannot instantiate a module but it may
	// instantiate an interface

endinterface
end_template
begin_template Modport Declaration
// A modport limits the access to the objects in an interface.  Each port
// must correspond to an object in the enclosing interface.  
modport <modport_name>(<port_list>);

// Examples
modport slave(input clk, input sel, output byte data);
modport master(input clk, output sel, input byte data);
end_template
begin_template Interface Port Declarations
// Both modules and interfaces may declare interface ports.  

// An interface port may refer to a specific interface and/or modport
<interface_name> <port_name>
<interface_name>.<modport_name> <port_name>

// A generic interface port will be bound to a specific interface
// and/or modport during instantiation.  As a result, the top-level
// module in your design cannot contain a generic interface port.
interface <port_name>
end_template
end_group
begin_template Extern Module Declaration
// An extern module declaration specifies the module's parameters
// and ports.  It provides a prototype for a module that does not
// depend directly on the module declaration.  
extern module <module_name> #(<parameters>) (<ports>);
end_template
end_group
begin_group Declarations
begin_group Type Declarations
begin_template Integer Type Declaration
// Built-in integer vector types.  By default, these types
// are signed.  You can explicitly declare them as unsigned or
// signed by adding the appropriate keyword after the type.
// These types have implicit bounds of [Size - 1 : 0].  2-state
// types support the bit values of {0,1}. 4-state types support
// {0,1,X,Z}.  If you assign a value of X or Z to a 2-state
// type, the value will be treated as 0.

Type            Size         States

integer         32             4
int             32             2
shortint        16             2
longint         64             2
byte             8             2

// Examples
int an_int = -37;
int unsigned an_unsigned_int = 37;
byte packet;

// Built-in integer atom types.  You can use them to declare 
// signed or unsigned vectors of arbitrary size.  By default,
// these types are unsigned unless you explicitly declare them
// as signed.

Type            Size        States

reg              1             4
logic            1             4
bit              1             2

// Examples

logic signed [31:0] an_integer_variable;
bit signed [31:0] an_int_variable;
bit [31:0] an_unsigned_int_variable;
end_template
begin_template Struct Type Declaration
typedef struct { 
	// Member Declaration(s)
} <type_name>;

struct { 
	// Member Declaration(s)
} <variable_name>;

// Packed structs can be treated as vectors with the range
// [N-1:0], where N is the total number of bits in the type.
// A packed struct can contain struct members, but they must
// also be packed.
struct packed {
	// Member Declaration(s)
} <variable_name>;

// Examples
typedef struct { int x, y, z; } coordinate_t;
struct { int x, y, z; } coordinate = '{ -1, -1, -1 };

// packed_coordinate[31:0]  == packed_coordinate.z
// packed_coordinate[63:32] == packed_coordinate.y
// packed_coordinate[95:64] == packed_coordinate.x
struct packed { int x, y, z; } packed_coordinate;
end_template
begin_template Enum Type Declaration
typedef enum <optional_base_type> {
	// Enum Literals
} <type_name>;

enum <optional_base_type> { 
	// Enum Literals
} <variable_name>;

// You can declare a single enum literal or multiple enum literals
// with a single construct.  If you don't assign an enum literal a 
// value, it is automatically assigned a value by incrementing the
// previous enum literal's value.  If the first literal has no
// explicit value, it is assigned the value 0.   

// Declare a single enum literal
<literal_name>
<literal_name> = <constant_expression>

// Declare multiple enums
<literal_name>[<num>]
<literal_name>[<num>] = <constant_expression>
<literal_name>[<begin>:<end>]
<literal_name>[<begin>:<end>] = <constant_expression>

// Examples

// Implicit base type (int)
// A == 0, B0 == 1, B1 == 2, C3 == 3, C4 == 4
typedef enum { A, B[2], C[3:4] } enum_t;  

// Explicit base type
typedef enum bit [3:0] { X = 4'ha, Y = 4'hb, Z = 4'hc } enum_t;

// Quartus II will infer state machines from enum types when possible
// but the type must be unsigned.  The implicit base type for 
// an enum is 'int', a signed type.
typedef enum int unsigned { S0, S1, S2, S3, S4 } state_t;
end_template
end_group
begin_template Function Declaration
// A function must execute in a single simulation cycle; therefore, it 
// cannot contain timing controls or tasks.  You set the return value of a 
// function by assigning to the function name as if it were a variable or
// by using the return statement. SystemVerilog allows you to specify default 
// values for function arguments.  In addition, functions may contain input 
// and inout arguments, and the return type of a function may be void.

function <func_return_type> <func_name>(<arg_decls>);
	// Optional Block Declarations
	// Statements
endfunction

// Examples

function int add(int a, int b = 1);
	return a + b;
endfunction
end_template
begin_template Task Declaration
// A task may have input, output, and inout arguments.  It may also
// contain timing controls.  A task does not return a value and, thus, 
// may not be used in an expression.  SystemVerilog allows you to
// specify default values for task arguments.  

task <task_name>(<arg_decls>);
	// Optional Block Declarations
	// Statements
endtask
end_template
begin_template Package Import Declaration
// Import declaration(s) from a package into the current scope.  You can
// import a specific object or all objects.  
import <package_identifier>::<object_name>;
import <package_identifier>::*;
end_template
end_group
begin_group Module Items
begin_template always_comb Construct
// This construct should be used to infer purely combinational logic.
always_comb
begin
	// Statements
end
end_template
begin_template always_latch Construct
// This construct should be used to infer latched logic.  
always_latch
begin
	// Statements
end
end_template
begin_template always_ff Construct
// This construct should be used to infer sequential logic such as
// registers and state machines.
always_ff@(<edge_events>)
begin
	// Statements
end
end_template
end_group
begin_group Sequential Statements
begin_group Loops
begin_template For Loop
for(<for_init>; <expression>; <for_step>)
begin
	// Statements
end	

// <for_init> may set the value for multiple variables.
// Likewise, <for_step> may update the value of multiple variables.

for(i = 0, i2 = 0; i < 8; i++, i2 *= 8)
begin
	// Statements
end
end_template
begin_template Do...While Loop
do 
begin
	// Statements
end 
while(<expression>);
end_template
end_group
begin_group Jump Statements
begin_template Return Statement
return <expression>;
end_template
begin_template Break Statement
break;
end_template
begin_template Continue Statement
continue;
end_template
end_group
end_group
begin_group Expressions
begin_template Assignment Operators
// SystemVerilog supports the assignment operators

// arithmetic
	++ 
	-- 
	+=
	-=
	*=
	/=
	%=

// logical
	&=
	^=
	|=
	<<=
	>>=
	<<<=
	>>>=
end_template
begin_template Assignment Patterns
// Assignment patterns are used to construct values for unpacked
// arrays and structs.  They resemble concatenations except that
// the opening brace is preceded by an apostrophe.

int array_of_ints[1:0] = '{1, 1};
struct { int a, b; } a_struct = '{1, 1};
end_template
begin_template Enum Methods
// Return the first enum literal in the enum data type returned by 
// the expression
<expression>.first()

// Return the last enum literal in the enum data type returned by 
// the expression
<expression>.last()

// Return the enum literal that follows the enum literal returned by
// the expression
<expression>.next()

// Return the enum literal that precedes the enum literal returned by
// the expression.
<expression>.prev()

// Return the number of enum literals in the enum data type returned
// by the expression
<expression>.num()

// Examples
enum { A, B, C, D, E } enum_object = C;

enum_object.first() == A
enum_object.last() == E
enum_object.next() == D
enum_object.prev() == B
enum_object.num() == 5
end_template
begin_group Array Querying
begin_template Array Querying
// Return the number of packed + unpacked dimensions in an array object
// or data type
$dimensions(<array_object_or_data_type>)

// Return the number of unpacked dimensions in an array object or data type.
$unpacked_dimensions(<array_object_or_data_type>)

// Return the specific bounds of an array object or data type.
$left(<array_object_or_data_type>, <dimension>)
$right(<array_object_or_data_type>, <dimension>)
$low(<array_object_or_data_type>, <dimension>)
$high(<array_object_or_data_type>, <dimension>)

// Return the number of elements in an array object or data type
$size(<array_object_or_data_type>, <dimension>)

// Return 1 if $left >= $right; otherwise, return -1.
$increment(<array_object_or_data_type>, <dimension>)
end_template
begin_template Expression Size
// Return the number of bits in a data type or expression
$bits(<expression_or_data_type)
end_template
end_group
end_group
begin_group Compiler Directives
begin_template `define
`define <name> <macro_text>
`define <name>(<args>) <macro_text>

// SystemVerilog supports three special strings in the macro text.  The
// first two strings allow you to construct string literals from macro
// arguments.  The third string allows you to construct identifiers
// from macro arguments.
// 
//     `"            -->          Include " character in macro expansion
//     `\`"          -->          Include \" in macro expansion
//     ``            -->          Delimits without introducing white space

// Example(s)
`define msg(type, text)   `"type: `\`"text`\`"`"
`msg(warning, undefined macro) returns "warning: \"undefined macro\""

`define make_name(prefix, base, suffix) prefix``base``suffix
`make_name(altera_, tmp, _variable) returns altera_tmp_variable
end_template
end_group
end_group
end_group
