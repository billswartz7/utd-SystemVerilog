%{
    #include <verilog/sverilog.h>
    #include "preprocessor.h"
    #include "sverilog.tab.h"
    #include <utd/file.h>
    #include <utd/string.h>

#define YY_FATAL_ERROR(msg) 	sverilog_fatal_error( msg )
    /* I really don't like this as I wanted everything to be reentrant */
    static SVERILOG_PARSEPTR parseS ;

    void verilog_flex_set_info( SVERILOG_PARSEPTR parse_p )
    {
	parseS = parse_p ;
    }  /* verilog_flex_set_info() */

    static void sverilog_fatal_error(yyconst char* msg )
    {
      if( parseS ){
	if( parseS->preproc_out ){
	  fclose( parseS->preproc_out ) ;
	}
      }
      (void) fprintf( stderr, "%s\n", msg );
      exit( -2 );
    }

%}

%option yylineno
%option nodefault 
%option noyywrap 
%option reject 

/* Pre-processor definitions */
CD_DEFAULT_NETTYPE     "`default_nettype"
%x in_default_nettype

CD_LINE                "`line"
%x in_line_1
%x in_line_2
%x in_line_3
%x in_line_4

CD_CELLDEFINE          "`celldefine"
CD_DEFINE              "`define"
CD_RESETALL            "`resetall"
CD_ENDCELLDEFINE       "`endcelldefine"

CD_ELSE                "`else"
CD_ELSIF               "`elsif"
CD_ENDIF               "`endif"
CD_IFDEF               "`ifdef"
CD_IFNDEF              "`ifndef"

%x in_ifdef
%x in_ifndef
%x in_elseif

CD_UNDEF               "`undef"

%x in_undef

CD_NOUNCONNECTED_DRIVE "`nounconnected_drive"
CD_UNCONNECTED_DRIVE   "`unconnected_drive"

%x in_unconnected_drive

/* Include Directives */

CD_INCLUDE             "`include"

%x in_include

/* Times and compiler directives */

CD_TIMESCALE           "`timescale"
TIME_UNITS             "(s|ms|us|ns|ps|fs)"
%x in_ts_1
%x in_ts_2
%x in_ts_3

/* Keyword Token definitions. */
ALWAYS              "always"
AND                 "and"
ASSIGN              "assign"
AUTOMATIC           "automatic"
BEGIN               "begin"
BIT                 "bit"
BUF                 "buf"
BUFIF0              "bufif0"
BUFIF1              "bufif1"
BYTE                "byte"
CASE                "case"
CASEX               "casex"
CASEZ               "casez"
CELL                "cell"
CMOS                "cmos"
CONFIG              "config"
DEASSIGN            "deassign"
DEFAULT             "default"
DEFPARAM            "defparam"
DESIGN              "design"
DISABLE             "disable"
EDGE                "edge"
ELSE                "else"
END                 "end"
ENDCASE             "endcase"
ENDCONFIG           "endconfig"
ENDFUNCTION         "endfunction"
ENDGENERATE         "endgenerate"
ENDMODULE           "endmodule"
ENDPRIMITIVE        "endprimitive"
ENDSPECIFY          "endspecify"
ENDTABLE            "endtable"
ENDTASK             "endtask"
EVENT               "event"
FOR                 "for"
FORCE               "force"
FOREVER             "forever"
FORK                "fork"
FUNCTION            "function"
GENERATE            "generate"
GENVAR              "genvar"
HIGHZ0              "highz0"
HIGHZ1              "highz1"
IF                  "if"
IFNONE              "ifnone"
INCDIR              "-incdir"
INCLUDE             "include"
INITIAL             "initial"
INOUT               "inout"
INPUT               "input"
INSTANCE            "instance"
INT                 "int"
INTEGER             "integer"
JOIN                "join"
LARGE               "large"
LIBLIST             "liblist"
LIBRARY             "library"
LOCALPARAM          "localparam"
LOGIC         	    "logic"
LONGINT        	    "longint"
MACROMODULE         "macromodule"
MEDIUM              "medium"
MODULE              "module"
NAND                "nand"
NEGEDGE             "negedge"
NMOS                "nmos"
NONE                "none"
NOR                 "nor"
NOSHOWCANCELLED     "noshowcancelled"
NOT                 "not"
NOTIF0              "notif0"
NOTIF1              "notif1"
OR                  "or"
OUTPUT              "output"
PARAMETER           "parameter"
PMOS                "pmos"
POSEDGE             "posedge"
PRIMITIVE           "primitive"
PULL0               "pull0"
PULL1               "pull1"
PULLDOWN            "pulldown"
PULLUP              "pullup"
PULSESTYLE_ONEVENT  "pulsestyle_onevent"
PULSESTYLE_ONDETECT "pulsestyle_ondetect"
RCMOS               "rcmos"
REAL                "real"
REALTIME            "realtime"
REG                 "reg"
RELEASE             "release"
REPEAT              "repeat"
RNMOS               "rnmos"
RPMOS               "rpmos"
RTRAN               "rtran"
RTRANIF0            "rtranif0"
RTRANIF1            "rtranif1"
SCALARED            "scalared"
SHORTINT            "shortint"
SHOWCANCELLED       "showcancelled"
SIGNED              "signed"
SMALL               "small"
SPECIFY             "specify"
SPECPARAM           "specparam"
STRONG0             "strong0"
STRONG1             "strong1"
SUPPLY0             "supply0"
SUPPLY1             "supply1"
TABLE               "table"
TASK                "task"
TIME                "time"
TRAN                "tran"
TRANIF0             "tranif0"
TRANIF1             "tranif1"
TRI0                "tri0"
TRI1                "tri1"
TRI                 "tri"
TRIAND              "triand"
TRIOR               "trior"
TRIREG              "trireg"
UNSIGNED            "unsigned"
USE                 "use"
UWIRE               "uwire"
VECTORED            "vectored"
WAIT                "wait"
WAND                "wand"
WEAK0               "weak0"
WEAK1               "weak1"
WHILE               "while"
WIRE                "wire"
WOR                 "wor"
XNOR                "xnor"
XOR                 "xor"

