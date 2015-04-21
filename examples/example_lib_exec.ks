// This file is distributed under the terms of the MIT license, (c) the KSLib team

run exec_lib.

execute("set " + "x" + " to " + "42" + "." + "print x."). // set x to 42. print x.

print evaluate("2 * 2 = 5"). // false
print evaluate("2 * 2 = 4"). // true
