%parse-param {SVERILOG_PARSEPTR parse_p}
%lex-param {SVERILOG_PARSEPTR parse_p}

%{
    #include <stdio.h>
    #include <string.h>
    #include <assert.h>
    #include <verilog/sverilog.h>
    #include <preprocessor.h>

    extern int sverilog_lineno ;
    extern char *sverilog_text ;

    void sverilog_error(SVERILOG_PARSEPTR parse_p,const char *msg) {
        fprintf( stderr, "line %d - ERROR: %s\n", sverilog_lineno,msg) ;
        fprintf( stderr, "- '%s'\n", sverilog_text) ;
    }

    /* Used to decouple lex/flex yacc/bison from the preprocessor */
    void sverilog_lowlevel_init(SVERILOG_PARSEPTR parse_p) {
	// We add level of indirection but now we are decoupled
	// and out of the address space.
        parse_p->line_num = &sverilog_lineno ; 
	parse_p->scanner_text = &sverilog_text ;
    }
%}


/* token types */
%union {
    char        		boolean ;
    char        		*string ;
    char        		*term ;
    char        		*keyword ;
    char        		*identifier ;
    SVERILOG_OPERATOR_T 	operator ;
}

%token <string> ANY
%token END
%token <string> NEWLINE
%token <string> SPACE
%token <string> TAB

%token <string> AT
%token <string> COMMA
%token <string> HASH               
%token <string> DOT                
%token <string> EQ
%token <string> COLON              
%token <string> IDX_PRT_SEL
%token <string> SEMICOLON          
%token <string> OPEN_BRACKET       
%token <string> CLOSE_BRACKET      
%token <string> OPEN_SQ_BRACKET    
%token <string> CLOSE_SQ_BRACKET   
%token <string> OPEN_SQ_BRACE      
%token <string> CLOSE_SQ_BRACE     

%token <string> BIN_VALUE
%token <string> OCT_VALUE
%token <string> HEX_VALUE

%token <string> DEC_BASE
%token <string> BIN_BASE
%token <string> OCT_BASE
%token <string> HEX_BASE

%token <string> NUM_REAL
%token <string> NUM_SIZE
%token <string> UNSIGNED_NUMBER

%type  <number> decimal_number
%type  <number> binary_number
%type  <number> hex_number
%type  <number> octal_number
%type  <number> real_number

%token <identifier> SYSTEM_ID
%token <identifier> SIMPLE_ID
%token <identifier> ESCAPED_ID
%token <identifier> DEFINE_ID

%token <string> ATTRIBUTE_START
%token <string> ATTRIBUTE_END

%token <string> COMMENT_LINE
%token <string> COMMENT_BLOCK

%token <string> STRING

/* Operators Precedence */

%token <operator> STAR
%token <operator> PLUS
%token <operator> MINUS
%token <operator> ASL     
%token <operator> ASR     
%token <operator> LSL     
%token <operator> LSR     
%token <operator> DIV     
%token <operator> POW     
%token <operator> MOD     
%token <operator> GTE     
%token <operator> LTE     
%token <operator> GT      
%token <operator> LT      
%token <operator> L_NEG   
%token <operator> L_AND   
%token <operator> L_OR    
%token <operator> C_EQ    
%token <operator> L_EQ    
%token <operator> C_NEQ   
%token <operator> L_NEQ   
%token <operator> B_NEG   
%token <operator> B_AND   
%token <operator> B_OR    
%token <operator> B_XOR   
%token <operator> B_EQU   
%token <operator> B_NAND  
%token <operator> B_NOR   
%token <operator> TERNARY 

%token <operator> UNARY_OP

/* Operator Precedence */


%right  TERNARY                 /* Lowest Precedence */
%left   L_OR
%left   L_AND
%left   B_OR B_NOR
%left   B_EQU B_XOR
%left   B_NAND B_AND
%left   L_EQ C_EQ L_NEQ C_NEQ
%left   GT LT GTE LTE
%left   LSL LSR ASR ASL
%left   PLUS MINUS
%left   STAR DIV MOD
%left   POW
%right  L_NEG B_NEG UNARY_OP    /* Highest Precedence. */


/* Compiler / Preprocessor tokens */

%token <string>     MACRO_TEXT
%token <identifier> MACRO_IDENTIFIER

%token <keyword> KW_ALWAYS
%token <keyword> KW_AND
%token <keyword> KW_ASSIGN
%token <keyword> KW_AUTOMATIC
%token <keyword> KW_BEGIN
%token <keyword> KW_BUF
%token <keyword> KW_BUFIF0
%token <keyword> KW_BUFIF1
%token <keyword> KW_CASE
%token <keyword> KW_CASEX
%token <keyword> KW_CASEZ
%token <keyword> KW_CELL
%token <keyword> KW_CMOS
%token <keyword> KW_CONFIG
%token <keyword> KW_DEASSIGN
%token <keyword> KW_DEFAULT
%token <keyword> KW_DEFPARAM
%token <keyword> KW_DESIGN
%token <keyword> KW_DISABLE
%token <keyword> KW_EDGE
%token <keyword> KW_ELSE
%token <keyword> KW_END
%token <keyword> KW_ENDCASE
%token <keyword> KW_ENDCONFIG
%token <keyword> KW_ENDFUNCTION
%token <keyword> KW_ENDGENERATE
%token <keyword> KW_ENDMODULE
%token <keyword> KW_ENDPRIMITIVE
%token <keyword> KW_ENDSPECIFY
%token <keyword> KW_ENDTABLE
%token <keyword> KW_ENDTASK
%token <keyword> KW_EVENT
%token <keyword> KW_FOR
%token <keyword> KW_FORCE
%token <keyword> KW_FOREVER
%token <keyword> KW_FORK
%token <keyword> KW_FUNCTION
%token <keyword> KW_GENERATE
%token <keyword> KW_GENVAR
%token <keyword> KW_HIGHZ0
%token <keyword> KW_HIGHZ1
%token <keyword> KW_IF
%token <keyword> KW_IFNONE
%token <keyword> KW_INCDIR
%token <keyword> KW_INCLUDE
%token <keyword> KW_INITIAL
%token <keyword> KW_INOUT
%token <keyword> KW_INPUT
%token <keyword> KW_INSTANCE
%token <keyword> KW_INTEGER
%token <keyword> KW_JOIN
%token <keyword> KW_LARGE
%token <keyword> KW_LIBLIST
%token <keyword> KW_LIBRARY
%token <keyword> KW_LOCALPARAM
%token <keyword> KW_MACROMODULE
%token <keyword> KW_MEDIUM
%token <keyword> KW_MODULE
%token <keyword> KW_NAND
%token <keyword> KW_NEGEDGE
%token <keyword> KW_NMOS
%token <keyword> KW_NOR
%token <keyword> KW_NOSHOWCANCELLED
%token <keyword> KW_NOT
%token <keyword> KW_NOTIF0
%token <keyword> KW_NOTIF1
%token <keyword> KW_OR
%token <keyword> KW_OUTPUT
%token <keyword> KW_PARAMETER
%token <keyword> KW_PATHPULSE
%token <keyword> KW_PMOS
%token <keyword> KW_POSEDGE
%token <keyword> KW_PRIMITIVE
%token <keyword> KW_PULL0
%token <keyword> KW_PULL1
%token <keyword> KW_PULLDOWN
%token <keyword> KW_PULLUP
%token <keyword> KW_PULSESTYLE_ONEVENT
%token <keyword> KW_PULSESTYLE_ONDETECT
%token <keyword> KW_RCMOS
%token <keyword> KW_REAL
%token <keyword> KW_REALTIME
%token <keyword> KW_REG
%token <keyword> KW_RELEASE
%token <keyword> KW_REPEAT
%token <keyword> KW_RNMOS
%token <keyword> KW_RPMOS
%token <keyword> KW_RTRAN
%token <keyword> KW_RTRANIF0
%token <keyword> KW_RTRANIF1
%token <keyword> KW_SCALARED
%token <keyword> KW_SHOWCANCELLED
%token <keyword> KW_SIGNED
%token <keyword> KW_SMALL
%token <keyword> KW_SPECIFY
%token <keyword> KW_SPECPARAM
%token <keyword> KW_STRONG0
%token <keyword> KW_STRONG1
%token <keyword> KW_SUPPLY0
%token <keyword> KW_SUPPLY1
%token <keyword> KW_TABLE
%token <keyword> KW_TASK
%token <keyword> KW_TIME
%token <keyword> KW_TRAN
%token <keyword> KW_TRANIF0
%token <keyword> KW_TRANIF1
%token <keyword> KW_TRI
%token <keyword> KW_TRI0
%token <keyword> KW_TRI1
%token <keyword> KW_TRIAND
%token <keyword> KW_TRIOR
%token <keyword> KW_TRIREG
%token <keyword> KW_UNSIGNED
%token <keyword> KW_USE
%token <keyword> KW_VECTORED
%token <keyword> KW_WAIT
%token <keyword> KW_WAND
%token <keyword> KW_WEAK0
%token <keyword> KW_WEAK1
%token <keyword> KW_WHILE
%token <keyword> KW_WIRE
%token <keyword> KW_WOR
%token <keyword> KW_XNOR
%token <keyword> KW_XOR

