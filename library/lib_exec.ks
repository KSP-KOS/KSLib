// This file is distributed under the terms of the MIT license, (c) the KSLib team
// Originally developed by abenkovskii

// The mess below declares a function execute that executes a command from it's string representation.
// I'm 95% sure there is no easy way to achieve this behavior in the current version of kOS (0.17).
// All easier solutions I know fail to work as expected in a range of special cases.
// If you think you know an easy way to implement it there are unit tests
// in KSLib/unit_tests/lib_exec to test your implementation.
// See "run is weird" for more detailed information: [link is coming soon (tm)]

// The execute function is now implemented using a version of the SHA-1 hashing algorithm.
// This modification was done in kOS version (1.1.9.0) and works as of that version.
// This is not backwards compatible with earlier versions of kOS.
// Failing a collision between the hashes of two different commands and the execute function should work perfectly if slower than it once did.

// nuggreat's notes about run/runpath as of kOS version (1.1.9.0)
// When a file is run for the first time it gets stored in memory so that any addational calls to run the given file can be served a lot faster.
// This means that even if you delete a file and then recreate it with different stuff it that won't update the version kOS is storing as the user has no way to make kOS forget a stored instance of a file.
// And as files are IDed by there name (and possably path haven't tested that) if the name doesn't change even if the contents do then kOS will run the version it stored.
// The version kOS stors only leaves memory when kOS falls back to the termonal level.
// Thus for a file to be runnable with different internal commands it must have a different name.
// NOTE: This might change in the future but at least as of kOS version (1.1.9.0) this is the way run appears to work.

@LAZYGLOBAL OFF.

run lib_hash.


function execute_long_hash {//implemented using the full SHA-1 algorithm
// expect it to take 9.2s for a command of 28 char or less
// from char 29 on expect an additional 9.14s every 32 char
// all times measured on an IPU of 2000 with no triggers running
  parameter command.
  //print command.
  local filePath IS path("_execute_" + generate_hash(command) + ".tmp").
  //print filePath.
  if exists(filePath) { deletepath(filePath). }
  log command to filePath.
  wait 0.
  runpath(filePath).
  deletepath(filePath).
}

function execute_short_hash {//a modification of the SHA-1 algorithm that removes one of the steps and thus reduces the time needed by a factor of about 5.68
  parameter command.
  //print command.
  local filePath IS path("_execute_" + generate_hash(command,true) + ".tmp").
  //print filePath.
  if exists(filePath) { deletepath(filePath). }
  log command to filePath.
  wait 0.
  runpath(filePath).
  deletepath(filePath).
}

if not (defined _exec_idString) {
  global _exec_idString is char(127).//starts at char 127 to avoid reserved word in windows file names
}
function execute_counter {//an implementation of execute using a counter
  parameter command.
  
  //start of string incrementing
  local carry is false.
  local strStart is _exec_idString:LENGTH - 1.
  from { local i is strStart. } until i < 0 step { SET i to i - 1. } do {
    local tmpNum is unchar(_exec_idString[i]).
	//print tmpNum.
    if carry or (i = strStart) {
      set tmpNum to tmpNum + 1.
	  set carry to false.
    }
    if tmpNum > 255 {
      set tmpNum to tmpNum - 128.
      set carry to true.
    }
    local subStringHigh IS _exec_idString:substring(i,_exec_idString:LENGTH - i).
    set subStringHigh to subStringHigh:remove(0,1).
    local subStringLow is _exec_idString:substring(0,i).
    set _exec_idString to subStringLow + char(tmpNum) + subStringHigh.
    
  }
  if carry { set _exec_idString to char(128) + _exec_idString. }//end of string incrementing
  
  //print command.
  local filePath IS path("_execute_" + _exec_idString + ".tmp").
  //print filePath.
  if exists(filePath) { deletepath(filePath). }
  log command to filePath.
  wait 0.
  runpath(filePath).
  deletepath(filePath).
}

function evaluate
{
  parameter expression.

  execute("global _evaluate_result is " + expression + ".").
  local result is _evaluate_result.
  unset _evaluate_result.
  return result.
}

function evaluate_function
{
  parameter
    function_name,
    parameter_list.

  global _exec__param_list is parameter_list.
  local expression is "".
  local separator is "".
  local index is 0.
  until index = parameter_list:length
  {
    set expression to expression + separator + "_exec__param_list[" + index + "]".
    set separator to ", ".
    set index to index + 1.
  }
  set expression to function_name + "(" + expression + ")".
  unset _exec__param_list.
  return evaluate(expression).
}