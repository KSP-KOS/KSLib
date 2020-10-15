// lib_testing.ks 
// Copyright © 2015 KSLib team 
// Lic. MIT

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