%start grammar_begin


%%
/* Start variables */

grammar_begin 	: library_text 
		| config_declaration
		| source_text 
		| /* empty */ 
		;

/* 19.0 Compiler Directives */


text_macro_usage : MACRO_IDENTIFIER list_of_actual_arguments
                 | MACRO_IDENTIFIER 
		 ;

list_of_actual_arguments : actual_argument
		| list_of_actual_arguments COMMA actual_argument 
		;

actual_argument : expression 
		; 


/* A.1.1 Library Source Text */

library_text 	: library_descriptions
		| library_text library_descriptions 
		;

library_descriptions : library_declaration
		| include_statement
		| config_declaration 
		;

library_declaration : KW_LIBRARY library_identifier file_path_specs SEMICOLON
		| KW_LIBRARY library_identifier file_path_specs KW_INCDIR file_path_specs SEMICOLON 
		;

file_path_specs : file_path_spec
		| file_path_specs COMMA file_path_spec 
		;

file_path_spec 	: file_path 
		;

file_path 	: string
		;

include_statement: KW_INCLUDE file_path_spec SEMICOLON 
		;
   
/* A.1.2 Configuration Source Text */

config_declaration : KW_CONFIG config_identifier SEMICOLON design_statement config_rule_statement_os KW_ENDCONFIG
		;

design_statement : KW_DESIGN lib_cell_identifier_os SEMICOLON
		;

lib_cell_identifier_os : /* empty */
		| cell_identifier
		| library_identifier DOT cell_identifier
		| lib_cell_identifier_os cell_identifier
		| lib_cell_identifier_os library_identifier DOT cell_identifier 
		;

config_rule_statement_os : /* empty */
		| config_rule_statement
		| config_rule_statement_os config_rule_statement 
		;

config_rule_statement : KW_DEFAULT liblist_clause
		| inst_clause liblist_clause
		| inst_clause use_clause
		| cell_clause liblist_clause
		| cell_clause use_clause 
		;

inst_clause 	: KW_INSTANCE inst_name 
		;

inst_name   	: topmodule_identifier instance_identifier_os 
		;

instance_identifier_os  : /* empty */
		| DOT instance_identifier
		| instance_identifier_os DOT instance_identifier 
		;

cell_clause 	: KW_CELL cell_identifier 
		| KW_CELL library_identifier DOT cell_identifier 
		;

liblist_clause  : KW_LIBLIST library_identifier_os 
		;

library_identifier_os : /* empty */
		| library_identifier
		| library_identifier_os library_identifier 
		;

use_clause 	: KW_USE library_identifier DOT cell_identifier COLON KW_CONFIG
		| KW_USE library_identifier DOT cell_identifier
		| KW_USE cell_identifier COLON KW_CONFIG
		| KW_USE cell_identifier 
		;

/* A.1.3 Module and primitive source text. */

source_text 	: description 
		| source_text description 
		;

description 	: module_declaration
		| udp_declaration 
		;

module_declaration : 
		/* new ANSI C style */
		attribute_instances module_keyword module_identifier
  			module_parameter_port_list list_of_port_declarations 
			SEMICOLON non_port_module_item_os KW_ENDMODULE
		/* old pre ANSI C style */
		| attribute_instances module_keyword module_identifier
  			module_parameter_port_list list_of_ports SEMICOLON
  			module_item_os KW_ENDMODULE 
		;

module_keyword	: KW_MODULE
                | KW_MACROMODULE 
		;

/* A.1.4 Module parameters and ports */

module_parameter_port_list  : /* empty */
		| HASH OPEN_BRACKET module_params CLOSE_BRACKET 
		;

module_params   : parameter_declaration
		| module_params COMMA parameter_declaration 
		;

list_of_ports   : /* empty */
		| OPEN_BRACKET ports CLOSE_BRACKET 
		;

list_of_port_declarations : OPEN_BRACKET CLOSE_BRACKET
		| OPEN_BRACKET port_declarations CLOSE_BRACKET 
		;

port_declarations : port_declarations COMMA port_dir port_declaration_l
		| port_declarations COMMA identifier_csv port_dir port_declaration_l
		| port_dir port_declaration_l 
		;

port_declaration_l: net_type_o signed_o range_o port_identifier
		| signed_o range_o port_identifier
		| KW_REG signed_o range_o port_identifier eq_const_exp_o
		| output_variable_type_o port_identifier
		| output_variable_type port_identifier eq_const_exp_o 
		;

identifier_csv	: /* empty */
		| identifier
		| COMMA identifier identifier_csv 
		;

port_dir	: attribute_instances KW_OUTPUT
		| attribute_instances KW_INPUT
		| attribute_instances KW_INOUT 
		;

port_declaration: inout_declaration
		| input_declaration
		| output_declaration 
		;

ports           : /* empty */
		| ports COMMA port
		| port 
		;

port            : port_expression
		| DOT port_identifier OPEN_BRACKET port_expression CLOSE_BRACKET 
		;

port_expression : port_reference 
		| port_expression COMMA port_reference 
		;

port_reference  : port_identifier
		| port_identifier OPEN_SQ_BRACKET constant_expression CLOSE_SQ_BRACKET
		| port_identifier OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET 
		;

/* A.1.5 Module Items */

module_item_os 	: /* empty */
		| module_item
		| module_item_os module_item 
		;

non_port_module_item_os : /* empty */
 		| non_port_module_item
 		| non_port_module_item_os non_port_module_item 
		;

module_item 	: module_or_generate_item
 		| port_declaration SEMICOLON
 		| attribute_instances generated_instantiation
 		| attribute_instances local_parameter_declaration
 		| attribute_instances parameter_declaration SEMICOLON
 		| attribute_instances specify_block
 		| attribute_instances specparam_declaration 
		;

module_or_generate_item : attribute_instances module_or_generate_item_declaration
		| attribute_instances parameter_override
		| attribute_instances continuous_assign
		| attribute_instances gate_instantiation
		| attribute_instances udp_instantiation
		| attribute_instances module_instantiation
		| attribute_instances initial_construct
		| attribute_instances always_construct 
		;

module_or_generate_item_declaration : net_declaration
 		| reg_declaration
 		| integer_declaration
 		| real_declaration
 		| time_declaration
 		| realtime_declaration
 		| event_declaration
 		| genvar_declaration
 		| task_declaration
 		| function_declaration 
		;

non_port_module_item : attribute_instances generated_instantiation
		| attribute_instances local_parameter_declaration
		| attribute_instances module_or_generate_item
		| attribute_instances parameter_declaration SEMICOLON
		| attribute_instances specify_block
		| attribute_instances specparam_declaration 
		;

parameter_override  : KW_DEFPARAM list_of_param_assignments SEMICOLON 
		;

/* A.2.1.1 Module Parameter Declarations */

signed_o 	: /* empty */
	  	| KW_SIGNED 
		;

range_o  	: /* empty */
	  	| range 
		;

local_parameter_declaration : KW_LOCALPARAM signed_o range_o list_of_param_assignments SEMICOLON 
		| KW_LOCALPARAM KW_INTEGER list_of_param_assignments SEMICOLON
		| KW_LOCALPARAM KW_REAL list_of_param_assignments SEMICOLON
		| KW_LOCALPARAM KW_REALTIME list_of_param_assignments SEMICOLON
		| KW_LOCALPARAM KW_TIME list_of_param_assignments SEMICOLON 
		;

parameter_declaration : KW_PARAMETER signed_o range_o list_of_param_assignments
		| KW_PARAMETER KW_INTEGER list_of_param_assignments
		| KW_PARAMETER KW_REAL list_of_param_assignments
		| KW_PARAMETER KW_REALTIME list_of_param_assignments
		| KW_PARAMETER KW_TIME list_of_param_assignments 
		;

specparam_declaration : KW_SPECPARAM range_o list_of_specparam_assignments SEMICOLON 
		;

/* A.2.1.2 Port declarations */

net_type_o  	: /* empty */
	     	| net_type 
		;

reg_o       	: /* empty */
	     	| KW_REG 
		;

inout_declaration : KW_INOUT net_type_o signed_o range_o list_of_port_identifiers 
		;

input_declaration : KW_INPUT net_type_o signed_o range_o list_of_port_identifiers 
		;

output_declaration: KW_OUTPUT net_type_o signed_o range_o list_of_port_identifiers
		| KW_OUTPUT reg_o signed_o range_o list_of_port_identifiers
		| KW_OUTPUT output_variable_type_o list_of_port_identifiers
		| KW_OUTPUT output_variable_type list_of_variable_port_identifiers
		| KW_OUTPUT KW_REG signed_o range_o list_of_variable_port_identifiers 
		;

