// lib_enum_spec.ks 
// Copyright © 2015,2016 KSLib team 
// Lic. MIT
// Note: This requires KSpec - see https://github.com/gisikw/kspec

RUN lib_enum.
function is_even { parameter n. return mod(n,2) = 0. }

describe("lib_enum").
  it("exposes a global enum module", "test_module").
    function test_module {
      Enum. assert(true).
    }
  end.

  it("has a version property equal to 0.1.1", "test_version").
    function test_version {
      assert_equal(Enum["version"], "0.1.1").
    }
  end.

  describe("all").
    context("when every element passes the condition").
      it("returns true", "test_all_true").
        function test_all_true {
          assert(Enum["all"](list(2,4,6), is_even@)).
          assert(Enum["all"](queue(2,4,6), is_even@)).
          assert(Enum["all"](stack(2,4,6), is_even@)).
        }
      end.
    end.

    context("when one element fail the condition").
      it("returns false", "test_all_false").
        function test_all_false {
          assert(not Enum["all"](list(2,5,6), is_even@)).
          assert(not Enum["all"](queue(2,5,6), is_even@)).
          assert(not Enum["all"](stack(2,5,6), is_even@)).
        }
      end.
    end.
  end.

  describe("any").
    context("when one element passes the condition").
      it("returns true", "test_any_true").
        function test_any_true {
          assert(Enum["any"](list(1,4,5), is_even@)).
          assert(Enum["any"](queue(1,4,5), is_even@)).
          assert(Enum["any"](stack(1,4,5), is_even@)).
        }
      end.
    end.

    context("when all elements fail the condition").
      it("returns false", "test_any_false").
        function test_any_false {
          assert(not Enum["any"](list(1,3,5), is_even@)).
          assert(not Enum["any"](queue(1,3,5), is_even@)).
          assert(not Enum["any"](stack(1,3,5), is_even@)).
        }
      end.
    end.
  end.

  describe("count").
    it("returns the number of items that meet the condition", "test_count").
      function test_count {
        assert_equal(Enum["count"](list(1,2,3,4,5), is_even@), 2).
        assert_equal(Enum["count"](queue(1,2,3,4,5), is_even@), 2).
        assert_equal(Enum["count"](stack(1,2,3,4,5), is_even@), 2).
      }
    end.
  end.

  describe("each").
    it("yields to the delegate with each item as the argument", "test_each").
      function test_each {
        // List
        local yielded is list().
        function yield { parameter i. yielded:add(i). }
        Enum["each"](list(2,4,7), yield@).
        assert_equal(yielded[0], 2).
        assert_equal(yielded[1], 4).
        assert_equal(yielded[2], 7).

        // Queue
        local yielded is list().
        function yield { parameter i. yielded:add(i). }
        Enum["each"](queue(2,4,7), yield@).
        assert_equal(yielded[0], 2).
        assert_equal(yielded[1], 4).
        assert_equal(yielded[2], 7).

        // Stack
        local yielded is list().
        function yield { parameter i. yielded:add(i). }
        Enum["each"](stack(2,4,7), yield@).
        assert_equal(yielded[0], 7).
        assert_equal(yielded[1], 4).
        assert_equal(yielded[2], 2).
      }
    end.
  end.

  describe("each_slice").
    it("yields to the delegate with a collection of the correct size", "test_enum_each_slice").
      function test_enum_each_slice {
        // List
        local yielded is list().
        function yield { parameter i. yielded:add(i). }
        Enum["each_slice"](list(1,2,3,4,5), 2, yield@).
        assert_equal(yielded[0][0], 1).
        assert_equal(yielded[0][1], 2).
        assert_equal(yielded[1][0], 3).
        assert_equal(yielded[1][1], 4).
        assert_equal(yielded[2][0], 5).

        // Queue
        local yielded is list().
        function yield { parameter i. yielded:add(i). }
        Enum["each_slice"](queue(1,2,3,4,5), 2, yield@).
        assert_equal(yielded[0]:pop(), 1).
        assert_equal(yielded[0]:pop(), 2).
        assert_equal(yielded[1]:pop(), 3).
        assert_equal(yielded[1]:pop(), 4).
        assert_equal(yielded[2]:pop(), 5).

        // Stack
        local yielded is list().
        function yield { parameter i. yielded:add(i). }
        Enum["each_slice"](stack(5,4,3,2,1), 2, yield@).
        assert_equal(yielded[0]:pop(), 1).
        assert_equal(yielded[0]:pop(), 2).
        assert_equal(yielded[1]:pop(), 3).
        assert_equal(yielded[1]:pop(), 4).
        assert_equal(yielded[2]:pop(), 5).
      }
    end.
  end.

  describe("each_with_index").
    it("yields to the delegate with each item and index as argument", "test_each_with_index").
      function test_each_with_index {
        // List
        local yielded is list().
        function yield { parameter s, i. yielded:add(i + ": " + s). }
        Enum["each_with_index"](list("foo","bar","baz"), yield@).
        assert_equal(yielded[0], "1: foo").
        assert_equal(yielded[1], "2: bar").
        assert_equal(yielded[2], "3: baz").

        // Queue
        local yielded is list().
        function yield { parameter s, i. yielded:add(i + ": " + s). }
        Enum["each_with_index"](queue("foo","bar","baz"), yield@).
        assert_equal(yielded[0], "1: foo").
        assert_equal(yielded[1], "2: bar").
        assert_equal(yielded[2], "3: baz").

        // Stack
        local yielded is list().
        function yield { parameter s, i. yielded:add(i + ": " + s). }
        Enum["each_with_index"](stack("baz","bar","foo"), yield@).
        assert_equal(yielded[0], "1: foo").
        assert_equal(yielded[1], "2: bar").
        assert_equal(yielded[2], "3: baz").
      }
    end.
  end.

  describe("find").
    it("returns the first element which matches the delegate", "test_find").
      function test_find {
        assert_equal(Enum["find"](list(1,2,3), is_even@), 2).
        assert_equal(Enum["find"](queue(1,2,3), is_even@), 2).
        assert_equal(Enum["find"](stack(1,2,3), is_even@), 2).
      }
    end.
  end.

  describe("find_index").
    context("when no such element exists").
      it("returns -1", "test_find_index_fail").
        function test_find_index_fail {
          assert_equal(Enum["find_index"](list(1,3,5), is_even@), -1).
          assert_equal(Enum["find_index"](queue(1,3,5), is_even@), -1).
          assert_equal(Enum["find_index"](stack(1,3,5), is_even@), -1).
        }
      end.
    end.

    context("when the element exists").
      it("returns the index", "test_find_index_match").
        function test_find_index_match {
          assert_equal(Enum["find_index"](list(1,3,4), is_even@), 2).
          assert_equal(Enum["find_index"](queue(1,3,4), is_even@), 2).
          assert_equal(Enum["find_index"](stack(4,3,1), is_even@), 2).
        }
      end.
    end.
  end.

  describe("group_by").
    it("partitions the elements by the delegate return value", "test_group_by").
      function test_group_by {
        function even_or_odd { parameter n. if mod(n,2) = 0 return "even". return "odd". }

        // List
        local result is Enum["group_by"](list(1,2,3,4,5), even_or_odd@).
        assert_equal(result["even"][0], 2).
        assert_equal(result["even"][1], 4).
        assert_equal(result["odd"][0], 1).
        assert_equal(result["odd"][1], 3).
        assert_equal(result["odd"][2], 5).

        // Queue
        local result is Enum["group_by"](queue(1,2,3,4,5), even_or_odd@).
        assert_equal(result["even"]:pop(), 2).
        assert_equal(result["even"]:pop(), 4).
        assert_equal(result["odd"]:pop(), 1).
        assert_equal(result["odd"]:pop(), 3).
        assert_equal(result["odd"]:pop(), 5).

        // Stack
        local result is Enum["group_by"](stack(5,4,3,2,1), even_or_odd@).
        assert_equal(result["even"]:pop(), 2).
        assert_equal(result["even"]:pop(), 4).
        assert_equal(result["odd"]:pop(), 1).
        assert_equal(result["odd"]:pop(), 3).
        assert_equal(result["odd"]:pop(), 5).
      }
    end.
  end.

  describe("map").
    it("returns a transformed enumerable", "test_map").
      function test_map {
        // List
        local result is Enum["map"](list(1,2,3), is_even@).
        assert_equal(result:dump:split(" ")[0], "LIST").
        assert_equal(result[0], false).
        assert_equal(result[1], true).
        assert_equal(result[2], false).

        // Queue
        local result is Enum["map"](queue(1,2,3), is_even@).
        assert_equal(result:dump:split(" ")[0], "QUEUE").
        assert_equal(result:pop(), false).
        assert_equal(result:pop(), true).
        assert_equal(result:pop(), false).

        // Stack
        local result is Enum["map"](stack(3,2,1), is_even@).
        assert_equal(result:dump:split(" ")[0], "STACK").
        assert_equal(result:pop(), false).
        assert_equal(result:pop(), true).
        assert_equal(result:pop(), false).
      }
    end.
  end.

  describe("map_with_index").
    it("returns a transformed enumerable", "test_map_with_index").
      function test_map_with_index {
        function enumerate { parameter s, i. return i + ": " + s. }

        // List
        local result is Enum["map_with_index"](list("foo","bar","baz"), enumerate@).
        assert_equal(result:dump:split(" ")[0], "LIST").
        assert_equal(result[0], "1: foo").
        assert_equal(result[1], "2: bar").
        assert_equal(result[2], "3: baz").

        // Queue
        local result is Enum["map_with_index"](queue("foo","bar","baz"), enumerate@).
        assert_equal(result:dump:split(" ")[0], "QUEUE").
        assert_equal(result:pop(), "1: foo").
        assert_equal(result:pop(), "2: bar").
        assert_equal(result:pop(), "3: baz").

        // Stack
        local result is Enum["map_with_index"](stack("baz","bar","foo"), enumerate@).
        assert_equal(result:dump:split(" ")[0], "STACK").
        assert_equal(result:pop(), "1: foo").
        assert_equal(result:pop(), "2: bar").
        assert_equal(result:pop(), "3: baz").
      }
    end.
  end.

  describe("max").
    it("returns the largest value in the collection", "test_max").
      function test_max {
        assert_equal(Enum["max"](list(1,5,2)), 5).
        assert_equal(Enum["max"](queue(1,5,2)), 5).
        assert_equal(Enum["max"](stack(1,5,2)), 5).
      }
    end.
  end.

  describe("min").
    it("returns the smallest value in the collection", "test_min").
      function test_min {
        assert_equal(Enum["min"](list(3,5,2)), 2).
        assert_equal(Enum["min"](queue(3,5,2)), 2).
        assert_equal(Enum["min"](stack(3,5,2)), 2).
      }
    end.
  end.

  describe("partition").
    it("returns a passing and failing list", "test_partition").
      function test_partition {
        // List
        local result is Enum["partition"](list(1,2,3,4,5), is_even@).
        assert_equal(result[0]:dump:split(" ")[0], "LIST").
        assert_equal(result[1]:dump:split(" ")[0], "LIST").
        assert_equal(result[0][0], 2).
        assert_equal(result[0][1], 4).
        assert_equal(result[1][0], 1).
        assert_equal(result[1][1], 3).
        assert_equal(result[1][2], 5).

        // Queue
        local result is Enum["partition"](queue(1,2,3,4,5), is_even@).
        assert_equal(result[0]:dump:split(" ")[0], "QUEUE").
        assert_equal(result[1]:dump:split(" ")[0], "QUEUE").
        assert_equal(result[0]:pop(), 2).
        assert_equal(result[0]:pop(), 4).
        assert_equal(result[1]:pop(), 1).
        assert_equal(result[1]:pop(), 3).
        assert_equal(result[1]:pop(), 5).

        // Stack
        local result is Enum["partition"](stack(5,4,3,2,1), is_even@).
        assert_equal(result[0]:dump:split(" ")[0], "STACK").
        assert_equal(result[1]:dump:split(" ")[0], "STACK").
        assert_equal(result[0]:pop(), 2).
        assert_equal(result[0]:pop(), 4).
        assert_equal(result[1]:pop(), 1).
        assert_equal(result[1]:pop(), 3).
        assert_equal(result[1]:pop(), 5).
      }
    end.
  end.

  describe("reduce").
    it("applied the reduction delegate to each pair and returns the result", "test_reduce").
      function test_reduce {
        function sum { parameter memo, i. return memo + i. }
        assert_equal(Enum["reduce"](list(1,2,3,4,5), 0, sum@), 15).
        assert_equal(Enum["reduce"](queue(1,2,3,4,5), 0, sum@), 15).
        assert_equal(Enum["reduce"](stack(5,4,3,2,1), 0, sum@), 15).
      }
    end.
  end.

  describe("reject").
    it("returns a collection of items which fail the delegate", "test_reject").
      function test_reject {
        // List
        local result is Enum["reject"](list(1,2,3,4,5), is_even@).
        assert_equal(result:dump:split(" ")[0], "LIST").
        assert_equal(result[0], 1).
        assert_equal(result[1], 3).
        assert_equal(result[2], 5).

        // Queue
        local result is Enum["reject"](queue(1,2,3,4,5), is_even@).
        assert_equal(result:dump:split(" ")[0], "QUEUE").
        assert_equal(result:pop(), 1).
        assert_equal(result:pop(), 3).
        assert_equal(result:pop(), 5).

        // Stack
        local result is Enum["reject"](stack(5,4,3,2,1), is_even@).
        assert_equal(result:dump:split(" ")[0], "STACK").
        assert_equal(result:pop(), 1).
        assert_equal(result:pop(), 3).
        assert_equal(result:pop(), 5).
      }
    end.
  end.

  describe("reverse").
    it("returns a reversed copy of the list", "test_reverse").
      function test_reverse {
        // List
        local result is Enum["reverse"](list(1,2,3)).
        assert_equal(result:dump:split(" ")[0], "LIST").
        assert_equal(result[0], 3).
        assert_equal(result[1], 2).
        assert_equal(result[2], 1).

        // Queue
        local result is Enum["reverse"](queue(1,2,3)).
        assert_equal(result:dump:split(" ")[0], "QUEUE").
        assert_equal(result:pop(), 3).
        assert_equal(result:pop(), 2).
        assert_equal(result:pop(), 1).

        // Stack
        local result is Enum["reverse"](stack(1,2,3)).
        assert_equal(result:dump:split(" ")[0], "STACK").
        assert_equal(result:pop(), 1).
        assert_equal(result:pop(), 2).
        assert_equal(result:pop(), 3).
      }
    end.
  end.

  describe("select").
    it("returns a list of items which pass the delegate", "test_select").
      function test_select {
        // List
        local result is Enum["select"](list(1,2,3,4,5), is_even@).
        assert_equal(result:dump:split(" ")[0], "LIST").
        assert_equal(result[0], 2).
        assert_equal(result[1], 4).

        // Queue
        local result is Enum["select"](queue(1,2,3,4,5), is_even@).
        assert_equal(result:dump:split(" ")[0], "QUEUE").
        assert_equal(result:pop(), 2).
        assert_equal(result:pop(), 4).

        // Stack
        local result is Enum["select"](stack(5,4,3,2,1), is_even@).
        assert_equal(result:dump:split(" ")[0], "STACK").
        assert_equal(result:pop(), 2).
        assert_equal(result:pop(), 4).
      }
    end.
  end.

  describe("sort").
    it("returns a sorted list", "test_sort").
      function test_sort {

        function str_len_comp_desc { parameter a, b. return b:length - a:length. }
        function str_len_comp_asc  { parameter a, b. return a:length - b:length. }

        // List
        local collection is list("foobar", "foo", "foobarbaz").
        local sorted_desc is Enum["sort"](collection, str_len_comp_desc@).
        local sorted_asc  is Enum["sort"](collection, str_len_comp_asc@).

        assert_equal(sorted_desc:dump:split(" ")[0], "LIST").
        assert_equal(sorted_asc:dump:split(" ")[0], "LIST").

        assert_equal(sorted_desc[0], "foobarbaz").
        assert_equal(sorted_desc[1], "foobar").
        assert_equal(sorted_desc[2], "foo").

        assert_equal(sorted_asc[0], "foo").
        assert_equal(sorted_asc[1], "foobar").
        assert_equal(sorted_asc[2], "foobarbaz").

        // Queue
        local collection is queue("foobar", "foo", "foobarbaz").
        local sorted_desc is Enum["sort"](collection, str_len_comp_desc@).
        local sorted_asc  is Enum["sort"](collection, str_len_comp_asc@).

        assert_equal(sorted_desc:dump:split(" ")[0], "QUEUE").
        assert_equal(sorted_asc:dump:split(" ")[0], "QUEUE").

        assert_equal(sorted_desc:pop(), "foobarbaz").
        assert_equal(sorted_desc:pop(), "foobar").
        assert_equal(sorted_desc:pop(), "foo").

        assert_equal(sorted_asc:pop(), "foo").
        assert_equal(sorted_asc:pop(), "foobar").
        assert_equal(sorted_asc:pop(), "foobarbaz").

        // Stack
        local collection is stack("foobarbaz", "foo", "foobar").
        local sorted_desc is Enum["sort"](collection, str_len_comp_desc@).
        local sorted_asc  is Enum["sort"](collection, str_len_comp_asc@).

        assert_equal(sorted_desc:dump:split(" ")[0], "STACK").
        assert_equal(sorted_asc:dump:split(" ")[0], "STACK").

        assert_equal(sorted_desc:pop(), "foobarbaz").
        assert_equal(sorted_desc:pop(), "foobar").
        assert_equal(sorted_desc:pop(), "foo").

        assert_equal(sorted_asc:pop(), "foo").
        assert_equal(sorted_asc:pop(), "foobar").
        assert_equal(sorted_asc:pop(), "foobarbaz").
      }
    end.
  end.

end.
