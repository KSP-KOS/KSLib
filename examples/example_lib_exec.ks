// This file is distributed under the terms of the MIT license, (c) the KSLib team

run lib_exec.

execute("set " + "x" + " to " + "42" + "." + "print x."). // set x to 42. print x.

print evaluate("2 * 2 = 5"). // false
print evaluate("2 * 2 = 4"). // true