/* A.2.1.3 Type declarations */

event_declaration: KW_EVENT list_of_event_identifiers SEMICOLON 
		;

genvar_declaration: KW_GENVAR list_of_genvar_identifiers SEMICOLON 
		;

integer_declaration: KW_INTEGER list_of_variable_identifiers SEMICOLON 
		;

time_declaration: KW_TIME list_of_variable_identifiers SEMICOLON 
		;

real_declaration: KW_REAL list_of_real_identifiers SEMICOLON 
		;

realtime_declaration: KW_REALTIME list_of_real_identifiers SEMICOLON 
		;

delay3_o	: /* empty */
		| delay3 
		;

drive_strength_o: /* empty */
		| OPEN_BRACKET drive_strength 
		;

net_declaration : net_type net_dec_p_ds
		| net_type OPEN_BRACKET drive_strength net_dec_p_ds
		| KW_TRIREG net_dec_p_ds
		| KW_TRIREG OPEN_BRACKET drive_strength  net_dec_p_ds
		| KW_TRIREG charge_strength net_dec_p_ds 
		;

net_dec_p_ds    : KW_VECTORED net_dec_p_vs
		| KW_SCALARED net_dec_p_vs 
		| net_dec_p_vs 
		;

net_dec_p_vs    : KW_SIGNED net_dec_p_si 
		| net_dec_p_si 
		;

net_dec_p_si    : range net_dec_p_range
		| net_dec_p_range 
		;

net_dec_p_range : delay3 net_dec_p_delay
		| net_dec_p_delay 
		;

net_dec_p_delay : list_of_net_identifiers SEMICOLON
		| list_of_net_decl_assignments SEMICOLON 
		;

reg_declaration	: KW_REG KW_SIGNED reg_dec_p_signed
		| KW_REG reg_dec_p_signed 
		;

reg_dec_p_signed: range reg_dec_p_range 
		| reg_dec_p_range
		;

reg_dec_p_range: list_of_variable_identifiers SEMICOLON
		;

/* 2.2.1 Net and variable types */

net_type	: KW_SUPPLY0
		| KW_SUPPLY1
		| KW_TRI
		| KW_TRIAND
		| KW_TRIOR
		| KW_WIRE 
		| KW_WAND
		| KW_WOR
		;

output_variable_type_o: /* empty */
		| output_variable_type
		;

output_variable_type: KW_INTEGER
		| KW_TIME
		;

real_type 	: real_identifier
          	| real_identifier EQ constant_expression
          	| real_identifier dimension dimensions
		;

dimensions 	: /* empty */
	    	| dimension 
 		| dimensions dimension 
		;

variable_type 	: variable_identifier
		| variable_identifier EQ constant_expression
		| variable_identifier dimension dimensions
		;

/* A.2.2.2 Strengths */

drive_strength  : strength0 COMMA strength1 CLOSE_BRACKET
		| strength1 COMMA strength0 CLOSE_BRACKET
		| strength0 COMMA KW_HIGHZ1 CLOSE_BRACKET
		| strength1 COMMA KW_HIGHZ0 CLOSE_BRACKET
		| KW_HIGHZ0 COMMA strength1 CLOSE_BRACKET
		| KW_HIGHZ1 COMMA strength0 CLOSE_BRACKET
		;

strength0	: KW_SUPPLY0 
		| KW_STRONG0
		| KW_PULL0
		| KW_WEAK0
		;

strength1	: KW_SUPPLY1
		| KW_STRONG1
		| KW_PULL1
		| KW_WEAK1
		;

charge_strength : OPEN_BRACKET KW_SMALL CLOSE_BRACKET
                | OPEN_BRACKET KW_MEDIUM CLOSE_BRACKET
                | OPEN_BRACKET KW_LARGE CLOSE_BRACKET
                ;

/* A.2.2.3 Delays */

delay3 		: /* empty */
	 	| HASH delay_value
		| HASH OPEN_BRACKET delay_value CLOSE_BRACKET
		| HASH OPEN_BRACKET delay_value COMMA delay_value CLOSE_BRACKET
		| HASH OPEN_BRACKET delay_value COMMA delay_value COMMA delay_value CB
		;

delay2    	: /* empty */
	   	| HASH delay_value
		| HASH OPEN_BRACKET delay_value CLOSE_BRACKET
		| HASH OPEN_BRACKET delay_value COMMA delay_value CLOSE_BRACKET
		;

delay_value 	: unsigned_number
		| parameter_identifier
		| specparam_identifier
		| mintypmax_expression
		;

/* A.2.3 Declaration Lists */

dimensions_o	: /* empty */
	     	| dimensions 
		;

list_of_event_identifiers : event_identifier dimensions_o
		| list_of_event_identifiers COMMA event_identifier dimensions_o
		;

list_of_genvar_identifiers: genvar_identifier
		| list_of_genvar_identifiers COMMA genvar_identifier
		;

list_of_net_decl_assignments : net_decl_assignment
		| list_of_net_decl_assignments COMMA net_decl_assignment
		;

list_of_net_identifiers: net_identifier dimensions_o
		| list_of_net_identifiers COMMA net_identifier dimensions_o
		;

list_of_param_assignments : param_assignment
 		| list_of_param_assignments COMMA param_assignment
 		| list_of_param_assignments COMMA KW_PARAMETER param_assignment
		;

list_of_port_identifiers: port_identifier
		| port_identifier OPEN_SQ_BRACKET constant_expression CLOSE_SQ_BRACKET
		| list_of_port_identifiers COMMA port_identifier
		| list_of_port_identifiers COMMA port_identifier OPEN_SQ_BRACKET 
			constant_expression CLOSE_SQ_BRACKET 
		;

list_of_real_identifiers: real_type
		| list_of_real_identifiers COMMA real_type
		;

list_of_specparam_assignments: specparam_assignment
		| list_of_specparam_assignments COMMA specparam_assignment
		;

list_of_variable_identifiers: variable_type
		| list_of_variable_identifiers COMMA variable_type
		;

eq_const_exp_o 	: /* empty */
	       	| EQ constant_expression
		;

list_of_variable_port_identifiers : port_identifier eq_const_exp_o
		| list_of_variable_port_identifiers COMMA port_identifier eq_const_exp_o
		;

/* A.2.4 Declaration Assignments */

net_decl_assignment: net_identifier EQ expression 
		| net_identifier
		;

param_assignment: parameter_identifier EQ constant_expression 
		;

specparam_assignment: specparam_identifier EQ constant_mintypmax_expression
		| pulse_control_specparam
		;

error_limit_value_o: /* empty */
		| COMMA error_limit_value
		;

pulse_control_specparam : KW_PATHPULSE EQ OPEN_BRACKET reject_limit_value 
			error_limit_value_o CLOSE_BRACKET SEMICOLON 
		| KW_PATHPULSE specify_input_terminal_descriptor '$'
  			specify_output_terminal_descriptor EQ OPEN_BRACKET 
			reject_limit_value error_limit_value_o 
			CLOSE_BRACKET SEMICOLON
		;

error_limit_value: limit_value
		;

reject_limit_value: limit_value
		;

limit_value	: constant_mintypmax_expression
	    	;

/* A.2.5 Declaration ranges */

dimension 	: OPEN_SQ_BRACKET constant_expression COLON constant_expression
			CLOSE_SQ_BRACKET
		;

range     	: OPEN_SQ_BRACKET constant_expression COLON constant_expression
			CLOSE_SQ_BRACKET
		;

/* A.2.6 Function Declarations */

automatic_o	: /* empty */
	    	| KW_AUTOMATIC
		;

function_declaration : KW_FUNCTION automatic_o signed_o range_or_type_o 
		     	function_identifier SEMICOLON function_item_declarations
			function_statement KW_ENDFUNCTION
		| KW_FUNCTION automatic_o signed_o range_or_type_o 
			function_identifier OPEN_BRACKET function_port_list 
			CLOSE_BRACKET SEMICOLON block_item_declarations 
			function_statement KW_ENDFUNCTION
		;

block_item_declarations: /* empty */ 
  		| block_item_declaration
		| block_item_declarations block_item_declaration
		;

function_item_declarations: /* empty */
		| function_item_declaration
 		| function_item_declarations function_item_declaration
		;

function_item_declaration: block_item_declaration 
		| tf_input_declaration SEMICOLON
		;

function_port_list : attribute_instances tf_input_declaration tf_input_declarations
		;

tf_input_declarations: /* empty */
		| COMMA attribute_instances tf_input_declaration tf_input_declarations
		;

range_or_type_o	: /* empty */
		| range_or_type
		;

range_or_type	: range
		| KW_INTEGER
		| KW_REAL
		| KW_REALTIME
		| KW_TIME
		;

/* A.2.7 Task Declarations */

