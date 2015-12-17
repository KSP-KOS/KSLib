// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_enum

``lib_enum.ks`` provides a set of functions for manipulating lists using the new delegates syntax introduced in kOS version 0.19.0. It allows you to transform and execute on lists by passing in a delegate function, and is designed to contain all the core components of an enumerable library.

function              | arguments                     | return type       | description
--------------------- | ----------------------------- | ----------------- | -----------
enum_all              | elements, match_fn@           | bool              | Check if all elements return true when passed to the delegate function
enum_any              | elements, match_fn@           | bool              | Check if any elements return true when passed to the delegate function
enum_count            | elements, match_fn@           | integer           | Count how many elements return true when passed to the delegate function
enum_each             | elements, operation_fn@       |                   | Call the delegate function with each element of the list as an argument
enum_each_slice       | elements, size, operation_fn@ |                   | Call the delegate function with fixed-size chunks of the list passed as an argument
enum_each_with_index  | elements, operation_fn@       |                   | Call the delegate function with each element and its index passed as arguments
enum_find             | elements, match_fn@           | element           | Return the first item in the list for which the delegate returns true
enum_find_index       | elements, match_fn@           | integer           | Return the index of the first item in the list for which the delegate returns true
enum_group_by         | elements, transform_fn@       | Lexicon           | Return a lexicon that maps the return values of the delegate to each element in the list
enum_map              | elements, transform_fn@       | List              | Return a new list with the return values of the delegate called with each element
enum_map_with_index   | elements, transform_fn@       | List              | Return a new list with the return values of the delegate called with each element and index
enum_max              | elements                      | element           | Return the largest value in the list
enum_min              | elements                      | element           | Return the smallest value in the list
enum_partition        | elements, match_fn@           | List(List, List)  | Return a list of lists, splitting the original list by the delegate's true/false result
enum_reduce           | elements, value, reduce_fn@   | final value       | Combine all the values of a list via binary operations, seeded with the starting value
enum_reject           | elements, match_fn@           | List              | Return a new list with all items for which the delegate returns false
enum_reverse          | elements                      | List              | Return a copy of the list with elements reversed
enum_select           | elements, match_fn@           | List              | Return a new list with all items for which the delegate returns true
enum_sort             | elements, compare_fn@         | List              | Return a new list with the original elements sorted by the delegate

### enum_all

Parameters:
  * elements (list) -- the elements you wish to check
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * bool

Returns `true` if the match_fn returns `true` for every element in the list. Otherwise, returns `false`.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_all(list(2,4,5), is_even@) => false
enum_all(list(2,4,6), is_even@) => true
```

### enum_any

Parameters:
  * elements (list) -- the elements you wish to check
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * bool

Returns `true` if the match_fn returns `true` for any element in the list. Otherwise, returns `false`.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_any(list(1,3,5), is_even@) => false
enum_any(list(1,3,6), is_even@) => true
```

### enum_count

Parameters:
  * elements (list) -- the elements you wish to check
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * integer

Calls the match_fn with each element in the list, and returns the number of times the result was `true`.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_count(list(1,2,3,4,5), is_even@) => 2
```

### enum_each

Parameters:
  * elements (list) -- the elements you wish to enumerate over
  * operation_fn@ (delegate function) -- a function accepting a single element

Calls the operation_fn for every element in the elements list.

Example:
```
function notify { parameter n. print n. }
enum_each(list(1,2,3), notify@)
=> 1
=> 2
=> 3
```

### enum_each_slice

Parameters:
  * elements (list) -- the elements you wish to enumerate over
  * size (integer) -- the size of list "chunks" to be passed to the operation_fn
  * operation_fn@ (delegate function) -- a function accepting a list of elements

Calls the operation_fn with chunks of the element list, based on the size parameter. When the elements list does not divide neatly, a smaller chunk will be used at the end. For example, if the elements list is `list(1,2,3)`, and the size is `2`, `enum_each_slice` will call `operation_fn` with `list(1,2)`, and then with `list(3)`.

Example:
```
function notify { parameter n. print n. }
enum_each_slice(list(1,2,3,4,5), 2, notify@)
=> list(1,2)
=> list(3,4)
=> list(5)
```

### enum_each_with_index

Parameters:
  * elements (list) -- the elements you wish to enumerate over
  * operation_fn@ (delegate function) -- a function accepting an element, and an index

Calls the operation_fn for every element in the elements list, passing in the element's index in the list as a second argument. *Note: The index passed in to the operation_fn begins at 1*

Example:
```
function notify { parameter s, i. print i + ": " + s. }
enum_each_with_index(list("foo","bar","baz"), notify@)
=> 1: foo
=> 2: bar
=> 3: baz
```

### enum_find

Parameters:
  * elements (list) -- the elements you wish to search
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * element

Returns the first element in the list for which match_fn returns `true`.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_find(list(1,2,3,4,5), is_even@) => 2
```

