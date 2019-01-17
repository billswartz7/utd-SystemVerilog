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