/* System Verilog Keyword Token definitions. */
NULL                "null"
SUPER               "super"
THIS                "this"
TIMEPRECISION       "timeprecision"
TIMEUNIT            "timeunit"
ROOT                "$root."
UNIT                "$unit"
REF                 "ref"
STEP                "step"
STATIC              "static"

/* Single character tokens */

NEWLINE             "\n"|"\r\n"
SPACE               " "
TAB                 "\t"

AT                  "@"
COMMA               ","
HASH                "#"
DOT                 "."
EQ                  "="
COLON               ":"
IDX_PRT_SEL         "+:"|"-:"
SEMICOLON           ";"
OPEN_PAREN          "\("
CLOSE_PAREN         "\)"
OPEN_SQ_BRACKET     "\["
CLOSE_SQ_BRACKET    "\]"
OPEN_CURLBRACE      "{"
CLOSE_CURLBRACE     "}"
DOLLAR_SIGN         "$"
SECOND              "s"
MILLISECOND         "ms"
MICROSECOND         "us"
NANOSECOND          "ns"
PICOSECOND          "ps"
FEMTOSECOND         "fs"


/* Tokens related to numbers */

EXP                 "e"|"E"
UNDERSCORE          "_"
SIGN                {PLUS}|{MINUS}
X                   "x"|"X"
Z                   "z"|"Z"|"?"

DIGIT_DECIMAL       [0-9]
DIGIT_DECMIAL_NZ    [1-9]
DIGIT_BINARY        [0-1]|{X}|{Z}
DIGIT_OCTAL         [0-7]|{X}|{Z}
DIGIT_HEX           [0-9a-fA-F]|{X}|{Z}

BASE_DECIMAL        '[sS]?[dD]
BASE_BINARY         '[sS]?[bB]
BASE_OCTAL          '[sS]?[oO]
BASE_HEX            '[sS]?[hH]

NUM_REAL_EXP        {NUM_UNSIGNED}({DOT}{NUM_UNSIGNED})?{EXP}({SIGN})?{NUM_UNSIGNED}

BIN_VALUE           {DIGIT_BINARY}({UNDERSCORE}|{DIGIT_BINARY})*
OCT_VALUE           {DIGIT_OCTAL}({UNDERSCORE}|{DIGIT_OCTAL})*
HEX_VALUE           {DIGIT_HEX}({UNDERSCORE}|{DIGIT_HEX})*
ASTERISK            [*]

%x in_hex_val
%x in_oct_val
%x in_bin_val
%s in_number

NUM_REAL            {NUM_UNSIGNED}{DOT}{NUM_UNSIGNED}|{NUM_REAL_EXP}
NUM_UNSIGNED        {DIGIT_DECIMAL}({UNDERSCORE}|{DIGIT_DECIMAL})*

/* Identifiers */

