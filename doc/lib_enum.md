// This file is distributed under the terms of the MIT license, (c) the KSLib team
## lib_enum

``lib_enum.ks`` provides a set of functions for manipulating lists using the new delegates syntax.

#### enum_all(<list>, <delegate>) => <boolean>

```
function is_even { parameter n. return mod(n,2) = 0. }
enum_all(list(2,4,5), is_even@) => false
enum_all(list(2,4,6), is_even@) => true
```

#### enum_any(<list>, <delegate>) => <boolean>

```
function is_even { parameter n. return mod(n,2) = 0. }
enum_any(list(1,3,5), is_even@) => false
enum_any(list(1,3,6), is_even@) => true
```

#### enum_count(<list>, <delegate>) => <number>

```
function is_even { parameter n. return mod(n,2) = 0. }
enum_count(list(1,2,3,4,5), is_even@) => 2
```

#### enum_each(<list>, <delegate>)

```
function notify { parameter n. print n. }
enum_each(list(1,2,3), notify@)
=> 1
=> 2
=> 3
```

#### enum_each_slice(<list>, <size>, <delegate>)

```
function notify { parameter n. print n. }
enum_each_slice(list(1,2,3,4,5), 2, notify@)
=> list(1,2)
=> list(3,4)
=> list(5)
```

#### enum_each_with_index(<list>, <delegate>)

```
function notify { parameter s, i. print i + ": " + s. }
enum_each_slice(list("foo","bar","baz"), notify@)
=> 1: foo
=> 2: bar
=> 3: baz
```

#### enum_find(<list>, <delegate>) => <object>

```
function is_even { parameter n. return mod(n,2) = 0. }
enum_find(list(1,2,3,4,5), is_even@) => 2
```

#### enum_find_index(<list>, <delegate>) => <number>

```
function is_even { parameter n. return mod(n,2) = 0. }
enum_find_index(list(1,2,3,4,5), is_even@) => 1
```

#### enum_group_by(<list>, <delegate>) => <lexicon>

```
function even_or_odd { parameter n. if mod(n,2) = 0 return "even". return "odd". }
enum_group_by(list(1,2,3,4,5), even_or_odd@) => lexicon("odd" => list(1,3,5), "even" => list(2,4))
```

#### enum_map(<list>, <delegate>) => <list>

```
function even_or_odd { parameter n. if mod(n,2) = 0 return "even". return "odd". }
enum_map(list(1,2,3,4,5), even_or_odd@) => list("odd","even","odd","even","odd")
```

#### enum_map_with_index(<list>, <delegate>) => <list>

```
function enumerate { parameter s, i. return i + ": " + s. }
enum_map_with_index(list("foo","bar","baz"), enumerate@). => list("1: foo", "2: bar", "3: baz")
```

#### enum_max(<list>) => <object>
```
enum_max(list(3,7,2)) => 7
```

#### enum_min(<list>) => <object>
```
enum_max(list(3,7,2)) => 2
```

#### enum_partition(<list>, <delegate>) => <list>
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_partition(list(1,2,3,4,5), is_even@) => list(list(2,4), list(1,3,5))
```

#### enum_reduce(<list>, <object>, <delegate>) => <object>
```
function sum { parameter memo, i. return memo + i. }
enum_reduce(list(1,2,3,4,5), 0, sum@) => 15
```

#### enum_reject(<list>, <delegate>) => <list>
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_reject(list(1,2,3,4,5), is_even@) => list(1,3,5)
```

#### enum_reverse(<list>) => <list>
```
enum_reverse(list(1,2,3,4,5)) => list(5,4,3,2,1)
```

#### enum_select(<list>) => <list>
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_select(list(1,2,3,4,5), is_even@) => list(2,4)
```

#### enum_sort(<list>, <delegate>) => <list>
```
function compare_string_descending {
  parameter a, b. return b:length - a:length.
}
enum_sort(list("foo","foobarbaz", "foobar"), compare_string_descending@) => list("foobarbaz","foobar","foo")
```