task_declaration: KW_TASK automatic_o task_identifier SEMICOLON task_item_declarations 
  			statement KW_ENDTASK
		| KW_TASK automatic_o task_identifier OPEN_BRACKET task_port_list 
  			CLOSE_BRACKET SEMICOLON block_item_declarations 
			statement KW_ENDTASK
		;

task_item_declarations: /* empty */ 
		| task_item_declaration
		| task_item_declarations task_item_declaration
		;

task_item_declaration : block_item_declaration
		| attribute_instances tf_input_declaration SEMICOLON
		| attribute_instances tf_output_declaration SEMICOLON
		| attribute_instances tf_inout_declaration SEMICOLON
		;

task_port_list	: task_port_item
 		| task_port_list COMMA task_port_item
		;

task_port_item	: attribute_instances tf_input_declaration  SEMICOLON
		| attribute_instances tf_output_declaration SEMICOLON
		| attribute_instances tf_inout_declaration  SEMICOLON
		;

tf_input_declaration: KW_INPUT reg_o signed_o range_o list_of_port_identifiers
		| KW_INPUT task_port_type_o list_of_port_identifiers
		;

tf_output_declaration: KW_OUTPUT reg_o signed_o range_o list_of_port_identifiers
		| KW_OUTPUT task_port_type_o list_of_port_identifiers
		;

tf_inout_declaration: KW_INOUT reg_o signed_o range_o list_of_port_identifiers
		| KW_INOUT task_port_type_o list_of_port_identifiers
		;

task_port_type_o : /* empty */
		| task_port_type 
		;
task_port_type	: KW_TIME
		| KW_REAL
		| KW_REALTIME
		| KW_INTEGER
		;


/* A.2.8 Block item declarations */

block_item_declaration : attribute_instances block_reg_declaration
		| attribute_instances event_declaration
		| attribute_instances integer_declaration
		| attribute_instances local_parameter_declaration
		| attribute_instances parameter_declaration SEMICOLON
		| attribute_instances real_declaration
		| attribute_instances realtime_declaration
		| attribute_instances time_declaration
		;

block_reg_declaration: KW_REG signed_o range_o list_of_block_variable_identifiers SEMICOLON
		;

list_of_block_variable_identifiers: block_variable_type
		| list_of_block_variable_identifiers COMMA block_variable_type
		;

block_variable_type: variable_identifier
		| variable_identifier dimensions
		;


/* A.3.1 primitive instantiation and instances */

delay2_o 	: /* empty */
		| delay2
		;

gate_instantiation : cmos_switchtype cmos_switch_instances SEMICOLON
		| mos_switchtype mos_switch_instances SEMICOLON
		| pass_switchtype pass_switch_instances SEMICOLON
		| gate_enable SEMICOLON
		| gate_n_output SEMICOLON
		| gate_pass_en_switch SEMICOLON
		| gate_n_input SEMICOLON
		| KW_PULLDOWN pulldown_strength_o pull_gate_instances SEMICOLON
		| KW_PULLUP pullup_strength_o pull_gate_instances SEMICOLON
		;

/* -------------------------------------------------------------------------*/

OB 		: OPEN_BRACKET
     		;

CB 		: CLOSE_BRACKET
     		;

gate_n_output	: gatetype_n_output n_output_gate_instances
		| gatetype_n_output OB drive_strength delay2 n_output_gate_instances
		| gatetype_n_output OB drive_strength n_output_gate_instances
		| gatetype_n_output delay2 n_output_gate_instances
		| gatetype_n_output OB output_terminal COMMA input_terminal CB gate_n_output_a_id
		;

gate_n_output_a_id: /* empty */
		| COMMA n_output_gate_instances
		;

gatetype_n_output: KW_BUF
		| KW_NOT
		;

n_output_gate_instances: n_output_gate_instance
		| n_output_gate_instances COMMA n_output_gate_instance
		;

n_output_gate_instance: name_of_gate_instance OPEN_BRACKET output_terminals 
		      	COMMA input_terminal CLOSE_BRACKET
		;

/* -------------------------------------------------------------------------*/

gate_enable 	: enable_gatetype enable_gate_instances
		| enable_gatetype OB drive_strength delay2 enable_gate_instances
		| enable_gatetype OB drive_strength enable_gate_instances
		| enable_gatetype OB output_terminal COMMA input_terminal COMMA 
  			enable_terminal CB COMMA n_output_gate_instances
		| enable_gatetype OB output_terminal COMMA input_terminal COMMA 
  			enable_terminal CB
		| enable_gatetype delay3 enable_gate_instances
		;

enable_gate_instances: enable_gate_instance
		| enable_gate_instances COMMA enable_gate_instance
		;

enable_gate_instance: name_of_gate_instance OPEN_BRACKET output_terminal COMMA
			input_terminal COMMA enable_terminal CLOSE_BRACKET
		;

enable_gatetype	: KW_BUFIF0
		| KW_BUFIF1
		| KW_NOTIF0
		| KW_NOTIF1
		;

/* -------------------------------------------------------------------------*/

gate_n_input : gatetype_n_input n_input_gate_instances
		| gatetype_n_input OB drive_strength delay2 n_input_gate_instances
		| gatetype_n_input OB drive_strength n_input_gate_instances 
		| gatetype_n_input OB output_terminal COMMA input_terminals CB
		| gatetype_n_input OB output_terminal COMMA input_terminals CB 
  			COMMA n_input_gate_instances
		| gatetype_n_input delay3 n_input_gate_instances
		;


gatetype_n_input: KW_AND
		| KW_NAND
		| KW_OR
		| KW_NOR
		| KW_XOR
		| KW_XNOR
		;

/* -------------------------------------------------------------------------*/

gate_pass_en_switch: KW_TRANIF0  delay2 pass_enable_switch_instances
		| KW_TRANIF1  delay2 pass_enable_switch_instances
		| KW_RTRANIF1 delay2 pass_enable_switch_instances
		| KW_RTRANIF0 delay2 pass_enable_switch_instances
		;

pass_enable_switch_instances: pass_enable_switch_instance
		| pass_enable_switch_instances COMMA pass_enable_switch_instance
		;


pass_enable_switch_instance: name_of_gate_instance OPEN_BRACKET inout_terminal 
			 COMMA inout_terminal COMMA enable_terminal 
			 CLOSE_BRACKET
		;

/* -------------------------------------------------------------------------*/

pull_gate_instances: pull_gate_instance
		| pull_gate_instances COMMA pull_gate_instance
		;

pass_switch_instances: pass_switch_instance
		| pass_switch_instances COMMA pass_switch_instance
		;

n_input_gate_instances: n_input_gate_instance
		| n_input_gate_instances COMMA n_input_gate_instance
		;

mos_switch_instances: mos_switch_instance
		| mos_switch_instances COMMA mos_switch_instance
		;

cmos_switch_instances: cmos_switch_instance
		| cmos_switch_instances COMMA cmos_switch_instance
		;


pull_gate_instance: name_of_gate_instance OPEN_BRACKET output_terminal CLOSE_BRACKET
		;

pass_switch_instance: name_of_gate_instance OPEN_BRACKET inout_terminal 
		    	COMMA inout_terminal CLOSE_BRACKET
		;


n_input_gate_instance: name_of_gate_instance OPEN_BRACKET output_terminal 
		     	COMMA input_terminals CLOSE_BRACKET
		;

mos_switch_instance: name_of_gate_instance OPEN_BRACKET output_terminal 
		   	COMMA input_terminal COMMA enable_terminal CLOSE_BRACKET
		;

cmos_switch_instance: name_of_gate_instance OPEN_BRACKET output_terminal 
		    	COMMA input_terminal COMMA ncontrol_terminal 
			COMMA pcontrol_terminal CLOSE_BRACKET
		;

output_terminals: output_terminals COMMA output_terminal
 		| output_terminal
		;

input_terminals: input_terminal
		| input_terminals COMMA input_terminal
		;

/* A.3.2 primitive strengths */

pulldown_strength_o: /* empty */
		| pulldown_strength
		;

pulldown_strength: OPEN_BRACKET strength0 COMMA strength1 CLOSE_BRACKET
		| OPEN_BRACKET strength1 COMMA strength0 CLOSE_BRACKET
		| OPEN_BRACKET strength1 CLOSE_BRACKET
		;

pullup_strength_o: /* empty */
		| pullup_strength
		;

pullup_strength	: OPEN_BRACKET strength0 COMMA strength1 CLOSE_BRACKET
		| OPEN_BRACKET strength1 COMMA strength0 CLOSE_BRACKET
		| OPEN_BRACKET strength1 CLOSE_BRACKET
		;

name_of_gate_instance :  /* empty */
		| gate_instance_identifier range_o
		;

/* A.3.3 primitive terminals */

enable_terminal	: expression
		;

input_terminal	: expression
		;

ncontrol_terminal: expression
		;

pcontrol_terminal: expression
		;