SYSTEM_ID           \$[a-zA-Z0-9_\$]+
SIMPLE_ID           [a-zA-Z_][a-zA-Z0-9_$]*
ESCAPED_ID          \\{SIMPLE_ID}
MACRO_IDENTIFIER    `{SIMPLE_ID}

MACRO_TEXT          .*\n

%x in_define
%x in_define_t

/* Attributes */

ATTRIBUTE_START     \(\*
ATTRIBUTE_END       \*\)

/* Comments */
COMMENT_LINE        "//".*\n

COMMENT_BEGIN       "/*"
COMMENT_END         "*/"

%x in_comment

/* Strings */

QSTRING             \".*\"

/* Operators */

STAR                "\*"
PLUS                "+"
MINUS               "-"
ASL                 "<<<"
ASR                 ">>>"
LSL                 "<<"
LSR                 ">>"
DIV                 "/"
POW                 "**"
MOD                 "%"
GTE                 ">="
LTE                 "<="
GT                  ">"
LT                  "<"
L_NEG               "!"
L_AND               "&&"
L_OR                "||"
C_EQ                "==="
L_EQ                "=="
C_NEQ               "!=="
L_NEQ               "!="
B_NEG               "~"
B_AND               "&"
B_OR                "|"
B_XOR               "^"
B_EQU               "^~"|"~^"
B_NAND              "~&"
B_NOR               "~|"
TERNARY             "?"

Space  	    	    [\n\r\t\b ]

%x in_expression

%%
{ATTRIBUTE_START}      {EMIT_TOKEN(parse_p,ATTRIBUTE_START, "(*" );}
{ATTRIBUTE_END}        {EMIT_TOKEN(parse_p,ATTRIBUTE_END, "*)" );}

{COMMENT_LINE}         {/*EMIT_TOKEN(parse_p,COMMENT_LINE); IGNORE */}
{COMMENT_BEGIN}        {BEGIN(in_comment);                    ;}

<in_comment>.|\n       {/* IGNORE                            */}
<in_comment>{COMMENT_END} {BEGIN(INITIAL);                     }

{CD_CELLDEFINE}          {verilog_preproc_enter_cell_define(parse_p);}
{CD_ENDCELLDEFINE}       {verilog_preproc_exit_cell_define(parse_p);}

{CD_DEFAULT_NETTYPE}     {BEGIN(in_default_nettype);}
<in_default_nettype>{Space}+{TRIAND}  {
    BEGIN(INITIAL); 
    verilog_preproc_default_net( parse_p, parse_p->token_count, 
        			 yylineno, NET_TYPE_TRIAND );
    }
<in_default_nettype>{Space}+{TRIOR}   {
    BEGIN(INITIAL); 
    verilog_preproc_default_net( parse_p, parse_p->token_count, 
				 yylineno, NET_TYPE_TRIOR ) ;
    }
<in_default_nettype>{Space}+{TRIREG}     {
    BEGIN(INITIAL); 
    verilog_preproc_default_net( parse_p, parse_p->token_count, 
				 yylineno, NET_TYPE_TRIREG ) ;
    }
<in_default_nettype>{Space}+{TRI0}     {
    BEGIN(INITIAL); 
    verilog_preproc_default_net( parse_p, parse_p->token_count, 
				 yylineno, NET_TYPE_TRI ) ;
    }
<in_default_nettype>{Space}+{TRI}     {
    BEGIN(INITIAL); 
    verilog_preproc_default_net( parse_p, parse_p->token_count, 
				 yylineno, NET_TYPE_TRI ) ;
    }
<in_default_nettype>{Space}+{WIRE}    {
    BEGIN(INITIAL); 
    verilog_preproc_default_net( parse_p, parse_p->token_count, 
        			 yylineno, NET_TYPE_WIRE ) ;
    }
<in_default_nettype>{Space}+{WAND}    {
    BEGIN(INITIAL); 
    verilog_preproc_default_net( parse_p, parse_p->token_count, 
        			 yylineno, NET_TYPE_WAND ) ;
    }
<in_default_nettype>{Space}+{WOR}     {
    BEGIN(INITIAL); 
    verilog_preproc_default_net( parse_p, parse_p->token_count, 
        			 yylineno, NET_TYPE_WOR ) ;
    }
<in_default_nettype>{Space}+{NONE}    {
    BEGIN(INITIAL); 
    verilog_preproc_default_net( parse_p, parse_p->token_count, 
        			 yylineno, NET_TYPE_WOR ) ;
    }
<in_default_nettype>.     {
    BEGIN(INITIAL); 
    fprintf( stderr, "ERROR:unknown default net type:%s on line:%d\n", 
       yytext, yylineno ) ;

    }

{CD_TIMESCALE}           {
    BEGIN(in_ts_1);
}
<in_ts_1>{NUM_UNSIGNED}      {
    parse_p->timescale.scale = sverilog_lval.string ;
}
<in_ts_1>{SIMPLE_ID}         {
    BEGIN(in_ts_2);
}
<in_ts_2>{DIV}               {
    BEGIN(in_ts_3);
}
<in_ts_3>{NUM_UNSIGNED}      {
    parse_p->timescale.precision = sverilog_lval.string ;
}
<in_ts_3>{SIMPLE_ID}         {
    BEGIN(INITIAL);
}

{CD_RESETALL}            {
    verilog_preprocessor_resetall( parse_p ) ;
}

{CD_IFDEF}               {
    BEGIN(in_ifdef);
}
<in_ifdef>{SIMPLE_ID}    {
    verilog_preprocessor_ifdef( parse_p,yytext,yylineno,SVERILOG_FALSE) ;
    BEGIN(INITIAL);
}

{CD_IFNDEF}              {
    BEGIN(in_ifndef);
}
<in_ifndef>{SIMPLE_ID}   {
    verilog_preprocessor_ifdef( parse_p,yytext,yylineno,SVERILOG_TRUE) ;
    BEGIN(INITIAL);
}

{CD_ELSIF}               {
    BEGIN(in_elseif);
}
<in_elseif>{SIMPLE_ID}   {
    verilog_preprocessor_elseif( parse_p,yytext, yylineno) ;
    BEGIN(INITIAL);
}

{CD_ELSE}                {
    verilog_preprocessor_else( parse_p,yylineno ) ;
}

{CD_ENDIF}               {
    verilog_preprocessor_endif( parse_p,yylineno) ;
}

{CD_INCLUDE}             {
    BEGIN(in_include);
}
<in_include>{QSTRING}     {
    YY_BUFFER_STATE cur = YY_CURRENT_BUFFER;

    VERILOG_FILEPTR id_p = verilog_preprocessor_include( parse_p,yytext,yylineno) ;

    // Now, we need to look for the file, open it as a buffer, and then 
    // switch to it.

    if( id_p->file_exists == SVERILOG_TRUE ) {
        id_p->fp = UTDOPEN( id_p->filename,"r",FILE_NOABORT|FILE_VERBOSE ) ;

	if( id_p->fp ){
	  YY_BUFFER_STATE n = yy_create_buffer(id_p->fp, YY_BUF_SIZE) ;
	  cur ->yy_bs_lineno = yylineno;
	  yy_switch_to_buffer(cur) ;
	  yypush_buffer_state(n) ;
	  BEGIN(INITIAL);
	} else {
	  fprintf(stderr,"ERROR - Could not open file %s on line %d for reading...\n",
            id_p->filename, id_p->lineNumber ) ;
	}
    } else {
        fprintf(stderr,"ERROR - Could not find include file %s on line %d\n",
            id_p->filename, id_p->lineNumber ) ;
        fprintf(stderr,"\tExpect stuff to break now.\n");
    }
    
    BEGIN(INITIAL);
}

{CD_LINE}                 {BEGIN(in_line_1);}
<in_line_1>{INTEGER}      {BEGIN(in_line_2);}
<in_line_1>{NUM_UNSIGNED} {BEGIN(in_line_2);}
<in_line_2>{QSTRING}      {BEGIN(in_line_3);}
<in_line_3>{INTEGER}      {BEGIN(INITIAL);}
<in_line_3>{NUM_UNSIGNED} {BEGIN(INITIAL);}

{CD_NOUNCONNECTED_DRIVE} {
    verilog_preprocessor_nounconnected_drive( parse_p,STRENGTH_NONE ) ;
}
{CD_UNCONNECTED_DRIVE}   {
    BEGIN(in_unconnected_drive);
}
<in_unconnected_drive>{PULL0} {
    verilog_preprocessor_nounconnected_drive( parse_p,STRENGTH_PULL0 ) ;
    BEGIN(INITIAL);
}
<in_unconnected_drive>{PULL1} {
    verilog_preprocessor_nounconnected_drive( parse_p,STRENGTH_PULL1 ) ;
    BEGIN(INITIAL);
}

{CD_DEFINE}              {
    BEGIN(in_define);
}

<in_define>{SIMPLE_ID}   {
    parse_p->scratch = UTDstrclone( yytext ) ;
    BEGIN(in_define_t);
}

<in_define_t>{MACRO_TEXT} {
    if(yyleng == 1)
    {
        // Macro has no value, and is just a newline character.
        verilog_preprocessor_macro_define(
	    parse_p,
            yylineno-1,
            parse_p->scratch,
            NULL,
            0); // -1 to avoid including the newline.
    }
    else
    {
        // Macro has a proper value.
        verilog_preprocessor_macro_define(
	    parse_p,
            yylineno-1,
            parse_p->scratch,
            yytext+1,
            yyleng-2); // -1 to avoid including the newline.
    }
    BEGIN(INITIAL);
}

{CD_UNDEF}             {
    BEGIN(in_undef);
}

<in_undef>{SIMPLE_ID}  {
    verilog_preprocessor_macro_undefine(
	parse_p,
        yytext
    );
    BEGIN(INITIAL);
}

{MACRO_IDENTIFIER}     {

    /* Look for the macro entry. */
    UTDHASH_ENTRYPTR entry_p ;          
    VERILOG_MACRO_DIRECTIVEPTR macro_p = NULL ;
    char * macroName = (yytext)+ 1;
    entry_p = UTDhash_find( parse_p-> macrodefines, macroName ) ;
    
    if( entry_p ){
      macro_p = UTDHASH_GETDATA( entry_p, VERILOG_MACRO_DIRECTIVEPTR ) ;
    }
    if( macro_p ){
        // Switch buffers to expand the macro.
        YY_BUFFER_STATE cur = YY_CURRENT_BUFFER;
        YY_BUFFER_STATE n   = yy_scan_string( macro_p->macro_value ) ;
        yy_switch_to_buffer(cur);
        yypush_buffer_state(n);
	// Push an empty file with no info so our stacks match
	VERILOG_FILEPTR file_info_p = UTDCALLOC( 1, VERILOG_FILE ) ;
	UTDdeck_push( parse_p->file_stack, file_info_p ) ;

    } else {
        // Undefined macro - PANIC!
        fprintf(stderr,"ERROR: Undefined macro '%s' on line %d\n", 
	yytext, yylineno) ;
        fprintf(stderr,"\tIt's probably all going to fall apart now...\n\n");
    }
}

{AT}                   {EMIT_TOKEN(parse_p,AT,"@" );}
{COMMA}                {EMIT_TOKEN(parse_p,COMMA,"," );}
{HASH}                 {EMIT_TOKEN(parse_p,HASH,"#" );}
{DOT}                  {EMIT_TOKEN(parse_p,DOT,"." );}
{EQ}                   {sverilog_lval.operator = OPERATOR_L_EQ; EMIT_TOKEN(parse_p,EQ,"=" );}
{COLON}                {EMIT_TOKEN(parse_p,COLON,":" );}
{IDX_PRT_SEL}          {EMIT_TOKEN(parse_p,IDX_PRT_SEL,"+=" );}
{SEMICOLON}            {EMIT_TOKEN(parse_p,SEMICOLON,";" );}
{OPEN_PAREN}           {EMIT_TOKEN(parse_p,OPEN_PAREN,"(" );}
{CLOSE_PAREN}          {EMIT_TOKEN(parse_p,CLOSE_PAREN,")" );}
{OPEN_SQ_BRACKET}      {EMIT_TOKEN(parse_p,OPEN_SQ_BRACKET,"[" );}
{CLOSE_SQ_BRACKET}     {EMIT_TOKEN(parse_p,CLOSE_SQ_BRACKET,"]" );}
{OPEN_CURLBRACE}       {EMIT_TOKEN(parse_p,OPEN_CURLBRACE,"{" );}
{CLOSE_CURLBRACE}      {EMIT_TOKEN(parse_p,CLOSE_CURLBRACE,"}" );}
{STAR}                 {sverilog_lval.operator=OPERATOR_STAR   ; EMIT_TOKEN(parse_p,STAR,"*" );}
{PLUS}                 {sverilog_lval.operator=OPERATOR_PLUS   ; EMIT_TOKEN(parse_p,PLUS,"+" );}
{MINUS}                {sverilog_lval.operator=OPERATOR_MINUS  ; EMIT_TOKEN(parse_p,MINUS,"-" );}
{ASL}                  {sverilog_lval.operator=OPERATOR_ASL    ; EMIT_TOKEN(parse_p,ASL,"<<<" );}
{ASR}                  {sverilog_lval.operator=OPERATOR_ASR    ; EMIT_TOKEN(parse_p,ASR,">>>" );}
{LSL}                  {sverilog_lval.operator=OPERATOR_LSL    ; EMIT_TOKEN(parse_p,LSL,"<<" );}
{LSR}                  {sverilog_lval.operator=OPERATOR_LSR    ; EMIT_TOKEN(parse_p,LSR,">>" );}
{DIV}                  {sverilog_lval.operator=OPERATOR_DIV    ; EMIT_TOKEN(parse_p,DIV,"/" );}
{POW}                  {sverilog_lval.operator=OPERATOR_POW    ; EMIT_TOKEN(parse_p,POW,"**" );}
{MOD}                  {sverilog_lval.operator=OPERATOR_MOD    ; EMIT_TOKEN(parse_p,MOD,"%" );}
{GTE}                  {sverilog_lval.operator=OPERATOR_GTE    ; EMIT_TOKEN(parse_p,GTE,">=" );}
{LTE}                  {sverilog_lval.operator=OPERATOR_LTE    ; EMIT_TOKEN(parse_p,LTE,"<=" );}
{GT}                   {sverilog_lval.operator=OPERATOR_GT     ; EMIT_TOKEN(parse_p,GT, ">" );}
{LT}                   {sverilog_lval.operator=OPERATOR_LT     ; EMIT_TOKEN(parse_p,LT, "<" );}
{L_NEG}                {sverilog_lval.operator=OPERATOR_L_NEG  ; EMIT_TOKEN(parse_p,L_NEG,"!" );}
{L_AND}                {sverilog_lval.operator=OPERATOR_L_AND  ; EMIT_TOKEN(parse_p,L_AND, "&&" );}
{L_OR}                 {sverilog_lval.operator=OPERATOR_L_OR   ; EMIT_TOKEN(parse_p,L_OR, "||" );}
{C_EQ}                 {sverilog_lval.operator=OPERATOR_C_EQ   ; EMIT_TOKEN(parse_p,C_EQ, "===" );}
{L_EQ}                 {sverilog_lval.operator=OPERATOR_L_EQ   ; EMIT_TOKEN(parse_p,L_EQ, "==" );}
{C_NEQ}                {sverilog_lval.operator=OPERATOR_C_NEQ  ; EMIT_TOKEN(parse_p,C_NEQ, "!==" );}
{L_NEQ}                {sverilog_lval.operator=OPERATOR_L_NEQ  ; EMIT_TOKEN(parse_p,L_NEQ, "!=" );}
{B_NEG}                {sverilog_lval.operator=OPERATOR_B_NEG  ; EMIT_TOKEN(parse_p,B_NEG, "~" );}
{B_AND}                {sverilog_lval.operator=OPERATOR_B_AND  ; EMIT_TOKEN(parse_p,B_AND, "&" );}
{B_OR}                 {sverilog_lval.operator=OPERATOR_B_OR   ; EMIT_TOKEN(parse_p,B_OR, "|" );}
{B_XOR}                {sverilog_lval.operator=OPERATOR_B_XOR  ; EMIT_TOKEN(parse_p,B_XOR, "^" );}
{B_EQU}                {sverilog_lval.operator=OPERATOR_B_EQU  ; EMIT_TOKEN(parse_p,B_EQU, "^~" );}
{B_NAND}               {sverilog_lval.operator=OPERATOR_B_NAND ; EMIT_TOKEN(parse_p,B_NAND, "~&" );}
{B_NOR}                {sverilog_lval.operator=OPERATOR_B_NOR  ; EMIT_TOKEN(parse_p,B_NOR, "~|" );}
{TERNARY}              {sverilog_lval.operator=OPERATOR_TERNARY; EMIT_TOKEN(parse_p,TERNARY, "?" );}

{BASE_DECIMAL}         {EMIT_TOKEN(parse_p,DEC_BASE, "d" );}
{BASE_HEX}             {BEGIN(in_hex_val); EMIT_TOKEN(parse_p,HEX_BASE, "h");}
{BASE_OCTAL}           {BEGIN(in_oct_val); EMIT_TOKEN(parse_p,OCT_BASE, "o");}
{BASE_BINARY}          {BEGIN(in_bin_val); EMIT_TOKEN(parse_p,BIN_BASE, "b" );}

<in_bin_val>{BIN_VALUE} {BEGIN(INITIAL); sverilog_lval.string = yytext; EMIT_TOKEN(parse_p,BIN_VALUE,"b" );}
<in_oct_val>{OCT_VALUE} {BEGIN(INITIAL); sverilog_lval.string = yytext; EMIT_TOKEN(parse_p,OCT_VALUE,"o" );}
<in_hex_val>{HEX_VALUE} {BEGIN(INITIAL); sverilog_lval.string = yytext; EMIT_TOKEN(parse_p,HEX_VALUE,"h" );}

{NUM_REAL}             {sverilog_lval.string=yytext;EMIT_TOKEN(parse_p,NUM_REAL, NULL );}
{NUM_UNSIGNED}         {sverilog_lval.string=yytext;EMIT_TOKEN(parse_p,UNSIGNED_NUMBER, NULL );}

{ALWAYS}               {EMIT_TOKEN(parse_p,KW_ALWAYS,"always");} 
{AND}                  {EMIT_TOKEN(parse_p,KW_AND,"and");} 
{ASSIGN}               {EMIT_TOKEN(parse_p,KW_ASSIGN,"assign");} 
{AUTOMATIC}            {EMIT_TOKEN(parse_p,KW_AUTOMATIC,"automatic");} 
{BEGIN}                {EMIT_TOKEN(parse_p,KW_BEGIN,"begin");} 
{BIT}                  {EMIT_SVTOKEN(parse_p,KW_BIT,"bit");} 
{BUF}                  {EMIT_TOKEN(parse_p,KW_BUF,"buf");} 
{BUFIF0}               {EMIT_TOKEN(parse_p,KW_BUFIF0,"bufif0");} 
{BUFIF1}               {EMIT_TOKEN(parse_p,KW_BUFIF1,"bufif1");} 
{BYTE}                 {EMIT_SVTOKEN(parse_p,KW_BYTE,"byte");} 
{CASE}                 {EMIT_TOKEN(parse_p,KW_CASE,"case");} 
{CASEX}                {EMIT_TOKEN(parse_p,KW_CASEX,"casex");} 
{CASEZ}                {EMIT_TOKEN(parse_p,KW_CASEZ,"casez");} 
{CELL}                 {EMIT_TOKEN(parse_p,KW_CELL,"cell");} 
{CMOS}                 {EMIT_TOKEN(parse_p,KW_CMOS,"cmos");} 
{CONFIG}               {EMIT_TOKEN(parse_p,KW_CONFIG,"config");} 
{DEASSIGN}             {EMIT_TOKEN(parse_p,KW_DEASSIGN,"deassign");} 
{DEFAULT}              {EMIT_TOKEN(parse_p,KW_DEFAULT,"default");} 
{DEFPARAM}             {EMIT_TOKEN(parse_p,KW_DEFPARAM,"defparam");} 
{DESIGN}               {EMIT_TOKEN(parse_p,KW_DESIGN,"design");} 
{DISABLE}              {EMIT_TOKEN(parse_p,KW_DISABLE,"disable");} 
{EDGE}                 {EMIT_TOKEN(parse_p,KW_EDGE,"edge");} 
{ELSE}                 {EMIT_TOKEN(parse_p,KW_ELSE,"else");} 
{END}                  {EMIT_TOKEN(parse_p,KW_END,"end");} 
{ENDCASE}              {EMIT_TOKEN(parse_p,KW_ENDCASE,"endcase");} 
{ENDCONFIG}            {EMIT_TOKEN(parse_p,KW_ENDCONFIG,"endconfig");} 
{ENDFUNCTION}          {EMIT_TOKEN(parse_p,KW_ENDFUNCTION,"endfunction");} 
{ENDGENERATE}          {EMIT_TOKEN(parse_p,KW_ENDGENERATE,"endgenerate");} 
{ENDMODULE}            {EMIT_TOKEN(parse_p,KW_ENDMODULE,"endmodule");} 
{ENDPRIMITIVE}         {EMIT_TOKEN(parse_p,KW_ENDPRIMITIVE,"endprimitive");} 
{ENDSPECIFY}           {EMIT_TOKEN(parse_p,KW_ENDSPECIFY,"endspecify");} 
{ENDTABLE}             {EMIT_TOKEN(parse_p,KW_ENDTABLE,"endtable");} 
{ENDTASK}              {EMIT_TOKEN(parse_p,KW_ENDTASK,"endtask");} 
{EVENT}                {EMIT_TOKEN(parse_p,KW_EVENT,"event");} 
{FOR}                  {EMIT_TOKEN(parse_p,KW_FOR,"for");} 
{FORCE}                {EMIT_TOKEN(parse_p,KW_FORCE,"force");} 
{FOREVER}              {EMIT_TOKEN(parse_p,KW_FOREVER,"forever");} 
{FORK}                 {EMIT_TOKEN(parse_p,KW_FORK,"fork");} 
{FUNCTION}             {EMIT_TOKEN(parse_p,KW_FUNCTION,"function");} 
{GENERATE}             {EMIT_TOKEN(parse_p,KW_GENERATE,"generate");} 
{GENVAR}               {EMIT_TOKEN(parse_p,KW_GENVAR,"genvar");} 
{HIGHZ0}               {EMIT_TOKEN(parse_p,KW_HIGHZ0,"highz0");} 
{HIGHZ1}               {EMIT_TOKEN(parse_p,KW_HIGHZ1,"highz1");} 
{IF}                   {EMIT_TOKEN(parse_p,KW_IF,"if");} 
{IFNONE}               {EMIT_TOKEN(parse_p,KW_IFNONE,"ifnone");} 
{INCDIR}               {EMIT_TOKEN(parse_p,KW_INCDIR,"incdir");} 
{INCLUDE}              {EMIT_TOKEN(parse_p,KW_INCLUDE,"include");} 
{INITIAL}              {EMIT_TOKEN(parse_p,KW_INITIAL,"initial");} 
{INOUT}                {EMIT_TOKEN(parse_p,KW_INOUT,"inout");} 
{INPUT}                {EMIT_TOKEN(parse_p,KW_INPUT,"input");} 
{INSTANCE}             {EMIT_TOKEN(parse_p,KW_INSTANCE,"instance");} 
{INTEGER}              {EMIT_TOKEN(parse_p,KW_INTEGER,"integer");} 
{INT}                  {EMIT_SVTOKEN(parse_p,KW_INT,"int");} 
{JOIN}                 {EMIT_TOKEN(parse_p,KW_JOIN,"join");} 
{LARGE}                {EMIT_TOKEN(parse_p,KW_LARGE,"large");} 
{LIBLIST}              {EMIT_TOKEN(parse_p,KW_LIBLIST,"liblist");} 
{LIBRARY}              {EMIT_TOKEN(parse_p,KW_LIBRARY,"library");} 
{LOCALPARAM}           {EMIT_TOKEN(parse_p,KW_LOCALPARAM,"localparam");} 
{LOGIC}                {EMIT_SVTOKEN(parse_p,KW_LOGIC,"logic");} 
{LONGINT}              {EMIT_SVTOKEN(parse_p,KW_LONGINT,"longint");} 
{MACROMODULE}          {EMIT_TOKEN(parse_p,KW_MACROMODULE,"macromodule");} 
{MEDIUM}               {EMIT_TOKEN(parse_p,KW_MEDIUM,"medium");} 
{MODULE}               {EMIT_TOKEN(parse_p,KW_MODULE,"module");} 
{NAND}                 {EMIT_TOKEN(parse_p,KW_NAND,"nand");} 
{NEGEDGE}              {EMIT_TOKEN(parse_p,KW_NEGEDGE,"negedge");} 
{NMOS}                 {EMIT_TOKEN(parse_p,KW_NMOS,"nmos");} 
{NOR}                  {EMIT_TOKEN(parse_p,KW_NOR,"nor");} 
{NOSHOWCANCELLED}      {EMIT_TOKEN(parse_p,KW_NOSHOWCANCELLED,"noshowcancelled");} 
{NOT}                  {EMIT_TOKEN(parse_p,KW_NOT,"not");} 
{NOTIF0}               {EMIT_TOKEN(parse_p,KW_NOTIF0,"notif0");} 
{NOTIF1}               {EMIT_TOKEN(parse_p,KW_NOTIF1,"notif1");} 
{NULL}                 {EMIT_SVTOKEN(parse_p,KW_NULL,"null");} 
{OR}                   {EMIT_TOKEN(parse_p,KW_OR,"or");} 
{OUTPUT}               {EMIT_TOKEN(parse_p,KW_OUTPUT,"output");} 
{PARAMETER}            {EMIT_TOKEN(parse_p,KW_PARAMETER,"parameter");} 
{PMOS}                 {EMIT_TOKEN(parse_p,KW_PMOS,"pmos");} 
{POSEDGE}              {EMIT_TOKEN(parse_p,KW_POSEDGE,"posedge");} 
{PRIMITIVE}            {EMIT_TOKEN(parse_p,KW_PRIMITIVE,"primitive");} 
{PULL0}                {EMIT_TOKEN(parse_p,KW_PULL0,"pull0");} 
{PULL1}                {EMIT_TOKEN(parse_p,KW_PULL1,"pull1");} 
{PULLDOWN}             {EMIT_TOKEN(parse_p,KW_PULLDOWN,"pulldown");} 
{PULLUP}               {EMIT_TOKEN(parse_p,KW_PULLUP,"pullup");} 
{PULSESTYLE_ONEVENT}   {EMIT_TOKEN(parse_p,KW_PULSESTYLE_ONEVENT,"pulsestyle_onevent");} 
{PULSESTYLE_ONDETECT}  {EMIT_TOKEN(parse_p,KW_PULSESTYLE_ONDETECT,"pulsestyle_ondetect");} 
{RCMOS}                {EMIT_TOKEN(parse_p,KW_RCMOS,"rcmos");} 
{REAL}                 {EMIT_TOKEN(parse_p,KW_REAL,"real");} 
{REALTIME}             {EMIT_TOKEN(parse_p,KW_REALTIME,"realtime");} 
{REF}   	       {EMIT_SVTOKEN(parse_p,KW_REF,"ref");} 
{REG}                  {EMIT_TOKEN(parse_p,KW_REG,"reg");} 
{RELEASE}              {EMIT_TOKEN(parse_p,KW_RELEASE,"release");} 
{REPEAT}               {EMIT_TOKEN(parse_p,KW_REPEAT,"repeat");} 
{RNMOS}                {EMIT_TOKEN(parse_p,KW_RNMOS,"rnmos");} 
{RPMOS}                {EMIT_TOKEN(parse_p,KW_RPMOS,"rpmos");} 
{RTRAN}                {EMIT_TOKEN(parse_p,KW_RTRAN,"rtran");} 
{RTRANIF0}             {EMIT_TOKEN(parse_p,KW_RTRANIF0,"rtranif0");} 
{RTRANIF1}             {EMIT_TOKEN(parse_p,KW_RTRANIF1,"rtranif1");} 
{SCALARED}             {EMIT_TOKEN(parse_p,KW_SCALARED,"scalared");} 
{SHORTINT}             {EMIT_SVTOKEN(parse_p,KW_SHORTINT,"shortint");} 
{SHOWCANCELLED}        {EMIT_TOKEN(parse_p,KW_SHOWCANCELLED,"showcancelled");} 
{SIGNED}               {EMIT_TOKEN(parse_p,KW_SIGNED,"signed");} 
{SMALL}                {EMIT_TOKEN(parse_p,KW_SMALL,"small") ;} 
{SPECIFY}              {EMIT_TOKEN(parse_p,KW_SPECIFY,"specify");} 
{SPECPARAM}            {EMIT_TOKEN(parse_p,KW_SPECPARAM,"specparam");} 
{STRONG0}              {EMIT_TOKEN(parse_p,KW_STRONG0,"strong0");} 
{STRONG1}              {EMIT_TOKEN(parse_p,KW_STRONG1,"strong1");} 
{SUPER}                {EMIT_SVTOKEN(parse_p,KW_SUPER,"super");} 
{SUPPLY0}              {EMIT_TOKEN(parse_p,KW_SUPPLY0,"supply0");} 
{SUPPLY1}              {EMIT_TOKEN(parse_p,KW_SUPPLY1,"supply1");} 
{TABLE}                {EMIT_TOKEN(parse_p,KW_TABLE,"table");} 
{TASK}                 {EMIT_TOKEN(parse_p,KW_TASK,"task");} 
{THIS}                 {EMIT_SVTOKEN(parse_p,KW_THIS,"this");} 
{TIME}                 {EMIT_TOKEN(parse_p,KW_TIME,"time");} 
{TIMEPRECISION}        {EMIT_SVTOKEN(parse_p,KW_TIMEPRECISION,"timeprecision");} 
{TIMEUNIT}             {EMIT_SVTOKEN(parse_p,KW_TIMEUNIT,"timeunit");} 
{TRAN}                 {EMIT_TOKEN(parse_p,KW_TRAN,"tran");} 
{TRANIF0}              {EMIT_TOKEN(parse_p,KW_TRANIF0,"tranif0");} 
{TRANIF1}              {EMIT_TOKEN(parse_p,KW_TRANIF1,"tranif1");} 
{TRI0}                 {EMIT_TOKEN(parse_p,KW_TRI0,"tri0");} 
{TRI1}                 {EMIT_TOKEN(parse_p,KW_TRI1,"tri1");} 
{TRIAND}               {EMIT_TOKEN(parse_p,KW_TRIAND,"triand");} 
{TRIOR}                {EMIT_TOKEN(parse_p,KW_TRIOR,"trior");} 
{TRIREG}               {EMIT_TOKEN(parse_p,KW_TRIREG,"trireg");} 
{TRI}                  {EMIT_TOKEN(parse_p,KW_TRI,"tri");} 
{UNSIGNED}             {EMIT_TOKEN(parse_p,KW_UNSIGNED,"unsigned");} 
{UWIRE}                {EMIT_TOKEN(parse_p,KW_UWIRE,"uwire");} 
{USE}                  {EMIT_TOKEN(parse_p,KW_USE,"use");} 
{VECTORED}             {EMIT_TOKEN(parse_p,KW_VECTORED,"vectored");} 
{WAIT}                 {EMIT_TOKEN(parse_p,KW_WAIT,"wait");} 
{WAND}                 {EMIT_TOKEN(parse_p,KW_WAND,"wand");} 
{WEAK0}                {EMIT_TOKEN(parse_p,KW_WEAK0,"weak0");} 
{WEAK1}                {EMIT_TOKEN(parse_p,KW_WEAK1,"weak1");} 
{WHILE}                {EMIT_TOKEN(parse_p,KW_WHILE,"while");} 
{WIRE}                 {EMIT_TOKEN(parse_p,KW_WIRE,"wire");} 
{WOR}                  {EMIT_TOKEN(parse_p,KW_WOR,"wor");} 
{XNOR}                 {EMIT_TOKEN(parse_p,KW_XNOR,"xnor");} 
{XOR}                  {EMIT_TOKEN(parse_p,KW_XOR,"xor");} 

{ASTERISK}	       {EMIT_SVTOKEN(parse_p,KW_ASTERISK,"*");}
{DOLLAR_SIGN}          {EMIT_TOKEN(parse_p,KW_DOLLAR_SIGN,"$");} 
{TIME_UNITS}           {EMIT_SVTOKEN(parse_p,KW_TIMEUNITS,"time_units");}
{STATIC}               {EMIT_SVTOKEN(parse_p,KW_STEP,"static");}
{STEP}                 {EMIT_SVTOKEN(parse_p,KW_STEP,"step");}
{UNIT}                 {EMIT_SVTOKEN(parse_p,KW_UNIT,"$unit");}

{SYSTEM_ID}            {
    sverilog_lval.identifier = sverilog_new_identifier(parse_p,yytext,yylineno); 
    EMIT_TOKEN(parse_p,SYSTEM_ID,NULL);
}

<in_expression>\[[0-9]*\] {
    BEGIN(INITIAL) ;
    fprintf( stderr, "we found an expression\n" ) ;
    sverilog_lval.identifier = sverilog_new_identifier(parse_p,yytext,yylineno); 
    EMIT_TOKEN(parse_p,SVID,NULL);
}
<in_expression>\[[0-9:]*\] {
    BEGIN(INITIAL) ;
    fprintf( stderr, "we found a range expression\n" ) ;
    sverilog_lval.identifier = sverilog_new_identifier(parse_p,yytext,yylineno); 
    EMIT_TOKEN(parse_p,SVID,NULL);
}
<in_expression>[^\[] {
    BEGIN(INITIAL) ;
    unput(yytext[0]) ;
    EMIT_TOKEN(parse_p,SVID,NULL);
}

{ESCAPED_ID}           {
    if( parse_p->check_for_expression ){
      BEGIN(in_expression) ;
    } else {
      sverilog_lval.identifier = sverilog_new_identifier(parse_p,yytext,yylineno); 
      EMIT_TOKEN(parse_p,ESCAPED_ID,NULL);
    }
}
{SIMPLE_ID}            {
    if( parse_p->check_for_expression ){
      fprintf( stderr, "checking line:%d when we have:%s\n", yylineno, yytext ) ;
      BEGIN(in_expression) ;
    } else {
      sverilog_lval.identifier = sverilog_new_identifier(parse_p,yytext,yylineno); 
      EMIT_TOKEN(parse_p,SIMPLE_ID,NULL);
    }
}

{QSTRING}              {sverilog_lval.string = yytext;EMIT_TOKEN(parse_p,QSTRING,NULL);}

<*>{NEWLINE}           { verilog_preproc(parse_p,NEWLINE,"\n") ;/* IGNORE */ }
<*>{SPACE}             { verilog_preproc(parse_p,SPACE," " ) ;  /* IGNORE */ }
<*>{TAB}               { verilog_preproc(parse_p,TAB, "\t");    /* IGNORE */ }

<<EOF>> {

    yypop_buffer_state();

    // We are exiting a file, so pop from the the preprocessor stack of files
    // being parsed.
    verilog_pop_file_stack( parse_p ) ;

    if ( !(YY_CURRENT_BUFFER) ) {
      yyterminate() ;
    } else {
      YY_BUFFER_STATE cur = YY_CURRENT_BUFFER ;
      yylineno = cur->yy_bs_lineno ;
    }
}

.   { EMIT_TOKEN(parse_p,ANY,NULL) ;}

%%
