DESTDIR?=
PREFIX?=/usr

VERSION=0.6.1

CFLAGS_STD?=-D_POSIX_C_SOURCE=200809L -D_XOPEN_SOURCE=700
CFLAGS+=${CFLAGS_STD}

CFLAGS+=-Wall
#CFLAGS+=-O3
#CFLAGS+=-ggdb -g -Wall -O0

HAVE_VALA=$(shell valac --version 2> /dev/null)
# This is hacky
HOST_CC?=gcc
RANLIB?=ranlib
OS?=$(shell uname)
ARCH?=$(shell uname -m)

ifeq (${OS},w32)
WCP?=i386-mingw32
CC=${WCP}-gcc
AR?=${WCP}-ar
CFLAGS_SHARED?=-fPIC -shared
EXEXT=.exe
else
CFLAGS_SHARED?=-fPIC -shared -fvisibility=hidden
CC?=gcc
EXEXT=
endif

# create .d files
CFLAGS+=-MMD

ifeq (${OS},Darwin)
SOEXT=dylib
LDFLAGS+=-dynamic
LDFLAGS_SHARED?=-fPIC -shared
 ifeq (${ARCH},i386)
   #CC+=-arch i386 
   CC+=-arch x86_64
 endif
else
SOVERSION=0
SOEXT=so.0.0.0
LDFLAGS_SHARED?=-fPIC -shared
LDFLAGS_SHARED+=-Wl,-soname,libsdb.so.$(SOVERSION)
endif

ifeq ($(MAKEFLAGS),s)
SILENT=1
else
SILENT=
endif
