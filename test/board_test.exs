defmodule BoardTest do
  use ExUnit.Case

  test "board creation" do
		state = Board.new_game(:hnefatafl)
		assert(state[:variant] == :hnefatafl)
  end

	test "valid movements" do
		state = Board.new_game(:hnefatafl)
		assert({:ok} == Board.can_move(state, [3, 0], [3, 1]))
		assert({:ok} == Board.can_move(state, [0, 3], [1, 3]))
	end

	test "invalid movements" do
		state = Board.new_game(:hnefatafl)
		assert({:error, :invalid_piece} = Board.can_move(state, [5, 3], [5, 2]))
		assert({:error, :invalid_move} = Board.can_move(state, [0, 0], [-1, -1]))
		assert({:error, :invalid_move} = Board.can_move(state, [0, 0], [11, 0]))
		assert({:error, :invalid_move} = Board.can_move(state, [0, 0], [0, 11]))
		assert({:error, :blocked} = Board.can_move(state, [5, 0], [5, 2]))
		assert({:error, :blocked} = Board.can_move(state, [10, 5], [8, 5]))
		assert({:error, :king_only} = Board.can_move(state, [3, 0], [0, 0]))
		assert({:error, :king_only} = Board.can_move(state, [7, 10], [10, 10]))
	end

	test "valid move actions" do
		state = Board.new_game(:hnefatafl)
		assert(state[:turn] == :a)
		{:ok, state} = Board.move(state, [3, 0], [3, 1])
		assert(Board.piece(state, [3, 0]) == 0)
		assert(Board.piece(state, [3, 1]) == :a)
		assert(state[:turn] == :d)
	end
		
	test "capture" do
		state = Board.new_game(:hnefatafl)
		{:ok, state} = Board.move(state, [3, 0], [3, 4])
		{:ok, state} = Board.move(state, [5, 3], [3, 3])
		assert(Board.piece(state, [3, 4]) == 0)
		assert(state[:attackers] == 23)
		{:ok, state} = Board.move(state, [4, 0], [4, 3])
		{:ok, state} = Board.move(state, [5, 7], [6, 7])
		{:ok, state} = Board.move(state, [0, 3], [2, 3])
		assert(Board.piece(state, [3, 3]) == 0)
		assert(state[:defenders] == 12)
	end

end
