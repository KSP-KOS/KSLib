@LAZYGLOBAL off.

function dep_check {
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
