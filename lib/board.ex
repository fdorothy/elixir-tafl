import Math
defmodule Board do
  """
  pieces explanation:
   :a - attacker, captures the king
   :d - defender, escorts the king to the corner
   :k - the king
  tile explanation:
   :x - corner tile, where the king escapes
   :t - throne tile, only the king may end his turn here
  """
  def new_game(variant) do
    case variant do
      :hnefatafl ->
        [ pieces: {{  0,  0,  0, :a, :a, :a, :a, :a,  0,  0,  0 },
                   {  0,  0,  0,  0,  0, :a,  0,  0,  0,  0,  0 },
                   {  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },
                   { :a,  0,  0,  0,  0, :d,  0,  0,  0,  0, :a },
                   { :a,  0,  0,  0, :d, :d, :d,  0,  0,  0, :a },
                   { :a, :a,  0, :d, :d, :k, :d, :d,  0, :a, :a },
                   { :a,  0,  0,  0, :d, :d, :d,  0,  0,  0, :a },
                   { :a,  0,  0,  0,  0, :d,  0,  0,  0,  0, :a },
                   {  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0 },
                   {  0,  0,  0,  0,  0, :a,  0,  0,  0,  0,  0 },
                   {  0,  0,  0, :a, :a, :a, :a, :a,  0,  0,  0 }},
          history: [],
          turn: :a,
          variant: variant,
          width: 11,
          height: 11,
          king: [5, 5],
          attackers: 24,
          defenders: 13
        ]
    end
  end

  def piece(state, [x, y]) do
    if on_board?(state, [x, y]), do: state[:pieces] |> elem(y) |> elem(x), else: 0
  end

  def tile(state, [x, y]) do
    cond do
      (x == 0 or x == state[:width]-1) and (y == 0 or y == state[:height]-1) -> :x
      x == state[:width]/2 && y == state[:height]/2 -> :t
      true -> 0
    end
  end

  def owner(state, pt) do owner(piece(state, pt)) end
  def owner(piece) do
    if piece == :k, do: :d, else: piece
  end

  def can_move(state, src, dst) do
    cond do
      not valid_move_direction?(state, src, dst) -> {:error, :invalid_move}
      owner(state, src) != state[:turn] -> {:error, :invalid_piece}
      path_blocked?(state, src, dst) -> {:error, :blocked}
      (piece(state, src) != :k) and [:x,:t] |> Enum.any?(&(&1==tile(state, dst))) -> {:error, :king_only}
      true -> {:ok}
    end
  end

  def move(state, src, dst) do
    case can_move(state, src, dst) do
      {:ok} ->
        p = piece(state, src)
        if p == :k, do: state = Keyword.put(state, :king, dst)
        {:ok, (put_piece(state, dst, p)
               |> put_piece(src, 0)
               |> remove_captured_pieces(dst)
               |> Keyword.put(:turn, (if owner(p) == :a, do: :d, else: :a)))}
      {:error, err_type} -> {:error, err_type}
    end
  end

  defp put_piece(state, [x, y], p) do
    Keyword.put(state, :pieces, put_elem(state[:pieces], y, elem(state[:pieces], y) |> put_elem(x, p)))
  end

  def remove_captured_pieces(state, pt) do
    captured = ([ [add(pt, [-1, 0]), add(pt, [-2, 0])],
                  [add(pt, [ 1, 0]), add(pt, [ 2, 0])],
                  [add(pt, [ 0, 1]), add(pt, [ 0, 2])],
                  [add(pt, [ 0,-1]), add(pt, [ 0,-2])] ]
                |> Enum.filter(&captured?(state, &1)))
    state = Enum.reduce(captured, state, fn([p1, _], acc) -> put_piece(acc, p1, 0) end)
    side = if state[:turn] == :a, do: :defenders, else: :attackers
           Keyword.put(state, side, state[side] - length(captured))
  end

  def path_blocked?(state, src, dst) do
    dir(src, dst) |> add(src) |> any?(dst, &(piece(state, &1) != 0))
  end

  def any?(dst, dst, fun) do fun.(dst) end
  def any?(src, dst, fun) do
    if fun.(src), do: true, else: any?(add(src, dir(src,dst)), dst, fun)
  end

  def win?(state) do
    cond do
      tile(state, state[:king]) == :x -> {:win, :d}
      state[:attackers] == 0 -> {:win, :d}
      state[:defenders] == 0 -> {:win, :a}
      king_surrounded?(state) -> {:win, :d}
      true -> false
    end
  end

  def captured?(state, [p1, p2]) do
    ally?(state, p2) && (state[:turn] == :a && piece(state, p1) == :d) || (state[:turn] == :d && piece(state, p1) == :a)
  end

  def ally?(state, pt) do
    tile(state, pt) == :x || owner(piece(state, pt)) == state[:turn]
  end

  def king_surrounded?(state) do
    foes = ([[-1,0], [1,0], [0,-1], [0,1]] |> Enum.map(&add(&1, state[:king]))
            |> Enum.map(&(piece(state, &1) == :d || tile(state, &1) == :x)).count)
    foes == 4 || (on_edge?(state, state[:king]) && foes == 3)
  end

  def on_edge?(state, [x, y]) do
    x == 0 || y == 0 || x == state[:width]-1 || y == state[:height]-1
  end

  def on_board?(state, [x, y]) do
    x >= 0 and y >= 0 and x < state[:width] and y < state[:height]
  end

  def valid_move_direction?(state, [x1, y1], [x2, y2]) do
    xor(x1 == x2, y1 == y2) and on_board?(state, [x1, y1]) and on_board?(state, [x2, y2])
  end
end
