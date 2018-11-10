/*!
@file parse.h
@brief Contains all the functions that users need to use the Verilog parser
*/

#ifndef VERILOG_PARSE_H
#define VERILOG_PARSE_H


#ifdef __cplusplus
extern "C" {
#endif /* __cplusplus */

#include <verilog/preprocessor.h>
#include <verilog/ast_util.h>


//! This is defined in the generated bison parser code.
extern verilog_preprocessor_context *verilog_parser_init(void) ;

extern verilog_source_tree *verilog_parser_get_source_tree(void) ;

/*!
@brief Perform a parsing operation on the currently selected buffer.
*/
extern int verilog_parse_file(FILE * to_parse) ;

#ifdef __cplusplus
} ;
#endif /* __cplusplus */

#endif

