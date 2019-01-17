/*!
@file main.c
@brief A simple test program for the C library code.
*/

#include "stdio.h"

#include <verilog/parse.h>
#include <verilog/parse.h>

int main(int argc, char ** argv)
{
    if(argc < 2) {
        printf("ERROR. Please supply at least one file path argument.\n");
        return 1;
    } else {

      // Initialise the parser.
      SVERILOG_PARSEPTR parse_p = sverilog_parser_init() ;

      // Setup the order to search for Verilog include files
      sverilog_parser_add_search_path( parse_p, "./tests/" ) ;
      sverilog_parser_add_search_path( parse_p, "../tests/" ) ;
      sverilog_parser_add_search_path( parse_p, "./" ) ;

      sverilog_parser_add_default_callbacks( parse_p ) ;

      // Install your personalized callbacks here.
      //

      for( int fcount = 1 ; fcount < argc; fcount++ ) {
	char *filename = argv[fcount] ;
	printf("%s ", filename ) ;
	fflush(stdout) ;

	// Parse the file and store the result.
	int result = sverilog_parse_file( parse_p, filename ) ;

	if ( result == 0 ) {
	  printf(" - Parse successful\n");
	} else {
	  printf(" - Parse failed\n");
        }
      }
    }
    return (0) ;
}
