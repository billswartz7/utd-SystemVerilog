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

#ifndef YY_SVERILOG_SVERILOG_TAB_H_INCLUDED
# define YY_SVERILOG_SVERILOG_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int sverilog_debug;
#endif

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

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED

union YYSTYPE
{

    char        		boolean ;
    char        		*string ;
    char        		*term ;
    char        		*keyword ;
    char        		*identifier ;
    SVERILOG_OPERATOR_T 	operator ;

};

typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE sverilog_lval;

int sverilog_parse (SVERILOG_PARSEPTR parse_p);

#endif /* !YY_SVERILOG_SVERILOG_TAB_H_INCLUDED  */
