#ifndef VERILOG_SVERILOG_H
#define VERILOG_SVERILOG_H

#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef enum  sverilog_boolean_e {
    SVERILOG_TRUE = 1,
    SVERILOG_FALSE = 0
} SVERILOG_BOOLEAN_T ;

//! Stores different Operators.
typedef enum sverilog_operator_e {
    OPERATOR_STAR    , //!<
    OPERATOR_PLUS    , //!<
    OPERATOR_MINUS   , //!<
    OPERATOR_ASL     , //!< Arithmetic shift left
    OPERATOR_ASR     , //!< Arithmetic shift right
    OPERATOR_LSL     , //!< logical shift left
    OPERATOR_LSR     , //!< logical shift right
    OPERATOR_DIV     , //!< divide
    OPERATOR_POW     , //!< pow
    OPERATOR_MOD     , //!< mod
    OPERATOR_GTE     , //!< greater than or equal to
    OPERATOR_LTE     , //!<
    OPERATOR_GT      , //!<
    OPERATOR_LT      , //!<
    OPERATOR_L_NEG   , //!<
    OPERATOR_L_AND   , //!<
    OPERATOR_L_OR    , //!<
    OPERATOR_C_EQ    , //!<
    OPERATOR_L_EQ    , //!<
    OPERATOR_C_NEQ   , //!<
    OPERATOR_L_NEQ   , //!<
    OPERATOR_B_NEG   , //!<
    OPERATOR_B_AND   , //!<
    OPERATOR_B_OR    , //!<
    OPERATOR_B_XOR   , //!<
    OPERATOR_B_EQU   , //!<
    OPERATOR_B_NAND  , //!<
    OPERATOR_B_NOR   , //!<
    OPERATOR_TERNARY , //!<
    OPERATOR_DOT     , //!< Add hierarchy
    OPERATOR_INDEX   , //!< Build a vector index
    OPERATOR_RANGE   , //!< Create lo,hi range constraint
    OPERATOR_INDEXED_PLUS_RANGE   , //!< Create incremented range constraint
    OPERATOR_INDEXED_MINUS_RANGE  , //!< Create decremented range constraint
    OPERATOR_CONCAT  , //!< Create a concatenated expression
    OPERATOR_ASSIGN  , //!< Create an assignment
    OPERATOR_NONE = 0
} SVERILOG_OPERATOR_T ;

//! Describes the type of a net in Verilog.
typedef enum sverilog_net_type_e {
    NET_TYPE_SUPPLY0,   //!< Logic 0 supply rail
    NET_TYPE_SUPPLY1,   //!< Logic 1 supply rail.
    NET_TYPE_TRI,       //!< Tri-state
    NET_TYPE_TRIAND,    //!< Tri-state AND
    NET_TYPE_TRIOR,     //!< Tri-state OR
    NET_TYPE_TRI0,      //!< Tri-state no driver pulled to 0
    NET_TYPE_TRI1,      //!< Tri-state no driver pulled to 1
    NET_TYPE_TRIREG,    //!< Tri-state reg wire
    NET_TYPE_WIRE,      //!< Wire
    NET_TYPE_UWIRE,     //!< Unresolved wire - only one driver allowed!
    NET_TYPE_WAND,      //!< ?
    NET_TYPE_WOR,       //!< ?
    NET_TYPE_NONE       //!< Use only when not specified!
} SVERILOG_NET_TYPE_T ;

//! Describes the direction of a port in Verilog.
typedef enum sverilog_port_dir_e {
    PORT_DIR_INPUT_T,    //!< input
    PORT_DIR_OUTPUT_T,   //!< output
    PORT_DIR_INOUT_T,    //!< bidirectional
    PORT_DIR_REF_T	 //!< System Verilog reference
} SVERILOG_PORT_DIR_T ;

//! Describes the drive strength of a single primitive.
typedef enum sverilog_primitive_strength_e {
    STRENGTH_HIGHZ0,
    STRENGTH_HIGHZ1,
    STRENGTH_SUPPLY0,
    STRENGTH_STRONG0,
    STRENGTH_PULL0,
    STRENGTH_WEAK0,
    STRENGTH_SUPPLY1,
    STRENGTH_STRONG1,
    STRENGTH_PULL1,
    STRENGTH_WEAK1,
    STRENGTH_NONE
} SVERILOG_PRIMITIVE_STRENGTH_T ;

typedef struct sverilog_expr_type_rec {
  union {
    char *string ;
    int int_value ;
    int start_index ;
    double double_value ;
  } data ;
  int end_index ;
  int token_type ;
} SVER_EXPR_TYPE, *SVER_EXPR_TYPEPTR ;

