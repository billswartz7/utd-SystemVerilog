SUBDIRS=src
ACLOCAL_AMFLAGS=-I m4

clean-local:
	        -rm -rf *~ autom4* *.dSYM modules/build

standalone:
	(test -d $(abs_top_srcdir)/modules/build || mkdir -p $(abs_top_srcdir)/modules/build)
	(cd $(abs_top_srcdir)/modules/utd-lib; source ./setenv.sh; \
	 cd ../build ; ../utd-lib/configure \
	 --prefix=$(abs_top_srcdir)/modules/build --libdir=$(abs_top_srcdir)/lib \
	 --includedir=$(abs_top_srcdir)/include --disable-shared; \
	 make config; make; make install ) ;
	(cd $(abs_top_srcdir)/modules/build/include ; \
	 tar cvf - utd | (cd $(abs_top_srcdir)/include; tar xvf - ) ) ; 
