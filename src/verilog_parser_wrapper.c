
/*!
@file verilog_parser_wrapper.c
@brief Contains implementations of functions declared in verilog_parser.h
*/

#include <verilog/ast.h>
#include "verilog_scanner.h"
#include "verilog_parser.h"
#include <verilog/parse.h>

//! This is defined in the generated bison parser code.

verilog_preprocessor_context *verilog_parser_init(void)
{
    if(yy_preproc == NULL) 
    {
        //printf("Added new preprocessor context\n");
        yy_preproc = verilog_new_preprocessor_context();
    }
    if(yy_verilog_source_tree == NULL)
    {
        //printf("Added new source tree\n");
        yy_verilog_source_tree = verilog_new_source_tree();
    }
    return( yy_preproc ) ;
}

verilog_source_tree *verilog_parser_get_source_tree(void)
{
    return( yy_verilog_source_tree ) ;
} 

/*!
@brief Perform a parsing operation on the currently selected buffer.
*/
int verilog_parse_file(FILE * to_parse)
{
    YY_BUFFER_STATE new_buffer = open_verilog_create_buffer(to_parse, YY_BUF_SIZE);
    open_verilog_switch_to_buffer(new_buffer);
    open_veriloglineno = 0; // Reset the global line counter, we are in a new file!
    
    int result = open_verilogparse();
    return result;
}

/*!
@brief Perform a parsing operation on the supplied in-memory string.
*/
int     verilog_parse_string(char * to_parse, int length)
{
    YY_BUFFER_STATE new_buffer = open_verilog_scan_bytes(to_parse, length);
    open_verilog_switch_to_buffer(new_buffer);
    
    int result = open_verilogparse();
    return result;
}


/*!
@brief Perform a parsing operation on the supplied in-memory string.
*/
int     verilog_parse_buffer(char * to_parse, int length)
{
    YY_BUFFER_STATE new_buffer = open_verilog_scan_buffer(to_parse, length);
    open_verilog_switch_to_buffer(new_buffer);
    
    int result = open_verilogparse();
    return result;
}
