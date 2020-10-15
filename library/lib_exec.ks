// lib_exec.ks - executes a command from its string representation.
// Copyright © 2015,2019,2020 KSLib team 
// Lic. MIT

// Originally developed by abenkovskii

// The mess below declares a function execute that executes a command from it's string representation.
// I'm 95% sure there is no easy way to achieve this behavior in the current version of kOS (0.17).
// All easier solutions I know fail to work as expected in a range of special cases.
// If you think you know an easy way to implement it there are unit tests
// in KSLib/unit_tests/lib_exec to test your implementation.
// See "run is weird" for more detailed information: [link is coming soon (tm)]

// The execute function is now implemented using an incrementing string so that each time the function is called there is a unique file name.
// This modification was done in kOS version (1.1.9.0) and works as of that version.
// It should be backwards compatible with earlier versions of kOS but this has not been tested.

// nuggreat's notes about run/runpath as of kOS version (1.1.9.0)
// When a file is run for the first time it gets stored in memory so that any additional calls to run the given file can be served a lot faster.
// This means that even if you delete a file and then recreate it with different stuff it that won't update the version kOS is storing as the user has no way to make kOS forget a stored instance of a file.
// And as files are IDed by there name (and possibly path haven't tested that) if the name doesn't change even if the contents do then kOS will run the version it stored.
// The version kOS stores only leaves memory when kOS falls back to the terminal level.
// Thus for a file to be runnable with different internal commands it must have a different name.
// NOTE: This might change in the future but at least as of kOS version (1.1.9.0) this is the way run appears to work.

@LAZYGLOBAL OFF.

if not (defined _exec_idString) {
  global _exec_idString is char(127).//starts at char 127 to avoid reserved charters in windows file names
}

if not (defined _past_exec_strings) {
  global _past_exec_strings is lexicon().//stores previously executed commands and the associated path, intended to prevent increment of _exec_idString if calling the same command repeatedly.
  set _past_exec_strings:casesensitive to true.
}

function execute {
  parameter command.

  local filePath IS path().
  if _past_exec_strings:haskey(command) {//if we have already run a command recall the path used the old path
    set filePath to _past_exec_strings[command].
  } else {
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
    if carry { set _exec_idString to char(128) + _exec_idString. }
    //end of string incrementing
    set filePath to path("1:/_execute_" + _exec_idString + ".tmp").
    _past_exec_strings:ADD(command,filePath).
  }
  log_run_del(command,filePath).
}

function evaluate {
  parameter expression.

  execute("global _evaluate_result is " + expression + ".").
  local result is _evaluate_result.
  if defined _evaluate_result {
    unset _evaluate_result.
  }
  return result.
}

function evaluate_function {
  parameter
    function_name,
    parameter_list.

  global _exec__param_list is parameter_list.
  local expression is "".
  local separator is "".
  local index is 0.
  until index = parameter_list:length {
    set expression to expression + separator + "_exec__param_list[" + index + "]".
    set separator to ", ".
    set index to index + 1.
  }
  set expression to function_name + "(" + expression + ")".
  local result is evaluate(expression).
  if defined _exec__param_list {
    unset _exec__param_list.
  }
  return result.
}

function get_suffix {
  parameter
    structure, //the structure to get the suffix of
    suffix,    //the suffix to get
    parameter_list IS false. //if the suffix is a function call this is the list of parameters for the suffix
	
  local filePath is "1:/_get_suffix" + suffix.
  local logStr IS "global _evaluate_result is { parameter o. return o:" + suffix.
  if parameter_list:istype("list") {
    set filePath to filePath + parameter_list:length.
    local separator is "(".
    global _exec__param_list IS parameter_list.
    local i IS 0.
    until i >= parameter_list:length
    {
      set logStr to logStr + separator + "_exec__param_list[" + i + "]".
      set separator to ", ".
      set i to i + 1.
    }
    set logStr to logStr + ")".
  }
  set filePath to path(filePath + ".tmp").
  log_run_del(logStr + ". }.",filePath).
  local result is _evaluate_result:call(structure).
  if defined _exec__param_list {
    unset _exec__param_list.
  }
  return result.
}

function set_suffix {
  parameter
    structure, //the structure to set the suffix of
    suffix,    //the suffix to set
    val.       //the value to set the suffix to
	
  local filePath is path("1:/_set_suffix" + suffix + ".tmp").
  local logStr IS "global _evaluate_result is { parameter o,v. set o:" + suffix + " to v. }.".
  log_run_del(logStr,filePath).
  local result is _evaluate_result:call(structure,val).
  unset _evaluate_result.
  return result.
}

local function log_run_del {
  parameter
    log_string,//the string to be executed
    file_path. //the path to where the string should be stored temporarily so it can be executed.
	
  if exists(file_path) {
    deletepath(file_path).
  }
  log log_string to file_path.
  wait 0.
  runpath(file_path).
  deletepath(file_path).
}
