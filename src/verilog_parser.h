/* A Bison parser, made by GNU Bison 3.0.5.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018 Free Software Foundation, Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

#ifndef YY_OPEN_VERILOG_VERILOG_PARSER_H_INCLUDED
# define YY_OPEN_VERILOG_VERILOG_PARSER_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif
#if YYDEBUG
extern int open_verilogdebug;
#endif
/* "%code requires" blocks.  */
#line 26 "verilog_parser.y" /* yacc.c:1916  */

    #include <verilog/ast.h>

#line 48 "verilog_parser.h" /* yacc.c:1916  */

/* Token type.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    ANY = 258,
    END = 259,
    NEWLINE = 260,
    SPACE = 261,
    TAB = 262,
    AT = 263,
    COMMA = 264,
    HASH = 265,
    DOT = 266,
    EQ = 267,
    COLON = 268,
    IDX_PRT_SEL = 269,
    SEMICOLON = 270,
    OPEN_BRACKET = 271,
    CLOSE_BRACKET = 272,
    OPEN_SQ_BRACKET = 273,
    CLOSE_SQ_BRACKET = 274,
    OPEN_SQ_BRACE = 275,
    CLOSE_SQ_BRACE = 276,
    BIN_VALUE = 277,
    OCT_VALUE = 278,
    HEX_VALUE = 279,
    DEC_BASE = 280,
    BIN_BASE = 281,
    OCT_BASE = 282,
    HEX_BASE = 283,
    NUM_REAL = 284,
    NUM_SIZE = 285,
    UNSIGNED_NUMBER = 286,
    SYSTEM_ID = 287,
    SIMPLE_ID = 288,
    ESCAPED_ID = 289,
    DEFINE_ID = 290,
    ATTRIBUTE_START = 291,
    ATTRIBUTE_END = 292,
    COMMENT_LINE = 293,
    COMMENT_BLOCK = 294,
    STRING = 295,
    STAR = 296,
    PLUS = 297,
    MINUS = 298,
    ASL = 299,
    ASR = 300,
    LSL = 301,
    LSR = 302,
    DIV = 303,
    POW = 304,
    MOD = 305,
    GTE = 306,
    LTE = 307,
    GT = 308,
    LT = 309,
    L_NEG = 310,
    L_AND = 311,
    L_OR = 312,
    C_EQ = 313,
    L_EQ = 314,
    C_NEQ = 315,
    L_NEQ = 316,
    B_NEG = 317,
    B_AND = 318,
    B_OR = 319,
    B_XOR = 320,
    B_EQU = 321,
    B_NAND = 322,
    B_NOR = 323,
    TERNARY = 324,
    UNARY_OP = 325,
    MACRO_TEXT = 326,
    MACRO_IDENTIFIER = 327,
    KW_ALWAYS = 328,
    KW_AND = 329,
    KW_ASSIGN = 330,
    KW_AUTOMATIC = 331,
    KW_BEGIN = 332,
    KW_BUF = 333,
    KW_BUFIF0 = 334,
    KW_BUFIF1 = 335,
    KW_CASE = 336,
    KW_CASEX = 337,
    KW_CASEZ = 338,
    KW_CELL = 339,
    KW_CMOS = 340,
    KW_CONFIG = 341,
    KW_DEASSIGN = 342,
    KW_DEFAULT = 343,
    KW_DEFPARAM = 344,
    KW_DESIGN = 345,
    KW_DISABLE = 346,
    KW_EDGE = 347,
    KW_ELSE = 348,
    KW_END = 349,
    KW_ENDCASE = 350,
    KW_ENDCONFIG = 351,
    KW_ENDFUNCTION = 352,
    KW_ENDGENERATE = 353,
    KW_ENDMODULE = 354,
    KW_ENDPRIMITIVE = 355,
    KW_ENDSPECIFY = 356,
    KW_ENDTABLE = 357,
    KW_ENDTASK = 358,
    KW_EVENT = 359,
    KW_FOR = 360,
    KW_FORCE = 361,
    KW_FOREVER = 362,
    KW_FORK = 363,
    KW_FUNCTION = 364,
    KW_GENERATE = 365,
    KW_GENVAR = 366,
    KW_HIGHZ0 = 367,
    KW_HIGHZ1 = 368,
    KW_IF = 369,
    KW_IFNONE = 370,
    KW_INCDIR = 371,
    KW_INCLUDE = 372,
    KW_INITIAL = 373,
    KW_INOUT = 374,
    KW_INPUT = 375,
    KW_INSTANCE = 376,
    KW_INTEGER = 377,
    KW_JOIN = 378,
    KW_LARGE = 379,
    KW_LIBLIST = 380,
    KW_LIBRARY = 381,
    KW_LOCALPARAM = 382,
    KW_MACROMODULE = 383,
    KW_MEDIUM = 384,
    KW_MODULE = 385,
    KW_NAND = 386,
    KW_NEGEDGE = 387,
    KW_NMOS = 388,
    KW_NOR = 389,
    KW_NOSHOWCANCELLED = 390,
    KW_NOT = 391,
    KW_NOTIF0 = 392,
    KW_NOTIF1 = 393,
    KW_OR = 394,
    KW_OUTPUT = 395,
    KW_PARAMETER = 396,
    KW_PATHPULSE = 397,
    KW_PMOS = 398,
    KW_POSEDGE = 399,
    KW_PRIMITIVE = 400,
    KW_PULL0 = 401,
    KW_PULL1 = 402,
    KW_PULLDOWN = 403,
    KW_PULLUP = 404,
    KW_PULSESTYLE_ONEVENT = 405,
    KW_PULSESTYLE_ONDETECT = 406,
    KW_RCMOS = 407,
    KW_REAL = 408,
    KW_REALTIME = 409,
    KW_REG = 410,
    KW_RELEASE = 411,
    KW_REPEAT = 412,
    KW_RNMOS = 413,
    KW_RPMOS = 414,
    KW_RTRAN = 415,
    KW_RTRANIF0 = 416,
    KW_RTRANIF1 = 417,
    KW_SCALARED = 418,
    KW_SHOWCANCELLED = 419,
    KW_SIGNED = 420,
    KW_SMALL = 421,
    KW_SPECIFY = 422,
    KW_SPECPARAM = 423,
    KW_STRONG0 = 424,
    KW_STRONG1 = 425,
    KW_SUPPLY0 = 426,
    KW_SUPPLY1 = 427,
    KW_TABLE = 428,
    KW_TASK = 429,
    KW_TIME = 430,
    KW_TRAN = 431,
    KW_TRANIF0 = 432,
    KW_TRANIF1 = 433,
    KW_TRI = 434,
    KW_TRI0 = 435,
    KW_TRI1 = 436,
    KW_TRIAND = 437,
    KW_TRIOR = 438,
    KW_TRIREG = 439,
    KW_UNSIGNED = 440,
    KW_USE = 441,
    KW_VECTORED = 442,
    KW_WAIT = 443,
    KW_WAND = 444,
    KW_WEAK0 = 445,
    KW_WEAK1 = 446,
    KW_WHILE = 447,
    KW_WIRE = 448,
    KW_WOR = 449,
    KW_XNOR = 450,
    KW_XOR = 451
  };
#endif
/* Tokens.  */
#define ANY 258
#define END 259
#define NEWLINE 260
#define SPACE 261
#define TAB 262
#define AT 263
#define COMMA 264
#define HASH 265
#define DOT 266
#define EQ 267
#define COLON 268
#define IDX_PRT_SEL 269
#define SEMICOLON 270
#define OPEN_BRACKET 271
#define CLOSE_BRACKET 272
#define OPEN_SQ_BRACKET 273
#define CLOSE_SQ_BRACKET 274
#define OPEN_SQ_BRACE 275
#define CLOSE_SQ_BRACE 276
#define BIN_VALUE 277
#define OCT_VALUE 278
#define HEX_VALUE 279
#define DEC_BASE 280
#define BIN_BASE 281
#define OCT_BASE 282
#define HEX_BASE 283
#define NUM_REAL 284
#define NUM_SIZE 285
#define UNSIGNED_NUMBER 286
#define SYSTEM_ID 287
#define SIMPLE_ID 288
#define ESCAPED_ID 289
#define DEFINE_ID 290
#define ATTRIBUTE_START 291
#define ATTRIBUTE_END 292
#define COMMENT_LINE 293
#define COMMENT_BLOCK 294
#define STRING 295
#define STAR 296
#define PLUS 297
#define MINUS 298
#define ASL 299
#define ASR 300
#define LSL 301
#define LSR 302
#define DIV 303
#define POW 304
#define MOD 305
#define GTE 306
#define LTE 307
#define GT 308
#define LT 309
#define L_NEG 310
#define L_AND 311
#define L_OR 312
#define C_EQ 313
#define L_EQ 314
#define C_NEQ 315
#define L_NEQ 316
#define B_NEG 317
#define B_AND 318
#define B_OR 319
#define B_XOR 320
#define B_EQU 321
#define B_NAND 322
#define B_NOR 323
#define TERNARY 324
#define UNARY_OP 325
#define MACRO_TEXT 326
#define MACRO_IDENTIFIER 327
#define KW_ALWAYS 328
#define KW_AND 329
#define KW_ASSIGN 330
#define KW_AUTOMATIC 331
#define KW_BEGIN 332
#define KW_BUF 333
#define KW_BUFIF0 334
#define KW_BUFIF1 335
#define KW_CASE 336
#define KW_CASEX 337
#define KW_CASEZ 338
#define KW_CELL 339
#define KW_CMOS 340
#define KW_CONFIG 341
#define KW_DEASSIGN 342
#define KW_DEFAULT 343
#define KW_DEFPARAM 344
#define KW_DESIGN 345
#define KW_DISABLE 346
#define KW_EDGE 347
#define KW_ELSE 348
#define KW_END 349
#define KW_ENDCASE 350
#define KW_ENDCONFIG 351
#define KW_ENDFUNCTION 352
#define KW_ENDGENERATE 353
#define KW_ENDMODULE 354
#define KW_ENDPRIMITIVE 355
#define KW_ENDSPECIFY 356
#define KW_ENDTABLE 357
#define KW_ENDTASK 358
#define KW_EVENT 359
#define KW_FOR 360
#define KW_FORCE 361
#define KW_FOREVER 362
#define KW_FORK 363
#define KW_FUNCTION 364
#define KW_GENERATE 365
#define KW_GENVAR 366
#define KW_HIGHZ0 367
#define KW_HIGHZ1 368
#define KW_IF 369
#define KW_IFNONE 370
#define KW_INCDIR 371
#define KW_INCLUDE 372
#define KW_INITIAL 373
#define KW_INOUT 374
#define KW_INPUT 375
#define KW_INSTANCE 376
#define KW_INTEGER 377
#define KW_JOIN 378
#define KW_LARGE 379
#define KW_LIBLIST 380
#define KW_LIBRARY 381
#define KW_LOCALPARAM 382
#define KW_MACROMODULE 383
#define KW_MEDIUM 384
#define KW_MODULE 385
#define KW_NAND 386
#define KW_NEGEDGE 387
#define KW_NMOS 388
#define KW_NOR 389
#define KW_NOSHOWCANCELLED 390
#define KW_NOT 391
#define KW_NOTIF0 392
#define KW_NOTIF1 393
#define KW_OR 394
#define KW_OUTPUT 395
#define KW_PARAMETER 396
#define KW_PATHPULSE 397
#define KW_PMOS 398
#define KW_POSEDGE 399
#define KW_PRIMITIVE 400
#define KW_PULL0 401
#define KW_PULL1 402
#define KW_PULLDOWN 403
#define KW_PULLUP 404
#define KW_PULSESTYLE_ONEVENT 405
#define KW_PULSESTYLE_ONDETECT 406
#define KW_RCMOS 407
#define KW_REAL 408
#define KW_REALTIME 409
#define KW_REG 410
#define KW_RELEASE 411
#define KW_REPEAT 412
#define KW_RNMOS 413
#define KW_RPMOS 414
#define KW_RTRAN 415
#define KW_RTRANIF0 416
#define KW_RTRANIF1 417
#define KW_SCALARED 418
#define KW_SHOWCANCELLED 419
#define KW_SIGNED 420
#define KW_SMALL 421
#define KW_SPECIFY 422
#define KW_SPECPARAM 423
#define KW_STRONG0 424
#define KW_STRONG1 425
#define KW_SUPPLY0 426
#define KW_SUPPLY1 427
#define KW_TABLE 428
#define KW_TASK 429
#define KW_TIME 430
#define KW_TRAN 431
#define KW_TRANIF0 432
#define KW_TRANIF1 433
#define KW_TRI 434
#define KW_TRI0 435
#define KW_TRI1 436
#define KW_TRIAND 437
#define KW_TRIOR 438
#define KW_TRIREG 439
#define KW_UNSIGNED 440
#define KW_USE 441
#define KW_VECTORED 442
#define KW_WAIT 443
#define KW_WAND 444
#define KW_WEAK0 445
#define KW_WEAK1 446
#define KW_WHILE 447
#define KW_WIRE 448
#define KW_WOR 449
#define KW_XNOR 450
#define KW_XOR 451

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{
#line 32 "verilog_parser.y" /* yacc.c:1916  */

    ast_assignment               * assignment;
    ast_block_item_declaration   * block_item_declaration;
    ast_block_reg_declaration    * block_reg_declaration;
    ast_case_item                * case_item;
    ast_case_statement           * case_statement;
    ast_charge_strength            charge_strength;
    ast_cmos_switch_instance     * cmos_switch_instance ;
    ast_concatenation            * concatenation;
    ast_config_rule_statement    * config_rule_statement;
    ast_config_declaration       * config_declaration;
    ast_library_declaration      * library_declaration;
    ast_library_descriptions     * library_descriptions;
    ast_delay2                   * delay2;
    ast_delay3                   * delay3;
    ast_delay_ctrl               * delay_control;
    ast_delay_value              * delay_value;
    ast_disable_statement        * disable_statement;
    ast_drive_strength           * drive_strength;
    ast_edge                       edge;
    ast_enable_gate_instance     * enable_gate;
    ast_enable_gate_instances    * enable_gates;
    ast_enable_gatetype            enable_gatetype;
    ast_event_control            * event_control;
    ast_event_expression         * event_expression;
    ast_expression               * expression;
    ast_function_call            * call_function;
    ast_function_declaration     * function_declaration;
    ast_function_item_declaration* function_or_task_item;
    ast_gate_instantiation       * gate_instantiation;
    ast_gatetype_n_input           n_input_gatetype;
    ast_generate_block           * generate_block;
    ast_identifier                 identifier;
    ast_if_else                  * ifelse;
    ast_level_symbol               level_symbol;
    ast_list                     * list;
    ast_loop_statement           * loop_statement;
    ast_lvalue                   * lvalue;
    ast_module_declaration       * module_declaration;
    ast_module_instance          * module_instance;
    ast_module_instantiation     * module_instantiation;
    ast_module_item              * module_item;
    ast_mos_switch_instance      * mos_switch_instance  ;
    ast_n_input_gate_instance    * n_input_gate_instance;
    ast_n_input_gate_instances   * n_input_gate_instances;
    ast_n_output_gate_instance   * n_output_gate_instance;
    ast_n_output_gate_instances  * n_output_gate_instances;
    ast_n_output_gatetype          n_output_gatetype;
    ast_net_type                   net_type;
    ast_node                     * node;
    ast_node_attributes          * node_attributes;
    ast_operator                   operator;
    ast_parameter_declarations   * parameter_declaration;
    ast_parameter_type             parameter_type;
    ast_pass_enable_switch       * pass_enable_switch   ;
    ast_pass_enable_switches     * pass_enable_switches;
    ast_pass_switch_instance     * pass_switch_instance ;
    ast_path_declaration         * path_declaration;
    ast_port_connection          * port_connection;
    ast_port_declaration         * port_declaration;
    ast_port_direction             port_direction;
    ast_primary                  * primary;
    ast_primitive_pull_strength  * primitive_pull;
    ast_primitive_strength         primitive_strength;
    ast_pull_gate_instance       * pull_gate_instance   ;
    ast_pulse_control_specparam  * pulse_control_specparam;
    ast_range                    * range;
    ast_range_or_type            * range_or_type;
    ast_single_assignment        * single_assignment;
    ast_source_item              * source_item;
    ast_statement                * generate_item;
    ast_statement                * statement;
    ast_statement_block          * statement_block;
    ast_switch_gate              * switch_gate;
    ast_task_declaration         * task_declaration;
    ast_task_enable_statement    * task_enable_statement;
    ast_task_port                * task_port;
    ast_task_port_type             task_port_type;
    ast_timing_control_statement * timing_control_statement;
    ast_type_declaration         * type_declaration;
    ast_udp_body                 * udp_body;
    ast_udp_combinatorial_entry  * udp_combinatorial_entry;
    ast_udp_declaration          * udp_declaration;
    ast_udp_initial_statement    * udp_initial;
    ast_udp_instance             * udp_instance;
    ast_udp_instantiation        * udp_instantiation;
    ast_udp_next_state             udp_next_state;
    ast_udp_port                 * udp_port;
    ast_udp_sequential_entry     * udp_seqential_entry;
    ast_wait_statement           * wait_statement;

    char                   boolean;
    char                 * string;
    ast_number           * number;
    char                 * term;
    char                 * keyword;

#line 550 "verilog_parser.h" /* yacc.c:1916  */
};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE open_veriloglval;

int open_verilogparse (void);

#endif /* !YY_OPEN_VERILOG_VERILOG_PARSER_H_INCLUDED  */