inout_terminal	: net_lvalue
	       	;
	      
output_terminal	: net_lvalue
		;

/* A.3.4 primitive gate and switch types */

cmos_switchtype	: KW_CMOS delay3
		| KW_RCMOS delay3
		;

mos_switchtype	: KW_NMOS delay3 
		| KW_PMOS  delay3
		| KW_RNMOS delay3
		| KW_RPMOS delay3
		;

pass_switchtype	: KW_TRAN delay2
		| KW_RTRAN delay2
		;

/* A.4.1 module instantiation */

module_instantiation: module_identifier HASH delay_value 
		    	parameter_value_assignment_o module_instances SEMICOLON
		| module_identifier parameter_value_assignment_o 
			module_instances SEMICOLON
		;

parameter_value_assignment_o: /* empty */
		| parameter_value_assignment
		;

parameter_value_assignment: HASH OPEN_BRACKET list_of_parameter_assignments CLOSE_BRACKET
		;

list_of_parameter_assignments: ordered_parameter_assignments
		| named_parameter_assignments
		;

ordered_parameter_assignments: ordered_parameter_assignment
		| ordered_parameter_assignments COMMA ordered_parameter_assignment
		;

named_parameter_assignments: named_parameter_assignment
		| named_parameter_assignments COMMA named_parameter_assignment
		;

module_instances : module_instance
		| module_instances COMMA module_instance
		;

ordered_parameter_assignment : expression
		;

named_parameter_assignment: DOT parameter_identifier OPEN_BRACKET 
			expression_o CLOSE_BRACKET
		;

module_instance	: name_of_instance OPEN_BRACKET list_of_port_connections 
			CLOSE_BRACKET
		;

name_of_instance: module_instance_identifier range_o
		;

list_of_port_connections: /* empty */
		| ordered_port_connections
		| named_port_connections
		;

ordered_port_connections: ordered_port_connection
		| ordered_port_connections COMMA ordered_port_connection
		;

named_port_connections: named_port_connection
		| named_port_connections COMMA named_port_connection
		;

ordered_port_connection : attribute_instances expression_o
		;

named_port_connection : DOT port_identifier OPEN_BRACKET expression_o CLOSE_BRACKET
		;

expression_o 	: /* empty */
	     	| expression
		;

/* A.4.2 Generated instantiation */

generated_instantiation : KW_GENERATE generate_items KW_ENDGENERATE 
		;

generate_items 	: generate_item
		| generate_items generate_item
		;

generate_item_or_null: /* empty */
		| generate_item 
		;

generate_item 	: generate_conditional_statement
		| generate_case_statement
		| generate_loop_statement
		| generate_block
		| module_or_generate_item
		;

generate_conditional_statement: KW_IF OPEN_BRACKET constant_expression 
			CLOSE_BRACKET generate_item_or_null
  			KW_ELSE generate_item_or_null
		| KW_IF OPEN_BRACKET constant_expression CLOSE_BRACKET 
			generate_item_or_null
		;

generate_case_statement: KW_CASE OPEN_BRACKET constant_expression 
			CLOSE_BRACKET genvar_case_items KW_ENDCASE
		;

genvar_case_items: /* empty */
		| genvar_case_item
		| genvar_case_items genvar_case_item
		;

genvar_case_item: constant_expressions COLON generate_item_or_null
		| KW_DEFAULT COLON generate_item_or_null
		| KW_DEFAULT generate_item_or_null
		;

generate_loop_statement: KW_FOR OPEN_BRACKET genvar_assignment SEMICOLON 
 			constant_expression SEMICOLON genvar_assignment 
			CLOSE_BRACKET KW_BEGIN COLON generate_block_identifier 
			generate_items KW_END
		;

genvar_assignment: genvar_identifier EQ constant_expression
		;

generate_block	: KW_BEGIN generate_items KW_END
		| KW_BEGIN COLON generate_block_identifier generate_items KW_END
		;

/* A.5.1 UDP Declaration */

udp_declaration : attribute_instances KW_PRIMITIVE udp_identifier OPEN_BRACKET 
			udp_port_list CLOSE_BRACKET SEMICOLON 
			udp_port_declarations udp_body KW_ENDPRIMITIVE
		| attribute_instances KW_PRIMITIVE udp_identifier OPEN_BRACKET
  			udp_declaration_port_list CLOSE_BRACKET SEMICOLON 
			udp_body KW_ENDPRIMITIVE
		;

udp_port_declarations: udp_port_declaration
		| udp_port_declarations udp_port_declaration
		;

/* A.5.2 UDP Ports */

udp_port_list	: output_port_identifier COMMA input_port_identifiers
		;

input_port_identifiers: input_port_identifier
		| input_port_identifiers COMMA input_port_identifier
		;

udp_declaration_port_list: udp_output_declaration COMMA udp_input_declarations
		;

udp_input_declarations: udp_input_declaration
		| udp_input_declarations udp_input_declaration
		;

udp_port_declaration: udp_output_declaration SEMICOLON
		| udp_input_declaration SEMICOLON
		| udp_reg_declaration SEMICOLON
;

udp_output_declaration: attribute_instances KW_OUTPUT port_identifier
		| attribute_instances KW_OUTPUT KW_REG port_identifier
		| attribute_instances KW_OUTPUT KW_REG port_identifier 
			EQ constant_expression
		;

udp_input_declaration: attribute_instances KW_INPUT list_of_port_identifiers
		;

udp_reg_declaration: attribute_instances KW_REG variable_identifier
		;

/* A.5.3 UDP body */

udp_body	: KW_TABLE combinational_entrys KW_ENDTABLE
		| udp_initial_statement KW_TABLE sequential_entrys KW_ENDTABLE
		| KW_TABLE sequential_entrys KW_ENDTABLE
		;

sequential_entrys: sequential_entry
		| sequential_entrys sequential_entry
		;

combinational_entrys: combinational_entry
		| combinational_entrys combinational_entry
		;

combinational_entry: level_symbols COLON output_symbol SEMICOLON
		;

sequential_entry: level_symbols   COLON level_symbol COLON next_state SEMICOLON
		| edge_input_list COLON level_symbol COLON next_state SEMICOLON
		;

udp_initial_statement: KW_INITIAL output_port_identifier EQ init_val SEMICOLON
		;

init_val	: unsigned_number
		| number
		;

level_symbols_o	: /* empty */
		| level_symbols
		;

level_symbols	: level_symbol
		| level_symbols level_symbol
		;

edge_input_list	: level_symbols_o edge_indicator level_symbols_o
		;

edge_indicator	: OPEN_BRACKET level_symbol level_symbol CLOSE_BRACKET
		| edge_symbol
		;

next_state	: output_symbol
		| MINUS
		;

output_symbol	: unsigned_number
		| 'X' 
		| 'x'
		| TERNARY
		| SIMPLE_ID 
		;

level_symbol 	: unsigned_number
		| 'X'
		| 'x'
		| TERNARY
		| 'B'
		| 'b'
		| SIMPLE_ID
		;

edge_symbol	: 'r'
		| 'R'
		| 'f'
		| 'F'
		| 'p'
		| 'P'
		| 'n'
		| 'N'
		| SIMPLE_ID
		| STAR
		;

/* A.5.4 UDP instantiation */

udp_instantiation : udp_identifier drive_strength_o delay2_o udp_instances SEMICOLON
		;

udp_instances 	: udp_instance
		| udp_instances COMMA udp_instance
		;

udp_instance	: udp_instance_identifier range_o OPEN_BRACKET output_terminal 
	     		COMMA input_terminals CLOSE_BRACKET
		| OPEN_BRACKET output_terminal COMMA input_terminals CLOSE_BRACKET
		;


/* A.6.1 Continuous assignment statements */

continuous_assign: KW_ASSIGN drive_strength_o delay3_o list_of_net_assignments SEMICOLON
		;

list_of_net_assignments: net_assignment
		| list_of_net_assignments COMMA net_assignment
		;

net_assignment	: net_lvalue EQ expression
		;

/* A.6.2 Procedural blocks and assignments */

initial_construct: KW_INITIAL statement
		;

always_construct: KW_ALWAYS statement
		;		

blocking_assignment: variable_lvalue EQ delay_or_event_control_o expression
		;

nonblocking_assignment: variable_lvalue LTE delay_or_event_control_o expression
		;

delay_or_event_control_o: /* empty */
		| delay_or_event_control
		;

procedural_continuous_assignments : KW_ASSIGN variable_assignment
		| KW_DEASSIGN variable_lvalue
		| KW_FORCE variable_assignment
		| KW_FORCE net_assignment
		| KW_RELEASE variable_lvalue
		| KW_RELEASE net_lvalue
		;

function_blocking_assignment: variable_lvalue EQ expression
		;

function_statement_or_null: function_statement
		| attribute_instances SEMICOLON
		;

/* A.6.3 Parallel and sequential blocks */

