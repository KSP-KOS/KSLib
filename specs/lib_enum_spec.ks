// Note: This requires KSpec - see https://github.com/gisikw/kspec

describe("lib_enum").
  RUN lib_enum.
  function is_even { parameter n. return mod(n,2) = 0. }

  describe("enum_all").
    it("accepts two arguments", "test_enum_all_args").
      function test_enum_all_args {
        enum_all(list(), false). assert(true).
      }
    end.

    context("when all elements meet the assertion").
      it("returns true", "test_enum_all_pass").
        function test_enum_all_pass {
          assert(enum_all(list(2, 4, 6), is_even@)).
        }
      end.
    end.

    context("when an element fails the assertion").
      it("returns false", "test_enum_all_fail").
        function test_enum_all_fail {
          assert(enum_all(list(2, 4, 7), is_even@) = false).
        }
      end.
    end.
  end.

  describe("enum_any").
    it("accepts two arguments", "test_enum_any_args").
      function test_enum_any_args {
        enum_any(list(), false). assert(true).
      }
    end.

    context("when no elements meet the assertion").
      it("returns false", "test_enum_any_fail").
        function test_enum_any_fail {
          assert(enum_any(list(3, 5, 7), is_even@) = false).
        }
      end.
    end.

    context("when any element passes the assertion").
      it("returns true", "test_enum_any_pass").
        function test_enum_any_pass {
          assert(enum_any(list(3, 5, 6), is_even@)).
        }
      end.
    end.
  end.

  describe("enum_count").
    it("accepts two arguments", "test_enum_count_args").
      function test_enum_count_args {
        enum_count(list(), false). assert(true).
      }
    end.

    it("returns the number of elements that match the condition", "test_enum_count").
      function test_enum_count {
        assert_equal(enum_count(list(1,2,3,4,5), is_even@), 2).
      }
    end.
  end.

  describe("enum_each").
    it("accepts two arguments", "test_enum_each_args").
      function test_enum_each_args {
        enum_each(list(), false). assert(true).
      }
    end.

    it("calls the delegate with each element", "test_enum_each").
      function test_enum_each {
        local yielded is list().
        function add_to_yielded { parameter i. yielded:add(i). }
        enum_each(list(1,2,3), add_to_yielded@).
        assert_equal(yielded[0], 1).
        assert_equal(yielded[1], 2).
        assert_equal(yielded[2], 3).
      }
    end.
  end.

  describe("enum_each_slice").
    it("accepts three arguments", "test_enum_each_slice_args").
      function test_enum_each_slice_args {
        enum_each_slice(list(), 2, false). assert(true).
      }
    end.

    it("calls the delegate with a list of the correct size", "test_enum_each_slice").
      function test_enum_each_slice {
        local yielded is list().
        function add_to_yielded { parameter i. yielded:add(i). }
        enum_each_slice(list(1,2,3,4,5), 2, add_to_yielded@).
        assert_equal(yielded[0][0], 1).
        assert_equal(yielded[0][1], 2).
        assert_equal(yielded[1][0], 3).
        assert_equal(yielded[1][1], 4).
        assert_equal(yielded[2][0], 5).
      }
    end.
  end.

  describe("enum_each_with_index").
    it("accepts two arguments", "test_enum_each_with_index_args").
      function test_enum_each_with_index_args {
        enum_each_with_index(list(), false). assert(true).
      }
    end.

    it("calls the delegate with each element and index", "test_enum_each_with_index").
      function test_enum_each_with_index {
        local yielded is list().
        function add_with_index { parameter s, i. yielded:add(i + ": " + s). }
        enum_each_with_index(list("foo","bar","baz"), add_with_index@).
        assert_equal(yielded[0], "1: foo").
        assert_equal(yielded[1], "2: bar").
        assert_equal(yielded[2], "3: baz").
      }
    end.
  end.

  describe("enum_find").
    it("accepts two arguments", "test_enum_find_args").
      function test_enum_find_args {
        enum_find(list(), false). assert(true).
      }
    end.

    context("when no such element exists").
      it("returns false", "test_enum_find_fail").
        function test_enum_find_fail {
          assert(enum_find(list(1,3,5), is_even@) = false).
        }
      end.
    end.

    context("when the element exists").
      it("returns the element", "test_enum_find_match").
        function test_enum_find_match {
          assert_equal(enum_find(list(1,3,4), is_even@), 4).
        }
      end.
    end.
  end.

  describe("enum_find_index").
    it("accepts two arguments", "test_enum_find_index_args").
      function test_enum_find_index_args {
        enum_find_index(list(), false). assert(true).
      }
    end.

    context("when no such element exists").
      it("returns -1", "test_enum_find_index_fail").
        function test_enum_find_index_fail {
          assert_equal(enum_find_index(list(1,3,5), is_even@), -1).
        }
      end.
    end.

    context("when the element exists").
      it("returns the index", "test_enum_find_index_match").
        function test_enum_find_index_match {
          assert_equal(enum_find_index(list(1,3,4), is_even@), 2).
        }
      end.
    end.
  end.

  describe("enum_group_by").
    it("accepts two arguments", "test_enum_group_by_args").
      function test_enum_group_by_args {
        enum_group_by(list(), false). assert(true).
      }
    end.

    it("returns a lexicon", "test_enum_group_by_lex").
      function test_enum_group_by_lex {
        assert(list(enum_group_by(list(), false)):dump:substring(25,7) = "LEXICON").
      }
    end.

    it("sorts the elements by the operation return value", "test_enum_group_by").
      function test_enum_group_by {
        function even_or_odd { parameter n. if mod(n,2) = 0 return "even". return "odd". }
        local result is enum_group_by(list(1,2,3,4,5), even_or_odd@).
        assert_equal(result["even"][0], 2).
        assert_equal(result["even"][1], 4).
        assert_equal(result["odd"][0], 1).
        assert_equal(result["odd"][1], 3).
        assert_equal(result["odd"][2], 5).
      }
    end.
  end.

  describe("enum_map").
    it("accepts two arguments", "test_enum_map_args").
      function test_enum_map_args {
        enum_map(list(), false). assert(true).
      }
    end.

    it("returns a transformed list", "test_enum_map").
      function test_enum_map {
        local result is enum_map(list(1,2,3), is_even@).
        assert_equal(result[0], false).
        assert_equal(result[1], true).
        assert_equal(result[2], false).
      }
    end.
  end.

  describe("enum_map_with_index").
    it("accepts two arguments", "test_enum_map_with_index_args").
      function test_enum_map_with_index_args {
        enum_map_with_index(list(), false). assert(true).
      }
    end.

    it("returns a transformed list", "test_enum_map_with_index").
      function test_enum_map_with_index {
        function enumerate { parameter s, i. return i + ": " + s. }
        local result is enum_map_with_index(list("foo","bar","baz"), enumerate@).
        assert_equal(result[0], "1: foo").
        assert_equal(result[1], "2: bar").
        assert_equal(result[2], "3: baz").
      }
    end.
  end.

  describe("enum_max").
    it("accepts one argument", "test_enum_max_args").
      function test_enum_max_args {
        enum_max(list()). assert(true).
      }
    end.

    it("returns the largest value in the list", "test_enum_max").
      function test_enum_max {
        assert_equal(enum_max(list(1,5,2)), 5).
      }
    end.
  end.

  describe("enum_min").
    it("accepts one argument", "test_enum_min_args").
      function test_enum_min_args {
        enum_min(list()). assert(true).
      }
    end.

    it("returns the smallest value in the list", "test_enum_min").
      function test_enum_min {
        assert_equal(enum_min(list(1,5,2)), 1).
      }
    end.
  end.

  describe("enum_partition").
    it("accepts two arguments", "test_enum_partition_args").
      function test_enum_partition_args {
        enum_partition(list(), false). assert(true).
      }
    end.

    it("returns a passing and failing list", "test_enum_partition").
      function test_enum_partition {
        local result is enum_partition(list(1,2,3,4,5), is_even@).
        assert_equal(result[0][0], 2).
        assert_equal(result[0][1], 4).
        assert_equal(result[1][0], 1).
        assert_equal(result[1][1], 3).
        assert_equal(result[1][2], 5).
      }
    end.
  end.

  describe("enum_reduce").
    it("accepts three arguments", "test_enum_reduce_args").
      function test_enum_reduce_args {
        enum_reduce(list(), 2, false). assert(true).
      }
    end.

    it("applies the reduction function to each pair and returns the result", "test_enum_reduce").
      function test_enum_reduce {
        function sum { parameter memo, i. return memo + i. }
        assert_equal(enum_reduce(list(1,2,3,4,5), 0, sum@), 15).
      }
    end.
  end.

  describe("enum_reject").
    it("accepts two arguments", "test_enum_reject_args").
      function test_enum_reject_args {
        enum_reject(list(), false). assert(true).
      }
    end.

    it("returns a list of elements which fail the delegate", "test_enum_reject").
      function test_enum_reject {
        local result is enum_reject(list(1,2,3,4,5), is_even@).
        assert_equal(result[0], 1).
        assert_equal(result[1], 3).
        assert_equal(result[2], 5).
      }
    end.
  end.

  describe("enum_reverse").
    it("accepts one argument", "test_enum_reverse_args").
      function test_enum_reverse_args {
        enum_reverse(list()). assert(true).
      }
    end.

    it("returns a reversed copy of the list", "test_enum_reverse").
      function test_enum_reverse {
        local result is enum_reverse(list(1,2,3)).
        assert_equal(result[0], 3).
        assert_equal(result[1], 2).
        assert_equal(result[2], 1).
      }
    end.
  end.

  describe("enum_select").
    it("accepts two arguments", "test_enum_select_args").
      function test_enum_select_args {
        enum_select(list(), false). assert(true).
      }
    end.

    it("returns a list of elements which pass the delegate", "test_enum_select").
      function test_enum_select {
        local result is enum_select(list(1,2,3,4,5), is_even@).
        assert_equal(result[0], 2).
        assert_equal(result[1], 4).
      }
    end.
  end.

  describe("enum_sort").

    function identity {
      parameter a, b. return a - b.
    }

    it("accepts two arguments", "enum_sort_arg_test").
      function enum_sort_arg_test {
        enum_sort(list(), false). assert(true).
      }
    end.

    it("returns a new list", "enum_sort_nonmutate").
      function enum_sort_nonmutate {
        local start is list(2,3,1).
        local sorted is enum_sort(start, identity@).
        assert_equal(start[0], 2).
        assert_equal(start[1], 3).
        assert_equal(start[2], 1).
        assert(start <> sorted).
      }
    end.

    it("sorts according to an arbitrary delegate", "enum_sort_arbitrary").
      function enum_sort_arbitrary {
        local sorted is enum_sort(list(2,3,1), identity@).
        assert_equal(sorted[0], 1).
        assert_equal(sorted[1], 2).
        assert_equal(sorted[2], 3).
      }
    end.

    it("allows sorting on complex conditions", "enum_sort_complex").
      function enum_sort_complex {
        local start is list("foo", "foobar", "foobarbaz").
        function str_len_comp_desc { parameter a, b. return b:length - a:length. }
        function str_len_comp_asc  { parameter a, b. return a:length - b:length. }

        local sorted_desc is enum_sort(start, str_len_comp_desc@).
        local sorted_asc  is enum_sort(start, str_len_comp_asc@).

        assert_equal(sorted_desc[0], "foobarbaz").
        assert_equal(sorted_desc[1], "foobar").
        assert_equal(sorted_desc[2], "foo").

        assert_equal(sorted_asc[0], "foo").
        assert_equal(sorted_asc[1], "foobar").
        assert_equal(sorted_asc[2], "foobarbaz").
      }
    end.

  end.
end.
