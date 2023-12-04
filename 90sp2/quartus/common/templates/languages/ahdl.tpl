begin_group AHDL
begin_group Architecture
begin_template Overall Structure
-- Title Statement (optional)

-- Include Statement (optional)

-- Constant Statement (optional)

-- Define Statement (optional)

-- Parameters Statement (optional)

-- Function Prototype Statement (optional)

-- Options Statement (optional)

-- Assert Statement (optional)

-- Subdesign Section

-- Variable Section (optional)

	-- If Generate Statement (optional)

	-- Node Declaration (optional)

	-- Instance Declaration (optional)

	-- Register Declaration (optional)

	-- State Machine Declaration (optional)

	-- Machine Alias Declaration (optional)

-- Logic Section

	-- Defaults Statement (optional)
	
	-- The following statements can be freely intermixed:

	-- Boolean Equation

	-- Case Statement

	-- For Generate Statement

	-- If Generate Statement

	-- If Then Statement

	-- In-Line Logic Function Reference

	-- Truth Table Statement

	-- Assert Statement
end_template

begin_template Assert Statement
ASSERT __expression
	REPORT		__report_string __report_parameter, __report_parameter
	SEVERITY	__severity_level;
end_template

begin_template Boolean Equation
__node_name = __node_name __operator __node_name;
end_template

begin_template Case Statement
CASE __expression IS
	WHEN __constant_value =>
		__statement;
		__statement;
	WHEN __constant_value =>
		__statement;
		__statement;
	WHEN OTHERS =>
		__statement;
		__statement;
END CASE;
end_template

begin_template Constant Statement
CONSTANT __constant_name = __constant_value;
end_template

begin_template Defaults Statement
DEFAULTS
	__node_name = __constant_value;
END DEFAULTS;
end_template

begin_template Define Statement
DEFINE __evaluated_function_name (__variable, __variable) = __expression;
end_template

begin_template For Generate Statement
FOR __index_variable IN __range GENERATE
	__statement;
	__statement;
END GENERATE;
end_template

begin_template Function Prototype Statement (non-parameterized)
FUNCTION __function_name(__input_name, MACHINE __state_machine_name) 
	RETURNS (__output_name, __bidir_name, MACHINE __state_machine_name);
end_template

begin_template Function Prototype Statement (parameterized)
FUNCTION __function_name(__input_name, MACHINE __state_machine_name) 
	WITH (__parameter_name, __parameter_name)
	RETURNS (__output_name, __bidir_name, MACHINE __state_machine_name);
end_template

begin_template If Generate Statement
IF __expression GENERATE
	__statement;
	__statement;
ELSE GENERATE
	__statement;
	__statement;
END GENERATE;
end_template

begin_template If Then Statement
IF __expression THEN
	__statement;
	__statement;
ELSIF __expression THEN
	__statement;
	__statement;
ELSE
	__statement;
	__statement;
END IF;
end_template

begin_template In-Line Reference (non-parameterized)
(__node_name, __node_name) = __function_name(__node_name, __node_name);
__node_name = __primitive_name(__node_name, __node_name);
end_template

begin_template In-Line Reference (parameterized)
(__node_name, __node_name) = __function_name(__node_name, __node_name)
	WITH (__parameter_name = __parameter_value, 
		__parameter_name = __parameter_value);
end_template

begin_template In-Line Reference (named port association)
(__node_name, __node_name) = __function_name
	(.__port_name = __node_name, .__port_name = __node_name)
	RETURNS (.__port_name, .__port_name);
__node_name = __primitive_name
	(.__port_name = __node_name, .__port_name = __node_name);
end_template

begin_template Include Statement
INCLUDE "__include_filename.inc";
end_template

begin_template Instance Declaration (non-parameterized)
__function_instance_name	: __function_name;
__primitive_instance_name	: __primitive_name;
end_template

begin_template Instance Declaration (parameterized)
__function_instance_name	: __function_name
	WITH (__parameter_name = __parameter_value, 
		__parameter_name = __parameter_value);
end_template

begin_template Logic Section
BEGIN

END;
end_template

begin_template Node Declaration
__node_name	: NODE;
__node_name	: TRI_STATE_NODE;
end_template

begin_template Options Statement
OPTIONS BIT0 = __option_value;
end_template

begin_template Parameters Statement
PARAMETERS
(
	__parameter_name = __parameter_default_value,
	__parameter_name,
	__parameter_name
);
end_template

begin_template Register Declaration
__register_instance_name	: __register_name;
end_template

begin_template State Machine Declaration
__machine_name	: MACHINE 
	OF BITS (__state_bit, __state_bit)
	WITH STATES (
		__state_name = __state_value,
		__state_name = __state_value,
		__state_name = __state_value);
end_template

begin_template Subdesign Section
SUBDESIGN __design_name
(
	__input_name, __input_name		: INPUT = __constant_value;
	__output_name, __output_name	: OUTPUT;
	__bidir_name, __bidir_name		: BIDIR;

	__state_machine_name			: MACHINE INPUT;
	__state_machine_name			: MACHINE OUTPUT;
)
end_template

begin_template Title Statement
TITLE "__your_title";
end_template

begin_template Truth Table Statement
TABLE
	__node_name,	__node_name		=> __node_name,	__node_name;

	__input_value,	__input_value	=>	__output_value,	__output_value;
	__input_value,	__input_value	=>	__output_value,	__output_value;
	__input_value,	__input_value	=>	__output_value,	__output_value;
END TABLE;
end_template

begin_template Variable Section
VARIABLE
end_template

end_group


end_group