block_item_declarations: block_item_declaration
		| block_item_declarations block_item_declaration
		;

function_statements_o: /* empty */
		| function_statements

function_statements: function_statement
		| function_statements function_statement
		;

function_seq_block: KW_BEGIN function_statements_o KW_END
		| KW_BEGIN COLON block_identifier block_item_declarations
			function_statements_o KW_END
		;

variable_assignment: variable_lvalue EQ expression
		;

par_block	: KW_FORK statements_o KW_JOIN
		| KW_FORK COLON block_identifier block_item_declarations 
			statements_o KW_JOIN
		;

seq_block	: KW_BEGIN statements_o KW_END
		| KW_BEGIN COLON block_identifier block_item_declarations 
			statements_o KW_END
		;

/* A.6.4 Statements */

statements_o	: /* empty */
		| statements 
		;

statements	: statement
		| statements statement
		;

statement	: attribute_instances blocking_assignment SEMICOLON
		| attribute_instances task_enable
		| attribute_instances nonblocking_assignment SEMICOLON
		| attribute_instances case_statement
		| attribute_instances conditional_statement
		| attribute_instances disable_statement
		| attribute_instances event_trigger
		| attribute_instances loop_statement
		| attribute_instances par_block
		| attribute_instances procedural_continuous_assignments SEMICOLON
		| attribute_instances procedural_timing_control_statement
		| attribute_instances seq_block
		| attribute_instances system_function_call SEMICOLON
		| attribute_instances system_task_enable
		| attribute_instances wait_statement
		;

statement_or_null: statement
		| attribute_instances SEMICOLON
		| SEMICOLON
		;
                  
function_statement: attribute_instances function_blocking_assignment SEMICOLON
		| attribute_instances function_case_statement
		| attribute_instances function_conditional_statement
		| attribute_instances function_loop_statement
		| attribute_instances function_seq_block
		| attribute_instances disable_statement
		| attribute_instances system_function_call SEMICOLON
		| attribute_instances system_task_enable
		;

/* A.6.5 Timing control statements */

procedural_timing_control_statement: delay_or_event_control statement_or_null
		;

delay_or_event_control: delay_control
		| event_control
		| KW_REPEAT OPEN_BRACKET expression CLOSE_BRACKET event_control
		;

delay_control	: HASH delay_value
		| HASH OPEN_BRACKET mintypmax_expression CLOSE_BRACKET
		;


disable_statement: KW_DISABLE hierarchical_task_identifier SEMICOLON
		| KW_DISABLE hierarchical_block_identifier SEMICOLON
		;

event_control	: AT event_identifier
		| AT OPEN_BRACKET event_expression CLOSE_BRACKET
		| AT STAR
		| AT ATTRIBUTE_START CLOSE_BRACKET
		| AT OPEN_BRACKET STAR CLOSE_BRACKET
		;

event_trigger	: MINUS GT hierarchical_event_identifier
		;

event_expression: expression
		| KW_POSEDGE expression
		| KW_NEGEDGE expression
		| event_expression KW_OR event_expression
		| event_expression COMMA event_expression
		;

wait_statement	: KW_WAIT OPEN_BRACKET expression CLOSE_BRACKET statement_or_null
		;

/* A.6.6 Conditional Statemnets */

conditional_statement: KW_IF OPEN_BRACKET expression CLOSE_BRACKET statement_or_null
		| KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
			statement_or_null KW_ELSE statement_or_null
		| if_else_if_statement
		;

if_else_if_statement: KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
		    	statement_or_null else_if_statements
		| KW_IF OPEN_BRACKET expression CLOSE_BRACKET statement_or_null
  			else_if_statements KW_ELSE statement_or_null
		;

else_if_statements: KW_ELSE KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
		  	statement_or_null
		| else_if_statements KW_ELSE KW_IF OPEN_BRACKET expression
  			CLOSE_BRACKET statement_or_null
		;

function_conditional_statement: KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
			function_statement_or_null
		| KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
			function_statement_or_null KW_ELSE 
			function_statement_or_null
 		| function_if_else_if_statement
		;

function_else_if_statements: KW_ELSE KW_IF OPEN_BRACKET expression 
			CLOSE_BRACKET function_statement_or_null
		| function_else_if_statements KW_ELSE KW_IF OPEN_BRACKET 
			expression CLOSE_BRACKET function_statement_or_null
		;

function_if_else_if_statement: KW_IF OPEN_BRACKET expression CLOSE_BRACKET 
			function_statement_or_null function_else_if_statements
		| KW_IF OPEN_BRACKET expression CLOSE_BRACKET function_statement_or_null
  			function_else_if_statements KW_ELSE function_statement_or_null
		;

/* A.6.7 Case Statements */

case_statement	: KW_CASE OPEN_BRACKET expression CLOSE_BRACKET case_items KW_ENDCASE
		| KW_CASEZ OPEN_BRACKET expression CLOSE_BRACKET case_items KW_ENDCASE
		| KW_CASEX OPEN_BRACKET expression CLOSE_BRACKET case_items KW_ENDCASE
		;

case_items      : case_item
		| case_items case_item
                ;

expressions_o   : /* empty */
		| expressions
                ;

case_item       : expressions COLON statement_or_null
		| KW_DEFAULT statement_or_null
		| KW_DEFAULT COLON statement_or_null
		;

function_case_statement: KW_CASE OPEN_BRACKET expression CLOSE_BRACKET 
			function_case_items KW_ENDCASE
		| KW_CASEZ OPEN_BRACKET expression CLOSE_BRACKET 
			function_case_items KW_ENDCASE
		| KW_CASEX OPEN_BRACKET expression CLOSE_BRACKET 
			function_case_items KW_ENDCASE
		;

function_case_items: function_case_item
		| function_case_items function_case_item
		;

function_case_item: expressions COLON function_statement_or_null
		| KW_DEFAULT function_statement_or_null
		| KW_DEFAULT COLON function_statement_or_null
		;

/* A.6.8 looping statements */

function_loop_statement : KW_FOREVER function_statement
		| KW_REPEAT OPEN_BRACKET expression CLOSE_BRACKET function_statement
		| KW_WHILE OPEN_BRACKET expression CLOSE_BRACKET function_statement
		| KW_FOR OPEN_BRACKET variable_assignment SEMICOLON expression
			SEMICOLON variable_assignment  CLOSE_BRACKET function_statement
		;

loop_statement	: KW_FOREVER statement
		| KW_REPEAT OPEN_BRACKET expression CLOSE_BRACKET statement
		| KW_WHILE OPEN_BRACKET expression CLOSE_BRACKET statement
		| KW_FOR OPEN_BRACKET variable_assignment SEMICOLON expression SEMICOLON
  			variable_assignment  CLOSE_BRACKET statement
		;


/* A.6.9 task enable statements */

system_task_enable: system_task_identifier OPEN_BRACKET expressions CLOSE_BRACKET SEMICOLON
		|   system_task_identifier SEMICOLON
		;

task_enable	: hierarchical_task_identifier SEMICOLON
		|   hierarchical_task_identifier OPEN_BRACKET expressions 
			CLOSE_BRACKET SEMICOLON
		;

/* A.7.1 specify block declaration */

specify_block	: KW_SPECIFY specify_items_o KW_ENDSPECIFY
		;

specify_items_o	: /* empty */
		| specify_items
		;

specify_items	: specify_item
		| specify_items specify_item
		;

specify_item	: specparam_declaration
		| pulsestyle_declaration
		| showcancelled_declaration
		| path_declaration
		| system_timing_check
		;

pulsestyle_declaration: KW_PULSESTYLE_ONEVENT list_of_path_outputs SEMICOLON
		| KW_PULSESTYLE_ONDETECT list_of_path_outputs SEMICOLON
		;

showcancelled_declaration: KW_SHOWCANCELLED list_of_path_outputs SEMICOLON
		| KW_NOSHOWCANCELLED list_of_path_outputs SEMICOLON
		;

/* A.7.2 specify path declarations */

path_declaration : simple_path_declaration SEMICOLON
                 | edge_sensitive_path_declaration SEMICOLON
                 | state_dependent_path_declaration SEMICOLON
                 ;

simple_path_declaration : OPEN_BRACKET specify_input_terminal_descriptor 
			polarity_operator_o EQ GT specify_output_terminal_descriptor 
			CLOSE_BRACKET EQ path_delay_value
		| OPEN_BRACKET list_of_path_inputs polarity_operator_o STAR GT 
  			list_of_path_outputs CLOSE_BRACKET EQ path_delay_value
		;


list_of_path_inputs: specify_input_terminal_descriptor
		| list_of_path_inputs COMMA specify_input_terminal_descriptor
		;

list_of_path_outputs: specify_output_terminal_descriptor
		| list_of_path_outputs COMMA specify_output_terminal_descriptor
		;

/* A.7.3 specify block terminals */

