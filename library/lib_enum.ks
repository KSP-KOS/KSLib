// lib_enum.ks provides a set of functions for manipulating lists, queues, and stacks using the new delegates syntax introduced in kOS version 0.19.0.
// Copyright © 2015,2016 KSLib team 
// Lic. MIT

{global Enum is lex(
"version", "0.1.1",
"all", all@,
"any", any@,
"count", count@,
"each", each@,
"each_slice", each_slice@,
"each_with_index", each_with_index@,
"find", find@,
"find_index", find_index@,
"group_by", group_by@,
"map", map@,
"map_with_index", map_with_index@,
"max", _max@,
"min", _min@,
"partition", partition@,
"reduce", reduce@,
"reject", reject@,
"reverse", reverse@,
"select", select@,
"sort", sort@
).

local y is true. local n is false.

function cast{
  parameter a,b,p is 0.
  if a:typename=b return a.
  if b="List"{set p to list(). for i in a p:add(i). return p.}
  if b="Queue"{set p to queue(). for i in a p:push(i). return p.}
  if b="Stack"{
    local l is stack().
    set p to stack(). for i in a p:push(i).
    for i in p l:push(i). return l.}}

function to_l{parameter c. return cast(c,"List").}

function all{parameter l,c. for i in l if not c(i) return n. return y.}

function any{parameter l,c. for i in l if c(i) return y. return n.}

function count{
  parameter l,c,p is 0. for i in l if c(i) set p to p+1. return p.}

function each{parameter l,o. for i in l o(i).}

function each_slice{
  parameter l,m,o,c is to_l(l),i is 0.
  until i > c:length-1 {
    o(cast(c:sublist(i,min(m,c:length-1)),l:typename)). set i to i+m.}}

function each_with_index{
  parameter l,o,i is 0. for j in to_l(l) {o(j,i+1). set i to i+1.}}

function find{parameter l,c. for i in l if c(i) return i. return n.}

function find_index{
  parameter l,c,i is 0. for j in to_l(l) {if c(j) return i. set i to i+1.}
  return -1.}

function group_by{parameter l,t,p is lex(). for i in l{
  local u is t(i). if p:haskey(u) p[u]:add(i). else set p[u] to list(i).}
  for k in p:keys set p[k] to cast(p[k],l:typename). return p.}

function map{
  parameter l,t,p is list(). for i in to_l(l) p:add(t(i)).
  return cast(p,l:typename).}

function map_with_index{parameter l,t,p is list(), i is 0, c is to_l(l).
  until i=c:length { p:add(t(c[i],i+1)). set i to i+1. }
  return cast(p,l:typename).}

function _max{parameter l,c is to_l(l). if c:length=0 return n.
  local p is c[0]. for i in c if i>p set p to i. return p.}

function _min{parameter l, c is to_l(l). if c:length=0 return n.
  local p is c[0]. for i in c if i<p set p to i. return p.}

function partition{parameter l,o,c is to_l(l), p is list(list(),list()).
  for i in c { if o(i) p[0]:add(i). else p[1]:add(i). }
  set p[0] to cast(p[0],l:typename). set p[1] to cast(p[1],l:typename).
  return p.
}

function reduce{parameter l,m,t. for i in to_l(l) set m to t(m,i). return m.}

function reject{parameter l,c,p is list().
  for i in to_l(l) if not c(i) p:add(i). return cast(p,l:typename). }

function reverse{parameter l,p is stack().
  for i in l p:push(i). return cast(p,l:typename).}

function select{parameter l,c,p is list().
  for i in to_l(l) if c(i) p:add(i). return cast(p,l:typename).}

function sort{
  parameter l,c,p is to_l(l):copy.
  function qs{parameter A,lo,hi.
    if lo<hi{local p is pt(A, lo, hi). qs(A, lo, p). qs(A, p + 1, hi).}}
  function pt{parameter A, lo, hi, pivot is A[lo], i is lo-1, j is hi+1.
    until 0 {
      until 0 {set j to j-1. if c(A[j],pivot)<=0 break.}
      until 0 {set i to i+1. if c(A[i],pivot)>=0 break.}
      if i<j{local s is A[i]. set A[i] to A[j]. set A[j] to s.} else return j.
    }
  }
  qs(p,0,p:length-1). return cast(p,l:typename).
}}
