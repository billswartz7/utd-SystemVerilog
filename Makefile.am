SUBDIRS=src
ACLOCAL_AMFLAGS=-I m4

clean-local:
	        -rm -rf *~ autom4* *.dSYM modules/build lib src/.deps

standalone:
	(test -d $(abs_top_srcdir)/modules/build || mkdir -p $(abs_top_srcdir)/modules/build)
	(cd $(abs_top_srcdir)/modules/utd-lib; source ./setenv.sh; \
	 cd ../build ; ../utd-lib/configure \
	 --prefix=$(abs_top_srcdir)/modules/build --libdir=$(abs_top_srcdir)/lib \
	 --bindir=$(abs_top_srcdir)/bin --includedir=$(abs_top_srcdir)/include \
	 --disable-shared --disable-autotools ; \
	 make config; make; make install ) ;
	(cd $(abs_top_srcdir)/modules/build/include ; \
	 tar cvf - utd | (cd $(abs_top_srcdir)/include; tar xvf - ) ) ; 

test:	
	TEST_FILES=`find . -name *.v | sort`;\
	passed=0 ; \
	failed=0 ; \
	cat /dev/null > test.failed ; \
	cat /dev/null > test.passed ; \
	for file in $$TEST_FILES; do \
	   echo "testing $$file..."; \
	   $(abs_top_builddir)/src/testparser $$file 2>> build/tests.log 1>> build/tests.log ; \
	   RESULT=$$? ;\
	   if [ "0" -eq "$$RESULT" ]; then \
	      echo "  parsed successfully: $$file" ; \
	      echo "  $$file" >> test.passed ; \
	      passed=$$((passed+1)) ; \
	   else \
	      echo "  parsing failed: $$file" ; \
	      echo "  $$file" >> test.failed ; \
	      failed=$$((failed+1)) ; \
	   fi ; \
	done ; \
	echo "$$passed files passed.  $$failed files failed."

testclean:	
	find . -name "*.preproc" -exec \rm -f {} \; -print