### enum_find_index

Parameters:
  * elements (list) -- the elements you wish to search
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * integer

Returns the index of the first element in the list for which match_fn returns `true`. If no element matches, this function returns -1.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_find_index(list(1,2,3,4,5), is_even@) => 1
```

### enum_group_by

Parameters:
  * elements (list) -- the elements you wish to group
  * transform_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * Lexicon

Returns a Lexicon with keys matching the return values of the transform_fn, with the lexicon values being a list of all elements that returned that value. This allows you to group the original elements list by arbitrary results of the transform function.

Example:
```
function even_or_odd { parameter n. if mod(n,2) = 0 return "even". return "odd". }
enum_group_by(list(1,2,3,4,5), even_or_odd@) => lexicon("odd" => list(1,3,5), "even" => list(2,4))
```

### enum_map

Parameters:
  * elements (list) -- the elements you wish to transform
  * transform_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * List

Returns a new list containing the results of applying the transform_fn to every element in the original list.

Example:
```
function even_or_odd { parameter n. if mod(n,2) = 0 return "even". return "odd". }
enum_map(list(1,2,3,4,5), even_or_odd@) => list("odd","even","odd","even","odd")
```

### enum_map_with_index

Parameters:
  * elements (list) -- the elements you wish to transform
  * transform_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * List

Returns a new list containing the results of applying the transform_fn to every element in the original list, with the index of each element passed as a second argument to the transform function.

Example:
```
function enumerate { parameter element, index. return index + ": " + element. }
enum_map_with_index(list("foo","bar","baz"), enumerate@). => list("1: foo", "2: bar", "3: baz")
```

### enum_max

Parameters:
  * elements (list) -- the elements for which you want to find the largest value

Return Type:
  * element

Returns the largest value in the list of elements.

Example:
```
enum_max(list(3,7,2)) => 7
```

### enum_min

Parameters:
  * elements (list) -- the elements for which you want to find the smallest value

Return Type:
  * element

Returns the smallest value in the list of elements.

Example:
```
enum_min(list(3,7,2)) => 2
```

### enum_partition

Parameters:
  * elements (list) -- the elements you wish to partition
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * List(List, List)

Returns a new list containing a list of elements for which the match_fn returned `true`, and a list of elements for which the match_fn returned `false`.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_partition(list(1,2,3,4,5), is_even@) => list(list(2,4), list(1,3,5))
```

### enum_reduce

Parameters:
  * elements (list) -- the elements you wish to reduce
  * value (any) -- the starting value with which to reduce the list
  * reduce_fn@ (delegate function) -- a function accepting a reduction value and a list element

Return Type:
  * value

Allows you to combine a list of elements by calling the reduce_fn on each element, with the first argument to the reduce function being the current reduction value. On the first call to the reduce function, the starting value will be the second argument passed to `enum_reduce`.

Example:
```
function concat { parameter memo, string. return memo + string. }
enum_reduce(list("foo",'bar","baz"), "", concat@) => "foobarbaz"

function multiply { parameter memo, n. return memo * n. }
enum_reduce(list(1,2,3,4,5), 1, multiply@) => 120
```

### enum_reject

Parameters:
  * elements (list) -- the elements you wish to match
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * List

Returns a new list containing only the elements for which match_fn *did not* return true.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_reject(list(1,2,3,4,5), is_even@) => list(1,3,5)
```

### enum_reverse

Parameters:
  * elements (list) -- the elements you wish to reverse

Return Type:
  * List

Returns a new list containing all the elements in reverse order.

Example:
```
enum_reverse(list(1,2,3,4,5)) => list(5,4,3,2,1)
```

### enum_select

Parameters:
  * elements (list) -- the elements you wish to match
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * List

Returns a new list containing only the elements for which match_fn *did* return true.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_select(list(1,2,3,4,5), is_even@) => list(2,4)
```

### enum_sort

Parameters:
  * elements (list) -- the elements you wish to sort
  * compare_fn@ (delegate function) -- a function accepting two elements

Return Type:
  * List

Returns a new list containing the elements sorted according to the compare_fn. The compare_fn should accept two elements. If the first element belongs earlier in the list, the compare_fn should return a negative number. If the second element belongs earlier in the list, the value should be positive. If the values are equivalent, the compare_fn should return 0.

*Note: `enum_sort` uses the [quicksort algorithm](https://www.wikiwand.com/en/Quicksort) to handle the actual sorting, relying on the Hoare partition scheme.*

Example:
```
function compare_string_descending {
  parameter a, b. return b:length - a:length.
}
enum_sort(list("foo","foobarbaz", "foobar"), compare_string_descending@) => list("foobarbaz","foobar","foo")
```
