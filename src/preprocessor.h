/*!
@file preprocessor.h
@brief Contains function and data structures to support source code
       preprocessing.
*/

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#ifndef VERILOG_PREPROCESSOR_H
#define VERILOG_PREPROCESSOR_H

#include <utd/config.h>
#include <utd/base.h>
#include <utd/deck.h>
#include <utd/hash.h>

// ----------------------- Timescale Directives -------------------------

//! Describes a simulation timescale directive.
typedef struct verilog_timescale_directive_t {
    char * scale ;       //!< The timescale to simulate on.
    char * precision ;   //!< Precision of each timestep.
} VERILOG_TIMESCALE_DIRECTIVE ;


/*!
@brief Stores information regarding a particular level of conditional
compilation.
@brief A stack of these is maintained, each one relating to a different
level of nested `ifdef or `ifndef statements.
*/
typedef struct verilog_preprocessor_conditional_context_t {
    char * condition;          //!< The definition to check for.
    int  line_number;         //!< Where the `ifdef came from.
    BOOL condition_passed;    //!< Did the condition pass?
    BOOL is_ndef ;            //!< True if directive was `ifndef
    BOOL wait_for_endif ;     //!< Emit nothing more until `endif
} VERILOG_PREPROC_COND_CONTEXT, *VERILOG_PREPROC_COND_CONTEXTPTR ;

//! Creates and returns a new conditional context.
extern VERILOG_PREPROC_COND_CONTEXTPTR
    verilog_preprocessor_new_conditional_context(
    char * condition,         //!< The definition to check for.
    int  line_number          //!< Where the `ifdef came from.
) ;

// ----------------------- Preprocessor Context -------------------------

/*
@brief Stores all of the contextual information used by the pre-processor.
@details Stores things like:
- Macro names and evaluations.
- Default net types.
- In Cell Defines.
- IF/ELSE pre-processor directives.
- Timescale directives
*/
typedef struct sverilog_parse_context_rec {
    BOOL emit ;           		//!< Only emit tokens iff true.
    FILE *preproc_out ;			//!< Preprocessor output file
    UNSIGNED_INT token_count ;    	//!< Keeps count of tokens processed.
    BOOL in_cell_define ; 		//!< TRUE iff we are in a cell define.
    UTDDECKPTR file_stack ;		//!< Stack of files to process. 
    UTDDECKPTR net_types ;      	//!< Storage for default nettype directives
    UTDHASHPTR search_dirs ;    	//!< Where to look for include files.
    UTDHASHPTR macrodefines ;   	//!< `define kvp matching.
    UTDHASHPTR includes ;		//!< Include directives.
    VERILOG_TIMESCALE_DIRECTIVE timescale ; //!< Timescale information
    SVERILOG_PRIMITIVE_STRENGTH_T unconnected_drive_pull; //!< nounconnectedrive
    char *scratch ;			//!< used internally
    UTDDECKPTR ifdefs ;         	//!< Storage for conditional compile stack.
    int errors ;			//!< Errors encountered.
    int *line_num ;			//!< low level line number variable 
    char **scanner_text ;		//!< low level scanner text
} SVERILOG_PARSE, *SVERILOG_PARSEPTR ;


#define YY_DECL int sverilog_lex ( SVERILOG_PARSEPTR parse_p )
extern int sverilog_lex ( SVERILOG_PARSEPTR parse_p ) ;
extern void sverilog_error(SVERILOG_PARSEPTR parse_p,const char *msg) ;
extern void verilog_preproc( SVERILOG_PARSEPTR parse_p, INT token, char *value ) ;
extern void sverilog_lowlevel_init(SVERILOG_PARSEPTR parse_p) ;
extern void verilog_flex_set_info( SVERILOG_PARSEPTR parse_p ) ;

#define EMIT_TOKEN(parse_xz,xz_z,val_xz)   verilog_preproc(parse_xz,xz_z,val_xz);\
					   if( parse_xz->emit ) {     \
					     return( xz_z ) ;         \
					   }

// ----------------------- Include/File Directives ----------------------

