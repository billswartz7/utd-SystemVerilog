## Process this file with automake to produce Makefile.in

lib_LTLIBRARIES = libopen_sverilog.la 
libopen_sverilog_la_SOURCES = \
	preprocessor.c \
	sverilog_parser.c \
	sverilog_scanner.c

PUBLIC_HDRS = \
	preprocessor.h

libopen_sverilog_la_LDFLAGS = -version-info 1:0:0

bin_PROGRAMS = testparser

testparser_SOURCES = main.c

testparser_LDADD = \
		../lib/libutd.la \
		libopen_sverilog.la

ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I.\
	-I${srcdir}/../include

# Need to store off config data for other programs
# Now done in top level configure.

AM_CFLAGS = -g $(X_CFLAGS) -DDEBUG

AM_CXXFLAGS = -g $(X_CFLAGS)

CC=@MCC@

clean-local:
	-rm -rf *~ autom4* *.dSYM

install-data-hook:
	  mkdir -p ${prefix}/include/verilog ; \
	  cd $(srcdir)/../include/verilog; tar cvf - $(PUBLIC_HDRS) | (cd ${prefix}/include/verilog; tar xvf - ) ;

