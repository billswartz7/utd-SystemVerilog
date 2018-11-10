## Process this file with automake to produce Makefile.in

lib_LTLIBRARIES = libopen_verilog.la 
libopen_verilog_la_SOURCES = \
	verilog_scanner.c \
	verilog_parser.c \
	verilog_ast.c \
	verilog_ast_common.c \
	verilog_ast_mem.c \
	verilog_preprocessor.c \
	verilog_ast_util.c \
	verilog_parser_wrapper.c

PUBLIC_HDRS = \
	ast.h \
	ast_common.h \
	ast_mem.h \
	ast_util.h \
	parse.h \
	preprocessor.h

libopen_verilog_la_LDFLAGS = -version-info 1:0:0

bin_PROGRAMS = testparser

testparser_SOURCES = main.c

testparser_LDADD = \
		libopen_verilog.la

ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I.\
	-I${srcdir}/../include

# Need to store off config data for other programs
# Now done in top level configure.

AM_CFLAGS = -g $(X_CFLAGS) -DDEBUG

AM_CXXFLAGS = -g $(X_CFLAGS)

CC=@MCC@

# There is no reason to force user to user Bison and Flex when not in development mode.
#
develop : verilog_scanner.c verilog_parser.c 

verilog_scanner.c : verilog_scanner.l
	flex -o verilog_scanner.c -P open_verilog verilog_scanner.l

verilog_parser.c : verilog_parser.y
	bison -y verilog_parser.y -p open_verilog -o verilog_parser.c

clean_develop:
	-rm -f verilog_scanner.c verilog_parser.output verilog_parser.c verilog_parser.h

clean-local:
	-rm -rf *~ autom4* *.dSYM

install-data-hook:
	  mkdir -p ${prefix}/include/verilog ; \
	  cd $(srcdir)/../include/verilog; tar cvf - $(PUBLIC_HDRS) | (cd ${prefix}/include/verilog; tar xvf - ) ;


