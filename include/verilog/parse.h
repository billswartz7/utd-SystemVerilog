/*!
@file parse.h
@brief Contains all the functions that users need to use the Verilog parser
*/

#ifndef VERILOG_PARSE_H
#define VERILOG_PARSE_H


#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

typedef struct sverilog_preprocessor_context_rec *SVERILOG_PARSEPTR ;

//! Parser initialize code, returns a parsing object.
extern SVERILOG_PARSEPTR sverilog_parser_init(void) ;

//! Parser adds to the directory search paths
extern void sverilog_parser_add_search_path( SVERILOG_PARSEPTR parse_p,
                                             const char *path ) ;

//! Add the default callbacks.
extern void sverilog_parser_add_default_callbacks( SVERILOG_PARSEPTR parse_p ) ;

// The top level parsing interface
extern int sverilog_parse_file( SVERILOG_PARSEPTR parse_p, char *filename ) ;

//! Ask for the output of the preprocessor.  Output is sent to the specified
// open file descriptor.
extern void sverilog_parser_set_preprocess_output( SVERILOG_PARSEPTR parse_p,
                                                   FILE *pre_output_p ) ;

//! Get the number of errors found.
extern int sverilog_parser_get_errors( SVERILOG_PARSEPTR parse_p ) ;

#ifdef LATER

extern verilog_source_tree *verilog_parser_get_source_tree(void) ;

/*!
@brief Perform a parsing operation on the currently selected buffer.
*/
extern int verilog_parse_file(FILE * to_parse) ;
#endif /* LATER */

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif

