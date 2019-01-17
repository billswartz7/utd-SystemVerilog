YACC=byacc -b sverilog
YACC=bison -p sverilog_
LEX=flex -P sverilog_ -o lex.yy.c
RM=rm -f
MV=mv
GREP=grep

all: ../sverilog_parser.c ../sverilog_scanner.c

../sverilog_parser.c : sverilog.y
	$(YACC) -v -d sverilog.y
	$(MV) sverilog.tab.c tmp
	$(GREP) -v "# line" tmp | $(GREP) -v "#line" > sverilog.tab.c
	$(MV) sverilog.tab.c ../sverilog_parser.c
	$(MV) sverilog.tab.h tmp
	$(GREP) -v "# line" tmp | $(GREP) -v "#line" > sverilog.tab.h
	$(MV) sverilog.tab.h ../sverilog_tab.h

../sverilog_scanner.c : sverilog.l
	$(LEX) -l sverilog.l
	$(MV) lex.yy.c tmp
	$(GREP) -v "# line" tmp | $(GREP) -v "#line" > lex.yy.c
	$(MV) lex.yy.c ../sverilog_scanner.c

clean:	
	$(RM) *.tab.c *~ *.output tmp


distclean : clean	
	$(RM) ../sverilog_parser.c ../sverilog_tab.h ../sverilog_scanner.c

:

