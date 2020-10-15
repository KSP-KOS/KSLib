// example_lib_exec.ks 
// Copyright © 2015,2019 KSLib team 
// Lic. MIT

run lib_exec.

execute("set " + "x" + " to " + "42" + "." + "print x."). // set x to 42. print x.

print evaluate("2 * 2 = 5"). // false
print evaluate("2 * 2 = 4"). // true

lock expr to 0. // otherwise compiler won't realize that expr is lock

set str_expr to "x * x + 2 * x - 10".

execute("lock expr to " + str_expr + ".").

print "f(x) = " + str_expr.

set x to -5.
set step to 1.

until x > 5
{
  print "f(" + x + ") = " + expr.
  set x to x + step.
}


set str_expr to "1 / x".

execute("lock expr to " + str_expr + ".").

print "g(x) = " + str_expr.

set x to 1.
set step to 2.

until x > 8
{
  print "g(" + x + ") = " + expr.
  set x to x + step.
}

function foo
{
  parameter x.
  return x ^ 2.
}

print evaluate_function("foo", list(10)).
