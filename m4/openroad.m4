#------------------------------------------------------------------------
# OR_ENABLE_THREADS --
#
#	Allows the building of threaded libraries
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-threads=yes|no
#
#	Sets the following vars:
#		OPENROAD_THREAD_BUILD	Value of 1 or 0
#------------------------------------------------------------------------

AC_DEFUN([OR_ENABLE_THREADS], [
    AC_MSG_CHECKING([whether to build libraries with thread support])
    AC_ARG_ENABLE(threads,
	AC_HELP_STRING([--enable-threads],
	    [build libraries with threads (default: off)]),
	[openroad_ok=$enableval], [openroad_ok=no])

    if test "${enable_threads+set}" = set; then
	enableval="$enable_threads"
	openroad_ok=$enableval
    else
	openroad_ok=no
    fi

    if test "$openroad_ok" = "yes" ; then
	AC_MSG_RESULT([threads enabled])
	OPENROAD_THREAD_BUILD="--enable-threads"
    else
	AC_MSG_RESULT([threads disabled])
	OPENROAD_THREAD_BUILD="--disable-threads"
    fi
    AC_SUBST(OPENROAD_THREAD_BUILD)
])


AC_DEFUN([OR_ENABLE_SHARED], [
    AC_MSG_CHECKING([how to build libraries])
    AC_ARG_ENABLE(shared,
	AC_HELP_STRING([--enable-shared],
	    [build and link with shared libraries (default: on)]),
	[openroad_ok=$enableval], [openroad_ok=yes])

    if test "${enable_shared+set}" = set; then
	enableval="$enable_shared"
	openroad_ok=$enableval
    else
	openroad_ok=yes
    fi

    if test "$openroad_ok" = "yes" ; then
	AC_MSG_RESULT([shared])
    else
	AC_MSG_RESULT([static])
	AC_DEFINE(OPENROAD_STATIC_BUILD, 1, [Is this a static build?])
    fi
])


AC_DEFUN([UTD_PATH_CONFIG], [
    AC_MSG_CHECKING([for UTD common library path])
    AC_ARG_WITH(utdlib,
	AC_HELP_STRING([--with-utdlib],
	    [directory containing the UTD common library (libutd)]),
	with_utdlib="${withval}")
    AC_CACHE_VAL(ac_cv_c_utdlib,[

	# First check to see if --with-utdlib was specified.
	if test x"${with_utdlib}" != x ; then
	    if test -f "${with_utdlib}/include/utd/config.h" ; then
		ac_cv_c_utdlib="`(cd "${with_utdlib}"; pwd)`"
	    else
		AC_MSG_ERROR([${with_utdlib} directory doesn't contain utd/config.h])
	    fi
	fi

    ])

    if test x"${ac_cv_c_utdlib}" = x ; then
	UTDLIB_ROOT_DIR="# no Tcl configs found"
	AC_MSG_RESULT([Can't find UTD configuration definitions. Use --with-utdlib to specify a directory containing libutd])
    else
	UTDLIB_ROOT_DIR="${ac_cv_c_utdlib}"
	AC_MSG_RESULT([found ${UTDLIB_ROOT_DIR}/include/utd/config.h])
    fi
])

#------------------------------------------------------------------------
# UTD_ENABLE_AUTOTOOLS --
#
#	Allows the enabling and disabling of autotools
#
# Arguments:
#	none
#
# Results:
#
#	Adds the following arguments to configure:
#		--enable-autotools=yes|no
#
#	Sets the following vars:
#		ACLOCAL
#		AUTOCONF
#		AUTOHEADER
#		AUTOMAKE
#		MAKEINFO
#------------------------------------------------------------------------

AC_DEFUN([UTD_ENABLE_AUTOTOOLS], [
    AC_MSG_CHECKING([whether to use autotools to regenerate Makefiles])
    AC_ARG_ENABLE(autotools,
	AC_HELP_STRING([--enable-autotools],
	    [rebuild Makefiles with autotools (default: off)]),
	[utdautotools_ok=$enableval], [utdautotools_ok=no])

    if test "${enable_autotools+set}" = set; then
	enableval="$enable_autotools"
	utdautotools_ok=$enableval
    else
	utdautotools_ok=no
    fi

    if test "$utdautotools_ok" = "yes" ; then
	AC_MSG_RESULT([autotools enabled])
	UTDLIB_AUTOTOOLS="--enable-autotools"
    else
	AC_MSG_RESULT([autotools disabled])
	ACLOCAL="echo no aclocal mode"
	AUTOCONF="echo no autoconf mode"
	AUTOHEADER="echo no autoheader mode"
	AUTOMAKE="echo no automake mode"
	MAKEINFO="echo no makeinfo mode"
	UTDLIB_AUTOTOOLS="--disable-autotools"
    fi
    AC_SUBST(ACLOCAL)
    AC_SUBST(AUTOCONF)
    AC_SUBST(AUTOHEADER)
    AC_SUBST(AUTOMAKE)
    AC_SUBST(MAKEINFO)
    AC_SUBST(UTDLIB_AUTOTOOLS)
])

AC_DEFUN([OPENROAD_ROOT], [
    AC_MSG_CHECKING([for OpenRoad root path])
    AC_ARG_WITH(openroad,
	AC_HELP_STRING([--with-openroad],
	    [directory containing the OpenRoad root directory]),
	with_openroad="${withval}")
    AC_CACHE_VAL(ac_cv_c_openroad,[

	# First check to see if --with-openroad was specified.
	if test x"${with_openroad}" != x ; then
	  ac_cv_c_openroad="`(cd "${with_openroad}"; pwd)`"
	fi

    ])

    if test x"${ac_cv_c_openroad}" = x ; then
	OPENROAD_ROOT_DIR="# no OpenRoad directory found"
	OPENROAD_INCLUDE=""
	AC_MSG_RESULT([OPENROAD root directory not specified. Use --with-openroad to specify the OpenRoad root directory containing setenv.sh])
    else
	OPENROAD_ROOT_DIR="${ac_cv_c_openroad}"
	OPENROAD_INCLUDE="-I${ac_cv_c_openroad}/include"
	AC_SUBST(OPENROAD_ROOT_DIR)
	AC_SUBST(OPENROAD_INCLUDE)
	AC_MSG_RESULT([given ${OPENROAD_ROOT_DIR}])
    fi
])