specify_input_terminal_descriptor: input_identifier
		| input_identifier constant_expression
		| input_identifier range_expression
		;

specify_output_terminal_descriptor: output_identifier
		| output_identifier constant_expression
		| output_identifier range_expression
		;

input_identifier : input_port_identifier
		| inout_port_identifier
		;

output_identifier: output_port_identifier
		| inout_port_identifier
		;

/* A.7.4 specify path delays */

path_delay_value: list_of_path_delay_expressions
		| OPEN_BRACKET list_of_path_delay_expressions CLOSE_BRACKET
		;

list_of_path_delay_expressions : path_delay_expression
		| path_delay_expression COMMA path_delay_expression
		| path_delay_expression COMMA path_delay_expression COMMA path_delay_expression
		| path_delay_expression COMMA path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression
		| path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression COMMA
  			path_delay_expression
		;

path_delay_expression: constant_mintypmax_expression
		;

edge_sensitive_path_declaration: OPEN_BRACKET edge_identifier_o 
			specify_input_terminal_descriptor EQ GT
			specify_output_terminal_descriptor polarity_operator_o COLON
			data_source_expression CLOSE_BRACKET EQ path_delay_value
		| OPEN_BRACKET edge_identifier_o list_of_path_inputs STAR GT
  			list_of_path_outputs polarity_operator_o COLON data_source_expression
  			CLOSE_BRACKET EQ path_delay_value
		;

data_source_expression: expression
		;     	

edge_identifier_o : /* empty */
		| edge_identifier
		;     	

edge_identifier	: KW_POSEDGE
		| KW_NEGEDGE
		;

state_dependent_path_declaration: KW_IF OPEN_BRACKET module_path_expression 
			CLOSE_BRACKET simple_path_declaration
		| KW_IF OPEN_BRACKET module_path_expression CLOSE_BRACKET 
  			edge_sensitive_path_declaration
		| KW_IFNONE simple_path_declaration
		;

polarity_operator_o: /* empty */
		| polarity_operator
		;

polarity_operator: PLUS
		| MINUS
		;

/* A.7.5.1 System timing check commands */

system_timing_check: /* empty */

/* A.7.5.2 System timing check command arguments */

/* A.7.5.3 System timing check evet definitions */

/* A.8.1 Concatenations */

concatenation : OPEN_SQ_BRACE expression concatenation_cont
		;

concatenation_cont: CLOSE_SQ_BRACE
		| COMMA expression concatenation_cont
		;

constant_concatenation: OPEN_SQ_BRACE expression constant_concatenation_cont
		;

constant_concatenation_cont: CLOSE_SQ_BRACE
		| COMMA expression concatenation_cont
		;

multiple_concatenation: OPEN_SQ_BRACE constant_expression concatenation CLOSE_SQ_BRACE
		| OPEN_SQ_BRACE constant_expression concatenation_cont
		;

constant_multiple_concatenation: OPEN_SQ_BRACE constant_expression 
			constant_concatenation CLOSE_SQ_BRACE
		| OPEN_SQ_BRACE constant_expression constant_concatenation_cont
		;

module_path_concatenation: OPEN_SQ_BRACE module_path_expression modpath_concatenation_cont
		;

modpath_concatenation_cont: CLOSE_SQ_BRACE
		| COMMA module_path_expression modpath_concatenation_cont
		;

module_path_multiple_concatenation: OPEN_SQ_BRACE constant_expression 
			module_path_concatenation CLOSE_SQ_BRACE
		;

net_concatenation: OPEN_SQ_BRACE net_concatenation_value net_concatenation_cont
		;

net_concatenation_cont: CLOSE_SQ_BRACE
		| COMMA net_concatenation_value net_concatenation_cont
		;

sq_bracket_expressions: OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET
		| OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET
		| OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET sq_bracket_expressions
		;

net_concatenation_value: hierarchical_net_identifier
		| hierarchical_net_identifier sq_bracket_expressions
		| hierarchical_net_identifier sq_bracket_expressions range_expression
		| hierarchical_net_identifier range_expression
		| net_concatenation
		;

variable_concatenation: OPEN_SQ_BRACE variable_concatenation_value 
			variable_concatenation_cont
		;

variable_concatenation_cont: CLOSE_SQ_BRACE
		| COMMA variable_concatenation_value variable_concatenation_cont
		;

variable_concatenation_value: hierarchical_variable_identifier
		| hierarchical_variable_identifier sq_bracket_expressions
		| hierarchical_variable_identifier sq_bracket_expressions 
			range_expression
		| hierarchical_variable_identifier range_expression
		| variable_concatenation
		;


/* A.8.2 Function calls */

constant_expressions: constant_expression
		| constant_expressions COMMA constant_expression
		;

expressions	: expression 
		| expressions COMMA expression
		;

constant_function_call: function_identifier attribute_instances 
			OPEN_BRACKET constant_expressions CLOSE_BRACKET
		;

constant_function_call_pid: attribute_instances OPEN_BRACKET constant_expressions CLOSE_BRACKET
		;

function_call	: hierarchical_function_identifier attribute_instances 
			OPEN_BRACKET expressions CLOSE_BRACKET
		;

system_function_call: system_function_identifier
		| system_function_identifier OPEN_BRACKET CLOSE_BRACKET
		| system_function_identifier OPEN_BRACKET expressions CLOSE_BRACKET
		;

/* A.8.3 Expressions */

conditional_expression : expression TERNARY attribute_instances 
			expression COLON expression
		;

constant_expression: constant_primary
		| unary_operator attribute_instances constant_primary
		| constant_expression PLUS  attribute_instances constant_expression
		| constant_expression MINUS attribute_instances constant_expression
		| constant_expression STAR  attribute_instances constant_expression
		| constant_expression DIV   attribute_instances constant_expression
		| constant_expression MOD   attribute_instances constant_expression
		| constant_expression L_EQ  attribute_instances constant_expression
		| constant_expression L_NEQ attribute_instances constant_expression
		| constant_expression C_EQ  attribute_instances constant_expression
		| constant_expression C_NEQ attribute_instances constant_expression
		| constant_expression L_AND attribute_instances constant_expression
		| constant_expression L_OR  attribute_instances constant_expression
		| constant_expression POW   attribute_instances constant_expression
		| constant_expression LT    attribute_instances constant_expression
		| constant_expression LTE   attribute_instances constant_expression
		| constant_expression GT    attribute_instances constant_expression
		| constant_expression GTE   attribute_instances constant_expression
		| constant_expression B_AND attribute_instances constant_expression
		| constant_expression B_OR  attribute_instances constant_expression
		| constant_expression B_XOR attribute_instances constant_expression
		| constant_expression B_EQU attribute_instances constant_expression
		| constant_expression LSR   attribute_instances constant_expression
		| constant_expression LSL   attribute_instances constant_expression
		| constant_expression ASR   attribute_instances constant_expression
		| constant_expression ASL   attribute_instances constant_expression
		| constant_expression TERNARY attribute_instances 
			constant_expression COLON constant_expression
		| string
		;

constant_mintypmax_expression: constant_expression
		| constant_expression COLON constant_expression COLON constant_expression
		;

constant_range_expression: constant_expression
		| constant_expression COLON       constant_expression
		| constant_expression IDX_PRT_SEL constant_expression
		;

expression	: primary
		| unary_operator attribute_instances primary
		| expression PLUS  attribute_instances expression
		| expression MINUS attribute_instances expression
		| expression STAR  attribute_instances expression
		| expression DIV   attribute_instances expression
		| expression MOD   attribute_instances expression
		| expression L_EQ  attribute_instances expression
		| expression L_NEQ attribute_instances expression
		| expression C_EQ  attribute_instances expression
		| expression C_NEQ attribute_instances expression
		| expression L_AND attribute_instances expression
		| expression L_OR  attribute_instances expression
		| expression POW   attribute_instances expression
		| expression LT    attribute_instances expression
		| expression LTE   attribute_instances expression
		| expression GT    attribute_instances expression
		| expression GTE   attribute_instances expression
		| expression B_AND attribute_instances expression
		| expression B_OR  attribute_instances expression
		| expression B_XOR attribute_instances expression
		| expression B_NOR attribute_instances expression
		| expression B_NAND attribute_instances expression
		| expression B_EQU attribute_instances expression
		| expression LSR   attribute_instances expression
		| expression LSL   attribute_instances expression
		| expression ASR   attribute_instances expression
		| expression ASL   attribute_instances expression
		| conditional_expression
		| string
		;

mintypmax_expression: expression
		| expression COLON expression COLON expression
		;

module_path_conditional_expression: module_path_expression TERNARY 
			attribute_instances module_path_expression
  			COLON module_path_expression
		;

module_path_expression: module_path_primary
		| unary_module_path_operator attribute_instances module_path_primary
		| module_path_expression binary_module_path_operator 
			attribute_instances module_path_expression
		| module_path_conditional_expression
		;

