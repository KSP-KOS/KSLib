// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_exec

Any good scripting language should be able to run it's own interpreter.
Warning there are some complex situations that might cause this library
to stop working correctly. I'll add the documentation for those cases soon (tm).

### execute

args:
  * command - a command or a sequence of commands to execute

description:
  * Execute a command.

### evaluate

args:
  * expression - an expression to evaluate.

returns:
  * result - result of expression evaluation.

description:
  * Evaluate an expression.
