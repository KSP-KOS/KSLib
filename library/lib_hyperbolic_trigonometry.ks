// lib_hyperbolic_trigonometry.ks provides the usual hyperbolic functions and their inverses.
// Copyright © 2021 KSLib team 
// Lic. MIT

@lazyglobal off.

function cosh {
  parameter x.
  
  local toRadian to x * constant:degToRad.
  return (constant:e^toRadian + constant:e^(-toRadian)) / 2.
}

function sinh {
  parameter x.
  
  local toRadian to x * constant:degToRad.
  return (constant:e^toRadian - constant:e^(-toRadian)) / 2.
}

function tanh {
  parameter x.
  
  local toRadian to x * constant:degToRad.
  return (1 - constant:e^(-2 * toRadian)) / (1 + constant:e^(-2 * toRadian)).
}

function arccosh {
  parameter n.
  
  return ln(n + sqrt(n + 1) * sqrt(n - 1)) * constant:radToDeg.
}

function arcsinh {
  parameter n.
  
  return ln(n + sqrt(1 + n^2)) * constant:radToDeg.
}

function arctanh {
  parameter n.
  
  return (ln((1 + n) / (1 - n)) / 2) * constant:radToDeg.
}
