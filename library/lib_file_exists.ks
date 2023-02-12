// lib_file_exists.ks is a means of checking for optional dependencies, or checking whether a file exists before attempting to run it.
// Copyright © 2015,2023 KSLib team 
// Lic. MIT

@LAZYGLOBAL off.
@CLOBBERBUILTINS off.

function file_exists{
 parameter fileName.
 local fileList is list().
 local found is false.
 list files in fileList.
 for file in fileList {
  if file = fileName {
   set found to true.
   break.
  }
 }
 return found.
}
