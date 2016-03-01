// This file is distributed under the terms of the MIT license, (c) the KSLib team
// Originally developed by abenkovskii

// The mess below declares a function execute that executes a command from it's string representation.
// I'm 95% sure there is no easy way to achieve this behavior in the current version of kOS (0.17).
// All easier solutions I know fail to work as expected in a range of special cases.
// If you think you know an easy way to implement it there are unit tests
// in KSLib/unit_tests/lib_exec to test your implementation.
// See "run is weird" for more detailed information: [link is coming soon (tm)]

@LAZYGLOBAL OFF.

clearscreen.
print "ERROR: [lib_exec.ks] - lib_exec is broken at this time. If you have an in script workaround then please feel free to submit a PR on the KSLib github page.".
print 1/0.

log "" to _execute.internal.
delete _execute.internal.
log "" to _execute.tmp.
delete _execute.tmp.
log "" to _execute.init.
delete _execute.init.

log "{}" to _execute.tmp.
log "run _execute.tmp." to _execute.internal.

global _execute__empty_string is "".

log
  "run _execute.internal. " +
  "function execute" +
  "{" +
    "parameter command. " +
    "log _execute__empty_string to _execute.tmp. " +
    "delete _execute.tmp. " +
    "log command to _execute.tmp. " +
    "run _execute.internal. " +
    "log _execute__empty_string to _execute.tmp. " +
    "delete _execute.tmp. " +
  "}"
to _execute.init.
run _execute.init.

delete _execute.init.
delete _execute.internal.
delete _execute.tmp.

// evaluate an expression
// Attention: evaluate() is implemented using execute().
// You'll have to copy the mess above or it won't work
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
  return evaluate(expression).
}