//! Stores information on an include or top level file info
typedef struct verilog_file_rec {
    char         *filename ;     //!< The file to include.
    FILE	 *fp ;		 //! <The file pointer if opened
    unsigned int lineNumber ;    //!< The line number of the directive.
    BOOL 	 file_exists ;   //!< Can we find the file?
} VERILOG_FILE, *VERILOG_FILEPTR ;

/*! 
@brief Handles the encounter of an include directive.
@returns A pointer to the newly created directive reference.
*/
extern VERILOG_FILEPTR verilog_preprocessor_include(
    SVERILOG_PARSEPTR parse_p,	//!< The parsing object
    char * filename,        //<! The file to include.
    unsigned int lineNumber //!< The line number of the directive.
) ;

// ----------------------- resetall directives --------------------------

/*!
@brief Handles the encounter of a `resetall directive as described in annex
19.6 of the spec.
*/
extern void verilog_preprocessor_resetall( SVERILOG_PARSEPTR parse_p ) ;

/*!
@brief Tells the preprocessor we are now defining PLI modules and to tag
       them as such.
*/
extern void verilog_preproc_enter_cell_define( SVERILOG_PARSEPTR parse_p ) ;


/*!
@brief Tells the preprocessor we are no longer defining PLI modules.
*/
extern void verilog_preproc_exit_cell_define( SVERILOG_PARSEPTR parse_p ) ;

// ----------------------- Connected Drive Directives -------------------

/*!
@brief Handles the entering of a no-unconnected drive directive.
@param [in] direction -  Where should an unconnected line be pulled?
*/
extern void verilog_preprocessor_nounconnected_drive(
    SVERILOG_PARSEPTR parse_p,
    SVERILOG_PRIMITIVE_STRENGTH_T direction
);


// ----------------------- `define Directives ---------------------------

/*!
@brief A simple container for macro directives
*/
typedef struct verilog_macro_directive_t {
    unsigned int line;      //!< Line number of the directive.
    char * macro_id;        //!< The name of the macro.
    char * macro_value;     //!< The value it expands to.
} VERILOG_MACRO_DIRECTIVE, *VERILOG_MACRO_DIRECTIVEPTR ;

/*!
@brief Instructs the preprocessor to register a new macro definition.
*/
extern void verilog_preprocessor_macro_define(
    SVERILOG_PARSEPTR parse_p,	//!< The parsing object
    unsigned int line,  	//!< The line the defininition comes from.
    char * macro_name,  	//!< The macro identifier.
    char * macro_text,  	//!< The value the macro expands to.
    size_t text_len     	//!< Length in bytes of macro_text.
) ;
    
/*!
@brief Removes a macro definition from the preprocessors lookup table.
*/
extern void verilog_preprocessor_macro_undefine(
    SVERILOG_PARSEPTR parse_p,	//!< The parsing object
    char * macro_name 		//!< The name of the macro to remove.
);

// ----------------------- Conditional Compilation Directives -----------


/*!
@brief Handles an ifdef statement being encountered.
@param [in] macro_name - The macro to test if defined or not.
@param [in] lineno - The line the directive occurs on.
@param [in] is_ndef - TRUE IFF the directive is `ifndef. Else the directive
is `ifdef and this should be FALSE.
*/
extern void verilog_preprocessor_ifdef (
    SVERILOG_PARSEPTR parse_p,	//!< The parsing object
    char * macro_name,		//!< Name of the macro to test
    unsigned int lineno,    	//!< line number of the directive.
    BOOL is_ndef     		//!< Is this an ifndef or ifdef directive.
);

/*!
@brief Handles an elseif statement being encountered.
@param [in] macro_name - The macro to test if defined or not.
@param [in] lineno - The line the directive occurs on.
*/
extern void verilog_preprocessor_elseif(
    SVERILOG_PARSEPTR parse_p,
    char * macro_name, unsigned int lineno) ;

/*!
@brief Handles an else statement being encountered.
@param [in] lineno - The line the directive occurs on.
*/
extern void verilog_preprocessor_else  (
    SVERILOG_PARSEPTR parse_p,
    unsigned int lineno);

