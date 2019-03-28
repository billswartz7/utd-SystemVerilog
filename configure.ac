AC_PREREQ([2.69])
AC_INIT([verilog], [1.0])
AC_CONFIG_HEADERS([src/config.h])
AM_INIT_AUTOMAKE([foreign])
AC_PREFIX_DEFAULT($OPENROAD)

# Checks for programs.
AC_PROG_CC
AC_PROG_CXX
AC_PROG_LIBTOOL

# See if threads are enabled
OR_ENABLE_THREADS
OR_ENABLE_SHARED

# See if we have defined the UTD path
UTD_PATH_CONFIG

# Checks for header files.
AC_FUNC_MALLOC
AC_FUNC_REALLOC
AC_TYPE_SIGNAL
AC_HEADER_STDC

# Checks for typedefs, structures, and compiler characteristics.
AC_CHECK_HEADERS(stdarg.h)

# Checks for library functions.
AC_CHECK_FUNCS([memset])

UTD_ENABLE_AUTOTOOLS

AC_CHECK_PROG(MCC,imcc,imcc,"$CC")

AC_SUBST(CC)
AC_CONFIG_FILES([
 	Makefile
	src/Makefile
])
AC_OUTPUT
