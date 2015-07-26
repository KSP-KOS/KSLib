// This file is distributed under the terms of the MIT license, (c) the KSLib team

@LAZYGLOBAL off.

function file_exists{
 parameter fileName.
 local fileList is list().
 local found is false.
 list files in fileList.
 for file in fileList {
  if file = fileName {
   set found to true.
  }
 }
 return found.
}