/*!
@brief Handles an else statement being encountered.
@param [in] lineno - The line the directive occurs on.
*/
extern void verilog_preprocessor_endif (SVERILOG_PARSEPTR parse_p,
                                        unsigned int lineno ) ;

// ----------------------- Default Net Type Directives ------------------

/*!
@brief Keeps track of the points at which default net type directives are
encountered.
*/
typedef struct verilog_default_net_type_t {
    unsigned int token_number ;  //!< Token number of the directive.
    unsigned int line_number ;   //!< Line number of the directive.
    SVERILOG_NET_TYPE_T type ;   //!< The net type.
} VERILOG_DEFAULT_NET_TYPE, *VERILOG_DEFAULT_NET_TYPEPTR ;

//! Creates and returns a new default net type directive.
extern VERILOG_DEFAULT_NET_TYPEPTR verilog_new_default_net_type(
    SVERILOG_PARSEPTR parse_p,	//!< Top level parsing object
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    SVERILOG_NET_TYPE_T type    //!< The net type.
);

/*!
@brief Registers a new default net type directive.
*/
extern void verilog_preproc_default_net (
    SVERILOG_PARSEPTR parse_p,	//!< Top level parsing object
    unsigned int token_number,  //!< Token number of the directive.
    unsigned int line_number,   //!< Line number of the directive.
    SVERILOG_NET_TYPE_T type    //!< The net type.
);


extern char *sverilog_new_identifier( SVERILOG_PARSEPTR parse_p,
                                      char *string, unsigned int line_no) ; 

/*!
@brief Cleanup file stack as we are done with the current file.
*/
extern void verilog_pop_file_stack( SVERILOG_PARSEPTR parse_p ) ;


/*!
@brief The call to the yacc parser
*/
extern int sverilog_parse( SVERILOG_PARSEPTR parse_p ) ;

extern int sverilog_lineno ;


#ifdef LATER
/*!
@defgroup verilog-preprocessor Preprocessor
@{
@brief This module contains all code and information on the preprocessor and
how it works / is implemented.

@details

The preprocessor is implemented mostly as part of the lexer, with the
various compiler directives handled within the verilog_preprocessor_context
structure and it's associated functions.

*/


// ----------------------- Line Directives ------------------------------

//! Describes a line directive.
typedef struct verilog_line_directive_t{
    unsigned int  line;  //!< The line to set the current counter to.
    char *        file;  //!< The file we should pretend stuff comes from.
    unsigned char level; //!< Level of include depth.
} verilog_line_directive;





/*! 
@brief Stores all information needed for the preprocessor.
@details This does not usually need to be accessed by the programmer, and
certainly should never be written to unless you are defining your own
default directives. For example, if I was writing my own simulated and
wanted to add my own "__IS_MY_SIMULATOR__" pre-defined macro, it can be
done by accessing this variable, and using the 
verilog_preprocessor_macro_define function.
@note This is a global variable. Treat it with care!
*/
extern verilog_preprocessor_context * yy_preproc;


/*!
@brief Creates a new pre-processor context.
@details This is called *once* at the beginning of a parse call.
*/
extern verilog_preprocessor_context * verilog_new_preprocessor_context();

/*!
@brief Clears the stack of files being parsed, and sets the current file to
the supplied string.
@param [inout] preproc - The context who's file name is being set.
@param [in] file - The file path to put as the current file.
*/
extern void verilog_preprocessor_set_file(
    verilog_preprocessor_context * preproc,
    char * file
);

/*!
@brief Returns the file currently being parsed by the context, or NULL 
@param [in] preproc - The context to get the current file for.
*/
extern char * verilog_preprocessor_current_file(
    verilog_preprocessor_context * preproc
);

/*!
@brief Frees a preprocessor context and all child constructs.
*/
extern void verilog_free_preprocessor_context(
    verilog_preprocessor_context * tofree
);




#endif /* LATER */

/*! @} */

#endif

