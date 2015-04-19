// This file is distributed under the terms of the MIT license, (c) the KSLib team

// execute a command (or a bunch of commands)
function execute
{
  parameter command.
  log "" to _execute.tmp.
  delete _execute.tmp.
  log command to _execute.tmp.
  run _execute.internal.
  delete _execute.tmp.
}

// evaluate an expression
function evaluate
{
  parameter expression.
  execute("global _evaluate_result is " + expression + ".").
  local result is _evaluate_result.
  unset _evaluate_result.
  return result.
}

// set up _execute.internal.
// all the lines below are essential for function execute to work properly
// run command in kOS works in a very weird way when you change file
// contents at runtime.
// See my "run is weird" for more detailed information: [link is coming soon (tm)]
log "" to _execute.internal.
delete _execute.internal.
log "run _execute.tmp." to _execute.internal.
log "" to _execute.tmp.
delete _execute.tmp.
log "{}" to _execute.tmp.
run _execute.internal.
delete _execute.internal.
delete _execute.tmp.
