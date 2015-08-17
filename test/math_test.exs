import Math

defmodule MathTest do
  use ExUnit.Case

  test "add" do
		assert(add([1, 2, 3], [4, 5, 6]) == [5, 7, 9])
  end

	test "sub" do
		assert(sub([3, 4], [1, -1]) == [2, 5])
	end

	test "neg" do
		assert(neg([3, 4]) == [-3, -4])
	end

	test "clamp" do
		assert(clamp(5, 2, 3) == 3)
		assert(clamp(1, 2, 3) == 2)
		assert(clamp(2, 2, 3) == 2)
	end

	test "dir" do
		assert(dir([3, 4], [3, 4]) == [0, 0])
		assert(dir([3, 4], [5, 4]) == [1, 0])
		assert(dir([10, 2], [8, 2]) == [-1, 0])
		assert(dir([-5, -3], [-5, -1]) == [0, 1])
		assert(dir([6, 7], [6, 5]) == [0, -1])
	end

	test "xor" do
		assert(xor(true, true) == false)
		assert(xor(false, true) == true)
		assert(xor(true, false) == true)
		assert(xor(false, false) == false)
	end

end
