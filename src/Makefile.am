## Process this file with automake to produce Makefile.in

lib_LTLIBRARIES = libopen_sverilog.la 
libopen_sverilog_la_SOURCES = \
	expr.c \
	preprocessor.c \
	sverilog_parser.c \
	sverilog_scanner.c

PRIVATE_HDRS = \
	preprocessor.h

PUBLIC_HDRS = \
	callbacks.h \
	expr.h \
	parse.h \
	sverilog.h

libopen_sverilog_la_LDFLAGS = -version-info 1:0:0

EXTRA_PROGRAMS = testparser

testparser_SOURCES = main.c

testparser_LDADD = \
		libopen_sverilog.la \
		$(abs_top_srcdir)/lib/libutd.la \
		-lm


ACLOCAL_AMFLAGS=-I m4

AM_CPPFLAGS =\
	-I.\
	-I${srcdir}/../include

# Need to store off config data for other programs
# Now done in top level configure.

AM_CFLAGS = -g $(X_CFLAGS) -DDEBUG -I$(srcdir)/include @OPENROAD_INCLUDE@

AM_CXXFLAGS = -g $(X_CFLAGS)

CC=@MCC@

clean-local:
	-rm -rf *~ autom4* *.dSYM

install-data-hook:
	  mkdir -p ${prefix}/include/verilog ; \
	  cd $(srcdir)/../include/verilog; tar cvf - $(PUBLIC_HDRS) | (cd ${prefix}/include/verilog; tar xvf - ) ;

testpgms: $(EXTRA_PROGRAMS)
