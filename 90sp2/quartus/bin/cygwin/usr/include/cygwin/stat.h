/* cygwin/stat.h

   Copyright 2002, 2007 Red Hat Inc.
   Written by Corinna Vinschen <corinna@vinschen.de>

This file is part of Cygwin.

This software is a copyrighted work licensed under the terms of the
Cygwin license.  Please consult the file "CYGWIN_LICENSE" for
details. */

#ifndef _CYGWIN_STAT_H
#define _CYGWIN_STAT_H

#ifdef __cplusplus
extern "C" {
#endif

#if defined (__INSIDE_CYGWIN__) || defined (_COMPILING_NEWLIB)
struct __stat32
{
  __dev16_t	st_dev;
  __ino32_t	st_ino;
  mode_t	st_mode;
  nlink_t       st_nlink;
  __uid16_t     st_uid;
  __gid16_t     st_gid;
  __dev16_t     st_rdev;
  _off_t        st_size;
  timestruc_t   st_atim;
  timestruc_t   st_mtim;
  timestruc_t   st_ctim;
  blksize_t     st_blksize;
  __blkcnt32_t  st_blocks;
  long          st_spare4[2];
};

struct __stat64
{
  __dev32_t     st_dev;
  __ino64_t     st_ino;
  mode_t        st_mode;
  nlink_t       st_nlink;
  __uid32_t     st_uid;
  __gid32_t     st_gid;
  __dev32_t     st_rdev;
  _off64_t      st_size;
  timestruc_t   st_atim;
  timestruc_t   st_mtim;
  timestruc_t   st_ctim;
  blksize_t     st_blksize;
  __blkcnt64_t  st_blocks;
  timestruc_t   st_birthtim;
};

extern int fstat64 (int fd, struct __stat64 *buf);
extern int stat64 (const char *file_name, struct __stat64 *buf);
extern int lstat64 (const char *file_name, struct __stat64 *buf);

#endif

struct stat
{
  dev_t         st_dev;
  ino_t         st_ino;
  mode_t        st_mode;
  nlink_t       st_nlink;
  uid_t         st_uid;
  gid_t         st_gid;
  dev_t         st_rdev;
  off_t         st_size;
  timestruc_t   st_atim;
  timestruc_t   st_mtim;
  timestruc_t   st_ctim;
  blksize_t     st_blksize;
  blkcnt_t      st_blocks;
#ifdef __CYGWIN_USE_BIG_TYPES__
  timestruc_t   st_birthtim;
#else
  long          st_spare4[2];
#endif
};

#define st_atime st_atim.tv_sec
#define st_mtime st_mtim.tv_sec
#define st_ctime st_ctim.tv_sec
#ifdef __CYGWIN_USE_BIG_TYPES__
#define st_birthtime st_birthtim.tv_sec
#endif

/* POSIX IPC objects are not implemented as distinct file types, so the
   below macros have to return 0.  The expression is supposed to catch
   illegal usage with non-stat parameters. */
#define S_TYPEISMQ(buf)  ((void)(buf)->st_mode,0)
#define S_TYPEISSEM(buf) ((void)(buf)->st_mode,0)
#define S_TYPEISSHM(buf) ((void)(buf)->st_mode,0)

#ifdef __cplusplus
}
#endif

#endif /* _CYGWIN_STAT_H */