typedef struct sverilog_expr_rec {
  int num_vals ;
  char *string_equiv ;
  SVER_EXPR_TYPEPTR *tokens ;
} SVER_EXPR, *SVER_EXPRPTR ;

typedef int SVER_CALLBACK_arg0( void *ud ) ;
typedef int SVER_CALLBACK_arg1s( void *ud, char *string1 ) ;
typedef int SVER_CALLBACK_arg2s( void *ud, char *string1, char *string2 ) ;
typedef int SVER_CALLBACK_net_type( void *ud, SVERILOG_NET_TYPE_T type ) ;
typedef int SVER_CALLBACK_port_dir( void *ud, SVERILOG_PORT_DIR_T direction ) ;
typedef SVER_EXPRPTR SVER_CALLBACK_expr( void *ud, SVER_EXPRPTR expr_p ) ;
typedef SVER_EXPRPTR SVER_CALLBACK_str1_expr( void *ud, char *string,SVER_EXPRPTR expr_p ) ;
typedef SVER_EXPRPTR SVER_CALLBACK_expr_op( void *ud, SVER_EXPRPTR expr1_p, SVER_EXPRPTR expr2_p, 
                                            SVERILOG_OPERATOR_T op) ;

/* -----------------------------------------------------------------
 * Define the callback functions.
----------------------------------------------------------------- */
typedef struct sverilog_callback_rec {
  union {
    SVER_CALLBACK_arg0 		*void_func ;
    SVER_CALLBACK_arg1s		*str1_func ;
    SVER_CALLBACK_arg2s		*str2_func ;
    SVER_CALLBACK_expr		*expr_func ;
    SVER_CALLBACK_expr_op	*expr_op_func ;
    SVER_CALLBACK_str1_expr	*str1_expr_func ;
    SVER_CALLBACK_net_type	*net_type_func ;
    SVER_CALLBACK_port_dir	*port_dir_func ;
  } f ;
} SVER_CALLBACK, *SVER_CALLBACKPTR ;


/* -----------------------------------------------------------------
 * Define the types of functions.
----------------------------------------------------------------- */
typedef enum {
  SVERCB_EXPR_F = 			0,	/* type SVER_CALLBACK_expr_op */
  SVERCB_EXPR_OP_F = 			1,	/* type SVER_CALLBACK_expr_op */
  SVERCB_EXPR_ADD_CONCAT_F =		2,	/* type SVER_CALLBACK_expr_op */
  SVERCB_MODULE_NAME_F = 		3,	/* type SVER_CALLBACK_arg1s */
  SVERCB_MODULE_IOPORT_F = 		4,	/* type SVER_CALLBACK_arg1s */
  SVERCB_PORT_CONCAT_START_F = 		5,	/* type SVER_CALLBACK_void */
  SVERCB_PORT_CONCAT_END_F = 		6,	/* type SVER_CALLBACK_void */
  SVERCB_PORT_RANGE_F = 		7,	/* type SVER_CALLBACK_expr */
  SVERCB_PORT_DIR_F = 			8,	/* type SVER_CALLBACK_port_dir */
  SVERCB_ANSI_PORT_DIR_F = 		9,	/* type SVER_CALLBACK_port_dir */
  SVERCB_MODNETS_END_F =		10,	/* type SVER_CALLBACK_void */
  SVERCB_MODINST_MODNAME_F =		11,	/* type SVER_CALLBACK_arg1s */
  SVERCB_MODINST_INSTNAME_F =		12,	/* type SVER_CALLBACK_arg1s */
  SVERCB_MODINST_MNET_F =		13,	/* type SVER_CALLBACK_expr */
  SVERCB_MODINST_MNET_BIND_F =		14,	/* type SVER_CALLBACK_str1_expr */
  SVERCB_MODINST_END_CONNECTS_F =	15,	/* type SVER_CALLBACK_arg1s */
  SVERCB_NET_TYPE_F = 			16,	/* type SVER_CALLBACK_net_type */
  SVERCB_NET_ASSIGN_F = 		17,	/* type SVER_CALLBACK_expr_op */
  SVERCB_MODULE_END_F = 		18,	/* type SVER_CALLBACK_arg1s */
} SVER_CALLBACK_T ;

#define SVER_CALLBACK_LAST_FUNC	     	18
#define SVER_CALLBACK_NUM_FUNCS	       (SVER_CALLBACK_LAST_FUNC+1)


#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif /* VERILOG_SVERILOG_H */