module_path_mintypemax_expression: module_path_expression
		| module_path_expression COLON module_path_expression COLON
			module_path_expression
		;

range_expression: expression
		| expression COLON constant_expression
		| expression IDX_PRT_SEL constant_expression %prec IDX_PRT_SEL
		;

/* A.8.4 Primaries */

constant_primary: constant_concatenation
		| constant_function_call
		| OPEN_BRACKET constant_mintypmax_expression CLOSE_BRACKET
		| constant_multiple_concatenation
		| genvar_identifier
		| number
		| parameter_identifier
		| specparam_identifier
		| text_macro_usage
		;

primary		: number
		| function_call
		| hierarchical_identifier constant_function_call_pid
		| SIMPLE_ID constant_function_call_pid
		| system_function_call
		| hierarchical_identifier sq_bracket_expressions
		| hierarchical_identifier sq_bracket_expressions OPEN_SQ_BRACKET
  			range_expression CLOSE_SQ_BRACKET
		| concatenation
		| multiple_concatenation
		| hierarchical_identifier
		| OPEN_BRACKET mintypmax_expression CLOSE_BRACKET
		| text_macro_usage
		;

module_path_primary: number
		| identifier
		| module_path_concatenation
		| module_path_multiple_concatenation
		| function_call
		| system_function_call
		| constant_function_call
		| OPEN_BRACKET module_path_mintypemax_expression CLOSE_BRACKET
		| text_macro_usage
		;

/* A.8.5 Expression left-side values */

sq_bracket_constant_expressions: OPEN_SQ_BRACKET constant_expression CLOSE_SQ_BRACKET
		| OPEN_SQ_BRACKET constant_expression CLOSE_SQ_BRACKET 
			sq_bracket_constant_expressions
		;

net_lvalue 	: hierarchical_net_identifier
		| hierarchical_net_identifier sq_bracket_constant_expressions
		| hierarchical_net_identifier sq_bracket_constant_expressions 
  			OPEN_SQ_BRACKET constant_range_expression CLOSE_SQ_BRACKET
		| hierarchical_net_identifier OPEN_SQ_BRACKET constant_range_expression
  			CLOSE_SQ_BRACKET
		| net_concatenation
		;

variable_lvalue : hierarchical_variable_identifier
		| hierarchical_variable_identifier sq_bracket_constant_expressions
		| hierarchical_variable_identifier sq_bracket_constant_expressions 
  			OPEN_SQ_BRACKET constant_range_expression CLOSE_SQ_BRACKET
		| hierarchical_variable_identifier OPEN_SQ_BRACKET constant_range_expression
  			CLOSE_SQ_BRACKET
		| variable_concatenation
		;

/* A.8.6 Operators */

unary_operator	: PLUS
		| MINUS
		| L_NEG
		| B_NEG
		| B_AND
		| B_NAND
		| B_OR 
		| B_NOR
		| B_XOR
		| B_EQU
		;


unary_module_path_operator: L_NEG
		| B_NEG
		| B_AND
		| B_NAND
		| B_OR
		| B_NOR
		| B_XOR
		| B_EQU
		;

binary_module_path_operator: L_EQ
		| L_NEQ
		| L_AND
		| L_OR
		| B_AND
		| B_OR
		| B_XOR
		| B_EQU
		;

/* A.8.7 Numbers */

unsigned_number : UNSIGNED_NUMBER
		;

number 		: NUM_REAL
		| BIN_BASE BIN_VALUE
		| HEX_BASE HEX_VALUE
		| OCT_BASE OCT_VALUE
		| DEC_BASE UNSIGNED_NUMBER
		| UNSIGNED_NUMBER BIN_BASE BIN_VALUE
		| UNSIGNED_NUMBER HEX_BASE HEX_VALUE
		| UNSIGNED_NUMBER OCT_BASE OCT_VALUE
		| UNSIGNED_NUMBER DEC_BASE UNSIGNED_NUMBER
		| unsigned_number
		;


/* A.8.8 Strings */

string 		: STRING
	 	;

/* A.9.1 Attributes */

attribute_instances: /* empty */
		| list_of_attribute_instances
		;

list_of_attribute_instances: ATTRIBUTE_START attr_specs ATTRIBUTE_END
		| attribute_instances ATTRIBUTE_START attr_specs ATTRIBUTE_END
		;

attr_specs 	: /* empty */
		| attr_spec
		| attr_specs COMMA attr_spec
		;

attr_spec 	: attr_name EQ constant_expression
		| attr_name 
		;

attr_name 	: identifier
		;  	

/* A.9.2 Comments */

comment		: one_line_comment
		| block_comment
		;

one_line_comment: COMMENT_LINE
		;

block_comment	: COMMENT_BLOCK
		;

/* A.9.3 Identifiers */

escaped_arrayed_identifier: escaped_identifier range_o
		;

escaped_hierarchical_identifier : escaped_hierarchical_branch escaped_hierarchical_identifiers
		| escaped_hierarchical_branch
		;

escaped_hierarchical_identifiers: DOT simple_hierarchical_identifier
		| DOT escaped_hierarchical_identifier
		| escaped_hierarchical_identifiers DOT simple_hierarchical_identifier
		| escaped_hierarchical_identifier DOT escaped_hierarchical_identifiers
		;

anys 		: anys ANY
		| ANY 
     		;


arrayed_identifier: simple_arrayed_identifier
		| escaped_arrayed_identifier
		;


hierarchical_identifier: simple_hierarchical_identifier
		| escaped_hierarchical_identifier
		;

hierarchical_net_identifier: hierarchical_identifier
		;	

hierarchical_variable_identifier: hierarchical_identifier
		;	

hierarchical_task_identifier    : hierarchical_identifier
		;	

hierarchical_block_identifier   : hierarchical_identifier
		;	

hierarchical_event_identifier   : hierarchical_identifier
		;	

hierarchical_function_identifier: hierarchical_identifier
		;	

gate_instance_identifier        : arrayed_identifier
		;	

module_instance_identifier      : arrayed_identifier
		;	

udp_instance_identifier         : arrayed_identifier
		;	

block_identifier                : identifier 
		;	

cell_identifier                 : identifier 
		;	

config_identifier               : identifier 
		;	

event_identifier                : identifier 
		;	

function_identifier             : identifier 
		;	

generate_block_identifier       : identifier 
		;	

genvar_identifier               : identifier 
		;	

inout_port_identifier           : identifier 
		;	

input_port_identifier           : identifier 
		;	

instance_identifier             : identifier 
		;	

library_identifier              : identifier 
		;	

module_identifier               : identifier 
		;	

net_identifier	: identifier 
		| hierarchical_identifier
		;

output_port_identifier		: identifier 
		;	

specparam_identifier		: identifier 
		;	

task_identifier			: identifier 
		;	

topmodule_identifier            : identifier 
		;	

udp_identifier                  : identifier 
		;	

variable_identifier             : identifier 
		;	

parameter_identifier            : identifier 
		| hierarchical_identifier
		;

port_identifier	: identifier 
		;

real_identifier	: identifier 
		;

identifier 	: simple_identifier
		| escaped_identifier
		| text_macro_usage 
		;

simple_identifier: SIMPLE_ID
		| text_macro_usage
		;

escaped_identifier: ESCAPED_ID
		;

simple_arrayed_identifier : simple_identifier range_o
		;

simple_hierarchical_identifier  : simple_hierarchical_branch
		| simple_hierarchical_branch DOT escaped_identifier
		;

system_function_identifier: SYSTEM_ID
		;

system_task_identifier: SYSTEM_ID
		;

/* A.9.4 Identifier Branches */

/* Semantic checking needed to make sure that the "expression"
in the closed brackets reduces to an "unsigned_number" */

simple_hierarchical_branch : SIMPLE_ID
		| SIMPLE_ID OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET
		| SIMPLE_ID OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET
		| simple_hierarchical_branch DOT simple_identifier
		| simple_hierarchical_branch DOT SIMPLE_ID OPEN_SQ_BRACKET expression 
  			CLOSE_SQ_BRACKET
		| simple_hierarchical_branch DOT SIMPLE_ID OPEN_SQ_BRACKET range_expression
  			CLOSE_SQ_BRACKET
		;

/* Semantic checking needed to make sure that the "expression"
in the closed brackets reduces to an "unsigned_number" */

escaped_hierarchical_branch : escaped_hierarchical_branch DOT escaped_identifier
		| escaped_hierarchical_branch DOT escaped_identifier OPEN_SQ_BRACKET
  			expression CLOSE_SQ_BRACKET 
		| escaped_identifier
		| escaped_identifier OPEN_SQ_BRACKET expression CLOSE_SQ_BRACKET
		| escaped_identifier OPEN_SQ_BRACKET range_expression CLOSE_SQ_BRACKET
		;

white_space 	: SPACE 
	     	| TAB 
		| NEWLINE
		;

%%
