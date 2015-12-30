// This file is distributed under the terms of the MIT license, (c) the KSLib team

## lib_enum

``lib_enum.ks`` provides a set of functions for manipulating lists, queues, and stacks using the new delegates syntax introduced in kOS version 0.19.0. It allows you to transform and execute on lists, queues, and stacks by passing in a delegate function, and is designed to contain all the core components of an enumerable library.

Each of the functions is made available through the `enum` [lexicon](http://ksp-kos.github.io/KOS_DOC/structures/misc/lexicon.html), to minimize the number of variables used in the global namespace. They can be called using the following syntax: `run lib_enum. enum["max"](list(1,2,3)) // 3` All functions work on [Lists](http://ksp-kos.github.io/KOS_DOC/structures/misc/list.html), [Stacks](http://ksp-kos.github.io/KOS_DOC/structures/misc/stack.html), and [Queues](http://ksp-kos.github.io/KOS_DOC/structures/misc/queue.html), and when collections are returned, they will be of the same type as the original input.

function        | arguments                     | return type   | description
----------------| ----------------------------- | ------------- | -----------
all             | elements, match_fn@           | bool          | Check if all elements return true when passed to the delegate function
any             | elements, match_fn@           | bool          | Check if any elements return true when passed to the delegate function
count           | elements, match_fn@           | integer       | Count how many elements return true when passed to the delegate function
each            | elements, operation_fn@       |               | Call the delegate function with each element of the collection as an argument
each_slice      | elements, size, operation_fn@ |               | Call the delegate function with fixed-size chunks of the collection passed as an argument
each_with_index | elements, operation_fn@       |               | Call the delegate function with each element and its index passed as arguments
find            | elements, match_fn@           | element       | Return the first item in the collection for which the delegate returns true
find_index      | elements, match_fn@           | integer       | Return the index of the first item in the collection for which the delegate returns true
group_by        | elements, transform_fn@       | Lexicon       | Return a lexicon that maps the return values of the delegate to each element in the collection
map             | elements, transform_fn@       | collection    | Return a new collection  with the return values of the delegate called with each element
map_with_index  | elements, transform_fn@       | collection    | Return a new collection  with the return values of the delegate called with each element and index
max             | elements                      | element       | Return the largest value in the collection
min             | elements                      | element       | Return the smallest value in the collection
partition       | elements, match_fn@           | List          | Return a list of collections, splitting the original collection by the delegate's true/false result
reduce          | elements, value, reduce_fn@   | final value   | Combine all the values of a collection via binary operations, seeded with the starting value
reject          | elements, match_fn@           | collection    | Return a new collection with all items for which the delegate returns false
reverse         | elements                      | collection    | Return a copy of the collection with elements reversed
select          | elements, match_fn@           | collection    | Return a new collection with all items for which the delegate returns true
sort            | elements, compare_fn@         | collection    | Return a new collection with the original elements sorted by the delegate

### enum["all"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to check
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * bool

Returns `true` if the match_fn returns `true` for every element in the collection. Otherwise, returns `false`.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum["all"](list(2,4,5), is_even@). // false
enum["all"](queue(2,4,6), is_even@). // true
```

### enum["any"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to check
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * bool

Returns `true` if the match_fn returns `true` for any element in the collection. Otherwise, returns `false`.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum["any"](stack(1,3,5), is_even@). // false
enum["any"](queue(1,3,6), is_even@). // true
```

### enum["count"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to check
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * integer

Calls the match_fn with each element in the collection, and returns the number of times the result was `true`.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_count(queue(1,2,3,4,5), is_even@). // 2
```

### enum["each"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to iterate over
  * operation_fn@ (delegate function) -- a function accepting a single element

Calls the operation_fn for every element in the collection.

Example:
```
function notify { parameter n. print n. }
enum["each"](list(1,2,3), notify@).
// 1
// 2
// 3
```

### enum["each_slice"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to iterate over
  * size (integer) -- the size of "chunks" to be passed to the operation_fn
  * operation_fn@ (delegate function) -- a function accepting a collection of elements

Calls the operation_fn with chunks of the collection, based on the size parameter. When the elements collection does not divide neatly, a smaller chunk will be used at the end. For example, if the elements collection is `queue(1,2,3)`, and the size is `2`, `enum["each_slice"]` will call `operation_fn` with `queue(1,2)`, and then with `queue(3)`.

Example:
```
function notify { parameter n. print n. }
enum["each_slice"](list(1,2,3,4,5), 2, notify@).
// list(1,2)
// list(3,4)
// list(5)
```

### enum["each_with_index"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to iterate over
  * operation_fn@ (delegate function) -- a function accepting an element, and an index

Calls the operation_fn for every element in the collection, passing in the element's index in the collection as a second argument. *Note: The index passed in to the operation_fn begins at 1*

Example:
```
function notify { parameter s, i. print i + ": " + s. }
enum["each_with_index"](stack("baz","bar","foo"), notify@).
// 1: foo
// 2: bar
// 3: baz
```

### enum["find"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to search
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * element

Returns the first element in the collection for which match_fn returns `true`.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_find(list(1,2,3,4,5), is_even@). // 2
```

### enum["find_index"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to search
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * integer

Returns the index of the first element in the collection for which match_fn returns `true`. If no element matches, this function returns -1.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum_find_index(list(1,2,3,4,5), is_even@). // 1
```

### enum["group_by"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to group
  * transform_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * Lexicon

Returns a Lexicon with keys matching the return values of the transform_fn, with the lexicon values being a collection of all elements that returned that value. This allows you to group the original elements by the result of the transform function.

Example:
```
function even_or_odd { parameter n. if mod(n,2) = 0 return "even". return "odd". }
enum["group_by"](queue(1,2,3,4,5), even_or_odd@). // lexicon("odd" => queue(1,3,5), "even" => queue(2,4))
```

### enum["map"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to transform
  * transform_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * List/Queue/Stack

Returns a new collection containing the results of applying the transform_fn to every element in the original collection.

Example:
```
function even_or_odd { parameter n. if mod(n,2) = 0 return "even". return "odd". }
enum["map"](stack(1,2,3,4,5), even_or_odd@). // stack("odd","even","odd","even","odd")
```

### enum["map_with_index"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to transform
  * transform_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * List/Queue/Stack

Returns a new collection containing the results of applying the transform_fn to every element in the original collection, with the index of each element passed as a second argument to the transform function.

Example:
```
function enumerate { parameter element, index. return index + ": " + element. }
enum["map_with_index"](list("foo","bar","baz"), enumerate@). // list("1: foo", "2: bar", "3: baz")
```

### enum["max"]

Parameters:
  * elements (list/queue/stack) -- the elements for which you want to find the largest value

Return Type:
  * element

Returns the largest value in the collection.

Example:
```
enum["max"](stack(3,7,2)). // 7
```

### enum["min"]

Parameters:
  * elements (list/queue/stack) -- the elements for which you want to find the smallest value

Return Type:
  * element

Returns the smallest value in the collection.

Example:
```
enum["min"](queue(3,7,2)). // 2
```

### enum["partition"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to partition
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * List(collection, collection)

Returns a new list containing a collection of elements for which the match_fn returned `true`, and a collection of elements for which the match_fn returned `false`. *Note: the result from `enum["partition"]` will always be a list, regardless of whether the initial collection is a list, queue, or stack. However, the nested collections will be of the same type as the original collection. For example, if you split a queue, `set split to enum["partition"](queue(1,2,3), my_split_fn@).`, then `split[0]` will also be a queue.*

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum["partition"](stack(1,2,3,4,5), is_even@). // list(stack(2,4), stack(1,3,5))
```

### enum["reduce"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to reduce
  * value (any) -- the starting value with which to reduce the list
  * reduce_fn@ (delegate function) -- a function accepting a reduction value and an element

Return Type:
  * value

Allows you to combine a collection by calling the reduce_fn on each element, with the first argument to the reduce function being the current reduction value. On the first call to the reduce function, the starting value will be the second argument passed to `enum["reduce"]`.

Example:
```
function concat { parameter memo, string. return memo + string. }
enum["reduce"](queue("foo",'bar","baz"), "", concat@). // "foobarbaz"

function multiply { parameter memo, n. return memo * n. }
enum["reduce"](list(1,2,3,4,5), 1, multiply@). // 120
```

### enum["reject"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to match
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * List/Queue/Stack

Returns a new collection containing only the elements for which match_fn *did not* return true.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum["reject"](stack(1,2,3,4,5), is_even@). // stack(1,3,5)
```

### enum["reverse"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to reverse

Return Type:
  * List/Queue/Stack

Returns a new collection containing all the elements in reverse order.

Example:
```
enum["reverse"](queue(1,2,3,4,5)). // queue(5,4,3,2,1)
```

### enum["select"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to match
  * match_fn@ (delegate function) -- a function accepting a single element

Return Type:
  * List

Returns a new collection containing only the elements for which match_fn *did* return true.

Example:
```
function is_even { parameter n. return mod(n,2) = 0. }
enum["select"](list(1,2,3,4,5), is_even@). // list(2,4)
```

### enum["sort"]

Parameters:
  * elements (list/queue/stack) -- the elements you wish to sort
  * compare_fn@ (delegate function) -- a function accepting two elements

Return Type:
  * List/Queue/Stack

Returns a new collection containing the elements sorted according to the compare_fn. The compare_fn should accept two elements. If the first element belongs earlier in the list, the compare_fn should return a negative number. If the second element belongs earlier in the list, the value should be positive. If the values are equivalent, the compare_fn should return 0.

*Note: `enum['sort"]` uses the [quicksort algorithm](https://www.wikiwand.com/en/Quicksort) to handle the actual sorting, relying on the Hoare partition scheme.*

Example:
```
function compare_string_descending {
  parameter a, b. return b:length - a:length.
}
enum["sort"](list("foo","foobarbaz", "foobar"), compare_string_descending@). // list("foobarbaz","foobar","foo")
```
