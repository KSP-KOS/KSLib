// This file is distributed under the terms of the MIT license, (c) the KSLib team

@lazyglobal off.

function assert
{
  parameter boolean.
  if not boolean
  {
    print "test failed". print 1/0.
  }
}

function test_success
{
  print "test finished successfully".
}
